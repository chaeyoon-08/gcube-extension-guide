#!/bin/bash

echo "================================================"
echo "  gcube Base Image Entrypoint"
echo "================================================"

# 필수 환경변수 검증
MISSING_VARS=0
for VAR in GIT_USER_NAME GIT_USER_EMAIL GIT_TOKEN; do
    if [ -z "${!VAR}" ]; then
        echo "❌ 필수 환경변수 누락: $VAR"
        MISSING_VARS=1
    fi
done

if [ $MISSING_VARS -eq 1 ]; then
    echo "❌ 필수 환경변수가 설정되지 않았습니다. 컨테이너를 종료합니다."
    exit 1
fi

# Git 초기화
echo "[1/3] Git 초기화 중..."
git init /workspace
echo "✅ git init 완료"

# Git 사용자 설정
echo "[2/3] Git 사용자 설정 중..."
git config --global user.name "$GIT_USER_NAME"
echo "✅ user.name: $GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
echo "✅ user.email: $GIT_USER_EMAIL"

# Git 인증 설정
echo "[3/3] Git 인증 설정 중..."
git config --global credential.helper store
echo "https://$GIT_USER_NAME:$GIT_TOKEN@github.com" > ~/.git-credentials
echo "✅ GitHub 인증 설정 완료"

echo "================================================"
echo "  설정 완료! 컨테이너를 시작합니다."
echo "================================================"

# 커맨드가 있으면 백그라운드 실행
if [ $# -gt 0 ]; then
    "$@" &
fi

# 컨테이너 항상 유지
tail -f /dev/null