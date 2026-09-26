# SerreNumberTheoryAI

AI-assisted Lean 4 formalization and independent exposition of the mathematics in J.-P. Serre's **『数論講義』**.

## 目的

このリポジトリは、セール『数論講義』日本語版を参考資料として用い、各節の数学的内容を次の3層で同期して構築する公開実験です。

1. 数学的解釈・自然言語説明
2. Blueprint
3. Lean 4 formalization

目標は、単にmathlibに既存の完成済み定理を呼び出すことではありません。mathlibを基礎インフラとして利用しながら、可能な限りセールの数学的な証明方針を再構成します。

## 人間版リポジトリとの分離

are4c4/SerreNumberTheoryBlueprint は人間が自力で理解しながら進める本命プロジェクトです。本リポジトリはAIによる独立実験であり、本命リポジトリの形式化コードや証明を解答源として使用しません。

## 参考資料と公開方針

主な参考資料は日本語版セール『数論講義』です。本の文章を公開することが目的ではありません。

Public GitHubには原則として次を置きません。

- 本文の転載や長い直接引用
- 本文の一文ずつの言い換え・逐語的な要約
- ページ画像、スキャン、スクリーンショット
- 図表のそのままの複製

代わりに、数学的内容を理解した後、定義・主張・依存関係・証明戦略として分解し、独立した説明とLeanコードを新規に構成します。詳細は docs/SOURCE_AND_COPYRIGHT_POLICY.md を参照してください。

## 単一レーン運用

2026-09-26より、複数AIチャットのA/B/C/D/E並列運用を終了し、**1レーンの直列運用**へ移行しました。

1つのAI作業レーンが、現在のwork itemについて次をすべて担当します。

~~~text
source確認
  ↓
数学的解釈・statement設計
  ↓
dependency / mathlib調査
  ↓
Lean statement / proof
  ↓
独立した自然言語説明
  ↓
Blueprint / Lean linkage
  ↓
policy / build / CI
  ↓
self-review
  ↓
merge
  ↓
次のwork item
~~~

重要な運用ルール:

- activeな数学的実装PRは原則1本だけ。
- active PRがmergeまたはparkされる前に別の実装PRを開始しない。
- CI待ち中に別workを実装しない。
- 新しいstacked branchによる並行downstream実装は行わない。
- 旧並列運用のbranch/PRは必要なら保存するが、再開時はlatest main上で再検証する。
- CI green後もstatement・dependency・mathlib依存・Blueprint同期を自己レビューしてからmergeする。
- hard blockerがなければAI自身でmergeしてよく、人間レビューを通常は待たない。

運用文書:

- docs/AI_WORKFLOW.md — 単一レーンの直列workflow
- docs/ACTIVE_WORK.md — 現在のactive work / parked legacy work
- docs/WORK_QUEUE.md — dependency-awareな直列backlog
- FORMALIZATION_PROGRESS.md — 数学的進捗
- AGENTS.md — AI作業規約

## mathlib の利用原則

積極的に利用するもの:

- Finset, Fintype, 集合・自然数・整数の基本API
- 群・環・体・準同型・同型の一般論
- 多項式などの標準的な基礎API
- 一般的な代数補題

慎重に利用するもの:

- その節の核心に非常に近い強力な定理
- 対象定理と実質的に同値、またはそれを直接含意する完成済み定理

対象定理そのものを既存定理で閉じるだけの実装は、原則として本プロジェクトの「形式化完了」とみなしません。

## 進捗

FORMALIZATION_PROGRESS.md を数学的進捗のsource of truthとします。

各work itemは、Interpretation / Explanation / Blueprint / Lean statement / Lean proof / CIが揃い、mainへ統合されて初めて完了です。

## ローカルでの確認

~~~bash
lake update
lake exe cache get
lake build
lake exe vbp build
~~~

BlueprintのHTML出力は通常 _out/site/html-multi に生成されます。

## AI作業規約

AIエージェントは作業開始前に必ず AGENTS.md を読み、docs/AI_WORKFLOW.md、docs/ACTIVE_WORK.md、docs/WORK_QUEUE.md、live GitHub stateを確認します。

## Reference

J.-P. Serre, 『数論講義』, 弥永健一訳, 岩波書店.

このリポジトリは書籍本文の再配布物ではなく、独立した形式化・解説プロジェクトです。
