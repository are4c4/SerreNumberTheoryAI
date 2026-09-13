import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.ChevalleyQuadraticForm

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "2.2 Chevalley–Warning の第二系" =>

# 2.2 Chevalley–Warning の第二系

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§2・2.2、印刷頁7（uploaded PDF page 17）。

ここで二次形式は、有限体上の多変数多項式で、すべての項が次数2であるものとして扱う。
変数が少なくとも3個あるとき、この多項式は原点とは異なる零点を持つ。

:::theorem "chevalley_quadratic_form_nontrivial_zero" (lean := "SerreNumberTheoryAI.serre_quadraticForm_exists_nontrivial_zero") (uses := "chevalley_nontrivial_common_zero")
有限体 `K` 上の次数2の斉次多項式 `f` を考える。変数の個数が3以上なら、`f(x)=0` を満たす非零点 `x` が存在する。
:::

:::proof "chevalley_quadratic_form_nontrivial_zero"
第一系を、多項式族が `f` だけからなる場合に適用する。

`f` は次数2の斉次多項式なので、その全次数は高々2である。変数が3個以上あるため、この次数は変数の個数より小さい。また正の次数の斉次多項式には定数項がないので、`f` は原点で0になる。

したがって `chevalley_nontrivial_common_zero` の仮定が満たされ、原点とは異なる `f` の零点が得られる。
:::
