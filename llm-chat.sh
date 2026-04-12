#!/bin/bash

# LLM 聊天脚本 - 支持 OpenAI 兼容格式的 API
# 用法：cat input.md | ./llm-chat.sh "你的提示词"
# 或：./llm-chat.sh "你的提示词" < input.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/llm-config.json"

# 读取配置
if [ ! -f "$CONFIG_FILE" ]; then
    echo "错误：配置文件 $CONFIG_FILE 不存在"
    exit 1
fi

BASE_URL=$(cat "$CONFIG_FILE" | grep -o '"base_url"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
API_KEY=$(cat "$CONFIG_FILE" | grep -o '"api_key"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
MODEL=$(cat "$CONFIG_FILE" | grep -o '"model"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

if [ -z "$BASE_URL" ] || [ -z "$API_KEY" ] || [ -z "$MODEL" ]; then
    echo "错误：配置文件格式不正确"
    exit 1
fi

# 读取提示词和用户输入
PROMPT="$1"
USER_INPUT=$(cat)

# 构建请求体
REQUEST_BODY=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "$PROMPT

$user_input"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 2000
}
EOF
)

# 发送请求
RESPONSE=$(curl -s -X POST "$BASE_URL/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "$REQUEST_BODY")

# 解析响应
CONTENT=$(echo "$RESPONSE" | grep -o '"content"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$CONTENT" ]; then
    echo "错误：API 返回异常"
    echo "$RESPONSE"
    exit 1
fi

# 输出结果（处理转义字符）
echo "$CONTENT" | sed 's/\\n/\n/g' | sed 's/\\"/"/g'
