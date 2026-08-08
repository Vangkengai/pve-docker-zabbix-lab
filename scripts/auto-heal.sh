#!/bin/bash
# 容器状态健康检查与自愈拉起脚本

CONTAINERS=("nginx-proxy" "zabbix-agent2")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting container health check..."

for container in "${CONTAINERS[@]}"; do
    STATUS=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null)
    
    if [ "$STATUS" != "running" ]; then
        echo "[WARNING] Container $container is $STATUS. Attempting restart..."
        docker restart "$container"
        sleep 3
        NEW_STATUS=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null)
        echo "[INFO] Container $container status after restart: $NEW_STATUS"
    else
        echo "[OK] Container $container is running normally."
    fi
done
