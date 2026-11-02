# 작업 규칙: Claude Code + Codex 역할 분담

- **Claude Code**가 구현한다(코드 작성, 수정, 커밋).
- **Codex**는 검토자다. `codex-plugin-cc` 플러그인으로 호출하며 리뷰는 읽기 전용이라 파일을 고치지 않는다.

## 언제 무엇을 쓰나
1. 변경을 마무리하기 전에 `/codex:review`를 실행한다. 여러 파일이거나 오래 걸릴 것 같으면 `--background`로 돌리고 `/codex:status`, `/codex:result`로 확인한다.
2. 설계나 위험 지점이 걱정되면 `/codex:adversarial-review`를 쓴다. 초점을 문장으로 덧붙일 수 있다(예: `... 데이터 유실 가능성을 따져줘`).
3. 막혔거나 원인 조사가 길어지면 `/codex:rescue`로 Codex 서브에이전트에게 넘긴다. 큰 작업은 `--background`.
4. 브랜치 전체를 볼 때는 `--base main`을 쓴다.

## 지킬 것
- Codex의 지적은 그대로 적용하지 않는다. 타당한지 먼저 판단하고, 반영한 것과 안 한 것을 이유와 함께 기록한다.
- 리뷰 게이트(`--enable-review-gate`)는 켜지 않는다. 켜면 Claude/Codex 루프로 사용량이 빠르게 소모될 수 있다.
- 로그인 정보(`~/.codex/auth.json`)와 토큰은 커밋하지 않는다.
