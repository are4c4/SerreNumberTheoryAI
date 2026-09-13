## Lane / ownership

- Lane: <!-- A / B / C / D / E / infra -->
- Focused Issue: <!-- #... -->
- Target id: <!-- e.g. S1.1.Theorem1(ii), or infra -->
- Owned deliverable: <!-- design / Lean / Blueprint / research / integration -->
- Shared hotspots touched: <!-- none, or list and explain conflict check -->

## Target

<!-- 対象となる章・節・定理。書籍本文は転載せず、節番号等のメタデータを記載する。infra PRなら目的を書く。 -->

## Mathematical statement

<!-- 数学PRでは何を形式化したかを独立した文章で説明する。infra PRなら N/A。 -->

## Proof idea

<!-- 採用した数学的証明の流れ。セールとの対応は数学的アイデアのレベルで説明する。infra PRなら N/A。 -->

## Lean structure

<!-- 追加・変更した主要 Definition / Lemma / Proposition / Theorem。Leanを触らないlaneなら N/A。 -->

## Mathlib dependencies

<!-- 使用・調査した主要なmathlib API / theorem。 -->

## Strong results intentionally not used

<!-- 対象定理に近すぎるため意図的に使用しなかった完成済み定理があれば記載する。 -->

## Differences from Serre

<!-- Lean固有の補題分割、別証明、追加した中間ステップ等。差異がなければその旨を記載する。 -->

## Cross-lane coordination

- [ ] 同じdeliverableを所有するactive PRがないことを確認した
- [ ] dependencyとなる他laneのPR / Issueを記載した、または dependencyなし
- [ ] 他lane所有ファイルを不必要に変更していない
- [ ] lane handoff / `docs/LANE_STATUS.md` の更新要否を確認した

## Source / copyright check

- [ ] 書籍本文の長い転載・逐語的な言い換えを含まない
- [ ] 書籍ページ画像・スキャン・スクリーンショットを含まない
- [ ] 自然言語説明は数学的内容から独立に構成した
- [ ] 人間版 `SerreNumberTheoryBlueprint` の証明・Blueprintを解答源として使用していない

## Verification

- [ ] `bash scripts/check_formalization_policy.sh`（該当する場合）
- [ ] `lake build`（該当する場合）
- [ ] `lake exe vbp build`（該当する場合）
- [ ] `FORMALIZATION_PROGRESS.md` の更新要否を確認した
- [ ] 担当lane handoffを更新した

## Blockers / merge gate

<!-- `BLOCKED:` 条件、statement上の判断、merge前に必要な別PRがあれば記載する。なければ none。 -->
