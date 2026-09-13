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

- State: ready scheduler; no A mathematical implementation deliverable
- Active A coordination: #60 / PR #61 is the final docs-only cleanup after #54 / PR #57; merge once latest-head CI is green
- Completed latest mathematical worker checkpoint:
  - C #49 / PR #58 — `S1.1-T1iii` end-to-end formalization merged; abstract uniqueness up to isomorphism is now complete on `main`
- Live ownership at the latest check:
  - B owns #50 / `work/s1-2-mult-group` / draft PR #59
  - C owns #56 / `work/s3-2-legendre-symbol` for dependency-safe preflight after completing #49
  - D owns #51 / `work/s2-1-power-sums`, #52 / `work/s2-2-chevalley`, and #55 / `work/s3-1-quadratic-elements` as dependency-safe preflights
  - E has no live canonical branch at the latest check
- Dependency gates:
  - #51 proof waits for #50 `DONE` or explicit `STACK-READY`
  - #52 proof waits for #51 `DONE` or explicit `STACK-READY`
  - #55 preflight confirms the characteristic-2 half is independent of #50, while the full odd-characteristic/index-2 theorem has a hard edge to #50 cyclicity; no dependent proof code should land before `DONE`/`STACK-READY`
  - #56 proof waits for the required #55 interface; C may continue source/dependency/mathlib preflight meanwhile
- Queue health: all currently seeded items #50/#51/#52/#55/#56 are owned. This means A should prepare the next refill candidate rather than assume E can claim an existing row.
- Next refill candidate: §3.3 quadratic reciprocity. Add only a dependency-safe `PREFLIGHT` seed after checking the exact source boundary and whether its implementation depends on #56 or a narrower earlier interface.
- Blockers: none at A level
- Shared hotspots reserved by A while #60 / PR #61 is active: `docs/LANE_STATUS.md`, `docs/lanes/A_DESIGN.md`; do not overlap worker implementation files
- Next A action: finish #61, then preflight/refill the queue so at least one unclaimed safe item is visible for E without stealing B/C/D work.

## Scheduler health target

A should prefer this state:

- at least one `READY` implementation item when mathematics permits
- several `PREFLIGHT` items so workers can stay productive during dependency waits
- `STACKABLE` only when upstream interface is explicitly stable
- no duplicate canonical branch ownership
- no worker waiting merely because another specialist lane has not produced a handoff

The current queue has one active implementation front (#50) plus four owned downstream preflights (#51/#52/#55/#56). Because there is no unclaimed seeded item at the latest check, A should now refill one dependency-safe future preflight rather than create proof work speculatively.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、常に複数のREADY/PREFLIGHT候補を先回りして用意して。`
