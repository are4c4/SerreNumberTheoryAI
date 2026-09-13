# FORMALIZATION_PROGRESS.md

このファイルはAI自律形式化の進捗に関する source of truth です。

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

## Phase 1 — 有限体

| Component | Interpretation | Explanation | Blueprint | Lean statement | Lean proof | CI |
| --- | --- | --- | --- | --- | --- | --- |
| 有限体の導入・必要な基本事項 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

**開始条件:** Phase 0 PRがmainへmergeされていること。

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

## 運用ルール

- active sliceは原則1つに絞る。
- 新しいsliceを始める前にopen PR / Issueとの重複を確認する。
- statementが曖昧な場合は進捗を⛔にし、`AGENTS.md` の停止条件に従う。
- Lean proofのみ完成していても、Explanation / Blueprintが未完成ならslice全体を完了扱いにしない。
- 主要な方針変更はこのファイルだけでなく `AGENTS.md` / READMEにも反映する。
