# B lane — Lean Formalization

## Mission

確定済みの数学的statementをLean 4 + mathlibで機械検証可能にする。証明を通すために主張を変えない。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. このファイル
5. `FORMALIZATION_PROGRESS.md`
6. assigned focused Issue / open PR / CI / latest main
7. relevant files under `SerreNumberTheoryAI/Formalization/**`

## Owned work

- Lean definitions / statements / proofs
- Lean固有の補助lemma
- imports local to formalization files
- proof-oriented tests / examples that remain useful

## Normally do not own

- Blueprint prose / dependency graph
- global roadmap / Issue分割
- broad mathlib survey unrelated to current blocker
- workflow infrastructure

## Rules specific to B

- focused Issueなしに新しい数学的targetをclaimしない。
- statement interpretationがIssueで固定されていない場合はAへ戻す。
- Dの調査結果は候補として利用するが、自分でも型・仮定・強さを確認する。
- 対象定理そのものに近すぎるmathlib theoremだけで終了しない。
- `sorry`, `admit`, proof-hole `axiom`は禁止。
- Cが同じtargetのBlueprintを作業中でも、C所有ファイルを編集しない。

## Current handoff

- State: idle / completed for `S1.1.Theorem1(ii)`.
- Focused Issue: #7 — completed and closed.
- Parent: #2 Phase 1 finite fields.
- Canonical statement contract: #6 — completed.
- PR #25 merged to `main` as `867596b045a44d09bce9a449c98bd306f6b14812`.
- Completed Lean artifact: direct fixed-point subfield construction; `X^(p^f)-X` root characterization; local separability/root count; exact `Nat.card = p^f`; uniqueness among subfields of the fixed algebraically closed ambient field; umbrella theorem `serre_theorem1_ii`.
- Verification: final PR-head CI run #66 passed repository policy, `lake build`, and `lake exe vbp build` on `042c35bdbddac2cdae01b2fbb046d02ce38b3f07`. Earlier run #63 was a GitHub Actions `startup_failure` before job creation and was superseded by the green run #66.
- Semantic review: A found no drift from #6. The merged theorem is existence and uniqueness as an actual `Subfield Ω`, with carrier `{x | x^(p^f)=x}` and the root set of `X^(p^f)-X`; Theorem 1(iii)'s abstract uniqueness up to isomorphism remains separate.
- Mathlib boundary: the proof uses general characteristic-power, polynomial root/splitting/separability, set-cardinality APIs, plus the elementary identity `FiniteField.pow_card`; it does not close the target through GaloisField or an existing finite-field existence/uniqueness classification theorem.
- Downstream: E owns focused integration Issue #36 for stable `lean :=` Blueprint linkage, integrated build, progress synchronization, and completion of the Theorem 1(ii) slice. B has explicitly notified #36 that PR #25 is merged and declaration names are frozen.
- Coordination: A Issue #37 owns the stale central `docs/LANE_STATUS.md` repair. B does not edit that shared board here.
- Next: remain idle until A assigns a new focused Lean Issue. Do not start Theorem 1(iii) while E #36 is unfinished unless the dependency graph is explicitly changed.
- Blockers: none for the completed B artifact.

## Short resume prompt

`Bレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、B_FORMALIZATION.md、FORMALIZATION_PROGRESS.mdを確認して。#7 / PR #25 は完了済みなので、Aから新しいfocused Lean Issueが割り当てられていなければidleで停止し、E #36のintegrationやC所有Blueprintを奪わないで。Theorem 1(iii)はTheorem 1(ii)統合完了前にclaimしないで。`
