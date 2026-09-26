# WORK_QUEUE.md

このファイルは、B/C/D/E の end-to-end formalizer が次に何を実行できるかを判断するための依存関係付き作業キューです。

`main` 上のこの表は計画の source of truth ですが、**live branch / Issue / PR / CI が表より新しい場合はlive stateを優先**します。

## 1. Queue states

- `READY` — upstreamがmainで安定し、本実装をclaim可能。
- `PREFLIGHT` — source / statement / dependency / mathlib調査を進めてよい。本proofはgate成立後。
- `STACKABLE` — 未merge upstream がstatement/interface/exact headを明示的に `STACK-READY` として固定済み。
- `WAITING` — upstream interface待ち。本実装は禁止。
- `CLAIMED` — canonical branchが存在しworker所有中。
- `CI-WAIT` — PRのCI待ち。ownerは別の安全なworkをstealしてよい。
- `BLOCKED` — item固有の停止条件。
- `DONE` — mainへ統合済みで必要なcross-layer artifact / verificationが揃っている。

## 2. Atomic claim / ownership

canonical branch作成をownership lockとします。既存branchがあるitemを、Issue上の `RELEASED` / Aの `REASSIGNED` なしに別workerが奪ってはいけません。claim後はfocused Issueへowner lane / branch / baseを記録します。

同一work itemに後発duplicate branchが生じた場合は**最初の有効なcanonical lockを優先**し、後発workをduplicate/releasedとして閉じます。

## 3. Work stealing

PR作成、CI pending、1 item merge、item固有blocker、upstream待ちはchat停止条件ではありません。実行時間が残っていれば `READY` / eligible `STACKABLE` / safe `PREFLIGHT` を再走査します。

1 workerの未merge実装PRは原則2本までです。追加の時間はpreflight、レビュー、dependency整理、CI確認、handoff同期へ使います。

## 4. Stacked branch gate

未merge upstreamへstackしてよいのは、upstream ownerが数学的statement/assumptions、downstream interface、exact head SHA、interface変更時の通知先を固定した場合だけです。upstream merge後はstack-only状態を解除し、downstream branchをlatest mainへresyncしてから統合します。

STACK-READYを後からwithdrawした場合、既存downstream commitは保存してよいが、replacement exact green SHAまたはupstream mergeまでは新しいdependent proofを追加しません。

## 5. Dependency rule

依存は章番号ではなく実際に使う数学的結果で管理します。dependency不明なら`PREFLIGHT`で確認し、新hard edgeが見つかったitemだけを待機させます。

## 6. Current queue

Mainでend-to-end完了:

- Theorem 1(ii)/(iii)
- §1.2 finite-field multiplicative group
- §2.1 power sums
- §2.2 core Chevalley–Warning + Corollary 1 + Corollary 2
- §3.1 Theorem 4 (square elements in finite fields)
- §3.2 Legendre symbol / Theorem 5(i)–(iii)
- Chapter 1 supplement (i) Gauss's lemma
- Chapter 2 §1.1 project-local `Z_p` inverse-limit construction
- Chapter 2 §2.1 Proposition 5

Live dependency graph:

- `S3.2-LegendreSymbol` #56 / PR #98 is DONE on main at `7aa158673bf0df1c62e977b508297d2e6b88610a`, including Theorem 5(i)–(iii), independent Blueprint exposition/linkage, and green CI #252.
- `S3.3-QuadraticReciprocity` #64 is C-owned, draft PR #114. It owns the normal `Formalization.lean` slot. Stable checkpoint `7a48b08d…` passed CI #289; the moving proof head has advanced to `136bdf47…` with CI #305 in progress at the latest check. Continue source coefficient/Gauss-square/Frobenius work without letting central scheduling chase every proof commit.
- `C1-Supp-GaussLemma` #78 / PR #115 is DONE on main at merge `56a5307bee7049924c9090a677492ba01a4808e2`. The source-shaped signed half-system/permutation proof, Blueprint exposition, and root linkage are integrated; its former shared-root slot is clear.
- `C2S1.2-ZpProperties` #72 is D-owned, draft PR #92. Replacement exact head `781d1b8fc4800c28934c39563ba8d8e3bd85ff7d` passed CI #297 after latest-main resync. Its mathematical interface is unchanged from the older `c43d7f09…` freeze, which remains valid for existing downstream work. For new work prefer `781d1b8f…`; scoped consumers are #89/#96/#102/#100/#104/#105/#108.
- `C2S1.2-ZpMetric` #89 is D-owned, draft PR #116. Replacement exact head `55175ebce34eda623e2b78cb486f75f7a3e7967a` is stacked on #72 `781d1b8f…` and passed CI #298. Its promised downstream interface is unchanged: #96 may consume topology/projection-ball/integer-density, and #102 may consume metric/completeness/divisibility-to-distance. Older exact `f42c68f0…` remains valid for existing work. The PR stays outside the shared root.
- `C2S1.3-QpField` #96 is B-owned and has **begun stacked implementation** in draft PR #123. Existing work validly uses the non-withdrawn exact base `f42c68f0…`; initial fraction-field/decomposition code is on head `3f61cac8…` with CI #306 in progress. For a future new restack prefer replacement #89 `55175ebc…`. Final normal root integration waits upstream/shared-root serialization.
- `C2S2.1-RootLiftingExistence` #99 / PR #103 is DONE on main at merge `326c2aec2e3f2168dfce64d5f95d678d8b6a1930`; final head `1a86c84e…` passed CI #260. Its earlier downstream-only interface for #100 remains stable.
- `C2S2.1-PrimitiveHomogeneousZeros` #100 is B-owned PREFLIGHT. The #99 finite-level interface and #72 primitive/unit subset are now stable; full proof still waits for a #96 DONE/STACK-READY scaling interface.
- `C2S2.2-HenselLifting` #102 is B-owned and **STACKABLE**. No dependent commit has been observed yet; for new work prefer replacement exact #89 head `55175ebc…` / CI #298, which contains replacement #72 `781d1b8f…`. Older `f42c68f0…` remains a valid non-withdrawn promise. B may begin the source Newton/Cauchy implementation after moving the canonical branch to an approved exact base.
- `C2S2.2-HenselQuadraticOdd` #104 is B-owned with preflight complete and proof-code-clean. Its #72 primitive/unit/projection subset is now frozen; proof waits only for #102 DONE/STACK-READY with the simple-root lifting interface.
- `C2S2.2-HenselQuadraticTwo` #105 is B-owned with preflight complete and proof-code-clean. Its #72 domain/dyadic-divisibility/valuation/unit subset is now frozen; proof waits only for #102 DONE/STACK-READY with the main `n,k` Hensel theorem.
- `C2S3.1-UnitFiltration` #108 is B-owned with PREFLIGHT complete and is now **STACKABLE for the core Proposition 7 slice**. D explicitly froze the requested #108 unit/projection/divisibility subset; for new dependent work prefer #72 replacement exact head `781d1b8f…` / CI #297. The canonical branch was still on main at the latest check, so move it before proof commits. The final roots-of-unity corollary inside project `Q_p` still waits #96.
- `C2S3.2-PrincipalUnits` #112 has an atomic canonical-branch lock at `work/c2-s3-2-principal-units` on current main, but the branch creator has not yet posted `OWNER: <lane>` on the Issue. Treat it as `CLAIMED (owner metadata pending)` and do not duplicate the branch. Proof remains gated on #108/#72; the final project `Q_p^×` formulation also needs #96.
- `C2S3.3-PadicSquares` #120 is B-owned PREFLIGHT on canonical branch `work/c2-s3-3-padic-squares`, based on current main. The branch remains proof-code-clean while #112/#96 interfaces are unsettled; merged #56 supplies the odd-prime Legendre criterion.
- `C3S1.1-HilbertBasics` #121 is D-owned with PREFLIGHT complete on canonical branch `work/c3-s1-1-hilbert-basics`. The generic field-level core is implementation-ready independently of #96, but D keeps the branch proof-code-clean under the two-unmerged-implementation-PR limit; project `Q_p` specialization waits #96.
- `C3S1.2-HilbertLocalFormula` #122 is B-owned with PREFLIGHT complete on canonical branch `work/c3-s1-2-hilbert-local-formula`. Proof remains gated on #121 plus the exact project `Q_p`/square-class/lifting interfaces from #96/#120/#100/#104/#105 actually used.
- `C3S2.1-HilbertProductFormula` #124 is B-owned with PREFLIGHT complete on canonical branch `work/c3-s2-1-hilbert-product-formula`. Proof waits #122 and the #64 reciprocity interface actually used; merged #56 supplies supplementary Legendre laws where needed.
- `C3S2.2-WeakApproximation` #129 is B-owned with PREFLIGHT complete on canonical branch `work/c3-s2-2-weak-approximation`. Lemma 1 (finite CRT) is project-independent and implementation-safe when B has a slot; the project weak-approximation theorem eventually needs #96 for the `Q_p` specialization.
- `C3S2.2-PrescribedHilbertSymbols` #130 is B-owned with PREFLIGHT complete on canonical branch `work/c3-s2-2-prescribed-hilbert-symbols`. The source two-stage sufficiency proof and exact Dirichlet/weak-approximation/product-formula edges are fixed; proof remains gated on #122/#124/#120/#129 and their local-field dependencies.
- `C4S1.1-QuadraticFormBasics` #131 is unclaimed PREFLIGHT for the generic quadratic-form definition, polarization, matrix/change-of-basis law, and discriminant. It is independent of the current p-adic/Hilbert implementation chain.
- `C4S1.2-Orthogonality` #134 is unclaimed PREFLIGHT for orthogonality, radicals/rank/nondegeneracy, orthogonal direct sums, and source Propositions 1–2. Preflight is safe now; proof consumes #131's source-facing quadratic-form interface once stable.
- `C4S1.3-IsotropicHyperbolic` #136 is unclaimed PREFLIGHT for isotropic vectors, hyperbolic planes, Proposition 3, and the value-surjectivity corollary. Preflight is safe now; proof waits #131/#134.

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2 | `DONE` | PR #94 merged | `work/s2-2-chevalley-cor2-quadratic-form` | #74 complete |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `DONE` | PR #98 merged at `7aa15867…` | `work/s3-2-legendre-symbol` | #56 complete |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `CLAIMED` | stable `7a48b08d…` CI #289; moving PR #114 head `136bdf47…`, CI #305 in progress; current Formalization-root slot | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `DONE` | PR #115 merged as `56a5307b…` | `work/c1-supp-gauss-lemma` | #78 complete |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `DONE` | PR #86 merged | `work/c2-s1-1-zp-construction` | #71 complete |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `BLOCKED` | rooted CI #351 is green only on a diagnostic Blueprint state; final four source-facing Lean links must be restored and rooted-green before republishing STACK-READY | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `WAITING` | restack after repaired #72 and compile the metric modules before republishing downstream promises | `work/c2-s1-2-zp-metric` | #89 / D |
| P13 | `C2S1.3-QpField` | §1.3 `Q_p` / Prop.4 | `BLOCKED` | PR #123 CI #306 fails in upstream #72 module; preserve commits and wait for replacement stack | `work/c2-s1-3-qp-field` | #96 / B |
| P14 | `C2S2.1-RootLiftingExistence` | §2.1 命題5 | `DONE` | PR #103 merged at `326c2aec…`, CI #260 green | `work/c2-s2-1-root-existence` | #99 complete |
| P15 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 命題6 | `PREFLIGHT` | #99 + #72 primitive/unit sides stable; full proof waits #96 scaling DONE/STACK-READY | `work/c2-s2-1-primitive-homogeneous-zeros` | #100 / B |
| P16 | `C2S2.2-HenselLifting` | §2.2 Hensel theorem + Cor.1 | `WAITING` | previous #72/#89 stack gate suspended pending compile-validated replacements | `work/c2-s2-2-hensel-lifting` | #102 / B |
| P17 | `C2S2.2-HenselQuadraticOdd` | §2.2 系2: odd-`p` quadratic lifting | `WAITING` | #72 subset frozen; wait #102 DONE/STACK-READY simple-root interface | `work/c2-s2-2-hensel-quadratic-odd` | #104 / B |
| P18 | `C2S2.2-HenselQuadraticTwo` | §2.2 系3: dyadic quadratic lifting | `WAITING` | #72 dyadic subset frozen; wait #102 DONE/STACK-READY main `n,k` theorem | `work/c2-s2-2-hensel-quadratic-two` | #105 / B |
| P19 | `C2S3.1-UnitFiltration` | §3.1 `Z_p^×` filtration / Proposition 7 | `BLOCKED` | PR #125 CI #311 fails in upstream #72 module; preserve commits and wait for repaired exact stack | `work/c2-s3-1-unit-filtration` | #108 / B |
| P20 | `C2S3.2-PrincipalUnits` | §3.2 principal units / Proposition 8 / multiplicative group theorem | `CLAIMED` | canonical branch exists at current main; owner metadata pending; proof remains gated on #108 and final theorem on #96 | `work/c2-s3-2-principal-units` | #112 / owner pending |
| P21 | `C2S3.3-PadicSquares` | §3.3 p-adic squares / Theorems 3–4 / square classes | `PREFLIGHT` | B-owned preflight; proof waits #112/#96; odd case reuses merged #56 Legendre | `work/c2-s3-3-padic-squares` | #120 / B |
| P22 | `C3S1.1-HilbertBasics` | 第3章 §1.1 Hilbert記号の定義・Norm criterion・基本公式 | `PREFLIGHT` | D preflight complete; generic core ready, project `Q_p` specialization waits #96 | `work/c3-s1-1-hilbert-basics` | #121 / D |
| P23 | `C3S1.2-HilbertLocalFormula` | 第3章 §1.2 local formula / bilinearity / nondegeneracy | `PREFLIGHT` | B preflight complete; proof waits #121/#96/#120 and actual primitive/lifting interfaces | `work/c3-s1-2-hilbert-local-formula` | #122 / B |
| P24 | `C3S2.1-HilbertProductFormula` | 第3章 §2.1 Hilbert積公式 / 定理3 | `PREFLIGHT` | B preflight complete; proof waits #122 + #64 reciprocity interface | `work/c3-s2-1-hilbert-product-formula` | #124 / B |
| P25 | `C3S2.2-WeakApproximation` | 第3章 §2.2 CRT + weak approximation lemmas | `PREFLIGHT` | B preflight complete; CRT independent, project weak approximation later consumes #96 | `work/c3-s2-2-weak-approximation` | #129 / B |
| P26 | `C3S2.2-PrescribedHilbertSymbols` | 第3章 §2.2 prescribed local Hilbert signs / Theorem 4 | `PREFLIGHT` | B preflight complete; proof waits #124/#122/#120/#129 + source-faithful Dirichlet interface | `work/c3-s2-2-prescribed-hilbert-symbols` | #130 / B |
| P27 | `C4S1.1-QuadraticFormBasics` | 第4章 §1.1 quadratic-form basics | `PREFLIGHT` | generic linear-algebra preflight safe and independent | `work/c4-s1-1-quadratic-form-basics` | #131 / unclaimed |
| P28 | `C4S1.2-Orthogonality` | 第4章 §1.2 orthogonality / radicals / nondegeneracy | `PREFLIGHT` | preflight safe; proof waits #131 source-facing quadratic-form interface | `work/c4-s1-2-orthogonality` | #134 / unclaimed |
| P29 | `C4S1.3-IsotropicHyperbolic` | 第4章 §1.3 isotropic vectors / hyperbolic planes | `PREFLIGHT` | preflight safe; proof waits #131/#134 | `work/c4-s1-3-isotropic-hyperbolic` | #136 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed. Old Corollary-2 PR #87 is superseded by merged #94; old Legendre draft #93 is superseded by merged #98.

## 7. Shared-hotspot order

1. **#114 / C** owns the current normal `Formalization.lean` single-writer slot. Stable checkpoint `7a48b08d…` passed CI #289; the moving head is `136bdf47…` with CI #305 in progress.
2. **#92 / D** and **#116 / D** remain isolated from `Formalization.lean`/`Blueprint.lean`; replacement heads `781d1b8f…` (CI #297) and `55175ebc…` (CI #298) are green.
3. **#123 / B** uses a temporary top-level `SerreNumberTheoryAI.lean` direct-import hook plus `PadicField.lean` on its private stack base. It does not edit `Formalization.lean`; final normal aggregator integration must still be serialized after upstream/root ownership clears.

A does not modify worker mathematical branches.

## 8. Queue health

Validation note: PR #123 CI #306 and PR #125 CI #311 exposed the upstream `PadicIntegerProperties.lean` errors. D then forced the owner module through CI on #72; CI #321 reproduced the failures directly on the owner branch. The current #72/#89 STACK-READY promises remain suspended for new dependent proof work until replacement heads actually compile the relevant modules. Existing downstream commits are preserved.


#120 was claimed by B, so A independently checked the next source boundary and seeded #124 for Chapter 3 §2.1 Hilbert's product formula. #112 remains branch-locked with owner metadata pending.

#129 has now also been atomically claimed by B and its preflight completed. A seeded #134 from the next independent Chapter 4 source boundary. After #130 was claimed by B and its preflight completed, A seeded #136 from the next Chapter 4 source boundary. Current clearly unclaimed safe capacity is #131/#134/#136. #64 remains executable. The p-adic #72/#89/#96/#102/#108 dependency chain stays paused for new dependency-consuming proof work until rooted compile validation is green; existing #96/#108 commits are preserved.

A should refill again only when #131/#134/#136 are claimed or cease to provide meaningful safe capacity.

## 9. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
