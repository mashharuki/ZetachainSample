# ZetachainSample

Zetachain を学習するためのサンプルリポジトリです。

## Zetachain とは

チェーンアプストラクションを可能とする L1 ブロックチェーン

- `onCrossChainCall` メソッドについて

  onCrossChainCall は、接続されたチェーンの TSS アドレスに送られたトークントランザクション（ガストークンが預けられた時）や、ERC-20 カストディ契約のデポジットメソッドコール（ERC-20 トークンが預けられた時）によってコントラクトが呼び出されたときに実行される関数です。この関数は以下の入力を受け取ります：

  context: zContext 型の構造体で、以下の値を含みます。

  origin: トークントランザクションを TSS アドレスに送った EOA アドレス（オムニチェーンコントラクトをトリガー）または ERC-20 カストディ契約のデポジットメソッドコールに渡された値。

  chainID: オムニチェーンコントラクトがトリガーされた接続チェーンの整数 ID。

  sender（将来の使用のために予約、現在は空）

  zrc20: ZetaChain 上で接続チェーンからの資産を表す ZRC-20 トークンコントラクトのアドレス。

  amount: TSS アドレスに転送されたトークンの量、または ERC-20 カストディ契約に預けられたトークンの量。

  message: トークントランザクションのデータフィールドの内容。

  onCrossChainCall 関数はシステムコントラクト（つまり、ZetaChain プロトコル）によってのみ呼び出される必要があります。これは、コンテキストに任意の値を供給する呼び出し元を防ぐためです。onlySystem モディファイアは、この関数が TSS アドレスや ERC-20 カストディ契約に送られたトークントランザクションへの応答としてのみ呼び出されることを保証します(つまりここに独自のロジックを実装していくことになる。)。

## 動かし方

`first-app`ディレクトリ配下で実行する。

- インストール

  ```bash
  yarn
  ```

- テンプレートプロジェクト生成

  ```bash
  npx hardhat omnichain MyContract
  ```

- ウォレットアドレスを作成

  ```bash
  npx hardhat account --save
  ```

  作成したアドレス

  ```bash
  😃 EVM address: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  😃 Bitcoin address: tb1qu9tgjwu33mmxpruj6t766s8fjapr5cjl4tvlt5
  😃 Bech32 address: zeta1wz8mju444aw20n4vdtq66tutfzlvzur8fxfj3m
  ```

- Zetachain ファウセットを取得する。

  ```bash
  npx hardhat faucet
  ```

- 残高の確認

  ```bash
  npx hardhat balances
  ```

  ```bash
  EVM: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  Bitcoin: tb1qu9tgjwu33mmxpruj6t766s8fjapr5cjl4tvlt5

  ┌─────────┬───────────────────┬───────────────────────────────────┬─────────┬────────────┐
  │ (index) │ Chain             │ Token                             │ Type    │ Amount     │
  ├─────────┼───────────────────┼───────────────────────────────────┼─────────┼────────────┤
  │ 0       │ 'amoy_testnet'    │ 'MATIC.AMOY'                      │ 'Gas'   │ 'NaN'      │
  │ 1       │ 'bsc_testnet'     │ 'USDC'                            │ 'ERC20' │ '0.000000' │
  │ 2       │ 'bsc_testnet'     │ 'tBNB'                            │ 'Gas'   │ '0.000000' │
  │ 3       │ 'bsc_testnet'     │ 'WZETA'                           │ 'ERC20' │ '0.000000' │
  │ 4       │ 'btc_testnet'     │ 'tBTC'                            │ 'Gas'   │ '0.000000' │
  │ 5       │ 'sepolia_testnet' │ 'sETH.SEPOLIA'                    │ 'Gas'   │ '0.000000' │
  │ 6       │ 'sepolia_testnet' │ 'USDC.SEPOLIA'                    │ 'ERC20' │ '0.000000' │
  │ 7       │ 'sepolia_testnet' │ 'WZETA'                           │ 'ERC20' │ '0.000000' │
  │ 8       │ 'zeta_testnet'    │ 'sETH.SEPOLIA'                    │ 'ZRC20' │ '0.000000' │
  │ 9       │ 'zeta_testnet'    │ 'USDC-goerli_testnet'             │ 'ZRC20' │ '0.000000' │
  │ 10      │ 'zeta_testnet'    │ 'gETH'                            │ 'ZRC20' │ '0.000000' │
  │ 11      │ 'zeta_testnet'    │ 'tMATIC'                          │ 'ZRC20' │ '0.000000' │
  │ 12      │ 'zeta_testnet'    │ 'tBTC'                            │ 'ZRC20' │ '0.000000' │
  │ 13      │ 'zeta_testnet'    │ 'MATIC.AMOY'                      │ 'ZRC20' │ '0.000000' │
  │ 14      │ 'zeta_testnet'    │ 'USDC-bsc_testnet'                │ 'ZRC20' │ '0.000000' │
  │ 15      │ 'zeta_testnet'    │ 'USDC-mumbai_testnet'             │ 'ZRC20' │ '0.000000' │
  │ 16      │ 'zeta_testnet'    │ 'ZetaChain ZRC20 USDC on SEPOLIA' │ 'ZRC20' │ '0.000000' │
  │ 17      │ 'zeta_testnet'    │ 'tBNB'                            │ 'ZRC20' │ '0.000000' │
  │ 18      │ 'zeta_testnet'    │ 'WZETA'                           │ 'ERC20' │ '0.000000' │
  │ 19      │ 'zeta_testnet'    │ 'ZETA'                            │ 'Gas'   │ '0.000000' │
  └─────────┴───────────────────┴───────────────────────────────────┴─────────┴────────────┘
  ```

- コンパイル

  ```bash
  npx hardhat compile
  ```

- テストネットへデプロイ

  ```bash
  npx hardhat deploy --network zeta_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0x82F26Ce25D4B28fF6DeEE4eF90bA3c8567c900Ed
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0x82F26Ce25D4B28fF6DeEE4eF90bA3c8567c900Ed
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0x82F26Ce25D4B28fF6DeEE4eF90bA3c8567c900Ed
  ```

- sepolia テストネットから zetachain のテストネットへ送金する

  ```bash
  npx hardhat interact --contract  0x82F26Ce25D4B28fF6DeEE4eF90bA3c8567c900Ed --amount 0.01 --network sepolia_testnet
  ```

### 参考文献

1. [開発者むけドキュメント](https://www.zetachain.com/developers)
2. [チュートリアル](https://www.zetachain.com/docs/developers/tutorials/hello/)
3. [GitHub - Zetachain](https://github.com/zeta-chain)
4. [チュートリアル用のサンプルリポジトリ](https://github.com/zeta-chain/template)
5. [zContract のインターフェース](https://github.com/zeta-chain/protocol-contracts/blob/main/contracts/zevm/interfaces/zContract.sol)
6. [SystemContract の情報](https://www.zetachain.com/docs/developers/evm/system-contract/)
7. [テストネットファウセット](https://www.zetachain.com/docs/reference/apps/get-testnet-zeta/)
8. [Zetachain プロジェクトで使える CLI コマンドテンプレ集](https://www.zetachain.com/docs/developers/reference/template/)
9. [Contract アドレス集](https://www.zetachain.com/docs/reference/network/contracts/)
10. [API/RPC endpoints](https://www.zetachain.com/docs/reference/network/api/)
