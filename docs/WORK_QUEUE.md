# WORK_QUEUE.md

このファイルは、B/C/D/E の end-to-end formalizer が次に何を実行できるかを判断するための依存関係付き作業キューです。

`main` 上のこの表は計画の source of truth ですが、**live の branch / Issue / PR / CI が表より新しい場合は live GitHub state を優先**します。

## 1. Queue states

- `READY` — 必要な上流が `main` 上で安定し、ただちに本実装をclaimできる。
- `PREFLIGHT` — source確認・statement整理・dependency確認・mathlib探索を進めてよい。本proofはgate成立後。
- `STACKABLE` — 未merge upstream が statement / interface / exact head SHA を `STACK-READY` として固定済み。
- `WAITING` — upstream interfaceが未安定。本実装は禁止。
- `CLAIMED` — canonical branchが存在しworker所有中。
- `CI-WAIT` — PRのCI待ち。ownerは別の安全なworkをstealしてよい。
- `BLOCKED` — item固有の停止条件。
- `DONE` — mainへ統合済みで、必要なprogress / Blueprint / Lean / verificationが同期済み。

## 2. Atomic claim

各work itemには **canonical branch** を1つだけ割り当て、branch作成をownership lockとして使います。

1. queue、open Issue / PR、既存branchを再確認する。
2. `READY`、条件を満たす `STACKABLE`、または安全な `PREFLIGHT` を選ぶ。
3. 指定canonical branchを `main` または許可されたupstream exact headから作成する。
4. branch作成に成功したworkerがowner。既存branchを `RELEASED` / `REASSIGNED` なしに奪わない。
5. focused Issueへ `OWNER: <lane>`、canonical branch、base mode、base SHAを記録する。
6. Issueが無ければ、branch lock取得後にworker自身が作成してよい。A承認待ちは不要。

### 2.1 Resume / release / reassignment

- 同じowner laneの新chatは既存canonical branchをresumeしてよい。
- itemを手放す場合はIssueへ `RELEASED` とcurrent stateを記録する。
- stale owner等の場合、AはIssueへ `REASSIGNED: <lane>` と根拠を記録できる。

## 3. Work stealing

PR作成、CI pending、1 item merge、item固有blocker、upstream待ちはchat停止条件ではありません。実行時間が残っていればqueueを再走査し、別の `READY` / `STACKABLE` / `PREFLIGHT` を進めます。

1 workerの未merge実装PRは原則2本までです。2本とも待機中なら追加実装branchを増やさず、preflight、レビュー、dependency整理、CI確認、handoff同期を行います。

## 4. Stacked branch gate

stackしてよいのはupstream ownerが少なくとも次を固定した場合だけです。

- 数学的statement / assumptions
- downstreamが使う主要Lean declaration名・型
- exact head SHA
- interface変更時の通知先

stacked branchはそのexact upstream headをbase/historyへ取り込み、PR本文に Stack base PR / SHA を記録します。upstream merge後は最新mainへ戻して統合検証します。

`PREFLIGHT` branchは原則proof-code-cleanに保ち、gate成立後に approved head へfast-forward/updateして実装します。

## 5. Dependency rule

依存は章番号ではなく、実際に使う数学的結果で管理します。dependency不明なら `PREFLIGHT` で確認し、依存しないと分かればIssueに根拠を残して進めてよいです。新しいhard edgeが判明したitemだけを `WAITING` / `BLOCKED` にします。

## 6. Current queue

現在mainでend-to-end完了している主要sliceは Theorem 1(ii)/(iii)、§1.2 multiplicative group、§2.1 power sums、§2.2 core Chevalley–Warning、そしてその系1です。

Live dependency graph:

- `S2.2-Chevalley-Cor1` は #70 / PR #80 で `DONE`。後発の #84 はduplicateとしてclosed。
- `S2.2-Chevalley-Cor2` / #85 は系1のspecializationであり、#70がDONEなので現在 `READY`。
- `S3.1-QuadraticElements` / #55 はD-owned。PR #82 exact head `ead063fff3e3714a77c9b340ffc339f4c8f74dfd` がCI-greenで、§3.2向け half-power / square-kernel interfaceを `STACK-READY` としてfreeze済み。ただしPR #82自体は最新mainへの再同期後にDがmergeする。
- `S3.2-LegendreSymbol` / #56 はC-owned。#55のexact frozen headを使って今は `STACKABLE`。Cはそのheadへstackしてproof実装へ進めてよい。
- `S3.3-QuadraticReciprocity` / #64 はC-owned `PREFLIGHT`。full proofは #56 が characteristic-independent Legendre sign、field-core compatibility、multiplicativity、Theorem 5(ii) at `-1` を `STACK-READY` にするまで待つ。Theorem 5(iii) at `2` はhard dependencyではない。
- `C1-Supp-GaussLemma` / #78 はunclaimed `PREFLIGHT`。#64には依存せず、proofはminimal #56 Legendre/half-power interface待ち。
- `C2S1.1-ZpConstruction` / #71 はB-owned、draft PR #86で実装中。後発 #79 はduplicateとしてclosed。
- `C2S1.2-ZpProperties` / #72 はD-owned `PREFLIGHT`。source/API preflightは完了し、proofは #71 public representation/projection/integer-map interface `DONE`/`STACK-READY` 待ち。D preflightは #72 をProposition 1–2 + valuationのalgebraic sliceとし、Proposition 3 metric/completeness/densityをfollow-upへ分けることを推奨している。

| Priority | Work ID | Target | State | Required before implementation | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 定理1(iii) | `DONE` | PR #58 merged green | `work/s1-1-t1iii` | #49 / complete |
| P1 | `S1.2-MultGroup` | 有限体の乗法群 / 定理2 | `DONE` | PR #59 merged green | `work/s1-2-mult-group` | #50 / complete |
| P2 | `S2.1-PowerSums` | 有限体上のべき乗和 | `DONE` | PR #62 merged green | `work/s2-1-power-sums` | #51 / complete |
| P3 | `S2.2-Chevalley` | core Chevalley–Warning | `DONE` | PR #68 merged green | `work/s2-2-chevalley` | #52 / complete |
| P4 | `S2.2-Chevalley-Cor1` | 系1: 原点以外の共通零点 | `DONE` | PR #80 merged green | `work/s2-2-chevalley-cor1-nontrivial-zero` | #70 / B complete |
| P5 | `S2.2-Chevalley-Cor2` | 系2: 3変数以上の2次形式 | `READY` | #70 DONE; use project Corollary 1 | `work/s2-2-chevalley-cor2` | #85 / unclaimed |
| P6 | `S3.1-QuadraticElements` | 3.1 `F_q` の平方数 / 定理4 | `CLAIMED` | PR #82 green; D resync/merge pending | `work/s3-1-quadratic-elements` | #55 / D |
| P7 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `STACKABLE` | stack on #55 head `ead063fff3e3…` | `work/s3-2-legendre-symbol` | #56 / C |
| P8 | `S3.3-QuadraticReciprocity` | 3.3 平方剰余の相互法則 / 定理6 | `PREFLIGHT` | wait for minimal #56 subset `STACK-READY`/DONE | `work/s3-3-quadratic-reciprocity` | #64 / C |
| P9 | `C1-Supp-GaussLemma` | 第1章補遺 (i) Gaussの補題 | `PREFLIGHT` | proof waits for minimal #56 interface | `work/c1-supp-gauss-lemma` | #78 / unclaimed |
| P10 | `C2S1.1-ZpConstruction` | 第2章 §1.1 `Z_p` inverse-limit construction | `CLAIMED` | no Chapter 1 dependency | `work/c2-s1-1-zp-construction` | #71 / B / PR #86 |
| P11 | `C2S1.2-ZpProperties` | 第2章 §1.2 Proposition 1–2 + valuation | `WAITING` | #71 public interface DONE/STACK-READY; preflight complete | `work/c2-s1-2-zp-properties` | #72 / D |

Issueが存在するだけではownershipではありません。canonical branch / Issue `OWNER:` / live PRを優先します。

## 7. Queue health / refill

現在unclaimedで安全に着手できる候補は少なくとも #85 (`READY`) と #78 (`PREFLIGHT`) です。加えて #56 はowner Cがstack実装可能、#71はBが実装中、#72はDがpreflight済み待機中です。

Aはduplicate workを作らず、3〜6個程度の実行候補を維持します。#85/#78がclaimされた場合は、Dの#72 preflightで切り出された §1.2 Proposition 3 metric/completeness/density follow-up など、source/dependency boundaryが既に明確なものから次のseedを検討します。

## 8. End-of-run handoff

終了前にはowned canonical branches / PRs、proof/Blueprint state、CI、`STACK-READY` interface、blocker、次にclaim可能なitemを残します。新chatはhandoffだけでなくlive GitHub stateを必ず再確認します。
