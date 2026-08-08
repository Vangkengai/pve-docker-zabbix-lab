#!/bin/bash
# Zabbix 钉钉机器人 Webhook 消息推送脚本

WEBHOOK_URL="https://oapi.dingtalk.com/robot/send?access_token=YOUR_ACCESS_TOKEN"

TEXT_CONTENT=$1

if [ -z "$TEXT_CONTENT" ]; then
    echo "Usage: $0 \"Alert Message\""
    exit 1
fi

curl -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{
    "msgtype": "text",
    "text": {
        "content": "【Zabbix 运维告警】\n'$TEXT_CONTENT'"
    }
  }'
