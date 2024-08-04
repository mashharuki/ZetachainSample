// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@zetachain/toolkit/contracts/BytesHelperLib.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";

/**
 * Staking Contract
 */
contract Staking is ERC20, zContract, OnlySystem {
  SystemContract public systemContract;
  uint256 public immutable chainID;
  uint256 constant BITCOIN = 18332;

  uint256 public rewardRate = 1;

  // カスタムエラー
  error WrongChain(uint256 chainID);
  error UnknownAction(uint8 action);
  error Overflow();
  error Underflow();
  error WrongAmount();
  error NotAuthorized();
  error NoRewardsToClaim();

  mapping(bytes => uint256) public stakes;
  mapping(bytes => address) public beneficiary;
  mapping(bytes => uint256) public lastStakeTime;

  /**
   * コンストラクター
   */
  constructor(
    string memory name_,
    string memory symbol_,
    uint256 chainID_,
    address systemContractAddress
  ) ERC20(name_, symbol_) {
    systemContract = SystemContract(systemContractAddress);
    chainID = chainID_;
  }

  function onCrossChainCall(
    zContext calldata context,
    address zrc20,
    uint256 amount,
    bytes calldata message
  ) external virtual override onlySystem(systemContract) {
    if (chainID != context.chainID) {
      revert WrongChain(context.chainID);
    }

    uint8 action = chainID == BITCOIN
      ? uint8(message[0])
      : abi.decode(message, (uint8));

    if (action == 1) {
      // stake ZRC-20 tokens
      stake(context.origin, amount, message);
    } else if (action == 2) {
      // unstake ZRC-20 tokens
      unstake(context.origin);
    } else if (action == 3) {
      // update beneficiary address
      updateBeneficiary(context.origin, message);
    } else {
      revert UnknownAction(action);
    }
  }

  /**
   * updateBeneficiary method
   */
  function updateBeneficiary(
    bytes memory staker,
    bytes calldata message
  ) internal {
    address beneficiaryAddress;
    if (chainID == BITCOIN) {
      beneficiaryAddress = BytesHelperLib.bytesToAddress(message, 1);
    } else {
      (, beneficiaryAddress) = abi.decode(message, (uint8, address));
    }
    beneficiary[staker] = beneficiaryAddress;
  }

  /**
   * stake method
   */
  function stake(
    bytes memory staker,
    uint256 amount,
    bytes calldata message
  ) internal {
    // call updateBeneficiary method
    updateBeneficiary(staker, message);

    stakes[staker] += amount;
    if (stakes[staker] < amount) revert Overflow();
    // call updateRewards method
    updateRewards(staker);
  }

  /**
   * unstake method
   */
  function unstake(bytes memory staker) internal {
    uint256 amount = stakes[staker];
    // call updateRewards method
    updateRewards(staker);

    address zrc20 = systemContract.gasCoinZRC20ByChainId(chainID);
    (, uint256 gasFee) = IZRC20(zrc20).withdrawGasFee();

    if (amount < gasFee) revert WrongAmount();

    stakes[staker] = 0;

    IZRC20(zrc20).approve(zrc20, gasFee);
    IZRC20(zrc20).withdraw(staker, amount - gasFee);

    if (stakes[staker] > amount) revert Underflow();

    lastStakeTime[staker] = block.timestamp;
  }

  /**
   * updateRewards method
   */
  function updateRewards(bytes memory staker) internal {
    if (lastStakeTime[staker] == 0) lastStakeTime[staker] = block.timestamp;
    // call queryRewards method
    uint256 rewardAmount = queryRewards(staker);
    // mint reward tokens
    _mint(beneficiary[staker], rewardAmount);
    lastStakeTime[staker] = block.timestamp;
  }

  /**
   * queryRewards method
   */
  function queryRewards(bytes memory staker) public view returns (uint256) {
    uint256 timeDifference = block.timestamp - lastStakeTime[staker];
    // caluculate reward amount
    uint256 rewardAmount = timeDifference * stakes[staker] * rewardRate;
    return rewardAmount;
  }

  /**
   * claimRewards method
   */
  function claimRewards(bytes memory staker) external {
    if (beneficiary[staker] != msg.sender) revert NotAuthorized();
    // call queryRewards method
    uint256 rewardAmount = queryRewards(staker);
    if (rewardAmount <= 0) revert NoRewardsToClaim();
    // updateRewards method
    updateRewards(staker);
  }
}
