# AGENTS.md

このファイルは SerreNumberTheoryAI で作業するAIエージェントの最上位ルールです。形式化・Blueprint・自然言語説明・mathlib調査・CI・GitHub運用のすべてに適用します。

## 0. プロジェクトの目的

日本語版セール『数論講義』を参考資料として数学的内容を理解し、以下を同期して独立に構成する。

- 人間向けの自然言語説明
- Verso Blueprint による依存関係・進捗
- Lean 4 + mathlib による機械検証可能な形式化

「Leanが通ること」だけでなく、「セールで扱われている数学を忠実に形式化すること」を優先する。

## 1. Source of truth

作業開始時に必ず次を確認する。

1. AGENTS.md
2. docs/AI_WORKFLOW.md
3. docs/ACTIVE_WORK.md
4. docs/WORK_QUEUE.md
5. FORMALIZATION_PROGRESS.md
6. docs/SOURCE_AND_COPYRIGHT_POLICY.md
7. 最新 main
8. live branch / open Issue / PR / CI
9. 対象節に対応する本リポジトリ内の既存 Blueprint / formalization

GitHub上の main・branch・Issue・PR・CI が共有状態であり、チャット履歴だけに存在する情報は source of truth ではない。文書とlive GitHub stateが矛盾する場合はlive stateを優先し、その後文書を同期する。

## 2. 単一レーン運用 — hard rule

2026-09-26以降、このリポジトリは **1レーンの直列運用** とする。

1つのAI作業レーンが、1つの数学的work itemについて次をend-to-endで担当する。

1. 原典範囲の確認
2. 数学的解釈・statement設計
3. dependency確認
4. mathlib API調査
5. Lean statement / proof
6. 独立した自然言語説明
7. Blueprint / uses / lean linkage
8. policy check / lake build / vbp build
9. PR作成・CI修正
10. 自己レビュー
11. merge
12. progress / queue / active-work同期

### 2.1 One active implementation PR

- activeな数学的実装PRは原則1本だけとする。
- active PRがmergeまたは明示的にpark/closeされる前に、別の数学的実装branch/PRを開始しない。
- CI待ちを理由に別の実装workを開始しない。同じwork itemの説明改善、レビュー、テスト、dependency確認、CI解析を行う。
- 将来workのread-only preflightは許可するが、別のproof実装branchを並行作成しない。
- A/B/C/D/Eなどのworker ownershipやwork stealingは現行運用では使用しない。

### 2.2 Stacked implementation停止

新しいstacked branchによるdownstream proof実装は行わない。upstreamが必要なら、upstreamをmainへ統合してからdownstreamへ進む。

旧並列運用で作られたstacked branch / PRは履歴として保存してよいが、再開時はlatest mainを基準に再検証し、古い STACK-READY をそのまま信頼しない。

### 2.3 Legacy multi-lane artifacts

旧A/B/C/D/E運用のbranch、Issue本文、PR本文に残るowner/lane表記は履歴情報であり、現在のownershipを意味しない。現行のactive workは docs/ACTIVE_WORK.md だけで管理する。

## 3. 人間版リポジトリからの独立性 — hard rule

are4c4/SerreNumberTheoryBlueprint は人間が自力で進める別プロジェクトである。

数学的な作業では、同リポジトリの次の内容を解答源として参照してはならない。

- Formalization のLeanコード
- Blueprint の数学的説明・証明
- theorem / lemma の具体的な証明構成

そこからコード・証明・補題分割・文章をコピー、翻案、模倣しない。

Lean toolchain、Verso、CI等の一般的インフラ互換性を合わせる必要がある場合に限り、設定ファイルの構成を比較してよい。その場合も数学的内容は持ち込まない。

## 4. 書籍本文の取扱い

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

直接引用が本当に必要だと判断した場合はcommitせず BLOCKED: SOURCE-QUOTE-REVIEW として人間確認を求める。

## 5. 数学的忠実性

### 5.1 statement integrity

以下は禁止する。

- 証明を通すために仮定を不必要に強くする
- 結論を弱める
- 定義を都合よく変更する
- 対象定理と異なる定理を同じ名前で登録する

書籍の主張に複数の自然な形式化があり、一意に決められない場合は停止し、Issue/PRへ根拠を記録する。

### 5.2 証明方針の優先順位

1. セールとほぼ同じ数学的アイデア
2. 同程度に基本的で透明な別証明
3. より一般的なmathlib定理を組み合わせる証明
4. 対象定理そのもの、または実質同値な完成済み定理を直接利用

4は原則として正式な完了形に採用しない。どうしても必要なら BLOCKED: TARGET-THEOREM-ONLY とする。

### 5.3 Dependency integrity

- 章番号だけでなく実際に使う数学的依存関係を記録する。
- downstreamがupstream theoremを必要とするなら、upstreamをmainへ統合してから進む。
- dependencyが不明なら、現在のactive item内でpreflightして確認する。
- 不安定なupstream interfaceを推測してdownstream proofを書かない。

## 6. mathlib利用方針

積極的に利用してよい:

- Finset, Fintype, Set
- 自然数・整数・有理数等の基本API
- 群・環・体の一般論
- 準同型・同型・部分構造の一般論
- 多項式・有限和等の標準API
- 一般的な代数・組合せ補題

慎重に利用する:

- 対象節の核心に近い固有定理
- 対象定理をほぼ自動的に導く高度な定理

PR本文には主要なmathlib依存と、意図的に使用しなかった「強すぎる」定理を記録する。

## 7. 禁止された証明穴

formalization sourceでは以下を禁止する。

- sorry
- admit
- 証明穴を埋めるための新規 axiom

探索用の #check / example は完成PRでは不要なら削除する。

## 8. Blueprint / 自然言語説明

各主要 Definition / Lemma / Proposition / Theorem には可能な限り以下を持たせる。

- 一意なBlueprint id
- 独立した数学的説明
- lean によるLean declarationとの対応
- uses による主要依存
- 必要なら独立したproof explanation

Lean proofと自然言語proofの数学的戦略が大きく異なる場合、Blueprintに差異を明記する。

## 9. 単一レーンの自律作業フロー

通常は人間への逐次確認なしに次を進めてよい。

1. startup docsとlive GitHubを確認する。
2. docs/ACTIVE_WORK.md のactive itemを復元する。
3. latest mainとの差分・open PR・CIを確認する。
4. source / statement / dependency / mathlibを確認する。
5. LeanとBlueprintを同じwork item内で実装する。
6. policy / build / vbp buildを通す。
7. PRを作成または更新する。
8. CI failureを修正する。
9. diff、statement integrity、dependency、copyright、near-target theorem利用を自己レビューする。
10. greenかつblockerなしならAI自身でmergeしてよい。
11. latest mainを再取得し、progress / queue / active workを同期する。
12. その後にだけ次のwork itemを選ぶ。

## 10. Blocker semantics

以下では勝手に解釈を変えず停止する。

- BLOCKED: STATEMENT-AMBIGUOUS
- BLOCKED: ASSUMPTION-CHANGE
- BLOCKED: POSSIBLE-SOURCE-ERROR
- BLOCKED: PRIOR-FORMALIZATION-ERROR
- BLOCKED: TARGET-THEOREM-ONLY
- BLOCKED: MAJOR-PROOF-DEVIATION
- BLOCKED: SOURCE-QUOTE-REVIEW
- BLOCKED: INFRASTRUCTURE
- BLOCKED: CROSS-LAYER-STATEMENT-DRIFT

blockerで別itemへ移る必要がある場合は、現在のPRを明示的にpark/closeし、docs/ACTIVE_WORK.md と docs/WORK_QUEUE.md を同期してから移る。複数のactive implementationを残したままwork stealingしない。

## 11. Definition of Done

1つのformalization work itemをcompleteにするには最低限次を満たす。

- statementの数学的意味が記録されている
- dependencyが記録されている
- independent natural-language explanationがある
- Blueprint node / dependencyがある
- Lean declarationが対応している
- Lean↔Blueprint linkageがある
- proofに sorry / admit / 新規穴埋めaxiomがない
- bash scripts/check_formalization_policy.sh 成功
- lake build 成功
- lake exe vbp build 成功
- PR-head CI成功
- FORMALIZATION_PROGRESS.md が同期されている
- docs/WORK_QUEUE.md と docs/ACTIVE_WORK.md が同期されている
- PR本文に数学的方針・mathlib依存・避けた強い定理・セールとの差異を記載
- self-review後にmainへ統合済み

## 12. PRの粒度

原則として「1つの小節」「密接に依存する1つの定理群」またはdependency-safeな1つのend-to-end sub-sliceを1 PRとする。

同じtargetのLean / Blueprint / mathlib調査 / integrationを別PRへ職種分割しない。

## 13. 現行運用

- 旧A/B/C/D/Eレーン運用は終了。
- 新しい自動スケジュールを前提にしない。
- 1つのチャット/作業レーンが、active itemをmergeまで完了してから次へ進む。
