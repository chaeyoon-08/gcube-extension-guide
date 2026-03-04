#!/bin/bash
# ==============================================
#  GCUBE Extension Guide — Setup Script
#  Ollama + Open WebUI 설치 및 모델 다운로드
#  실행: bash setup.sh
# ==============================================

set -e

echo "======================================"
echo "  🚀 GCUBE Extension Guide Setup"
echo "======================================"

# ----------------------------------------------
# 1. Ollama 설치
# ----------------------------------------------
echo ""
echo "[1/3] Ollama 설치 중..."
curl -fsSL https://ollama.com/install.sh | sh
echo "✅ Ollama 설치 완료"

# ----------------------------------------------
# 2. Open WebUI 설치
# ----------------------------------------------
echo ""
echo "[2/3] Open WebUI 설치 중..."
pip install open-webui --quiet
echo "✅ Open WebUI 설치 완료"

# ----------------------------------------------
# 3. 모델 다운로드 (기본: qwen2.5-coder:7b)
# ----------------------------------------------
echo ""
echo "[3/3] 모델 다운로드 중... (시간이 소요됩니다)"
ollama serve &
OLLAMA_PID=$!
sleep 5
ollama pull qwen2.5-coder:7b
ollama pull deepseek-r1:8b
kill $OLLAMA_PID 2>/dev/null || true
echo "✅ 모델 다운로드 완료"

# ----------------------------------------------
# 완료
# ----------------------------------------------
echo ""
echo "======================================"
echo "  ✅ Setup 완료!"
echo "  이제 아래 명령어로 서비스를 시작하세요:"
echo ""
echo "    bash start.sh"
echo "======================================"