# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🚧 active | #64 §3.3 queue refill / dependency synchronization | PR #66 | finish queue refill with live #51 completion reflected; then return to scheduler monitoring |
| B | End-to-end Formalizer | 🟡 ready | no active mathematical work; post-#59 handoff cleanup only | `docs/sync-b-after-s1-2-59` / PR #63 | finish docs-only synchronization; after #66 activates a new unclaimed item, rescan and atomic-claim only if it remains unowned |
| C | End-to-end Formalizer | 🚧 active | #56 `S3.2-LegendreSymbol` preflight | `work/s3-2-legendre-symbol` | keep §3.2 proof implementation gated on #55 `DONE`/`STACK-READY`; continue safe source/dependency/mathlib preflight |
| D | End-to-end Formalizer | 🚧 active | #52 `S2.2-Chevalley` and #55 `S3.1-QuadraticElements` owned work; #51 completed in PR #62 | `work/s2-2-chevalley`; `work/s3-1-quadratic-elements` | #51 and #50 gates are now DONE on main, so resume the highest-priority dependency-safe owned implementation; publish `STACK-READY` only after interfaces are fixed and verified |
| E | End-to-end Formalizer | 🟡 ready | none | none | scan live queue/branches and atomic-claim the next still-unowned executable work; do not duplicate #52/#55/#56 |

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

`S1.1-T1iii` is complete on `main` via #49 / PR #58, `S1.2-MultGroup` is complete via #50 / PR #59, and `S2.1-PowerSums` is complete via #51 / PR #62. The project now exposes both the finite-field multiplicative-group cyclicity interface and the source-faithful low-exponent power-sum vanishing result needed downstream.

Current live ownership at the latest B check:

- A: #64 scheduler queue-refill work in PR #66; no mathematical implementation ownership.
- B: #50 / PR #59 completed; no active mathematical work. PR #63 is post-merge documentation synchronization only.
- C: #56 `S3.2-LegendreSymbol` preflight.
- D: #51 / PR #62 completed; #52 `S2.2-Chevalley` and #55 `S3.1-QuadraticElements` remain D-owned.
- E: no live canonical work at the latest check.

Dependency frontier:

- #52 `S2.2-Chevalley` — its hard #51 power-sum dependency is now DONE on main, so the D-owned implementation gate is open.
- #55 `S3.1-QuadraticElements` — its full odd-characteristic/index-2 result depends on #50 cyclicity, which is DONE on main; the D-owned implementation gate is open.
- #56 `S3.2-LegendreSymbol` — C owns preflight; proof implementation remains gated on the required #55 interface becoming `DONE` or `STACK-READY`.
- #64 `S3.3-QuadraticReciprocity` — A is seeding it as a preflight item in PR #66; its proof has a hard dependency on #56, so only preflight becomes executable once the queue activation is merged.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
