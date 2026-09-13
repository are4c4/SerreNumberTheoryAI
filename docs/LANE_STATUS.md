# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🟡 ready | none | none | maintain dependency graph / queue health; resolve ambiguity or conflicts without becoming a per-item approval gate |
| B | End-to-end Formalizer | 🟡 ready | none | none | restore any live owned work or atomic-claim the highest-priority executable queue item |
| C | End-to-end Formalizer | 🟡 ready | none | none | restore any live owned work or atomic-claim the highest-priority executable queue item |
| D | End-to-end Formalizer | 🟡 ready | none | none | restore any live owned work or atomic-claim the highest-priority executable queue item |
| E | End-to-end Formalizer | 🟡 ready | none | none | restore any live owned work or atomic-claim the highest-priority executable queue item |

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

Active seed queue:

- #49 `S1.1-T1iii` — `READY`
- #50 `S1.2-MultGroup` — `PREFLIGHT`
- #51 `S2.1-PowerSums` — `PREFLIGHT`。本実装前に必要なS1.2 resultを明示する
- #52 `S2.2-Chevalley` — `PREFLIGHT`。本実装前に必要なS2.1 resultを明示する

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。

後続targetの細かいdependencyは推測せずpreflightで確定します。actual dependencyがある場合は上流 `DONE` または `STACK-READY` まで本proofを待ちますが、worker自身は別workへ移って稼働を続けます。
