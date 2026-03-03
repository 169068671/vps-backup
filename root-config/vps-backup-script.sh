#!/bin/bash

# VPS 自动备份脚本
# 备份到 GitHub: https://github.com/169068671/vps-backup

BACKUP_DIR="/vps-backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="/var/log/vps-backup.log"

echo "[$DATE] Starting VPS backup..." >> $LOG_FILE

# 进入备份目录
cd $BACKUP_DIR || exit 1

# 复制需要备份的文件
echo "[$DATE] Copying files..." >> $LOG_FILE
cp -r /root/guacamole*.yml /root/init.sql $BACKUP_DIR/ 2>/dev/null
cp /etc/ssh/sshd_config $BACKUP_DIR/ 2>/dev/null

# 添加到 Git
git add .

# 检查是否有变化
if git diff --cached --quiet; then
    echo "[$DATE] No changes to backup." >> $LOG_FILE
    exit 0
fi

# 提交更改
git commit -m "Auto backup - $DATE"

# 推送到 GitHub
git push origin main

echo "[$DATE] Backup completed successfully." >> $LOG_FILE
