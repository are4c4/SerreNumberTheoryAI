# FORMALIZATION_PROGRESS.md

このファイルはAI自律形式化の**数学的進捗**に関する source of truth です。実行可能workとdependencyは docs/WORK_QUEUE.md、現在唯一のactive workは docs/ACTIVE_WORK.md とlive GitHub stateで管理します。2026-09-26以前のA/B/C/D/E owner表記は履歴情報であり、現行ownershipではありません。

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
| Single-lane serial workflow / one-active-PR policy | ✅ |

2026-09-26以降は単一レーンがsource解釈からLean・Blueprint・CI・mergeまでend-to-endで直列に担当する。

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
| 補遺 (i) Gaussの補題 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

- #55 / PR #82 はcharacteristic-2 / odd-characteristic両ケースをsource-faithfulにend-to-end完成済み。
- #56 / PR #98 はmerge `7aa158673bf0df1c62e977b508297d2e6b88610a` でend-to-end完成。project Legendre value/sign、multiplicativity、square criterion、Theorem 5(i)–(iii)、primitive 8th-root route、独立Blueprint linkageを統合し、final headはCI #252 green。
- #64 / draft PR #114 はC-ownedで現在のshared-root single-writer。stable checkpoint `7a48b08d…` はCI #289 green、moving headは `136bdf47…` まで進みCI #305実行中。primitive root・additive character・Gauss sum・Legendre characterからsource coefficient/Gauss-square/Frobenius proofへ継続中。
- #78 / PR #115 はmerge `56a5307bee7049924c9090a677492ba01a4808e2` でend-to-end完成。source-shaped signed half-system/permutation proof、独立Blueprint、normal Formalization/Blueprint root linkageをmainへ統合済み。

## Phase 6 — 第2章 p進体 §1

> Validation note: downstream CI #306/#311 exposed compile failures in `PadicIntegerProperties.lean`. Until D publishes replacement exact heads that actually compile the new modules, #72/#89-dependent proof work is paused; existing downstream commits remain preserved.


| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限構成 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §1.2 Proposition 1–2 + valuation | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |
| §1.2 Proposition 3: metric / completeness / density | ✅ | 🚧 | ⬜ | 🚧 | 🚧 | 🚧 |
| §1.3 `Q_p` fraction field / Proposition 4 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #71 / PR #86 はproject-local inverse-limit `SerrePadicInt`、residue projections、integer embedding、compactness/continuity、Blueprint linkageをmainへend-to-end統合済み。
- #72 / PR #92 はD-owned。latest-main resync後のreplacement exact head `781d1b8f…` はCI #297 green。projection/kernel、power divisibility、unit criterion、unique `p^n * unit` decomposition、project additive valuation、multiplicative/ultrametric laws、domain instance、独立Blueprintの数学interfaceは旧 `c43d7f09…` と不変で、#89/#96/#102/#100/#104/#105/#108向けにscoped freeze済み。旧freezeもexisting workには有効。
- #89 / draft PR #116 はD-owned。replacement exact head `55175ebc…` は#72 `781d1b8f…` 上でCI #298 green。source metric、inverse-limit topologyとの一致、compact→complete、integer density、独立Blueprintまで実装し、#96向けtopology/projection-ball/densityと#102向けmetric/completeness/divisibility-to-distanceをfreeze。旧 `f42c68f0…` もexisting workには有効。shared rootは未編集。
- #96 はB-ownedでPR #123まで進んだが、現在CIはupstream `PadicIntegerProperties.lean` で失敗している。field側commitは保存し、compile-validated replacement stack待ち。

## Phase 7 — 第2章 §2 p進方程式

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 命題5: `Z_p` の共通零点と全 residue level の共通零点 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §2.1 命題6: homogeneous system の `Q_p` / primitive `Z_p` / residue zeros | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Hensel lifting theorem + Corollary 1 | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Corollary 2: odd-`p` nondegenerate quadratic lifting | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 Corollary 3: dyadic quadratic lifting | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #99 / PR #103 はmerge `326c2aec2e3f2168dfce64d5f95d678d8b6a1930` でend-to-end完成。finite inverse-limit nonemptiness、polynomial reduction/evaluation compatibility、Proposition 5 proof、独立Blueprint、normal Formalization/Blueprint aggregator integrationまで揃い、final head `1a86c84e…` はCI #260 green。#100向けに以前freezeしたfinite-level interfaceも維持される。
- #100 はB-owned preflight complete。#99と#72 primitive/unit側は安定済みで、full proofは#96の`Q_p` scaling interfaceがDONE/STACK-READYになるのを待つ。
- #102 はB-ownedでsource/API/dependency preflight complete。以前の#72/#89 stack gateはcompile-validation待ちで一時停止中。
- #104 はB-ownedでodd-`p` quadratic liftingのpreflight complete。#72 primitive/unit/congruence subsetはfreeze済みで、proofは#102 simple-root liftingのDONE/STACK-READY待ち。
- #105 はB-ownedでdyadic quadratic liftingのpreflight complete。#72 domain/dyadic-divisibility/valuation/primitive subsetはfreeze済みで、proofは#102 main `n,k` Hensel theoremのDONE/STACK-READY待ち。#96は不要。

## Phase 8 — 第2章 §3 `Q_p` の乗法群と平方類

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §3.1 unit filtration / Proposition 7 / roots of unity corollary | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §3.2 principal units / Proposition 8 / multiplicative-group theorem | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §3.3 p-adic squares / Theorems 3–4 / square classes | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #108 はB-ownedでPR #125まで進んだが、現在CIは同じupstream p進整数moduleで失敗。filtration commitは保存し、replacement stack待ち。
- #112 はcanonical branchがcurrent mainに作成済みでatomic lock成立。ただしIssue上のowner lane metadataは未記録のため、Aはownerを推測せず `CLAIMED / owner pending` として扱う。source `p`-power step、Proposition 8、multiplicative-group theoremが対象で、core proofは#108、最終 `Q_p^×` theoremは#96にも依存する。
- #120 はB-owned PREFLIGHT。odd `p` では `x=p^n u` の平方条件をvaluation parity + residue Legendreで、`p=2`ではvaluation parity + `u≡1 (mod 8)` で特徴付ける方針。branchはproof-code-cleanで、proofは#112のprincipal-unit/multiplicative decompositionと#96のproject `Q_p` interface待ち。

## Phase 9 — 第3章 §1 Hilbert記号の局所的性質

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 Hilbert記号の定義 / norm criterion / 基本公式 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.2 明示公式 / 双1次性 / 非退化性 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #121 はD-ownedでPREFLIGHT complete。generic field-level Hilbert symbol / norm criterion / Proposition 2 のAPI計画を固定し、branchはproof-code-clean。generic coreは#96なしでもimplementation-readyだが、project `Q_p` specializationは#96待ち。
- #122 はB-ownedでPREFLIGHT complete。real/`Q_p` の明示Hilbert公式、`kˣ/kˣ²` 上の双1次非退化形式、norm subgroup index-two corollaryのsource/API planを固定し、branchはproof-code-clean。proofは#121に加え、#96/#120および実際に使う#100/#104/#105 interface待ち。

## Phase 10 — 第3章 §2 Hilbert記号の大局的性質

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 Hilbert積公式 / 定理3 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 CRT + weak approximation lemmas | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 prescribed local Hilbert signs / 定理4 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #124 はB-ownedでPREFLIGHT complete。有限個を除いて local Hilbert symbol が1であり `∏_v (a,b)_v = 1` となる積公式、rational square-class generator reduction、exact #64 reciprocity edgeを固定し、branchはproof-code-clean。proofは#122と#64の実際に使うinterface待ち。
- #129 はAが原典 printed pp.35–36 / uploaded PDF pp.45–46 を独立確認してseedしたunclaimed PREFLIGHT。source Lemma 1（CRT）と Lemma 2（有限個の実・p進場所に対するQのweak approximation）を対象とし、Hilbert proof chainからほぼ独立。
- #130 はAが原典 printed pp.35–38 / uploaded PDF pp.45–48 を独立確認してseedしたunclaimed PREFLIGHT。source Theorem 4（prescribed local Hilbert signsのglobal realization）を対象とし、proofは#124/#122/#120/#129および書籍がChapter 6へ証明を送るDirichlet theorem interface待ち。

## Phase 11 — 第4章 §1 2次形式

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 quadratic-form definition / polarization / matrix / discriminant | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #131 はAが原典 printed pp.39–40 / uploaded PDF pp.49–50 を独立確認してseedしたunclaimed PREFLIGHT。char ≠ 2 の有限次元vector space上のquadratic form、associated symmetric bilinear form、isometry、basis matrix、change-of-basis `A' = XᵀAX`、discriminant mod squaresを対象とし、現在のp進/Hilbert dependency chainから独立した安全なparallel candidate。

## Single-lane operation rules

- active mathematical implementationは原則1 item / 1 PRだけ。
- source解釈、mathlib調査、Lean、Blueprint、explanation、CI、self-review、mergeを同じレーンで完結する。
- CI pendingを理由に別の実装workへ移らない。
- 新しいstacked downstream proof実装は行わない。必要なupstreamをmainへmergeしてから進む。
- 旧並列運用のbranch/PRはPARKEDとして保存できるが、再開時はlatest mainへ適合させて全checkを再実行する。
- hard blockerで別itemへ移る場合は、現在のactive PRをpark/closeし、docs/ACTIVE_WORK.mdとdocs/WORK_QUEUE.mdを同期してから移る。
- 全列completeはInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃いmainへ統合された後に記録する。
