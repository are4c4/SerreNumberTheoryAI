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

- queue health / dependency graph
- `READY` / `PREFLIGHT` / `STACKABLE` / `WAITING` の整合
- ambiguous statementの調整
- ownership / shared-hotspot conflict解消
- stale Issue / PR / handoff / progress drift修正
- dependency-safe work splitting / refill

Aは通常のLean/Blueprint implementationをworker poolから奪いません。

## Current handoff

- State: active scheduler coordination
- Active A Issue: #81
- Canonical A branch: `design/sync-live-queue-81-v2`
- Superseded stale A PRs: #75, #83（いずれもmergeせずclose）
- Duplicate scheduler work cleaned:
  - #84 -> canonical #70 Corollary 1
  - #79 -> canonical #71 p-adic construction
  - #85 / PR #88 -> canonical #74 / PR #87 Corollary 2

### Recent DONE checkpoints

- #49 / PR #58 — Theorem 1(iii)
- #50 / PR #59 — finite-field multiplicative group
- #51 / PR #62 — power sums
- #52 / PR #68 — core Chevalley–Warning
- #70 / PR #80 — Corollary 1 nontrivial common zero
- #55 / PR #82 — §3.1 Theorem 4 quadratic elements; main merge `329184fa3aa1e6ee748061b1cf5cb539e2c72778`

### Live ownership

- B: #71 `C2S1.1-ZpConstruction`, draft PR #86.
- C: #74 `S2.2-Chevalley-Cor2` / draft PR #87; #56 `S3.2-LegendreSymbol`; #64 `S3.3-QuadraticReciprocity` preflight.
- D: #72 `C2S1.2-ZpProperties` preflight, completed and waiting on #71 interface.
- E: no mathematical ownership at latest check.

### Dependency / integration state

- #74/C is the valid first ownership lock for Corollary 2. #70 is DONE, so implementation gate is open. PR #87 predates #82 root-import merge and is currently nonmergeable; A routed latest-main resync back to C.
- #55 is DONE, so #56's former STACKABLE state is no longer needed. C's #56 branch had been moved to frozen #55 head; A routed resync to latest main before further proof commits.
- #64 remains proof-gated on a smaller future #56 interface: characteristic-independent Legendre sign/value, field-half-power compatibility, multiplicativity, and Theorem 5(ii) at `-1`. Theorem 5(iii) at `2` is not required.
- #71 is independent of Chapter 1 and is being implemented by B.
- #72 source/API preflight recommends an algebraic slice (Proposition 1–2 + valuation) with proof waiting on #71.
- #89 was seeded from that stable preflight as the separate Proposition 3 metric/topology/completeness/density PREFLIGHT. Its proof waits on #72.

### Queue health

Unclaimed safe capacity:

- #78 `C1-Supp-GaussLemma` — PREFLIGHT; proof waits on minimal #56 interface, not on #64.
- #89 `C2S1.2-ZpMetric` — PREFLIGHT; proof waits on #72.

Owned executable work also exists (#74, #56, #71), so the worker pool has parallel capacity without inventing unrelated work.

### Shared-hotspot coordination

- A #81 branch owns only `docs/WORK_QUEUE.md`, `docs/LANE_STATUS.md`, this file, and `FORMALIZATION_PROGRESS.md`.
- C PR #76 is stale docs-only handoff and should be refreshed/superseded by C rather than edited by A.
- A does not modify worker PR #86/#87 or their mathematical files.

### Next A actions

1. open a fresh #81 coordination PR from this branch after final latest-main check;
2. verify exactly four central files changed, run CI, self-merge when green/mergeable;
3. continue monitoring #74/#56 latest-main resync, #71 public interface, and claims of #78/#89;
4. refill only after visible unclaimed capacity becomes thin.

## Scheduler health target

- at least one executable mathematical item when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
