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
- stale Issue / PR / handoff / progress driftの修正
- dependency-safeなwork item分割とqueue refill

## Not an approval gate

B/C/D/Eは安全なwork itemについてcanonical branch lockを取れればA承認を待たずに進めてよいです。Aは通常のLean/Blueprint実装をworker poolから奪いません。

## Current handoff

- State: active scheduler coordination
- Active A Issue: #81
- Canonical branch: `design/sync-live-queue-81-v2`
- Superseded A work: PR #75 / Issue #73 and PR #83 were closed rather than merging stale scheduler state.
- Latest main at branch creation includes #70 / PR #80 Chevalley Corollary 1.

### Completed checkpoints

- #49 / PR #58 — Theorem 1(iii) DONE
- #50 / PR #59 — finite-field multiplicative group DONE
- #51 / PR #62 — power sums DONE
- #52 / PR #68 — core Chevalley–Warning DONE
- #70 / PR #80 — Corollary 1 nontrivial common zero DONE

### Live ownership

- B owns #71 `C2S1.1-ZpConstruction`; draft PR #86 is active.
- C owns #56 `S3.2-LegendreSymbol` and #64 `S3.3-QuadraticReciprocity`.
- D owns #55 `S3.1-QuadraticElements` and #72 `C2S1.2-ZpProperties` preflight.
- E currently has no owned mathematical item.

### Dependency gates

- #55 / PR #82 exact head `ead063fff3e3714a77c9b340ffc339f4c8f74dfd` is CI-green and explicitly `STACK-READY` for #56. Frozen downstream declarations are:
  - `finiteFieldHalfPowerCharacter`
  - `finiteFieldHalfPowerCharacter_eq_one_or_neg_one`
  - `finiteFieldNonzeroSquares_eq_ker_halfPowerCharacter`
  - `mem_finiteFieldNonzeroSquares_iff_halfPowerCharacter_eq_one`
- #56 is therefore `STACKABLE` now; C may stack onto that exact head.
- #64 proof remains gated on a future smaller #56 subset: characteristic-independent Legendre sign/value, compatibility with the field-valued half-power core, multiplicativity, and Theorem 5(ii) at `-1`. Theorem 5(iii) at `2` is not required for §3.3.
- #71 is independent of Chapter 1 and is being implemented by B.
- #72 preflight is complete and WAITING on #71 public representation/projection/integer-map interface. D recommends splitting Proposition 3 metric/completeness/density into a follow-up after the algebraic #72 slice.

### Queue health

- #85 `S2.2-Chevalley-Cor2` is unclaimed `READY`; canonical Corollary 1 is #70 and is already DONE.
- #78 `C1-Supp-GaussLemma` is unclaimed `PREFLIGHT`; proof waits for minimal #56 interface but does not depend on #64.
- duplicate scheduler seeds #84 and #79 are closed as duplicates of #70 and #71 respectively.

### Shared-hotspot / stale PR cleanup

- A current branch changes only `docs/WORK_QUEUE.md`, `docs/LANE_STATUS.md`, `docs/lanes/A_DESIGN.md`, and `FORMALIZATION_PROGRESS.md`.
- C PR #76 touches only `docs/lanes/C_BLUEPRINT.md`, but its handoff predates #55 STACK-READY and is now stale/nonmergeable; route refresh/supersede to C rather than editing it in A.
- D PR #82 and B PR #86 remain worker-owned; A does not edit their mathematical artifacts.

### Next A actions

1. finish #81 latest-main central sync, verify CI, and self-merge if green;
2. watch #85/#78 claims so idle capacity remains available;
3. monitor #56 stack transition and #64 future `STACK-READY` edge;
4. if queue thins again, seed the source-faithful §1.2 Proposition 3 metric/completeness/density follow-up identified by #72 preflight rather than inventing unrelated work.

## Scheduler health target

- at least one `READY` item when mathematics permits;
- several safe `PREFLIGHT`/`STACKABLE` candidates;
- no duplicate canonical ownership;
- no worker idle merely because another worker is waiting on CI/upstream.

## Short resume prompt

`Aレーンとして作業を続けて。最新main、branch、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、A_DESIGN.md、FORMALIZATION_PROGRESS.mdを確認し、queue health・dependency graph・statement ambiguity・ownership conflictを管理して。B/C/D/Eの開始許可ゲートにはならず、複数のREADY/PREFLIGHT候補を先回りして維持して。`
