#!/bin/bash

# Ollama 서버 시작
ollama serve &

# Ollama 준비될 때까지 대기
until curl -s http://localhost:11434 > /dev/null 2>&1; do
    sleep 2
done

# 모델 다운로드
ollama pull qwen2.5-coder:7b
ollama pull deepseek-r1:8b

# 서비스 시작
bash /workspace/start.sh