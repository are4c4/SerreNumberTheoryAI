import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.PowerSums

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "2.1 有限体上のべき乗和" =>

# 2.1 有限体上のべき乗和

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§2・2.1、印刷頁6（uploaded PDF page 16）。

有限体 `K` の全要素について `u` 乗を足し合わせる。
この節の要点は、指数 `u` が乗法群 `Kˣ` の位数 `#K-1` の倍数かどうかで和が決まることである。
書籍の文章そのものではなく、前節で得た乗法群の巡回性から依存関係を組み立てる。

## べき乗和

:::definition "power_sum" (lean := "SerreNumberTheoryAI.powerSum")
自然数 `u` に対し、有限体 `K` の全要素の `u` 乗の和を `powerSum K u` とする。
Leanの自然数べきでは `0^0=1` なので、`u=0` も同じ定義で扱える。
:::

## 乗法群上の指数条件

:::lemma_ "unit_power_exponent_divisibility" (lean := "SerreNumberTheoryAI.finiteField_units_forall_pow_eq_one_iff") (uses := "finite_field_units_cyclic")
有限体 `K` のすべての単元 `x` が `x^u=1` を満たすことと、`#K-1` が `u` を割り切ることは同値である。
:::

:::proof "unit_power_exponent_divisibility"
前節で `Kˣ` が巡回群であることを得ているので、生成元を1つ取る。
生成元の位数は群全体の位数 `#K-1` である。
したがって生成元の `u` 乗が1になることは `#K-1 | u` と同値であり、生成元のべきとして表される全単元について同じ条件が成り立つ。
:::

:::lemma_ "unit_power_sum" (lean := "SerreNumberTheoryAI.finiteField_unitPowerSum") (uses := "unit_power_exponent_divisibility")
単元全体で `u` 乗を足すと、`#K-1 | u` のとき `-1`、そうでなければ `0` になる。
:::

:::proof "unit_power_sum"
`x ↦ x^u` を `Kˣ` から `K` への乗法準同型とみなす。
この準同型が自明なら和は単元の個数 `#K-1` であり、有限体の中では `#K=0` なのでこれは `-1` に等しい。
自明でなければ、有限群上の非自明な乗法準同型の値の総和は0になる。
前の補題により、自明かどうかはちょうど `#K-1 | u` で判定できる。
:::

:::lemma_ "field_unit_power_sum_agree" (lean := "SerreNumberTheoryAI.powerSum_eq_unitPowerSum")
正の指数では `0^u=0` なので、有限体全体のべき乗和は単元全体のべき乗和と一致する。
:::

:::lemma_ "zeroth_power_sum" (lean := "SerreNumberTheoryAI.powerSum_zero")
`u=0` のとき、べき乗和は有限体の要素数を体の中に写したものになり、これは0である。
:::

## べき乗和公式

:::theorem "serre_power_sum_formula" (lean := "SerreNumberTheoryAI.serre_powerSum_formula") (uses := "unit_power_sum, field_unit_power_sum_agree, zeroth_power_sum")
有限体上のべき乗和は、指数0では0、正の指数では `#K-1` が指数を割るとき `-1`、割らないとき0である。
:::

:::proof "serre_power_sum_formula"
指数0は `zeroth_power_sum` で処理する。
正の指数では0の項を除いてよく、`field_unit_power_sum_agree` により単元上の和に移る。
そこで `unit_power_sum` を適用すれば、割り切れる場合と割り切れない場合の2ケースが得られる。
:::

:::lemma_ "low_exponent_power_sum_zero" (lean := "SerreNumberTheoryAI.powerSum_eq_zero_of_lt_card_sub_one") (uses := "serre_power_sum_formula")
`u < #K-1` なら `powerSum K u = 0` である。
この形は次のChevalley型の議論で単項式ごとの和を消すために使う。
:::

:::proof "low_exponent_power_sum_zero"
`u=0` なら指数0のケースで従う。
`u>0` なら、正の整数 `u` がそれより大きい `#K-1` の倍数になることはできないので、べき乗和公式の非可除ケースが適用される。
:::
