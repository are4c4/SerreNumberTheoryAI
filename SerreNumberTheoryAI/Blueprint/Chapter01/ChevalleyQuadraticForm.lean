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

有限体上の二次形式を、次数2の斉次多項式として扱う。変数が3個以上なら、
その全次数は変数の個数より小さい。また斉次次数が正なので原点では0になる。
したがって第一系を1本の多項式に適用でき、原点とは異なる零点が得られる。

:::theorem "chevalley_quadratic_form_nontrivial_zero" (lean := "SerreNumberTheoryAI.serre_chevalleyWarning_quadraticForm_exists_nontrivial_zero") (uses := "chevalley_nontrivial_common_zero")
有限体 `K` 上の次数2の斉次多項式 `f` が少なくとも3個の変数を持つなら、
`f(x)=0` を満たす `x ≠ 0` が存在する。
:::

:::proof "chevalley_quadratic_form_nontrivial_zero"
斉次性から `f` の全次数は高々2であり、定数項は0なので `f(0)=0` である。
変数が少なくとも3個あるため、`totalDegree f < number of variables` が成り立つ。
そこで第一系を多項式族 `{f}` に適用すると、原点とは異なる共通零点、すなわち
`f` の非零零点が得られる。
:::
