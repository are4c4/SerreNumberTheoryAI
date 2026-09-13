# AI_WORKFLOW.md

この文書は、複数のChatGPTチャットを同時に動かすための協調プロトコルです。会話履歴ではなくGitHubを共有状態とし、各チャットは独立したAIワーカーとして振る舞います。

## 1. 原則

- `main` とGitHub Issue / PR / CIが共有状態の source of truth である。
- チャット内だけに存在する決定は、他レーンから見えないため正式な決定ではない。
- 数学的対象は共通の target id / Issue で追跡し、成果物ごとにownerを一意にする。
- 同じファイル・同じ成果物を複数レーンが同時に編集しない。
- `AGENTS.md` の数学的忠実性・著作権・独立性・停止条件は、レーン分割より常に優先する。

## 2. 初期レーン

| Lane | 名称 | 主担当 | 通常触る範囲 |
| --- | --- | --- | --- |
| A | Design / Coordination | 全体設計、Issue分割、依存関係、ownership、進捗整合 | `docs/`, Issue本文、運用文書 |
| B | Lean Formalization | Lean statement / proof、Lean固有補助lemma | `SerreNumberTheoryAI/Formalization/**` |
| C | Blueprint / Exposition | Blueprint node、独立した自然言語説明、依存関係 | `SerreNumberTheoryAI/Blueprint/**` |
| D | Mathlib Research | API探索、既存定理の強さ判定、候補の比較 | Issueコメント、`docs/lanes/D_MATHLIB.md` |
| E | Integration / CI | build、policy、cross-layer整合、CI障害、統合監査 | CI、workflow、統合文書。数学実装は原則しない |

必要になればBを章・節単位で `B1`, `B2`, ... に分割できる。その場合も同じ成果物のownerは一つだけとする。

## 3. 作業開始時の共通読込順

各チャットは作業開始時に必ず次を確認する。

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. 自分の `docs/lanes/*.md`
5. `FORMALIZATION_PROGRESS.md`
6. 対象Issue / open PR / CI / 最新main
7. 対象に対応する既存コード

新しいチャットで「Bレーンとして作業を続けて」とだけ言われた場合も、この順序から現在地を復元する。

## 4. Ownership と並列化

### 4.1 Artifact ownership

同じ数学的targetに複数成果物があってもよいが、成果物単位のownerは一意にする。

例:

- target `S1.1.Theorem1(ii)`
  - Lean implementation: B
  - Blueprint / exposition: C
  - mathlib research: D
  - integration: E

BがLeanを実装中にCがBlueprintを作ることは可能。ただし、statement解釈が未確定ならAが先に解釈を固定する。BとCが別々の意味のstatementを採用してはならない。

### 4.2 Focused Issue

並列作業はfocused Issue単位で行う。Issueには最低限次を記録する。

- target id / 書籍上の位置
- lane owner
- deliverable
- dependencies
- allowed files / shared hotspotの有無
- branch
- blocker

広いparent Issueしかない場合、Aレーンがfocused Issueへ分割してから実装を開始する。

### 4.3 Branch naming

推奨:

- `design/<slug>-<issue>`
- `formalize/<slug>-<issue>`
- `blueprint/<slug>-<issue>`
- `research/<slug>-<issue>`
- `integration/<slug>-<issue>`
- `infra/<slug>-<issue>`

## 5. Shared hotspot

次は共有競合が起きやすいため、編集前にopen PRを確認する。

- `AGENTS.md`
- `README.md`
- `FORMALIZATION_PROGRESS.md`
- `docs/LANE_STATUS.md`
- `SerreNumberTheoryAI/Formalization.lean`
- `SerreNumberTheoryAI/Blueprint.lean`
- `lakefile.lean`
- `.github/workflows/**`

shared hotspotを触る必要がある場合は、PR本文に理由と競合確認結果を書く。可能ならAまたはEが統合変更を担当する。

## 6. Handoff protocol

各レーン文書は「次の新規チャットが30秒で再開できる状態」に保つ。

最低限、次を記録する。

- current focused Issue
- current branch / PR
- target id
- completed work
- next action
- blockers
- cross-lane dependencies
- shared hotspots touched / reserved

PRをmergeするときは、handoffがmerge後に古いactive PRを指し続けないようにする。必要ならmerge直後にAまたはEが小さなcoordination PRで `docs/LANE_STATUS.md` とlane handoffを最新mainへ同期する。チャットだけに進捗を書き残して終了しない。

## 7. PR と merge

レーン単位のPRは許可する。したがって、BのLean PRだけ、CのBlueprint PRだけが先にmergeされる場合がある。

ただし「数学的slice全体の完了」は以下が揃ってからEまたはAが確認する。

- Interpretation
- independent Explanation
- Blueprint
- Lean statement
- Lean proof
- policy check
- `lake build`
- `lake exe vbp build`

レーンPRは、自分のdeliverableが正しく、依存先mainが最新で、CIがgreenで、`AGENTS.md` の停止条件に該当しなければAI自身でmergeしてよい。

cross-layer不整合が残るPRはmergeしない。依存する別レーンPRが必要なら、PR本文に明示して待機する。

## 8. Aレーンの責務

Aは「全部を自分で実装するレーン」ではない。

- 次の数学的targetを選ぶ
- statement解釈を安定させる
- focused Issueへ分割する
- B/C/D/Eへownerを割り当てる
- dependencyとshared hotspotを監視する
- lane handoffのdriftを修正する

B/C/D/Eの仕事を奪わない。

## 9. Eレーンの責務

Eは通常、数学的証明を新規実装しない。

- open PR間の整合性
- Lean / Blueprint linkage
- build / policy / CI
- import / warning / generated output
- lane document drift
- completed sliceのDefinition of Done

を監査する。

## 10. 停止と競合

次の場合は作業を増やさず停止・routeする。

- 同じ成果物を別レーンが既に所有している
- shared hotspotに競合PRがある
- statement解釈がlane間で一致していない
- `AGENTS.md` の `BLOCKED:` 条件に該当する
- 必要な上流PRが未mergeで、安全に独立作業できない

「暇だから別の仕事を作る」のではなく、Aへrouteするかidleとする。
