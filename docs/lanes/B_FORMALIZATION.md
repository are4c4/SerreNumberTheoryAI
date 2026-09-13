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
- PR: pending initial CI
- Completed on main: opening notation, Frobenius lemma, Theorem 1(i)
- Work in branch: direct fixed-point subfield construction; `X^(p^f)-X` root characterization; separability/root count; exact `Nat.card = p^f`; uniqueness among subfields of the fixed algebraically closed ambient field; umbrella theorem `serre_theorem1_ii`.
- Mathlib use: general polynomial root/splitting/separability APIs and `FiniteField.pow_card`; deliberately not using a theorem that constructs or classifies the target finite subfield.
- Cross-lane: C owns #9 Blueprint/exposition and must not be edited here; D #10 research is advisory; E integrates after B/C artifacts stabilize.
- Next: run PR CI, repair Lean/API errors, then self-review statement integrity and merge if green and no blocker remains.
- Blockers: none currently; CI has not yet checked the initial implementation.
- Shared hotspots: none edited; `FORMALIZATION_PROGRESS.md`, root import aggregators, and `docs/LANE_STATUS.md` remain untouched in this branch.

## Short resume prompt

`Bレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、B_FORMALIZATION.md、FORMALIZATION_PROGRESS.mdを確認し、#7 / formalize/s1-1-theorem1-ii-7 のLean実装とCI修正だけを進めて。statement #6を変更せず、C所有のBlueprintは編集しないで。`
