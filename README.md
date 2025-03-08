# git safe-clone

## 概要
`git safe-clone`は、危険なリポジトリをcloneして、十分なリスク分析をしないまま実行しないようにするための安全なgit cloneです。
cloneしたリポジトリはLLMによるチェックが行われ、危険と判断された場合にはcloneしたディレクトリが消されます。

## インストール方法

1. このリポジトリをクローンします:
   ```bash
   git clone https://github.com/kbwo/git-safe-clone.git
   ```

2. スクリプトを実行可能にします:
   ```bash
   chmod +x git-safe-clone
   ```

3. スクリプトをPATHの通ったディレクトリに配置します:
   ```bash
   sudo cp git-safe-clone /usr/local/bin/
   ```

4. 環境変数を設定します:
   ```bash
   # .bashrcや.zshrcなどに追加
   export LLM_API_KEY="your_api_key_here"
   export LLM_MODEL="your_preferred_model"  # 例: "gpt-4"
   ```

## 使い方

通常のgit cloneと同じように使用できます:

```bash
git safe-clone <repository-url> [<directory>] [<git-clone-options>...]
```

例:
```bash
git safe-clone https://github.com/example/repo.git
git safe-clone https://github.com/example/repo.git my-custom-dir
git safe-clone https://github.com/example/repo.git --depth=1
```

## 動作の仕組み

1. 指定されたリポジトリを通常通りgit cloneします
2. OpenHandsを使用してリポジトリのコードを分析します
3. 分析結果に基づいて、リポジトリが安全かどうかを判断します
4. 安全でないと判断された場合、クローンしたディレクトリは自動的に削除されます

## 必要条件

- Docker
- Git
- OpenHands（自動的にDockerイメージとして取得されます）
- LLM API Key（環境変数として設定）

