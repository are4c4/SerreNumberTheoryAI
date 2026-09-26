import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.QuadraticReciprocity

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "3.3 平方剰余の相互法則" =>

# 3.3 平方剰余の相互法則

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§3・3.3、印刷頁10–11（uploaded PDF pages 20–21）。

相異なる奇素数 `l,p` を固定する。本節では `F_p` の代数閉包の中に
原始 `l` 乗根 `w` を取り、`F_l` 上のLegendre符号を係数とするGauss和を使って
平方剰余の相互法則を導く。

形式化では、前節で構成した整数値 `legendreSignInt` をそのまま係数に用いる。
これにより、異なる標数の有限体に由来する二つのLegendre符号を同じ計算の中で扱える。

## Gauss和と係数計算

:::definition "serre_gauss_sum" (lean := "SerreNumberTheoryAI.serreGaussSum") (uses := "legendre_sign")
原始 `l` 乗根 `w` に対し、
`y = Σ x : F_l, (x/l) w^x` に対応するGauss和を定める。
係数 `(x/l)` にはプロジェクトの整数値Legendre符号を用い、代数閉包へ写して加算する。
:::

:::definition "serre_gauss_coefficient" (lean := "SerreNumberTheoryAI.serreGaussCoefficient") (uses := "serre_gauss_sum")
Gauss和の平方を加法変数 `u` ごとにまとめたとき現れる係数を定義する。
全体和から `t=0` の寄与を差し引く形にすることで、除算を含む有限体上の置換計算に適した形にしている。
:::

:::lemma_ "serre_gauss_coefficient_zero" (lean := "SerreNumberTheoryAI.serreGaussCoefficient_zero") (uses := "serre_gauss_coefficient")
`u=0` の係数は `l-1` である。
:::

:::lemma_ "serre_gauss_coefficient_nonzero" (lean := "SerreNumberTheoryAI.serreGaussCoefficient_eq_neg_one_of_ne_zero") (uses := "serre_gauss_coefficient")
`u≠0` の係数はすべて `-1` である。
:::

:::proof "serre_gauss_coefficient_nonzero"
`t ↦ 1-u/t` は `F_l` の置換になる。したがってLegendre符号の総和へ変数変換できる。
非自明な乗法指標の全体和は0であり、定義で差し引いた `t=0` の寄与だけが残るため、係数は `-1` となる。
:::

## 第一のGauss和補題

:::theorem "serre_gauss_sum_square" (lean := "SerreNumberTheoryAI.serreGaussSum_sq") (uses := "serre_gauss_sum, serre_gauss_coefficient_zero, serre_gauss_coefficient_nonzero, serre_theorem5_ii")
Gauss和 `y` は
`y² = (-1)^((l-1)/2) l`
を満たす。
:::

:::proof "serre_gauss_sum_square"
`y²` を二重和へ展開し、`u=x+z` で項をまとめる。
内側の積 `(x/l)((u-x)/l)` はLegendre符号の乗法性により一つの符号へまとめられ、
`-1` のLegendre符号を取り出すと上の係数計算に帰着する。

`u=0` の係数は `l-1`、それ以外は `-1` である。
また原始 `l` 乗根の全ての冪の和は0なので、重み付き係数和は `l` になる。
最後に定理5(ii)で `(-1/l)=(-1)^((l-1)/2)` と書き直す。
:::

## Frobeniusによる第二の補題

:::lemma_ "serre_gauss_sum_frobenius" (lean := "SerreNumberTheoryAI.serreGaussSum_pow_prime") (uses := "serre_gauss_sum")
Gauss和はFrobeniusに対して
`y^p = (p/l) y`
を満たす。
:::

:::proof "serre_gauss_sum_frobenius"
標数 `p` では和の `p` 乗は各項の `p` 乗の和になる。
Legendre符号は `0,±1` なので奇数 `p` 乗で変化しない。
一方、根の項は指数が `p` 倍される。 `p≠l` なので `F_l` での `p` 倍写像は置換であり、
変数変換すると乗法性から `(p/l)` が共通因子として外に出る。
:::

:::theorem "serre_gauss_sum_second_lemma" (lean := "SerreNumberTheoryAI.serreGaussSum_pow_prime_sub_one") (uses := "serre_gauss_sum_square, serre_gauss_sum_frobenius")
Gauss和は
`y^(p-1) = (p/l)`
を満たす。
:::

:::proof "serre_gauss_sum_second_lemma"
第一の補題の右辺は零でないので `y≠0` である。
したがって `y^p=(p/l)y` の両辺から `y` を消去できる。
:::

## 平方剰余の相互法則

:::theorem "serre_theorem6" (lean := "SerreNumberTheoryAI.serre_theorem6") (uses := "serre_gauss_sum_square, serre_gauss_sum_second_lemma, serre_theorem5_ii")
相異なる奇素数 `l,p` に対し、
`(l/p) = (p/l) (-1)^(((l-1)/2)((p-1)/2))`
が成り立つ。
:::

:::proof "serre_theorem6"
第一の補題 `y²=(-1)^((l-1)/2)l` を `(p-1)/2` 乗すると、
左辺は `y^(p-1)` になる。第二の補題でこれは `(p/l)` に等しい。
右辺は `p` を法とするLegendre値として
`(-1/p)^((l-1)/2)(l/p)` である。
定理5(ii)を用いて `(-1/p)=(-1)^((p-1)/2)` と書けば、
符号因子を移項して相互法則の式を得る。
:::
