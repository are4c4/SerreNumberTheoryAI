# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S1.2-ZpProperties
- Issue: #72
- PR: #140 — Recover algebraic properties of project p-adic integers
- Branch: work/c2-s1-2-zp-properties
- Source: Chapter 2 §1.2, algebraic part of Propositions 1–2 and valuation consequences
- State: ACTIVE
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Just completed

- S3.3-QuadraticReciprocity / Issue #64 / PR #114
- merged as `1a67db4fb59cb0b8c660d3e00ad849f2623fbe6d`
- policy / Lean / Verso CI green before merge

## Legacy multi-lane work to park

2026-09-26以前の並列運用で作られた次のPR/branchは、単一レーン移行後は同時実装しない。コードは失わないようbranchを保持し、順番が来た時にlatest mainから再検証して再開する。

| Legacy PR | Work | Branch | Transition state |
| --- | --- | --- | --- |
| #116 | Chapter 2 §1.2 p-adic metric | work/c2-s1-2-zp-metric | PARKED |
| #123 | Chapter 2 §1.3 project Q_p | work/c2-s1-3-qp-field | PARKED |
| #125 | Chapter 2 §3.1 unit filtration | work/c2-s3-1-unit-filtration | PARKED |

旧A/B/C/D/E owner名、STACK-READY、stack base SHAは履歴情報にすぎず、再開時の許可や正当性を保証しない。

## Recovery rule for #140

1. latest mainへ適合させる。
2. 旧branchの有用なLean / Blueprint commitを保持する。
3. source statementとdependencyを再確認する。
4. policy / `lake build` / `lake exe vbp build` / PR-head CIを最初から再実行する。
5. self-review後にmergeする。
6. その後にのみ次の1 itemをACTIVEへ進める。

## Transition note

旧 docs/LANE_STATUS.md と docs/lanes/* は廃止した。現在地はこのファイルだけで管理する。
