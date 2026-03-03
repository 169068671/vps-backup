#!/bin/bash

# VPS 完整备份脚本
# 备份到 GitHub: https://github.com/169068671/vps-backup

BACKUP_DIR="/vps-backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="/var/log/vps-backup.log"

echo "[$DATE] Starting VPS full backup..." >> $LOG_FILE

cd $BACKUP_DIR || exit 1

# 创建目录结构
mkdir -p {root-config,etc-config,docker-volumes,system-info}

# 备份 root 目录
echo "[$DATE] Backing up /root..." >> $LOG_FILE
rsync -av --exclude='.cache' --exclude='*.log' --exclude='*.tmp' \
  /root/ root-config/ 2>/dev/null

# 备份关键系统配置
echo "[$DATE] Backing up /etc configs..." >> $LOG_FILE
cp /etc/ssh/sshd_config etc-config/ 2>/dev/null
cp /etc/hosts etc-config/ 2>/dev/null
cp /etc/hostname etc-config/ 2>/dev/null
cp /etc/fstab etc-config/ 2>/dev/null

# 备份 Docker Compose 文件
echo "[$DATE] Backing up Docker configs..." >> $LOG_FILE
find /root -maxdepth 1 -name "*.yml" -exec cp {} . \; 2>/dev/null
find /root -maxdepth 1 -name "*.yaml" -exec cp {} . \; 2>/dev/null

# 备份系统信息
echo "[$DATE] Collecting system info..." >> $LOG_FILE
uptime > system-info/uptime.txt 2>/dev/null
df -h > system-info/disk-usage.txt 2>/dev/null
free -h > system-info/memory.txt 2>/dev/null
uname -a > system-info/kernel.txt 2>/dev/null

# 备份 MySQL 数据库
echo "[$DATE] Backing up MySQL database..." >> $LOG_FILE
docker exec guacamole-mysql mysqldump -u guacamole_user -pguacamole_password \
  guacamole_db > docker-volumes/guacamole-db-backup.sql 2>/dev/null

# Git 操作
echo "[$DATE] Git add..." >> $LOG_FILE
git add .

# 检查是否有变化
if git diff --cached --quiet; then
    echo "[$DATE] No changes to backup." >> $LOG_FILE
    exit 0
fi

# 提交更改
git commit -m "Full VPS backup - $DATE"

# 推送到 GitHub
git push origin main

echo "[$DATE] VPS backup completed successfully." >> $LOG_FILE
