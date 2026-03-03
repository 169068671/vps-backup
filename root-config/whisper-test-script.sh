#!/bin/bash
echo "🚀 Starting Whisper Small Model Test..."
echo "======================================="

# 检查 Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Installing..."
    apt-get update && apt-get install -y python3 python3-pip
fi

# 安装 whisper 如果未安装
if ! python3 -c "import whisper" &> /dev/null; then
    echo "📦 Installing openai-whisper..."
    pip3 install openai-whisper
fi

# 下载测试音频
echo "🎵 Downloading test audio file..."
cd /tmp
wget -q https://github.com/openai/whisper/raw/main/tests/jfk.wav

if [ ! -f "jfk.wav" ]; then
    echo "❌ Failed to download test audio"
    exit 1
fi

# 测试 Whisper Small 模型
echo "🧠 Testing Whisper Small model..."
python3 -c "
import whisper
import time
print('Loading Whisper Small model...')
start = time.time()
model = whisper.load_model('small')
load_time = time.time() - start
print(f'Model loaded in {load_time:.2f} seconds')

print('Transcribing test audio...')
start = time.time()
result = model.transcribe('jfk.wav')
transcribe_time = time.time() - start
print(f'✅ Transcription completed in {transcribe_time:.2f} seconds')
print('📝 Result:', result['text'])
"

echo "======================================="
echo "🎉 Test completed!"
