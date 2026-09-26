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
- Active A Issue: #118
- Canonical A branch: `design/post-merge-handoff-118`
- Current A PR: #119
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
- #78 / PR #115 — Chapter 1 supplement (i) Gauss's lemma, merge `56a5307bee7049924c9090a677492ba01a4808e2`

### Live ownership

- B: #96 `C2S1.3-QpField`; #100 `C2S2.1-PrimitiveHomogeneousZeros`; #102 `C2S2.2-HenselLifting`; #104 `C2S2.2-HenselQuadraticOdd`; #105 `C2S2.2-HenselQuadraticTwo`; #108 `C2S3.1-UnitFiltration`.
- C: #64 `S3.3-QuadraticReciprocity` / PR #114.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` / PR #116.
- #112 `C2S3.2-PrincipalUnits`: canonical branch exists on current main; owner-lane metadata is still pending on the Issue. The branch lock is authoritative, so do not duplicate it.
- E: no mathematical ownership at latest check.
- Unclaimed: #120 `C2S3.3-PadicSquares`; #121 `C3S1.1-HilbertBasics`; #122 `C3S1.2-HilbertLocalFormula`.

### Dependency / integration state

- #56 is DONE on main. Its former #64-only frozen stack head is no longer the gate for new work.
- #64/C draft PR #114 has reconciled onto main after #78 merged. Latest checked head `7a48b08d47ff2c39dd8dd8ba333f6177c6619066` passed CI #289 and uses the normal `Formalization.lean` aggregator. C owns the current shared-root slot while the remaining source coefficient/Gauss-square/Frobenius proof, Blueprint, and final theorem are completed.
- #78/B / PR #115 is DONE on main at `56a5307bee7049924c9090a677492ba01a4808e2`. Its source-shaped Gauss-lemma proof, Blueprint, and root linkage are integrated.
- #72/D exact head `c43d7f09c57a01418663965fd070c69ee16a73b6` passed CI #261. It provides projection/kernel, unit and power-divisibility bridges, unique `p^n * unit` decomposition, `serrePadicIntAddValuation` with multiplication/ultrametric laws, the domain instance, and independent Blueprint exposition.
- D has published consumer-scoped `STACK-READY` promises from #72 exact green `c43d7f09…` / CI #261 for #89, #96, #102, #100, #104, and #105. #108's smaller unit/projection/divisibility subset is the remaining requested #72 promise.
- #89/D draft PR #116 stacks exactly on #72 `c43d7f09…`. Exact head `f42c68f095015a4e5d66d08f71d24257d6d52d9f` passed CI #291 and is explicitly frozen for two consumers: #96 may use topology/projection-ball/integer-density, and #102 may use compatible metric/completeness/divisibility-to-distance. The PR remains outside shared-root contention.
- #96/B is now STACKABLE: both required #72 and #89 contracts are frozen, and because #89 head contains the exact #72 base, B may use `f42c68f0…` as the single exact stack base for dependent implementation.
- #99/B is DONE on main. Its final head `1a86c84e…` passed CI #260 with normal Formalization/Blueprint integration; the earlier #100 downstream interface remains stable.
- #100/B has both #99 and #72 primitive/unit inputs stable. Full proof now waits a #96 DONE/STACK-READY scaling interface.
- #102/B is now STACKABLE from exact #89 head `f42c68f0…`; both the #72 source congruence/decomposition/valuation contract and #89 metric/completeness contract are explicitly frozen. It may begin the source Newton/Cauchy implementation.
- #104/B completed odd-prime quadratic-lifting preflight; its #72 subset is frozen, so it now waits only for #102 DONE/STACK-READY with the simple-root theorem interface.
- #105/B completed dyadic quadratic-lifting preflight; its #72 dyadic subset is frozen, so it now waits only for #102 DONE/STACK-READY with the main `n,k` Hensel theorem. No #96 dependency is needed.
- #108/B has completed dependency-safe preflight for Chapter 2 §3.1 unit filtration / Proposition 7. Core proof remains proof-code-clean until D publishes the requested #108-scoped #72 unit/projection/divisibility freeze; only the final roots-of-unity corollary inside project `Q_p` needs #96.
- #112 has a canonical branch lock on current main but no `OWNER: <lane>` comment yet. Treat it as claimed with owner metadata pending; proof remains gated on #108/#72 and the final `Q_p^×` theorem on #96.
- #120 is the unclaimed Chapter 2 §3.3 p-adic-square-class preflight. Odd `p` uses valuation parity plus the merged project Legendre residue-square criterion; `p=2` uses valuation parity plus unit `≡1 mod 8`. Proof waits #112 + #96.
- #121 is the unclaimed Chapter 3 §1.1 Hilbert-symbol basics/norm-criterion preflight. Generic field-level definition/norm work is safe now; project `Q_p` specialization waits #96.
- #122 is the unclaimed Chapter 3 §1.2 explicit Hilbert-formula/nondegeneracy preflight. Proof will wait #121 plus the exact #96/#120/#100/#104/#105 interfaces actually used.

### Shared-hotspot coordination

1. **#115 / B is DONE** on main at `56a5307b…`; its former shared-root slot is clear.
2. **#114 / C** is reconciled on that main and owns the current normal `SerreNumberTheoryAI/Formalization.lean` single-writer slot. Latest checked head `7a48b08d…` is CI #289 green.
3. **#116 / D** avoids `Formalization.lean` / `Blueprint.lean`; its four changed files are Chapter 2 metric/topology/completion modules plus an independent Blueprint module. #92 final root linkage should still not race #114.

### Queue health

Unclaimed safe capacity:

- #120 `C2S3.3-PadicSquares` — PREFLIGHT; source Theorems 3–4 / square-class quotients, proof waits #112/#96 and odd case reuses merged #56.
- #121 `C3S1.1-HilbertBasics` — PREFLIGHT; generic field/norm work safe, project `Q_p` specialization waits #96.
- #122 `C3S1.2-HilbertLocalFormula` — PREFLIGHT; explicit local formulas/nondegeneracy, proof waits #121 plus actual #96/#120/lifting interfaces.

#112 is branch-locked and therefore not claimable even though its owner-lane comment is still missing. Owned executable/near-executable work now includes #64/#72, stackable #89, and newly stackable #96/#102. Owned waiting/preflight work includes #100/#104/#105/#108 plus #112's locked preflight. The pool therefore retains three clearly unclaimed safe paths without speculative work.

### Next A actions

1. finish #118 / PR #119 after latest-main recheck, exact four-file self-review, and latest-head CI;
2. monitor #114 source proof/Blueprint/final root integration on main after #115 merge;
3. monitor #96/#102 branch movement to exact #89 `f42c68f0…` and later downstream STACK-READY contracts for #100/#104/#105;
4. monitor #72 only for the remaining #108-scoped unit/projection/divisibility freeze; monitor #116 promise stability until upstream merge;
5. resolve #112 owner metadata without disturbing its atomic branch lock; monitor #108's now-complete preflight;
6. monitor claims of #120/#121/#122 and refill only when safe capacity thins again;
7. do not create speculative implementation work merely to keep a lane busy.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
