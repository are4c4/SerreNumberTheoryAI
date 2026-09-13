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
4. branch作成に成功したworkerがowner。branchが既に存在する場合はclaimせず、live stateを再確認して別itemへ移る。
5. focused Issueがまだ無ければ、**branch lock取得後に** worker自身がIssueを作成する。Aの事前承認は不要。
6. Issue / PRにはwork id、dependency、base mode、canonical branchを記録する。

branch作成というGitHub側の一意操作を先に行うことで、複数chatが同じitemを同時にclaimする競合を避けます。

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

stacked workはupstream PRの**特定head SHA**からcanonical branchを作り、PR本文に `Stack base PR` と `Stack base SHA` を記録します。upstreamがmergeしたら、downstreamは最新mainへrebase/更新し、PR baseをmainへ戻してからmergeします。

上流statementがまだ揺れている場合はstackしてはいけません。source順に後だからという理由だけでinterfaceを推測しないでください。

## 5. Dependency rule

依存は章番号ではなく、実際に使う数学的結果で管理します。

- `A → B` のdependencyがあるなら、Aが `DONE` または `STACK-READY` になるまでBの本実装を始めない。
- dependencyが不明なら `PREFLIGHT` で確認する。
- preflightで「実は依存しない」と確認できた場合、Issueに根拠を残して本実装へ進めてよい。
- preflightで新しい依存が判明した場合、Issueとこのqueueを更新し、そのitemだけを `WAITING` / `BLOCKED` にする。

典型例として、後続のべき乗和の議論が有限体の乗法群の結果を使うなら、そのedgeを明示し、乗法群のinterfaceが安定する前にべき乗和のproofを完成させようとしません。

## 6. Current queue

Theorem 1(ii)まではmain上でcross-layer completeです。次の表は、**既存progress文書が保証している範囲だけ**をseedし、未確認の細かいdependencyはpreflightで確定します。

| Priority | Work ID | Target | State | Required before implementation | Canonical branch | Issue / owner |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | `S1.1-T1iii` | 1.1 定理1(iii): 位数 `q` の有限体の抽象同型一意性 | `READY` | Theorem 1(ii) integrated on main ✅ | `work/s1-1-t1iii` | unclaimed |
| P1 | `S1.2-MultGroup` | 1.2 有限体の乗法群 | `PREFLIGHT` | exact Phase 1 prerequisites must be recorded by preflight; do not assume whether T1(iii) is logically needed | `work/s1-2-mult-group` | unclaimed |
| P2 | `S2.1-PowerSums` | 2.1 有限体上のべき乗和 | `PREFLIGHT` | identify the exact S1.2 result(s) used; implementation waits for those results to be `DONE` or `STACK-READY` | `work/s2-1-power-sums` | unclaimed |
| P3 | `S2.2-Chevalley` | 2.2 Chevalleyの定理周辺 | `PREFLIGHT` | identify exact S2.1 prerequisites; implementation waits for them to be `DONE` or `STACK-READY` | `work/s2-2-chevalley` | unclaimed |

## 7. Queue refill

Aはqueue healthを監視し、可能なら常時3〜6個程度の `READY` / `PREFLIGHT` / `STACKABLE` 候補を見える状態に保ちます。ただしAは各workの開始許可ゲートではありません。

B/C/D/Eも、現在のworkを進める中で次のsource targetとdependencyが明白になった場合はfocused Issueやqueue更新を提案・実装してよいです。曖昧なstatement、dependency conflict、shared-hotspot conflictだけをAへrouteします。

## 8. End-of-run handoff

利用可能な実行時間を早く切り上げるためのhandoffではありません。作業を継続し、終了が近いと判断した段階で最後に次を残します。

- owned canonical branch / PR
- current proof / Blueprint state
- CI state
- `STACK-READY` の有無と固定interface
- blocked itemと理由
- 次にclaim可能なqueue item

新しいchatはhandoffだけを信じず、必ずlive GitHub stateを再確認します。
