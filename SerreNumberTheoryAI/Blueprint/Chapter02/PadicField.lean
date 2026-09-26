import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicField

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 1.3 p進体の代数的構成" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§1・1.3、印刷頁17–18（uploaded PDF pages 27–28）。

この節では、project-local に構成済みの p進整数環 `SerrePadicInt p` の
分数体として p進体を定義する。§1.2 で証明した
「非零 p進整数は p の非負整数冪と単元の積に一意分解される」という事実から、
分数体の非零元は p の整数冪と p進整数単元の像の積に書ける。
さらにこの分解を一般の離散付値環の order-of-vanishing に接続し、
指数が p進付値そのものであることを記録する。

このファイルでは §1.3 の代数的構成だけを扱う。局所コンパクト性、
`Z_p` の開コンパクト性、`Q` の稠密性からなる命題4は後続の位相的 slice とする。

:::definition "serre_padic_field"
  (lean := "SerreNumberTheoryAI.SerrePadicField")
project-local な p進体 `Q_p` を、project-local な p進整数環
`SerrePadicInt p` の分数体として定義する。
:::

:::definition "serre_padic_int_to_field"
  (lean := "SerreNumberTheoryAI.serrePadicIntToField")
  (uses := "serre_padic_field")
`Z_p → Q_p` の標準環準同型を分数体の標準埋め込みとして定義する。
:::

:::theorem "serre_padic_int_to_field_injective"
  (lean := "SerreNumberTheoryAI.serrePadicIntToField_injective")
  (uses := "serre_padic_int_to_field")
この標準埋め込みは単射である。
:::

:::theorem "serre_padic_int_dvr"
  (uses := "serre_padic_int_to_field")
§1.2 の一意分解により、project-local な `Z_p` は
`p` を一様化元に持つ離散付値環である。
:::

```lean "serre_padic_int_dvr"
namespace SerreNumberTheoryAI

noncomputable example (p : ℕ) [Fact p.Prime] :
    IsDiscreteValuationRing (SerrePadicInt p) := by
  infer_instance

end SerreNumberTheoryAI
```

:::proof "serre_padic_int_dvr"
非零元 `x` を `x = p^n u`（`u` は単元）と分解する。
したがって任意の非零元は一様化元 `p` の冪と associated であり、
一般の離散付値環判定定理を適用できる。
:::

:::theorem "serre_padic_field_decomposition"
  (lean := "SerreNumberTheoryAI.serrePadicField_exists_unit_smul_zpow")
  (uses := "serre_padic_int_dvr, serre_padic_field")
非零の `x : Q_p` に対し、整数 `n : ℤ` と `u : Z_pˣ` が存在して
`x = u · p^n` と書ける。
:::

:::proof "serre_padic_field_decomposition"
分子・分母をそれぞれ `p` の非負整数冪と単元へ分解すると、
指数の差が整数指数 `n` になる。この議論は一般の離散付値環の
分数体に対する分解定理として適用する。
:::

:::definition "serre_padic_field_order"
  (lean := "SerreNumberTheoryAI.serrePadicFieldOrder")
  (uses := "serre_padic_int_dvr, serre_padic_field")
分数体上の order-of-vanishing を用い、`p` の指数を記録する
project-local p進付値を定義する。Leanでは零点も含めて乗法的に扱うため
値域を `ℤᵐ⁰` とする。
:::

:::lemma_ "serre_padic_field_order_prime"
  (lean := "SerreNumberTheoryAI.serrePadicFieldOrder_prime")
  (uses := "serre_padic_field_order")
一様化元 `p` の order は 1 である。
:::

:::lemma_ "serre_padic_field_order_unit"
  (lean := "SerreNumberTheoryAI.serrePadicFieldOrder_unit")
  (uses := "serre_padic_field_order")
`Z_p` の単元の像の order は 0、すなわち乗法的表現では 1 である。
:::

:::theorem "serre_padic_field_exponent_unique"
  (lean := "SerreNumberTheoryAI.serrePadicField_zpow_exponent_unique")
  (uses := "serre_padic_field_decomposition, serre_padic_field_order")
`u p^m = v p^n`（`u,v : Z_pˣ`）ならば `m=n` である。
したがって source の整数指数は一意である。
:::

:::proof "serre_padic_field_exponent_unique"
両辺に order を適用する。単元因子は order 0 なので消え、
`p^m` と `p^n` の order はそれぞれ `m,n` になる。
整数から `ℤᵐ⁰` への指数埋め込みの単射性から `m=n` を得る。
:::
