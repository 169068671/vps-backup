#!/bin/bash
# Whisper 测试脚本 - CPU 版本

echo "========================================="
echo "Whisper 测试脚本"
echo "========================================="
echo ""

# 检查 GPU
echo "[1/5] 检查 GPU 支持..."
if command -v nvidia-smi &> /dev/null; then
    echo "✅ 发现 NVIDIA GPU"
    nvidia-smi --query-gpu=name --format=csv,noheader,nounits
    IMAGE="guillaumekln/faster-whisper-gpu:latest"
    COMPUTE_TYPE="float16"
else
    echo "⏸️ 未发现 GPU，使用 CPU"
    IMAGE="guillaumekln/faster-whisper:latest"
    COMPUTE_TYPE="int8"
fi

echo ""
echo "[2/5] 检查 Docker..."
docker --version

echo ""
echo "[3/5] 准备目录..."
mkdir -p /root/videos
mkdir -p /root/transcripts
mkdir -p /root/models
echo "✅ 目录已创建"

echo ""
echo "[4/5] 拉取镜像..."
docker pull $IMAGE

echo ""
echo "[5/5] 运行测试..."
docker run --rm \
  -v /root/videos:/videos \
  -v /root/transcripts:/transcripts \
  -v /root/models:/root/.cache/huggingface \
  -e MODEL_SIZE=small \
  -e LANGUAGE=auto \
  -e COMPUTE_TYPE=$COMPUTE_TYPE \
  $IMAGE \
  /app/whisper.py --help

echo ""
echo "========================================="
echo "测试完成"
echo "========================================="
echo ""
echo "镜像信息："
echo "  镜像: $IMAGE"
echo "  计算类型: $COMPUTE_TYPE"
echo ""
echo "目录："
echo "  视频: /root/videos"
echo "  转录: /root/transcripts"
echo "  模型: /root/models"
echo ""
echo "使用方法："
echo "  1. 将视频文件上传到 /root/videos 目录"
echo "  2. 运行转录命令"
echo ""
