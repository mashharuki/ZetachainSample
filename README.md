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

- Zetachain ファウセットを取得する。

  ```bash
  npx hardhat faucet
  ```

- 残高の確認

  ```bash
  npx hardhat balances
  ```

- テストネットへデプロイ

  ```bash
  npx hardhat deploy --network zeta_testnet
  ```

- sepolia テストネットから zetachain のテストネットへ送金する

  ```bash
  npx hardhat interact --contract 0xE26F2e102E2f3267777F288389435d3037D14bb3 --amount 0.1 --network sepolia_testnet
  ```

### 参考文献

1. [開発者むけドキュメント](https://www.zetachain.com/developers)
2. [チュートリアル](https://www.zetachain.com/docs/developers/tutorials/hello/)
3. [GitHub - Zetachain](https://github.com/zeta-chain)
4. [チュートリアル用のサンプルリポジトリ](https://github.com/zeta-chain/template)
5. [zContract のインターフェース](https://github.com/zeta-chain/protocol-contracts/blob/main/contracts/zevm/interfaces/zContract.sol)
6. [SystemContract の情報](https://www.zetachain.com/docs/developers/evm/system-contract/)
7. [テストネットファウセット](https://www.zetachain.com/docs/reference/apps/get-testnet-zeta/)
