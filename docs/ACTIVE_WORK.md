# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S2.2-HenselQuadraticTwo
- Issue: #105
- Branch: `work/c2-s2-2-hensel-quadratic-two`
- PR: not opened yet
- Source: Chapter 2 §2.2, Corollary 3, printed p.22 / uploaded PDF p.32
- State: ACTIVE
- Base main: after PR #147 merge and active-work cleanup; odd-prime Corollary 2 is DONE.
- Dependencies now on main: Hensel lifting theorem with explicit `n,k` interface (#102/#146), dyadic value-lift wrapper in `HenselQuadraticCorollary.lean`, shared quadratic polynomial / derivative bridge / first-residue matrix infrastructure from #104/#147, project `Z_p` valuation/divisibility/unit interface (#72/#140).
- No project `Q_2` dependency is required for this slice.
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Run-length preference for this ACTIVE item

この dyadic quadratic Hensel item では、ユーザーの「続けて」「形式化を続けて」1回につき、原則として最大25分間の連続作業予算を使う。短い状態確認だけで止めず、同じPR内で安全に進められる小タスクを連続して処理する。

標準の継続順:

1. live branch / PR / CI を確認する。
2. CI失敗があれば、最初にログを読み、原因を直す。
3. CI pendingまたはgreenなら、同じACTIVE item内で次の小補題、Blueprint同期、docs同期、PR本文更新、self-reviewを進める。
4. CI pendingだけでは止まらない。待ち時間にはread-only review、次補題のstatement設計、既存API調査、docs/Blueprint同期を進める。
5. 新しいLean/Blueprint/docs commitを積んだら、latest headのCI起動状況を確認する。
6. run終了時には、最新head、CI状態、次の具体的補題を記録する。

ただし、次の場合は25分を待たず止める:

- `mod 4` 非零条件から additive valuation `1` への橋渡しで、仮定を勝手に強めそうな場合。
- determinant/primitive-vector step の dyadic factor `2` の扱いが不確かな場合。
- CI failureのログ確認が必要な場合。
- GitHub write拒否、merge conflict、branch不整合、権限エラーが出た場合。
- source boundaryやcopyright policyに不安がある場合。
- context/time上限が近く、未検証の主張を残しそうな場合。
- ユーザーが短時間作業や停止を明示した場合。

## Current dyadic quadratic plan

1. keep the existing Hensel-facing wrapper `serreHenselValueLift_mod_eight_of_derivative_valuation_one` as the direct `n=3,k=1` boundary;
2. package the coordinate-quadratic version preserving the congruence depth `2`, i.e. source modulus `4`;
3. expose the dyadic quadratic Hensel hypothesis with symmetry, value congruence mod `8`, and a chosen gradient of valuation exactly `1`;
4. add extractors for exact root, congruent lift, and combined exact/congruent lift;
5. separately investigate the source-facing `∂f/∂X_j(x) ≠ 0 (mod 4)` to valuation-one bridge;
6. separately adapt the determinant + primitive vector argument from #104 to the dyadic factor-`2` condition;
7. synchronize Blueprint / progress docs / PR body, then run policy / Lean / Verso CI.

## Just completed

- C2S2.2-HenselQuadraticOdd / Issue #104
- PR #147 merged as `3bd49171d8bf95a355d4eae8f7b4eef609a8d285`
- Final PR-head CI #700: policy / Lean / Verso all green
- Final source-facing theorem: `SerreNumberTheoryAI.serreOddQuadratic_exists_solution_lift`

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | superseded by merged #143 |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | PARKED |

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
