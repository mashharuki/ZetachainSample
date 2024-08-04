import { parseEther } from "@ethersproject/units";
import { ethers } from "ethers";
import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const main = async (args: any, hre: HardhatRuntimeEnvironment) => {
  // get signer
  const [signer] = await hre.ethers.getSigners();

  /*
  if (!/zeta_(testnet|mainnet)/.test(hre.network.name)) {
    throw new Error('🚨 Please use either "zeta_testnet" or "zeta_mainnet".');
  }
  */

  // SwapToAnyToken コントラクトインスタンスを生成
  const factory = await hre.ethers.getContractFactory("SwapToAnyToken");
  const contract = factory.attach(args.contract);
  // 引数の値を取得する
  const amount = parseEther(args.amount);
  const inputToken = args.inputToken;
  const targetToken = args.targetToken;
  const recipient = ethers.utils.arrayify(args.recipient);
  const withdraw = JSON.parse(args.withdraw);
  // ERC20規格トークンのコントラクトインスタンスを生成
  const erc20Factory = await hre.ethers.getContractFactory("ERC20");
  const inputTokenContract = erc20Factory.attach(args.inputToken);
  // approve
  const approval = await inputTokenContract.approve(args.contract, amount);
  await approval.wait();
  // swapメソッドを実行
  const tx = await contract.swap(
    inputToken,
    amount,
    targetToken,
    recipient,
    withdraw
  );

  ////////////////////////////////////////////////////////////////////////
  // アイディア ここにintentの仕組みを混ぜられないか？？
  // まずはメタトランザクションでも良いと思う。
  ////////////////////////////////////////////////////////////////////////

  await tx.wait();
  console.log(`Transaction hash: ${tx.hash}`);
};

// swap タスク定義
task("interact", "Interact with the Swap contract from ZetaChain", main)
  .addFlag("json", "Output JSON")
  .addParam("contract", "Contract address")
  .addParam("amount", "Token amount to send")
  .addParam("inputToken", "Input token address")
  .addParam("targetToken", "Target token address")
  .addParam("recipient", "Recipient address")
  .addParam("withdraw", "Withdraw flag (true/false)")