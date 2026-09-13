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
| 系2: 3変数以上の2次形式の非自明零点 | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |

#52 / PR #68 でcore theorem、#70 / PR #80 で系1を統合済み。系2のcanonical workはC-owned #74 / draft PR #87。`MvPolynomial.IsHomogeneous f 2` と `3 ≤ Fintype.card σ` でsource statementを固定し、project-local系1へreduceする方針。#70はDONEなのでproof gateはopenだが、PR #87はlatest-main resync/verification中。後発 #85 / PR #88 はduplicateとしてclosed。

## Phase 5 — 平方剰余の相互法則への有限体準備

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 3.1 `F_q` の平方数 / 定理4 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.2 Legendre記号 / 定理5 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 3.3 平方剰余の相互法則 / 定理6 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 補遺 (i) Gaussの補題 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #55 / PR #82 はcharacteristic-2 / odd-characteristic両ケースをsource-faithfulにend-to-end完成し、main commit `329184fa3aa1e6ee748061b1cf5cb539e2c72778` へmerge済み。
- #56 はC preflightでsource boundary / theorem-strength boundary / primitive-eighth-root routeを固定済み。#55がDONEになったためcanonical branchをlatest mainへresyncして実装へ進める。
- #64 はC preflightでGauss-sum routeとminimal #56 dependencyを固定済み。proofはcharacteristic-independent Legendre sign、field compatibility、multiplicativity、Theorem 5(ii) subset待ち。
- #78 Gauss lemma はunclaimed PREFLIGHT。#64には依存しない。

## Phase 6 — 第2章 p進体

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限構成 | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |
| §1.2 Proposition 1–2 + valuation | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.2 Proposition 3: metric / completeness / density | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #71 `C2S1.1-ZpConstruction` はB-owned draft PR #86で実装中。project-local inverse-limit constructionを使い、ready-made mathlib `PadicInt` をcompletion shortcutにしない。exact head `27a414372c72f5ac749ac7e59da06da3c4c5e86f` はpolicy/build/vbp greenで、#72向けにtype/projection/extensionality/surjectivity/integer-map/compactness/continuity interfaceをSTACK-READYとしてfreeze済み。後発 #79 はduplicate closed。
- #72 はD-owned preflight complete。source上 Proposition 1–2 + valuation をalgebraic sliceとして残す。必要な#71 interfaceがSTACK-READYになったため、proof implementationはそのexact headへstack可能。#71が先にmergeした場合はmainから進める。
- #89 は #72 preflightから切り出したProposition 3 metric/topology/completeness/densityのunclaimed PREFLIGHT。proofは#72 valuation/topology-relevant interface待ち。

## Continuous parallelization rules

- globalにactive sliceを1つへ制限しない。ただし **1 work item = 1 active owner**。
- B/C/D/Eは固定専門レーンではなくend-to-end worker pool。
- dependencyは `docs/WORK_QUEUE.md` のactual graphで管理する。
- work claimはcanonical branch作成をatomic lockとする。
- PR作成、CI pending、1 item完了、item固有blockerはchat停止条件ではない。
- upstream未mergeのdownstream実装はupstreamがstatement/interface/exact headを`STACK-READY`として固定した場合のみ許可する。
- 全列completeはInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃いmainへ統合された後に記録する。
