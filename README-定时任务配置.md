# 定时任务配置说明

## Windows 系统（任务计划程序）

### 1. 打开任务计划程序
- 按 `Win + R`，输入 `taskschd.msc`，回车

### 2. 创建基本任务

#### 任务 1：晨间简报（每天 8:00）
- **名称：** 知识库 - 晨间简报
- **触发器：** 每天 8:00
- **操作：** 启动程序
- **程序/脚本：** `bash`
- **添加参数：** `-c "cd /home/gmcc/obsidian-vault && ./morning-briefing.sh"`
- **起始于：** `/home/gmcc/obsidian-vault`

#### 任务 2：晚间提醒（每天 21:00）
- **名称：** 知识库 - 晚间提醒
- **触发器：** 每天 21:00
- **操作：** 启动程序
- **程序/脚本：** `bash`
- **添加参数：** `-c "cd /home/gmcc/obsidian-vault && ./evening-reminder.sh"`
- **起始于：** `/home/gmcc/obsidian-vault`

#### 任务 3：Git 同步（每 4 小时）
- **名称：** 知识库 - Git 同步
- **触发器：** 每天，重复间隔 4 小时
- **操作：** 启动程序
- **程序/脚本：** `bash`
- **添加参数：** `-c "cd /home/gmcc/obsidian-vault && ./vault-git-sync.sh"`
- **起始于：** `/home/gmcc/obsidian-vault`

#### 任务 4：周回顾（每周日 10:00）
- **名称：** 知识库 - 周回顾
- **触发器：** 每周日 10:00
- **操作：** 启动程序
- **程序/脚本：** `bash`
- **添加参数：** `-c "cd /home/gmcc/obsidian-vault && echo '周回顾生成脚本待实现'"`
- **起始于：** `/home/gmcc/obsidian-vault`

---

## Linux 系统（cron）

编辑 crontab：
```bash
crontab -e
```

添加以下任务：
```cron
# 晨间简报 - 每天 8:00
0 8 * * * cd /home/gmcc/obsidian-vault && ./morning-briefing.sh

# 晚间提醒 - 每天 21:00
0 21 * * * cd /home/gmcc/obsidian-vault && ./evening-reminder.sh

# Git 同步 - 每 4 小时
0 */4 * * * cd /home/gmcc/obsidian-vault && ./vault-git-sync.sh

# 周回顾 - 每周日 10:00
0 10 * * 0 cd /home/gmcc/obsidian-vault && echo "周回顾生成脚本待实现"
```

---

## 注意事项

1. **路径问题：** 确保脚本中的路径与实际路径一致
2. **权限问题：** 确保脚本有执行权限（`chmod +x *.sh`）
3. **环境变量：** cron 任务可能需要配置 PATH 环境变量
4. **日志输出：** 可以重定向输出到日志文件便于调试

```bash
# 示例：带日志输出的 cron 任务
0 8 * * * cd /home/gmcc/obsidian-vault && ./morning-briefing.sh >> /tmp/morning-briefing.log 2>&1
```
