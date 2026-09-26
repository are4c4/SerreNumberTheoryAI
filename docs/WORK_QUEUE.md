# WORK_QUEUE.md

このファイルは単一レーンが「現在のactive workを終えた後、次に何を選ぶか」を判断するためのdependency-aware backlogです。

現行ownershipは docs/ACTIVE_WORK.md だけで管理します。2026-09-26以前のA/B/C/D/E owner表記、canonical branch lock、STACK-READY情報は履歴であり、現在の並行作業許可ではありません。

live branch / Issue / PR / CI がこの文書より新しい場合はlive stateを優先し、その後この文書を同期します。

## 1. Queue states

- ACTIVE — 現在唯一の数学的実装対象。0または1件。
- READY — active完了後にmainから着手可能。
- PREFLIGHT — 将来対象。read-onlyのsource/dependency/API確認は可能だが並行proof実装はしない。
- WAITING — main上のupstream完了待ち。
- BLOCKED — hard blockerあり。
- PARKED — 旧並列運用のbranch/PRまたは明示的に中断したwork。activeではない。
- DONE — mainへ統合済みでcross-layer artifact / verificationが揃っている。

## 2. Serial selection rule

1. docs/ACTIVE_WORK.md のACTIVEをmergeまたはparkする。
2. latest mainへ同期する。
3. source orderと実際のdependencyを確認する。
4. 次の1 itemだけをACTIVEへ昇格する。
5. 新しい数学的実装PRを1本だけ作る。
6. そのPRが終わるまで別実装へwork stealingしない。

新しいstacked implementationは行いません。downstreamがupstreamを必要とする場合、upstreamをmainへmergeしてからdownstreamへ進みます。

## 3. Transition state

Current ACTIVE:

- C2S1.2-ZpMetric — Issue #89 / work/c2-s1-2-zp-metric

Just completed:

- C2S1.2-ZpProperties — Issue #72 / PR #140, merged on main as 2edd751d…
- S3.3-QuadraticReciprocity — Issue #64 / PR #114, merged on main as 1a67db4f…

Legacy PRs to keep PARKED until their turn:

- #123 — C2S1.3-QpField
- #125 — C2S3.1-UnitFiltration

これらのbranch上のcommitは保存するが、同時実装はしない。再開時はlatest mainへ適合させ、古いstack promiseを無効としてpolicy/build/CIを再実行する。

以下のsnapshotに残るlane owner表記は2026-09-26以前の履歴であり、現行運用上のownerではない。

## 4. Mathematical queue snapshot

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
- `C3S2.2-WeakApproximation` #129 is unclaimed PREFLIGHT for the source CRT lemma and finite-place weak approximation lemma. It is mathematically independent of the Hilbert proof chain and safe for parallel work.
- `C3S2.2-PrescribedHilbertSymbols` #130 is unclaimed PREFLIGHT for Theorem 4. Proof waits #124/#122/#120/#129 and a source-faithful Dirichlet-theorem interface (the book postpones that lemma's proof to Chapter 6).
- `C4S1.1-QuadraticFormBasics` #131 is unclaimed PREFLIGHT for the generic quadratic-form definition, polarization, matrix/change-of-basis law, and discriminant. It is independent of the current p-adic/Hilbert implementation chain.

| Priority | Work ID | Target | State at transition | Gate / next action | Existing branch | Issue / legacy owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2 | `DONE` | PR #94 merged | `work/s2-2-chevalley-cor2-quadratic-form` | #74 complete |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `DONE` | PR #98 merged at `7aa15867…` | `work/s3-2-legendre-symbol` | #56 complete |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `DONE` | stable `7a48b08d…` CI #289; moving PR #114 head `136bdf47…`, CI #305 in progress; current Formalization-root slot | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `DONE` | PR #115 merged as `56a5307b…` | `work/c1-supp-gauss-lemma` | #78 complete |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `DONE` | PR #86 merged | `work/c2-s1-1-zp-construction` | #71 complete |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `DONE` | downstream CI #306/#311 exposed compile errors in the upstream module; publish a compile-validated replacement before stacking resumes | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `ACTIVE` | restack after repaired #72 and compile the metric modules before republishing downstream promises | `work/c2-s1-2-zp-metric` | #89 / D |
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
| P25 | `C3S2.2-WeakApproximation` | 第3章 §2.2 CRT + weak approximation lemmas | `PREFLIGHT` | safe independent preflight; final `Q_p` specialization may consume #96 | `work/c3-s2-2-weak-approximation` | #129 / unclaimed |
| P26 | `C3S2.2-PrescribedHilbertSymbols` | 第3章 §2.2 prescribed local Hilbert signs / Theorem 4 | `PREFLIGHT` | proof waits #124/#122/#120/#129 + source-faithful Dirichlet interface | `work/c3-s2-2-prescribed-hilbert-symbols` | #130 / unclaimed |
| P27 | `C4S1.1-QuadraticFormBasics` | 第4章 §1.1 quadratic-form basics | `PREFLIGHT` | generic linear-algebra preflight safe and independent | `work/c4-s1-1-quadratic-form-basics` | #131 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed. Old Corollary-2 PR #87 is superseded by merged #94; old Legendre draft #93 is superseded by merged #98.

## 5. Single-lane resume order

- 現在は C2S1.2-ZpMetric / Issue #89 だけを実装ACTIVEとして進める。
- metric slice merge後、latest main上でこのqueueを再評価する。
- #116 は #92 がmainで安定してから。
- #123 は必要なp進整数/metric interfaceがmainで安定してから。
- #125 は必要なunit/valuation interfaceがmainで安定してから。
- その他のPREFLIGHT候補は、上記active chainを壊さない範囲で次のACTIVE候補として評価する。

## 6. Legacy branch recovery

旧branchを再開するときは、branchが存在すること自体をownershipや正当性の根拠にしない。

1. latest mainを確認する。
2. branch差分をreviewする。
3. 必要なcommitだけをrebase/cherry-pick/再実装する。
4. source statementとdependencyを再確認する。
5. Lean / Blueprint / explanationを同期する。
6. policy / lake build / vbp build / CIを最初から通す。
7. self-reviewしてmergeする。

## 7. End-of-run synchronization

各run終了時に、ACTIVE、PR/CI、blocker、next candidateを docs/ACTIVE_WORK.md とこのqueueへ同期する。複数worker用handoffは作らない。
