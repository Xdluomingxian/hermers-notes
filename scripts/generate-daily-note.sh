#!/bin/bash
# 晚间日记生成脚本
# 核心原则：真实第一，完整第二

set -e

cd ~/obsidian-vault

# 获取今天日期
TODAY=$(date +%Y-%m-%d)
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

# 计算星期
WEEKDAY=$(date -d "$TODAY" +%u)
case $WEEKDAY in
  1) WEEKDAY_NAME="星期一" ;;
  2) WEEKDAY_NAME="星期二" ;;
  3) WEEKDAY_NAME="星期三" ;;
  4) WEEKDAY_NAME="星期四" ;;
  5) WEEKDAY_NAME="星期五" ;;
  6) WEEKDAY_NAME="星期六" ;;
  7) WEEKDAY_NAME="星期日" ;;
esac

# 确保目录存在
mkdir -p "10-日记/${YEAR}/${MONTH}/"

DIARY_FILE="10-日记/${YEAR}/${MONTH}/${TODAY}.md"

# 收集 git 数据
echo "正在收集当日 git 数据..."

# 获取当日提交记录
GIT_LOG=$(git log --since="$TODAY 00:00" --until="$TODAY 23:59" --format="%h|%ai|%s" 2>/dev/null || echo "")
COMMIT_COUNT=$(echo "$GIT_LOG" | grep -c "|" 2>/dev/null || echo "0")

# 获取文件变更
GIT_FILES=$(git log --since="$TODAY 00:00" --until="$TODAY 23:59" --name-only --format="" 2>/dev/null | sort -u | grep -v "^$" || echo "")

# 生成日记内容
echo "正在生成日记..."

cat > "$DIARY_FILE" << EOF
---
type: daily-note
date: ${TODAY}
tags: [日记，晚间总结]
---

# ${TODAY} ${WEEKDAY_NAME} 晚间日记

## 📅 今日概览
- **日期**: ${TODAY} ${WEEKDAY_NAME}
- **提交次数**: ${COMMIT_COUNT} 次
- **数据来源**: git 提交记录核实

---

## 💼 工作/学习

EOF

# 如果有提交记录，逐条添加
if [ -n "$GIT_LOG" ] && [ "$COMMIT_COUNT" -gt 0 ]; then
  echo "$GIT_LOG" | while IFS='|' read -r hash time msg; do
    if [ -n "$hash" ]; then
      # 提取时间（HH:MM）
      TIME_SHORT=$(echo "$time" | grep -oP '\d{2}:\d{2}' | head -1)
      
      # 获取该提交的文件（处理中文）
      FILES=$(git -c core.quotePath=false show --name-only --format="" "$hash" 2>/dev/null | head -5)
      
      cat >> "$DIARY_FILE" << EOF
### ${msg}
**时间**: ${TIME_SHORT:-未知}
**提交**: \`${hash}\`
**涉及文件**:
EOF
      echo "$FILES" | while read -r file; do
        if [ -n "$file" ]; then
          echo "- $file" >> "$DIARY_FILE"
        fi
      done
      echo "" >> "$DIARY_FILE"
    fi
  done
else
  cat >> "$DIARY_FILE" << EOF
**今日无 git 提交记录**

---

EOF
fi

# 添加其他章节
cat >> "$DIARY_FILE" << EOF
## ⚠️ 遇到问题

**今日无重大问题**

---

## ✅ 解决情况

$(if [ "$COMMIT_COUNT" -gt 0 ]; then echo "- 完成 ${COMMIT_COUNT} 次代码提交"; else echo "- 今日无提交"; fi)

---

## 📋 待办事项

- [ ] (待补充，需要查看任务列表)

---

## 📝 备注

**今日成果**: $(if [ "$COMMIT_COUNT" -gt 0 ]; then echo "完成 ${COMMIT_COUNT} 次 git 提交"; else echo "今日无代码提交"; fi)
**数据来源**: 本日记内容基于 git 提交记录核实，确保真实性。

---
*最后更新：${TODAY} 23:40*
EOF

echo "日记文件已生成：$DIARY_FILE"

# Git 提交
echo "正在提交到 git..."
git add "$DIARY_FILE"
git commit -m "Daily: ${TODAY} 晚间日记" || echo "无变更需要提交"
git push origin master || echo "推送失败，请检查网络连接"

echo "✅ 日记生成完成！"
