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

### 1.1 Single-instruction run budget

ユーザーが「続けて」「作業を続けて」「形式化を続けて」「長めに」など、現在のACTIVE itemの継続を依頼した場合、1回の返答内で短い確認だけで止めず、プラットフォームと安全性が許す範囲で連続作業します。

標準目安:

- 明示的な短時間指定がない通常の継続依頼では、原則として最大25分間を1 runの作業予算として扱う。
- 25分の作業予算はバックグラウンド実行を意味しない。実際の応答内で、設計・実装・docs同期・Blueprint同期・CI確認・self-reviewのうち安全に進められるものを連続して行う。
- 実装系のrunでは、単に1 commitを作っただけ、またはCIがpendingになっただけでは原則終了しない。CI待ちの間に、同じACTIVE item内のread-only review、次補題の設計、Blueprint/docs同期、PR本文更新、差分自己確認を進める。
- ユーザーが「10分くらい」「25分上限まで」など時間を明示した場合、その範囲を優先する。ユーザーが25分より短い時間を指定した場合は、その短い指定に従う。
- 複数commitを作る場合も、各commitは同じACTIVE itemに限定し、最後にlatest headのCIまたは少なくとも起動状況を確認する。
- 失敗したCIの原因を読まずに、同じ不確かな変更を積み増ししない。CI失敗が見えたら、まずログを確認して修正する。

25分run中に進めてよい作業例:

- Lean補題を追加し、root importやBlueprintを同期する。
- CI pending中にPR本文、progress docs、next-step docsを更新する。
- 直前のgreen headと最新headの差分を確認し、危険な仮定強化やsource逸脱がないか自己レビューする。
- 次の補題のstatementだけを安全に切り出す。
- 既存APIを調査して、次回の証明再開地点をdocsへ明記する。

25分runでも、次のstop conditionを超えないこと:

- Lean/Blueprint/CI failureの原因確認と修正が必要になった。
- 数学的statementが原典から安全に復元できない。
- source/copyright policy上、本文・画像の過度な再現になりそう。
- GitHub write権限、merge conflict、branch state不整合、tool安全性拒否が出た。
- context/time上限が近く、未保存の変更や未確認の主張が残る。
- ユーザーが明示的に停止・短時間作業を指示した。

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

手動チャットと定期実行は同じACTIVE itemを共有します。片方の実行履歴をもう片方が暗黙に引き継がず、毎回live GitHub stateから復元します。

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

### 6.1 GitHub write path / safety-check resilience

GitHubへ変更を永続化するときは、利用可能ならChatGPTのGitHub連携が提供する構造化操作（branch、file create/update、PR、merge等）を優先します。書き込みを通すためにtoken、SSH key、Secrets、repository settings、Actions permissions、branch protection、ruleset、security settingsへ触れません。

特定のwriteがChatGPT/OpenAI側の安全性チェック、権限制約、UI制約等で拒否された場合:

1. 迂回・権限弱体化・別の危険な書き込み経路を試さない。
2. その拒否だけを理由に別work itemへ移らない。
3. 同じACTIVE itemで可能なread-only CI解析、source/statement/dependency/mathlib確認、proof/Blueprint patch設計、self-reviewを続ける。
4. 永続化されていない変更をcommit/push/merge済みと扱わない。
5. run終了時に pending write のbranch/path/意図した変更/再開地点を明示する。
6. 次回の手動チャットまたは定期実行でlive GitHubを再確認し、通常の構造化writeを再試行する。

write不能のため同じACTIVE itemについてもそれ以上安全に進められない場合は、そのrunだけ終了します。これは自動的にwork itemの数学的BLOCKEDやPARKEDを意味しません。

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

単発のGitHub write拒否は、それだけではhard blockerとして扱いません。同じACTIVE itemで安全な作業が残っていれば継続し、残っていなければpending writeと再開地点を残してそのrunを終了します。