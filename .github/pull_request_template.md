## Target

<!-- 対象となる章・節・定理。書籍本文は転載せず、節番号等のメタデータを記載する。 -->

## Mathematical statement

<!-- 何を形式化したかを独立した文章で説明する。 -->

## Proof idea

<!-- 採用した数学的証明の流れ。セールとの対応は数学的アイデアのレベルで説明する。 -->

## Lean structure

<!-- 追加・変更した主要 Definition / Lemma / Proposition / Theorem。 -->

## Mathlib dependencies

<!-- 使用した主要なmathlib API / theorem。 -->

## Strong results intentionally not used

<!-- 対象定理に近すぎるため意図的に使用しなかった完成済み定理があれば記載する。 -->

## Differences from Serre

<!-- Lean固有の補題分割、別証明、追加した中間ステップ等。差異がなければその旨を記載する。 -->

## Source / copyright check

- [ ] 書籍本文の長い転載・逐語的な言い換えを含まない
- [ ] 書籍ページ画像・スキャン・スクリーンショットを含まない
- [ ] 自然言語説明は数学的内容から独立に構成した
- [ ] 人間版 `SerreNumberTheoryBlueprint` の証明・Blueprintを解答源として使用していない

## Verification

- [ ] `bash scripts/check_formalization_policy.sh`
- [ ] `lake build`
- [ ] `lake exe vbp build`
- [ ] `FORMALIZATION_PROGRESS.md` を更新した

## Blockers / review points

<!-- 人間に確認してほしいstatement上の判断や停止条件があれば記載する。 -->
