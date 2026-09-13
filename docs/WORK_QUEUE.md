# WORK_QUEUE.md

このファイルは、B/C/D/E の end-to-end formalizer が次に何を実行できるかを判断するための依存関係付き作業キューです。

`main` 上のこの表は計画の source of truth ですが、**live branch / Issue / PR / CI が表より新しい場合はlive stateを優先**します。

## 1. Queue states

- `READY` — upstreamがmainで安定し、本実装をclaim可能。
- `PREFLIGHT` — source / statement / dependency / mathlib調査を進めてよい。本proofはgate成立後。
- `STACKABLE` — 未merge upstream がstatement/interface/exact headを明示的に `STACK-READY` として固定済み。
- `WAITING` — upstream interface待ち。本実装は禁止。
- `CLAIMED` — canonical branchが存在しworker所有中。
- `CI-WAIT` — PRのCI待ち。ownerは別の安全なworkをstealしてよい。
- `BLOCKED` — item固有の停止条件。
- `DONE` — mainへ統合済みで必要なcross-layer artifact / verificationが揃っている。

## 2. Atomic claim / ownership

canonical branch作成をownership lockとします。既存branchがあるitemを、Issue上の `RELEASED` / Aの `REASSIGNED` なしに別workerが奪ってはいけません。claim後はfocused Issueへowner lane / branch / baseを記録します。

同一work itemに後発duplicate branchが生じた場合は**最初の有効なcanonical lockを優先**し、後発workをduplicate/releasedとして閉じます。

## 3. Work stealing

PR作成、CI pending、1 item merge、item固有blocker、upstream待ちはchat停止条件ではありません。実行時間が残っていれば `READY` / eligible `STACKABLE` / safe `PREFLIGHT` を再走査します。

1 workerの未merge実装PRは原則2本までです。追加の時間はpreflight、レビュー、dependency整理、CI確認、handoff同期へ使います。

## 4. Stacked branch gate

未merge upstreamへstackしてよいのは、upstream ownerが数学的statement/assumptions、downstream interface、exact head SHA、interface変更時の通知先を固定した場合だけです。upstream ownerがその承認を撤回した場合、既存downstream workは保存してよいですが、新しい依存proofを積み増さず、replacement `STACK-READY` またはupstream mergeを待ちます。upstream merge後はstack-only状態を解除し、downstream branchを最新mainへresyncしてから統合します。

## 5. Dependency rule

依存は章番号ではなく実際に使う数学的結果で管理します。dependency不明なら`PREFLIGHT`で確認し、新hard edgeが見つかったitemだけを待機させます。

## 6. Current queue

Mainでend-to-end完了:

- Theorem 1(ii)/(iii)
- §1.2 finite-field multiplicative group
- §2.1 power sums
- §2.2 core Chevalley–Warning
- §2.2 Corollary 1 (nontrivial common zero)
- §3.1 Theorem 4 (square elements in finite fields)

Live dependency graph:

- `S2.2-Chevalley-Cor2` のcanonical workは **#74 / C**。Cが先に `work/s2-2-chevalley-cor2-quadratic-form` をclaimし、source/representation preflight済み。#70がDONEなので実装gateはopen。旧draft PR #87はsupersededされ、clean current PR **#94** がactive。head `596b6341…` はgreenだがA #90後のlatest mainへresyncしてから統合する。
- `S3.1-QuadraticElements` #55 / PR #82 は main commit `329184fa3aa1e6ee748061b1cf5cb539e2c72778` でDONE。half-power / square-kernel interfaceはmainでstable。
- `S3.2-LegendreSymbol` #56 はC-owned、draft PR **#93** で実装中。#55はDONEなのでstack-only gateは解除済み。current head `83d03bc…` のCIはstatement/dependencyではなく`LegendreSymbol.lean`のsign/cast proof 1箇所で失敗しており、Cへrepairをroute済み。
- `S3.3-QuadraticReciprocity` #64 はC-owned PREFLIGHT。proofは #56 が characteristic-independent Legendre sign/value、field-core compatibility、multiplicativity、Theorem 5(ii) at `-1` をDONEまたはSTACK-READYにするまで待つ。Theorem 5(iii) at `2` はhard dependencyではない。
- `C1-Supp-GaussLemma` #78 は **B-owned**。canonical branch `work/c1-supp-gauss-lemma` が存在し、source/package/API preflightはcomplete。proofはminimal #56 sign/half-power interfaceがDONE/STACK-READYになるまでWAITING。#64には依存しない。
- `C2S1.1-ZpConstruction` #71 はB-owned、draft PR **#86**。以前の exact `STACK-READY` SHA `27a414…` は、root aggregator未接続のため新moduleが実際にはcompileされていなかったことが判明し、B自身が明示的に撤回した。public declaration names/statementsは変更なしと報告されている。current head `6a39d1fd…` のCI #190はpolicy通過後、Chapter-2 Blueprintのheader nesting (`##` where `#` expected) で`lake build` failure。Bへrepairをroute済みで、replacement exact `STACK-READY` はroot-integrated policy/build/vbp green後に再公開される。
- `C2S1.2-ZpProperties` #72 はD-owned、draft PR **#92**。旧承認が有効だった時点でexact `27a414…` anchorから開始し、existing head `a6ffdf7a…` 自体はCI green。ただし#71が旧承認を撤回したため、現在は**WAITING**に戻す。既存workは保持してよいが、replacement `STACK-READY` または#71 mergeまで新たなupstream依存proofを積み増さない。AからDへこのgate correctionをroute済み。
- `C2S1.2-ZpMetric` #89 はunclaimed PREFLIGHT。#72 preflightで切り出されたProposition 3（metric / topology compatibility / completeness / density）。proofは#72 valuation/topology-relevant interface待ち。
- `C2S1.3-QpField` #96 はunclaimed PREFLIGHT。Definition 2のproject `Z_p` のfraction fieldとしての `Q_p`、valuation extension、Proposition 4のlocal compactness / `Z_p` open compact / `Q` densityをsource boundaryとする。algebraic proofは#72待ちで、metric側が#89のどの最小interfaceを必要とするかはpreflightで確定する。

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1: 原点以外の共通零点 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2: 3変数以上の2次形式 | `CLAIMED` | PR #94 green; resync current main, then self-review/merge | `work/s2-2-chevalley-cor2-quadratic-form` | #74 / C |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `CLAIMED` | PR #93; repair implementation-local Lean goal, continue isolated module | `work/s3-2-legendre-symbol` | #56 / C |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `PREFLIGHT` | wait for minimal #56 subset DONE/STACK-READY | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `WAITING` | B preflight complete; proof waits minimal #56 interface | `work/c1-supp-gauss-lemma` | #78 / B |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `CLAIMED` | PR #86; fix Blueprint header nesting; publish replacement root-integrated STACK-READY only after full green | `work/c2-s1-1-zp-construction` | #71 / B |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `WAITING` | preserve green PR #92 work; wait replacement #71 STACK-READY or #71 merge before new dependent proof | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `PREFLIGHT` | preflight safe; proof waits #72 | `work/c2-s1-2-zp-metric` | #89 / unclaimed |
| P13 | `C2S1.3-QpField` | §1.3 `Q_p` / Prop.4 | `PREFLIGHT` | preflight safe; algebraic proof waits #72, metric edge to #89 to be minimized | `work/c2-s1-3-qp-field` | #96 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed and are not queue work。旧Corollary-2 PR #87も#94にsupersede済み。

## 7. Shared-hotspot order

Current worker PRs overlap root imports:

1. **#94 / C** is already end-to-end green and gets the next root `Formalization.lean` / `Blueprint.lean` integration slot after resync to latest main.
2. **#86 / B** also touches both root imports. Repair its local Chapter-2 Blueprint hierarchy first, then rebase after #94 lands before final integrated CI.
3. **#93 / C** currently touches root `Formalization.lean` but remains an in-progress §3.2 slice. Keep proof work isolated; rebase/add final root integration only after #94 rather than racing the shared hotspot.

A does not modify these worker mathematical branches.

## 8. Queue health

Unclaimed safe capacity is currently #89 and #96 (`PREFLIGHT`). Owned executable work includes #74, #56, and #71; #64/#78 have safe preflight/waiting work, while #72 is temporarily WAITING only because its former stack approval was withdrawn. Thus the pool still has safe work without violating the stack gate.

A should refill only when these candidates are claimed/thin, and should prefer source/dependency boundaries already exposed by current work rather than inventing unrelated tasks.

## 9. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
