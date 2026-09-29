# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S3.1-UnitFiltration
- Issue: #108
- Branch: `work/c2-s3-1-unit-filtration-serial`
- PR: not opened yet in this recovery run
- Source: Chapter 2 §3.1, printed pp.22–24 / uploaded PDF pp.32–34
- State: ACTIVE
- Base main: after PR #148 merge; Chapter 2 §2.2 Corollary 3 / dyadic quadratic Hensel lifting is DONE.
- Starting commit in this run: recovered the old PR #125 core definitions onto latest main and imported them from `Formalization.lean`.
- Dependencies now on main: project `Z_p` inverse-limit construction, residue projections and surjectivity, divisibility/principal-ideal bridge for powers of `p`, unit criterion, project `Q_p`, Hensel and quadratic corollary chain.
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Current unit-filtration proof state

The first recovered Lean slice contains:

- `serrePadicUnitReductionLevel`: reduction of project p-adic units to a finite residue-unit group;
- `serrePadicPrincipalUnits`: source-indexed principal-unit filtration, with `U_0 = U` and `U_(n+1)` as a kernel of reduction modulo `p^(n+1)`;
- `mem_serrePadicPrincipalUnits_succ_iff_pow_dvd`: membership in `U_(n+1)` as divisibility of `u - 1` by `p^(n+1)`;
- `serrePadicUnitReduction`: first reduction map `U → (Z/pZ)^×`;
- `serrePadicUnitReduction_surjective`: surjectivity of first reduction from residue projection surjectivity and the unit-lift criterion;
- `serrePadicUnitsQuotientPrincipalOneEquiv`: first quotient `U/U_1 ≃ (Z/pZ)^×`.

## Next proof targets for this ACTIVE item

1. Open the recovery PR and let CI validate the recovered first slice on latest main.
2. If CI fails, inspect logs first and fix the concrete API mismatch.
3. If CI is green or pending, continue inside the same PR toward a source-shaped successive quotient statement `U_n/U_(n+1) ≃ Z/pZ`, without using a packaged p-adic unit decomposition theorem.
4. Add Blueprint linkage for the recovered filtration definitions and first quotient.
5. Keep the later §3.2 Proposition 8 and the final `Q_p` roots-of-unity corollary out of this first proof boundary unless the required interfaces are already isolated.

## Run-length preference for this ACTIVE item

この unit filtration item では、ユーザーの「続けて」「形式化を続けて」1回につき、原則として最大25分間の連続作業予算を使う。短い状態確認だけで止めず、同じPR内で安全に進められる小タスクを連続して処理する。

標準の継続順:

1. live branch / PR / CI を確認する。
2. CI失敗があれば、最初にログを読み、原因を直す。
3. CI pendingまたはgreenなら、同じACTIVE item内で次の小補題、Blueprint同期、docs同期、PR本文更新、self-reviewを進める。
4. CI pendingだけでは止まらない。待ち時間にはread-only review、次補題のstatement設計、既存API調査、docs/Blueprint同期を進める。
5. 新しいLean/Blueprint/docs commitを積んだら、latest headのCI起動状況を確認する。
6. run終了時には、最新head、CI状態、次の具体的補題を記録する。

ただし、次の場合は25分を待たず止める:

- `U_n/U_(n+1)` の添字・法の対応が不確かな場合。
- finite coprime-order complement / inverse-limit subgroup `V` のstatementを勝手に強めそうな場合。
- CI failureのログ確認が必要な場合。
- GitHub write拒否、merge conflict、branch不整合、権限エラーが出た場合。
- source boundaryやcopyright policyに不安がある場合。
- context/time上限が近く、未検証の主張を残しそうな場合。
- ユーザーが短時間作業や停止を明示した場合。

## Just completed

- C2S2.2-HenselQuadraticTwo / Issue #105
- PR #148 merged as `c7c030763ee4251f10c2d96decd42fad63c66004`
- Final PR-head CI #729: policy / Lean / Verso all green
- Final source-facing theorem: `SerreNumberTheoryAI.serreDyadicQuadratic_exists_solution_lift`

## Parked legacy implementation

| Legacy PR | Work | Preserved branch | State |
| --- | --- | --- | --- |
| #123 | Chapter 2 §1.3 project `Q_p` | `work/c2-s1-3-qp-field` | superseded by merged #143 |
| #125 | Chapter 2 §3.1 unit filtration | `work/c2-s3-1-unit-filtration` | recovery source for current ACTIVE item |

## Transition note

旧 `docs/LANE_STATUS.md` と `docs/lanes/*` は廃止済みです。現行ownershipやparallel laneは存在せず、現在地はこのファイルだけで管理します。
