#!/bin/bash
# Zabbix 钉钉机器人 Webhook 消息推送脚本

WEBHOOK_URL="https://oapi.dingtalk.com/robot/send?access_token=YOUR_ACCESS_TOKEN

# 报警内容
TEXT_CONTENT=$1

if [ -z "$TEXT_CONTENT" ]; then
    echo "Usage: $0 \"Alert Message\""
    exit 1
fi

# 1. 自动转义 JSON 中的特殊字符 
JSON_PAYLOAD=$(python3 -c "import json,sys; print(json.dumps({'msgtype': 'text', 'text': {'content': '【Zabbix 运维告警】\n' + sys.argv[1]}}))" "$TEXT_CONTENT")

# 2. 发送请求并记录响应
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sending alert to DingTalk..."
RESPONSE=$(curl -s -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d "$JSON_PAYLOAD")

# 3. 简单的结果检查
if [[ $RESPONSE == *"\"errcode\":0"* ]]; then
    echo "[SUCCESS] Message sent successfully."
else
    echo "[ERROR] Failed to send message. Response: $RESPONSE"
    exit 1
fi
