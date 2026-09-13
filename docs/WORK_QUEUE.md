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

STACK-READYを後からwithdrawした場合、既存downstream commitは保存してよいが、replacement exact green SHAまたはupstream mergeまでは新しいdependent proofを追加しません。

## 5. Dependency rule

依存は章番号ではなく実際に使う数学的結果で管理します。dependency不明なら`PREFLIGHT`で確認し、新hard edgeが見つかったitemだけを待機させます。

## 6. Current queue

Mainでend-to-end完了:

- Theorem 1(ii)/(iii)
- §1.2 finite-field multiplicative group
- §2.1 power sums
- §2.2 core Chevalley–Warning + Corollary 1 + Corollary 2
- §3.1 Theorem 4 (square elements in finite fields)
- Chapter 2 §1.1 project-local `Z_p` inverse-limit construction

Live dependency graph:

- `S2.2-Chevalley-Cor2` #74 / PR #94 is DONE on main at `f4921a0e6c65ae7521376229ac78bfc95f68fc1c`.
- `C2S1.1-ZpConstruction` #71 / PR #86 is DONE on main at `2f4366622121ce0d56e76d8e9a41c25c6917da8b`. The old withdrawn stack anchor is irrelevant after merge; merged project declarations are now the stable source for downstream work.
- `S3.2-LegendreSymbol` #56 is C-owned, current draft PR #98. Exact head `45bde2eff8e75e901282151760b0c5dfc41a869a` was policy/build/vbp green in CI #198 and C explicitly froze a `STACK-READY` subset **for #64** containing the Legendre value/sign layers, multiplicativity, cast compatibility, Theorem 5(i), and Theorem 5(ii). #56 itself continues toward Theorem 5(iii), Blueprint, and merge. The live branch has since moved beyond the frozen downstream head; downstreams must use the exact frozen SHA unless a newer promise is published.
- `S3.3-QuadraticReciprocity` #64 is C-owned and now **STACKABLE** from #56 exact head `45bde2ef…`. A routed implementation resume to #64; it must not assume Theorem 5(iii).
- `C1-Supp-GaussLemma` #78 is B-owned with preflight complete. It needs only `legendreValue` plus the integer-sign↔field bridge, but C's current promise explicitly names #64 only. #78 therefore remains WAITING until #56 extends an exact STACK-READY promise to #78 or #56 merges.
- `C2S1.2-ZpProperties` #72 is D-owned, draft PR #92. #71 is now DONE, so the temporary upstream gate is removed. PR #92 has been retargeted to main and D may resume after latest-main resync/interface check.
- `C2S1.2-ZpMetric` #89 is D-owned with Proposition 3 preflight complete. Proof waits for #72 to freeze/merge the valuation and `p^n Z_p` bridge.
- `C2S1.3-QpField` #96 is B-owned with preflight complete. Algebraic implementation waits for #72 integral-domain/unit-decomposition/valuation interface; Proposition 4 additionally needs the minimal #89 topology/neighborhood/density subset.
- `C2S2.1-RootLiftingExistence` #99 is now B-owned on `work/c2-s2-1-root-existence`. Because #71 is DONE, its hard gate is open; B is preflighting and may proceed directly to Proposition 5 implementation if no new dependency appears.
- `C2S2.1-PrimitiveHomogeneousZeros` #100 is unclaimed PREFLIGHT. Proposition 6 will need the reusable #99 inverse-limit root interface plus #72 primitive/unit facts and #96 `Q_p` scaling interface.
- `C2S2.2-HenselLifting` #102 is unclaimed PREFLIGHT. It isolates the one-step improvement lemma, multivariate Hensel theorem, and simple-root corollary; proof is expected to wait for #72 congruence/valuation and #89 completeness interfaces.

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2 | `DONE` | PR #94 merged | `work/s2-2-chevalley-cor2-quadratic-form` | #74 complete |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `CLAIMED` | PR #98; finish Theorem 5(iii) / Blueprint / final integration | `work/s3-2-legendre-symbol` | #56 / C |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `STACKABLE` | stack exactly on #56 `45bde2ef…`; do not assume later declarations | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `WAITING` | preflight complete; wait explicit #78 freeze or #56 merge | `work/c1-supp-gauss-lemma` | #78 / B |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `DONE` | PR #86 merged at `2f436662…` | `work/c2-s1-1-zp-construction` | #71 complete |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `CLAIMED` | PR #92 retargeted main; resync and resume | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `WAITING` | preflight complete; proof waits #72 interface | `work/c2-s1-2-zp-metric` | #89 / D |
| P13 | `C2S1.3-QpField` | §1.3 `Q_p` / Prop.4 | `WAITING` | preflight complete; algebraic proof waits #72; topology subset waits #89 | `work/c2-s1-3-qp-field` | #96 / B |
| P14 | `C2S2.1-RootLiftingExistence` | §2.1 命題5 | `CLAIMED` | #71 DONE; B preflight then implement if no new edge | `work/c2-s2-1-root-existence` | #99 / B |
| P15 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 命題6 | `PREFLIGHT` | preflight safe; proof waits #99/#72/#96 interfaces | `work/c2-s2-1-primitive-homogeneous-zeros` | #100 / unclaimed |
| P16 | `C2S2.2-HenselLifting` | §2.2 Hensel theorem + Cor.1 | `PREFLIGHT` | preflight safe; proof expected to wait #72/#89 | `work/c2-s2-2-hensel-lifting` | #102 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed. Old Corollary-2 PR #87 is superseded by merged #94; old Legendre draft #93 is superseded by #98.

## 7. Shared-hotspot order

#86 is merged, so the former Chapter-2 root conflict is gone.

1. **#98 / C** is the next active root-integration candidate once its work item is end-to-end ready. Because the branch moved after #86, C must verify latest-main integration before final merge.
2. **#92 / D** is now ungated by #71, but should finish/stabilize its algebraic proof interface before adding Blueprint/root linkage; it should not race an incomplete #98 unnecessarily.
3. #99/B should keep its new Proposition 5 module isolated until its statement/proof interface stabilizes, then coordinate any root import with the live queue.

A does not modify worker mathematical branches.

## 8. Queue health

#99 was claimed by B immediately after #71 merged. To keep two unclaimed source-adjacent PREFLIGHTs, A retained #100 and seeded #102 from the next §2.2 Hensel boundary.

Current unclaimed safe capacity is #100 and #102. Owned executable/near-executable work includes #56, #64, #72, #99; dependency-waiting but preflight-complete work includes #78, #89, #96. No single dependency chain should globally idle the worker pool.

A should refill only when #100/#102 are claimed or otherwise cease to provide meaningful safe capacity.

## 9. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
