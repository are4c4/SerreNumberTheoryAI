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

通常のLean proofをworker poolから奪う代わりに、upcoming targetのsource/dependency preflight、queue refill、work-item粒度の見直し、stack候補のdependency確認、stale state cleanupを進めます。

## Current handoff

- State: active scheduler coordination
- Active A coordination: #81 / PR #83 — post-Chevalley synchronization and parallel-capacity refill
- Canonical A branch: `design/sync-post-chevalley-refill-81`
- Completed recent mathematical checkpoints:
  - #49 / PR #58 — `S1.1-T1iii` DONE
  - #50 / PR #59 — `S1.2-MultGroup` DONE
  - #51 / PR #62 — `S2.1-PowerSums` DONE
  - #52 / PR #68 — core `S2.2-Chevalley` DONE on main with green policy/build/vbp
- Live ownership at the latest check:
  - D owns #55 / `work/s3-1-quadratic-elements` / draft PR #82; implementation is underway
  - C owns #56 / `work/s3-2-legendre-symbol`; proof remains gated on #55 interface
  - C also owns #64 / `work/s3-3-quadratic-reciprocity`; the focused issue was reopened after scheduler PR #69 had auto-closed it
  - B and E have no unfinished mathematical ownership at this checkpoint
- #55 CI routing:
  - PR #82 head `141673eb…` passed repository policy but failed `lake build` in `QuadraticElements.lean`
  - A routed the concrete errors to D: the `Nat.card`-dependent half-power definition needs noncomputable handling, and the current Frobenius-surjectivity term has an unwanted `∀ e : K ≃ K` shape
  - this is D-local implementation repair, not an A-level statement/dependency blocker; A will not edit the worker branch
- Refined downstream gates:
  - #56 needs #55's half-power `{±1}` / square-kernel interface `DONE` or `STACK-READY`
  - #64 does not need all of Theorem 5 before stacking; the minimal #56 subset is the sign layer, multiplicativity, Theorem 5(ii) at `-1`, and cross-characteristic sign compatibility. Theorem 5(iii) at `2` is not required for §3.3.
- Queue refill prepared by A:
  - #84 `S2.2-Chevalley-Cor1` — fresh unclaimed READY item. Core #52 is DONE; the source proof is the cardinality contradiction excluding `V={0}`
  - #85 `S2.2-Chevalley-Cor2` — fresh unclaimed PREFLIGHT; source is the quadratic-form specialization of #84, so proof waits for #84 `DONE`/`STACK-READY`
  - #78 `C1-Supp-GaussLemma` — fresh unclaimed PREFLIGHT; depends on the minimal #56 Legendre/half-power interface but not on #64
  - #79 `C2.1.1-ZpInverseLimit` — fresh unclaimed PREFLIGHT for Chapter 2 §1.1; independent of the Chapter 1 quadratic-residue dependency chain
- Source boundaries checked independently from the uploaded Japanese edition:
  - #84/#85: §2.2 Corollaries 1/2, printed p.7 / uploaded PDF p.17
  - #78: Chapter 1 supplement (i), printed pp.12–13 / uploaded PDF pp.22–23
  - #79: Chapter 2 §1.1, printed pp.15–16 / uploaded PDF pp.25–26, ending before §1.2 Proposition 1
- Shared-hotspot coordination:
  - A #81 / PR #83 owns `docs/WORK_QUEUE.md`, `docs/LANE_STATUS.md`, `FORMALIZATION_PROGRESS.md`, and this A handoff
  - open C docs-only PR #76 touches only `docs/lanes/C_BLUEPRINT.md`, so there is no overlap
  - D PR #82 touches worker mathematical artifacts and is likewise disjoint from A central files
  - A does not modify worker Lean/Blueprint mathematical artifacts
- Blockers: none at A level
- Next A action: merge #83 after latest-head CI and final hotspot check; then monitor #55 for a stable interface, #56/#64 stack transitions, and claims of #84/#85/#78/#79. Refill again before executable capacity becomes thin.

## Scheduler health target

A should prefer this state:

- at least one `READY` implementation item when mathematics permits
- several `PREFLIGHT` items so workers can stay productive during dependency waits
- `STACKABLE` only when upstream interface is explicitly stable
- no duplicate canonical branch ownership
- no worker waiting merely because another specialist lane has not produced a handoff

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、常に複数のREADY/PREFLIGHT候補を先回りして用意して。`
