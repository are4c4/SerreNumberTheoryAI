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

**開始条件:** Phase 0の数学作業に必要な基盤がmainへmergeされていること。達成済み。

**注意:** 人間版 `are4c4/SerreNumberTheoryBlueprint` の形式化・Blueprintは数学的解答源として参照しない。

## Phase 2 — 有限体の乗法群

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 有限体の乗法群に関する対象節 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#50 / PR #59 では、§1.2（印刷頁5–6 / uploaded PDF pages 15–16）をsource boundaryとして、Euler関数の約数和、有限群のpower-root boundからの巡回性、有限体単元群での多項式根数評価、`Kˣ` の巡回性と `Nat.card Kˣ = Nat.card K - 1` をend-to-endで形式化した。Lean/Blueprint declaration linkageを含む実装headでrepository policy・`lake build`・`lake exe vbp build`がgreenとなり、Theorem 1(iii)を前提としないsource-derived dependencyも確認済みである。

開始条件: A #54 のsource/dependency auditにより、定理1(iii)はこのsource proofの前提ではないと確認した。定理1(ii)までのstable mainから本実装可能であり、live ownerは `docs/LANE_STATUS.md` / canonical branchを参照する。

## Phase 3 — 有限体上のべき乗和

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| べき乗和の定義と基本補題 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 2の乗法群巡回性が `DONE` またはstacking可能なstable interfaceになっていること。A #54 のsource auditで、§2.1 proofがこの巡回性を明示的に使うdependency edgeを確認済み。

## Phase 4 — Chevalley の定理周辺

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 補助多項式・必要な中間結果 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Chevalleyの対象定理 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 3のpower-sum interfaceが `DONE` またはstacking可能なstable interfaceになっていること。A #54 のsource auditで、§2.2 proofが単項式和の消滅に§2.1を明示的に使うdependency edgeを確認済み。

## Phase 5 — 平方剰余の相互法則への有限体準備

Source continuation: 第1章・§3。queueではまず3.1と3.2をdependency-awareなpreflight targetとしてseedする。

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 3.1 `F_q` の平方数 / 定理4 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 3.2 Legendre記号 / 定理5 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 3.3 平方剰余の相互法則 / 定理6 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件:

- 3.1: odd-characteristic側は有限体乗法群の巡回性を使うため、`S1.2-MultGroup` の必要interfaceが `DONE` または `STACK-READY` であること。§2.1/§2.2の完了は論理的前提として仮定しない。
- 3.2: §3.1の平方部分群・quadratic character記述の必要interfaceが安定していること。
- 3.3: §3.2のLegendre記号interfaceが安定してからqueueへ本格seedする。現時点ではprogress上の将来targetとしてのみ記録する。

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
