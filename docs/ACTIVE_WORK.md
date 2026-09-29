# ACTIVE_WORK.md

このファイルは単一レーン運用における現在唯一のactive mathematical workを記録します。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## Current active work

- Work ID: C2S3.1-UnitFiltration
- Issue: #108
- Branch: `work/c2-s3-1-unit-filtration-serial`
- PR: #149
- Source: Chapter 2 §3.1, printed pp.22–24 / uploaded PDF pp.32–34
- State: ACTIVE
- Base main: after PR #148 merge; Chapter 2 §2.2 Corollary 3 / dyadic quadratic Hensel lifting is DONE.
- Latest validated branch head in this run: `37f3ba78c6e7ef557bcd49fa23798b0b79f3e253`.
- Latest CI: #770 passed policy / Lean build / Verso Blueprint build.
- Dependencies now on main: project `Z_p` inverse-limit construction, residue projections and surjectivity, divisibility/principal-ideal bridge for powers of `p`, unit criterion, project `Q_p`, Hensel and quadratic corollary chain.
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Current unit-filtration proof state

The Lean development in PR #149 now contains:

- `serrePadicUnitReductionLevel`: reduction of project p-adic units to a finite residue-unit group;
- `serrePadicPrincipalUnits`: source-indexed principal-unit filtration, with `U_0 = U` and `U_(n+1)` as a kernel of reduction modulo `p^(n+1)`;
- `mem_serrePadicPrincipalUnits_succ_iff_pow_dvd`: membership in `U_(n+1)` as divisibility of `u - 1` by `p^(n+1)`;
- `serrePadicPrincipalUnits_succ_succ_le_succ`: consecutive positive levels are descending, so `U_(n+2) ≤ U_(n+1)`;
- `serrePadicUnitReduction`, `serrePadicUnitReduction_surjective`, and `serrePadicUnitsQuotientPrincipalOneEquiv`: first quotient `U/U_1 ≃ (Z/pZ)^×`;
- `serrePadicPrincipalUnitCoeffResidueHom`, its kernel theorem, its surjectivity, and `serrePadicPrincipalUnitsSuccessiveQuotientEquiv`: the source successive quotient layer;
- `serrePadicUnitRootsOfUnity`, `serrePadicTeichmuellerSubgroup`, and `serrePadicUnitRootsReduction`: the first roots-of-unity / finite-complement interface;
- `serrePadicUnitRootsReduction_pow` and `serrePadicUnitRootsReduction_ker`: reduction preserves the root condition and has kernel equal to the intersection with `U_1`.

Blueprint pages are synchronized for the unit-filtration and roots-of-unity layers.

## CI / repair state

- CI #735 failed in Lean build at `mem_serrePadicPrincipalUnits_succ_iff_pow_dvd`; fixed by inserting the explicit projection equality bridge.
- CI #742 validated the first Lean filtration layer, then exposed Blueprint notation/rendering issues.
- CI #757 validated the extended coefficient-residue Lean layer, with remaining direct Blueprint theorem-preview issues.
- CI #763/#764 validated successive quotient packaging and progress-note synchronization.
- CI #766 exposed subgroup-closure proof gaps in the first roots-of-unity file; fixed by converting set-membership hypotheses to the root equations.
- CI #767 validated the roots-of-unity Lean interface.
- CI #769 exposed Blueprint parsing failure on direct theorem previews for names containing underscores.
- CI #770 validated the repair using labeled inline Lean aliases.

## Next proof targets for this ACTIVE item

1. Prove that the kernel of `serrePadicUnitRootsReduction` is trivial.
2. Package the reduction from `serrePadicUnitRootsOfUnity` to the first residue-unit group as an isomorphism when the kernel/surjectivity proof is available.
3. Use that isomorphism as the source-shaped entry point for the finite complement `V`.
4. Keep the later §3.2 Proposition 8 and the final `Q_p` roots-of-unity corollary out of this proof boundary unless the required interfaces are already isolated.

The immediate mathematical risk is the kernel-triviality proof: it amounts to showing that a `(p-1)`-st root in `U_1` is already `1`, and should not be forced with an unsupported theorem-strength jump.

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

- roots-of-unity subgroup / finite complement `V` のstatementを勝手に強めそうな場合。
- kernel triviality で必要な torsion-free / separatedness / Hensel 型補題が未確認の場合。
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
