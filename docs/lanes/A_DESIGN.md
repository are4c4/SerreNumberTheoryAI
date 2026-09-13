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
- Active A coordination: #73 — Chapter 2 p-adic integer preflight refill and live-state synchronization
- Canonical A branch: `design/refill-ch2-zp-73`
- Completed recent scheduler checkpoint:
  - A #64 / PR #69 — §3.3 quadratic-reciprocity PREFLIGHT seed merged; C subsequently atomically claimed `work/s3-3-quadratic-reciprocity`
- Completed recent mathematical checkpoints:
  - C #49 / PR #58 — `S1.1-T1iii` end-to-end complete on `main`
  - B #50 / PR #59 — `S1.2-MultGroup` end-to-end complete on `main`
  - D #51 / PR #62 — `S2.1-PowerSums` end-to-end complete on `main`
- Live ownership at the latest check:
  - B owns #70 / `work/s2-2-chevalley-cor1-nontrivial-zero` for dependency-safe preflight
  - C owns #56 / `work/s3-2-legendre-symbol` and #64 / `work/s3-3-quadratic-reciprocity` as preflights
  - D owns #52 / `work/s2-2-chevalley` (draft PR #68 active) and #55 / `work/s3-1-quadratic-elements`
  - E has no current canonical work item
- Dependency gates:
  - #52 implementation gate is open because #51 is `DONE`
  - #70 proof waits for #52 `DONE` or explicit `STACK-READY`
  - #55 full proof gate is open because #50 is `DONE`
  - #56 proof waits for #55 `DONE` or explicit `STACK-READY`
  - #64 proof waits for #56 `DONE` or explicit `STACK-READY`
- New Chapter 2 capacity:
  - #71 `C2S1.1-ZpConstruction` is a fresh unclaimed `PREFLIGHT`. It is mathematically independent of the active Chapter 1 theorem chain and may stabilize the `A_n = ℤ/p^nℤ` inverse-limit representation, ring/topology structure, and canonical integer embedding from current main.
  - #72 `C2S1.2-ZpProperties` is a fresh unclaimed `PREFLIGHT`. Its proof implementation must wait for #71 `DONE`/`STACK-READY`, but source/API/theorem-strength preflight may run now.
- Queue health: B/C/D each own work; E is available; #71 and #72 provide independent unclaimed preflight capacity without stealing another lane's branch.
- Shared hotspots reserved by A while #73 is active: `docs/WORK_QUEUE.md`, `docs/LANE_STATUS.md`, and this A handoff only. Worker implementation files and worker-specific handoffs remain untouched.
- Blockers: none at A level
- Next A action: merge #73 after CI and final hotspot check, then monitor #52/#55 implementation, #70/#56/#64 dependency transitions, and Chapter 2 claims. Refill again only when unclaimed executable/preflight capacity becomes thin.

## Scheduler health target

A should prefer this state:

- at least one `READY` implementation item when mathematics permits
- several `PREFLIGHT` items so workers can stay productive during dependency waits
- `STACKABLE` only when upstream interface is explicitly stable
- no duplicate canonical branch ownership
- no worker waiting merely because another specialist lane has not produced a handoff

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、常に複数のREADY/PREFLIGHT候補を先回りして用意して。`
