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

- Focused Issue: #7
- Parent: #2 Phase 1 finite fields
- Target id: `S1.1.Theorem1(ii)`
- Canonical statement contract: #6 (completed)
- Branch: `formalize/s1-1-theorem1-ii-7`
- PR: #25
- Completed on main: opening notation, Frobenius lemma, Theorem 1(i); C #9 exposition / Blueprint and D #10 mathlib research are also merged.
- Work in branch: direct fixed-point subfield construction; `X^(p^f)-X` root characterization; local separability/root count; exact `Nat.card = p^f`; uniqueness among subfields of the fixed algebraically closed ambient field; umbrella theorem `serre_theorem1_ii`.
- Mathlib use: general characteristic-power, polynomial root/splitting/separability, set-cardinality APIs, plus the elementary identity `FiniteField.pow_card`; deliberately not using GaloisField or an existing finite-field existence/uniqueness classification theorem to close the target.
- Verification: CI run #59 passed repository policy, `lake build`, and `lake exe vbp build` on head `72b176993001c5039d8c9bfdd384f94f61dfac03`.
- Semantic review: A reported no drift from #6; B rechecked that the result is existence and uniqueness as an actual `Subfield Ω`, with carrier `{x | x^(p^f)=x}` and the root set of `X^(p^f)-X`, not Theorem 1(iii)'s abstract uniqueness up to isomorphism.
- Cross-lane: C-owned Blueprint exposition is not edited here; final `lean :=` linkage and slice-wide progress completion belong to E integration after this PR merges.
- Next: final CI after this handoff-only commit, self-review PR #25, then merge if green and no new blocker appears. After merge, B should become idle until A assigns another focused Lean Issue; do not begin Theorem 1(iii) before integration completes.
- Blockers: none.
- Shared hotspots: none edited; `FORMALIZATION_PROGRESS.md`, root import aggregators, `docs/LANE_STATUS.md`, and C-owned Blueprint files remain untouched in this branch.

## Short resume prompt

`Bレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、B_FORMALIZATION.md、FORMALIZATION_PROGRESS.mdを確認し、#7 / PR #25 の最終CIと自己レビューを確認して、greenかつblockerなしならmergeして。merge後はA/Eの統合handoffを確認し、新しいfocused Lean Issueが割り当てられるまで新規数学targetをclaimしないで。`
