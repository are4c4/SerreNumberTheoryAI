# C lane — Blueprint / Exposition

## Mission

確定済みの数学的targetについて、独立した自然言語説明、Blueprint node、依存関係、Lean declarationとの対応を整備する。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. このファイル
5. `FORMALIZATION_PROGRESS.md`
6. assigned focused Issue / open PR / CI / latest main
7. relevant files under `SerreNumberTheoryAI/Blueprint/**`

## Owned work

- independent exposition
- Blueprint ids / nodes
- `uses :=` dependencies
- `lean :=` linkage
- proof explanation at the mathematical-idea level

## Normally do not own

- Lean proof implementation
- mathlib exploration code
- global roadmap
- CI infrastructure

## Rules specific to C

- 書籍本文の翻訳・逐語的言い換えを作らない。
- statement interpretationが未確定ならAへ戻す。
- BのLean declaration名が未確定の場合、仮の名前を勝手に固定せずcross-lane dependencyとして記録する。
- Lean proofと自然言語proofの戦略が異なる場合は差異を明示する。
- B所有のformalization filesを編集しない。

## Current handoff

- Focused Issue: none
- Parent: #2 Phase 1 finite fields
- Target candidate: Theorem 1(ii)
- Branch / PR: none
- Completed on main: first finite-field slice has synchronized Blueprint content
- Next: wait for A to create a focused Blueprint/exposition Issue and statement boundary
- Blockers: ownership not yet assigned
- Cross-lane dependency: B declaration names once formalization work begins

## Short resume prompt

`Cレーンとして作業を続けて。最新main、Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、C_BLUEPRINT.md、FORMALIZATION_PROGRESS.mdを確認し、割り当て済みfocused IssueのBlueprintと独立説明を進めて。B所有のLean proofは編集しないで。`
