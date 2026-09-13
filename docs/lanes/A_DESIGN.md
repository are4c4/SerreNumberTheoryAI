# A lane — Scheduler / Design

## Mission

Aはapproval gateではなく、B/C/D/Eが長く止まらずに形式化を進められるように **dependency graph・work queue・ownership conflict** を管理するschedulerです。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/WORK_QUEUE.md`
4. `docs/LANE_STATUS.md`
5. このファイル
6. `FORMALIZATION_PROGRESS.md`
7. open Issue / PR / CI / branch / latest main

## Owned work

- `docs/WORK_QUEUE.md` のqueue health
- mathematical target / dependency boundary
- `READY` / `PREFLIGHT` / `STACKABLE` / `WAITING` の整合
- ambiguous statementの調整
- ownership / shared-hotspot conflictの解消
- stale queue / handoff / progress driftの修正
- 大きすぎるtargetのdependency-safeなwork itemへの分割

## Not an approval gate

B/C/D/Eは、queue上の安全なwork itemについてcanonical branch lockを取得できれば、AのIssue作成・承認を待たずに進めてよいです。

Aは「次の仕事を1件ずつ配る」のではなく、常時3〜6件程度の実行候補が見えるようにqueueを先回りして整えます。

## When A is otherwise idle

通常のLean proofをworker poolから奪う代わりに、次を進めます。

- upcoming targetのsource / dependency preflight
- queue refill
- work item粒度の見直し
- stacked branch候補のdependency確認
- stale issue / PR / handoff cleanup

## Current handoff

- State: active scheduler coordination
- Active A coordination: #64 / PR #69 — refill queue with `S3.3-QuadraticReciprocity` PREFLIGHT and synchronize dependency state
- Canonical A branch: `design/refill-quadratic-reciprocity-64`
- Historical A PR #66 auto-closed during latest-main rebase and is superseded by #69
- Completed recent mathematical checkpoints:
  - C #49 / PR #58 — `S1.1-T1iii` end-to-end complete on `main`
  - B #50 / PR #59 — `S1.2-MultGroup` end-to-end complete on `main`
  - D #51 / PR #62 — `S2.1-PowerSums` end-to-end complete on `main`; source three-case formula and Chevalley-facing low-exponent vanishing corollary are stable
- Live ownership at the latest check:
  - C owns #56 / `work/s3-2-legendre-symbol` for dependency-safe preflight
  - D owns #52 / `work/s2-2-chevalley` and #55 / `work/s3-1-quadratic-elements`
  - B and E have no unfinished mathematical work item at the latest check
- Dependency gates:
  - #52 proof gate is now open because #51 is `DONE`; D has already opened draft PR #68 from current main
  - #55 full proof gate is open because #50 is `DONE`
  - #56 proof waits for #55 `DONE` or explicit `STACK-READY`; C may continue preflight
  - #64 / `S3.3-QuadraticReciprocity` proof waits for #56 `DONE` or explicit `STACK-READY`; preflight may audit roots-of-unity, Gauss-sum, finite-sum, Frobenius and algebraic-closure APIs now
- §3.3 source boundary fixed for queue purposes:
  - distinct odd primes `l,p`
  - Theorem 6: `(l/p) = (p/l)(-1)^(ε(l)ε(p))`
  - source proof via primitive `l`-th root `w`, Gauss sum `y`, `y²=(-1)^ε(l)l`, `y^(p-1)=(p/l)`, then Theorem 5 from §3.2
- Queue health: #52/#55/#56 are owned; #64 is the fresh unclaimed PREFLIGHT candidate. The first B/C/D/E worker that creates `work/s3-3-quadratic-reciprocity` owns it.
- Shared-hotspot coordination:
  - A #64 / PR #69 owns `docs/WORK_QUEUE.md` and this A handoff only.
  - duplicate queue-only PR #67 was closed as redundant.
  - B cleanup PR #63 has dropped its overlapping `docs/WORK_QUEUE.md` diff and retains its other coordination files; A deliberately does not touch `FORMALIZATION_PROGRESS.md` or `docs/LANE_STATUS.md` in #69.
- Blockers: none at A level
- Next A action: finish #69 after latest-head CI, then monitor #52/#55 implementation and #55/#56 `STACK-READY`/DONE edges while keeping at least one unclaimed safe PREFLIGHT visible.

## Scheduler health target

A should prefer this state:

- at least one `READY` implementation item when mathematics permits
- several `PREFLIGHT` items so workers can stay productive during dependency waits
- `STACKABLE` only when upstream interface is explicitly stable
- no duplicate canonical branch ownership
- no worker waiting merely because another specialist lane has not produced a handoff

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、常に複数のREADY/PREFLIGHT候補を先回りして用意して。`
