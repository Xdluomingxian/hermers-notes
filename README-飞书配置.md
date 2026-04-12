# 飞书 Webhook 配置说明

## 获取飞书机器人 Webhook URL

1. 打开飞书，创建一个新群（可以只有自己）
2. 点击右上角「设置」→「群机器人」
3. 点击「添加机器人」
4. 选择「自定义机器人」
5. 填写机器人名称（如：知识库助手）
6. 勾选「发送消息」权限
7. 点击「完成」
8. 复制 Webhook 地址（格式：https://open.feishu.cn/open-apis/bot/v2/hook/xxxxx）

## 配置 Webhook

将复制的 Webhook URL 写入以下文件：

```
~/obsidian-vault/feishu-webhook.txt
```

**注意：** 只写入 URL，不要有其他内容

## 测试通知

配置完成后，运行以下命令测试：

```bash
cd ~/obsidian-vault
./feishu-notify.sh "测试通知" "这是一条测试消息"
```
