// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@zetachain/toolkit/contracts/BytesHelperLib.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";

/**
 * NFT Contract
 */
contract NFT is zContract, ERC721, OnlySystem {
  SystemContract public systemContract;
  uint256 constant BITCOIN = 18332;
  uint256 private _nextTokenId;
  // カスタムエラー
  error CallerNotOwnerNotApproved();

  mapping(uint256 => uint256) public tokenAmounts;
  mapping(uint256 => uint256) public tokenChains;

  constructor(address systemContractAddress) ERC721("MyNFT", "MNFT") {
    systemContract = SystemContract(systemContractAddress);
    _nextTokenId = 0;
  }

  function onCrossChainCall(
    zContext calldata context,
    address zrc20,
    uint256 amount,
    bytes calldata message
  ) external override onlySystem(systemContract) {
    address recipient;

    if (context.chainID == BITCOIN) {
      recipient = BytesHelperLib.bytesToAddress(message, 0);
    } else {
      recipient = abi.decode(message, (address));
    }
    // NFTをミントする。(チェーンIDを指定する。)
    _mintNFT(recipient, context.chainID, amount);
  }

  /**
   * NFTをミントするメソッド
   */
  function _mintNFT(
    address recipient,
    uint256 chainId,
    uint256 amount
  ) private {
    uint256 tokenId = _nextTokenId;
    // _safeMintを使ってNFTをミントする。
    _safeMint(recipient, tokenId);
    tokenChains[tokenId] = chainId;
    tokenAmounts[tokenId] = amount;
    _nextTokenId++;
  }

  /**
   * NFTを償却するメソッド
   */
  function burnNFT(uint256 tokenId, bytes memory recipient) public {
    if (!_isApprovedOrOwner(_msgSender(), tokenId)) {
      revert CallerNotOwnerNotApproved();
    }
    address zrc20 = systemContract.gasCoinZRC20ByChainId(tokenChains[tokenId]);

    (, uint256 gasFee) = IZRC20(zrc20).withdrawGasFee();

    IZRC20(zrc20).approve(zrc20, gasFee);
    IZRC20(zrc20).withdraw(recipient, tokenAmounts[tokenId] - gasFee);
    // _burnメソッドを呼び出す
    _burn(tokenId);

    delete tokenAmounts[tokenId];
    delete tokenChains[tokenId];
  }
}
