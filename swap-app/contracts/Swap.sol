// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@zetachain/toolkit/contracts/SwapHelperLib.sol";
import "@zetachain/toolkit/contracts/BytesHelperLib.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";

/**
 * @title Swap Cpntract 
 */
contract Swap is zContract, OnlySystem {
    SystemContract public systemContract;
    uint256 constant BITCOIN = 18332;

    struct Params {
        address target;
        bytes to;
    }

    /**
     * コンストラクター
     */
    constructor(address systemContractAddress) {
        systemContract = SystemContract(systemContractAddress);
    }

    /**
     * onCrossChainCall メソッド
     */
    function onCrossChainCall(
        zContext calldata context,
        address zrc20,
        uint256 amount,
        bytes calldata message
    ) external virtual override onlySystem(systemContract) {
        // param型の変数を定義
        Params memory params = Params({
            target: address(0), 
            to: bytes("")
        });
 
        if (context.chainID == BITCOIN) {
            params.target = BytesHelperLib.bytesToAddress(message, 0);
            params.to = abi.encodePacked(
                BytesHelperLib.bytesToAddress(message, 20)
            );
        } else {
            (
                address targetToken, 
                bytes memory recipient
            ) = abi.decode(
                message,
                (address, bytes)
            );
            params.target = targetToken;
            params.to = recipient;
        }
 
        (address gasZRC20, uint256 gasFee) = IZRC20(params.target)
            .withdrawGasFee();

        // ガス代を算出
        uint256 inputForGas = SwapHelperLib.swapTokensForExactTokens(
            systemContract,
            zrc20,
            gasFee,
            gasZRC20,
            amount
        );
        // ガス代を引いた残りをスワップ
        uint256 outputAmount = SwapHelperLib.swapExactTokensForTokens(
            systemContract,
            zrc20,
            amount - inputForGas,
            params.target,
            0
        );
        // approve & withdraw
        IZRC20(gasZRC20).approve(params.target, gasFee);
        IZRC20(params.target).withdraw(params.to, outputAmount);
    }
}
