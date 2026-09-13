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
- Active A Issue: #95
- Canonical A branch: `design/sync-post-90-live-95`
- Current A PR: #97
- Last completed A sync: #81 / PR #90, merged green as `6c39201ba0fd7fa2659d8fb499be836a20b5dfe5`
- Superseded stale A PRs: #75, #83（mergeせずclose）
- Duplicate scheduler/work conflicts already cleaned:
  - #84 -> canonical #70 Corollary 1
  - #79 -> canonical #71 p-adic construction
  - #85 / PR #88 -> canonical #74 Corollary 2

### Recent DONE checkpoints

- #49 / PR #58 — Theorem 1(iii)
- #50 / PR #59 — finite-field multiplicative group
- #51 / PR #62 — power sums
- #52 / PR #68 — core Chevalley–Warning
- #70 / PR #80 — Corollary 1 nontrivial common zero
- #55 / PR #82 — §3.1 Theorem 4 quadratic elements; main merge `329184fa3aa1e6ee748061b1cf5cb539e2c72778`

### Live ownership

- B: #71 `C2S1.1-ZpConstruction`, draft PR #86; #78 `C1-Supp-GaussLemma` preflight complete / WAITING on #56.
- C: #74 `S2.2-Chevalley-Cor2` / current PR #94; #56 `S3.2-LegendreSymbol` / draft PR #93; #64 `S3.3-QuadraticReciprocity` preflight.
- D: #72 `C2S1.2-ZpProperties` / draft PR #92, existing work preserved but temporary upstream-gate wait.
- E: no mathematical ownership at latest check.

### Dependency / integration state

- #74/C is the valid first ownership lock for Corollary 2. Old PR #87 is superseded; current PR #94 is green and mergeable at head `596b6341…`. A #90 advanced main only through central docs, so C should resync #94 to current main and land it before other root-import PRs.
- #55 is DONE, so #56's former STACKABLE state is gone. C is actively implementing #56 in PR #93. Current head `83d03bc…` has one implementation-local sign/cast Lean goal; A routed the exact CI diagnostic to C. This is not an A-level statement/dependency blocker.
- #64 remains proof-gated on a smaller future #56 interface: characteristic-independent Legendre sign/value, field-half-power compatibility, multiplicativity, and Theorem 5(ii) at `-1`. Theorem 5(iii) at `2` is not required.
- #78 was claimed by B after the previous central snapshot. B completed source/package/API preflight and determined that the generic Gauss-product argument only needs the minimal #56 sign/half-power layer. The branch remains proof-code-clean and waits on #56 DONE/STACK-READY.
- #71 remains independent of Chapter 1, but B explicitly **withdrew** the earlier downstream stack approval at exact head `27a414…`: that green run occurred while the new Chapter-2 module was still isolated from root aggregators and therefore did not compile it. B reports the public declaration names/statements are unchanged. Current PR #86 head `6a39d1fd…` CI #190 passes policy and builds the formalization, then fails Chapter-2 Blueprint compilation because headings at several lines use `##` where only `#` is permitted. A routed the exact diagnostic to B. A replacement exact `STACK-READY` may be published only after root-integrated policy/build/vbp all pass.
- #72 had legitimately begun stacked work while `27a414…` approval was live, and its existing PR #92 head `a6ffdf7a…` is green against that anchor. Because B later withdrew the approval, A routed a gate correction to D: keep existing work intact, but add no further upstream-dependent proof and do not advertise it integratable until #71 publishes a replacement green exact SHA or merges. If the replacement interface changes, route back to A first.
- #89 is the separate Proposition 3 metric/topology/completeness/density PREFLIGHT extracted from #72. Proof waits on #72.
- #96 is newly seeded from Chapter 2 §1.3: project `Q_p` as fraction field of project `Z_p`, valuation extension, and Proposition 4 local compactness/open compactness/density. Preflight is safe now; algebraic proof waits on #72 and the metric edge to #89 must be minimized by preflight.

### Queue health

Unclaimed safe capacity:

- #89 `C2S1.2-ZpMetric` — PREFLIGHT; proof waits on #72.
- #96 `C2S1.3-QpField` — PREFLIGHT; algebraic proof waits on #72, metric dependency to #89 to be refined.

Owned executable work exists (#74, #56, #71), while #64/#78 retain owned preflight/waiting state and #72 is temporarily WAITING only because its former stack approval was withdrawn. The worker pool therefore still has safe parallel capacity without inventing unrelated work.

### Shared-hotspot coordination

Current root import order is explicit:

1. #94 / C first: already end-to-end green; resync current main and merge.
2. #86 / B second among current root `Blueprint.lean` consumers: fix Chapter-2 Blueprint heading hierarchy, then rebase after #94 and rerun integrated CI.
3. #93 / C remains an in-progress proof slice and should not race the root import; keep module work isolated and do final root integration after #94.

A #95 / PR #97 owns only:

- `docs/WORK_QUEUE.md`
- `docs/LANE_STATUS.md`
- this file

No `FORMALIZATION_PROGRESS.md` change is needed because no new mathematical slice has merged since #90.

### Next A actions

1. finish #95/#97 after the corrected #71/#72 gate state is green on latest-head CI; previous #97 CI #189 was green before this correction, so only the new head's CI counts;
2. monitor #94 landing, then ensure #86/#93 rebase instead of racing shared root imports;
3. monitor #71 for replacement root-integrated STACK-READY and immediately route that exact SHA to #72; if declarations drift, stop and reconcile before D resumes;
4. monitor #56 for a minimal `STACK-READY` subset that can release both #64 and #78 without waiting on unrelated Theorem 5(iii);
5. monitor claims of #89/#96 and refill only when unclaimed safe capacity becomes thin.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
