# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S1.3-QpField
- Issue: #96
- Previous parked PR: #123 — project `Q_p` fraction-field construction
- Recovery branch: `work/c2-s1-3-qp-field-serial`
- Source: Chapter 2 §1.3, Definition 2 and Proposition 4
- State: ACTIVE — implementation complete; final CI / self-review / merge pending
- PR: #143
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Just completed

- C2S1.2-ZpMetric / Issue #89
- recovery PR #142 merged as `f4f0710b262ef294919983f40141e788fc8280f7`
- final CI #374: policy / Lean / Verso all green
- project-local p-adic metric, topology compatibility, completeness, and integer density are now on main

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | source for serial recovery only |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | PARKED |

## Recovery rule for the current `Q_p` slice

1. recover only useful #123 code onto latest main;
2. consume the now-merged project `Z_p` algebraic and metric interfaces;
3. complete the source decomposition / valuation / Proposition 4 boundary without importing ready-made mathlib `Padic` completion facts;
4. integrate normal Formalization / Blueprint roots;
5. run policy / `lake build` / `lake exe vbp build` / PR-head CI (current final-validation step);
6. self-review and merge PR #143;
7. only then select the next single item.

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
