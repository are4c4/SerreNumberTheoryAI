# SerreNumberTheoryAI

AI-assisted Lean 4 formalization and independent exposition of the mathematics in J.-P. Serre's **『数論講義』**.

## 目的

このリポジトリは、セール『数論講義』日本語版を**参考資料**として用い、各節の数学的内容を次の3層で同期して構築する公開実験です。

1. **数学的解釈・自然言語説明** — 定義、主張、証明アイデアを独立した文章で整理する。
2. **Blueprint** — 定義・補題・命題・定理の依存関係と形式化状況を可視化する。
3. **Lean 4 formalization** — statement と proof を Lean 4 + mathlib で機械検証可能にする。

目標は、単に mathlib に既存の完成済み定理を呼び出すことではありません。mathlib を基礎インフラとして利用しながら、可能な限りセールの数学的な証明方針を再構成します。

## 人間版リポジトリとの分離

`are4c4/SerreNumberTheoryBlueprint` は人間が自力で理解しながら進める本命プロジェクトです。本リポジトリはAIによる独立実験であり、**本命リポジトリの形式化コードや証明を解答源として使用しません**。

AIが数学的作業を行う際は、本命リポジトリの `Formalization` / `Blueprint` の内容を参照・模倣・コピーしないことを原則とします。Lean・Verso・CIなどの一般的な開発インフラについては、必要に応じて互換性を合わせることがあります。

## 参考資料と公開方針

主な参考資料は日本語版セール『数論講義』です。本の文章を公開することが目的ではありません。

Public GitHub には原則として次を置きません。

- 本文の転載や長い直接引用
- 本文の一文ずつの言い換え・逐語的な要約
- ページ画像、スキャン、スクリーンショット
- 図表のそのままの複製

代わりに、数学的内容を理解した後、定義・主張・依存関係・証明戦略として分解し、**独立した説明とLeanコードを新規に構成**します。詳細は [`docs/SOURCE_AND_COPYRIGHT_POLICY.md`](docs/SOURCE_AND_COPYRIGHT_POLICY.md) を参照してください。

## mathlib の利用原則

積極的に利用するもの:

- `Finset`, `Fintype`, 集合・自然数・整数の基本API
- 群・環・体・準同型・同型の一般論
- 多項式などの標準的な基礎API
- 一般的な代数補題

慎重に利用するもの:

- その節の核心に非常に近い強力な定理
- 対象定理と実質的に同値、またはそれを直接含意する完成済み定理

対象定理そのものを既存定理で `exact` するだけの実装は、原則として本プロジェクトの「形式化完了」とみなしません。

## 自律作業の基本フロー

```text
日本語版セールを参照
        ↓
数学的内容を解釈
        ↓
Blueprint / 独立した自然言語説明
        ↓
Lean statement
        ↓
Lean proof
        ↓
lake build / Blueprint build / policy checks
        ↓
Pull Request
        ↓
人間レビュー
```

初期段階ではAIはbranch・commit・PR作成・CI修正まで自律的に進めますが、**formalization PRのmergeは人間の明示的な確認を待ちます**。

## 進捗

[`FORMALIZATION_PROGRESS.md`](FORMALIZATION_PROGRESS.md) を source of truth とします。

最初の実験範囲は次の4段階です。

1. 有限体
2. 有限体の乗法群
3. 有限体上のべき乗和
4. Chevalley の定理周辺

この範囲でAIの statement 設計、mathlib利用、Blueprint生成、自然言語説明、停止条件を検証し、必要に応じて作業規約を改善します。

## ローカルでの確認

```bash
lake update
lake exe cache get
lake build
lake exe vbp build
```

BlueprintのHTML出力は通常 `_out/site/html-multi` に生成されます。

## AI作業規約

AIエージェントは作業開始前に必ず [`AGENTS.md`](AGENTS.md) を読み、その停止条件・独立性ルール・著作物取扱いルールに従います。

## Reference

J.-P. Serre, 『数論講義』, 弥永健一訳, 岩波書店.

このリポジトリは書籍本文の再配布物ではなく、独立した形式化・解説プロジェクトです。
