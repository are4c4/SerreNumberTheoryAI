import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.ChevalleyNontrivialZero

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "2.2 Chevalley–Warning の第一系" =>

# 2.2 Chevalley–Warning の第一系

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§2・2.2、印刷頁7（uploaded PDF page 17）。

Chevalley–Warning 定理の仮定に加えて、各多項式が原点で0になるとする。
原点はすでに共通零点である。もし共通零点が原点しかなければ、その個数は1になる。
一方、前の定理は共通零点数が有限体の標数で割り切れることを主張するので、これは矛盾する。
したがって原点とは異なる共通零点が存在する。

:::theorem "chevalley_nontrivial_common_zero" (lean := "SerreNumberTheoryAI.serre_chevalleyWarning_exists_nontrivial_zero") (uses := "serre_chevalley_warning")
有限体 `K` 上の有限個の多変数多項式 `fᵢ` について、全次数の総和が変数の個数より小さく、さらにすべての `fᵢ` が原点で0になるなら、原点とは異なる共通零点が存在する。
:::

:::proof "chevalley_nontrivial_common_zero"
原点は仮定から共通零点である。
非零の共通零点が存在しないと仮定すると、共通零点全体は原点だけからなるので、その有限集合の要素数は1である。

一方、`serre_chevalley_warning` により共通零点数は標数 `p` で割り切れる。
したがって `p` が1を割り切ることになるが、標数 `p` の非自明な体では1が0になることはない。
矛盾より、原点以外の共通零点が存在する。
:::
