# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🟡 ready | none | none | monitor queue health, worker claims, `STACK-READY` transitions, ambiguity/conflicts; refill before executable/preflight capacity becomes thin |
| B | End-to-end Formalizer | 🚧 active | #50 `S1.2-MultGroup` | `work/s1-2-mult-group` / draft PR #59 | repair latest-head CI and continue end-to-end self-review; T1(iii) is not a dependency |
| C | End-to-end Formalizer | 🚧 active | #49 `S1.1-T1iii` | `work/s1-1-t1iii` / draft PR #58 | repair latest-head CI and preserve the stabilized abstract-isomorphism statement boundary |
| D | End-to-end Formalizer | 🚧 active | #51 `S2.1-PowerSums`, #52 `S2.2-Chevalley`, #55 `S3.1-QuadraticElements` preflights | `work/s2-1-power-sums`, `work/s2-2-chevalley`, `work/s3-1-quadratic-elements` | keep proof bodies gated on required upstream `DONE`/`STACK-READY`; use waiting time only for safe preflight |
| E | End-to-end Formalizer | 🟡 ready | none | none | atomic-claim the highest-priority still-unclaimed executable work; #56 is the visible unclaimed preflight at the latest check |

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

Current live ownership at the latest A check:

- C: #49 `S1.1-T1iii`, draft PR #58
- B: #50 `S1.2-MultGroup`, draft PR #59
- D: #51 `S2.1-PowerSums`, #52 `S2.2-Chevalley`, and #55 `S3.1-QuadraticElements` preflights
- E: unclaimed

A #54 / PR #57 completed the source-level dependency refinement and queue refill:

- #49 `S1.1-T1iii` — abstract uniqueness up to isomorphism; source contract stabilized on the Issue.
- #50 `S1.2-MultGroup` — source proof does **not** depend on T1(iii).
- #51 `S2.1-PowerSums` — full proof depends on #50 cyclicity `DONE` or `STACK-READY`.
- #52 `S2.2-Chevalley` — full proof depends on #51 power-sum interface `DONE` or `STACK-READY`.
- #55 `S3.1-QuadraticElements` — `PREFLIGHT`; branches from the multiplicative-group/finite-field path rather than requiring the §2 power-sum/Chevalley chain. D acquired the canonical branch after #57 merged.
- #56 `S3.2-LegendreSymbol` — unclaimed `PREFLIGHT`; implementation depends on the required §3.1 interface.

PR #57 passed repository policy, `lake build`, and `lake exe vbp build` on its latest head and is merged. A is therefore back in ready scheduler state rather than retaining completed #54 as active ownership.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
