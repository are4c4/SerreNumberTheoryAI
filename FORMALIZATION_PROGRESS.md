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
| 3.2 Legendre記号 / 定理5 | ✅ | ⬜ | ⬜ | 🚧 | 🚧 | 🚧 |
| 3.3 平方剰余の相互法則 / 定理6 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 補遺 (i) Gaussの補題 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #55 / PR #82 はcharacteristic-2 / odd-characteristic両ケースをsource-faithfulにend-to-end完成済み。
- #56 / PR #98 はC-owned。#64向けfrozen head `45bde2ef…` はLegendre value/sign、multiplicativity、cast-back、Theorem 5(i)/(ii)を含むCI-green interface。moving live branchはTheorem 5(iii)の後続coercion/normalization修正まで通過し、latest checked `e681e215…` はCI #232 green。独立Blueprint exposition/linkageとfinal latest-main integrationは未完了。
- #64 はC preflight completeで、frozen `45bde2ef…` からstacked implementation可能。later #56 declarationsはreplacement freezeまたはmergeなしに仮定しない。
- #78 はB preflight complete。必要なminimal #56 interfaceは存在するが現在のupstream promiseは#64専用なので、別freezeまたは#56 merge待ち。

## Phase 6 — 第2章 p進体 §1

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限構成 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §1.2 Proposition 1–2 + valuation | ✅ | ⬜ | ⬜ | 🚧 | 🚧 | 🚧 |
| §1.2 Proposition 3: metric / completeness / density | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.3 `Q_p` fraction field / Proposition 4 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #71 / PR #86 はproject-local inverse-limit `SerrePadicInt`、residue projections、integer embedding、compactness/continuity、Blueprint linkageをmainへend-to-end統合済み。
- #72 / PR #92 はD-owned。live head `81bc0f88…` はCI #219 greenで、projection-kernel、`p^(n+1)` divisibility detection、unit criteriaまで実装。sourceの `p^n * unit` decomposition、project valuation、integral-domain conclusionは継続中。
- #89 はD preflight complete。source metric normalization、inverse-limit topologyとの一致、compact→complete、integer densityのAPI planを固定し、proofは#72 valuation / `p^n Z_p` bridge待ち。
- #96 はB preflight complete。project `Q_p` を `FractionRing (SerrePadicInt p)` として構成する方針を固定。algebraic proofは#72、Proposition 4のtopology/density部分はminimal #89 interface待ち。

## Phase 7 — 第2章 §2 p進方程式

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 命題5: `Z_p` の共通零点と全 residue level の共通零点 | ✅ | ✅ | ✅ | ✅ | ✅ | 🚧 |
| §2.1 命題6: homogeneous system の `Q_p` / primitive `Z_p` / residue zeros | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Hensel lifting theorem + Corollary 1 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Corollary 2: odd-`p` nondegenerate quadratic lifting | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Corollary 3: dyadic quadratic lifting | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #99 / PR #103 はB-owned。current checked `fe1a173e…` はCI #226 greenで、finite inverse-limit nonemptiness、polynomial reduction/evaluation compatibility、Proposition 5 proof、Blueprint exposition/linkageまでisolated formで揃う。shared rootが#98にownedされているため、最終normal aggregator integration + latest-main CIのみ残る。#100向けdownstream subsetもこのheadでexplicit freeze済み。
- #100 はB-owned preflight。命題6を命題5と分離し、#99 frozen subsetをpreflight/interface用途に利用可能。full proofは#72 primitive/unit criterionと#96 `Q_p` scaling interface待ち。
- #102 はB-ownedでsource/API/dependency preflight complete。one-step Taylor remainder、multivariate specialization、iterative Cauchy proofのsource-shaped planを固定し、proofは#72 valuation/congruence/decompositionと#89 compatible completeness interface待ち。`Q_p`依存は不要。
- #104 はunclaimed PREFLIGHT。odd `p` の非退化対称二次形式についてprimitive mod-`p` solutionからsimple-root条件を導き#102 Corollary 1でliftするsource Corollary 2を対象とする。
- #105 はunclaimed PREFLIGHT。`p=2` でprimitive mod-8 solutionとpartial derivative nonzero mod 4から#102 theorem (`n=3,k=1`) を用いてliftし、invertible determinantを十分条件とするsource Corollary 3を対象とする。

## Phase 8 — 第2章 §3 `Q_p` の乗法群

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §3.1 unit filtration / Proposition 7 / roots of unity corollary | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #108 はAがsource boundaryを独立確認してseedしたunclaimed PREFLIGHT。project `U=(SerrePadicInt p)ˣ` と `U_n` のfiltration、`U_n/U_{n+1} ≃ Z/pZ`、coprime-order finite splitting、inverse-limit passageによる `U = V × U_1` と `V ≃ (Z/pZ)ˣ` をProposition 7のcoreとする。core proofは#71 + stable #72 units/divisibility interface待ちで、source corollaryをproject `Q_p` 内のroots of unityとして述べる最終bridgeだけ#96待ち。§3.2 Proposition 8はこのitemに含めない。

## Continuous parallelization rules

- globalにactive sliceを1つへ制限しない。ただし **1 work item = 1 active owner**。
- B/C/D/Eは固定専門レーンではなくend-to-end worker pool。
- dependencyは `docs/WORK_QUEUE.md` のactual graphで管理する。
- work claimはcanonical branch作成をatomic lockとする。
- PR作成、CI pending、1 item完了、item固有blockerはchat停止条件ではない。
- upstream未mergeのdownstream実装はupstreamがstatement/interface/exact headを`STACK-READY`として固定した場合のみ許可する。
- withdrawn STACK-READYではexisting workを保存し、replacement exact green SHAまたはupstream mergeまでdependent proofを増やさない。
- 全列completeはInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃いmainへ統合された後に記録する。
