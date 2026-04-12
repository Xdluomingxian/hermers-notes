#!/bin/bash

# 创建当日日记脚本
# 用法：./create-daily-note.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$SCRIPT_DIR"
DIARY_DIR="$VAULT_DIR/10-日记"
TEMPLATE_FILE="$VAULT_DIR/90-模板/日记模板.md"

# 获取今天日期
TODAY=$(date +%Y-%m-%d)
YEAR=$(date +%Y)
MONTH=$(date +%m)

# 创建年月子目录
mkdir -p "$DIARY_DIR/$YEAR/$MONTH"

# 日记文件路径
NOTE_FILE="$DIARY_DIR/$YEAR/$MONTH/$TODAY.md"

# 检查是否已存在
if [ -f "$NOTE_FILE" ]; then
    echo "今日日记已存在：$NOTE_FILE"
    exit 0
fi

# 读取模板并替换日期
if [ -f "$TEMPLATE_FILE" ]; then
    # 替换 {{date}} 和 {{date:YYYY-MM-DD}}
    CONTENT=$(cat "$TEMPLATE_FILE" | sed "s/{{date:YYYY-MM-DD}}/$TODAY/g" | sed "s/{{date:YYYY-[W]ww}}/$YEAR-W$(date +%V)/g" | sed "s/{{date:W}}/$(date +%V)/g" | sed "s/{{date:YYYY-MM}}/$YEAR-$MONTH/g" | sed "s/{{date:YYYY}}/$YEAR/g" | sed "s/{{date}}/$TODAY/g")
    echo "$CONTENT" > "$NOTE_FILE"
    echo "已创建今日日记：$NOTE_FILE"
else
    echo "错误：模板文件不存在 $TEMPLATE_FILE"
    exit 1
fi
