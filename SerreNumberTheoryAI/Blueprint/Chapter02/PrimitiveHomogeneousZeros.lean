import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PrimitiveHomogeneousZeros

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 2.1 原始的な斉次共通零点" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§2・2.1、印刷頁19（uploaded PDF page 29）。

この節では命題5を斉次方程式系に強める。有限個の変数をもち、
各多項式がそれぞれある次数で斉次であるとする。書籍の「原始的」は、
座標の少なくとも一つが p進整数の単元であることを意味する。

Leanでは、非零な project-local Qₚ 共通零点を、各非零座標の
`p` 指数の最小値で同時にスケールする。これにより全座標が
project-local Zₚ に入り、最小指数を達成する座標が単元になる。
斉次性により共通零点条件はこのスケーリングで保たれる。

:::definition "serre_padic_tuple_primitive"
  (lean := "SerreNumberTheoryAI.serrePadicTuplePrimitive")
p進整数の有限tupleが原始的であるとは、少なくとも一つの座標が単元であることとする。
:::

:::definition "padic_reduced_tuple_primitive"
  (lean := "SerreNumberTheoryAI.padicReducedTuplePrimitive")
有限剰余levelのtupleが原始的であるとは、少なくとも一つの座標が単元であることとする。
この条件は、その座標を最初の residue level へさらに還元した値が0でないことと同値である。
:::

:::lemma_ "primitive_projection"
  (lean := "SerreNumberTheoryAI.padicReducedTuplePrimitive_of_serrePadic")
  (uses := "serre_padic_tuple_primitive, padic_reduced_tuple_primitive")
原始的な p進整数tupleを任意の有限levelへ射影すると原始性が保たれる。
:::

:::lemma_ "primitive_recovery"
  (lean := "SerreNumberTheoryAI.serrePadicTuplePrimitive_of_reduced")
  (uses := "serre_padic_tuple_primitive, padic_reduced_tuple_primitive")
ある有限levelへの射影が原始的なら、元の p進整数tupleも原始的である。
:::

:::theorem "primitive_common_zero_iff_reductions"
  (lean := "SerreNumberTheoryAI.primitiveCommonZero_iff_reductions")
  (uses := "primitive_projection, primitive_recovery")
p進整数上に原始的な共通零点が存在することと、すべての有限levelで
還元された方程式族に原始的な共通零点が存在することは同値である。
:::

:::proof "primitive_common_zero_iff_reductions"
一方向は原始的な p進共通零点を各有限levelへ射影する。
逆方向では命題5と同様に、各levelで方程式を満たし、かつ最初の residue level で
非零座標をもつ近似集合を考える。これらは非空な減少閉集合族をなし、
p進整数tuple空間のコンパクト性から共通部分を得る。
最初のlevelの条件から極限tupleは原始的で、全levelでの消滅から
各多項式値そのものが0になる。
:::

:::lemma_ "homogeneous_eval_scale"
  (lean := "SerreNumberTheoryAI.homogeneous_eval₂_scale")
斉次多項式を全座標同じスカラー倍した点で評価すると、
元の評価値にそのスカラーの斉次次数乗を掛けた値になる。
:::

:::theorem "field_tuple_primitive_normalization"
非零な有限 Qₚ tupleには整数 `h` が存在し、全座標を `p^(-h)` 倍すると
Zₚ tupleとして表され、しかも少なくとも一つの座標は単元になる。
:::

```lean "field_tuple_primitive_normalization"
namespace SerreNumberTheoryAI

example
    {σ : Type*} (p : ℕ) [Fact p.Prime] [Fintype σ]
    (x : σ → SerrePadicField p) (hx : x ≠ 0) :
    ∃ (h : ℤ) (y : σ → SerrePadicInt p),
      serrePadicTuplePrimitive y ∧
        ∀ s, serrePadicIntToField p (y s) =
          (serrePadicFieldPrime p) ^ (-h) * x s :=
  exists_primitive_serrePadicInt_scale_of_fieldTuple_ne_zero p x hx

end SerreNumberTheoryAI
```

:::proof "field_tuple_primitive_normalization"
非零座標を `uₛ p^(eₛ)` と分解し、有限個の指数 `eₛ` の最小値を `h` とする。
`p^(-h)` を掛けると各非零座標の指数は `0 ≤ eₛ - h` となるので
p進整数の像に入る。最小値を達成する座標では指数が0になるため、
対応する座標は単元である。
:::

:::theorem "homogeneous.field.common.zero.primitive"
  (uses := "homogeneous_eval_scale, field_tuple_primitive_normalization")
斉次多項式族について、Qₚ 上の非零共通零点の存在と
Zₚ 上の原始的共通零点の存在は同値である。
:::



:::proof "homogeneous.field.common.zero.primitive"
Qₚ 上の非零共通零点からは、最小指数による正規化で原始的な Zₚ tuple を得る。
各多項式は斉次なので、同じスカラーによる全座標の変換は多項式値を
その斉次次数乗だけ変える。したがって零点条件は保たれる。

逆方向では、原始的な Zₚ 共通零点を標準埋め込みで Qₚ に送る。
単元である座標は0でないので、得られる Qₚ tuple は非零である。
評価は標準埋め込みと可換だから、共通零点条件も保たれる。
:::

:::theorem "serre_proposition6_homogeneous_common_zero_iff_reductions"
  (uses := "homogeneous.field.common.zero.primitive, primitive_common_zero_iff_reductions")
斉次多項式族について、project-local Qₚ 上に非零共通零点が存在することと、
すべての有限 residue level で原始的な共通零点が存在することは同値である。
これは命題6の (a)、(b)、(c) を、中央の原始的 Zₚ 条件を介して結ぶ。
:::

```lean "serre_proposition6_homogeneous_common_zero_iff_reductions"
namespace SerreNumberTheoryAI

universe u v

example
    {σ : Type u} {ι : Type v} (p : ℕ) [Fact p.Prime] [Fintype σ]
    (f : ι → MvPolynomial σ (SerrePadicInt p))
    (d : ι → ℕ) (hf : ∀ i, (f i).IsHomogeneous (d i)) :
    (∃ x : σ → SerrePadicField p,
        x ≠ 0 ∧
          ∀ i, MvPolynomial.eval₂ (serrePadicIntToField p) x (f i) = 0) ↔
      ∀ n : ℕ, ∃ a : σ → padicResidueRing p n,
        padicReducedTuplePrimitive a ∧
          ∀ i, MvPolynomial.eval a (padicPolynomialReduction p n (f i)) = 0 :=
  serre_proposition6_homogeneous_commonZero_iff_reductions p f d hf

end SerreNumberTheoryAI
```

:::proof "serre_proposition6_homogeneous_common_zero_iff_reductions"
Qₚ から Zₚ への方向では、非零共通零点を最小指数で正規化し、
斉次性によって零点条件を保つ。逆方向では原始的な Zₚ 共通零点を
標準埋め込みで Qₚ に送れば、単元座標の存在によりtupleは非零である。
最後に原始的 Zₚ 共通零点と全有限levelの原始的共通零点の同値を合成する。
:::
