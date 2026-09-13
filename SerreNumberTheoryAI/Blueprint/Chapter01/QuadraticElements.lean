import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.QuadraticElements

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "3.1 有限体の平方元" =>

# 3.1 有限体の平方元

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§3・3.1、印刷頁8（uploaded PDF page 18）。

有限体の平方元の構造は標数2と奇標数で異なる。
標数2ではFrobeniusによってすべての元が平方になる。
奇標数では、零でない平方元は乗法群の指数2の部分群をなし、`(#K-1)/2` 乗写像によって判定できる。

## 標数2

:::theorem "finite_field_squares_char_two" (lean := "SerreNumberTheoryAI.finiteField_isSquare_of_char_two")
標数2の有限体では、任意の元が平方である。
:::

:::proof "finite_field_squares_char_two"
平方写像は標数2のFrobenius写像である。
体準同型として単射であり、有限集合上の自己写像なので全射でもある。
したがって任意の元 `x` に対して `y²=x` となる `y` が存在する。
:::

## 零でない平方元

:::definition "finite_field_nonzero_squares" (lean := "SerreNumberTheoryAI.finiteFieldNonzeroSquares")
乗法群 `Kˣ` の平方写像 `y ↦ y²` の像を、零でない平方元の部分群とする。
:::

:::theorem "finite_field_nonzero_squares_index_two" (lean := "SerreNumberTheoryAI.finiteFieldNonzeroSquares_index") (uses := "finite_field_units_cyclic, finite_field_nonzero_squares")
奇標数の有限体では、零でない平方元の部分群の指数は2である。
:::

:::proof "finite_field_nonzero_squares_index_two"
前節で `Kˣ` が有限巡回群であることを示した。
奇標数では `-1` の位数が2なので `#Kˣ` は偶数である。
有限巡回群における平方写像の像の指数は `gcd(#Kˣ,2)` であり、したがって2になる。
:::

## 半乗写像

:::definition "finite_field_half_power_character" (lean := "SerreNumberTheoryAI.finiteFieldHalfPowerCharacter")
`Kˣ` 上の写像 `x ↦ x^(#Kˣ/2)` を半乗写像と呼ぶ。
`#Kˣ=#K-1` なので、これは書籍の `x ↦ x^((q-1)/2)` に対応する。
:::

:::lemma_ "finite_field_half_power_values" (lean := "SerreNumberTheoryAI.finiteFieldHalfPowerCharacter_eq_one_or_neg_one") (uses := "finite_field_half_power_character")
奇標数では半乗写像の値は常に `1` または `-1` である。
:::

:::proof "finite_field_half_power_values"
`#Kˣ` が偶数なので、半乗した値をさらに2乗すると `x^(#Kˣ)=1` になる。
体では `z²=1` の解は `z=1` または `z=-1` だけである。
:::

:::theorem "finite_field_nonzero_squares_kernel" (lean := "SerreNumberTheoryAI.finiteFieldNonzeroSquares_eq_ker_halfPowerCharacter") (uses := "finite_field_units_cyclic, finite_field_nonzero_squares, finite_field_half_power_character")
奇標数では、零でない平方元の部分群は半乗写像の核に一致する。
:::

:::proof "finite_field_nonzero_squares_kernel"
平方 `y²` を半乗すると `y^(#Kˣ)=1` なので、平方元部分群は核に含まれる。
一方、有限巡回群の一般的な冪写像の公式から、平方写像の像と半乗写像の核は同じ要素数を持つ。
包含関係と有限性から両者は等しい。
:::

:::lemma_ "finite_field_square_iff_half_power_one" (lean := "SerreNumberTheoryAI.mem_finiteFieldNonzeroSquares_iff_halfPowerCharacter_eq_one") (uses := "finite_field_nonzero_squares_kernel")
奇標数では、`x : Kˣ` が平方元であることと半乗値が `1` であることは同値である。
:::

## 定理4

:::theorem "serre_theorem4_char_two" (lean := "SerreNumberTheoryAI.serre_theorem4_char_two") (uses := "finite_field_squares_char_two")
標数2では有限体のすべての元が平方である。
:::

:::theorem "serre_theorem4_odd" (lean := "SerreNumberTheoryAI.serre_theorem4_odd") (uses := "finite_field_nonzero_squares_index_two, finite_field_nonzero_squares_kernel, finite_field_half_power_values")
奇標数では、零でない平方元は指数2の部分群をなし、それは半乗写像の核であり、半乗写像の値は `{±1}` に入る。
:::
