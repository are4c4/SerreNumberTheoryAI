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

- State: monitoring / ready for scheduler coordination
- Active A mathematical Issue: none
- Active A mathematical branch / PR: none
- Latest completed A central sync: #113 / PR #117, merge `c8b94633ed218392ba771ecab3cde3884b6bf457`
- Previous completed A central sync: #106 / PR #107, merge `f3d0f5b22b1e306720d6c313185f98692110f3a8`
- Latest A housekeeping before that: #109 / PR #110, merge `272885ad850d12fa1ee06d60c75f101bae54413c`

### Recent DONE checkpoints

- #49 / PR #58 — Theorem 1(iii)
- #50 / PR #59 — finite-field multiplicative group
- #51 / PR #62 — power sums
- #52 / PR #68 — core Chevalley–Warning
- #70 / PR #80 — Corollary 1 nontrivial common zero
- #55 / PR #82 — §3.1 Theorem 4 quadratic elements
- #74 / PR #94 — Chevalley Corollary 2
- #71 / PR #86 — Chapter 2 §1.1 project-local `Z_p`
- #56 / PR #98 — §3.2 Legendre symbol / Theorem 5(i)–(iii), merge `7aa158673bf0df1c62e977b508297d2e6b88610a`
- #99 / PR #103 — Chapter 2 §2.1 Proposition 5, merge `326c2aec2e3f2168dfce64d5f95d678d8b6a1930`

### Live ownership

- B: #78 `C1-Supp-GaussLemma` / PR #115; #96 `C2S1.3-QpField`; #100 `C2S2.1-PrimitiveHomogeneousZeros`; #102 `C2S2.2-HenselLifting`; #104 `C2S2.2-HenselQuadraticOdd`.
- C: #64 `S3.3-QuadraticReciprocity` / PR #114.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` / PR #116.
- E: no mathematical ownership at latest check.
- Unclaimed: #105 `C2S2.2-HenselQuadraticTwo`; #108 `C2S3.1-UnitFiltration`; #112 `C2S3.2-PrincipalUnits`.

### Dependency / integration state

- #56 is DONE on main. Its former #64-only frozen stack head is no longer the gate for new work.
- #64/C draft PR #114 now uses merged §3.2 and the normal `Formalization.lean` aggregator. Latest checked head `e5abc14f93c2a9cefa8854c0de842c8b69623d9b` passed CI #278. C therefore owns the current shared-root slot while the source Gauss-sum proof, Blueprint, and final theorem are completed.
- #78/B draft PR #115 has advanced beyond preflight. Latest checked head `dac9ecf5c18665d16a89a40d5e1b612412ada39c` passed CI #277 and includes source-shaped Gauss-lemma code plus Blueprint/root linkage. Because it also edits `Formalization.lean` and `Blueprint.lean`, A serialized its final aggregator merge behind #114; B may continue nonconflicting module work and must resync latest main after #114 clears.
- #72/D exact head `c43d7f09c57a01418663965fd070c69ee16a73b6` passed CI #261. It provides projection/kernel, unit and power-divisibility bridges, unique `p^n * unit` decomposition, `serrePadicIntAddValuation` with multiplication/ultrametric laws, the domain instance, and independent Blueprint exposition.
- D explicitly published `STACK-READY` from `c43d7f09…` **for #89 only**. A must not silently reuse that promise for #96/#102/#100/#108.
- #89/D draft PR #116 stacks exactly on the frozen #72 head. Latest checked head `382a56d40d41e197b837eab34f7de871d147d8ba` passed CI #267 and currently changes only `PadicIntegerMetric.lean`, so the metric implementation can proceed without shared-root contention.
- #96/B remains proof-gated until #72 publishes a #96-scoped stable domain/decomposition/valuation subset or merges. Proposition 4 additionally needs minimal #89 topology/density.
- #99/B is DONE on main. Its final head `1a86c84e…` passed CI #260 with normal Formalization/Blueprint integration; the earlier #100 downstream interface remains stable.
- #100/B may consume #99 now without stacking. Full proof still needs #72 primitive/unit and #96 `Q_p` scaling.
- #102/B completed source/API preflight. It needs more than the #89-scoped #72 freeze: the source congruence/decomposition interface plus a compatible completeness result from #89.
- #104/B completed odd-prime quadratic-lifting preflight. It remains proof-code-clean until #102 is DONE/STACK-READY plus the minimal #72 primitive/unit/congruence subset.
- #105 remains the dyadic Hensel corollary unclaimed preflight.
- #108 is the Chapter 2 §3.1 unit-filtration / Proposition 7 preflight. Core work waits for an explicit stable #72 unit/divisibility subset; only the final roots-of-unity corollary phrased inside project `Q_p` needs #96.
- #112 is the source-adjacent §3.2 principal-unit / Proposition 8 preflight. Core work depends on #108/#72; the final project `Q_p^×` decomposition statement also needs #96.

### Shared-hotspot coordination

1. **#114 / C** owns the current normal `SerreNumberTheoryAI/Formalization.lean` single-writer slot. Latest checked head `e5abc14f…` is CI #278 green.
2. **#115 / B** is also green but edits both `Formalization.lean` and `Blueprint.lean`; its final shared-root integration is explicitly behind #114. After #114 merges, B must resync latest main, reconcile root imports, and rerun full CI before merge.
3. **#116 / D** currently edits only its isolated metric module. It may continue stacked proof work. #92 final Blueprint/root integration should likewise avoid racing #114/#115.

### Queue health

Unclaimed safe capacity:

- #105 `C2S2.2-HenselQuadraticTwo` — PREFLIGHT; proof waits #102/#72.
- #108 `C2S3.1-UnitFiltration` — PREFLIGHT; core waits an explicit #72 unit/divisibility subset, final `Q_p` corollary waits #96.
- #112 `C2S3.2-PrincipalUnits` — PREFLIGHT; core waits #108/#72, final `Q_p^×` theorem waits #96.

Owned executable/near-executable work includes #64/#78/#72 and stackable #89. Owned preflight/waiting work includes #100/#102/#104/#96. The pool therefore retains several useful paths without speculative work.

### Next A actions

1. monitor #114 source proof/Blueprint/final root integration and keep #115 serialized behind it;
2. once #114 merges, route #115 to latest-main root reconciliation and full CI;
3. monitor #72 for any additional explicit downstream freeze(s) before releasing #96/#102/#100/#108;
4. monitor #116 implementation from exact `c43d7f09…` and future topology/completeness freeze needed by #96/#102;
5. monitor claims of #105/#108/#112 and refill only when safe capacity thins again;
6. do not create speculative implementation work merely to keep a lane busy.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
