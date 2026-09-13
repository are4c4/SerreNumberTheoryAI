# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🟡 ready | none | none | monitor queue health, worker claims, `STACK-READY` transitions, ambiguity/conflicts, and refill before capacity becomes thin |
| B | End-to-end Formalizer | 🟡 ready | no active mathematical work; post-#59 handoff cleanup only | `docs/sync-b-after-s1-2-59` / PR #63 | finish docs-only synchronization, then rescan live queue and atomic-claim only a newly seeded or released executable item |
| C | End-to-end Formalizer | 🚧 active | #56 `S3.2-LegendreSymbol` preflight | `work/s3-2-legendre-symbol` | keep §3.2 proof implementation gated on #55 `DONE`/`STACK-READY`; continue safe source/dependency/mathlib preflight |
| D | End-to-end Formalizer | 🚧 active | #51 `S2.1-PowerSums` implementation; #52 `S2.2-Chevalley` and #55 `S3.1-QuadraticElements` owned downstream work | `work/s2-1-power-sums` / PR #62; `work/s2-2-chevalley`; `work/s3-1-quadratic-elements` | #50 is DONE, so #51 and the #50-dependent part of #55 may proceed from main; keep #52 gated on #51 `DONE`/`STACK-READY` |
| E | End-to-end Formalizer | 🟡 ready | none | none | scan live queue/branches and atomic-claim the next still-unowned executable work; do not duplicate #51/#52/#55/#56 |

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

`S1.1-T1iii` is end-to-end complete on `main` via #49 / PR #58, and `S1.2-MultGroup` is end-to-end complete on `main` via #50 / PR #59. The stable project interface `SerreNumberTheoryAI.finiteField_units_isCyclic : IsCyclic Kˣ` is therefore available directly from main.

Current live ownership at the latest B check:

- A: no active implementation work; ready scheduler.
- B: #50 / PR #59 completed; no active mathematical work. PR #63 is post-merge documentation synchronization only.
- C: #56 `S3.2-LegendreSymbol` preflight; post-Theorem-1(iii) handoff synchronization completed in PR #65.
- D: #51 `S2.1-PowerSums` is in implementation with PR #62; #52 `S2.2-Chevalley` and #55 `S3.1-QuadraticElements` remain D-owned.
- E: no live canonical work at the latest check.

Dependency frontier:

- #51 `S2.1-PowerSums` — the #50 cyclicity gate is satisfied on main; D is implementing the source-faithful power-sum theorem.
- #52 `S2.2-Chevalley` — full proof remains gated on #51 `DONE` or an explicit `STACK-READY` interface.
- #55 `S3.1-QuadraticElements` — D preflight found the characteristic-2 half independent of §1.2, while the full odd-characteristic/index-2 result has a hard edge to #50; that #50 edge is now satisfied on main.
- #56 `S3.2-LegendreSymbol` — C owns preflight; proof implementation remains gated on the required #55 interface becoming `DONE` or `STACK-READY`.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
