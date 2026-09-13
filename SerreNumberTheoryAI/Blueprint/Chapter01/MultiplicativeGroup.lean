import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.MultiplicativeGroup

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "1.2 有限体の乗法群" =>

# 1.2 有限体の乗法群

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§1・1.2、印刷頁5–6（uploaded PDF pages 15–16）。

有限体 `K` の零でない元は乗法について有限群 `Kˣ` をなす。
この節の中心は、この群が単に有限可換群であるだけでなく、1つの元で生成されることを示す点にある。
証明は、Eulerの `φ` 関数による位数ごとの数え上げと、多項式が次数を超える個数の根を持たないことを組み合わせる。

## 約数上のEuler関数の和

:::lemma_ "totient_divisor_sum" (lean := "SerreNumberTheoryAI.totient_divisor_sum")
正整数の各約数 `d` に対してEuler関数 `φ(d)` を足すと、元の整数に戻る。
Leanでは `Nat.sum_totient` を通してこの標準的な算術恒等式を利用する。
:::

:::proof "totient_divisor_sum"
巡回群の各元をその位数で分類すると、位数が `d` の元は `φ(d)` 個である。
可能な位数は群の位数の約数なので、全要素を数えると約数上の `φ` の和が得られる。
形式化では、この算術部分はmathlibの一般定理に委ねる。
:::

## 方程式の解の個数から巡回性を得る

:::lemma_ "finite_group_cyclic_from_power_root_bound" (lean := "SerreNumberTheoryAI.finiteGroup_isCyclic_of_power_root_bound") (uses := "totient_divisor_sum")
有限群 `G` について、任意の正整数 `n` に対して方程式 `x^n=1` の解が高々 `n` 個なら、`G` は巡回群である。
:::

:::proof "finite_group_cyclic_from_power_root_bound"
元を位数ごとに分けて数える。
ある位数 `d` の元が存在すると、その元が生成する巡回部分群には位数 `d` の元が `φ(d)` 個ある。
一方、`x^d=1` の解の総数に上限 `d` があるため、位数ごとの個数をEuler関数の約数和と比較できる。
全要素数を満たすには群全体の位数を持つ元が必要になり、その元が群を生成する。

書籍では群の位数の約数 `d` だけに解の個数条件を仮定する。
Lean側ではmathlibの一般的な巡回性判定に合わせて、すべての正整数 `n` に同じ上界を仮定する少し強い補助命題を使う。
有限体への適用では多項式の根の個数評価がすべての正整数に対して成り立つため、最終定理の仮定は増えない。
:::

## 有限体での根の個数評価

:::lemma_ "finite_field_units_power_root_bound" (lean := "SerreNumberTheoryAI.finiteField_units_power_root_bound")
有限体 `K` と正整数 `n` に対して、`Kˣ` の中で `u^n=1` を満たす元は高々 `n` 個である。
:::

:::proof "finite_field_units_power_root_bound"
`u^n=1` は、体 `K` 上の多項式 `X^n-1` の根であることと同じである。
この多項式の次数は `n` であり、体上の非零多項式は次数を超える個数の相異なる根を持てない。
単元から `K` への自然な写像は単射なので、単元の解の個数にも同じ上界が移る。
Leanでは一般的な `nthRoots` の根数評価を使ってこの部分を実装する。
:::

## 乗法群の巡回性

:::theorem "finite_field_units_cyclic" (lean := "SerreNumberTheoryAI.finiteField_units_isCyclic") (uses := "finite_group_cyclic_from_power_root_bound, finite_field_units_power_root_bound")
有限体 `K` の乗法群 `Kˣ` は巡回群である。
:::

:::proof "finite_field_units_cyclic"
`finite_field_units_power_root_bound` によって、任意の正整数 `n` に対して `u^n=1` の解は高々 `n` 個である。
そこで `finite_group_cyclic_from_power_root_bound` を `Kˣ` に適用すれば巡回性が従う。
:::

:::lemma_ "finite_field_units_cardinality" (lean := "SerreNumberTheoryAI.finiteField_units_natCard")
有限体 `K` の乗法群の要素数は `Card(K)-1` である。
:::

:::proof "finite_field_units_cardinality"
体では `0` 以外の元がちょうど可逆元である。
したがって `Kˣ` は `K` から `0` を1個除いた集合と同じ要素数を持つ。
:::

:::theorem "serre_theorem2" (lean := "SerreNumberTheoryAI.serre_theorem2") (uses := "finite_field_units_cyclic, finite_field_units_cardinality")
有限体 `K` の乗法群は巡回群であり、その位数は `Card(K)-1` である。
特に `Card(K)=q` と書けば、乗法群の位数は `q-1` となる。
:::
