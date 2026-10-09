# ACTIVE_WORK.md

この文書は単一レーン運用の現在唯一の数学実装を記録します。
GitHubのlive stateがこの文書より新しければlive stateを優先します。

## Current ACTIVE

- Work ID: `C2S3.2-PrincipalUnits`
- Issue: #112
- Branch: `work/c2-s3-2-principal-units-serial`
- PR: #152（draft）
- State: ACTIVE
- Source: Chapter 2 §3.2、印刷 pp.24–25 / uploaded PDF pp.34–35
- Base: PR #149 がmainにマージされた後の最新main
- 必須の証明範囲: power-step lemma / Proposition 8 (odd p and p=2) / Theorem 2 for project Q_p^×.
- §3.3 のsquare classesは明示的にscope外。
- ルール: このPRを完了・parkするまで、別の数学実装PRをactiveにしない。

## Current proof state

- §3.1（Issue #108, PR #149）はmain統合済み（merge commit `9f95bb90a3c3386d289f34afca92451423651d21`、CI #877 green）。
- §3.2の先行実装は、既存の`serrePadicPrincipalUnits` / coefficient residue / successive quotient homomorphismを再利用する。
- `PadicPrincipalUnitPowerStep.lean`: 厳密層の係数による判定、`1+p^(n+1)`による各層の非空性、二項展開の中間・最終項の指数評価。
- 新規補題は最初のCI検証中。ここから命題8が自動的に従うとは主張しない。

## Next proof target

1. 現在のCIでLean/Blueprintを確認し、エラーを修正。
2. 二項係数のp可除性と評価済み指数から、`p`乗のフィルトレーション1段上昇を証明。
3. 係数の非零性を用いて、原典の仮定下でちょうど次の層に属することを証明。
4. 生成元・有限商・整合性・逆極限に進み、命題8を構成。
5. project `Q_p` の付値分解と命題7を接続して定理2を得る。
6. Blueprint、進捗、最終CIを同期してmainへ統合。

## Serial operation

1回の`続けて`で、現在のACTIVEに限り可能な限り作業を進める。
CI失敗があれば最優先でログを読み修正する。書籍本文の転載や完成済みp進単数構造定理のブラックボックス利用は行わない。
