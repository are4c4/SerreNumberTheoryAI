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
- §3.2 Legendre symbol / Theorem 5(i)–(iii)
- Chapter 1 supplement (i) Gauss's lemma
- Chapter 2 §1.1 project-local `Z_p` inverse-limit construction
- Chapter 2 §2.1 Proposition 5

Live dependency graph:

- `S3.2-LegendreSymbol` #56 / PR #98 is DONE on main at `7aa158673bf0df1c62e977b508297d2e6b88610a`, including Theorem 5(i)–(iii), independent Blueprint exposition/linkage, and green CI #252.
- `S3.3-QuadraticReciprocity` #64 is C-owned, draft PR #114. The branch has reconciled onto latest main after #78 merged; latest checked head `7a48b08d47ff2c39dd8dd8ba333f6177c6619066` passed CI #289 and uses the normal `Formalization.lean` aggregator. C owns the current shared-root slot while the source coefficient/Gauss-square/Frobenius proof and Blueprint/final integration continue.
- `C1-Supp-GaussLemma` #78 / PR #115 is DONE on main at merge `56a5307bee7049924c9090a677492ba01a4808e2`. The source-shaped signed half-system/permutation proof, Blueprint exposition, and root linkage are integrated; its former shared-root slot is clear.
- `C2S1.2-ZpProperties` #72 is D-owned, draft PR #92. Exact head `c43d7f09c57a01418663965fd070c69ee16a73b6` passed CI #261 and includes projection/kernel, source power-divisibility, unit criteria, unique `p^n * unit` decomposition, project additive valuation with multiplicative/ultrametric laws, the domain instance, and independent Blueprint exposition. D explicitly froze this exact interface **for #89 only**; no other downstream proof gate is inferred from that promise.
- `C2S1.2-ZpMetric` #89 is D-owned, draft PR #116, and stacks exactly on #72 head `c43d7f09…`. Latest checked head `f42c68f095015a4e5d66d08f71d24257d6d52d9f` passed CI #291. Its four changed files remain confined to Chapter 2 metric/topology/completion modules plus their independent Blueprint module, with no shared `Formalization.lean`/`Blueprint.lean` edit. No #102/#96 downstream freeze is inferred until D explicitly publishes one.
- `C2S1.3-QpField` #96 is B-owned with preflight complete. Algebraic implementation still waits for #72 DONE or an explicit #96-scoped domain/decomposition/valuation freeze; Proposition 4 additionally needs the minimal #89 topology/neighborhood/density subset.
- `C2S2.1-RootLiftingExistence` #99 / PR #103 is DONE on main at merge `326c2aec2e3f2168dfce64d5f95d678d8b6a1930`; final head `1a86c84e…` passed CI #260. Its earlier downstream-only interface for #100 remains stable.
- `C2S2.1-PrimitiveHomogeneousZeros` #100 is B-owned PREFLIGHT. It may consume the stable #99 finite-level reduction interface; full proof still waits for an explicit #72 primitive/unit subset and #96 `Q_p` scaling interface.
- `C2S2.2-HenselLifting` #102 is B-owned with preflight complete. Proof still waits for #72's source congruence/decomposition/valuation interface and for a compatible metric/completeness interface from #89; #72's current promise is scoped only to #89.
- `C2S2.2-HenselQuadraticOdd` #104 is B-owned with preflight complete and proof-code-clean. Proof waits for #102 DONE/STACK-READY and the minimal #72 primitive/unit/congruence interface.
- `C2S2.2-HenselQuadraticTwo` #105 is B-owned with preflight complete and proof-code-clean. The source dyadic slice uses the main #102 Hensel theorem at `n=3,k=1`, plus the #72 domain/divisibility/valuation/primitive interface; no direct #96 dependency exists. Proof waits explicit #102 + #72 consumer-safe gates.
- `C2S3.1-UnitFiltration` #108 is B-owned PREFLIGHT on canonical branch `work/c2-s3-1-unit-filtration`, based on current main `56a5307…`. Core proof waits for an explicit stable #72 unit/divisibility interface; only the final corollary inside project `Q_p` needs #96.
- `C2S3.2-PrincipalUnits` #112 has an atomic canonical-branch lock at `work/c2-s3-2-principal-units` on current main, but the branch creator has not yet posted `OWNER: <lane>` on the Issue. Treat it as `CLAIMED (owner metadata pending)` and do not duplicate the branch. Proof remains gated on #108/#72; the final project `Q_p^×` formulation also needs #96.
- `C2S3.3-PadicSquares` #120 is unclaimed PREFLIGHT. It covers Theorem 3 for odd `p` (valuation parity + residue Legendre square criterion, square-class quotient type `(2,2)`) and Theorem 4 for `p=2` (valuation parity + unit `≡1 mod 8`, quotient type `(2,2,2)`). Proof waits stable #112 principal-unit/multiplicative-decomposition and #96 project `Q_p` interfaces; merged #56 supplies the odd-prime Legendre criterion.
- `C3S1.1-HilbertBasics` #121 is unclaimed PREFLIGHT. It covers the Hilbert-symbol conic definition over the source local fields, square-class invariance, Proposition 1 norm criterion, and Proposition 2 elementary identities. Generic field/norm preflight is safe now; project `Q_p` specialization waits #96.
- `C3S1.2-HilbertLocalFormula` #122 is unclaimed PREFLIGHT. It covers the real and `Q_p` explicit Hilbert-symbol formulas, bilinearity/nondegeneracy on `kˣ/kˣ²`, and the norm-subgroup index-two corollary. Proof waits #121 plus the exact project `Q_p`/square-class/lifting interfaces from #96/#120/#100/#104/#105 actually used.

| Priority | Work ID | Target | State | Gate / next action | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged | `work/s1-1-t1iii` | #49 complete |
| P1 | `S1.2-MultGroup` | 有限体乗法群 / 定理2 | `DONE` | PR #59 merged | `work/s1-2-mult-group` | #50 complete |
| P2 | `S2.1-PowerSums` | べき乗和 | `DONE` | PR #62 merged | `work/s2-1-power-sums` | #51 complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged | `work/s2-2-chevalley` | #52 complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1 | `DONE` | PR #80 merged | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2 | `DONE` | PR #94 merged | `work/s2-2-chevalley-cor2-quadratic-form` | #74 complete |
| P6 | `S3.1-QuadraticElements` | 3.1 平方数 / 定理4 | `DONE` | PR #82 merged | `work/s3-1-quadratic-elements` | #55 complete |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `DONE` | PR #98 merged at `7aa15867…` | `work/s3-2-legendre-symbol` | #56 complete |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余相互法則 / 定理6 | `CLAIMED` | PR #114 `7a48b08d…` CI #289 green on latest main; current Formalization-root slot | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `DONE` | PR #115 merged as `56a5307b…` | `work/c1-supp-gauss-lemma` | #78 complete |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse limit | `DONE` | PR #86 merged | `work/c2-s1-1-zp-construction` | #71 complete |
| P11 | `C2S1.2-ZpProperties` | §1.2 Prop.1–2 + valuation | `CLAIMED` | PR #92 `c43d7f09…` CI #261 green; #89-only freeze published | `work/c2-s1-2-zp-properties` | #72 / D |
| P12 | `C2S1.2-ZpMetric` | §1.2 Prop.3 metric/completeness/density | `STACKABLE` | PR #116 `f42c68f0…` CI #291 green on exact #72 `c43d7f09…`; no new downstream freeze yet | `work/c2-s1-2-zp-metric` | #89 / D |
| P13 | `C2S1.3-QpField` | §1.3 `Q_p` / Prop.4 | `WAITING` | wait #72 explicit #96 subset/merge; topology+density additionally wait #89 | `work/c2-s1-3-qp-field` | #96 / B |
| P14 | `C2S2.1-RootLiftingExistence` | §2.1 命題5 | `DONE` | PR #103 merged at `326c2aec…`, CI #260 green | `work/c2-s2-1-root-existence` | #99 complete |
| P15 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 命題6 | `PREFLIGHT` | B preflight; #99 stable, full proof still waits #72/#96 | `work/c2-s2-1-primitive-homogeneous-zeros` | #100 / B |
| P16 | `C2S2.2-HenselLifting` | §2.2 Hensel theorem + Cor.1 | `WAITING` | B preflight complete; proof waits #72 congruence/decomposition + #89 completeness | `work/c2-s2-2-hensel-lifting` | #102 / B |
| P17 | `C2S2.2-HenselQuadraticOdd` | §2.2 系2: odd-`p` quadratic lifting | `PREFLIGHT` | B preflight complete; proof waits #102/#72 interfaces | `work/c2-s2-2-hensel-quadratic-odd` | #104 / B |
| P18 | `C2S2.2-HenselQuadraticTwo` | §2.2 系3: dyadic quadratic lifting | `WAITING` | B preflight complete; proof waits explicit #102 main-theorem + #72 dyadic interfaces | `work/c2-s2-2-hensel-quadratic-two` | #105 / B |
| P19 | `C2S3.1-UnitFiltration` | §3.1 `Z_p^×` filtration / Proposition 7 | `PREFLIGHT` | B-owned preflight; core proof waits explicit stable #72 unit/divisibility subset; `Q_p` corollary waits #96 | `work/c2-s3-1-unit-filtration` | #108 / B |
| P20 | `C2S3.2-PrincipalUnits` | §3.2 principal units / Proposition 8 / multiplicative group theorem | `CLAIMED` | canonical branch exists at current main; owner metadata pending; proof remains gated on #108/#72 and final theorem on #96 | `work/c2-s3-2-principal-units` | #112 / owner pending |
| P21 | `C2S3.3-PadicSquares` | §3.3 p-adic squares / Theorems 3–4 / square classes | `PREFLIGHT` | preflight safe; proof waits #112/#96; odd case reuses merged #56 Legendre | `work/c2-s3-3-padic-squares` | #120 / unclaimed |
| P22 | `C3S1.1-HilbertBasics` | 第3章 §1.1 Hilbert記号の定義・Norm criterion・基本公式 | `PREFLIGHT` | generic field/norm preflight safe; project `Q_p` specialization waits #96 | `work/c3-s1-1-hilbert-basics` | #121 / unclaimed |
| P23 | `C3S1.2-HilbertLocalFormula` | 第3章 §1.2 local formula / bilinearity / nondegeneracy | `PREFLIGHT` | preflight safe; proof waits #121/#96/#120 and actual primitive/lifting interfaces | `work/c3-s1-2-hilbert-local-formula` | #122 / unclaimed |

Duplicate records #79/#84/#85 and PR #88 are closed. Old Corollary-2 PR #87 is superseded by merged #94; old Legendre draft #93 is superseded by merged #98.

## 7. Shared-hotspot order

1. **#115 / B is DONE** on main at `56a5307b…`; its former `Formalization.lean` / `Blueprint.lean` slot is clear.
2. **#114 / C** has reconciled on top of that main and owns the current normal `Formalization.lean` single-writer slot; latest checked head `7a48b08d…` is CI #289 green.
3. **#116 / D** changes only Chapter 2 metric/topology/completion files plus an independent Blueprint module and does not touch the shared root. #92 final root/Blueprint integration should still avoid racing #114.

A does not modify worker mathematical branches.

## 8. Queue health

#78 merged, #108 was claimed by B, and #112 acquired an atomic canonical-branch lock (owner metadata still pending). A therefore extended the source-adjacent queue through Chapter 2 §3.3 (#120) and Chapter 3 §1.1–1.2 (#121/#122), rather than inventing unrelated work.

Current clearly unclaimed safe capacity is #120, #121, and #122. #112 is not claimable because its canonical branch already exists. Owned executable/near-executable work includes #64, #72, and stackable #89; owned preflight/waiting work includes #96/#100/#102/#104/#105/#108 plus #112's locked preflight. This preserves three independent safe PREFLIGHT paths while the p-adic dependency chain stabilizes.

A should refill again only when #120/#121/#122 are claimed or cease to provide meaningful safe capacity.

## 9. End-of-run handoff

Record owned branches/PRs, current proof/Blueprint state, CI, STACK-READY interfaces, blockers, and next claimable items. New chats must recheck live GitHub rather than trusting this file alone.
