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
- Active A Issue: #135
- Canonical A branch: `design/sync-weak-approx-135`
- Current A PR: pending
- Latest completed A central sync: #132 / PR #133, merge `e2fec6e82d014ebdec6d83823a2ddfd1b927f765`, CI #347 green
- Previous completed A central sync: #127 / PR #128, merge `6b486522fe873a1b9537b6aedfe94a7636eaa694`, CI #326 green
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

- B: #96 `C2S1.3-QpField` / PR #123; #100 `C2S2.1-PrimitiveHomogeneousZeros`; #102 `C2S2.2-HenselLifting`; #104 `C2S2.2-HenselQuadraticOdd`; #105 `C2S2.2-HenselQuadraticTwo`; #108 `C2S3.1-UnitFiltration`; #120 `C2S3.3-PadicSquares`; #122 `C3S1.2-HilbertLocalFormula`; #124 `C3S2.1-HilbertProductFormula`; #129 `C3S2.2-WeakApproximation`.
- C: #64 `S3.3-QuadraticReciprocity` / PR #114.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` / PR #116; #121 `C3S1.1-HilbertBasics` preflight complete/proof-code-clean.
- #112 `C2S3.2-PrincipalUnits`: canonical branch exists on current main; owner-lane metadata is still pending on the Issue. The branch lock is authoritative, so do not duplicate it.
- E: no mathematical ownership at latest check.
- Unclaimed: #130 `C3S2.2-PrescribedHilbertSymbols`; #131 `C4S1.1-QuadraticFormBasics`; #134 `C4S1.2-Orthogonality`.

### Dependency / integration state

- Validation correction: downstream CI #306/#311 exposed compile failures in `PadicIntegerProperties.lean`. Earlier green #72/#89 runs did not certify all new modules. Their downstream STACK-READY promises are paused for new dependent proof work until D publishes replacement exact heads with the relevant modules actually compiled by CI.

- #56 is DONE on main. Its former #64-only frozen stack head is no longer the gate for new work.
- #64/C draft PR #114 owns the normal `Formalization.lean` aggregator. Stable checkpoint `7a48b08d…` passed CI #289; the moving proof head has advanced to `136bdf47…` with CI #305 in progress. Central scheduling should track structural transitions rather than chase every proof commit.
- #78/B / PR #115 is DONE on main at `56a5307bee7049924c9090a677492ba01a4808e2`. Its source-shaped Gauss-lemma proof, Blueprint, and root linkage are integrated.
- #72/D rooted mathematical modules now compile; diagnostic head `8e123bb1…` passed CI #351 after isolating Blueprint metadata. However four source-facing Blueprint Lean links are temporarily removed, so this is not an acceptable replacement STACK-READY head. Keep downstream gates paused until valid linkage is restored and rooted policy + Lean + Verso are green simultaneously.
- #89/D remains transitively suspended until #72 repair is rooted-green; after that D must restack/revalidate the metric/topology/completion modules before republishing #96/#102 promises.
- #96/B has draft PR #123. Its current CI fails in upstream p-adic integer code; keep the field commits, but wait for a compile-validated replacement stack before extending dependent proof work.
- #99/B is DONE on main. Its final head `1a86c84e…` passed CI #260 with normal Formalization/Blueprint integration; the earlier #100 downstream interface remains stable.
- #100/B has both #99 and #72 primitive/unit inputs stable. Full proof now waits a #96 DONE/STACK-READY scaling interface.
- #102/B preflight remains complete, but its prior stack gate is paused until repaired #72/#89 heads are published.
- #104/B completed odd-prime quadratic-lifting preflight; its #72 subset is frozen, so it waits only for #102 DONE/STACK-READY with the simple-root interface.
- #105/B completed dyadic quadratic-lifting preflight; its #72 subset is frozen, so it waits only for #102 DONE/STACK-READY with the main `n,k` Hensel theorem. No #96 dependency is needed.
- #108/B has draft PR #125. Its current CI fails in the same upstream p-adic integer code; preserve the filtration commits and wait for a replacement stack.
- #112 has a canonical branch lock on current main but no `OWNER: <lane>` comment yet. Treat it as claimed with owner metadata pending; proof remains gated on #108/#72 and the final `Q_p^×` theorem on #96.
- #120 is B-owned proof-code-clean PREFLIGHT for Chapter 2 §3.3 p-adic square classes; proof waits #112 + #96.
- #121 is D-owned, PREFLIGHT complete, and proof-code-clean. The generic field-level core is implementation-ready independently of #96, while the project `Q_p` specialization waits #96.
- #122 is B-owned with PREFLIGHT complete and proof-code-clean; proof waits #121 plus the exact #96/#120/#100/#104/#105 interfaces actually used.
- #124 is B-owned with PREFLIGHT complete and proof-code-clean; proof waits #122 and the exact #64 quadratic-reciprocity interface actually used.
- #129 is B-owned with PREFLIGHT complete and proof-code-clean. Its CRT lemma is project-independent; the source weak-approximation specialization waits #96.
- #130/#131/#134 are the clearly unclaimed safe PREFLIGHT capacity.

### Shared-hotspot coordination

1. **#114 / C** owns the normal `SerreNumberTheoryAI/Formalization.lean` single-writer slot; stable `7a48b08d…` is green and the moving head `136bdf47…` is under CI #305.
2. **#92 / #116 / D** remain isolated from normal shared aggregators; replacement heads `781d1b8f…` / CI #297 and `55175ebc…` / CI #298 are green.
3. **#123 / B** temporarily edits top-level `SerreNumberTheoryAI.lean` plus `PadicField.lean` on a private stack base. It does not edit `Formalization.lean`; final normal aggregator integration must wait upstream/root serialization.

### Queue health

Unclaimed safe capacity:

- #130 `C3S2.2-PrescribedHilbertSymbols` — PREFLIGHT; theorem-level proof gated on #124/#122/#120/#129 + source-faithful Dirichlet interface.
- #131 `C4S1.1-QuadraticFormBasics` — PREFLIGHT; generic quadratic-form algebra independent of the current p-adic chain.
- #134 `C4S1.2-Orthogonality` — PREFLIGHT; generic orthogonality/radical theory, proof waits #131.

#112 is branch-locked and not claimable. #120 is now B-owned PREFLIGHT. Owned executable/near-executable work includes #64/#72, stacked #89, active stacked #96/PR #123, stackable #102, and core-stackable #108. The pool retains three clearly unclaimed safe paths without speculative work.

### Next A actions

0. require #72/#89 replacement promises to be backed by CI that actually compiles their new modules before reopening p-adic downstream gates;

1. land #135 central sync after latest-main/live-claim recheck, exact central-file review, and latest-head CI;
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
