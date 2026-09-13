# AGENTS.md

このファイルは `SerreNumberTheoryAI` で作業するAIエージェントの最上位ルールです。形式化・Blueprint・自然言語説明・CI・GitHub運用のすべてに適用します。

## 0. プロジェクトの目的

日本語版セール『数論講義』を参考資料として数学的内容を理解し、以下を同期して独立に構成する。

- 人間向けの自然言語説明
- Verso Blueprint による依存関係・進捗
- Lean 4 + mathlib による機械検証可能な形式化

「Leanが通ること」だけでなく、「セールで扱われている数学を忠実に形式化すること」を優先する。

## 1. Source of truth

作業開始時に必ず確認する。

1. `AGENTS.md`
2. `FORMALIZATION_PROGRESS.md`
3. `docs/SOURCE_AND_COPYRIGHT_POLICY.md`
4. 最新 `main`
5. open Issue / PR / CI
6. 対象節に対応する本リポジトリ内の既存Blueprint / formalization

既存のactive PRと重複する作業を開始しない。

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

書籍の主張に複数の自然な形式化があり、一意に決められない場合は停止する。

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

## 8. 自律作業フロー

通常は人間への逐次確認なしに以下を進めてよい。

1. 最新main / Issue / PR / CIの再確認
2. `FORMALIZATION_PROGRESS.md` から次の安全な対象を選ぶ
3. 対象の数学的statementを整理する
4. mathlib APIを調査する
5. Blueprintのノードと自然言語説明を設計する
6. Lean statement / proofを実装する
7. policy checkを通す
8. `lake build`
9. `lake exe vbp build`
10. branchへcommit / push
11. PRを作成
12. CI failureがあればログを読み修正
13. `FORMALIZATION_PROGRESS.md` を更新
14. CIがgreenで、停止条件に該当せず、PRの内容がDefinition of Doneを満たすことを再確認する
15. AI自身でPRをmergeする
16. 最新mainを再確認して次の安全なsliceへ進む

AIは通常、人間レビューを待たずにformalization PRをmergeしてよい。
ただし、`BLOCKED:` 停止条件、著作権判断、statementの曖昧性、仮定変更、数学的整合性に疑義がある場合はmergeしてはならない。
CI greenだけを理由に数学的レビューを省略せず、PR本文・diff・依存・statement integrityをAI自身で再監査してからmergeする。

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

## 10. Definition of Done

1つの形式化sliceは最低限次を満たす。

- statementの数学的意味が記録されている
- Blueprint nodeがある
- 独立した自然言語説明がある
- Lean declarationが対応している
- proofに `sorry` / `admit` / 新規穴埋めaxiomがない
- `lake build` 成功
- `lake exe vbp build` 成功
- policy check成功
- 進捗ファイル更新
- PR本文に数学的方針・mathlib依存・セールとの差異を記載

## 11. PRの粒度

原則として「1つの小節」または「密接に依存する1つの定理群」を1 PRとする。

巨大PRにしない。下流の定理に進む前に、上流の数学的statementが安定していることを確認する。

## 12. 初期実験の範囲

最初は以下のみで自律運用を評価する。

1. 有限体
2. 有限体の乗法群
3. 有限体上のべき乗和
4. Chevalleyの定理周辺

この範囲を終えるまでは、プロジェクト全体を一気に自動生成しない。問題を発見したら先に本規約を改善する。
