# GCUBE VS Code Extension 사용 가이드 - Ollama + Open WebUI

## 0. 개요

- **Ollama란?**
  - LLM을 실행하고 관리할 수 있도록 지원하는 플랫폼
  - 로컬 환경에서 오픈소스 언어 모델을 다운 받고 사용해 볼 수 있음
  - 대표적인 언어 모델은 다음과 같다
    - Qwen2.5-Coder: Alibaba Cloud에서 개발한 코딩 특화 모델로, 코드 생성 및 디버깅 성능이 우수
    - Llama3.1: Meta에서 개발한 최신 언어 모델로, 자연어 처리 성능이 우수
    - DeepSeek-R1: DeepSeek AI에서 개발한 추론 특화 모델로, 단계적 사고 과정을 보여줌

- **Open WebUI란?**
  - Ollama와 연동하여 사용할 수 있는 웹 기반 채팅 인터페이스
  - ChatGPT와 유사한 UI로 손쉽게 LLM을 사용할 수 있음
  - 모델 선택, 시스템 프롬프트 설정 등 다양한 기능을 제공

- **이 가이드에서 다루는 내용**
  - GCUBE VS Code Extension 환경에서 Ollama + Open WebUI 배포
  - 모델 추가 / 교체 / 삭제 커스터마이징
  - 시스템 프롬프트 설정 (`prompt.txt` 파일 기반)
  - 변경 사항을 본인 GitHub 계정에 Push

---

## 1. GCUBE 플랫폼 워크로드 서비스 등록 절차

- 워크로드 생성 및 배포
  - gcube.ai 접속 및 워크로드 페이지 이동
  - 새 워크로드 등록 시 아래 설정값 입력

| 항목 | 값 |
|------|-----|
| 컨테이너 이미지 | `pytorch/pytorch:2.7.0-cuda12.8-cudnn9-devel` |
| 저장소 유형 | 도커허브 |
| 컨테이너 포트 | `8080` |
| 컨테이너 명령 | `/bin/bash -c "apt-get update && apt-get install -y git curl && sleep infinity"` |
| 환경변수 | `OLLAMA_HOST` = `0.0.0.0:11434` |
| 환경변수 | `OPEN_WEBUI_PORT` = `8080` |
| GPU | RTX 4080S x 1 |
| GPU 메모리 | 16GB |

- 워크로드 배포 완료 후 Running 상태 확인

---

## 2. VS Code Extension 터미널 접속

- GCUBE VS Code Extension에서 배포된 워크로드 확인
- 워크로드 선택 후 터미널 접속

---

## 3. 저장소 Clone 및 서비스 실행

- 아래 명령어를 순서대로 실행

```bash
# 저장소 Clone
git clone https://github.com/Data-Alliance/gcube-extension-guide.git
cd gcube-extension-guide

# Ollama + Open WebUI 설치 및 모델 다운로드
bash setup.sh

# 서비스 시작
bash start.sh
```

- `setup.sh` 실행 시 Ollama, Open WebUI 설치 및 모델 다운로드가 자동으로 진행됨
  - 처음 실행 시 수~수십 분이 소요될 수 있음
  - 다음 실행부터는 `bash start.sh`만 실행하면 됨

- 서비스 시작 후 GCUBE 워크로드의 서비스 URL (포트 8080) 로 브라우저 접속

---

## 4. 커스터마이징

### 4-1. 모델 추가

- `setup.sh`에 원하는 모델의 `ollama pull` 명령어를 추가

```bash
# setup.sh
ollama pull qwen2.5-coder:7b   # 기본 모델
ollama pull llama3.1:8b        # 추가 모델
```

- 사용 가능한 모델 목록: [ollama.com/library](https://ollama.com/library)

### 4-2. 모델 교체

- `setup.sh` 내 기존 모델 라인을 원하는 모델명으로 변경

```bash
# 기존
ollama pull qwen2.5-coder:7b

# 교체 후
ollama pull deepseek-r1:8b
```

### 4-3. 모델 삭제

- `setup.sh`에서 해당 줄을 제거하고, 터미널에서 아래 명령어 실행

```bash
ollama rm qwen2.5-coder:7b
```

### 4-4. 시스템 프롬프트 수정

- `prompt.txt` 파일을 열어 원하는 내용으로 수정
- `start.sh` 실행 시 `prompt.txt`를 자동으로 읽어 Open WebUI에 적용됨
- 수정 후 GitHub에 Push해두면 컨테이너 재시작 후에도 동일한 프롬프트가 유지됨

**기본 프롬프트**

```
You are a helpful, accurate, and professional AI assistant.
You provide clear explanations, well-structured code, and practical solutions.
You support both Korean and English and respond in the same language as the user.
```

**연구 목적 커스텀 프롬프트 예시**

```
You are an expert AI assistant specializing in scientific research support.
Your role is to assist researchers with data analysis, experiment design,
literature review, and technical problem solving.
Provide precise, evidence-based responses. When writing code, prioritize
readability and include comments for reproducibility.
You support both Korean and English and respond in the same language as the user.
```

> Open WebUI 웹 UI의 Admin Panel에서 직접 수정한 프롬프트는 컨테이너 재시작 시 초기화되므로 권장하지 않음

---

## 5. 변경 사항 GitHub에 Push

- 커스터마이징 작업 후 본인 GitHub 계정에 반영

```bash
# Git 사용자 정보 설정 (최초 1회)
git config --global user.name "본인 GitHub 사용자명"
git config --global user.email "본인 GitHub 이메일"

# remote를 본인 레포로 변경
git remote set-url origin https://본인계정@github.com/본인계정/gcube-extension-guide.git

# 변경 사항 확인
git status
git diff

# Commit 및 Push
git add .
git commit -m "feat: 모델 추가 및 시스템 프롬프트 수정"
git push origin main
```

- Push 완료 후 브라우저에서 본인 GitHub 레포지토리에 접속하여 커밋 반영 여부 확인

---

## 6. 컨테이너 재시작 시 주의사항

- GCUBE 워크로드 컨테이너를 내렸다가 다시 올리면 컨테이너 내부의 모든 데이터가 초기화됨
  - 설치된 Ollama 및 Open WebUI
  - 다운로드된 모델 파일
  - Open WebUI 웹 UI에서 수정한 설정 (시스템 프롬프트, 사용자 정보 등)
- 커스터마이징 내용은 반드시 `setup.sh`, `start.sh`, `prompt.txt`에 반영하고 GitHub에 Push해두어야 함
- 이후 컨테이너 재시작 시 `git clone` 후 동일한 환경을 복원할 수 있음

---

## 7. 프로젝트 구조

```
gcube-extension-guide/
├── README.md        # 프로젝트 설명 및 가이드 (현재 파일)
├── .gitignore       # 민감한 파일 제외 설정
├── setup.sh         # Ollama + Open WebUI 설치 + 모델 다운로드
├── start.sh         # 서비스 시작 스크립트 (prompt.txt 자동 로드)
└── prompt.txt       # 시스템 프롬프트 설정 파일
```