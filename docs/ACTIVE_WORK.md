# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S2.1-PrimitiveHomogeneousZeros
- Issue: #100
- Branch: `work/c2-s2-1-primitive-homogeneous-zeros-serial`
- Source: Chapter 2 §2.1, Proposition 6, printed p.19 / uploaded PDF p.29
- State: ACTIVE
- Dependencies now on main: Proposition 5 (#99), project `Z_p` unit/decomposition API (#72/#140), project `Q_p` fraction-field/scaling interface (#96/#143)
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Just completed

- C2S1.3-QpField / Issue #96
- recovery PR #143 merged as `5b021cb96378c51709ba8dac52d0ff6784fbbb76`
- final CI #428: policy / Lean / Verso all green
- project-local `Q_p`, unique `p^n u` decomposition, valuation/metric topology, Proposition 4 local compactness/open `Z_p`/dense `Q` are now on main

## Current Proposition 6 plan

1. ✅ represent “primitive” as a unit-coordinate condition, with an equivalent first-residue nonvanishing formulation;
2. ✅ prove compatibility of primitivity with finite residue projections;
3. ✅ strengthen the Proposition 5 compact inverse-limit argument to primitive common zeros;
4. ✅ use homogeneity plus the merged `Q_p` decomposition interface to normalize a nonzero `Q_p` common zero to a primitive `Z_p` common zero;
5. ✅ integrate Formalization / Blueprint roots;
6. 🚧 run policy / `lake build` / `lake exe vbp build` / PR-head CI;
7. self-review and merge before selecting the next item.

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | superseded by merged #143 |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | PARKED |

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
