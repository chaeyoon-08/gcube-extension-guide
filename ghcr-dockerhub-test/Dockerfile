FROM pytorch/pytorch:2.7.0-cuda12.8-cudnn9-devel

# apt 패키지 설치
COPY packages.txt .
RUN apt-get update && xargs apt-get install -y < packages.txt \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /workspace

# entrypoint 스크립트 복사 및 실행 권한 부여
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]