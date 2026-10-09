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
- Latest active-work sync head before this metadata commit: `9b7b351ca3949c999750bb61627f8e56b6090610`.
- Latest validated implementation/docs head: `9b7b351ca3949c999750bb61627f8e56b6090610`.
- Latest validated CI: #849 passed policy / Lean build / Verso Blueprint build.
- Dependencies now on main: project `Z_p` inverse-limit construction, residue projections and surjectivity, divisibility/principal-ideal bridge for powers of `p`, unit criterion, project `Q_p`, Hensel and quadratic corollary chain.
- Rule: このworkをmergeまたは明示的にpark/closeするまで、別の数学的実装PRをactiveにしない。

## Current unit-filtration proof state

The Lean development in PR #149 now contains:

- source-indexed unit reduction and principal-unit filtration in `PadicUnitFiltration.lean`;
- first quotient `U/U_1 ≃ (Z/pZ)^×` and finite quotient `U/U_(n+1) ≃ (Z/p^(n+1)Z)^×`;
- coefficient extraction, coefficient-residue map, kernel/surjectivity, product additivity, and the successive quotient equivalence `U_(n+1)/U_(n+2)`;
- roots-of-unity subgroup `serrePadicUnitRootsOfUnity`, alias `serrePadicTeichmuellerSubgroup`, first-residue reduction, residue-root target, kernel/one-fiber criteria, and conditional injectivity interfaces;
- abstract finite commutative coprime-order complement in `FiniteAbelianCoprimeSplit.lean`;
- finite residue-unit complements, cardinality/kernel-coprimality facts, uniqueness, adjacent transition maps, transition/equivalence comparisons, and adjacent transition bijectivity;
- first-residue roots identified with all first-residue units and packaged as a multiplicative equivalence;
- finite-complement residue-root equivalence and transition compatibility;
- project roots reduced to each finite complement via `serrePadicUnitRootsReductionLevelToFiniteComplement`;
- transition compatibility for those reductions via `serrePadicUnitRootsReductionLevelToFiniteComplement_transition`;
- finite-complement reduction separation and level-zero-to-all-levels propagation for project roots;
- kernel-triviality for project `(p-1)`-st roots lying in `U_1` via `serrePadicUnitRoots_principal_one_trivial`;
- injectivity and kernel-bottom packaging for both the ordinary first-residue reduction and the narrowed reduction to first-residue roots;
- conditional equivalence packaging reducing the remaining `V ≃ (Z/pZ)^×` isomorphism to surjectivity of the narrowed reduction;
- finite-complement tower subgroup/type/projections;
- `serrePadicUnitRootsToFiniteComplementTower`, sending project roots to the compatible finite-complement tower;
- `serrePadicFiniteUnitComplementTowerEquivResidueRoots`, identifying the compatible finite-complement tower with first-residue roots.

Blueprint pages are synchronized through the finite-complement tower packaging layer.

## CI / repair state

- CI #735 failed in Lean build at `mem_serrePadicPrincipalUnits_succ_iff_pow_dvd`; fixed by inserting the explicit projection equality bridge.
- CI #742 validated the first Lean filtration layer, then exposed Blueprint notation/rendering issues.
- CI #757 validated the extended coefficient-residue Lean layer, with remaining direct Blueprint theorem-preview issues.
- CI #763/#764 validated successive quotient packaging and progress-note synchronization.
- CI #767 through #798 validated the roots-of-unity interface, one-fiber criteria, conditional injectivity, and Blueprint documentation.
- CI #807 validated finite-level unit lifting and finite quotient equivalence.
- CI #810 validated the finite residue-unit complement Lean layer.
- CI #816 validated the first-residue roots identification.
- CI #818/#819 validated Blueprint and equivalence packaging for first-residue roots.
- CI #821/#823 validated finite complement transition maps and concrete transition/equivalence proofs.
- CI #831 validated the finite-complement residue-roots Blueprint after the duplicate-tag fix.
- CI #835 validated the finite-complement limit Lean layer after coercion repairs.
- CI #837 validated the finite-complement limit Blueprint inclusion.
- CI #840 validated the Lean kernel-triviality and reduction-injectivity bridge.
- CI #841 validated the Blueprint documentation for the injectivity bridge.
- CI #842 validated the Lean kernel/equivalence packaging.
- CI #843 validated the Blueprint documentation for the kernel/equivalence packaging.
- CI #844/#845 validated the progress-note synchronization through the kernel/equivalence layer.
- CI #847 validated the finite-complement tower Lean packaging after repairing the transition lambda and tower injectivity rewrite.
- CI #848 validated the Blueprint documentation for the finite-complement tower packaging.
- CI #849 validated the progress-note synchronization at head `9b7b351ca3949c999750bb61627f8e56b6090610`.

## Next proof targets for this ACTIVE item

1. Prove that `serrePadicUnitRootsToFiniteComplementTower` is surjective, or isolate the exact project-local inverse-limit compactness argument needed for that proof.
2. Compose that surjectivity with `serrePadicFiniteUnitComplementTowerEquivResidueRoots` to obtain surjectivity of `serrePadicUnitRootsReductionToResidueRoots`.
3. Package the reduction from `serrePadicUnitRootsOfUnity` to the first residue-root subgroup as an isomorphism using the already-proved injectivity.
4. Compare that isomorphism with the finite-complement residue-root equivalences.
5. Then move toward the internal product `U ≃ V × U_1` without importing a packaged p-adic unit decomposition theorem.

The immediate mathematical risk is now the project-lift/surjectivity bridge: it should construct a project root from a compatible finite-complement tower, but should not silently import a Teichmüller theorem or assume an unsupported inverse-limit theorem.

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


## 2026-10-10 — 命題7の実装と検証ゲート

- 最新のCI成功チェックポイント: `c23280cd` / CI #863（policy / Lean / Verso）。
- 有限補群塔からp進の根を復元する写像・全射性・`V ≃ (Z/pZ)ˣ` はこのチェックポイントまでLeanビルド済み。
- `d8b864d` で第一剰余への**実際の**根還元の全射性、根と第一主単数の積写像の単射・全射、命題7 `serrePadicUnitsMulEquivRootsProdPrincipal` を新規実装。
- `22373e7` で対応するBlueprint記述を追加。これら新しい宣言は**CI未確定**のため完成扱いにしない。
- 現在のACTIVEは引き続き Issue #108 / PR #149だけ。Lean / BlueprintのCIが成功したら、補群の一意性と原典の`Q_p`根の系を確認して最終レビューする。
