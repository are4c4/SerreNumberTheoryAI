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

## 複数AIチャットの並列運用

複数のChatGPT chatを同時に動かしますが、職種別pipelineにはしません。チャット履歴そのものは共有状態にせず、**GitHubのmain・branch・Issue・PR・CI・queue文書をsource of truth**にします。

現在の構成:

| Lane | Role |
| --- | --- |
| A | Scheduler / Design — dependency graph、queue health、曖昧なstatement、ownership conflict |
| B | End-to-end Formalizer |
| C | End-to-end Formalizer |
| D | End-to-end Formalizer |
| E | End-to-end Formalizer |

B/C/D/Eは同等workerです。work itemをclaimしたworkerが、そのitemについてsource解釈、mathlib調査、Lean、Blueprint、自然言語説明、CI、mergeまで可能な限りend-to-endで担当します。

共有状態:

- [`docs/AI_WORKFLOW.md`](docs/AI_WORKFLOW.md) — worker-pool / work-stealing / stacked-branch protocol
- [`docs/WORK_QUEUE.md`](docs/WORK_QUEUE.md) — dependency-aware executable queue
- [`docs/LANE_STATUS.md`](docs/LANE_STATUS.md) — workerの現在地
- `docs/lanes/*.md` — 各chatの短いhandoff
- [`FORMALIZATION_PROGRESS.md`](FORMALIZATION_PROGRESS.md) — 数学的進捗

新しいchatで `Bレーンとして作業を続けて` とだけ指示しても、Bはlive GitHubとqueueを復元し、active workがなければcanonical branch lockで最高priorityの安全なworkをclaimします。

### Work stealing

PR作成、CI pending、1 Issue完了、1 item固有blockerはchat停止条件ではありません。実行時間が残っていれば次の `READY` / `STACKABLE` / `PREFLIGHT` itemへ移ります。

1 workerの未merge実装PRは原則2本までとし、それ以上は増やさずCI修正・preflight・dependency整理を行います。

### Dependency first

並列化は章番号ではなく実際の数学的依存関係に従います。後続節が前節の定理を使うなら、そのdependencyをqueueへ明記し、上流が安定するまでdownstream proofを推測しません。

一方、上流PRが未mergeでもstatementとLean interfaceが十分安定し `STACK-READY` と明示された場合は、その特定head SHAをbaseにstacked branchを作って下流を進められます。upstream merge後はmainへ戻して再検証します。

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
A: dependency graph / queue を先回りして整備
                    │
          ┌─────────┼─────────┬─────────┐
          ↓         ↓         ↓         ↓
          B         C         D         E
        formalizer formalizer formalizer formalizer
          │         │         │         │
          └──── READY / STACKABLE / PREFLIGHT ────┘
                    │
               work stealing
                    │
      source → mathlib → Lean → Blueprint → CI → merge
```

各formalizerはbranch・commit・PR作成・CI修正まで自律的に進めます。`AGENTS.md` の停止条件に該当せず、担当workの自己レビューとCIが通っていれば、**AI自身でPRをmergeしてよく、人間レビューを通常は待ちません**。

statementの曖昧性、仮定変更、著作権判断、重大な証明方針の逸脱などはwork item単位で `BLOCKED:` とします。別の安全なqueue workがある限りworker chat自体は継続します。

## 進捗

[`FORMALIZATION_PROGRESS.md`](FORMALIZATION_PROGRESS.md) を数学的進捗の source of truth とします。

最初の実験範囲は次の4段階です。

1. 有限体
2. 有限体の乗法群
3. 有限体上のべき乗和
4. Chevalley の定理周辺

この範囲でAIの statement 設計、mathlib利用、Blueprint生成、自然言語説明、dependency-aware parallelism、work stealing、stacked branch、停止条件を検証し、必要に応じて作業規約を改善します。

## ローカルでの確認

```bash
lake update
lake exe cache get
lake build
lake exe vbp build
```

BlueprintのHTML出力は通常 `_out/site/html-multi` に生成されます。

## AI作業規約

AIエージェントは作業開始前に必ず [`AGENTS.md`](AGENTS.md) を読み、[`docs/AI_WORKFLOW.md`](docs/AI_WORKFLOW.md)、[`docs/WORK_QUEUE.md`](docs/WORK_QUEUE.md)、live GitHub state、自分のhandoffを確認してから作業します。

## Reference

J.-P. Serre, 『数論講義』, 弥永健一訳, 岩波書店.

このリポジトリは書籍本文の再配布物ではなく、独立した形式化・解説プロジェクトです。
