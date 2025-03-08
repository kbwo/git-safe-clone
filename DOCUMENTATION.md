# git-safe-clone ドキュメント

## 概要

`git-safe-clone`は、リポジトリをクローンする前に安全性を確認するためのGitカスタムコマンドです。このツールは、悪意のあるコードや安全でないコードを含む可能性のあるリポジトリからユーザーを保護することを目的としています。

リポジトリがクローンされた後、OpenHandsとLLMを使用してコードベースを分析し、安全かどうかを判断します。リポジトリが安全でないと判断された場合、クローンされたディレクトリは自動的に削除されます。

## インストール

### 前提条件

- Git
- Docker
- LLM API Key（OpenAI APIキーなど）

### インストール手順

1. このリポジトリをクローンします:
   ```bash
   git clone https://github.com/kbwo/git-safe-clone.git
   cd git-safe-clone
   ```

2. インストールスクリプトを実行します:
   ```bash
   ./install.sh
   ```

3. 環境変数を設定します:
   ```bash
   # .bashrcや.zshrcなどに追加
   export LLM_API_KEY="your_api_key_here"
   export LLM_MODEL="your_preferred_model"  # 例: "gpt-4"
   ```

4. シェル設定を再読み込みします:
   ```bash
   source ~/.bashrc  # または ~/.zshrc など
   ```

### 手動インストール

1. スクリプトを実行可能にします:
   ```bash
   chmod +x git-safe-clone
   ```

2. スクリプトをPATHの通ったディレクトリに配置します:
   ```bash
   sudo cp git-safe-clone /usr/local/bin/
   ```

## 使用方法

### 基本的な使い方

```bash
git safe-clone <repository-url> [<directory>] [<git-clone-options>...]
```

### 例

```bash
# 基本的な使い方
git safe-clone https://github.com/example/repo.git

# カスタムディレクトリ名を指定
git safe-clone https://github.com/example/repo.git my-custom-dir

# git cloneオプションを指定
git safe-clone https://github.com/example/repo.git --depth=1

# 複数のオプションを指定
git safe-clone https://github.com/example/repo.git my-dir --depth=1 --branch=develop
```

## 動作の仕組み

1. 指定されたリポジトリを通常通りgit cloneします
2. OpenHandsを使用してリポジトリのコードを分析します
   - OpenHandsはDockerコンテナ内で実行され、クローンされたリポジトリをマウントします
   - LLMを使用してコードベースを分析し、安全かどうかを判断します
3. 分析結果に基づいて、リポジトリが安全かどうかを判断します
   - 安全と判断された場合、クローンされたディレクトリはそのまま残ります
   - 安全でないと判断された場合、クローンされたディレクトリは自動的に削除されます

## 安全性の判断基準

リポジトリの安全性は、以下の要素に基づいて判断されます:

- シェルコマンドの実行
- 不審なドメインへのネットワーク接続
- 難読化されたコード
- 暗号通貨マイナー
- データの流出
- 権限昇格
- その他の悪意のあるコードパターン

## トラブルシューティング

### Docker関連の問題

- Dockerが実行されていることを確認してください
- Dockerの権限問題がある場合は、ユーザーをdockerグループに追加してください:
  ```bash
  sudo usermod -aG docker $USER
  ```

### API Key関連の問題

- LLM_API_KEY環境変数が正しく設定されていることを確認してください
- API Keyの有効期限や使用制限を確認してください

### その他の問題

- 一時ファイルが残っている場合は、/tmp/openhands-log-*ファイルを確認してください
- Dockerイメージのプルに問題がある場合は、手動でイメージをプルしてみてください:
  ```bash
  docker pull docker.all-hands.dev/all-hands-ai/openhands:0.28
  docker pull docker.all-hands.dev/all-hands-ai/runtime:0.28-nikolaik
  ```

## カスタマイズ

### プロンプトのカスタマイズ

`git-safe-clone`スクリプト内のOpenHandsに送信されるプロンプトをカスタマイズすることができます。プロンプトは、リポジトリの安全性を判断するためのLLMへの指示です。

### 環境変数

- `LLM_API_KEY`: LLM APIキー（必須）
- `LLM_MODEL`: 使用するLLMモデル（必須）
- `WORKSPACE_BASE`: クローンされたリポジトリのパス（自動設定）

## ライセンス

MITライセンス 