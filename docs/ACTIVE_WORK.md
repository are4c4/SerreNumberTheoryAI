# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S2.2-HenselQuadraticOdd
- Issue: #104
- Branch: `work/c2-s2-2-hensel-quadratic-odd-serial`
- PR: #147
- Source: Chapter 2 §2.2, Corollary 2, printed pp.21–22 / uploaded PDF pp.31–32
- State: ACTIVE
- Latest head to verify: `9307d2664d4bd5cbe94123b8ec991ffe43537e54`
- Dependencies now on main: Hensel lifting theorem and simple-root/value-lift interface (#102/#146), project `Z_p` valuation/divisibility/unit interface (#72/#140)
- No project `Q_p` dependency is required for this slice.
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Run-length preference for this ACTIVE item

この odd quadratic Hensel item では、ユーザーの「続けて」「形式化を続けて」1回につき、原則として最大25分間の連続作業予算を使う。短い状態確認だけで止めず、同じPR内で安全に進められる小タスクを連続して処理する。

標準の継続順:

1. live PR head / CI を確認する。
2. CI失敗があれば、最初にログを読み、原因を直す。
3. CI pendingまたはgreenなら、同じACTIVE item内で次の小補題、Blueprint同期、docs同期、PR本文更新、self-reviewを進める。
4. CI pendingだけでは止まらない。待ち時間にはread-only review、次補題のstatement設計、既存API調査、docs/Blueprint同期を進める。
5. 新しいLean/Blueprint/docs commitを積んだら、latest headのCI起動状況を確認する。
6. run終了時には、最新head、CI状態、次の具体的補題を記録する。

ただし、次の場合は25分を待たず止める:

- determinant/primitive-vector step の数学的statementが不確かで、仮定を勝手に強めそうな場合。
- CI failureのログ確認が必要な場合。
- GitHub write拒否、merge conflict、branch不整合、権限エラーが出た場合。
- source boundaryやcopyright policyに不安がある場合。
- context/time上限が近く、未検証の主張を残しそうな場合。
- ユーザーが短時間作業や停止を明示した場合。

## Just completed

- C2S2.2-HenselLifting / Issue #102
- PR #146 merged as `3695fa0bd60adb0f0f1cb0863d5b0a4269c60bd4`
- final PR-head CI #590: policy / Lean / Verso all green
- Hensel theorem, Corollary 1, value-lift packaging for quadratic corollaries

## Current odd quadratic plan

1. confirm PR #147 latest head / CI;
2. keep the Hensel-facing value-lift interface from #146 as the upstream boundary;
3. formalize the coordinate quadratic polynomial derivative identity;
4. rewrite the derivative under symmetry to Serre's `2 * Σ_i a_ij x_i` gradient expression;
5. package the Hensel lift from a gradient coordinate of valuation zero;
6. audit the residue/matrix API for the determinant + primitive-vector step;
7. only then attempt the nonvanishing-gradient theorem for odd `p`;
8. add independent Blueprint explanation / Lean linkage and root integration;
9. run policy / `lake build` / `lake exe vbp build` / PR-head CI;
10. self-review and merge before selecting the next item.

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | superseded by merged #143 |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | PARKED |

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
