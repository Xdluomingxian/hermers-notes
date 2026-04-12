#!/bin/bash

# 晚间提醒脚本 - 统计完成率 + 催反思 + 自动 commit
# 用法：./evening-reminder.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$SCRIPT_DIR"
DIARY_DIR="$VAULT_DIR/10-日记"
LLM_SCRIPT="$VAULT_DIR/llm-chat.sh"
FEISHU_SCRIPT="$VAULT_DIR/feishu-notify.sh"
GIT_SCRIPT="$VAULT_DIR/vault-git-sync.sh"

# 获取日期
TODAY=$(date +%Y-%m-%d)
YEAR=$(date +%Y)
MONTH=$(date +%m)

# 1. 读取今日日记
TODAY_NOTE="$DIARY_DIR/$YEAR/$MONTH/$TODAY.md"

if [ -f "$TODAY_NOTE" ]; then
    TODAY_CONTENT=$(cat "$TODAY_NOTE")
    
    # 2. 统计任务完成情况
    TOTAL_TASKS=$(grep -cE "^\- \[[ x]\]" "$TODAY_NOTE" 2>/dev/null || echo "0")
    COMPLETED_TASKS=$(grep -cE "^\- \[x\]" "$TODAY_NOTE" 2>/dev/null || echo "0")
    
    if [ "$TOTAL_TASKS" -gt 0 ]; then
        COMPLETION_RATE=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
    else
        COMPLETION_RATE=0
    fi
    
    # 3. 用 AI 生成今日总结
    if [ -f "$LLM_SCRIPT" ]; then
        AI_SUMMARY=$(echo "$TODAY_CONTENT" | bash "$LLM_SCRIPT" "用一句话总结今天的日记内容。")
    else
        AI_SUMMARY="请完成晚间反思，记录今天的收获。"
    fi
    
    # 4. 构建通知内容
    NOTICE_CONTENT="## 🌙 晚间提醒

**日期：** $TODAY

---

### 📊 今日任务完成率
**$COMPLETED_TASKS / $TOTAL_TASKS** ($COMPLETION_RATE%)

---

### 💡 AI 今日总结
$AI_SUMMARY

---

该做晚间反思了！
打开 Obsidian 完成今天的日记吧～"

    # 5. 发送飞书通知
    if [ -f "$FEISHU_SCRIPT" ]; then
        echo "$NOTICE_CONTENT" | bash "$FEISHU_SCRIPT" "🌙 晚间提醒 - $TODAY"
    else
        echo "飞书通知脚本不存在，跳过发送"
    fi
    
    echo "$NOTICE_CONTENT"
else
    echo "今日日记不存在，先创建日记..."
    bash "$SCRIPT_DIR/create-daily-note.sh"
fi

# 6. 自动 Git 同步
if [ -f "$GIT_SCRIPT" ] && [ -d "$VAULT_DIR/.git" ]; then
    echo "执行 Git 同步..."
    bash "$GIT_SCRIPT"
fi

echo "晚间提醒完成"
