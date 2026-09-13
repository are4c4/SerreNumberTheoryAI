import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.LegendreSymbol
import SerreNumberTheoryAI.Formalization.Chapter01.LegendreTwo

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "3.2 Legendre記号" =>

# 3.2 Legendre記号

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§3・3.2、印刷頁8–9（uploaded PDF pages 18–19）。

奇素数 `p` を固定する。前節で得た有限体の平方元の判定を使うと、
`F_p` の零でない元 `x` に対する `x^((p-1)/2)` は `1` または `-1` になる。
この符号を零では `0` に拡張し、さらに整数を `F_p` へ写すことでLegendre記号を表す。

形式化では、有限体内で計算する値と、標数に依存せず他の体へも符号として移せる整数値を分けている。
前者が `legendreValue`、後者が `legendreSign` / `legendreSignInt` である。

## 定義と基本性質

:::definition "legendre_value" (lean := "SerreNumberTheoryAI.legendreValue") (uses := "finite_field_half_power_character")
`x : F_p` に対し、有限体内のLegendre値を `x^((p-1)/2)` とする。
零でない `x` では前節の半乗写像と一致する。
:::

:::definition "legendre_sign" (lean := "SerreNumberTheoryAI.legendreSignInt") (uses := "legendre_value")
整数 `a` を `F_p` に写し、そのLegendre値が `0,1,-1` のどれであるかを整数の符号 `0,1,-1` として取り出す。
これにより後の節で標数の異なる体へ係数として移す場合にも同じ符号を使える。
:::

:::theorem "legendre_multiplicative" (lean := "SerreNumberTheoryAI.legendreSignInt_mul") (uses := "legendre_sign")
奇素数 `p` に対し、整数入力のLegendre符号は乗法的である。
:::

:::proof "legendre_multiplicative"
有限体内では `(xy)^((p-1)/2)=x^((p-1)/2)y^((p-1)/2)` である。
零を含む場合は符号が `0` になり、零でない場合は各値が `±1` なので、整数の符号へ移しても積が保たれる。
:::

:::theorem "legendre_square_criterion" (lean := "SerreNumberTheoryAI.legendreValue_eq_one_iff_isSquare_of_ne_zero") (uses := "finite_field_square_iff_half_power_one, legendre_value")
零でない `x : F_p` について、Legendre値が `1` であることと `x` が平方元であることは同値である。
:::

:::proof "legendre_square_criterion"
前節で、零でない平方元部分群が半乗写像の核に一致することを示した。
`legendreValue` は零でない元ではその半乗写像を `F_p` に戻したものなので、値が `1` であることが平方元であることをちょうど表す。
:::

## 定理5

奇数 `n` に対して、書籍の符号指数は
`ε(n) = (n-1)/2 (mod 2)` と `ω(n) = (n^2-1)/8 (mod 2)` で与えられる。
Leanでは `(-1)` の冪は指数の偶奇だけに依存するため、自然数指数 `(n-1)/2` と `(n^2-1)/8` をそのまま使う。

:::theorem "serre_theorem5_i" (lean := "SerreNumberTheoryAI.serre_theorem5_i") (uses := "legendre_sign")
`1` のLegendre記号は `1` である。
:::

:::proof "serre_theorem5_i"
`1` のどの正整数乗も `1` なので、定義から直ちに従う。
:::

:::theorem "serre_theorem5_ii" (lean := "SerreNumberTheoryAI.serre_theorem5_ii") (uses := "legendre_sign")
奇素数 `p` に対し、`-1` のLegendre記号は `(-1)^((p-1)/2)` である。
:::

:::proof "serre_theorem5_ii"
有限体内の定義に `x=-1` を代入すると値はそのまま `(-1)^((p-1)/2)` になる。
この値は `±1` なので整数符号へ移しても変わらない。
:::

:::theorem "serre_theorem5_iii" (lean := "SerreNumberTheoryAI.serre_theorem5_iii") (uses := "legendre_sign")
奇素数 `p` に対し、`2` のLegendre記号は `(-1)^((p^2-1)/8)` である。
:::

:::proof "serre_theorem5_iii"
`F_p` の代数閉包で原始8乗根 `α` を取り、`y=α+α⁻¹` とおく。
`α^4=-1` から直接計算して `y²=2` を得る。

Frobeniusは `α` を `α^p` へ送る。`p` を8で割った余りが `1` または `7` なら `α^p` は `α` または `α⁻¹` となり、`y^p=y` である。
余りが `3` または `5` なら対応する冪は符号付きの逆元または元となり、`y^p=-y` である。
`y` は零でないので、前者では `y^(p-1)=1`、後者では `y^(p-1)=-1` を得る。
`y²=2` を用いると、これは `2^((p-1)/2)` がそれぞれ `1` または `-1` であることを意味する。

最後に `p mod 8` の4通りを計算すると、`(p^2-1)/8` は余り `1,7` のとき偶数、`3,5` のとき奇数である。
したがって上の符号はちょうど `(-1)^((p^2-1)/8)` と一致する。
:::
