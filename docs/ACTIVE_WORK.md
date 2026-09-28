# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- State: NONE
- Active implementation PR: none
- Last completed work: C2S2.2-HenselQuadraticOdd / Issue #104 / PR #147
- Merge commit: `3bd49171d8bf95a355d4eae8f7b4eef609a8d285`
- Final PR-head verification: head `89e816f4ba608a4587e9fdb573b5ee9db32499ea` passed CI #700: policy / Lean / Verso all green.
- Source: Chapter 2 §2.2, Corollary 2, printed pp.21–22 / uploaded PDF pp.31–32

No new mathematical implementation is active yet.  The next item should be selected from `docs/WORK_QUEUE.md` after checking latest main and dependencies.

## Just completed

- C2S2.2-HenselQuadraticOdd / Issue #104
- PR #147 merged as `3bd49171d8bf95a355d4eae8f7b4eef609a8d285`
- Final PR-head CI #700: policy / Lean / Verso all green
- Final source-facing theorem: `SerreNumberTheoryAI.serreOddQuadratic_exists_solution_lift`

Completed proof chain:

- formal derivative expansion is proved in `HenselQuadraticOddDerivativeBridge.lean`;
- symmetry yields `2 * Σ_i a_ij x_i`;
- determinant nonzero + primitive first residue yields a nonzero matrix-vector coordinate using a no-zero-divisors adjugate/determinant argument;
- unit determinant over project `Z_p` projects to nonzero first-residue determinant;
- oddness makes the factor `2` nonzero in the first residue;
- the resulting valuation-zero derivative feeds the merged Hensel theorem;
- `serreOddQuadratic_exists_solution_lift` is the final source-facing Corollary 2 consequence.

## Previously completed

- C2S2.2-HenselLifting / Issue #102
- PR #146 merged as `3695fa0bd60adb0f0f1cb0863d5b0a4269c60bd4`
- final PR-head CI #590: policy / Lean / Verso all green
- Hensel theorem, Corollary 1, value-lift packaging for quadratic corollaries

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | superseded by merged #143 |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | PARKED |

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
