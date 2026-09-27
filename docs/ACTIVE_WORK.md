# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S2.2-HenselLifting
- Issue: #102
- Branch: `work/c2-s2-2-hensel-lifting-serial`
- Source: Chapter 2 §2.2, Theorem 1 + Corollary 1, printed pp.20–21 / uploaded PDF pp.30–31
- State: ACTIVE
- Dependencies now on main: project `Z_p` valuation/divisibility/unit interface (#72/#140), project p-adic metric/completeness interface (#89/#142)
- No project `Q_p` dependency is required for this slice.
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Run-length preference for this ACTIVE item

このHensel itemでは、ユーザーの「続けて」1回につき、短い状態確認だけで止めず、同じPR内で安全に進められる小タスクを連続して処理する。

標準の継続順:

1. live PR head / CI を確認する。
2. CI失敗があれば、最初にログを読み、原因を直す。
3. CI pendingまたはgreenなら、同じACTIVE item内で次の小補題、Blueprint同期、docs同期、PR本文更新、self-reviewを進める。
4. 新しいLean/Blueprint/docs commitを積んだら、latest headのCI起動状況を確認する。
5. run終了時には、最新head、CI状態、次の具体的補題を記録する。

ただし、次の場合は長く進めず止める:

- Taylor補題やNewton stepの数学的statementが不確かで、仮定を勝手に強めそうな場合。
- CI failureのログ確認が必要な場合。
- GitHub write拒否、merge conflict、branch不整合が出た場合。
- context/time上限が近く、未検証の主張を残しそうな場合。
- ユーザーが短時間作業や停止を明示した場合。

## Just completed

- C2S2.1-PrimitiveHomogeneousZeros / Issue #100
- PR #145 merged as `32c68109beac3f3b27504501c166022864c34c1c`
- final CI #462: policy / Lean / Verso all green
- Proposition 6: nonzero `Q_p` common zero ↔ primitive `Z_p` common zero ↔ primitive common zeros at every finite residue level

## Current Hensel plan

1. independently recheck the source boundary on printed pp.20–21 / PDF pp.30–31;
2. audit the latest-main valuation/divisibility/congruence and metric/completeness APIs rather than relying on legacy stacked heads;
3. formalize the univariate one-step Taylor improvement under `2*k < n`;
4. iterate the improvement to a Cauchy sequence and obtain an exact univariate root;
5. reduce the multivariate theorem to the univariate theorem by varying one coordinate and identify the specialized derivative with `pderiv`;
6. derive Corollary 1 (simple zero modulo `p`);
7. add independent Blueprint explanation / Lean linkage and root integration;
8. run policy / `lake build` / `lake exe vbp build` / PR-head CI;
9. self-review and merge before selecting the next item.

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | superseded by merged #143 |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | PARKED |

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
