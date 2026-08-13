#!/bin/bash
# 容器状态健康检查与自愈拉起脚本

# 配置区域
CONTAINERS=("nginx-proxy" "zabbix-agent2")
WAIT_TIME=5  # 重启后的等待检查时间（秒）

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting container health check..."

for container in "${CONTAINERS[@]}"; do
    # 1. 获取容器状态和健康检查结果
    # {{.State.Status}} 可能是: running, exited, paused, restarting, dead
    # {{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}} 获取健康状态
    INFO=$(docker inspect -f '{{.State.Status}} {{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$container" 2>/dev/null)
    
    # 检查容器是否存在
    if [ $? -ne 0 ]; then
        echo "[ERROR] Container $container does not exist. Skipping..."
        continue
    fi

    STATUS=$(echo $INFO | cut -d' ' -f1)
    HEALTH=$(echo $INFO | cut -d' ' -f2)

    NEED_RESTART=false

    # 2. 判断是否需要重启
    if [ "$STATUS" != "running" ]; then
        echo "[WARNING] Container $container is not running (Current: $STATUS)."
        NEED_RESTART=true
    elif [ "$HEALTH" == "unhealthy" ]; then
        echo "[WARNING] Container $container is running but UNHEALTHY."
        NEED_RESTART=true
    fi

    # 3. 执行重启逻辑
    if [ "$NEED_RESTART" = true ]; then
        echo "[ACTION] Attempting to restart $container..."
        docker restart "$container" >/dev/null 2>&1
        
        sleep $WAIT_TIME
        
        # 4. 重启后复检
        NEW_INFO=$(docker inspect -f '{{.State.Status}} {{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$container" 2>/dev/null)
        NEW_STATUS=$(echo $NEW_INFO | cut -d' ' -f1)
        NEW_HEALTH=$(echo $NEW_INFO | cut -d' ' -f2)
        
        if [ "$NEW_STATUS" == "running" ] && [ "$NEW_HEALTH" != "unhealthy" ]; then
            echo "[SUCCESS] Container $container has been restored. (Status: $NEW_STATUS, Health: $NEW_HEALTH)"
        else
            echo "[CRITICAL] Failed to restore $container. (Status: $NEW_STATUS, Health: $NEW_HEALTH). Manual intervention may be required."
        fi
    else
        echo "[OK] Container $container is healthy (Status: $STATUS, Health: $HEALTH)."
    fi
done
