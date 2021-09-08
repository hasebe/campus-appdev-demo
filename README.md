# Google Cloud demo material for Application Development Campus

**This is not an officially supported Google product**. This directory
contains some scripts to demonstrate how to use Google Cloud's DevOps products
in more efficient way.

## 目的

本デモは Google Cloud の下記機能を使い、コンテナ、サーバーレス、CI/CD パイプライン、また監視機能を体験することを目的としています。

- Cloud Shell
- Google Kubernetes Engine
- Cloud Run
- Artifact Registry
- Cloud Source Repositories
- Cloud Build
- Cloud Trace

## 前提

本デモは新しい Google Cloud のプロジェクトの上で、Cloud Shell から実行することを想定しています。

## デモ手順

### 環境準備

1. ソースコードのダウンロード

   ```bash
   git clone https://github.com/hasebe/campus-appdev-demo.git
   ```

2. ディレクトリの移動

   ```bash
   cd campus-appdev-demo
   ```

3. 対象 Google Cloud プロジェクトの設定

   ```bash
   gcloud config set project [PROJECT_ID]
   ```

4. デモ環境初期化

   ```bash
   ./preparation.sh
   ```

5. デモスクリプトが配置してあるディレクトリを PATH に追加

   ```bash
   export PATH=${PWD}/demo-scripts:$PATH
   ```

### デモの実施

1. 実行ファイルの作成、動作確認

   ```bash
   1.sh
   ```

   Go 言語で書かれたプログラムがビルド、実行されます。8080 ポートでアクセスを待ち受けていますので、Cloud Shell の中から 8080 ポートにアクセスして見てみましょう。

   Ctrl + C でプロセスを止めます。

   Git に登録しないよう、実行ファイルを削除します。

   ```bash
   rm -rf backend/devops_handson
   ```

2. アプリケーションのコンテナ化、確認

   ```bash
   2.sh
   ```

   Dockerfile の内容に基づき、コンテナが作成されます。作成されたコンテナは Cloud Shell 上に保存されます。

3. コンテナの Artifact Registry へのプッシュ

   ```bash
   3.sh
   ```

   作成したコンテナを Artifact Registry にプッシュします。Artifact Registry は事前に作成、設定済みです。

4. GKE へのデプロイ

   ```bash
   4.sh
   ```

   Artifact Registry にプッシュしたコンテナを GKE にデプロイします。GKE のマニフェストは下記の 2 ファイルを利用します。

   - gke-config/deployment.yaml
   - gke-config/loadbalancer.yaml

   デプロイ完了後、下記コマンドで取得できる外部 IP アドレスからアプリケーションにアクセスできます。

   ```bash
   kubectl get svc -n devops-handson-ns
   ```

5. Cloud Run へのデプロイ

   ```bash
   5.sh
   ```

   Artifact Registry にプッシュしたコンテナを Cloud Run にデプロイします。GKE と違い、Cloud Run では 1 コマンドでデプロイができます。デプロイ後に出力されるエンドポイントからアプリケーションにアクセスできます。

6. Git リポジトリの作成、コードのアップロード

   ```bash
   6.sh
   ```

   ソースコードが Cloud Shell 上に置かれています。Git リポジトリを作成し、ソースコードをアップロードします。

7. ビルド設定、トリガーの作成

   ```bash
   7.sh
   ```

   Cloud Build にトリガーを作成します。このトリガーは手順 6 で作成したリポジトリに修正があると起動します。実行される処理は、ここまで手動で行ってきた、コンテナの作成、Artifact Registry へのプッシュ、Cloud Run へのデプロイです。

   処理の中身は下記のファイルを参照ください。

   - cloudbuild.yaml

8. ソースコードを修正し、プッシュ

   アプリケーションのソースコードを使いやすいエディタから修正します。修正箇所は下記ファイルの 101 行目から 103 行目をコメントアウト or 削除するのが良いでしょう。そうすると、UI(Bench)画面のカウントアップが早くなります。

   - backend/main.go

   修正後、下記のコマンドで Git リポジトリにプッシュします

   ```bash
   git add . && git commit -m "Fix"
   ```

9. Cloud Build が修正を検知、新しいコンテナを作成し Cloud Run へデプロイ

   手順 8 を実行すると Cloud Build のトリガーが起動し、コンテナのビルド、Artifact Registry へのプッシュ、Cloud Run へのデプロイが開始されます。

   Cloud Console の Cloud Build 履歴から進捗を確認しましょう。またトリガーされた処理が完了した後に、UI(Bench)画面のカウントアップが早くなっていることを確認します。

10. 監視、ロギング、トレーシング

    Cloud Trace のトレースリスト画面から、処理内容の詳細、手順 9 前後の状況を確認します。負荷がかかっていた処理がなくなり、すぐ結果を返すようになっていることを確認します。

## クリーンアップ

プロジェクトごと削除するのが最も簡単です。下記のコマンドでプロジェクトを削除します。

```bash
gcloud projects delete [PROJECT_ID]
```
