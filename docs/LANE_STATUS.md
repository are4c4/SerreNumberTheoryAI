# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🚧 active | #73 Chapter 2 queue refill / dependency synchronization | `design/refill-ch2-zp-73` / PR pending | land #71/#72 queue seeds, then resume monitoring/refill |
| B | End-to-end Formalizer | 🚧 active | #70 `S2.2-Chevalley-Cor1` preflight | `work/s2-2-chevalley-cor1-nontrivial-zero` | stabilize statement/interface; proof waits for #52 `DONE`/`STACK-READY` |
| C | End-to-end Formalizer | 🚧 active | #56 `S3.2-LegendreSymbol` and #64 `S3.3-QuadraticReciprocity` preflights | `work/s3-2-legendre-symbol`; `work/s3-3-quadratic-reciprocity` | keep proof bodies gated on #55/#56 respectively; use remaining time for safe preflight |
| D | End-to-end Formalizer | 🚧 active | #52 `S2.2-Chevalley` implementation and #55 `S3.1-QuadraticElements` | `work/s2-2-chevalley` / draft PR #68; `work/s3-1-quadratic-elements` | finish #52 from merged power-sum interface; advance #55 when capacity allows |
| E | End-to-end Formalizer | 🟡 ready | none | none | after #73 merges, atomic-claim the highest-priority still-unowned safe item; #71 is independent Chapter 2 preflight capacity and #72 is additional preflight capacity |

Legend: 🚧 active / 🟡 ready / ⛔ blocked / ⚪ idle.

## Coordination model

- Issue #47 / PR #48 is merged: the continuous worker-pool protocol is active on main.
- B/C/D/Eは固定専門レーンではなく同等のformalizer worker。
- workerは `docs/WORK_QUEUE.md` をscanし、canonical branch作成をownership lockとしてclaimする。
- claim後はfocused Issueへowner lane / branch / base SHAを記録する。
- branchが既に存在するwork itemを、`RELEASED` / `REASSIGNED` なしに別workerが奪わない。
- PR作成・CI pending・1 item完了・item固有blockerはchat停止条件ではない。実行時間が残っていればwork stealingする。
- 1 workerの未merge実装PRは原則2本まで。
- downstream stackはupstreamが `STACK-READY` を明記した場合だけ許可する。
- `main` とlive GitHubがこの表と矛盾する場合、live stateを優先し、この表を後で修正する。

## Current mathematical frontier

`S1.1-T1iii`, `S1.2-MultGroup`, and `S2.1-PowerSums` are end-to-end complete on `main`. The active Chapter 1 implementation fronts are Chevalley–Warning and §3.1 quadratic elements, with §3.2/§3.3 and the first Chevalley corollary already preflight-owned downstream.

Current live ownership at the latest A check:

- B: #70 `S2.2-Chevalley-Cor1` preflight.
- C: #56 `S3.2-LegendreSymbol` preflight and #64 `S3.3-QuadraticReciprocity` preflight.
- D: #52 `S2.2-Chevalley` implementation (draft PR #68) and #55 `S3.1-QuadraticElements`.
- E: no live canonical work item.
- A: #73 coordination only; no mathematical implementation ownership.

Dependency frontier:

- #52 `S2.2-Chevalley` — hard #51 power-sum dependency is DONE; implementation active under D.
- #70 first Chevalley corollary — B owns preflight; proof waits for #52 `DONE`/`STACK-READY`.
- #55 `S3.1-QuadraticElements` — hard #50 cyclicity dependency is DONE; implementation gate open under D.
- #56 `S3.2-LegendreSymbol` — C owns preflight; proof waits for #55 `DONE`/`STACK-READY`.
- #64 `S3.3-QuadraticReciprocity` — C owns preflight; proof waits for #56 `DONE`/`STACK-READY`.
- #71 `C2S1.1-ZpConstruction` — new unclaimed Chapter 2 preflight, independent of the Chapter 1 chain.
- #72 `C2S1.2-ZpProperties` — new unclaimed Chapter 2 preflight; proof waits for #71 `DONE`/`STACK-READY`, while source/API preflight is safe now.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
