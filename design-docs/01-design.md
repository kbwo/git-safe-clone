# 実装の仕組み

以下の流れで実行する
リポジトリをgit clone
clone先のディレクトリに移動

```
docker run -it \
    --pull=always \
    -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.28-nikolaik \
    -e SANDBOX_USER_ID=$(id -u) \
    -e SANDBOX_USE_HOST_NETWORK=true \
    -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
    -e LLM_API_KEY=$LLM_API_KEY \
    -e LLM_MODEL=$LLM_MODEL \
    -e LOG_ALL_EVENTS=true \
    -v $WORKSPACE_BASE:/opt/workspace_base \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.openhands-state:/.openhands-state \
    --add-host host.docker.internal:host-gateway \
    --name openhands-app-$(date +%Y%m%d%H%M%S) \
    docker.all-hands.dev/all-hands-ai/openhands:0.28 \
    python -m openhands.core.main -t "<コードベース全体、多すぎる場合には危険そうなファイルに目星をつけてを確認して安全かどうかを確認する指示をするプロンプト>"
```

を実行し、openhandsに危険かどうかを判断させる

openhandsのアウトプットをparseし、危険であったらリポジトリのディレクトリを消す
