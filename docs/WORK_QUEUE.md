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

未merge upstreamへstackしてよいのは、upstream ownerが数学的statement/assumptions、downstream interface、exact head SHA、interface変更時の通知先を固定した場合だけです。upstream merge後はstack-only状態を解除し、downstream branchを最新mainへresyncしてから統合します。

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

- `S2.2-Chevalley-Cor2` のcanonical workは **#74 / C**。Cが先に `work/s2-2-chevalley-cor2-quadratic-form` をclaimし、source/representation preflight済み。#70がDONEなので実装gateはopen、draft PR #87がactive。後発 #85 / PR #88 / branch `work/s2-2-chevalley-cor2` はduplicate/released。
- `S3.1-QuadraticElements` #55 / PR #82 は main commit `329184fa3aa1e6ee748061b1cf5cb539e2c72778` でDONE。half-power / square-kernel interfaceはmainでstable。
- `S3.2-LegendreSymbol` #56 はC-owned。stack baseだった#55がmerge済みなのでstack-only gateは解除。canonical branchをlatest mainへresyncし、通常のCLAIMED implementationとして進めてよい。
- `S3.3-QuadraticReciprocity` #64 はC-owned PREFLIGHT。proofは #56 が characteristic-independent Legendre sign/value、field-core compatibility、multiplicativity、Theorem 5(ii) at `-1` をDONEまたはSTACK-READYにするまで待つ。Theorem 5(iii) at `2` はhard dependencyではない。
- `C1-Supp-GaussLemma` #78 はunclaimed PREFLIGHT。#64には依存せず、proofはminimal #56 interface待ち。
- `C2S1.1-ZpConstruction` #71 はB-owned、draft PR #86で実装中。後発 #79 はduplicateとしてclosed。
- `C2S1.2-ZpProperties` #72 はD-owned。preflight complete、proofは #71 public representation/projection/integer-map interface待ち。source boundaryはProposition 1–2 + valuationのalgebraic sliceへ絞る。
- `C2S1.2-ZpMetric` #89 はunclaimed PREFLIGHT。#72 preflightで切り出されたProposition 3（metric / topology compatibility / completeness / density）。proofは#72 valuation/topology-relevant interface待ち。

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1: 原点以外の共通零点 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2: 3変数以上の2次形式 | `CLAIMED` | #70 DONE; PR #87をlatest mainへresync | `work/s2-2-chevalley-cor2-quadratic-form` | #74 / C |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `CLAIMED` | #55 DONE; resync to latest main and implement | `work/s3-2-legendre-symbol` | #56 / C |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `PREFLIGHT` | wait for minimal #56 subset DONE/STACK-READY | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `PREFLIGHT` | preflight safe; proof waits for #56 | `work/c1-supp-gauss-lemma` | #78 / unclaimed |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `CLAIMED` | implementation active in PR #86 | `work/c2-s1-1-zp-construction` | #71 / B |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `WAITING` | preflight done; wait #71 interface | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `PREFLIGHT` | preflight safe; proof waits #72 | `work/c2-s1-2-zp-metric` | #89 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed and are not queue work.

## 7. Queue health

Unclaimed safe capacity is currently #78 and #89 (`PREFLIGHT`). Meanwhile C has executable #74 and #56, B has #71, D has #72 preflight completed/waiting, so no worker should be globally blocked by one dependency chain.

A should refill only when these candidates are claimed/thin, and should prefer source/dependency boundaries already exposed by current work rather than inventing unrelated tasks.

## 8. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
