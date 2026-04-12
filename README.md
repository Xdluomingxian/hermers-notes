# 🧠 个人知识库系统

基于 Obsidian + 飞书 + Git + LLM 的自动化个人知识库系统

---

## 📁 目录结构

```
obsidian-vault/
├── 00-收件箱/          # 快速捕获，什么都往里扔
├── 10-日记/            # 按年/月自动归类
├── 20-任务/            # 待办 + 习惯追踪
├── 30-项目/            # 一个项目一个文件夹
├── 40-知识库/          # 读书笔记、学习笔记、技术参考、灵感
├── 50-归档/            # 做完的东西丢这里
├── 90-模板/            # 所有模板放一起
├── 90-附件/            # 图片、PDF
├── 90-模板/
│   ├── 日记模板.md
│   ├── 周回顾模板.md
│   ├── 项目模板.md
│   ├── 读书笔记模板.md
│   ├── 任务模板.md
│   └── 记录模板.md
├── create-daily-note.sh      # 创建当日日记
├── vault-git-sync.sh         # Git 同步
├── feishu-notify.sh          # 飞书通知
├── morning-briefing.sh       # 晨间简报
├── evening-reminder.sh       # 晚间提醒
├── llm-chat.sh               # LLM 调用
├── llm-config.json           # LLM 配置
└── feishu-webhook.txt        # 飞书 Webhook
```

---

## ⚙️ 配置步骤

### 1. 配置飞书 Webhook

编辑 `feishu-webhook.txt`，填入你的飞书机器人 Webhook URL

详见：[[README-飞书配置]]

### 2. 配置 LLM API

编辑 `llm-config.json`，填入你的 API 信息：

```json
{
  "base_url": "https://api.openai.com/v1",
  "api_key": "sk-xxx",
  "model": "gpt-4o-mini"
}
```

支持任何 OpenAI 兼容的 API（Claude、Gemini、通义千问等）

### 3. 初始化 Git（已完成）

```bash
cd ~/obsidian-vault
git init
git add .
git commit -m "Initial commit"
```

可选：添加远程仓库进行备份

```bash
git remote add origin https://github.com/yourname/your-vault.git
git push -u origin master
```

### 4. 配置定时任务

详见：[[README-定时任务配置]]

---

## 🚀 快速开始

### 手动测试

```bash
cd ~/obsidian-vault

# 创建今日日记
./create-daily-note.sh

# 发送测试通知
./feishu-notify.sh "测试" "这是一条测试消息"

# 运行晨间简报
./morning-briefing.sh

# 运行晚间提醒
./evening-reminder.sh

# Git 同步
./vault-git-sync.sh
```

### 用 LLM 辅助

```bash
# 总结一篇文章
cat 40-知识库/某篇文章.md | ./llm-chat.sh "用三句话总结这篇文章的核心观点"

# 生成周回顾
cat 10-日记/2026/*.md | ./llm-chat.sh "读取这 7 篇日记，生成一份周回顾"
```

---

## 📌 核心设计理念

1. **收件箱很重要** - 所有临时想法先扔进 00-收件箱，每天整理一次
2. **模板决定使用频率** - 模板越好用，越愿意打开 Obsidian
3. **自动化必须"不需要我启动"** - 人是靠不住的
4. **AI 的价值在总结，不在记录** - 日记自己写，回顾统计交给 AI
5. **Git 是最被低估的个人工具** - 可以看到每一次修改历史
6. **采集成本决定知识库生死** - Web Clipper 把保存动作压缩到一次点击

---

## 🔗 推荐插件

- **Obsidian Web Clipper** - 浏览器剪藏插件
- **Calendar** - 日历视图
- **Templates** - 模板管理
- **Dataview** - 数据查询和统计

---

## 📝 更新日志

- 2026-04-12: 初始版本完成
  - 8 个目录结构
  - 6 个核心模板
  - 5 个自动化脚本
  - Git 版本管理

---

**搭建时间：** 一个下午
**维护成本：** 接近零

> 个人系统的核心不是记录，是反馈。
