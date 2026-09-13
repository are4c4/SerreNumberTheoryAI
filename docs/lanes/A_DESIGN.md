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
- Active A Issue: #106
- Canonical A branch: `design/refill-hensel-corollaries-106`
- Current A PR: #107
- Previous completed A sync: #95 / PR #101, merge `9d232f844e4de88967483e82bd783a4b6b155345`
- Older completed A sync: #81 / PR #90, merge `6c39201ba0fd7fa2659d8fb499be836a20b5dfe5`

### Recent DONE checkpoints

- #49 / PR #58 — Theorem 1(iii)
- #50 / PR #59 — finite-field multiplicative group
- #51 / PR #62 — power sums
- #52 / PR #68 — core Chevalley–Warning
- #70 / PR #80 — Corollary 1 nontrivial common zero
- #55 / PR #82 — §3.1 Theorem 4 quadratic elements
- #74 / PR #94 — Chevalley Corollary 2
- #71 / PR #86 — Chapter 2 §1.1 project-local `Z_p`

### Live ownership

- B: #78 `C1-Supp-GaussLemma`; #96 `C2S1.3-QpField`; #99 `C2S2.1-RootLiftingExistence` / PR #103; #100 `C2S2.1-PrimitiveHomogeneousZeros` preflight.
- C: #56 `S3.2-LegendreSymbol` / PR #98; #64 `S3.3-QuadraticReciprocity`.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` preflight complete.
- E: no mathematical ownership at latest check.
- Unclaimed: #102 `C2S2.2-HenselLifting`, #104 `C2S2.2-HenselQuadraticOdd`, #105 `C2S2.2-HenselQuadraticTwo`.

### Dependency / integration state

- #56/C retains exact frozen `STACK-READY` head `45bde2eff8e75e901282151760b0c5dfc41a869a` **for #64 only**. A later Theorem 5(iii) head `527533d4…` was green in CI #217, after which C continued source-shaped cleanup. CI #220/#223 then exposed only local additive-commutativity normalization in `LegendreTwo.lean`; A routed exact diagnostics. Current observed repair head `90996cbe1c4e1f2a6c2a2c2916d53467df8c94e0` is queued in CI #225. The old downstream freeze remains green and unchanged. Independent Blueprint exposition/linkage and final latest-main integration remain after proof stabilization.
- #64/C is legally STACKABLE from exactly `45bde2ef…`. The canonical branch was still on its old preflight base at the latest branch check, so no implicit move to a later #56 head is allowed. If #56 merges before #64 adds proof commits, #64 should resync to main instead.
- #78/B needs a smaller subset already present in the #64 freeze, but the owner promise explicitly scopes itself to #64. A has requested a separate #78 promise; #78 remains WAITING until that appears or #56 merges.
- #72/D live head `81bc0f88d6960611264194cf7923118f015f262a` passed CI #219. It now proves the projection-kernel / `p^(n+1)` divisibility equivalence and source unit criteria, but does not yet provide the full `p^n * unit` decomposition, project valuation, or domain conclusion. Therefore it is too early to release #89/#96.
- #89/D preflight remains complete and waits for a stable #72 valuation + divisibility/topology bridge.
- #96/B preflight remains complete; algebraic `Q_p` waits for #72 domain/decomposition/valuation, while Proposition 4 additionally needs a minimal #89 topology/density subset.
- #99/B draft PR #103 previously reached green head `bf91ce4a…` in CI #218 with Proposition 5 and Blueprint work. Subsequent polynomial reduction compatibility refinement currently fails only in B-owned `RootExistence.lean`: observed head `6f4fe68e9276a5658a7bb091172f7dff24c22f83` fails CI #224 at coefficient-level `MvPolynomial.map` compatibility and the mapped-evaluation rewrite. A routed exact diagnostics; no cross-lane intervention is needed. The temporary top-level import hook remains until isolated proof CI is green and #98 frees `Formalization.lean`.
- #100/B was claimed while #99 was root/CI occupied. Its current mandate is source/API/dependency preflight only; proof waits for #99/#72/#96 interfaces.
- #102 remains the core Hensel one-step + multivariate theorem + simple-root Corollary 1 boundary, preflight safe but proof expected to need #72/#89.
- Because #100 was claimed, A independently checked the immediately following source page and split Corollaries 2–3 into #104 (odd `p`) and #105 (`p=2`). These are preflight-safe and depend on #102 plus the appropriate #72 primitive/unit/valuation/congruence interface rather than on `Q_p`.

### Shared-hotspot coordination

1. #98 / C keeps the next normal `Formalization.lean` integration slot while local Theorem 5(iii) repair and Blueprint/final §3.2 work finish. The explicit #64 frozen head is isolated from the moving live branch.
2. #103 / B stays isolated while `RootExistence.lean` is repaired; after isolated CI is green and #98 frees the shared root, B should resync latest main, move `RootExistence` into the normal `Formalization.lean` aggregator, remove the temporary top-level hook, and re-run full CI before merge.
3. #92 / D may continue isolated algebraic proof work, but final Blueprint/root linkage should wait until its theorem interface is stable.

A #106 / PR #107 owns only:

- `docs/WORK_QUEUE.md`
- `docs/LANE_STATUS.md`
- this file
- `FORMALIZATION_PROGRESS.md`

No worker mathematical file is edited.

### Queue health

Unclaimed safe capacity:

- #102 `C2S2.2-HenselLifting` — PREFLIGHT; implementation expected to wait #72/#89.
- #104 `C2S2.2-HenselQuadraticOdd` — PREFLIGHT; source Corollary 2, proof waits #102/#72.
- #105 `C2S2.2-HenselQuadraticTwo` — PREFLIGHT; source Corollary 3, proof waits #102/#72.

Owned executable/near-executable work includes #56/#64/#72/#99. Owned preflight now includes #100. Dependency-waiting but fully preflighted work includes #78/#89/#96. This preserves multiple safe lanes without creating unrelated busywork.

### Next A actions

1. keep PR #107 synchronized with live worker state, then land it after its latest-head CI and four-file self-review are green;
2. monitor #98 repair/Blueprint completion; once it clears `Formalization.lean`, route #103 to normal root integration after its own isolated proof is green;
3. monitor #72 for the first genuinely stable valuation/decomposition subset before releasing #89/#96;
4. monitor #64 consuming the exact frozen #56 head and #56 publishing a separate #78 freeze or merging;
5. monitor claims of #102/#104/#105 and refill only when safe capacity thins again.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
