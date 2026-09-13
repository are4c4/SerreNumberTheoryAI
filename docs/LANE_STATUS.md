# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🟡 ready | none | #60 / PR #61 docs-only cleanup | finish #61 self-review/merge, then monitor queue health, worker claims, `STACK-READY` transitions, ambiguity/conflicts, and refill before capacity becomes thin |
| B | End-to-end Formalizer | 🚧 active | #50 `S1.2-MultGroup` | `work/s1-2-mult-group` / draft PR #59 | continue end-to-end implementation and CI repair; T1(iii) is not a dependency |
| C | End-to-end Formalizer | 🚧 active | #56 `S3.2-LegendreSymbol` preflight | `work/s3-2-legendre-symbol` / PR pending | keep proof implementation gated on #55 `DONE`/`STACK-READY`; source/dependency/mathlib preflight may proceed now |
| D | End-to-end Formalizer | 🚧 active | #51 `S2.1-PowerSums`, #52 `S2.2-Chevalley`, #55 `S3.1-QuadraticElements` preflights | `work/s2-1-power-sums`, `work/s2-2-chevalley`, `work/s3-1-quadratic-elements` | keep proof bodies gated on required upstream `DONE`/`STACK-READY`; use waiting time only for safe preflight |
| E | End-to-end Formalizer | 🟡 ready | none | none | scan live queue/branches and atomic-claim the next still-unowned executable work; do not duplicate already-claimed #51/#52/#55/#56 |

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

`S1.1.Theorem1(iii)` is now end-to-end complete on `main` via #49 / PR #58. The active implementation frontier is therefore no longer a single chapter-ordered target: B is implementing §1.2 while D/C are using dependency-safe preflight capacity further downstream.

Current live ownership at the latest A check:

- B: #50 `S1.2-MultGroup`, draft PR #59
- C: #56 `S3.2-LegendreSymbol` preflight; #49 / PR #58 is completed and merged
- D: #51 `S2.1-PowerSums`, #52 `S2.2-Chevalley`, and #55 `S3.1-QuadraticElements` preflights
- E: no live canonical branch at the latest check

A #54 / PR #57 completed the source-level dependency refinement and queue refill:

- #50 `S1.2-MultGroup` — source proof does **not** depend on T1(iii).
- #51 `S2.1-PowerSums` — full proof depends on #50 cyclicity `DONE` or `STACK-READY`.
- #52 `S2.2-Chevalley` — full proof depends on #51 power-sum interface `DONE` or `STACK-READY`.
- #55 `S3.1-QuadraticElements` — D preflight confirmed the characteristic-2 half is independent of §1.2, while the full odd-characteristic/index-2 result has a hard edge to #50 cyclicity.
- #56 `S3.2-LegendreSymbol` — now claimed by C for preflight; proof implementation remains gated on the required §3.1 interface.

PR #57 passed repository policy, `lake build`, and `lake exe vbp build` and is merged. PR #58 subsequently completed Theorem 1(iii). A is therefore in scheduler/coordination mode rather than retaining either completed item as active ownership.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
