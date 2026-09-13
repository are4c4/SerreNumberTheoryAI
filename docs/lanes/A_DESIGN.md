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
- Active A work: #54 — post-activation dependency refinement / queue refill
- Branch: `design/refine-worker-queue-54`
- Mathematical frontier: Theorem 1(ii) cross-layer complete; worker pool has started later slices
- Live ownership at the latest check:
  - C owns #49 / `work/s1-1-t1iii`
  - B owns #50 / `work/s1-2-mult-group`; B preflight independently confirmed no T1(iii) dependency and is proceeding to implementation
  - D owns #51 / `work/s2-1-power-sums`; preflight only until #50 is `DONE` or `STACK-READY`
  - E has no live canonical branch at the latest check
- Queue refinement in #54:
  - #50 promoted semantically to `READY` from current main; Theorem 1(iii) is not a dependency
  - #51 exact hard edge -> #50 cyclicity interface
  - #52 exact hard edge -> #51 power-sum interface
  - #55 `S3.1-QuadraticElements` added as `PREFLIGHT`
  - #56 `S3.2-LegendreSymbol` added as `PREFLIGHT`
  - #49 abstract-isomorphism statement boundary recorded explicitly
- Blockers: none at A level
- Shared hotspots reserved by A while #54 is active: `docs/WORK_QUEUE.md`, `docs/LANE_STATUS.md`, `FORMALIZATION_PROGRESS.md`
- Next safe action: finish #54 synchronization/CI/merge, then monitor canonical branch claims and `STACK-READY` transitions. Do not manually assign unclaimed #52/#55/#56 if workers can atomic-claim them.

## Scheduler health target

A should prefer this state:

- at least one `READY` implementation item when mathematics permits
- several `PREFLIGHT` items so workers can stay productive during dependency waits
- `STACKABLE` only when upstream interface is explicitly stable
- no duplicate canonical branch ownership
- no worker waiting merely because another specialist lane has not produced a handoff

Current intended queue after #54: two independent `READY` fronts (#49, #50) plus four dependency-aware `PREFLIGHT` candidates (#51, #52, #55, #56). Live branch ownership overrides the static table as workers claim them.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、常に複数のREADY/PREFLIGHT候補を先回りして用意して。`
