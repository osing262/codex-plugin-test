# Codex 플러그인 클라우드 구성 (SETUP)

Claude Code 클라우드에서 `openai/codex-plugin-cc`를 쓰기 위한 구성이에요.
2026-11-02에 클라우드 샌드박스에서 검증한 내용과 아직 검증하지 못한 내용을 구분해서 적었어요.

## 검증된 것
- `npm i -g @openai/codex` → codex-cli 0.166.0
- `claude plugin marketplace add openai/codex-plugin-cc` → 마켓플레이스 `openai-codex`
- `claude plugin install codex@openai-codex` → codex v1.0.6 (user 스코프)
- `codex login --device-auth` → ChatGPT 로그인 성공
- 플러그인 setup 스크립트: `ready: true`, 리뷰 게이트 꺼짐
- `review`, `adversarial-review`가 실제로 동작하고 findings 반환

## 검증하지 못한 것
- 슬래시 명령(`/reload-plugins`, `/codex:setup` 등)은 대화형 세션에서 직접 실행하지 못했어요.
  대신 플러그인의 `codex-companion.mjs`를 같은 인자로 직접 호출해서 동작을 확인했어요.
- 새 세션에서 `~/.codex/auth.json`이 남아 있는지는 확인하지 못했어요.
- `.claude/settings.json`의 플러그인 선언이 새 클라우드 세션에서 자동 설치되는지는 확인하지 못했어요.

## 1. 플러그인 선언
`.claude/settings.json`에 마켓플레이스와 플러그인을 선언해요(이 레포에 포함됨).
수동으로 할 때는 다음 순서예요.
```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

## 2. 셋업 스크립트
환경의 셋업 스크립트에 `scripts/cloud-setup.sh`를 지정해요. Codex CLI를 설치하고 로그인 상태를 출력해요.
네트워크 정책에서 `api.openai.com`, `auth.openai.com`을 허용해야 해요. `chatgpt.com` 루트는 403이었어요.

## 3. 로그인 유지
컨테이너는 임시라서 `~/.codex/auth.json`이 세션이 바뀌면 사라질 수 있어요.

| 방법 | 장점 | 단점 |
|---|---|---|
| 매번 `codex login --device-auth` | 가장 안전 | 세션마다 일회용 코드 입력(15분 만료) |
| `auth.json`을 환경 시크릿 `CODEX_AUTH_JSON`에 저장 후 복원 | 자동화 가능 | 계정 토큰이라 민감함. 토큰이 갱신되면 저장본이 무효가 될 수 있음(미검증) |
| API 키 | 가장 안정적 | 이 프로젝트에서는 쓰지 않기로 함 |

시크릿 값을 레포에 커밋하지 마세요.

## 4. 리뷰 게이트
`--enable-review-gate`는 켜지 않았어요. 켜면 종료 시마다 Codex 리뷰가 돌아 사용량이 늘어요.

## 알려진 경고
- bubblewrap 경고가 나오지만 번들 버전으로 동작해요.
