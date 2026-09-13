# FORMALIZATION_PROGRESS.md

このファイルはAI自律形式化の数学的進捗に関する source of truth です。チャット別の稼働状況・ownershipは `docs/LANE_STATUS.md` と `docs/lanes/*.md` で管理します。

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

B/C/D/Eが成果物単位で並列作業することはできますが、上の全項目が揃うまでslice全体をcompleteにはしません。

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

Parallel lane coordination was completed by Issue #4 / PR #5. Post-merge lane-state cleanup is tracked separately by E and does not reopen the infrastructure item.

## Phase 1 — 有限体

Source start: 日本語版『数論講義』第1部・第1章・§1・1.1、印刷頁3–4（uploaded PDF pages 13–14）。

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 1.1 導入・Frobenius 補題・定理1(i) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 定理1(ii): `F_q` の存在・一意性と `X^q-X` | ✅ | ✅ | 🚧 | ⬜ | ⬜ | ⬜ |
| 定理1(iii): 位数 `q` の有限体の一意性 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

**開始条件:** Phase 0の数学作業に必要な基盤がmainへmergeされていること。達成済み。

**注意:** 人間版 `are4c4/SerreNumberTheoryBlueprint` の形式化・Blueprintは数学的解答源として参照しない。

## Phase 2 — 有限体の乗法群

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 有限体の乗法群に関する対象節 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 1の必要な前提がmain上で安定していること。

## Phase 3 — 有限体上のべき乗和

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| べき乗和の定義と基本補題 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 2の必要な前提がmain上で安定していること。

## Phase 4 — Chevalley の定理周辺

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 補助多項式・必要な中間結果 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Chevalleyの対象定理 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

開始条件: Phase 3の必要な前提がmain上で安定していること。

## 並列運用ルール

- globalにactive sliceを1つへ制限しない。代わりに、**1 deliverable = 1 active owner** を守る。
- 各laneは原則1つのfocused Issueだけをactiveにする。BをB1/B2へ明示分割した場合は各sub-laneごとに1つまで。
- 同じ数学的targetについてBのLeanとCのBlueprintを並列化してよいが、Interpretationが安定していることを前提とする。
- 新しいdeliverableを始める前にopen PR / Issue / `docs/LANE_STATUS.md`との重複を確認する。
- statementが曖昧な場合は進捗を⛔にし、`AGENTS.md` の停止条件に従う。
- Lean proofのみ完成していても、Explanation / Blueprintが未完成ならslice全体を完了扱いにしない。
- B/Cなどlane PRのmerge後、該当列だけを更新する。全列が揃った段階でEまたはAがcross-layer整合を確認する。
- 主要な方針変更はこのファイルだけでなく `AGENTS.md` / `docs/AI_WORKFLOW.md` / READMEにも反映する。
