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
| 3.3 平方剰余の相互法則 / 定理6 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 補遺 (i) Gaussの補題 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

- #55 / PR #82 はcharacteristic-2 / odd-characteristic両ケースをsource-faithfulにend-to-end完成済み。
- #56 / PR #98 はmerge `7aa158673bf0df1c62e977b508297d2e6b88610a` でend-to-end完成。project Legendre value/sign、multiplicativity、square criterion、Theorem 5(i)–(iii)、primitive 8th-root route、独立Blueprint linkageを統合し、final headはCI #252 green。
- #64 / PR #114 は原典のGauss和ルートをend-to-endで実装。原始 l 乗根、係数計算 C₀=l−1 / Cᵤ=−1、第一Gauss和補題、Frobeniusによる第二補題、定理5(ii)からの最終相互法則までLean/Blueprintを同期し、ready-made quadratic reciprocity / gaussSum_sq を完了定理として使用していない。
- #78 / PR #115 はmerge `56a5307bee7049924c9090a677492ba01a4808e2` でend-to-end完成。source-shaped signed half-system/permutation proof、独立Blueprint、normal Formalization/Blueprint root linkageをmainへ統合済み。

## Phase 6 — 第2章 p進体 §1

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限構成 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §1.2 Proposition 1–2 + valuation | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §1.2 Proposition 3: metric / completeness / density | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §1.3 `Q_p` fraction field / Proposition 4 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

- #71 / PR #86: project-local inverse-limit `SerrePadicInt`, residue projections、integer embedding、compactness/continuityをend-to-end統合済み。
- #72 / PR #140: projection-kernel/quotient、unit criterion、unique `p^n * unit` decomposition、domain structure、project additive valuationをlatest mainへ統合済み。
- #89 / PR #142: p-adic distance、有限剰余levelとの対応、inverse-limit topologyとの一致、compact→complete、整数像の稠密性を統合。main `f4f0710b262ef294919983f40141e788fc8280f7`、CI #374 green。
- #96 / PR #143 は main `5b021cb96378c51709ba8dac52d0ff6784fbbb76` へ統合済み。Definition 2、unique `p^n u` decomposition、project valuation/metric、Proposition 4 local compactness/open integer subring/rational density、Blueprint/root linkageを完了し、final CI #428 green。

## Phase 7 — 第2章 §2 p進方程式

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 命題5: `Z_p` の共通零点と全 residue level の共通零点 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §2.1 命題6: homogeneous system の `Q_p` / primitive `Z_p` / residue zeros | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §2.2 Hensel lifting theorem + Corollary 1 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §2.2 Corollary 2: odd-`p` nondegenerate quadratic lifting | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §2.2 Corollary 3: dyadic quadratic lifting | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

- #99 / PR #103 はmerge `326c2aec2e3f2168dfce64d5f95d678d8b6a1930` でend-to-end完成。finite inverse-limit nonemptiness、polynomial reduction/evaluation compatibility、Proposition 5 proof、独立Blueprint、normal Formalization/Blueprint aggregator integrationまで揃い、final head `1a86c84e…` はCI #260 green。#100向けに以前freezeしたfinite-level interfaceも維持される。
- #100 / PR #145 は main `32c68109beac3f3b27504501c166022864c34c1c` へ統合済み。primitive finite-level compatibility、primitive inverse-limit recovery、homogeneous evaluation scaling、nonzero `Q_p` tuple normalization、Proposition 6 の three-condition equivalence、Blueprint/root integrationを完了し、final PR-head CI #462 green。
- #102 / PR #146 は main `3695fa0bd60adb0f0f1cb0863d5b0a4269c60bd4` へ統合済み。Taylor one-step improvement、Cauchy iteration、exact root from finite residues、coordinate specialization、multivariate theorem、Corollary 1、quadratic value-lift wrappersを完了し、final PR-head CI #590 green。
- #104 / PR #147 は main `3bd49171d8bf95a355d4eae8f7b4eef609a8d285` へ統合済み。odd-prime quadratic lifting を source-shaped derivative / determinant / primitive-vector bridgeからHenselへ接続し、final PR-head CI #700 green。
- #105 / PR #148 は main `c7c030763ee4251f10c2d96decd42fad63c66004` へ統合済み。dyadic quadratic lifting と `serreDyadicQuadratic_exists_solution_lift` を完成し、final PR-head CI #729 green。

## Phase 8 — 第2章 §3 `Q_p` の乗法群と平方類

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §3.1 unit filtration / Proposition 7 / roots of unity corollary | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| §3.2 principal units / Proposition 8 / multiplicative-group theorem | ✅ | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |
| §3.3 p-adic squares / Theorems 3–4 / square classes | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #108 / PR #149 はCI #873まで全検証がgreen。`U_n` filtration、successive quotient、有限補群塔と逆極限、命題7 `serrePadicUnitsMulEquivRootsProdPrincipal` と補群の一意性、分数体 `Q_p` の `(p-1)` 乗根の系までLean/Blueprintを完了した。PR #149 のmain統合をもってDONEとする。
- #112 は §3.1 / PR #149 のmain統合直後にREADY。fresh latest-main branchで§3.2 Proposition 8 とmultiplicative-group theoremを開始する。
- #120 は WAITING。#112完了後に、odd `p` のvaluation parity + residue Legendre criterion と dyadic `u≡1 (mod 8)` criterionを実装する。#96 / project `Q_p` はすでにmain上で完成。

## Phase 9 — 第3章 §1 Hilbert記号の局所的性質

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 Hilbert記号の定義 / norm criterion / 基本公式 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.2 明示公式 / 双1次性 / 非退化性 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #121 は PREFLIGHT。generic field-level Hilbert symbol / norm criterion / Proposition 2 のsource/API計画はIssueに整理済み。project `Q_p` interface (#96/#143) はすでにmain上で利用可能。
- #122 は WAITING。#121 と #120 のmain統合後に開始する。#96/#100/#104/#105 の必要interfaceはすでにmain上で完成。

## Phase 10 — 第3章 §2 Hilbert記号の大局的性質

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §2.1 Hilbert積公式 / 定理3 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 CRT + weak approximation lemmas | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §2.2 prescribed local Hilbert signs / 定理4 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #124 は WAITING。#122完了後に開始し、quadratic reciprocity (#64 / PR #114) はすでにmain上で利用可能。
- #129 は原典 printed pp.35–36 / uploaded PDF pp.45–46 を独立確認してseedしたunclaimed PREFLIGHT。source Lemma 1（CRT）と Lemma 2（有限個の実・p進場所に対するQのweak approximation）を対象とし、Hilbert proof chainからほぼ独立。
- #130 は原典 printed pp.35–38 / uploaded PDF pp.45–48 を独立確認してseedしたunclaimed PREFLIGHT。source Theorem 4（prescribed local Hilbert signsのglobal realization）を対象とし、proofは#124/#122/#120/#129および書籍がChapter 6へ証明を送るDirichlet theorem interface待ち。

## Phase 11 — 第4章 §1 2次形式

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 quadratic-form definition / polarization / matrix / discriminant | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.2 orthogonality / radical / nondegeneracy | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.3 isotropic vectors / hyperbolic planes | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| §1.4 orthogonal bases / adjacency theorem | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

- #131 は PREFLIGHT。原典 printed pp.39–40 / uploaded PDF pp.49–50 のsource boundaryをIssueに整理済み。単一レーンのためread-only preflightのみで、別implementation branchは開かない。
- #134 は WAITING。§1.2 orthogonality / radical / nondegeneracyを対象とし、#131のsource-facing interface待ち。
- #136 は WAITING。§1.3 isotropic vectors / hyperbolic plane / Proposition 3を対象とし、#131/#134待ち。
- #137 は WAITING。§1.4 orthogonal bases / adjacency theoremを対象とし、#131/#134待ち。§1.5 Witt theoremは明示的にscope外。

## Single-lane operation rules

- active mathematical implementationは原則1 item / 1 PRだけ。
- 現在のactive itemは `docs/ACTIVE_WORK.md` とlive GitHub stateを優先する。
- 既存PRのレビュー待ちやmerge待ちを理由に新しい数学sliceを開始しない。


### 2026-10-10 §3.1 作業中の追加実装

- CI #863（`c23280cd`）で有限補群塔の逆極限と`(p-1)`乗根への復元・全射性がLean/Versoとも成功。
- 後続コミット`d8b864d`で命題7の直積同型`serrePadicUnitsMulEquivRootsProdPrincipal`までLean定義を追加。`22373e7`でBlueprint対応を追加した。
- この後続部分のCIは確認中のため、上のPhase 8 §3.1の完了欄はまだ更新しない。
- 次はCI修復（必要なら）→補群の一意性・原典の系→source/self-review→main統合の順。§3.2はこのPRの範囲外。

### §3.1 final ready-to-merge checkpoint

- CI #868: 命題7 `V × U₁ ≃ U`、Lean・Blueprint・policy green。
- CI #870: `V` の一意性、Lean・Blueprint・policy green。
- CI #873: project `Q_p` における `p-1` 個の相異なる根の系、root import / Blueprint / policy green。
- これらは原典 printed pp.22–24 / uploaded PDF pp.32–34 の§3.1を完了する。§3.2は次の別work item。

## 2026-10-10 §3.2 シリアル移行

- PR #149 / Issue #108 はmainへ統合され、§3.1の命題7・補群一意性・Q_pの根に関する系まで完了。
- 現在唯一のACTIVEはIssue #112 / PR #152 / `work/c2-s3-2-principal-units-serial`。
- 出典 §3.2 に合わせ、冪の補題と命題8の奇素数／2進の分岐を先に形式化。§3.3はWAITINGを維持。


## 2026-10-10 §3.2 主単数群：逆極限の再構成（継続中）

- Issue #112 / draft PR #152 が単一レーンの唯一のACTIVE。
- **CI #935 green:** 原典の許容範囲における厳密`p`冪上昇、生成元候補、有限巡回商の位数と同型、自然射影と同型の可換性、有限商の逆極限部分群の定義がLean/Blueprintで検証済み。
- その後に、主単数群から逆極限への自然な準同型・フィルトレーションの分離性と単射性、有限商と剰余射影の対応、逆極限の代表元選択、代表元の剰余座標からproject-local`SerrePadicInt`を再構成するコード・Blueprintを追加。
- **CI #942 failed:** 逆極限への単射性における`QuotientGroup.eq_one_iff`の型推論を`6a14c068`で修正。追加範囲は現在のPR-head CI成功まで未検証。
- 未完了: 再構成した`p`進整数の主単数性・全射性、命題8の`Z_p`との同型、2進の場合の符号分解、`Q_p^×`の定理2。現行PRをdraftのまま保持。
