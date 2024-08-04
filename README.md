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

  Swap 用のテンプレートコントラクトを生成するには以下のコマンドを生成

  ```bash
  npx hardhat omnichain Swap targetToken:address recipient
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

- コントラクト名を指定した場合

  ```bash
  npx hardhat deploy --name SwapToAnyToken --network zeta_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0x96B7F8B76d74BFdC334F85dDBFfcea24f7592207
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0x96B7F8B76d74BFdC334F85dDBFfcea24f7592207
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0x96B7F8B76d74BFdC334F85dDBFfcea24f7592207
  ```

- sepolia テストネットから zetachain のテストネットへ送金する

  事前に`0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067`に Sepolia ETH を送金しておく必要あり

  ```bash
  npx hardhat interact --contract 0x82F26Ce25D4B28fF6DeEE4eF90bA3c8567c900Ed --amount 0.01 --network sepolia_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067

      🚀 Successfully broadcasted a token transfer transaction on sepolia_testnet network.
      📝 Transaction hash: 0x8ff9cc6be40254a7ba13326b899fb8d31c2ada22ebc5d3692c6e19658faad3c5
  ```

  トランザクションを確認する

  ```bash
  npx hardhat cctx 0x8ff9cc6be40254a7ba13326b899fb8d31c2ada22ebc5d3692c6e19658faad3c5

  ✓ CCTXs on ZetaChain found.

  ✓ 0xedde81be8a7e234e77bf0b8a49738b07019224f3484a5f4ddff34994bedff0b8: 11155111 → 7001: OutboundMined (Remote omnichain contract call completed)
  ```

- Swap のコントラクトのデプロイ記録

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067

  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0x2B769C1A6Be728E1edC3D9269b5689E4973Dd537
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0x2B769C1A6Be728E1edC3D9269b5689E4973Dd537
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0x2B769C1A6Be728E1edC3D9269b5689E4973Dd537
  ```

- Swap を行うコマンド

  Sepolia から Amoy への swap

  ```bash
  npx hardhat interact --contract 0x2B769C1A6Be728E1edC3D9269b5689E4973Dd537 --amount 0.03 --network sepolia_testnet --target-token 0x777915D031d1e8144c90D025C594b3b8Bf07a08d --recipient 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067

  🚀 Successfully broadcasted a token transfer transaction on sepolia_testnet network.
  📝 Transaction hash: 0x81d05c9c0098eff783ef62ea5eb5cab6672728f68aff0619bd2904c4ef8c171b
  ```

  ```bash
  npx hardhat cctx 0x81d05c9c0098eff783ef62ea5eb5cab6672728f68aff0619bd2904c4ef8c171b

  ✓ CCTXs on ZetaChain found.

  ✓ 0xd6e32634ef5910cd5986d4857ddc3a0441fcfceee431e5e54017fb07741332de: 11155111 → 7001: OutboundMined (Remote omnichain contract call completed)
  ✓ 0x1ad600765698f51e1d2bba2fde1f143572f7b4743a864902bdfc5f8eedb9ab81: 7001 → 80002: PendingOutbound (ZRC20 withdrawal event setting to pending outbound directly) → OutboundMined (ZRC20 withdrawal event setting to pending outbound directly : Outbound succeeded, mined)
  ```

- チェーン間で任意のトークンを Swap する。

  - Swap Tokens Without Withdrawing

    ```bash
    npx hardhat interact --contract 0x1767A93A96D339EeC8E0325D94B5d3E4454d542f --network bsc_testnet --amount 0.01 --input-token 0xd97B1de3619ed2c6BEb3860147E30cA8A7dC9891 --target-token 0xcC683A782f4B30c138787CB5576a86AF66fdc31d --recipient 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --withdraw false
    ```

    ```bash
    Transaction hash: 0x1248de9227a4c411cf1fedbe65fc61542412502af0747500b984d859928a0426
    ```

    ```bash
    npx hardhat cctx 0x1248de9227a4c411cf1fedbe65fc61542412502af0747500b984d859928a0426
    ```

  - Swap Tokens With Withdrawing

    ```bash
    npx hardhat interact --contract 0x1767A93A96D339EeC8E0325D94B5d3E4454d542f --network bsc_testnet --amount 0.1 --input-token 0xd97B1de3619ed2c6BEb3860147E30cA8A7dC9891 --target-token 0xcC683A782f4B30c138787CB5576a86AF66fdc31d --recipient 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072  --withdraw true
    ```

- Staking Contract をデプロイする。

  `staking`ディレクリで実行すること。

  ```bash
  npx hardhat deploy --chain btc_testnet --network zeta_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0x92810274196d79e9E7FBAC8207509B637b2E6c07
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0x92810274196d79e9E7FBAC8207509B637b2E6c07
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0x92810274196d79e9E7FBAC8207509B637b2E6c07
  ```

  chain の部分を変えることで Stake 先を変えられる。

  ```bash
  npx hardhat deploy --network zeta_testnet --chain sepolia_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0x66291B7264524e564BA0e99B97997F72cd2696a7
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0x66291B7264524e564BA0e99B97997F72cd2696a7
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0x66291B7264524e564BA0e99B97997F72cd2696a7
  ```

  stake する。

  ```bash
  npx hardhat stake --amount 0.1 --beneficiary 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --contract 0x66291B7264524e564BA0e99B97997F72cd2696a7 --network sepolia_testnet
  ```

  Stake した記録は EtherScan 上から確認が可能

  [0x727307eeaa653cac6d2d241cc50fec57e2c9bfc87af960d94e0730cd00df3e3c](https://sepolia.etherscan.io/tx/0x727307eeaa653cac6d2d241cc50fec57e2c9bfc87af960d94e0730cd00df3e3c)

  update-beneficiary するコマンド

  ```bash
  npx hardhat update-beneficiary --contract 0x66291B7264524e564BA0e99B97997F72cd2696a7 --beneficiary 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --network sepolia_testnet
  ```

  update-beneficiary した時の記録は EtherScan から確認が可能

  [0x9c972a6c4a053244c4ed0ad066eec3647850ded9917f11bde229138a7d1cf6c6](https://sepolia.etherscan.io/tx/0x9c972a6c4a053244c4ed0ad066eec3647850ded9917f11bde229138a7d1cf6c6)

  claim するコマンド

  ```bash
  npx hardhat claim --contract 0x66291B7264524e564BA0e99B97997F72cd2696a7 --staker 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --network sepolia_testnet
  ```

  claim した時の記録

  [0x472b00d2ee57aef80a956091fab20afd2fb5abf144a0d6508e3d54a69b4dcff6](https://sepolia.etherscan.io/tx/0x472b00d2ee57aef80a956091fab20afd2fb5abf144a0d6508e3d54a69b4dcff6)

  unstake するコマンド

  ```bash
  npx hardhat unstake --contract 0x66291B7264524e564BA0e99B97997F72cd2696a7 --network sepolia_testnet
  ```

  unstake した時の記録

  [0x9c972a6c4a053244c4ed0ad066eec3647850ded9917f11bde229138a7d1cf6c6](https://sepolia.etherscan.io/tx/0x9c972a6c4a053244c4ed0ad066eec3647850ded9917f11bde229138a7d1cf6c6)

  Polygon Amoy 用にもデプロイできる。

  ```bash
  npx hardhat deploy --network zeta_testnet --chain amoy_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0xa7f029596460f4bB7C263979e2464b912880Bb47
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0xa7f029596460f4bB7C263979e2464b912880Bb47
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0xa7f029596460f4bB7C263979e2464b912880Bb47
  ```

- クロスチェーン NFT を発行する時の操作

  `nft`ディレクトリで実行する。

  デプロイするコマンド

  ```bash
  npx hardhat deploy --network zeta_testnet
  ```

  ```bash
  🔑 Using account: 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  🚀 Successfully deployed contract on zeta_testnet.
  📜 Contract address: 0x1Fe904cFEdF8D61Bcaf77c2a728704A26ad74f47
  🌍 ZetaScan: https://athens.explorer.zetachain.com/address/0x1Fe904cFEdF8D61Bcaf77c2a728704A26ad74f47
  🌍 Blockcsout: https://zetachain-athens-3.blockscout.com/address/0x1Fe904cFEdF8D61Bcaf77c2a728704A26ad74f47
  ```

  サブグラフをデプロイ

  ```bash
  goldsky login
  goldsky subgraph deploy nft/v1 --from-abi goldsky.json
  ```

  こうすることでサブグラフがデプロイされる。

  [Public SubGraph](https://api.goldsky.com/api/public/project_clzfkgto0x60v01wi16os4gyx/subgraphs/nft-zetachain-testnet/v1/gn)

  NFT をデプロイするコマンド

  ```bash
  npx hardhat interact --contract 0x1Fe904cFEdF8D61Bcaf77c2a728704A26ad74f47 --amount 0.01 --network sepolia_testnet --recipient 0x708fb972b5aF5ca7CeAc6ac1ad2f8b48BEC17067
  ```

  以下が NFT を発行した時の記録

  [0x7e6b2b9e2d9feb2ee0c6a70debb1fe572cf046891ad4da31dc97206b17a24b35](https://sepolia.etherscan.io/tx/0x7e6b2b9e2d9feb2ee0c6a70debb1fe572cf046891ad4da31dc97206b17a24b35)

  クロスチェーントランザクション

  [ZetaScan - 0x40385d9e7f6bbf4310dd6c1de684915399d3f57e4de8cb22ba16d9c1963d9f99](https://athens.explorer.zetachain.com/cc/tx/0x40385d9e7f6bbf4310dd6c1de684915399d3f57e4de8cb22ba16d9c1963d9f99)

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
11. [ファウセットサイト 2](https://faucet.triangleplatform.com/zetachain/athens3)
12. [Goldsky Dashboard](https://app.goldsky.com/dashboard)
