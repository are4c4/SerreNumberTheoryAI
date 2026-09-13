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
- Canonical A branch: `design/sync-post-94-live-95-v2`
- Superseded A sync PR: #97（greenだったが#94 mergeとworker claimsで内容がlive stateに追い越されたためv2へ置換）
- Last completed A sync on main: #81 / PR #90, merge `6c39201ba0fd7fa2659d8fb499be836a20b5dfe5`

### Recent DONE checkpoints

- #49 / PR #58 — Theorem 1(iii)
- #50 / PR #59 — finite-field multiplicative group
- #51 / PR #62 — power sums
- #52 / PR #68 — core Chevalley–Warning
- #70 / PR #80 — Corollary 1 nontrivial common zero
- #55 / PR #82 — §3.1 Theorem 4 quadratic elements
- #74 / PR #94 — Chevalley Corollary 2, main `f4921a0e6c65ae7521376229ac78bfc95f68fc1c`

### Live ownership

- B: #71 `C2S1.1-ZpConstruction` / PR #86; #78 `C1-Supp-GaussLemma`; #96 `C2S1.3-QpField`.
- C: #56 `S3.2-LegendreSymbol` / PR #98; #64 `S3.3-QuadraticReciprocity` preflight.
- D: #72 `C2S1.2-ZpProperties` / PR #92; #89 `C2S1.2-ZpMetric` preflight complete.
- E: no mathematical ownership at latest check.
- Unclaimed: #99 `C2S2.1-RootLiftingExistence`, #100 `C2S2.1-PrimitiveHomogeneousZeros`.

### Dependency / integration state

- #56/C core head `45bde2eff8e75e901282151760b0c5dfc41a869a` is green in CI #198. A routed an early-freeze request: if the sign/half-power declarations are stable, publish an exact-head minimal STACK-READY subset for #78 without waiting for all of Theorem 5. #64 remains gated until the stronger subset including Theorem 5(ii) at `-1` is frozen.
- #78/B preflight is complete. Its generic Gauss-product argument needs only the minimal #56 sign/half-power interface, not #64.
- #71/B withdrew the old `27a414…` STACK-READY because that run had not root-compiled Chapter 2. Current latest-main-integrated head `2a22858d4cf7a3bb89c2409a3f281e67e73807fd` is fully green in CI #199. A routed B to publish the replacement exact STACK-READY, notify #72, then self-review/merge.
- #72/D retains the work created while the old approval was valid, but further upstream-dependent proof is WAITING until #71 replacement exact green SHA is published or #71 merges. No mathematical drift has been reported in the public #71 declarations.
- #89/D preflight is complete and recommends a project-local additive valuation + `v(x) ≥ n ↔ p^n ∣ x` / projection-kernel bridge, exact source metric normalization, topology compatibility with the inverse-limit topology, compact→complete, and integer-density proof. Proof waits #72.
- #96/B preflight is complete. Algebraic `Q_p` should be `FractionRing (SerrePadicInt p)` after #72 gives a domain/valuation/unit-decomposition interface. Proposition 4 needs only a minimal #89 topology/neighborhood/density subset, not all completeness machinery.
- Because #89 and #96 were both claimed, unclaimed capacity became zero. A source-checked Chapter 2 §2.1 and split the next boundary into #99 Proposition 5 (depends essentially on #71 only) and #100 Proposition 6 (future #72/#96 + reusable #99 root machinery), restoring two safe PREFLIGHT candidates.

### Shared-hotspot coordination

Current root order:

1. #86 / B next: current head is fully green and based on main after #94.
2. #98 / C after #86 if #86 merges first; its current core is green but the work item is not yet end-to-end complete.
3. #92 / D stays downstream-gated and should not race root integration.

A #95 v2 owns only:

- `docs/WORK_QUEUE.md`
- `docs/LANE_STATUS.md`
- this file
- `FORMALIZATION_PROGRESS.md`

No worker mathematical file is edited.

### Queue health

Unclaimed safe capacity:

- #99 `C2S2.1-RootLiftingExistence` — PREFLIGHT; implementation waits #71.
- #100 `C2S2.1-PrimitiveHomogeneousZeros` — PREFLIGHT; implementation waits #72/#96 and reusable #99 interface.

Owned executable/near-executable work exists in #56/#71; dependency-waiting but fully preflighted work exists in #64/#78/#72/#89/#96. The worker pool therefore has parallel work without inventing unrelated slices.

### Next A actions

1. land #95 v2 after latest-head CI if four-file scope stays clean;
2. watch #71 for explicit replacement STACK-READY + merge, then ensure #72 resumes on the replacement/merged base rather than the withdrawn anchor;
3. watch #56 for minimal #78 STACK-READY; when published, route #78 to resume while keeping #64 separately gated;
4. monitor claims of #99/#100 and refill only when unclaimed safe capacity becomes thin again;
5. keep `FORMALIZATION_PROGRESS.md` synchronized only after actual main integration or independently completed source-interpretation/preflight milestones.

## Scheduler health target

- executable mathematical work when dependencies permit;
- multiple safe PREFLIGHT candidates;
- no duplicate ownership;
- no global lane idle caused only by another lane's CI/upstream wait.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
