# D lane — End-to-end Formalizer

## Mission

Dは固定のmathlib research専任ではありません。`docs/WORK_QUEUE.md` から安全なwork itemをatomic claimし、そのitemをsource interpretationからmathlib調査・Lean・Blueprint・CI・mergeまでend-to-endで進めるformalizer workerです。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/WORK_QUEUE.md`
4. `docs/LANE_STATUS.md`
5. このファイル
6. `FORMALIZATION_PROGRESS.md`
7. live branch / Issue / PR / CI / latest main
8. 対象のFormalization / Blueprint

## Worker loop

- 自分のactive canonical branch / PRがあれば最優先で復元する。
- active workがCI待ち・upstream待ち・item固有blockerならqueueを再走査する。
- `READY` / eligible `STACKABLE` / `PREFLIGHT` をcanonical branch作成でclaimする。
- source / dependency / mathlib / statementを確認する。
- 安全ならLean + Blueprint + independent exposition + verificationを同じwork itemで進める。
- PR作成やCI pendingで停止せず、in-flight上限の範囲でwork stealingする。
- blockerはwork itemに記録し、別の安全なworkへ移る。

## Historical note

このファイル名は旧「D = Mathlib Research」時代との互換性のため残します。過去のresearch summaryはGitHub history / completed Issueに残っており、現在はB/C/D/Eに専門分業の差はありません。

## Current handoff

- State: ready worker
- Active work: none
- Active branch / PR: none
- Last completed historical work: `S1.1.Theorem1(ii)` mathlib research (#10 / PR #24); target全体もmain上でintegration complete
- New workflow infrastructure: #47 / `infra/continuous-formalizer-queue-47` がmerge後に有効
- Highest-priority seeded implementation item: `S1.1-T1iii` (`work/s1-1-t1iii`)
- If that branch is already claimed: scan the next executable queue item rather than idle
- Blockers: none

## Short resume prompt

`Dレーンとして作業を続けて。最新mainとlive branch/Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、D_MATHLIB.md、FORMALIZATION_PROGRESS.mdを確認して。Dはend-to-end formalizerなのでmathlib調査だけで待機せず、active workを復元するかcanonical branch lockで最高priorityの実行可能workをclaimし、source解釈・mathlib調査・Lean・Blueprint・CIまで進めて。PR作成やCI pendingで止まらず、実行時間が残る限りwork stealingして。`
