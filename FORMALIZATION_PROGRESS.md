# FORMALIZATION_PROGRESS.md

このファイルはAI自律形式化の**数学的進捗**に関する source of truth です。実行可能workとdependencyは `docs/WORK_QUEUE.md`、worker稼働状況は `docs/LANE_STATUS.md` とlive GitHub stateで管理します。

## Status legend

- ✅ complete
- 🚧 in progress
- ⬜ not started
- ⛔ blocked

各数学的sliceについて、少なくとも次を別々に管理します。

- Interpretation — 数学的主張の解釈
- Explanation — 独立した自然言語説明
- Blueprint — 依存関係とLean対応
- Lean statement
- Lean proof
- CI / policy checks

B/C/D/Eは現在end-to-end formalizer workerです。通常は1つのworkerが1 work itemについて上記layerをまとめて完成させます。大きすぎるtargetは、職種別ではなく**数学的dependencyで安全に分けられるsub-slice**へ分割します。

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
| Parallel lane coordination | ✅ |
| Continuous worker queue / work stealing / stacked-branch protocol | ✅ |

Role-specialized lane coordination was introduced by Issue #4 / PR #5. Issue #47 / PR #48 replaced the specialist B/C/D/E pipeline with A as scheduler plus four equivalent end-to-end formalizers, a dependency-aware queue, atomic branch claims, work stealing, and guarded stacked branches. PR #48 passed repository policy, `lake build`, and `lake exe vbp build` before merge.

## Phase 1 — 有限体

Source start: 日本語版『数論講義』第1部・第1章・§1・1.1、印刷頁3–4（uploaded PDF pages 13–14）。

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 1.1 導入・Frobenius 補題・定理1(i) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(ii): `F_q` の存在・一意性と `X^q-X` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(iii): 位数 `q` の有限体の一意性 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

定理1(ii)は、#6 のcanonical statement contract、C #9 / PR #18 の独立説明・Blueprint、B #7 / PR #25 のLean statement/proofをE #36 / PR #45で最終統合した。stable Lean declarationsへの`lean :=`対応を追加したintegrated headでrepository policy・`lake build`・`lake exe vbp build`がすべてgreenとなり、cross-layer statement driftも確認されなかったため、全列をcompleteとする。

定理1(iii)は #49 / PR #58 でend-to-endに完成し、位数 `p^f` の任意の有限体をTheorem 1(ii)のcanonical `p^f`-element subfieldへ同型で移す構成をLean/Blueprintで同期した。PR #58は近すぎる有限体分類定理を完成証明に使わず、policy・Lean build・Verso Blueprint buildがgreenの状態でmainへmerge済みである。

**注意:** 人間版 `are4c4/SerreNumberTheoryBlueprint` の形式化・Blueprintは数学的解答源として参照しない。

## Phase 2 — 有限体の乗法群

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 有限体の乗法群に関する対象節 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#50 / PR #59 では、§1.2（印刷頁5–6 / uploaded PDF pages 15–16）をsource boundaryとして、Euler関数の約数和、有限群のpower-root boundからの巡回性、有限体単元群での多項式根数評価、`Kˣ` の巡回性と `Nat.card Kˣ = Nat.card K - 1` をend-to-endで形式化した。Lean/Blueprint declaration linkageを含む実装headでrepository policy・`lake build`・`lake exe vbp build`がgreenとなった。

## Phase 3 — 有限体上のべき乗和

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| べき乗和の定義と基本補題 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#51 / PR #62 では、§2.1（印刷頁6 / uploaded PDF p.16）の有限体上のべき乗和をend-to-endで完成した。`S1.2-MultGroup` のproject cyclicity interfaceから指数のdivisibility判定を導き、`u = 0`、`q - 1 ∣ u`、非divisibleの三場合をsource-faithfulに形式化し、#52が必要とする低指数消滅corollaryまでLean/Blueprintで同期した。

## Phase 4 — Chevalley の定理周辺

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 補助多項式・必要な中間結果 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Chevalleyの対象定理 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 系1: 原点以外の共通零点 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 系2: 3変数以上の2次形式の非自明零点 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

#52 / PR #68 で、§2.2（印刷頁7 / uploaded PDF p.17）の**core Chevalley–Warning theorem**をend-to-endで完成した。project-local full-grid sum vanishing、indicator polynomial `∏ᵢ (1 - fᵢ^(q-1))`、degree bound、common-zero cardinalityの標数による可除性までを、#51 の低指数power-sum interfaceからsource-shapedに証明した。mathlibのnear-target Chevalley–Warning / `MvPolynomial.sum_eval_eq_zero` / finite-field power-sum完成定理はcompletion argumentとして使っていない。PR #68はpolicy・Lean build・Verso Blueprint buildがgreenでmainへmerge済みである。

#84 は本文直後の系1を `READY` itemとしてseedした。仮定は `∑ deg(f_α)<n` と全 `f_α(0)=0` で、source proofは共通零点集合が `{0}` だけなら `Card(V)=1` となりTheorem 3の標数可除性と矛盾するというcardinality argument。#85 は系2を別 `PREFLIGHT` itemとしてseedし、sourceどおり系1を1つの2次形式へ適用するdependencyを保つ。full proofは #84 `DONE`/`STACK-READY` 待ち。

## Phase 5 — 平方剰余の相互法則への有限体準備

Source continuation: 第1章・§3 と補遺。

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 3.1 `F_q` の平方数 / 定理4 | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 | 🚧 |
| 3.2 Legendre記号 / 定理5 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 3.3 平方剰余の相互法則 / 定理6 | 🚧 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 補遺 (i) Gaussの補題 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

Current source/dependency state:

- 3.1 / #55: Dがdraft PR #82でLean/Blueprint実装まで進めた。最初のCIで出た`Nat.card` noncomputabilityとFrobenius surjectivity elaborationの2点は修正済みで、latest head `ead063fff3e3714a77c9b340ffc339f4c8f74dfd` / CI #153 はpolicy・Lean build・Verso Blueprint buildまでgreen。まだmain未mergeなので全列completeにはせず、Dのfinal self-review / interface freeze / merge待ちとする。
- 3.2 / #56: C preflightはsource boundary・mathlib boundaryを固定済み。proofは#55のhalf-power `{±1}` / square-kernel interface `DONE`/`STACK-READY`待ち。
- 3.3 / #64: C preflightはGauss-sum proofのsource boundaryを固定し、必要な#56 interfaceをLegendre sign layer・multiplicativity・Theorem 5(ii) at `-1`・cross-characteristic sign compatibilityまで狭めた。Theorem 5(iii) at `2` はsource dependencyではない。
- 補遺 (i) / #78: fresh PREFLIGHT candidate。#64の完了は不要で、minimal #56 Legendre/half-power interfaceのみがproof dependency。

## Phase 6 — 第2章 p進体

Source start: 第2章「p進体」、§1「環 `Z_p` と体 `Q_p`」。

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| §1.1 `Z_p` の射影極限定義 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

#79 は printed pp.15–16 / uploaded PDF pp.25–26 の1.1「定義」をPREFLIGHT targetとしてseedした。`A_n = Z/p^n Z` の射影系、compatible sequenceとしてのinverse limit、componentwise ring operations、product/subspace topology・compactness、`Z → Z_p` のcanonical embeddingまでをsource boundaryとし、§1.2 命題1は含めない。

これはChapter 1のquadratic-residue chainから数学的に独立しており、representation/API preflight後はmainからend-to-end実装可能。mathlibのready-made `PadicInt` をsource inverse-limit constructionの代用としてcompletionに使わない。

## Continuous parallelization rules

- globalにactive sliceを1つへ制限しない。ただし **1 work item = 1 active owner** を守る。
- B/C/D/Eは固定専門レーンではなくend-to-end worker pool。
- `docs/WORK_QUEUE.md` のactual dependency graphに従い、source順だけで並列化可否を決めない。
- work claimはcanonical branch作成をatomic lockとして行う。
- PR作成、CI pending、1 work item完了、1 item固有blockerはworker chatの停止条件ではない。
- workerは実行時間が残る限り `READY` / eligible `STACKABLE` / `PREFLIGHT` をwork stealingする。
- upstream未mergeのdownstream実装は、upstreamが `STACK-READY` とstatement / interface / head SHAを固定した場合だけ許可する。
- 1 workerの未merge実装PRは原則2本まで。
- blockerはそのitemだけを止め、別の安全なworkがあればworkerは継続する。
- target完了はInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃ってから記録する。
- 主要なworkflow変更は `AGENTS.md` / `docs/AI_WORKFLOW.md` / `docs/WORK_QUEUE.md` / READMEにも反映する。
