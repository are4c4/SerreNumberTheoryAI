# AI_WORKFLOW.md

この文書は SerreNumberTheoryAI の単一レーン直列ワークフローを定義します。

2026-09-26より、複数ChatGPTチャットの並列worker pool、A/B/C/D/Eレーン、work stealing、stacked implementationを廃止しました。競合・古いbase・Lean/Blueprintの同期ずれを避けるため、1つのAI作業レーンが1 work itemをmergeまでend-to-endで完了してから次へ進みます。

## 1. Core model

単一レーンは次の工程をすべて担当します。

~~~text
日本語版『数論講義』
        ↓
source boundary / 数学的解釈
        ↓
statement / dependency 設計
        ↓
mathlib audit
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
progress同期
        ↓
次のwork item
~~~

設計・形式化・Blueprint・mathlib調査・integrationは別workerへ分けず、同じwork itemの工程として直列に処理します。

## 2. Source of truth

作業開始時の確認順:

1. AGENTS.md
2. docs/AI_WORKFLOW.md
3. docs/ACTIVE_WORK.md
4. docs/WORK_QUEUE.md
5. FORMALIZATION_PROGRESS.md
6. docs/SOURCE_AND_COPYRIGHT_POLICY.md
7. latest main
8. live branch / Issue / PR / CI
9. 対象の既存Formalization / Blueprint

live GitHub stateが文書より新しい場合はlive stateを優先し、そのrun内で文書を同期します。

## 3. Work states

- ACTIVE — 現在唯一の実装対象。
- READY — active完了後に着手可能。
- PREFLIGHT — source/dependency/API調査候補。並行proof実装はしない。
- WAITING — upstream main統合待ち。
- BLOCKED — hard blockerあり。
- PARKED — 旧branch/PRまたは明示的に中断したwork。activeではない。
- DONE — mainへ統合され、cross-layer artifactと検証が揃っている。

docs/ACTIVE_WORK.md に ACTIVE は常に0または1件だけ記録します。

## 4. One active implementation PR

数学的実装PRは原則1本だけopen-activeにします。

- active PRがある間は別の実装PRを作らない。
- CI pending中も別workへ移らない。
- 同じactive itemのCI解析、review、文書同期、proof cleanup、Blueprint確認を行う。
- hard blockerで別workへ移るなら、現在のPRをpark/closeし、ACTIVE_WORKとqueueを同期してから次へ進む。
- future itemのread-only調査は可能だが、proof commitや別branch ownershipには進めない。

## 5. Dependency rule

dependencyは実際に使う数学的結果で管理します。

downstreamがupstreamを必要とする場合:

1. upstreamを現在のactive itemとして完成させる。
2. mainへmergeする。
3. latest mainを取得する。
4. downstreamを新しいactive itemとして開始する。

新しいstacked implementationは行いません。旧stacked branchを再開する場合も、最新mainへ適合させてから通常のmain-based PRとして再開します。

## 6. Active work lifecycle

1. ACTIVE_WORK.md とlive GitHubを確認。
2. active branch/PRを復元。
3. source boundaryとstatementを再確認。
4. mathlib near-target theoremを監査。
5. Lean statement/proofを実装。
6. Blueprintと独立説明を同期。
7. bash scripts/check_formalization_policy.sh。
8. lake build。
9. lake exe vbp build。
10. PRを作成/更新。
11. CI failureを修正。
12. diff / statement / dependency / source policyを自己レビュー。
13. greenならAIがmergeしてよい。
14. main上で必要なら最終確認。
15. progress / queue / active workを更新。
16. 次のworkを選ぶ。

## 7. Self-review gate

CI greenだけではmergeしません。最低限次を再確認します。

- statementが原典の対象と一致する。
- 仮定を強めていない。
- 結論を弱めていない。
- 対象そのものに近すぎるmathlib定理で閉じていない。
- Lean proofとBlueprint説明が同じ数学を述べる。
- source prose/imageを公開していない。
- sorry / admit / proof-hole axiomがない。
- dependencyはmain上で安定している。

## 8. Legacy multi-lane work

2026-09-26以前のA/B/C/D/E owner表記、canonical branch lock、STACK-READY、work-stealing情報は履歴としてのみ扱います。

旧branchに有用なcommitがある場合:

1. branch/PRをactiveとみなさない。
2. そのworkが順番でactiveになった時点でlatest mainを確認。
3. 必要なcommitをrebase/cherry-pick/再実装してmain-based branchへ整理。
4. policy/build/CIを最初から再実行。
5. 古いstack promiseやlane handoffは根拠にしない。

## 9. Shared documents

- docs/ACTIVE_WORK.md — 現在唯一のactive workとparked legacy PR。
- docs/WORK_QUEUE.md — dependency-awareな直列backlog。
- FORMALIZATION_PROGRESS.md — 数学的進捗。
- docs/SOURCE_AND_COPYRIGHT_POLICY.md — 公開/出典ルール。

旧 docs/LANE_STATUS.md と docs/lanes/* は使用しません。

## 10. Stop conditions

hard blockerは AGENTS.md に従います。

blockerを発見したら、Issue/PRへ理由を記録し、unsafeな推測をしません。別workへ移る場合でも、現在のactive workを明示的にparkしてから移ります。
