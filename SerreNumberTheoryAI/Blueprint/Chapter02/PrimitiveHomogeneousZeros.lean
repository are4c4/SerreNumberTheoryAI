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

非零な project-local Qₚ 共通零点は、各非零座標の p 指数の
最小値で同時にスケールする。これにより全座標が project-local
Zₚ に入り、最小指数を達成する座標が単元になる。斉次性により
共通零点条件はこのスケーリングで保たれる。

:::definition "primitivezptuple"
p進整数の有限 tuple が原始的であるとは、少なくとも一つの座標が単元であることとする。
:::

:::definition "primitiveresiduetuple"
有限剰余 level の tuple が原始的であるとは、少なくとも一つの座標が単元であることとする。
:::

:::lemma_ "primitiveprojection"
  (uses := "primitivezptuple, primitiveresiduetuple")
原始的な p進整数 tuple を任意の有限 level へ射影すると原始性が保たれる。
:::

:::lemma_ "primitiverecovery"
  (uses := "primitivezptuple, primitiveresiduetuple")
ある有限 level への射影が原始的なら、元の p進整数 tuple も原始的である。
:::

:::theorem "primitivecommonzero"
  (uses := "primitiveprojection, primitiverecovery")
p進整数上に原始的な共通零点が存在することと、すべての有限 level で
還元された方程式族に原始的な共通零点が存在することは同値である。
:::

:::proof "primitivecommonzero"
一方向は原始的な p進共通零点を各有限 level へ射影する。
逆方向では命題5と同様に、各 level で方程式を満たし、かつ最初の
residue level で非零座標をもつ近似集合を考える。これらは非空な
減少閉集合族をなし、p進整数 tuple 空間のコンパクト性から共通部分を得る。
最初の level の条件から極限 tuple は原始的で、全 level での消滅から
各多項式値そのものが0になる。
:::

:::lemma_ "homscale"
斉次多項式を全座標同じスカラー倍した点で評価すると、
元の評価値にそのスカラーの斉次次数乗を掛けた値になる。
:::

:::theorem "fieldnormalization"
非零な有限 Qₚ tuple には整数 h が存在し、全座標を p のマイナス h 乗で
同時にスケールすると Zₚ tuple として表され、少なくとも一つの座標は単元になる。
:::

:::proof "fieldnormalization"
非零座標を単元と p の整数冪に分解し、有限個の指数の最小値を h とする。
p のマイナス h 乗を掛けると各非零座標の指数は非負になり、
p進整数の像に入る。最小値を達成する座標では指数が0になるため、
対応する座標は単元である。
:::

:::theorem "homogeneousprimitive"
  (uses := "homscale, fieldnormalization")
各方程式が斉次であるとする。このとき、project-local Qₚ 上の非零共通零点の存在と、
project-local Zₚ 上の原始的共通零点の存在は同値である。
:::

:::proof "homogeneousprimitive"
Qₚ 上の非零共通零点からは、最小指数による正規化で原始的な Zₚ tuple を得る。
各多項式は斉次なので、同じスカラーによる全座標の変換は多項式値を
斉次次数乗だけ変える。したがって零点条件は保たれる。
逆方向では、原始的な Zₚ 共通零点を標準埋め込みで Qₚ に送る。
単元である座標は0でないので、得られる Qₚ tuple は非零である。
:::

:::theorem "serreprop6"
  (uses := "homogeneousprimitive, primitivecommonzero")
斉次多項式族について、project-local Qₚ 上に非零共通零点が存在することと、
すべての有限 residue level で原始的な共通零点が存在することは同値である。
これは命題6の三つの条件を、中央の原始的 Zₚ 条件を介して結ぶ。
:::

:::proof "serreprop6"
Qₚ から Zₚ への方向では、非零共通零点を最小指数で正規化し、
斉次性によって零点条件を保つ。逆方向では原始的な Zₚ 共通零点を
標準埋め込みで Qₚ に送れば、単元座標の存在により tuple は非零である。
最後に原始的 Zₚ 共通零点と全有限 level の原始的共通零点の同値を合成する。
:::
