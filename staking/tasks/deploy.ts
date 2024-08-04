import {getAddress, ParamChainName} from "@zetachain/protocol-contracts";
import ZRC20 from "@zetachain/protocol-contracts/abi/zevm/ZRC20.sol/ZRC20.json";
import {task} from "hardhat/config";
import {HardhatRuntimeEnvironment} from "hardhat/types";

const main = async (args: any, hre: HardhatRuntimeEnvironment) => {
  const network = hre.network.name as ParamChainName;

  const [signer] = await hre.ethers.getSigners();
  if (signer === undefined) {
    throw new Error(
      `Wallet not found. Please, run "npx hardhat account --save" or set PRIVATE_KEY env variable (for example, in a .env file)`
    );
  }

  const systemContract = getAddress("systemContract", network);

  const factory = await hre.ethers.getContractFactory("Staking");

  let symbol, chainID;

  if (args.chain === "btc_testnet") {
    symbol = "BTC";
    chainID = 18332;
  } else {
    const zrc20 = getAddress("zrc20", args.chain);
    const contract = new hre.ethers.Contract(zrc20!, ZRC20.abi, signer);
    symbol = await contract.symbol();
    chainID = hre.config.networks[args.chain]?.chainId;
    if (chainID === undefined) {
      throw new Error(`🚨 Chain ${args.chain} not found in hardhat config.`);
    }
  }

  const contract = await factory.deploy(
    `Staking rewards for ${symbol}`,
    `R${symbol.toUpperCase()}`,
    chainID,
    systemContract
  );
  await contract.deployed();

  const isTestnet = network === "zeta_testnet";
  const zetascan = isTestnet ? "athens.explorer" : "explorer";
  const blockscout = isTestnet ? "zetachain-athens-3" : "zetachain";

  if (args.json) {
    console.log(JSON.stringify(contract));
  } else {
    console.log(`
      🔑 Using account: ${signer.address}
      🚀 Successfully deployed contract on ${network}.
      📜 Contract address: ${contract.address}
      🌍 ZetaScan: https://${zetascan}.zetachain.com/address/${contract.address}
      🌍 Blockcsout: https://${blockscout}.blockscout.com/address/${contract.address}
`);
  }
};

task("deploy", "Deploy the contract", main).addParam(
  "chain",
  "Chain ID (use btc_testnet for Bitcoin Testnet)"
);
