## Active work

- Work ID: <!-- e.g. S3.3-QuadraticReciprocity or infra -->
- Focused Issue: <!-- #... -->
- Branch: <!-- work/... or workflow/... -->
- Dependencies on main: <!-- identify mathematical prerequisites -->
- Shared hotspots touched: <!-- none, or list -->

## Target

<!-- 対象となる章・節・定理。書籍本文は転載せず、節番号等のメタデータを記載する。infra PRなら目的を書く。 -->

## Mathematical statement

<!-- 数学PRでは何を形式化したかを独立した文章で説明する。statement boundaryとassumptionsを明確にする。infra PRなら N/A。 -->

## Dependency audit

<!-- このworkが実際に使うmain上の上流resultを記載する。未merge branchをdependencyとしてproof実装しない。 -->

## Proof idea

<!-- 採用した数学的証明の流れ。セールとの対応は数学的アイデアのレベルで説明する。infra PRなら N/A。 -->

## Lean structure

<!-- 追加・変更した主要 Definition / Lemma / Proposition / Theorem。 -->

## Blueprint / exposition

<!-- 追加したBlueprint node、uses、lean linkage、独立した説明。数学PRでは原則N/Aにしない。 -->

## Mathlib dependencies

<!-- 使用・調査した主要なmathlib API / theorem。 -->

## Strong results intentionally not used

<!-- 対象定理に近すぎるため意図的に使用しなかった完成済み定理があれば記載する。 -->

## Differences from Serre

<!-- Lean固有の補題分割、別証明、追加した中間ステップ等。差異がなければその旨を記載する。 -->

## Single-lane coordination

- [ ] docs/ACTIVE_WORK.md の現在唯一のactive workと一致する
- [ ] 他の数学的実装PRを並行activeにしていない
- [ ] dependencyはmain上で安定している
- [ ] 未merge upstreamへstackしたproof実装ではない
- [ ] active workのLean / Blueprint / explanationを同じPRで同期した
- [ ] merge後にprogress / queue / active workを更新する

## Source / copyright check

- [ ] 書籍本文の長い転載・逐語的な言い換えを含まない
- [ ] 書籍ページ画像・スキャン・スクリーンショットを含まない
- [ ] 自然言語説明は数学的内容から独立に構成した
- [ ] 人間版 SerreNumberTheoryBlueprint の証明・Blueprintを解答源として使用していない

## Verification

- [ ] bash scripts/check_formalization_policy.sh（該当する場合）
- [ ] lake build（該当する場合）
- [ ] lake exe vbp build（該当する場合）
- [ ] PR-head CI
- [ ] diff / statement integrity / dependency / near-target theoremをself-reviewした
- [ ] FORMALIZATION_PROGRESS.md の更新要否を確認した
- [ ] docs/WORK_QUEUE.md / docs/ACTIVE_WORK.md の更新要否を確認した

## Blockers / merge gate

<!-- BLOCKED: 条件、statement上の判断、merge前に必要なmain dependencyがあれば記載する。なければ none。 -->
