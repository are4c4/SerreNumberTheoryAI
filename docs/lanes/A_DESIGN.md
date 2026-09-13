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

- State: ready scheduler; no active A mathematical implementation or scheduler deliverable after completed #54 / PR #57
- Mathematical frontier: Theorem 1(ii) cross-layer complete; later slices are now owned by the worker pool
- Completed latest A coordination checkpoint:
  - #54 / PR #57 — refined actual source dependencies, seeded #55/#56, synchronized live claims, and extended future §3 progress; latest-head CI green and merged
- Live ownership at the latest check:
  - C owns #49 / `work/s1-1-t1iii` / draft PR #58; semantic target is abstract uniqueness up to isomorphism
  - B owns #50 / `work/s1-2-mult-group` / draft PR #59; source/dependency preflight confirmed Theorem 1(iii) is not required
  - D owns #51 / `work/s2-1-power-sums`, #52 / `work/s2-2-chevalley`, and #55 / `work/s3-1-quadratic-elements` as dependency-safe preflights
  - E has no live canonical branch at the latest check
- Queue capacity:
  - #56 `S3.2-LegendreSymbol` — unclaimed `PREFLIGHT`
  - next refill candidate when depth drops: §3.3 quadratic reciprocity
- Dependency gates:
  - #51 proof waits for #50 `DONE` or explicit `STACK-READY`
  - #52 proof waits for #51 `DONE` or explicit `STACK-READY`
  - #55 odd-characteristic proof is expected to use #50 cyclicity; D may refine the exact interface in preflight now
  - #56 proof waits for the required #55 interface
- Current worker PR state: #58 and #59 are active draft implementation PRs; each worker owns its own CI repair and end-to-end completion
- Blockers: none at A level
- Shared hotspots reserved by A: none after this post-merge handoff synchronization lands
- Next A action: monitor live canonical claims, queue depth, worker-published `STACK-READY` interfaces, and any statement/ownership/shared-hotspot blocker routed to A. Do not take worker proof implementation.

## Scheduler health target

A should prefer this state:

- at least one `READY` implementation item when mathematics permits
- several `PREFLIGHT` items so workers can stay productive during dependency waits
- `STACKABLE` only when upstream interface is explicitly stable
- no duplicate canonical branch ownership
- no worker waiting merely because another specialist lane has not produced a handoff

Current queue has two active implementation fronts (#49/#50), three owned preflights (#51/#52/#55), and one unclaimed preflight (#56). This remains healthy queue depth; do not create extra work merely to keep A busy.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、常に複数のREADY/PREFLIGHT候補を先回りして用意して。`
