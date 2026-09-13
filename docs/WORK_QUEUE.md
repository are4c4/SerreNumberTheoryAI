# WORK_QUEUE.md

このファイルは、B/C/D/E の end-to-end formalizer が次に何を実行できるかを判断するための依存関係付き作業キューです。

`main` 上のこの表は計画の source of truth ですが、**live の branch / Issue / PR / CI が表より新しい場合は live GitHub state を優先**します。claim直後は表の更新がまだmergeされていないことがあるため、必ずlive stateも確認してください。

## 1. Queue states

- `READY` — 必要な上流が `main` 上で安定しており、ただちに本実装をclaimできる。
- `PREFLIGHT` — 本実装前の source確認・statement整理・dependency確認・mathlib探索を進めてよい。依存が満たされたと確認できれば同じworkerが `READY` 相当として本実装へ進めてよい。
- `STACKABLE` — 必要な上流が未mergeだが、上流PRで数学的interfaceが明示的に `STACK-READY` とされている。上流headをbaseにstacked branchを作ってよい。
- `WAITING` — 必要な上流が不安定または未確定。本実装は禁止。別work itemへ移る。
- `CLAIMED` — canonical branchが存在し、workerが所有中。
- `CI-WAIT` — PRのCI待ち。work itemは所有中だが、workerは別の `READY` / `PREFLIGHT` workをstealしてよい。
- `BLOCKED` — そのwork item固有の停止条件。worker全体の停止を意味しない。
- `DONE` — mainへ統合済みで、必要なprogress / Blueprint / Lean / verificationが同期済み。

## 2. Atomic claim

各work itemには **canonical branch** を1つだけ割り当てます。branch作成をownership lockとして使います。

1. queue、open Issue / PR、既存branchを再確認する。
2. `READY`、または条件を満たす `STACKABLE` itemを選ぶ。実装可能itemがなければ `PREFLIGHT` を選べる。
3. 指定されたcanonical branchを、`main` または許可されたupstream head SHAから作成する。
4. branch作成に成功したworkerがowner。branchが既に存在する場合はclaimせず、Issue/PRのowner stateを確認する。
5. claim直後、focused Issueへ `OWNER: <lane>`, canonical branch, base mode, base SHA をコメントする。
6. focused Issueがまだ無ければ、**branch lock取得後に** worker自身がIssueを作成する。Aの事前承認は不要。
7. PRにはwork id、dependency、base mode、canonical branchを記録する。

branch作成というGitHub側の一意操作を先に行うことで、複数chatが同じitemを同時にclaimする競合を避けます。

### 2.1 Resume / release / reassignment

branchが存在することだけで永久lockにはしません。

- 同じowner laneの新しいchatはIssue/PR/handoffを読んで既存canonical branchをresumeしてよい。
- ownerが別workへ移っても、CI-WAIT等でそのbranchのownershipは維持される。
- itemを手放す場合はIssueへ `RELEASED` とcurrent stateを記録する。
- owner chatが失われた、または明らかにstaleな場合、AはIssueへ `REASSIGNED: <lane>` と根拠を記録できる。新ownerは既存canonical branchをresumeする。branchを二重作成しない。
- `RELEASED` / `REASSIGNED` が無い他workerは既存branchを奪わない。

## 3. Work stealing

B/C/D/E は固定担当領域を持ちません。現在のworkが次の状態になったら、実行時間が残っている限りqueueを再走査します。

- PRを作成した
- CIがpendingになった
- 1 work itemをmergeした
- work item固有の `BLOCKED:` を記録した
- upstream待ちになった

その時点で最高priorityの実行可能itemをclaimします。**PR作成、CI pending、1 Issue完了はchat停止条件ではありません。**

1 workerが同時に持つ未mergeの実装PRは原則2本までとします。2本ともCI待ち等なら、追加の本実装branchは増やさず、preflight、レビュー、dependency整理、CI再確認、handoff同期を行います。

## 4. Stacked branch gate

下流workを未merge上流へstackしてよいのは、上流ownerがIssueまたはPRに `STACK-READY` を記録し、少なくとも次を固定した場合だけです。

- 数学的statement / assumptions
- 下流が利用する主要なLean declaration名・型、またはそれに相当する明確なinterface
- 変更が下流を破壊する場合の通知先

stacked workはupstream PRの**特定head SHA**をbranch historyへ取り込み、PR本文に `Stack base PR` と `Stack base SHA` を記録します。upstreamがmergeしたら、downstreamは最新mainへrebase/更新し、PR baseをmainへ戻してからmergeします。

上流statementがまだ揺れている場合はstackしてはいけません。source順に後だからという理由だけでinterfaceを推測しないでください。

### 4.1 PREFLIGHT → STACKABLE transition

`PREFLIGHT` itemはdependency gateが確定するまで**formalization codeをcommitしない**のを原則とし、調査結果はIssueコメントへ残します。これによりcanonical branchはmainと同じ位置に保てます。

preflightの結果、未mergeupstreamへのstackが必要になった場合:

1. upstreamが `STACK-READY` になるまでproof実装を待つ。
2. preflight branchに固有code commitが無いことを確認する。
3. canonical branchをapproved upstream headへfast-forward/updateしてから実装を開始する。
4. もしpreflight中にbranch固有commitを作ってしまった場合は、stack開始前に安全なrebase/merge計画をIssueへ記録し、履歴を曖昧にしたままproofを進めない。

## 5. Dependency rule

依存は章番号ではなく、実際に使う数学的結果で管理します。

- `A → B` のdependencyがあるなら、Aが `DONE` または `STACK-READY` になるまでBの本実装を始めない。
- dependencyが不明なら `PREFLIGHT` で確認する。
- preflightで「実は依存しない」と確認できた場合、Issueに根拠を残して本実装へ進めてよい。
- preflightで新しい依存が判明した場合、Issueとこのqueueを更新し、そのitemだけを `WAITING` / `BLOCKED` にする。

典型例として、後続のべき乗和の議論が有限体の乗法群の結果を使うなら、そのedgeを明示し、乗法群のinterfaceが安定する前にべき乗和のproofを完成させようとはしません。

## 6. Current queue

Theorem 1(iii)まではmain上でcross-layer completeです。2026-09-13のsource/dependency preflightと、その後のlive integrationで、書籍上の実際の証明依存を次のように明示しました。

- `S1.2-MultGroup` は Theorem 1(iii) を必要としない。Theorem 1(ii) の安定した `F_q` modelと一般的な有限群・多項式根数の議論から進められ、#50 / PR #59でmainへ統合済み。
- `S2.1-PowerSums` は `S1.2-MultGroup` の巡回性を明示的に使う。#50統合後、Dが#51 / PR #62を最新main上で実装中。
- `S2.2-Chevalley` は `S2.1-PowerSums` の単項式に対する和を明示的に使う。
- §3.1平方数は §2 系列とは独立に、主として `S1.2-MultGroup` とPhase 1の有限体/Frobenius基盤に依存する。#50はmain上で `DONE` なので、Dの#55は上流gateを満たしている。
- §3.2 Legendre記号は §3.1 の平方部分群・half-power character記述を使う。Cの#56 preflightは完了しているが、本proofは#55の必要interfaceが `DONE` または明示的 `STACK-READY` になるまで待つ。

| Priority | Work ID | Target | State | Required before implementation | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 1.1 定理1(iii): 位数 `q` の有限体の抽象同型一意性 | `DONE` | PR #58 merged; policy / Lean / Verso green ✅ | `work/s1-1-t1iii` | #49 / C (done) |
| P1 | `S1.2-MultGroup` | 1.2 有限体の乗法群 / 定理2 | `DONE` | PR #59 merged; stable cyclicity/cardinality interface is on main ✅ | `work/s1-2-mult-group` | #50 / B (done) |
| P2 | `S2.1-PowerSums` | 2.1 有限体上のべき乗和 | `CLAIMED` | `S1.2-MultGroup` is `DONE`; D is implementing on latest main in PR #62 | `work/s2-1-power-sums` | #51 / D (PR #62) |
| P3 | `S2.2-Chevalley` | 2.2 Chevalley–Warning theorem vicinity | `CLAIMED` | full proof waits for `S2.1-PowerSums` `DONE` or `STACK-READY` | `work/s2-2-chevalley` | #52 / D |
| P4 | `S3.1-QuadraticElements` | 3.1 `F_q` の平方数 / 定理4 | `CLAIMED` | `S1.2-MultGroup` is `DONE`; D may proceed using project cyclicity plus Phase 1 Frobenius infrastructure | `work/s3-1-quadratic-elements` | #55 / D |
| P5 | `S3.2-LegendreSymbol` | 3.2 Legendre記号 / 定理5 | `CLAIMED` | C preflight complete; proof waits for the required #55 half-power `{±1}` / square-kernel interface to be `DONE` or `STACK-READY` | `work/s3-2-legendre-symbol` | #56 / C |

Issueが存在するだけではownershipではありません。canonical branchを最初に作成したworkerがownerです。`CLAIMED` 行についてはIssue上の `OWNER:` コメントとlive branchを優先します。

`PREFLIGHT` 行は「本proofを開始してよい」という意味ではありません。dependency gateが未成立なら、source / statement / dependency / mathlib調査だけを進め、結果をIssueへ残して別の実行可能itemへ移ります。

## 7. Queue refill

Aはqueue healthを監視し、可能なら常時3〜6個程度の `READY` / `PREFLIGHT` / `STACKABLE` 候補を見える状態に保ちます。ただしAは各workの開始許可ゲートではありません。

B/C/D/Eも、現在のworkを進める中で次のsource targetとdependencyが明白になった場合はfocused Issueやqueue更新を提案・実装してよいです。曖昧なstatement、dependency conflict、shared-hotspot conflictだけをAへrouteします。

次のrefill候補は §3.3 平方剰余の相互法則です。§3.2のstatement/interfaceが安定する前にproof dependencyを推測せず、queue depthが減った段階でPREFLIGHT seedを追加します。

## 8. End-of-run handoff

利用可能な実行時間を早く切り上げるためのhandoffではありません。作業を継続し、終了が近いと判断した段階で最後に次を残します。

- owned canonical branches / PRs（最大2本のin-flight実装PRを含む）
- current proof / Blueprint state
- CI state
- `STACK-READY` の有無と固定interface
- blocked itemと理由
- 次にclaim可能なqueue item

新しいchatはhandoffだけを信じず、必ずlive GitHub stateを再確認します。
