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

- State: monitoring / scheduler-ready
- Active A Issue: none
- Canonical A branch: none
- Current A PR: none
- Latest completed A central sync: #118 / PR #119, merge `cd9654f81d05a870e6200b8849882bf2eff5aab3`, CI #319 green
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

- B: #96 `C2S1.3-QpField` / PR #123; #100 `C2S2.1-PrimitiveHomogeneousZeros`; #102 `C2S2.2-HenselLifting`; #104 `C2S2.2-HenselQuadraticOdd`; #105 `C2S2.2-HenselQuadraticTwo`; #108 `C2S3.1-UnitFiltration`; #120 `C2S3.3-PadicSquares`.
- C: #64 `S3.3-QuadraticReciprocity` / PR #114.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` / PR #116.
- #112 `C2S3.2-PrincipalUnits`: canonical branch exists on current main; owner-lane metadata is still pending on the Issue. The branch lock is authoritative, so do not duplicate it.
- E: no mathematical ownership at latest check.
- Unclaimed: #121 `C3S1.1-HilbertBasics`; #122 `C3S1.2-HilbertLocalFormula`; #124 `C3S2.1-HilbertProductFormula`.

### Dependency / integration state

- Validation correction: downstream CI #306/#311 exposed compile failures in `PadicIntegerProperties.lean`. Earlier green #72/#89 runs did not certify all new modules. Their downstream STACK-READY promises are paused for new dependent proof work until D publishes replacement exact heads with the relevant modules actually compiled by CI.

- #56 is DONE on main. Its former #64-only frozen stack head is no longer the gate for new work.
- #64/C draft PR #114 owns the normal `Formalization.lean` aggregator. Stable checkpoint `7a48b08d…` passed CI #289; the moving proof head has advanced to `136bdf47…` with CI #305 in progress. Central scheduling should track structural transitions rather than chase every proof commit.
- #78/B / PR #115 is DONE on main at `56a5307bee7049924c9090a677492ba01a4808e2`. Its source-shaped Gauss-lemma proof, Blueprint, and root linkage are integrated.
- #72/D replacement exact head `781d1b8fc4800c28934c39563ba8d8e3bd85ff7d` passed CI #297 after latest-main resync. The mathematical interface is unchanged from old `c43d7f09…`; old promises remain valid for existing work, while new dependent commits should prefer `781d1b8f…`. Scoped consumers now include #89/#96/#102/#100/#104/#105/#108.
- #89/D replacement exact head `55175ebce34eda623e2b78cb486f75f7a3e7967a`, stacked on `781d1b8f…`, passed CI #298. The #96 topology/projection-ball/density and #102 metric/completeness promises are unchanged; old `f42c68f0…` remains valid for existing work.
- #96/B has draft PR #123. Its current CI fails in upstream p-adic integer code; keep the field commits, but wait for a compile-validated replacement stack before extending dependent proof work.
- #99/B is DONE on main. Its final head `1a86c84e…` passed CI #260 with normal Formalization/Blueprint integration; the earlier #100 downstream interface remains stable.
- #100/B has both #99 and #72 primitive/unit inputs stable. Full proof now waits a #96 DONE/STACK-READY scaling interface.
- #102/B preflight remains complete, but its prior stack gate is paused until repaired #72/#89 heads are published.
- #104/B completed odd-prime quadratic-lifting preflight; its #72 subset is frozen, so it waits only for #102 DONE/STACK-READY with the simple-root interface.
- #105/B completed dyadic quadratic-lifting preflight; its #72 subset is frozen, so it waits only for #102 DONE/STACK-READY with the main `n,k` Hensel theorem. No #96 dependency is needed.
- #108/B has draft PR #125. Its current CI fails in the same upstream p-adic integer code; preserve the filtration commits and wait for a replacement stack.
- #112 has a canonical branch lock on current main but no `OWNER: <lane>` comment yet. Treat it as claimed with owner metadata pending; proof remains gated on #108/#72 and the final `Q_p^×` theorem on #96.
- #120 is B-owned proof-code-clean PREFLIGHT for Chapter 2 §3.3 p-adic square classes; proof waits #112 + #96.
- #121 is the unclaimed Chapter 3 §1.1 Hilbert-symbol basics/norm-criterion preflight. Generic field-level definition/norm work is safe now; project `Q_p` specialization waits #96.
- #122 is the unclaimed Chapter 3 §1.2 explicit Hilbert-formula/nondegeneracy preflight. Proof will wait #121 plus the exact #96/#120/#100/#104/#105 interfaces actually used.
- #124 is the newly seeded unclaimed Chapter 3 §2.1 Hilbert product-formula preflight, independently checked from printed pp.33–34 / PDF pp.43–44. Proof waits #122 and the #64 quadratic-reciprocity interface actually used.

### Shared-hotspot coordination

1. **#114 / C** owns the normal `SerreNumberTheoryAI/Formalization.lean` single-writer slot; stable `7a48b08d…` is green and the moving head `136bdf47…` is under CI #305.
2. **#92 / #116 / D** remain isolated from normal shared aggregators; replacement heads `781d1b8f…` / CI #297 and `55175ebc…` / CI #298 are green.
3. **#123 / B** temporarily edits top-level `SerreNumberTheoryAI.lean` plus `PadicField.lean` on a private stack base. It does not edit `Formalization.lean`; final normal aggregator integration must wait upstream/root serialization.

### Queue health

Unclaimed safe capacity:

- #121 `C3S1.1-HilbertBasics` — PREFLIGHT; generic field/norm work safe, project `Q_p` specialization waits #96.
- #122 `C3S1.2-HilbertLocalFormula` — PREFLIGHT; explicit local formulas/nondegeneracy, proof waits #121 plus actual #96/#120/lifting interfaces.
- #124 `C3S2.1-HilbertProductFormula` — PREFLIGHT; global product formula, proof waits #122 + #64 reciprocity interface.

#112 is branch-locked and not claimable. #120 is now B-owned PREFLIGHT. Owned executable/near-executable work includes #64/#72, stacked #89, active stacked #96/PR #123, stackable #102, and core-stackable #108. The pool retains three clearly unclaimed safe paths without speculative work.

### Next A actions

0. require #72/#89 replacement promises to be backed by CI that actually compiles their new modules before reopening p-adic downstream gates;

1. finish #118 / PR #119 after latest-main recheck, exact four-file self-review, and latest-head CI;
2. monitor #114 source proof/Blueprint/final root integration on main after #115 merge;
3. monitor #96/PR #123 CI and eventual stable scaling interface for #100; monitor #102 movement to replacement #89 `55175ebc…` and later STACK-READY contracts for #104/#105;
4. monitor #108 movement to replacement #72 `781d1b8f…`; preserve old non-withdrawn freezes for existing work and prefer replacement heads for new work;
5. resolve #112 owner metadata without disturbing its atomic branch lock; keep #120 proof-code-clean until #112/#96 gates;
6. monitor claims of #121/#122/#124 and refill only when safe capacity thins again;
7. do not create speculative implementation work merely to keep a lane busy.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
