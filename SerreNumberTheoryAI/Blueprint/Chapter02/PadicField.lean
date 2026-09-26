import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicFieldTopology

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 1.3 p進体" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§1・1.3、印刷頁17–18（uploaded PDF pages 27–28）。

この節では、project-local に構成済みの p進整数環 `SerrePadicInt p` の
分数体として p進体を定義する。§1.2 で証明した
「非零 p進整数は p の非負整数冪と単元の積に一意分解される」という事実から、
分数体の非零元は p の整数冪と p進整数単元の像の積に書ける。
さらにこの分解を一般の離散付値環の order-of-vanishing に接続し、
指数が p進付値そのものであることを記録する。

続いて離散付値から p進位相と対応する実数値距離を導入し、命題4の
`Z_p` の開コンパクト性、`Q_p` の局所コンパクト性、`Q` の稠密性までを扱う。
この位相部分も project-local な `SerrePadicInt` のコンパクト性・整数稠密性を使い、
mathlib の完成済み `Padic` / `PadicInt` による置換は行わない。

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
  (uses := "serre_padic_int_to_field")
この標準埋め込みは単射である。
:::

```lean "serre_padic_int_to_field_injective"
namespace SerreNumberTheoryAI

theorem blueprint_serrePadicIntToField_injective
    (p : ℕ) [Fact p.Prime] :
    Function.Injective (serrePadicIntToField p) :=
  serrePadicIntToField_injective p

end SerreNumberTheoryAI
```

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
非零の p進体の元は、p の整数冪と p進整数の単元の像の積に分解できる。
この構成では {uses "serre_padic_int_dvr"}[] と {uses "serre_padic_field"}[] を用いる。
:::

:::proof "serre_padic_field_decomposition"
分子・分母をそれぞれ `p` の非負整数冪と単元へ分解すると、
指数の差が整数指数 `n` になる。この議論は一般の離散付値環の
分数体に対する分解定理として適用する。
:::

:::definition "serre_padic_field_order"
分数体上の order-of-vanishing を用いて、p の整数指数を記録する
project-local p進付値を定義する。
この構成では {uses "serre_padic_int_dvr"}[] と {uses "serre_padic_field"}[] を用いる。
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
  (uses := "serre_padic_field_decomposition, serre_padic_field_order")
`u p^m = v p^n`（`u,v : Z_pˣ`）ならば `m=n` である。
したがって source の整数指数は一意である。
:::

```lean "serre_padic_field_exponent_unique"
namespace SerreNumberTheoryAI

theorem blueprint_serrePadicField_zpow_exponent_unique
    (p : ℕ) [Fact p.Prime]
    {u v : (SerrePadicInt p)ˣ} {m n : ℤ}
    (h : u • (serrePadicFieldPrime p) ^ m =
      v • (serrePadicFieldPrime p) ^ n) :
    m = n :=
  serrePadicField_zpow_exponent_unique (p := p) h

end SerreNumberTheoryAI
```

:::proof "serre_padic_field_exponent_unique"
両辺に order を適用する。単元因子は order 0 なので消え、
`p^m` と `p^n` の order はそれぞれ `m,n` になる。
整数から `ℤᵐ⁰` への指数埋め込みの単射性から `m=n` を得る。
:::


:::definition "serre_padic_field_valuation"
  (lean := "SerreNumberTheoryAI.serrePadicFieldValuation")
  (uses := "serre_padic_field_order, serre_padic_int_dvr")
`Z_p` の極大イデアルから得られる離散付値を `Q_p` 上に入れる。
order-of-vanishing とは逆数の関係にあり、`p` の付値は
`WithZero.exp (-1)` である。
:::

:::definition "serre_padic_field_metric"
  (uses := "serre_padic_field_valuation")
離散付値を底 `p` で rank-one 実現し、対応する p進距離を
`MetricSpace` として束ねる。構成に用いる `Valued.toNormedField` は
この構成で得られる位相は、上で用いた付値位相と同じである。
:::

```lean "serre_padic_field_metric"
namespace SerreNumberTheoryAI

noncomputable def blueprint_serrePadicFieldMetricSpace
    (p : ℕ) [Fact p.Prime] :
    MetricSpace (SerrePadicField p) :=
  serrePadicFieldMetricSpace p

end SerreNumberTheoryAI
```

:::theorem "serre_padic_int_open"
  (lean := "SerreNumberTheoryAI.isOpen_serrePadicIntImage")
  (uses := "serre_padic_field_valuation, serre_padic_int_to_field")
`Z_p` の標準像は `Q_p` の付値部分環と一致し、したがって開部分環である。
:::

:::theorem "serre_padic_int_compact"
  (lean := "SerreNumberTheoryAI.isCompact_serrePadicIntImage")
  (uses := "serre_padic_int_open, serre_padic_int_to_field")
`Z_p` の標準像は `Q_p` でコンパクトである。
project-local `Z_p` の既証明のコンパクト性と、標準埋め込みの連続性から従う。
:::

:::theorem "serre_padic_field_locally_compact"
  (uses := "serre_padic_int_open, serre_padic_int_compact")
`Q_p` は局所コンパクトである。開コンパクトな `Z_p` の像が
0 のコンパクト近傍となり、加法平行移動で任意の点へ移せる。
:::

```lean "serre_padic_field_locally_compact"
namespace SerreNumberTheoryAI

noncomputable def blueprint_serrePadicFieldLocallyCompactSpace
    (p : ℕ) [Fact p.Prime] :
    LocallyCompactSpace (SerrePadicField p) :=
  serrePadicFieldLocallyCompactSpace p

end SerreNumberTheoryAI
```

:::theorem "serre_padic_rationals_dense"
  (uses := "serre_padic_int_compact, serre_padic_field_locally_compact")
標準埋め込み `Q → Q_p` の像は稠密である。
まず §1.2 で得た `Z → Z_p` の稠密性を連続な `Z_p → Q_p` で移し、
`Z_p` の像が有理数像の閉包に入ることを示す。
任意の `Q_p` の元は `Z_p` の2元の商なので、その閉包が部分体であることから
有理数像の閉包は p進体全体になる。
:::

```lean "serre_padic_rationals_dense"
namespace SerreNumberTheoryAI

theorem blueprint_serrePadicField_ratCast_denseRange
    (p : ℕ) [Fact p.Prime] :
    DenseRange (Rat.castHom (SerrePadicField p)) :=
  serrePadicField_ratCast_denseRange p

end SerreNumberTheoryAI
```
