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

- Focused Issue: none
- Parent: #2 Phase 1 finite fields
- Target candidate: Theorem 1(ii)
- Branch / PR: none
- Completed on main: opening notation, Frobenius lemma, Theorem 1(i)
- Next: wait for A to create a focused Lean Issue and fix the statement boundary
- Blockers: ownership not yet assigned
- Shared hotspots: do not edit root import aggregators unless required and conflict-checked

## Short resume prompt

`Bレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、B_FORMALIZATION.md、FORMALIZATION_PROGRESS.mdを確認し、割り当て済みfocused IssueのLean実装だけを進めて。statementを変更せず、C所有のBlueprintは編集しないで。`
