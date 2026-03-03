#!/bin/bash
# Whisper 转录脚本 - 在 VPS 容器中执行

echo "========================================="
echo "Whisper 转录脚本"
echo "========================================="
echo ""

# 检查参数
if [ $# -eq 0 ]; then
    echo "使用方法："
    echo "  bash /root/transcribe.sh <视频文件>"
    echo ""
    echo "示例："
    echo "  bash /root/transcribe.sh /videos/sample.mp4"
    echo ""
    echo "支持的格式："
    echo "  mp3, wav, m4a, flac, ogg, mp4, mkv, avi 等"
    exit 1
fi

VIDEO_FILE=$1

# 检查文件是否存在
if [ ! -f "$VIDEO_FILE" ]; then
    echo "[错误] 文件不存在：$VIDEO_FILE"
    exit 1
fi

# 提取文件名（不含路径）
FILENAME=$(basename "$VIDEO_FILE")
FILENAME_NOEXT="${FILENAME%.*}"

# 输出目录
OUTPUT_DIR="/app/transcripts"

# 确保输出目录存在
mkdir -p "$OUTPUT_DIR"

echo "========================================="
echo "开始转录：$FILENAME"
echo "========================================="
echo ""

# 运行 faster-whisper
docker exec -it whisper-faster \
  python -c "
from faster_whisper import WhisperModel
import sys

# 模型配置
model_size = 'small'  # tiny, base, small, medium, large
language = 'auto'  # auto, zh, en, ...

print(f'[1/3] 加载模型: {model_size}')
model = WhisperModel(model_size, compute_type='int8')

print(f'[2/3] 转录音频: {sys.argv[1]}')
segments, info = model.transcribe(
    sys.argv[1],
    language=language,
    beam_size=5,
    word_timestamps=True
)

print(f'[3/3] 保存转录...')
output_file = f'/app/transcripts/{sys.argv[1]}.txt'

with open(output_file, 'w', encoding='utf-8') as f:
    for segment in segments:
        f.write(f'[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}\n')

print(f'转录完成！')
print(f'输出文件: {output_file}')
print(f'语言: {info.language} (置信度: {info.language_probability:.2f})')
print(f'音频时长: {info.duration:.2f}s')
" "$VIDEO_FILE"

echo ""
echo "========================================="
echo "转录完成"
echo "========================================="
echo ""
echo "输出目录：$OUTPUT_DIR"
echo "输出文件：$OUTPUT_DIR/${FILENAME}.txt"
echo ""
