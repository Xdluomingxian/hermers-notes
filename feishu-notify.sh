#!/bin/bash

# 飞书通知脚本 - 往飞书群发卡片消息
# 用法：./feishu-notify.sh "标题" "内容"
# 或：echo "内容" | ./feishu-notify.sh "标题"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEBHOOK_FILE="$SCRIPT_DIR/feishu-webhook.txt"

# 读取 Webhook URL
if [ ! -f "$WEBHOOK_FILE" ]; then
    echo "错误：飞书 Webhook 配置文件不存在"
    echo "请在 $WEBHOOK_FILE 中写入你的飞书机器人 Webhook URL"
    exit 1
fi

WEBHOOK_URL=$(cat "$WEBHOOK_FILE" | tr -d '\n\r')

if [ -z "$WEBHOOK_URL" ]; then
    echo "错误：Webhook URL 为空"
    exit 1
fi

# 读取参数
TITLE="$1"
CONTENT="${2:-$(cat)}"

# 构建请求体（使用 PowerShell 兼容的 UTF-8 编码方式）
# 注意：在 Windows 上运行时，需要使用 PowerShell 发送请求
cat <<EOF > /tmp/feishu_payload.json
{
  "msg_type": "interactive",
  "card": {
    "header": {
      "title": {
        "tag": "plain_text",
        "content": "$TITLE"
      },
      "template": "blue"
    },
    "elements": [
      {
        "tag": "markdown",
        "content": "$CONTENT"
      }
    ]
  }
}
EOF

# 发送请求
echo "发送飞书通知..."
curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @/tmp/feishu_payload.json

echo "通知已发送"
