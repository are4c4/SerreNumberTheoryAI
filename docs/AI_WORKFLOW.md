# AI_WORKFLOW.md

この文書は、複数のChatGPTチャットを同時に動かすための協調プロトコルです。会話履歴ではなくGitHubを共有状態とし、各chatは長時間連続で作業するAI workerとして振る舞います。

## 1. Core model

旧方式の「B=Lean、C=Blueprint、D=mathlib、E=integration」という職種別pipelineは廃止します。handoff待ちが増え、1つのchatが短時間でidleになりやすいためです。

現在の構成:

| Lane | Role |
| --- | --- |
| A | Scheduler / Design — dependency graph、queue health、曖昧なstatement、ownership conflictの調整 |
| B | End-to-end Formalizer |
| C | End-to-end Formalizer |
| D | End-to-end Formalizer |
| E | End-to-end Formalizer |

B/C/D/Eは同等です。1つのwork itemをclaimしたworkerが、そのitemについて可能な限り次をend-to-endで担当します。

1. source位置と数学的statementの解釈
2. dependency確認
3. mathlib API調査
4. Lean statement / proof
5. Blueprint / independent exposition
6. Lean↔Blueprint linkage
7. policy / `lake build` / `lake exe vbp build`
8. PR、CI修正、自己レビュー、merge
9. progress / handoff同期

専門レーンへのhandoffは通常行いません。数学的に曖昧な判断や競合だけをAへrouteします。

## 2. Source of truth

共有状態は次です。

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/WORK_QUEUE.md`
4. `docs/LANE_STATUS.md`
5. 自分の `docs/lanes/*.md`
6. `FORMALIZATION_PROGRESS.md`
7. `docs/SOURCE_AND_COPYRIGHT_POLICY.md`
8. live GitHub state — latest main、branch、Issue、PR、CI
9. 対象の既存Formalization / Blueprint

**live GitHub stateが静的handoff文書より新しい場合はlive stateを優先**し、後で文書を同期します。

## 3. Queue first

実行可能性は `docs/WORK_QUEUE.md` で管理します。workerはlane固有のassigned Issueを待つのではなく、queueとlive stateを見てwork stealingします。

主なstate:

- `READY`: mainから本実装可能
- `PREFLIGHT`: source / statement / dependency / mathlib調査を進められる
- `STACKABLE`: upstream未mergeだがinterfaceが `STACK-READY`
- `WAITING`: upstream不安定
- `CLAIMED`: ownerあり
- `CI-WAIT`: ownerのPRがCI待ち。ownerは別workをsteal可能
- `BLOCKED`: item固有のblocker
- `DONE`: mainへ統合済み

詳しいstate machineは `docs/WORK_QUEUE.md` を参照します。

## 4. Ownership: canonical branch as lock

同じwork itemを2 workerが同時に実装しないため、canonical branch作成をatomic ownership lockにします。

### Claim procedure

1. queue、open Issue / PR、既存branchを再確認する。
2. 最高priorityの実行可能itemを選ぶ。
3. item指定のcanonical branchを作る。
   - `READY`: latest mainから作る。
   - `STACKABLE`:許可されたupstream PRの特定head SHAから作る。
4. branch作成に成功したworkerがowner。
5. branchが既に存在するなら、そのitemを奪わず別itemへ移る。
6. focused Issueが無ければbranch lock取得後にworker自身で作る。Aの許可待ちは不要。

したがって、Aが全Issueを事前生成しないことはworkerの停止理由になりません。

## 5. Actual dependency graph, not chapter parallelism

並列化は章番号ではなく数学的依存関係に従います。

- downstream proofがupstream theoremを使うならdependency edgeを記録する。
- upstreamが不安定ならdownstream proofを推測して実装しない。
- dependencyが不明なら `PREFLIGHT` でsourceと既存コードを確認する。
- source順が後でも、論理的に独立と確認できればmainから並列化してよい。
- 新しいdependencyが判明したらIssueとqueueへ記録する。

この原則により、例えば後続のべき乗和が有限体の乗法群の結果を必要とするなら、乗法群のinterfaceが安定する前にべき乗和proofを完成させようとはしません。

## 6. Continuous-run rule

workerの目的は「1 Issueを終えること」ではなく、**利用可能な実行時間を安全な形式化作業に使い続けること**です。

次は停止条件ではありません。

- commitを作った
- PRを作った
- CIがpendingになった
- 1 Issue / 1 work itemを完了した
- 1 work itemがupstream待ちになった
- 1 work itemが `BLOCKED:` になった

上記のいずれかになったら、実行時間が残っている限りqueueを再走査してwork stealingします。

### In-flight cap

1 workerあたり未mergeの実装PRは原則2本までです。

- 0〜1本: 次の `READY` / `STACKABLE` をclaimしてよい。
- 2本: 3本目の実装PRは増やさず、既存PRのCI確認・修正、`PREFLIGHT`、dependency整理、self-review、handoff同期を行う。

これによりthroughputを上げつつ、未統合branchが増えすぎるのを防ぎます。

## 7. Stacked branches

upstream merge待ちでdownstream workerをidleにしないため、限定的にstacked branchを許可します。

### Stack gate

upstream ownerがIssueまたはPRに `STACK-READY` を明記し、次を固定した場合だけstack可能です。

- mathematical statement / assumptions
- downstreamが使う主要Lean interface
- stack base PR と head SHA

downstreamはその特定SHAからcanonical branchを作り、PR本文にstack情報を記録します。

### After upstream merge

1. latest mainを再確認する。
2. downstream branchをmainへrebase/更新する。
3. PR baseをmainへ戻す。
4. policy / Lean / Blueprint checksを再実行する。
5. upstream差分がstatement/interfaceを変えていないことを再確認してからmergeする。

upstreamが `STACK-READY` 後にbreaking changeを入れる必要が生じた場合、upstream ownerはstacked downstream Issue/PRへ通知し、下流は再検証までmerge禁止です。

## 8. PREFLIGHT as productive fallback

実装可能itemが無い場合も、workerはすぐidleになりません。queueの `PREFLIGHT` itemについて、次のうち安全なものを進めます。

- 書籍上の対象位置・statement boundaryの確認
- 既存mainのどの定理が必要かというdependency audit
- mathlib namespace / theorem / coercionの調査
- near-target theoremの強さ判定
- file split / declaration naming案
- Blueprint dependency skeletonの設計

ただし、不安定upstreamのstatementを仮定したLean proofをcommitしてはいけません。preflight結果からdependency gateを満たしたと確認できた場合は、その根拠をIssueへ残してend-to-end本実装へ進みます。

## 9. A lane: scheduler, not approval gate

Aの役割:

- `docs/WORK_QUEUE.md` を3〜6個程度先まで見える状態に保つ
- source/dependency graphを整理する
- ambiguous statementを解決または `BLOCKED:` 化する
- ownership / shared-hotspot conflictを調整する
- stale handoff / queue driftを直す
- 大きすぎるtargetをdependency-safeなwork itemへ分割する

AはB/C/D/Eの開始許可ゲートではありません。workerがqueueから安全にclaimできるなら進めます。

A自身にcoordination作業が少ない場合は、将来workのdependency preflightやqueue補充を行います。通常のproof実装をworker poolから奪いません。

## 10. Worker end-to-end lifecycle

B/C/D/Eは次のloopを実行します。

1. startup docs + live GitHubを読む。
2. 自分のactive canonical branch / PRがあれば最優先で復元する。
3. active workが実行可能なら継続する。
4. CI pending / blocked / waitingならqueueをscanする。
5. canonical branch lockで次itemをclaimする。
6. source / dependency / mathlibを確認する。
7. statementが一意ならLean + Blueprintをend-to-endで実装する。
8. local/repository checksを実行する。
9. PRを作る。
10. `STACK-READY` を出せるならinterfaceを明記する。
11. CI待ちなら別itemをstealする。
12. greenになったPRをself-reviewしmergeする。
13. latest mainへ同期し、progress / queue / handoff driftを修正する。
14. 実行時間が残る限りloopを続ける。

## 11. Work-item blocker vs worker blocker

`AGENTS.md` の `BLOCKED:` は原則として**work itemを止める**ものであり、worker chat全体を止めるものではありません。

work itemでblockerを発見したら:

1. Issue / PRへ `BLOCKED: ...` と根拠を記録する。
2. unsafeな実装を進めない。
3. Aへrouteが必要ならrouteする。
4. queueへ戻り、別の実行可能itemをclaimする。

worker全体が停止するのは次の場合です。

- repository全体に影響するhard infrastructure failureで安全な別workもない
- queueに `READY` / eligible `STACKABLE` / `PREFLIGHT` が1つもない
- ownership/shared-hotspot conflictが広範囲で、別fileの安全なworkもない
- 利用可能な実行時間の終了が近く、handoff同期を優先すべき段階

## 12. Shared hotspots

以下は競合しやすいため、編集前にopen PRを確認します。

- `AGENTS.md`
- `README.md`
- `FORMALIZATION_PROGRESS.md`
- `docs/WORK_QUEUE.md`
- `docs/LANE_STATUS.md`
- root import aggregators
- `lakefile.lean`
- `.github/workflows/**`

数学workでは可能な限りtarget固有ファイルを作り、root aggregator更新を小さく保ちます。

## 13. Handoff

各lane文書は簡潔なworker状態だけを残します。

- active work id / Issue
- canonical branch / PR
- base mode (`main` / stacked)
- stack base SHA if any
- CI state
- `STACK-READY` state
- blockers
- next safe action

古いhandoffよりlive GitHubを優先します。チャット内だけに重要な状態を残して終了しません。
