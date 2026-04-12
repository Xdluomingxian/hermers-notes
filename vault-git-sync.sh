#!/bin/bash

# Git 同步脚本 - 检测变更、commit、push
# 用法：./vault-git-sync.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$SCRIPT_DIR"

# 检查是否是 git 仓库
if [ ! -d "$VAULT_DIR/.git" ]; then
    echo "错误：$VAULT_DIR 不是 git 仓库"
    echo "请先运行：cd $VAULT_DIR && git init"
    exit 1
fi

cd "$VAULT_DIR"

# 检查是否有变更
CHANGES=$(git status --porcelain)

if [ -z "$CHANGES" ]; then
    echo "没有变更，跳过同步"
    exit 0
fi

# 添加变更
git add -A

# 提交
TIMESTAMP=$(date +%Y-%m-%d\ %H:%M:%S)
git commit -m "Auto-sync: $TIMESTAMP"

# 推送（如果有远程仓库）
REMOTE=$(git remote get-url origin 2>/dev/null)
if [ -n "$REMOTE" ]; then
    echo "推送到远程仓库..."
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "推送失败，请检查远程仓库配置"
    echo "同步完成"
else
    echo "未配置远程仓库，仅本地提交"
    echo "要添加远程仓库，请运行：git remote add origin <your-repo-url>"
fi
