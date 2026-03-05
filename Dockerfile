FROM pytorch/pytorch:2.7.0-cuda12.8-cudnn9-devel

# apt 패키지 설치
COPY packages.txt .
RUN apt-get update && xargs apt-get install -y < packages.txt \
    && rm -rf /var/lib/apt/lists/*

# Ollama 설치
RUN curl -fsSL https://ollama.com/install.sh | sh

# Open WebUI 설치
RUN pip install open-webui --quiet

# 작업 디렉터리
WORKDIR /workspace

# 파일 복사
COPY prompt.txt .
COPY start.sh .
RUN chmod +x start.sh

# 모델 다운로드 (빌드 시)
RUN ollama serve & sleep 5 && \
    ollama pull qwen2.5-coder:7b && \
    pkill ollama || true

EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]