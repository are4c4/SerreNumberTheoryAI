## Worker / ownership

- Worker lane: <!-- B / C / D / E / A-infra -->
- Work ID: <!-- e.g. S1.1-T1iii or infra -->
- Focused Issue: <!-- #... -->
- Canonical branch: <!-- work/... or infra/... -->
- Base mode: <!-- main / stacked -->
- Stack base PR / SHA: <!-- N/A for main; otherwise exact upstream PR + head SHA -->
- Dependencies: <!-- DONE / STACK-READY / none; identify mathematical prerequisites -->
- Shared hotspots touched: <!-- none, or list and explain conflict check -->

## Target

<!-- 対象となる章・節・定理。書籍本文は転載せず、節番号等のメタデータを記載する。infra PRなら目的を書く。 -->

## Mathematical statement

<!-- 数学PRでは何を形式化したかを独立した文章で説明する。statement boundaryとassumptionsを明確にする。infra PRなら N/A。 -->

## Dependency audit

<!-- このworkが実際に使う上流resultを記載する。source順だけをdependencyとみなさない。stackedならSTACK-READY interfaceとの対応を書く。 -->

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

## Continuous-worker coordination

- [ ] canonical branch ownershipを取得し、重複active ownerがないことを確認した
- [ ] dependency gateが `DONE` / eligible `STACK-READY` / dependencyなしのいずれかである
- [ ] stackedの場合、upstreamの固定head SHAとinterfaceを記録した
- [ ] 他worker所有branch / shared hotspotを不必要に変更していない
- [ ] `docs/WORK_QUEUE.md` / `docs/LANE_STATUS.md` / handoffの更新要否を確認した
- [ ] CI pendingだけを理由にworker chatを停止せず、in-flight上限内で次の安全なworkを検討した

## STACK-READY gate

<!-- downstreamをstack可能にする場合のみ記載。statement / assumptions / downstream-facing Lean interface / exact head SHA を明記する。stackを許可しない場合は `Not STACK-READY`。 -->

## Source / copyright check

- [ ] 書籍本文の長い転載・逐語的な言い換えを含まない
- [ ] 書籍ページ画像・スキャン・スクリーンショットを含まない
- [ ] 自然言語説明は数学的内容から独立に構成した
- [ ] 人間版 `SerreNumberTheoryBlueprint` の証明・Blueprintを解答源として使用していない

## Verification

- [ ] `bash scripts/check_formalization_policy.sh`（該当する場合）
- [ ] `lake build`（該当する場合）
- [ ] `lake exe vbp build`（該当する場合）
- [ ] PR-head CI
- [ ] `FORMALIZATION_PROGRESS.md` の更新要否を確認した
- [ ] queue / lane handoffの更新要否を確認した
- [ ] stacked workの場合、upstream merge後にlatest main上で再検証した

## Blockers / merge gate

<!-- `BLOCKED:` 条件、statement上の判断、merge前に必要なupstream PRがあれば記載する。なければ none。 -->
