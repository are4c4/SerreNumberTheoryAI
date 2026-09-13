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

未merge upstreamへstackしてよいのは、upstream ownerが数学的statement/assumptions、downstream interface、exact head SHA、interface変更時の通知先を固定した場合だけです。upstream merge後はstack-only状態を解除し、downstream branchをlatest mainへresyncしてから統合します。

STACK-READYを後からwithdrawした場合、既存downstream commitは保存してよいが、replacement exact green SHAまたはupstream mergeまでは新しいdependent proofを追加しない。

## 5. Dependency rule

依存は章番号ではなく実際に使う数学的結果で管理します。dependency不明なら`PREFLIGHT`で確認し、新hard edgeが見つかったitemだけを待機させます。

## 6. Current queue

Mainでend-to-end完了:

- Theorem 1(ii)/(iii)
- §1.2 finite-field multiplicative group
- §2.1 power sums
- §2.2 core Chevalley–Warning
- §2.2 Corollary 1 (nontrivial common zero)
- §2.2 Corollary 2 (homogeneous quadratic form in at least three variables)
- §3.1 Theorem 4 (square elements in finite fields)

Live dependency graph:

- `S2.2-Chevalley-Cor2` #74 / PR #94 is **DONE** on main at `f4921a0e6c65ae7521376229ac78bfc95f68fc1c`.
- `S3.2-LegendreSymbol` #56 is C-owned, current draft PR #98. Core head `45bde2eff8e75e901282151760b0c5dfc41a869a` passed CI #198. A asked C to publish an exact-head minimal `STACK-READY` subset for #78 as soon as the sign/half-power declarations are frozen; #64 still needs the stronger Theorem 5(ii) at `-1` subset.
- `S3.3-QuadraticReciprocity` #64 is C-owned PREFLIGHT. Proof waits for #56 characteristic-independent Legendre sign/value, field compatibility, multiplicativity, and Theorem 5(ii) at `-1`. Theorem 5(iii) at `2` is not a hard dependency.
- `C1-Supp-GaussLemma` #78 is B-owned. Source/package/API preflight is complete; proof waits only for the minimal #56 sign/half-power interface and does not depend on #64.
- `C2S1.1-ZpConstruction` #71 is B-owned, draft PR #86. The old exact `STACK-READY` at `27a41437…` was withdrawn because that run had not root-compiled the Chapter 2 module. Current root-integrated head `2a22858d4cf7a3bb89c2409a3f281e67e73807fd` is fully green in CI #199. B has been routed to publish a replacement exact `STACK-READY`, notify #72, then mark ready/self-merge.
- `C2S1.2-ZpProperties` #72 is D-owned, draft PR #92. Existing work on the formerly approved anchor is preserved and its own head was green, but new upstream-dependent proof is **WAITING** until #71 publishes a replacement root-integrated exact green SHA or merges.
- `C2S1.2-ZpMetric` #89 is D-owned. Proposition 3 source/API preflight is complete; proof waits for #72 to freeze the valuation / `p^n Z_p` bridge. D recommends a project-local additive valuation plus divisibility/projection-kernel characterization and source-normalized metric.
- `C2S1.3-QpField` #96 is B-owned. Preflight is complete; algebraic implementation waits for #72 integral-domain / unit-decomposition / valuation interface, while Proposition 4 additionally needs only the minimal #89 topology/neighborhood/density subset.
- `C2S2.1-RootLiftingExistence` #99 is unclaimed PREFLIGHT. It isolates §2.1 Proposition 5: common roots in `(Z_p)^m` iff common roots exist at every finite residue level. Implementation should depend on #71 plus polynomial reduction/evaluation compatibility, not on #72/#96.
- `C2S2.1-PrimitiveHomogeneousZeros` #100 is unclaimed PREFLIGHT. It isolates §2.1 Proposition 6: nonzero `Q_p` common zero ↔ primitive `Z_p` common zero ↔ primitive common zeros at every finite level. Proof will need #72, #96 and the reusable inverse-limit root machinery from #99 as actually exposed.

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1: 原点以外の共通零点 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2: 3変数以上の2次形式 | `DONE` | PR #94 merged at `f4921a0e…` | `work/s2-2-chevalley-cor2-quadratic-form` | #74 complete |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `CLAIMED` | PR #98 core green; finish Theorem 5 / Blueprint; optionally freeze minimal #78 subset first | `work/s3-2-legendre-symbol` | #56 / C |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `PREFLIGHT` | wait stronger #56 subset incl. Theorem 5(ii) at `-1` | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `WAITING` | B preflight complete; resume on minimal #56 STACK-READY/DONE | `work/c1-supp-gauss-lemma` | #78 / B |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `CLAIMED` | PR #86 head `2a22858…` CI #199 green; publish replacement STACK-READY then merge | `work/c2-s1-1-zp-construction` | #71 / B |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `WAITING` | preserve PR #92; resume after replacement #71 STACK-READY or #71 merge | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `WAITING` | D preflight complete; proof waits #72 valuation/topology interface | `work/c2-s1-2-zp-metric` | #89 / D |
| P13 | `C2S1.3-QpField` | §1.3 `Q_p` / Prop.4 | `WAITING` | B preflight complete; algebraic proof waits #72; topology subset waits #89 | `work/c2-s1-3-qp-field` | #96 / B |
| P14 | `C2S2.1-RootLiftingExistence` | §2.1 命題5 | `PREFLIGHT` | preflight safe; implementation waits #71 | `work/c2-s2-1-root-existence` | #99 / unclaimed |
| P15 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 命題6 | `PREFLIGHT` | preflight safe; implementation waits #72/#96 and reusable #99 interface | `work/c2-s2-1-primitive-homogeneous-zeros` | #100 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed and are not queue work。旧Corollary-2 PR #87は#94に、旧Legendre draft PR #93は#98にsupersede済み。

## 7. Shared-hotspot order

#94がmainへmerge済みなので、現在のroot-import競合は次の順で扱う。

1. **#86 / B** — current latest-main-integrated head is fully green; replacement STACK-READY公開後に最優先でmerge可能。
2. **#98 / C** — current coreはgreenだがwork itemは未完了。#86が先にmergeした場合はlatest mainへresyncしてからfinal root/Blueprint integrationを行う。
3. stacked/downstream PR #92はroot integrationを急がず、#71 replacement gateが成立してからupstreamを取り直す。

Aはworkerの数学ファイルを変更しない。

## 8. Queue health

#89と#96はすでにclaimされpreflight completeになったため、Aはsource上で隣接する§2.1をdependency-safeに分割し、#99/#100を新しいunclaimed PREFLIGHTとして補充した。

現時点のunclaimed safe capacityは #99 と #100。owned executable/near-executable workは #56 / #71、dependency待ちだがpreflight completeなworkは #64 / #78 / #72 / #89 / #96。したがって単一dependency chainでworker pool全体が止まる必要はない。

Aはこの2候補がclaimされてcapacityが薄くなったときだけ次のsource-adjacent boundaryを補充する。

## 9. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
