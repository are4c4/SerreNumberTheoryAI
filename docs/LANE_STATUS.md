# LANE_STATUS.md

このファイルは複数AI chatの現在地を一覧する共有ボードです。詳細な実行可能性は `docs/WORK_QUEUE.md`、live ownershipはGitHub branch / Issue / PRを優先します。

## Status

| Lane | Role | State | Active work | Branch / PR | Next |
| --- | --- | --- | --- | --- | --- |
| A | Scheduler / Design | 🚧 active | #81 post-Chevalley queue/progress sync and refill | `design/sync-post-chevalley-refill-81` / PR #83 | land central sync, then monitor #55→#56→#64 gates and fresh #84/#85/#78/#79 claims |
| B | End-to-end Formalizer | 🟡 ready | none | none | after #83 lands, rescan queue; #84 is READY and #85/#78/#79 are PREFLIGHT unless live branch state changes |
| C | End-to-end Formalizer | 🚧 active | #56 `S3.2-LegendreSymbol` and #64 `S3.3-QuadraticReciprocity` preflights | `work/s3-2-legendre-symbol`; `work/s3-3-quadratic-reciprocity`; docs PR #76 | keep proof code gated; #64 can stack once the minimal #56 sign/multiplicativity/Theorem5(ii) subset is explicitly `STACK-READY` |
| D | End-to-end Formalizer | 🚧 active | #55 `S3.1-QuadraticElements`; #52 completed | `work/s3-1-quadratic-elements` / draft PR #82 | repair current Lean build failure, then publish a stable half-power/square-kernel interface for #56 when green |
| E | End-to-end Formalizer | 🟡 ready | none | none | after #83 lands, atomic-claim only a still-unowned candidate; #84 is immediately executable and #79 is an independent preflight |

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

`S1.1-T1iii` (#49/#58), `S1.2-MultGroup` (#50/#59), `S2.1-PowerSums` (#51/#62), and the core `S2.2-Chevalley` theorem (#52/#68) are end-to-end complete on `main`.

Current live ownership at the latest A check:

- A: #81 / PR #83 scheduler-only synchronization/refill; no mathematical implementation ownership.
- B: no unfinished mathematical work.
- C: #56 `S3.2-LegendreSymbol` preflight and #64 `S3.3-QuadraticReciprocity` preflight; docs-only PR #76 is green and disjoint from A central files.
- D: #55 `S3.1-QuadraticElements`, draft PR #82. CI run #147 passed policy but failed `lake build`; A routed the two concrete Lean compile errors back to D without modifying the branch.
- E: no unfinished mathematical work.

Dependency / capacity frontier:

- #84 `S2.2-Chevalley-Cor1` → fresh unclaimed READY item. Core #52 is DONE; implementation can start directly from main.
- #85 `S2.2-Chevalley-Cor2` → fresh unclaimed PREFLIGHT. Its source proof specializes #84 to one quadratic form in at least three variables, so proof waits for #84 `DONE`/`STACK-READY`.
- #55 → no remaining project gate. D owns implementation/CI repair; once the half-power `{±1}` / square-kernel declarations are stable and green, D may publish `STACK-READY` for #56.
- #56 → waits for #55's half-power `{±1}` / square-kernel interface `DONE` or explicit `STACK-READY`.
- #64 → waits for a smaller stable subset of #56: Legendre sign layer, multiplicativity, Theorem 5(ii) at `-1`, and cross-characteristic sign compatibility. Theorem 5(iii) at `2` is not needed for the source §3.3 proof.
- #78 `C1-Supp-GaussLemma` → fresh unclaimed PREFLIGHT. It is an alternative-proof supplement, independent of #64, but its proof also waits for the minimal #56 Legendre/half-power interface.
- #79 `C2.1.1-ZpInverseLimit` → fresh unclaimed PREFLIGHT for Chapter 2 §1.1. It is independent of the Chapter 1 quadratic-residue chain and may proceed from main after representation/API preflight.

Issueが存在するだけではownershipではありません。canonical branch lockを最初に取得したworkerがownerです。Aは未claim itemを各workerへ手動配布せず、queueとdependencyの整合だけを維持します。
