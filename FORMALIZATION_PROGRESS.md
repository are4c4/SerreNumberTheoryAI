# FORMALIZATION_PROGRESS.md

このファイルはAI自律形式化の**数学的進捗**に関する source of truth です。実行可能workとdependencyは `docs/WORK_QUEUE.md`、worker稼働状況は `docs/LANE_STATUS.md` とlive GitHub stateで管理します。

## Status legend

- ✅ complete
- 🚧 in progress
- ⬜ not started
- ⛔ blocked

各数学的sliceについて Interpretation / Explanation / Blueprint / Lean statement / Lean proof / CI を別々に管理します。全列completeは原則mainへ統合済みのend-to-end sliceに使います。

## Phase 0 — Infrastructure

| Item | Status |
| --- | --- |
| Repository bootstrap | ✅ |
| `AGENTS.md` autonomy rules | ✅ |
| Public source/copyright policy | ✅ |
| Lean 4 + mathlib project scaffold | ✅ |
| Verso Blueprint scaffold | ✅ |
| CI build + policy checks | ✅ |
| Issue / PR templates | ✅ |
| Continuous worker queue / work stealing / stacked-branch protocol | ✅ |

Aをscheduler、B/C/D/Eを同等のend-to-end formalizer worker poolとして運用する。

## Phase 1 — 有限体

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 1.1 導入・Frobenius 補題・定理1(i) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(ii): `F_q` の存在・一意性と `X^q-X` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(iii): 位数 `q` の有限体の一意性 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

定理1(ii)は #6、C #9 / PR #18、B #7 / PR #25、E #36 / PR #45 を経て統合済み。定理1(iii)は #49 / PR #58 でend-to-end完成。

**注意:** 人間版 `are4c4/SerreNumberTheoryBlueprint` は数学的解答源として参照しない。

## Phase 2 — 有限体の乗法群

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.2 有限体の乗法群 / 定理2 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#50 / PR #59 でsource-shaped proofとLean/Blueprint linkageを統合済み。

## Phase 3 — 有限体上のべき乗和

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 べき乗和 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#51 / PR #62 でsource三分岐式とChevalley向け低指数消滅まで統合済み。

## Phase 4 — Chevalley–Warning と直後の系

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.2 core Chevalley–Warning | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 系1: 原点以外の共通零点 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 系2: 3変数以上の2次形式の非自明零点 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#52 / PR #68 でcore theorem、#70 / PR #80 で系1、#74 / PR #94 で系2を統合済み。系2は `MvPolynomial.IsHomogeneous f 2` と `3 ≤ Fintype.card σ` のsource statementからproject-local系1へreduceするelementary proofでmainへ入った。

## Phase 5 — 平方剰余の相互法則への有限体準備

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 3.1 `F_q` の平方数 / 定理4 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.2 Legendre記号 / 定理5 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.3 平方剰余の相互法則 / 定理6 | ✅ | ⬜ | ⬜ | 🚧 | 🚧 | 🚧 |
| 補遺 (i) Gaussの補題 | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |

- #55 / PR #82 はcharacteristic-2 / odd-characteristic両ケースをsource-faithfulにend-to-end完成済み。
- #56 / PR #98 はmerge `7aa158673bf0df1c62e977b508297d2e6b88610a` でend-to-end完成。project Legendre value/sign、multiplicativity、square criterion、Theorem 5(i)–(iii)、primitive 8th-root route、独立Blueprint linkageを統合し、final headはCI #252 green。
- #64 / draft PR #114 はC-owned。latest checked `e5abc14f…` はCI #278 greenで、merged §3.2上のprimitive root・additive character・source-shaped Gauss sum等を通常のFormalization aggregatorからbuildしている。現在のshared-root single-writer。
- #78 / draft PR #115 はB-owned。latest checked `dac9ecf5…` はCI #277 greenで、source-shaped signed half-system/permutation proof、独立Blueprint、root linkageまで進んでいる。`Formalization.lean` / `Blueprint.lean` の最終integrationは#114の後へserializeする。

## Phase 6 — 第2章 p進体 §1

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限構成 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §1.2 Proposition 1–2 + valuation | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |
| §1.2 Proposition 3: metric / completeness / density | ✅ | 🚧 | ⬜ | 🚧 | 🚧 | 🚧 |
| §1.3 `Q_p` fraction field / Proposition 4 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #71 / PR #86 はproject-local inverse-limit `SerrePadicInt`、residue projections、integer embedding、compactness/continuity、Blueprint linkageをmainへend-to-end統合済み。
- #72 / PR #92 はD-owned。exact head `c43d7f09…` はCI #261 greenで、projection/kernel、power divisibility、unit criterion、unique `p^n * unit` decomposition、project additive valuation、そのmultiplicative/ultrametric laws、domain instance、独立Blueprint expositionまで含む。Dはこのexact headを#89向けにのみSTACK-READYとしてfreezeした。他consumerへのgateは別promiseまたはmerge待ち。
- #89 / draft PR #116 はD-ownedで、#72 `c43d7f09…` にexact stack済み。latest checked `382a56d4…` はCI #267 greenで、valuation-weight・source distance・metric基本性質・`d≤exp(-n)` と `p^n∣x-y` のbridge・residue closed-ball characterizationまで実装。次はmetric topology、compact→complete、integer density。#102向けminimal completeness subsetと#96向けtopology+density subsetは安定後に別freezeするのが望ましい。
- #96 はB preflight complete。project `Q_p` を `FractionRing (SerrePadicInt p)` として構成する方針を固定。algebraic proofは#72の#96向けstable subset/merge待ち、Proposition 4はさらにminimal #89 topology/density interface待ち。

## Phase 7 — 第2章 §2 p進方程式

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 命題5: `Z_p` の共通零点と全 residue level の共通零点 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §2.1 命題6: homogeneous system の `Q_p` / primitive `Z_p` / residue zeros | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Hensel lifting theorem + Corollary 1 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Corollary 2: odd-`p` nondegenerate quadratic lifting | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Corollary 3: dyadic quadratic lifting | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #99 / PR #103 はmerge `326c2aec2e3f2168dfce64d5f95d678d8b6a1930` でend-to-end完成。finite inverse-limit nonemptiness、polynomial reduction/evaluation compatibility、Proposition 5 proof、独立Blueprint、normal Formalization/Blueprint aggregator integrationまで揃い、final head `1a86c84e…` はCI #260 green。#100向けに以前freezeしたfinite-level interfaceも維持される。
- #100 はB-owned preflight complete。#99はDONEなのでfinite-level側は安定したが、full proofは#72 primitive/unit criterionと#96 `Q_p` scaling interface待ち。
- #102 はB-ownedでsource/API/dependency preflight complete。one-step Taylor remainder、multivariate specialization、iterative Cauchy proofのsource-shaped planを固定。proofは#72 congruence/decomposition/valuationと#89 compatible completeness interface待ち。
- #104 はB-ownedでodd-`p` quadratic liftingのpreflight complete。source-shaped quadratic polynomial・gradient・residue-matrix argumentを固定し、proofは#102 simple-root liftingとminimal #72 primitive/unit/congruence interface待ち。
- #105 はB-ownedでdyadic quadratic liftingのpreflight complete。sourceの `p=2`, `n=3`, `k=1` specialization、`∂f/∂X_j=2∑ᵢaᵢⱼxᵢ`、mod-8/mod-4条件、unit determinant→mod-2 invertibility argumentを固定した。proofは#102 main Hensel theoremと#72 domain/divisibility/valuation/primitive subsetのexplicit gate待ちで、#96は不要。

## Phase 8 — 第2章 §3 `Q_p` の乗法群と平方類

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §3.1 unit filtration / Proposition 7 / roots of unity corollary | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §3.2 principal units / Proposition 8 / multiplicative-group theorem | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §3.3 p-adic squares / Theorems 3–4 / square classes | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #108 はunclaimed PREFLIGHT。project `U=(SerrePadicInt p)ˣ` と `U_n` のfiltration、successive quotients、finite coprime-order splitting、inverse-limit passageによる `U = V × U_1` と `V ≃ (Z/pZ)ˣ` をProposition 7のcoreとする。core proofは#71 + explicit stable #72 units/divisibility interface待ちで、project `Q_p` 内のroots-of-unity corollaryだけ#96待ち。
- #112 はunclaimed PREFLIGHT。source `p`-power step、Proposition 8のprincipal-unit構造、compatible finite-quotient/inverse-limit proof、およびそこからのmultiplicative-group theoremを対象とする。core proofは#108/#72、最終 `Q_p^×` theoremは#96にも依存する。
- #120 はAが次のsource boundaryを独立確認してseedしたunclaimed PREFLIGHT。odd `p` では `x=p^n u` が平方であることを `n` 偶数 + residue unitのLegendre平方条件で特徴付け、平方類商をtype `(2,2)` とする。`p=2` では `n` 偶数 + `u≡1 (mod 8)` を平方条件とし、平方類商をtype `(2,2,2)` とする。proofは#112のprincipal-unit/multiplicative decompositionと#96のproject `Q_p` interface待ちで、odd caseはmerged #56を再利用する。

## Continuous parallelization rules

- globalにactive sliceを1つへ制限しない。ただし **1 work item = 1 active owner**。
- B/C/D/Eは固定専門レーンではなくend-to-end worker pool。
- dependencyは `docs/WORK_QUEUE.md` のactual graphで管理する。
- work claimはcanonical branch作成をatomic lockとする。
- PR作成、CI pending、1 item完了、item固有blockerはchat停止条件ではない。
- upstream未mergeのdownstream実装はupstreamがstatement/interface/exact headを`STACK-READY`として固定した場合のみ許可する。
- withdrawn STACK-READYではexisting workを保存し、replacement exact green SHAまたはupstream mergeまでdependent proofを増やさない。
- 全列completeはInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃いmainへ統合された後に記録する。
