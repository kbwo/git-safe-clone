# openhandsの出力

openhandsの出力の内容は./openhands-logにある。

./openhands-log/2025-03-08.txtは以下のコマンド及びプロンプトで実行したときのログである。
必ずしもこのプロンプトであり続ける必要はない。
一例として参考にせよ

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
    python -m openhands.core.main -t "write a bash script that prints hi"
```

## ログのparse
parse戦略として、最後のAgentFinishAction(final_thought='<コードベースの分析結果>')をparseすることが考えられる。
よりプログラムで扱いやすい結果を返すようにプロンプトを改善する必要もあるだろう

