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

- B: #78 `C1-Supp-GaussLemma`; #96 `C2S1.3-QpField`; #99 `C2S2.1-RootLiftingExistence` / PR #103; #100 `C2S2.1-PrimitiveHomogeneousZeros`; #102 `C2S2.2-HenselLifting` preflight complete.
- C: #56 `S3.2-LegendreSymbol` / PR #98; #64 `S3.3-QuadraticReciprocity`.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` preflight complete.
- E: no mathematical ownership at latest check.
- Unclaimed: #104 `C2S2.2-HenselQuadraticOdd`, #105 `C2S2.2-HenselQuadraticTwo`, #108 `C2S3.1-UnitFiltration`.

### Dependency / integration state

- #56/C retains exact frozen `STACK-READY` head `45bde2eff8e75e901282151760b0c5dfc41a869a` **for #64 only**. The moving live branch repaired the later Theorem 5(iii) coercion/normalization work; latest checked head `e681e2155e34022a181f2b7eafbaa55886bda9a0` passed CI #232. The old downstream freeze remains green and unchanged. Independent Blueprint exposition/linkage and final latest-main integration remain before #56 is DONE.
- #64/C is legally STACKABLE from exactly `45bde2ef…`. Later #56 declarations must not leak into #64 unless C publishes a replacement freeze or #56 merges.
- #78/B needs a smaller subset already present in the #64 freeze, but the owner promise explicitly scopes itself to #64. #78 remains WAITING until a separate exact promise appears or #56 merges.
- #72/D live head `81bc0f88d6960611264194cf7923118f015f262a` passed CI #219. It proves projection-kernel / `p^(n+1)` divisibility and unit criteria, but does not yet expose the full `p^n * unit` decomposition, project valuation, or domain conclusion. Therefore #89/#96 and proof implementation of #102 remain gated.
- #89/D preflight remains complete and waits for a stable #72 valuation + divisibility/topology bridge.
- #96/B preflight remains complete; algebraic `Q_p` waits for #72 domain/decomposition/valuation, while Proposition 4 additionally needs a minimal #89 topology/density subset.
- #99/B draft PR #103 current checked head `fe1a173e9665595b584d7f8235c5122b4f0cc373` passed CI #226. Proposition 5 and Blueprint work are green in isolated form, and B explicitly froze a downstream-only subset for #100. The temporary top-level import hook remains until #98 frees `Formalization.lean`; final integration then moves imports into the normal aggregators and reruns full CI.
- #100/B may use the frozen #99 downstream subset for interface/preflight work, but its full Proposition 6 proof still needs #72 primitive/unit and #96 `Q_p` scaling.
- #102/B completed source/API preflight. It fixed the source-shaped one-step Taylor proof plan, exact #72 congruence/decomposition contract, and minimal #89 completeness contract. The canonical branch is intentionally proof-code-clean while those interfaces are unavailable.
- #104/#105 remain the two source quadratic Hensel corollaries, preflight-safe and proof-dependent on #102 plus #72.
- Because #102 was claimed, A independently checked the next source boundary, Chapter 2 §3.1 (printed pp.22–24 / uploaded PDF pp.32–34), and seeded #108. The core Proposition 7 unit-filtration/splitting work depends on #71 plus stable #72 units/divisibility; only its final corollary inside project `Q_p` needs #96.

### Shared-hotspot coordination

1. #98 / C keeps the next normal `Formalization.lean` integration slot now that its latest proof head is green; Blueprint/final §3.2 work and latest-main verification remain.
2. #103 / B is isolated-CI green; after #98 frees the shared root, B should resync latest main, move `RootExistence` into the normal Formalization/Blueprint aggregators, remove the temporary top-level hook, and re-run full CI before merge.
3. #92 / D may continue isolated algebraic proof work, but final Blueprint/root linkage should wait until its theorem interface is stable.

A #106 / PR #107 owns only:

- `docs/WORK_QUEUE.md`
- `docs/LANE_STATUS.md`
- this file
- `FORMALIZATION_PROGRESS.md`

No worker mathematical file is edited.

### Queue health

Unclaimed safe capacity:

- #104 `C2S2.2-HenselQuadraticOdd` — PREFLIGHT; source Corollary 2, proof waits #102/#72.
- #105 `C2S2.2-HenselQuadraticTwo` — PREFLIGHT; source Corollary 3, proof waits #102/#72.
- #108 `C2S3.1-UnitFiltration` — PREFLIGHT; Proposition 7/core unit filtration waits stable #72, final `Q_p` corollary waits #96.

Owned executable/near-executable work includes #56/#64/#72/#99. Owned preflight/waiting work includes #100/#102; dependency-waiting but fully preflighted work also includes #78/#89/#96. This preserves multiple safe lanes without creating unrelated busywork.

### Next A actions

1. land PR #107 after latest-head CI and four-file self-review are green;
2. monitor #98 Blueprint/final integration; once it clears `Formalization.lean`, route #103 to normal root integration from its green isolated head;
3. monitor #72 for the first genuinely stable valuation/decomposition subset before releasing #89/#96 and #102 proof work;
4. monitor #64's exact frozen stack and #56 publishing a separate #78 freeze or merging;
5. monitor claims of #104/#105/#108 and refill only when safe capacity thins again.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
