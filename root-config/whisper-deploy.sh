#!/bin/bash
# Whisper 部署脚本 - rotemb/whisper

echo "========================================="
echo "Whisper 部署脚本 - rotemb/whisper"
echo "========================================="
echo ""

# 检查 GPU
echo "[1/6] 检查 GPU 支持..."
if command -v nvidia-smi &> /dev/null; then
    echo "✅ 发现 NVIDIA GPU"
    nvidia-smi --query-gpu=name --format=csv,noheader,nounits
    IMAGE="rotemb/whisper-gpu:latest"
    COMPUTE_TYPE="float16"
else
    echo "⏸️ 未发现 GPU，使用 CPU"
    IMAGE="rotemb/whisper-cpu:latest"
    COMPUTE_TYPE="int8"
fi

echo ""
echo "[2/6] 停止旧容器..."
docker stop whisper-rotemb 2>/dev/null
docker rm whisper-rotemb 2>/dev/null
echo "✅ 旧容器已停止并删除"

echo ""
echo "[3/6] 准备目录..."
mkdir -p /root/videos
mkdir -p /root/transcripts
mkdir -p /root/models
echo "✅ 目录已创建"

echo ""
echo "[4/6] 拉取镜像..."
docker pull $IMAGE

echo ""
echo "[5/6] 运行测试..."
docker run --rm \
  -v /root/videos:/videos \
  -v /root/transcripts:/transcripts \
  -v /root/models:/root/.cache \
  $IMAGE \
  /app/whisper.py --help

echo ""
echo "[6/6] 创建 Docker Compose 配置..."
cat > /root/whisper-rotemb-compose.yml << 'EOF'
version: '3.8'

services:
  whisper:
    image: $IMAGE
    container_name: whisper-rotemb
    restart: unless-stopped
    environment:
      - ASR_MODEL=${MODEL_NAME:-Systran/faster-whisper-small}
      - ASR_ENGINE=openai-whisper
      - WHISPER_MODEL_SIZE=${MODEL_SIZE:-small}
      - WHISPER_LANGUAGE=${LANGUAGE:-auto}
      - WHISPER_TASK=${TASK:-transcribe}
      - WHISPER_THREADS=4
    volumes:
      - ./videos:/videos
      - ./transcripts:/transcripts
      - ./models:/root/.cache
    ports:
      - "9000:9000"
    networks:
      - whisper-net

networks:
  whisper-net:
    driver: bridge
EOF

echo "✅ Docker Compose 配置已创建"
echo ""
echo "========================================="
echo "部署完成"
echo "========================================="
echo ""
echo "镜像信息："
echo "  镜像: $IMAGE"
echo "  计算类型: $COMPUTE_TYPE"
echo "  模型: ${MODEL_NAME:-Systran/faster-whisper-small}"
echo "  模型大小: ${MODEL_SIZE:-small}"
echo ""
echo "目录："
echo "  视频: /root/videos"
echo "  转录: /root/transcripts"
echo "  模型: /root/models"
echo ""
echo "使用方法："
echo "  1. 将视频文件上传到 /root/videos 目录"
echo "  2. 访问 http://76.13.219.143:9000"
echo "  3. 选择视频文件和转录参数"
echo "  4. 点击开始转录"
echo ""
