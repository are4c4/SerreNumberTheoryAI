# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S1.2-ZpMetric
- Issue: #89
- Previous parked PR: #116 — p-adic metric / completeness / density
- Branch: work/c2-s1-2-zp-metric
- Source: Chapter 2 §1.2, Proposition 3
- State: ACTIVE
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Just completed

- C2S1.2-ZpProperties / Issue #72
- recovery PR #140 merged as `2edd751d24fb201abc1c363de633c7c1d1c3f7bd`
- policy / Lean / Verso CI green before merge
- algebraic `SerrePadicInt` interface is now on main

## Remaining legacy work to park

| Legacy PR | Work | Branch | Transition state |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project Q_p | work/c2-s1-3-qp-field | PARKED |
| #125 | Chapter 2 §3.1 unit filtration | work/c2-s3-1-unit-filtration | PARKED |

## Recovery rule for the metric slice

1. rebuild the old #116 metric files on latest main, now consuming the merged §1.2 algebraic interface rather than an unmerged stack;
2. integrate through normal Formalization / Blueprint roots;
3. recheck source statement and theorem-strength boundaries;
4. rerun policy / `lake build` / `lake exe vbp build` / PR-head CI;
5. self-review and merge;
6. only then select the next single item.

## Transition note

旧 docs/LANE_STATUS.md と docs/lanes/* は廃止した。現在地はこのファイルだけで管理する。
