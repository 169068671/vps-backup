curl -O https://raw.githubusercontent.com/your-repo/whisper-test-script.sh
chmod +x whisper-test-script.sh
./whisper-test-script.sh
cat > whisper-test-script.sh << 'EOF'
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
EOF

chmod +x whisper-test-script.sh
./whisper-test-script.sh
# 1. 安装 Python3 和 pip3
apt-get update
apt-get install -y python3 python3-pip
apt-get update && apt-get install -y python3 python3-pip
pip3 install openai-whisper torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
python3 -c "
import whisper
print('🚀 Loading Whisper Small model...')
model = whisper.load_model('small')
print('✅ Model loaded successfully!')

print('🎵 Transcribing test audio...')
result = model.transcribe('jfk.wav')
print('✅ Transcription completed!')
print('📝 Result:', result['text'])
"
# 安装 FFmpeg
apt-get update
apt-get install -y ffmpeg
# 验证 FFmpeg 是否安装成功
ffmpeg -version
# 然后重新运行 Whisper 测试
cd /tmp
python3 -c "
import whisper
print('🚀 Loading Whisper Small model...')
model = whisper.load_model('small')
print('✅ Model loaded successfully!')

print('🎵 Transcribing test audio...')
result = model.transcribe('jfk.wav')
print('✅ Transcription completed!')
print('📝 Result:', result['text'])
"
[200~sudo reboot~
sudo reboot
cd /tmp~
cd /tmp
wget https://github.com/openai/whisper/raw/main/tests/jfk.wav
openclaw tui
