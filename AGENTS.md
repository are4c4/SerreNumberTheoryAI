# AGENTS.md

このファイルは `SerreNumberTheoryAI` で作業するAIエージェントの最上位ルールです。形式化・Blueprint・自然言語説明・mathlib調査・CI・GitHub運用のすべてに適用します。

## 0. プロジェクトの目的

日本語版セール『数論講義』を参考資料として数学的内容を理解し、以下を同期して独立に構成する。

- 人間向けの自然言語説明
- Verso Blueprint による依存関係・進捗
- Lean 4 + mathlib による機械検証可能な形式化

「Leanが通ること」だけでなく、「セールで扱われている数学を忠実に形式化すること」を優先する。

## 1. Source of truth とレーン起動

作業開始時に必ず確認する。

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. 自分の `docs/lanes/*.md`
5. `FORMALIZATION_PROGRESS.md`
6. `docs/SOURCE_AND_COPYRIGHT_POLICY.md`
7. 最新 `main`
8. open Issue / PR / CI
9. 対象節に対応する本リポジトリ内の既存Blueprint / formalization

GitHub上のmain・Issue・PR・CI・lane handoffが共有状態であり、チャット履歴だけに存在する情報はsource of truthではない。

複数チャットの並列運用は `docs/AI_WORKFLOW.md` に従う。初期レーンは以下。

- A — Design / Coordination
- B — Lean Formalization
- C — Blueprint / Exposition
- D — Mathlib Research
- E — Integration / CI

新しいチャットで「Bレーンとして作業を続けて」のように指示された場合、上記の読込順でGitHubから現在地を復元してから作業する。

### 1.1 Ownership hard rule

- 同じdeliverableを複数レーンが同時に所有してはならない。
- 同じ数学的targetでも、Lean / Blueprint / research / integrationのように成果物が分離され、focused Issueとownerが明示されていれば並列作業してよい。
- active PRと重複する作業を開始しない。
- shared hotspotを編集する前にopen PRを確認する。
- 広いparent Issueしかない場合、Aレーンがfocused Issueへ分割するまで新規実装をclaimしない。

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

書籍の主張に複数の自然な形式化があり、一意に決められない場合は停止する。レーン間でstatement解釈が一致しない場合もAへrouteして停止する。

### 4.2 証明方針の優先順位

1. セールとほぼ同じ数学的アイデア
2. 同程度に基本的で透明な別証明
3. より一般的なmathlib定理を組み合わせる証明
4. 対象定理そのもの、または実質同値な完成済み定理を直接利用

4は原則として正式な完了形に採用しない。どうしても必要なら `BLOCKED: TARGET-THEOREM-ONLY` とする。

### 4.3 Lean上の分解

数学的アイデアを保つ限り、Leanに適した補助lemmaの追加・分割・再構成は推奨する。

書籍では一行の議論でも、型合わせ・有限和・cast・subtype・equiv等の処理のために複数lemmaへ分解してよい。

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

Dレーンの調査結果は候補情報であり、Bレーンは実装時に型・仮定・定理の強さを再確認する。

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

CレーンがBレーンと並列に作業する場合、未確定のLean declaration名やstatementを独断で固定しない。依存をhandoffへ記録する。

## 8. 並列自律作業フロー

通常は人間への逐次確認なしに以下を進めてよい。

1. 最新main / Issue / PR / CIを再確認
2. `docs/LANE_STATUS.md` と自分のlane handoffからassigned focused Issueを確認
3. ownership・dependency・shared hotspotを確認
4. 自分のlane deliverableを実装または調査
5. lane handoffを更新
6. 必要な検証を実行
7. branchへcommit / push
8. PRを作成
9. CI failureがあれば担当範囲内で修正、または適切なlaneへroute
10. CIがgreenで、停止条件に該当せず、PRの内容がlane deliverableのDone条件を満たすことを再確認
11. AI自身でPRをmerge
12. 最新mainを再確認し、handoff / `docs/LANE_STATUS.md` / progressのdriftを修正
13. 同じlaneに安全な次のassigned workがある場合のみ続行

AIは通常、人間レビューを待たずにPRをmergeしてよい。
ただし、`BLOCKED:` 停止条件、著作権判断、statementの曖昧性、仮定変更、数学的整合性に疑義がある場合はmergeしてはならない。
CI greenだけを理由に数学的レビューを省略せず、PR本文・diff・依存・statement integrityをAI自身で再監査してからmergeする。

### 8.1 レーン別の境界

- A: 設計・Issue分割・owner・dependency。B/C/D/Eの実装を奪わない。
- B: Lean formalization。CのBlueprintを編集しない。
- C: Blueprint / exposition。BのLean proofを編集しない。
- D: mathlib research。完成proofを奪わない。
- E: integration / CI。通常は新規数学proofを書かない。

詳細は `docs/AI_WORKFLOW.md` と `docs/lanes/*.md` に従う。

## 9. 停止条件

以下では作業を勝手に解決せず、Issue/PRに根拠を残して停止する。

- `BLOCKED: STATEMENT-AMBIGUOUS` — 主張の形式化が複数あり選べない
- `BLOCKED: ASSUMPTION-CHANGE` — 仮定の追加・削除・変更が必要
- `BLOCKED: POSSIBLE-SOURCE-ERROR` — 書籍の記述に誤り・脱落の疑い
- `BLOCKED: PRIOR-FORMALIZATION-ERROR` — 既存の前提形式化に数学的問題
- `BLOCKED: TARGET-THEOREM-ONLY` — 対象そのものの既存定理以外で進めない
- `BLOCKED: MAJOR-PROOF-DEVIATION` — セールと大きく異なる強力な数学が必要
- `BLOCKED: SOURCE-QUOTE-REVIEW` — 直接引用等の公開判断が必要
- `BLOCKED: INFRASTRUCTURE` — CI / toolchain / dependency問題で数学作業を安全に進められない
- `BLOCKED: OWNERSHIP-CONFLICT` — 同じdeliverableに別のactive owner / PRがある
- `BLOCKED: CROSS-LANE-STATEMENT-DRIFT` — LeanとBlueprint等でstatement解釈が一致しない

ownership conflictやshared hotspot競合を見つけた場合は仕事を奪わず、Aへrouteする。

## 10. Definition of Done

### 10.1 Lane PR のDone

レーン単位のPRは、担当deliverableだけを完成させてmergeしてよい。最低限:

- focused Issueとlane ownerが明確
- 担当成果物が自己完結している
- statement integrityを壊していない
- 他レーン所有ファイルを不必要に変更していない
- 必要なbuild / policy checksが成功
- handoffが更新されている
- cross-lane dependencyがPR本文に明記されている

### 10.2 数学的slice全体のDone

1つの数学的sliceを `FORMALIZATION_PROGRESS.md` でcompleteにするには最低限次を満たす。

- statementの数学的意味が記録されている
- Blueprint nodeがある
- 独立した自然言語説明がある
- Lean declarationが対応している
- proofに `sorry` / `admit` / 新規穴埋めaxiomがない
- `lake build` 成功
- `lake exe vbp build` 成功
- policy check成功
- 進捗ファイル更新
- 必要なPR本文に数学的方針・mathlib依存・セールとの差異が記録されている
- EまたはAがcross-layer整合を確認している

Bだけ、Cだけが先にmergeされても、その時点ではslice全体をcompleteにしない。

## 11. PRの粒度

原則として「1つの小節」「密接に依存する1つの定理群」または「その中の1つのlane deliverable」を1 PRとする。

巨大PRにしない。下流の定理に進む前に、上流の数学的statementが安定していることを確認する。

shared hotspotだけをまとめるinfra/integration PRは数学PRから分離する。

## 12. 初期実験の範囲

最初は以下のみで自律運用を評価する。

1. 有限体
2. 有限体の乗法群
3. 有限体上のべき乗和
4. Chevalleyの定理周辺

この範囲を終えるまでは、プロジェクト全体を一気に自動生成しない。問題を発見したら先に本規約・lane workflowを改善する。
