# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: S3.3-QuadraticReciprocity
- Issue: #64
- PR: #114 — Formalize source-shaped quadratic reciprocity
- Branch: work/s3-3-quadratic-reciprocity
- Source: Chapter 1 §3.3 / Theorem 6
- State: ACTIVE
- Rule: このPRをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Legacy multi-lane work to park

2026-09-26以前の並列運用で作られた次のPR/branchは、単一レーン移行後は同時実装しない。コードは失わないようbranchを保持し、順番が来た時にlatest mainから再検証して再開する。

| Legacy PR | Work | Branch | Transition state |
| --- | --- | --- | --- |
| #92 | Chapter 2 §1.2 p-adic integer properties | work/c2-s1-2-zp-properties | PARKED |
| #116 | Chapter 2 §1.2 p-adic metric | work/c2-s1-2-zp-metric | PARKED |
| #123 | Chapter 2 §1.3 project Q_p | work/c2-s1-3-qp-field | PARKED |
| #125 | Chapter 2 §3.1 unit filtration | work/c2-s3-1-unit-filtration | PARKED |

旧A/B/C/D/E owner名、STACK-READY、stack base SHAは履歴情報にすぎず、再開時の許可や正当性を保証しない。

## Next selection rule

1. #114をend-to-endで完了しmainへmergeする。
2. latest main上の FORMALIZATION_PROGRESS.md と docs/WORK_QUEUE.md を再確認する。
3. 原典順と実際のdependencyの両方を考慮して、次の1 itemだけを ACTIVE にする。
4. parked branchを再利用する場合も、latest mainとの整合性・build・CIを最初から確認する。

## Transition note

旧 docs/LANE_STATUS.md と docs/lanes/* は廃止した。現在地はこのファイルだけで管理する。
