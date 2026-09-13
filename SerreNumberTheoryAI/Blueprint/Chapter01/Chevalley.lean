import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.Chevalley

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "2.2 Chevalley–Warning" =>

# 2.2 Chevalley–Warning

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§2・2.2、印刷頁7（uploaded PDF page 17）。

有限体 `K` の標数を `p`、要素数を `q` とする。
有限個の多変数多項式について、次数の総和が変数の個数より小さければ、共通零点の個数は `p` で割り切れる。
ここでは、その中心となる全格子上の和の消滅を前節のべき乗和から導き、零点指示式を用いて本定理へ進む。

## 多変数多項式の全格子和

:::lemma_ "multivariate_grid_sum_zero" (lean := "SerreNumberTheoryAI.mvPolynomial_sum_eval_eq_zero") (uses := "low_exponent_power_sum_zero")
`σ` 個の変数を持つ多項式 `F` の全次数が `(q-1)·#σ` より小さいとき、`K^σ` の全点で `F` を評価した値の総和は0である。
:::

:::proof "multivariate_grid_sum_zero"
`F` を単項式の和として展開する。
全次数の仮定から、各単項式の指数ベクトルには少なくとも1つ `q-1` 未満の座標がある。
その座標以外を固定して和を分解すると、問題の座標に関する因子は
`∑ a : K, a^u`
となる。ここで `u<q-1` なので前節のべき乗和補題によりこの因子は0であり、各単項式の全格子和も0になる。
:::

## 共通零点を検出する多項式

:::definition "chevalley_indicator_idea"
有限個の多項式 `fᵢ` に対し、各点で
`∏ᵢ (1 - fᵢ^(q-1))`
を考える。有限体では非零元の `(q-1)` 乗が1なので、この積はすべての `fᵢ` が0になる点で1、それ以外で0となる。
:::

## Chevalley–Warning 定理

:::theorem "serre_chevalley_warning" (lean := "SerreNumberTheoryAI.serre_chevalleyWarning") (uses := "multivariate_grid_sum_zero, chevalley_indicator_idea")
有限体 `K` の標数を `p` とする。有限集合で添字付けられた `σ` 変数多項式 `fᵢ` について、全次数の総和が `#σ` より小さいなら、共通零点の個数は `p` で割り切れる。
:::

:::proof "serre_chevalley_warning"
`P=∏ᵢ(1-fᵢ^(q-1))` とおく。`P` は共通零点では1、それ以外では0なので、有限体の中で `P` の全格子和は共通零点数を表す。

一方、`P` の全次数は高々 `(q-1)` と各 `fᵢ` の全次数の積和であり、仮定から `(q-1)·#σ` より小さい。したがって `multivariate_grid_sum_zero` により `P` の全格子和は0である。

よって共通零点数を `K` に移したものは0になる。標数が `p` であることから、これは整数として共通零点数が `p` で割り切れることと同値である。
:::

この節の直後に続く「原点以外の共通零点の存在」や二次形式への応用は、この核心定理からの下流結果として別のwork itemに分離する。
