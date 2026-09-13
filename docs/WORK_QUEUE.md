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
- `S3.2-LegendreSymbol` #56 is C-owned, draft PR #98. Exact head `45bde2eff8e75e901282151760b0c5dfc41a869a` remains the frozen `STACK-READY` subset **for #64**. Theorem 5(iii) itself previously reached green CI #217; subsequent source-shaped cleanup remains in local Lean normalization. Latest checked head `e1d5bf9ed6dbcaa9c5ab1beea6019d23cbf9e9c6` fails CI #229 only because a numeral `2` in `AlgebraicClosure (ZMod p)` is not yet normalized against `algebraMap ... (2 : ZMod p)` in two final branches. A routed that exact cast-normalization diagnostic. The old downstream freeze remains valid. Independent Blueprint exposition/linkage and final latest-main integration are still required after proof stabilization.
- `S3.3-QuadraticReciprocity` #64 is C-owned and **STACKABLE** from #56 exact head `45bde2ef…`. A already routed implementation resume; the canonical #64 branch has not yet consumed that head at the latest check, so no later #56 declarations may be assumed implicitly.
- `C1-Supp-GaussLemma` #78 is B-owned with preflight complete. It needs only `legendreValue` plus the integer-sign↔field bridge, but C's current frozen promise explicitly names #64 only. #78 remains WAITING until #56 extends an exact STACK-READY promise to #78 or #56 merges.
- `C2S1.2-ZpProperties` #72 is D-owned, draft PR #92. Live head `81bc0f88d6960611264194cf7923118f015f262a` passed CI #219 and now includes the quotient/kernel, `p^(n+1)` divisibility detection, and unit criteria. The source `p^n * unit` decomposition, project valuation, and integral-domain conclusion are still unfinished, so downstream #89/#96 remain gated.
- `C2S1.2-ZpMetric` #89 is D-owned with Proposition 3 preflight complete. Proof waits for #72 to freeze/merge the valuation and `p^n Z_p` bridge.
- `C2S1.3-QpField` #96 is B-owned with preflight complete. Algebraic implementation waits for #72 integral-domain/unit-decomposition/valuation interface; Proposition 4 additionally needs the minimal #89 topology/neighborhood/density subset.
- `C2S2.1-RootLiftingExistence` #99 is B-owned, draft PR #103. After local map/evaluation repairs, current checked head `fe1a173e9665595b584d7f8235c5122b4f0cc373` passed CI #226 and contains Proposition 5 + Blueprint work in isolated form. Final normal root integration remains coordinated behind #98 because #103 currently uses a temporary top-level import hook to avoid the C-owned `Formalization.lean` hotspot.
- `C2S2.1-PrimitiveHomogeneousZeros` #100 is now B-owned PREFLIGHT on `work/c2-s2-1-primitive-homogeneous-zeros`. It may finish source/API/dependency preflight while proof waits for reusable #99 plus #72 primitive/unit and #96 `Q_p` scaling interfaces.
- `C2S2.2-HenselLifting` #102 is unclaimed PREFLIGHT. It isolates the one-step improvement lemma, multivariate Hensel theorem, and simple-root corollary; proof is expected to wait for #72 congruence/valuation and #89 completeness interfaces.
- `C2S2.2-HenselQuadraticOdd` #104 is unclaimed PREFLIGHT. It isolates source Corollary 2: for odd `p`, a primitive mod-`p` solution of a nondegenerate symmetric quadratic equation lifts by the simple-root Hensel criterion. Expected proof dependencies are #102 plus the project primitive/unit interface from #72.
- `C2S2.2-HenselQuadraticTwo` #105 is unclaimed PREFLIGHT. It isolates source Corollary 3 at `p=2`: primitive mod-8 solution plus a partial derivative nonzero mod 4 lifts, with invertible determinant as a sufficient condition. Expected proof dependencies are #102 plus #72 dyadic valuation/congruence/primitive interfaces.

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2 | `DONE` | PR #94 merged | `work/s2-2-chevalley-cor2-quadratic-form` | #74 complete |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `CLAIMED` | PR #98 latest checked `e1d5bf9e…`; CI #229 local cast failure; keep #64 on frozen `45bde2ef…` | `work/s3-2-legendre-symbol` | #56 / C |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `STACKABLE` | stack exactly on #56 `45bde2ef…`; do not assume later declarations | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `WAITING` | preflight complete; wait explicit #78 freeze or #56 merge | `work/c1-supp-gauss-lemma` | #78 / B |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `DONE` | PR #86 merged at `2f436662…` | `work/c2-s1-1-zp-construction` | #71 complete |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `CLAIMED` | PR #92 head `81bc0f88…` CI #219 green; continue decomposition/valuation/domain | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `WAITING` | preflight complete; proof waits #72 valuation interface | `work/c2-s1-2-zp-metric` | #89 / D |
| P13 | `C2S1.3-QpField` | §1.3 `Q_p` / Prop.4 | `WAITING` | preflight complete; algebraic proof waits #72; topology subset waits #89 | `work/c2-s1-3-qp-field` | #96 / B |
| P14 | `C2S2.1-RootLiftingExistence` | §2.1 命題5 | `CLAIMED` | PR #103 head `fe1a173e…` CI #226 green isolated; final normal root integration after #98 hotspot clears | `work/c2-s2-1-root-existence` | #99 / B |
| P15 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 命題6 | `PREFLIGHT` | B preflight; proof waits #99/#72/#96 interfaces | `work/c2-s2-1-primitive-homogeneous-zeros` | #100 / B |
| P16 | `C2S2.2-HenselLifting` | §2.2 Hensel theorem + Cor.1 | `PREFLIGHT` | preflight safe; proof expected to wait #72/#89 | `work/c2-s2-2-hensel-lifting` | #102 / unclaimed |
| P17 | `C2S2.2-HenselQuadraticOdd` | §2.2 系2: odd-`p` quadratic lifting | `PREFLIGHT` | preflight safe; proof waits #102/#72 interfaces | `work/c2-s2-2-hensel-quadratic-odd` | #104 / unclaimed |
| P18 | `C2S2.2-HenselQuadraticTwo` | §2.2 系3: dyadic quadratic lifting | `PREFLIGHT` | preflight safe; proof waits #102/#72 interfaces | `work/c2-s2-2-hensel-quadratic-two` | #105 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed. Old Corollary-2 PR #87 is superseded by merged #94; old Legendre draft #93 is superseded by #98.

## 7. Shared-hotspot order

1. **#98 / C** keeps the next active `Formalization.lean` root-integration slot while its local Theorem 5(iii) cast repair and Blueprint/final §3.2 work finish. The explicit #64 freeze remains isolated from the moving live branch.
2. **#103 / B** is isolated-CI green at `fe1a173e…`; after #98 frees the shared root, B should resync latest main, move the import into the normal `Formalization.lean` aggregator, remove the temporary hook, and re-run full CI before merge.
3. **#92 / D** can continue its isolated algebraic module now; final Blueprint/root linkage should wait until the proof interface is stable rather than racing the two workers above.

A does not modify worker mathematical branches.

## 8. Queue health

#100 was claimed by B while #99 is occupied with the root hotspot. A therefore source-checked the immediately following §2.2 quadratic corollaries and split them into #104/#105 rather than inventing unrelated work.

Current unclaimed safe capacity is #102, #104, and #105. Owned executable/near-executable work includes #56, #64, #72, #99; owned preflight includes #100; dependency-waiting but preflight-complete work includes #78, #89, #96. The worker pool retains multiple safe paths despite shared-root and dependency waits.

A should refill again only when #102/#104/#105 are claimed or cease to provide meaningful safe capacity.

## 9. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
