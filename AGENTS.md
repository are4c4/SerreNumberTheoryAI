# AGENTS.md

このファイルは `SerreNumberTheoryAI` で作業するAIエージェントの最上位ルールです。形式化・Blueprint・自然言語説明・mathlib調査・CI・GitHub運用のすべてに適用します。

## 0. プロジェクトの目的

日本語版セール『数論講義』を参考資料として数学的内容を理解し、以下を同期して独立に構成する。

- 人間向けの自然言語説明
- Verso Blueprint による依存関係・進捗
- Lean 4 + mathlib による機械検証可能な形式化

「Leanが通ること」だけでなく、「セールで扱われている数学を忠実に形式化すること」を優先する。

## 1. Source of truth とworker起動

作業開始時に必ず確認する。

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/WORK_QUEUE.md`
4. `docs/LANE_STATUS.md`
5. 自分の `docs/lanes/*.md`
6. `FORMALIZATION_PROGRESS.md`
7. `docs/SOURCE_AND_COPYRIGHT_POLICY.md`
8. 最新 `main`
9. live branch / open Issue / PR / CI
10. 対象節に対応する本リポジトリ内の既存Blueprint / formalization

GitHub上のmain・branch・Issue・PR・CIが共有状態であり、チャット履歴だけに存在する情報はsource of truthではない。静的handoffとlive GitHub stateが矛盾する場合はlive stateを優先し、後で文書を同期する。

複数chatの並列運用は `docs/AI_WORKFLOW.md` に従う。

- A — Scheduler / Design / dependency coordination
- B — End-to-end Formalizer
- C — End-to-end Formalizer
- D — End-to-end Formalizer
- E — End-to-end Formalizer

B/C/D/Eは同等workerであり、固定専門領域を持たない。

### 1.1 Ownership hard rule

- **1 work item = 1 active owner** を守る。
- ownershipは `docs/WORK_QUEUE.md` のcanonical branchをGitHub上で作成することでclaimする。
- canonical branch作成に失敗した場合、そのitemは別workerが所有している可能性があるため奪わない。
- active PR / branchと重複するworkを開始しない。
- shared hotspotを編集する前にopen PRを確認する。
- focused Issueがまだなくても、queueに安全なwork itemがありcanonical branch lockを取得できれば、worker自身がIssueを作成して進めてよい。Aの事前承認は不要。
- 上流が未mergeの場合は `STACK-READY` 条件を満たさない限りdownstream proofを推測して実装しない。

## 2. 人間版リポジトリからの独立性 — hard rule

`are4c4/SerreNumberTheoryBlueprint` は人間が自力で進める別プロジェクトである。

数学的な作業では、同リポジトリの次の内容を**解答源として参照してはならない**。

- `Formalization` のLeanコード
- `Blueprint` の数学的説明・証明
- theorem / lemma の具体的な証明構成

そこからコード・証明・補題分割・文章をコピー、翻案、模倣しない。

Lean toolchain、Verso、CI等の**一般的インフラ互換性**を合わせる必要がある場合に限り、設定ファイルの構成を比較してよい。その場合も数学的内容は持ち込まない。

## 3. 書籍本文の取扱い

日本語版セール『数論講義』は参考資料であり、公開リポジトリへ本文を再配布しない。

禁止:

- 本文の転載
- 長い直接引用
- 一文ずつ対応する言い換え
- ページ画像・スキャン・スクリーンショットのcommit
- 図表の忠実な複製
- 本文をほぼ復元できる逐語的要約

許可:

- 節番号・定理番号・ページ等の出典メタデータ
- 数学的定義・主張・証明アイデアの抽出
- 数学的内容から新規に構成した独立説明
- Leanで必要な中間補題の独立説明

直接引用が本当に必要だと判断した場合は、commitせず `BLOCKED: SOURCE-QUOTE-REVIEW` として人間確認を求める。

ユーザーがチャットで書籍画像を提示した場合、その画像は理解のために利用してよいが、画像や長い転記をGitHubへ保存しない。

## 4. 数学的忠実性

### 4.1 statement integrity

以下は禁止する。

- 証明を通すために仮定を不必要に強くする
- 結論を弱める
- 定義を都合よく変更する
- 対象定理と異なる定理を同じ名前で登録する

書籍の主張に複数の自然な形式化があり、一意に決められない場合はそのwork itemを停止する。別workerが勝手に別解釈を採用して進めてはならない。Aへrouteする。

### 4.2 証明方針の優先順位

1. セールとほぼ同じ数学的アイデア
2. 同程度に基本的で透明な別証明
3. より一般的なmathlib定理を組み合わせる証明
4. 対象定理そのもの、または実質同値な完成済み定理を直接利用

4は原則として正式な完了形に採用しない。どうしても必要なら `BLOCKED: TARGET-THEOREM-ONLY` とする。

### 4.3 Lean上の分解

数学的アイデアを保つ限り、Leanに適した補助lemmaの追加・分割・再構成は推奨する。

書籍では一行の議論でも、型合わせ・有限和・cast・subtype・equiv等の処理のために複数lemmaへ分解してよい。

### 4.4 Dependency integrity

- 並列化は章番号ではなく実際の数学的依存関係で決める。
- downstreamがupstream theoremを使うなら、そのedgeをIssue / queueへ記録する。
- dependencyが不明なら `PREFLIGHT` で確認する。
- source順が後でも論理的独立と確認できれば並列化してよい。
- upstream statementが不安定なままdownstream statement / proofを推測しない。

## 5. mathlib利用方針

積極的に利用してよい:

- `Finset`, `Fintype`, `Set`
- 自然数・整数・有理数等の基本API
- 群・環・体の一般論
- 準同型・同型・部分構造の一般論
- 多項式・有限和等の標準API
- 一般的な代数・組合せ補題

慎重に利用する:

- 対象節の核心に近い有限体固有定理
- 対象定理をほぼ自動的に導く高度な定理

PR本文には主要なmathlib依存と、意図的に使用しなかった「強すぎる」定理を記録する。

どのformalizerも、自分で候補定理の型・仮定・強さを確認する。過去のresearch handoffは参考情報であって検証の代替ではない。

## 6. 禁止された証明穴

formalization sourceでは以下を禁止する。

- `sorry`
- `admit`
- 証明穴を埋めるための新規 `axiom`

既存mathlib内部のaxiom利用を再実装する必要はない。

`#check` や `example` を探索中に一時利用してもよいが、完成PRでは不要な探索コードを削除する。

## 7. Blueprint / 自然言語説明

各主要Definition / Lemma / Proposition / Theoremには可能な限り以下を持たせる。

- 一意なBlueprint id
- 独立した数学的説明
- `lean :=` によるLean declarationとの対応
- `uses :=` による主要依存
- 必要なら独立したproof explanation

自然言語説明は書籍の文の翻訳・言い換えではなく、数学的内容から新規に構成する。

Lean proofと自然言語proofの数学的戦略が大きく異なる場合、Blueprintに差異を明記する。

work item ownerは原則としてLeanとBlueprintを同じend-to-end slice内で同期する。宣言名が未確定なら、同じworker内でstatementとLean interfaceを安定させてから最終 `lean :=` linkageを入れる。

## 8. Continuous autonomous workflow

B/C/D/Eは次のloopを、人間への逐次確認なしで実行してよい。

1. startup docsとlive GitHubを再確認する。
2. 自分が既に所有するcanonical branch / PRがあれば復元する。
3. 実行可能ならそのworkを進める。
4. workがCI待ち、upstream待ち、またはitem固有blockerになったらqueueを再走査する。
5. `READY` / eligible `STACKABLE` / `PREFLIGHT` の最高priority itemをcanonical branch lockでclaimする。
6. source interpretation、dependency、mathlib APIを確認する。
7. statementが一意ならLean + Blueprint + independent expositionをend-to-endで実装する。
8. policy / `lake build` / `lake exe vbp build` を実行する。
9. PRを作る。
10. downstream stackingを安全に許せる場合だけIssue/PRへ `STACK-READY` と固定interface / head SHAを記録する。
11. CI pendingなら停止せず、in-flight上限の範囲で別workをstealする。
12. CI greenになったPRをdiff・statement integrity・dependencyまで自己レビューしてmergeする。
13. latest mainを再確認し、progress / queue / handoff driftを同期する。
14. 利用可能な実行時間が残る限りloopを続ける。

AIは通常、人間レビューを待たずにPRをmergeしてよい。

### 8.1 Continuous-run hard rule

次は**chat停止条件ではない**。

- commit完了
- PR作成完了
- CI pending
- 1 work item完了
- 1 work itemのupstream待ち
- 1 work item固有の `BLOCKED:`

上記になったら別の安全なworkへ移る。

1 workerの未merge実装PRは原則2本まで。2本ある場合は3本目を増やさず、CI確認・修正・PREFLIGHT・dependency整理・self-review・handoff同期を行う。

### 8.2 Stacked branch

stacked branchを許可するのは、upstream ownerがIssueまたはPRへ `STACK-READY` を記録し、数学的statement・assumptions・downstreamが使うLean interface・stack base head SHAを固定した場合だけである。

- downstream canonical branchはその特定SHAから作る。
- downstream PRはstack base PR / SHAを記録する。
- upstream merge後は最新mainへrebase/更新し、PR baseをmainへ戻し、全checkを再実行する。
- upstreamにbreaking changeが必要になったらstacked downstreamは再検証までmerge禁止。

## 9. Blocker semantics と停止条件

以下では、その**work item**を勝手に解決せず、Issue/PRに根拠を残して停止する。

- `BLOCKED: STATEMENT-AMBIGUOUS` — 主張の形式化が複数あり選べない
- `BLOCKED: ASSUMPTION-CHANGE` — 仮定の追加・削除・変更が必要
- `BLOCKED: POSSIBLE-SOURCE-ERROR` — 書籍の記述に誤り・脱落の疑い
- `BLOCKED: PRIOR-FORMALIZATION-ERROR` — 既存の前提形式化に数学的問題
- `BLOCKED: TARGET-THEOREM-ONLY` — 対象そのものの既存定理以外で進めない
- `BLOCKED: MAJOR-PROOF-DEVIATION` — セールと大きく異なる強力な数学が必要
- `BLOCKED: SOURCE-QUOTE-REVIEW` — 直接引用等の公開判断が必要
- `BLOCKED: INFRASTRUCTURE` — CI / toolchain / dependency問題でそのworkを安全に進められない
- `BLOCKED: OWNERSHIP-CONFLICT` — 同じwork item / shared hotspotに別のactive ownerがある
- `BLOCKED: CROSS-LAYER-STATEMENT-DRIFT` — LeanとBlueprint等でstatement解釈が一致しない

blockerを記録したworkerは、unsafeな実装を止めた上でqueueへ戻り、別の実行可能itemをclaimする。

worker chat全体が停止するのは、次のいずれかの場合だけである。

- repository全体に影響するhard failureで、安全な別workもない
- queueに `READY` / eligible `STACKABLE` / `PREFLIGHT` がない
- ownership/shared-hotspot conflictが広範囲で、安全な別fileのworkもない
- 利用可能な実行時間の終了が近く、handoff同期が必要

## 10. Definition of Done

1つのend-to-end formalization work itemをcompleteにするには最低限次を満たす。

- statementの数学的意味が記録されている
- dependencyが記録されている
- independent natural-language explanationがある
- Blueprint node / dependencyがある
- Lean declarationが対応している
- Lean↔Blueprint linkageがある
- proofに `sorry` / `admit` / 新規穴埋めaxiomがない
- `bash scripts/check_formalization_policy.sh` 成功
- `lake build` 成功
- `lake exe vbp build` 成功
- `FORMALIZATION_PROGRESS.md` の該当状態が同期されている
- PR本文に数学的方針・mathlib依存・強すぎて避けた定理・セールとの差異・dependency/base modeが記録されている
- stacked workならupstream merge後のmain再検証が成功している

旧方式のようにLeanだけ / Blueprintだけを通常の別lane PRとして完了扱いにはしない。大きすぎるtargetは、数学的dependencyが明確なend-to-end sub-sliceへ分割する。

## 11. PRの粒度

原則として「1つの小節」「密接に依存する1つの定理群」または「dependency-safeな1つのend-to-end sub-slice」を1 PRとする。

巨大PRにしない。一方で、同じ小さなtargetのLean / Blueprint / research / integrationを職種別の4 PRへ機械的に分割しない。

shared hotspotだけをまとめるinfra/coordination PRは数学PRから分離してよい。

## 12. A scheduler の責務

Aはapproval gateではない。

Aが担当するのは:

- `docs/WORK_QUEUE.md` のqueue health
- dependency graph / work item境界
- statement ambiguityの調整
- ownership / shared-hotspot conflict
- stale handoff / queue drift
- 大きすぎるtargetの分割

Aの事前Issue作成や承認がなくても、formalizerがqueue上の安全なitemをatomic claimできれば進めてよい。

## 13. 初期実験の範囲

最初は以下のみで自律運用を評価する。

1. 有限体
2. 有限体の乗法群
3. 有限体上のべき乗和
4. Chevalleyの定理周辺

この範囲を終えるまでは、プロジェクト全体を一気に自動生成しない。問題を発見したら先に本規約・queue workflowを改善する。
