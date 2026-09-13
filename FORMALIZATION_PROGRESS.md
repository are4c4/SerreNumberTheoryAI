# FORMALIZATION_PROGRESS.md

このファイルはAI自律形式化の**数学的進捗**に関する source of truth です。実行可能workとdependencyは `docs/WORK_QUEUE.md`、worker稼働状況は `docs/LANE_STATUS.md` とlive GitHub stateで管理します。

## Status legend

- ✅ complete
- 🚧 in progress
- ⬜ not started
- ⛔ blocked

各数学的sliceについて Interpretation / Explanation / Blueprint / Lean statement / Lean proof / CI を別々に管理します。全列completeは原則としてmainへ統合済みのend-to-end sliceに使います。

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

Issue #47 / PR #48 以降、Aをscheduler、B/C/D/Eを同等のend-to-end formalizer worker poolとして運用する。

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

#50 / PR #59 で、Euler関数の約数和、有限群power-root bound、有限体単元群の根数評価、`Kˣ` の巡回性をsource-shapedに統合済み。

## Phase 3 — 有限体上のべき乗和

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 べき乗和の定義と基本補題 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#51 / PR #62 でsource三分岐式とChevalley向け低指数消滅corollaryまで統合済み。

## Phase 4 — Chevalley–Warning と直後の系

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.2 core Chevalley–Warning | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 系1: 原点以外の共通零点 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 系2: 3変数以上の2次形式の非自明零点 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

#52 / PR #68 でcore theoremを、#70 / PR #80 で系1をend-to-end統合済み。系2 #85 は系1のquadratic-form specializationで、#70がDONEになったため現在 `READY`。後発 #84 は #70 のduplicateとしてclosed。

## Phase 5 — 平方剰余の相互法則への有限体準備

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 3.1 `F_q` の平方数 / 定理4 | ✅ | ✅ | ✅ | ✅ | ✅ | 🚧 |
| 3.2 Legendre記号 / 定理5 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 3.3 平方剰余の相互法則 / 定理6 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 補遺 (i) Gaussの補題 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

Current state:

- #55 / PR #82 はsourceの characteristic-2 / odd-characteristic両ケースをLean/Blueprintで実装済み。exact head `ead063fff3e3714a77c9b340ffc339f4c8f74dfd` はpolicy/build/vbp greenで、#56向けinterfaceを `STACK-READY` としてfreeze済み。最終latest-main integration/mergeが残るためCI列は🚧とする。
- #56 はC preflight完了。#55のfixed headへstack可能になったため、次は実装段階へ進める。
- #64 はC preflightでsource Gauss-sum routeとminimal #56 dependencyを固定済み。proofは #56 の sign/multiplicativity/Theorem 5(ii) subset `STACK-READY` 待ち。
- #78 Gauss lemma はunclaimed PREFLIGHT。#64には依存しない。

## Phase 6 — 第2章 p進体

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限構成 | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |
| §1.2 Proposition 1–2 + valuation | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.2 Proposition 3: metric / completeness / density | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #71 `C2S1.1-ZpConstruction` はB-ownedでdraft PR #86実装中。project-local inverse-limit constructionを使い、ready-made mathlib `PadicInt` をcompletion shortcutにしない。
- 後発 #79 は #71 duplicateとしてclosed。
- #72 はD-owned preflight完了。source上 Proposition 1–2 + valuation と Proposition 3 metric/completeness/density に分ける方針が推奨され、proofは #71 public interface待ち。Proposition 3 follow-upはqueue healthが必要になった時点で独立Issue化する。

## Continuous parallelization rules

- globalにactive sliceを1つへ制限しない。ただし **1 work item = 1 active owner**。
- B/C/D/Eは固定専門レーンではなくend-to-end worker pool。
- dependencyは `docs/WORK_QUEUE.md` のactual graphで管理する。
- work claimはcanonical branch作成をatomic lockとする。
- PR作成、CI pending、1 item完了、item固有blockerはchat停止条件ではない。
- upstream未mergeのdownstream実装は、upstreamがstatement/interface/exact headを `STACK-READY` として固定した場合のみ許可する。
- target全列completeはInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃いmainへ統合された後に記録する。
