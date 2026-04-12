#!/bin/bash

# 晨间简报脚本 - 创建日记 + 检查昨日未完成 + 飞书推送
# 用法：./morning-briefing.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$SCRIPT_DIR"
DIARY_DIR="$VAULT_DIR/10-日记"
LLM_SCRIPT="$VAULT_DIR/llm-chat.sh"
FEISHU_SCRIPT="$VAULT_DIR/feishu-notify.sh"

# 获取日期
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d 2>/dev/null)
YEAR=$(date +%Y)
MONTH=$(date +%m)
YESTERDAY_MONTH=$(date -d "yesterday" +%m 2>/dev/null || date -v-1d +%m 2>/dev/null)

# 1. 创建今日日记
echo "创建今日日记..."
bash "$SCRIPT_DIR/create-daily-note.sh"

# 2. 读取昨日日记
YESTERDAY_NOTE="$DIARY_DIR/$YEAR/$YESTERDAY_MONTH/$YESTERDAY.md"
if [ -f "$YESTERDAY_NOTE" ]; then
    YESTERDAY_CONTENT=$(cat "$YESTERDAY_NOTE")
    
    # 3. 用 AI 生成今日建议
    if [ -f "$LLM_SCRIPT" ]; then
        echo "生成 AI 今日建议..."
        AI_SUGGESTIONS=$(echo "$YESTERDAY_CONTENT" | bash "$LLM_SCRIPT" "根据昨天的日记，用三句话给出今天的建议，每条建议一行。")
    else
        AI_SUGGESTIONS="请回顾昨天的日记，规划今天最重要的三件事。"
    fi
else
    AI_SUGGESTIONS="新的一天开始了！请规划今天最重要的三件事。"
fi

# 4. 检查昨日未完成的任务
UNFINISHED=""
if [ -f "$YESTERDAY_NOTE" ]; then
    UNFINISHED=$(grep -E "^\- \[ \]" "$YESTERDAY_NOTE" | head -5)
fi

# 5. 构建通知内容
NOTICE_CONTENT="## 🌅 晨间简报

**日期：** $TODAY

---

### 💡 AI 今日建议
$AI_SUGGESTIONS

---

### 📋 昨日未完成
$UNFINISHED

---

打开 Obsidian 开始今天的工作吧！"

# 6. 发送飞书通知
if [ -f "$FEISHU_SCRIPT" ]; then
    echo "$NOTICE_CONTENT" | bash "$FEISHU_SCRIPT" "🌅 晨间简报 - $TODAY"
else
    echo "飞书通知脚本不存在，跳过发送"
fi

echo "晨间简报完成"
echo "$NOTICE_CONTENT"
