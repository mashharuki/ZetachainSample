// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
 
import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@zetachain/toolkit/contracts/SwapHelperLib.sol";
import "@zetachain/toolkit/contracts/BytesHelperLib.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/IWZETA.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
/**
 * SwapToAnyToken Cpntract 
 */
contract SwapToAnyToken is zContract, OnlySystem {

  SystemContract public systemContract;
 
  uint256 constant BITCOIN = 18332;

  struct Params {
    address target;
    bytes to;
    bool withdraw;
  }

  /**
   * コンストラクター
   */
  constructor(address systemContractAddress) {
    systemContract = SystemContract(systemContractAddress);
  }


  function onCrossChainCall(
    zContext calldata context,
    address zrc20,
    uint256 amount,
    bytes calldata message
  ) external virtual override onlySystem(systemContract) {
    // パラメーターを定義する。
    Params memory params = Params({
      target: address(0),
      to: bytes(""),
      withdraw: true
    });
 
    if (context.chainID == BITCOIN) {
      params.target = BytesHelperLib.bytesToAddress(message, 0);
      params.to = abi.encodePacked(
        BytesHelperLib.bytesToAddress(message, 20)
      );
      if (message.length >= 41) {
        params.withdraw = BytesHelperLib.bytesToBool(message, 40);
      }
    } else {
      (
        address targetToken,
        bytes memory recipient,
        bool withdrawFlag
      ) = abi.decode(message, (address, bytes, bool));
      params.target = targetToken;
      params.to = recipient;
      params.withdraw = withdrawFlag;
    }

    // swapAndWithdraw メソッドを呼び出す。
    swapAndWithdraw(
      zrc20,
      amount,
      params.target,
      params.to,
      params.withdraw
    );
  }

  /**
   * swap メソッド
   */
  function swap(
    address inputToken,
    uint256 amount,
    address targetToken,
    bytes memory recipient,
    bool withdraw
  ) public {
    // inputToken をこのコントラクトに移転する。
    IZRC20(inputToken).transferFrom(msg.sender, address(this), amount);
    // swapAndWithdraw メソッドを呼び出す。
    swapAndWithdraw(
      inputToken, 
      amount, 
      targetToken, 
      recipient, 
      withdraw
    );
  }

  /**
   * swapAndWithdraw メソッド
   */
  function swapAndWithdraw(
    address inputToken,
    uint256 amount,
    address targetToken,
    bytes memory recipient,
    bool withdraw
  ) internal {
    uint256 inputForGas;
    address gasZRC20;
    uint256 gasFee;

    // 引き出す場合
    if (withdraw) {
      (gasZRC20, gasFee) = IZRC20(targetToken).withdrawGasFee();

      inputForGas = SwapHelperLib.swapTokensForExactTokens(
        systemContract,
        inputToken,
        gasFee,
        gasZRC20,
        amount
      );
    }
 
    uint256 outputAmount = SwapHelperLib.swapExactTokensForTokens(
      systemContract,
      inputToken,
      withdraw ? amount - inputForGas : amount,
      targetToken,
      0
    );
 
    if (withdraw) {
      // 承認と引き出し
      IZRC20(gasZRC20).approve(targetToken, gasFee);
      IZRC20(targetToken).withdraw(recipient, outputAmount);
    } else {
      // ネイティブトークンの場合
      address wzeta = systemContract.wZetaContractAddress();
      if (targetToken == wzeta) {
        IWETH9(wzeta).withdraw(outputAmount);
        address payable recipientAddress = payable(
          address(uint160(bytes20(recipient)))
        );
        recipientAddress.transfer(outputAmount);
      } else {
        // トークンの場合
        address recipientAddress = address(uint160(bytes20(recipient)));
        IWETH9(targetToken).transfer(recipientAddress, outputAmount);
      }
    }
  }

  receive() external payable {}
}