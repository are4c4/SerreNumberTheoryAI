# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🚧 active | #54 dependency graph / queue refill | `design/refine-worker-queue-54` / PR #57 | finish scheduler-doc synchronization, CI/self-review/merge; continue monitoring claims and `STACK-READY` transitions |
| B | End-to-end Formalizer | 🚧 active | #50 `S1.2-MultGroup` | `work/s1-2-mult-group` / PR pending | continue end-to-end implementation; preflight confirmed T1(iii) is not a dependency |
| C | End-to-end Formalizer | 🚧 active | #49 `S1.1-T1iii` | `work/s1-1-t1iii` / PR pending | formalize abstract uniqueness up to isomorphism end-to-end under the stabilized source contract |
| D | End-to-end Formalizer | 🚧 active | #51 `S2.1-PowerSums` + #52 `S2.2-Chevalley` preflights | `work/s2-1-power-sums`, `work/s2-2-chevalley` / PRs pending | keep both proof bodies gated on their upstream `DONE`/`STACK-READY`; use the second branch only for safe preflight while #51 waits |
| E | End-to-end Formalizer | 🟡 ready | none | none | after #57 exposes the refilled queue on main, atomic-claim the highest-priority still-unclaimed executable preflight (#55 before #56 unless live state changes) |

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

`S1.1.Theorem1(ii)` まではInterpretation / Explanation / Blueprint / Lean statement / Lean proof / CIがmain上でcompleteです。

Live worker claims at the latest A check:

- C: #49 `S1.1-T1iii`
- B: #50 `S1.2-MultGroup`
- D: #51 `S2.1-PowerSums` preflight and #52 `S2.2-Chevalley` preflight
- E: unclaimed

A #54 refined the source-level dependency graph:

- #49 `S1.1-T1iii` — abstract uniqueness up to isomorphism; source contract stabilized on the Issue.
- #50 `S1.2-MultGroup` — implementation-ready from current main; source proof does **not** depend on T1(iii).
- #51 `S2.1-PowerSums` — preflight is productive now, but full proof depends on #50 cyclicity `DONE` or `STACK-READY`.
- #52 `S2.2-Chevalley` — preflight is productive now, but full proof depends on #51 power-sum interface `DONE` or `STACK-READY`.
- #55 `S3.1-QuadraticElements` — new `PREFLIGHT`; §3.1 branches from the multiplicative-group/finite-field path rather than requiring the §2 power-sum/Chevalley chain.
- #56 `S3.2-LegendreSymbol` — new `PREFLIGHT`; implementation depends on the required §3.1 interface.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
