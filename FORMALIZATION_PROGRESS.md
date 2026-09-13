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
| Continuous worker queue / work stealing / stacked-branch protocol | 🚧 |

Role-specialized lane coordination was introduced by Issue #4 / PR #5. Issue #47 replaces the specialized B/C/D/E pipeline with a scheduler + end-to-end worker pool while preserving the same mathematical safety rules.

## Phase 1 — 有限体

Source start: 日本語版『数論講義』第1部・第1章・§1・1.1、印刷頁3–4（uploaded PDF pages 13–14）。

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 1.1 導入・Frobenius 補題・定理1(i) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(ii): `F_q` の存在・一意性と `X^q-X` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(iii): 位数 `q` の有限体の一意性 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

定理1(ii)は、#6 のcanonical statement contract、C #9 / PR #18 の独立説明・Blueprint、B #7 / PR #25 のLean statement/proofをE #36 / PR #45で最終統合した。stable Lean declarationsへの`lean :=`対応を追加したintegrated headでrepository policy・`lake build`・`lake exe vbp build`がすべてgreenとなり、cross-layer statement driftも確認されなかったため、全列をcompleteとする。

**開始条件:** Phase 0の数学作業に必要な基盤がmainへmergeされていること。達成済み。

**注意:** 人間版 `are4c4/SerreNumberTheoryBlueprint` の形式化・Blueprintは数学的解答源として参照しない。

## Phase 2 — 有限体の乗法群

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 有限体の乗法群に関する対象節 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 1の**必要な前提**が安定していること。どのPhase 1結果が実際に必要かは `S1.2-MultGroup` preflightで明示し、単なるsource順だけをdependencyとして仮定しない。

## Phase 3 — 有限体上のべき乗和

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| べき乗和の定義と基本補題 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 2の必要な前提が `DONE` またはstacking可能なstable interfaceになっていること。exact dependencyは `S2.1-PowerSums` preflightで記録する。

## Phase 4 — Chevalley の定理周辺

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 補助多項式・必要な中間結果 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Chevalleyの対象定理 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 3の必要な前提が `DONE` またはstacking可能なstable interfaceになっていること。exact dependencyはpreflightで明示する。

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
