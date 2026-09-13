import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegers

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 1.1 p進整数の構成" =>

# 逆極限としての p進整数

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§1・1.1、印刷頁15–16（uploaded PDF pages 25–26）。

素数 `p` を固定する。正の整数 `m` ごとの剰余環 `ℤ / p^mℤ` を、
隣り合う法の間の自然な剰余写像で結ぶ。p進整数は、これらすべての剰余情報が
互いに整合する列として構成できる。

Leanでは添字を0から始め、level `n` を `ℤ / p^(n+1)ℤ` とする。
これは書籍の正の整数添字をずらしただけで、数学的対象は同じである。

## 剰余環と遷移写像

:::definition "padic_residue_ring" (lean := "SerreNumberTheoryAI.padicResidueRing")
level `n` の剰余環を `ZMod (p^(n+1))` とする。
:::

:::definition "padic_reduction" (lean := "SerreNumberTheoryAI.padicReduction") (uses := "padic_residue_ring")
level `n+1` から level `n` への写像は、より高い `p` の冪を法とする剰余類を
より低い冪を法として読み直す自然な環準同型である。
:::

:::lemma_ "padic_reduction_surjective" (lean := "SerreNumberTheoryAI.padicReduction_surjective") (uses := "padic_reduction")
各隣接剰余写像は全射である。
:::

:::lemma_ "padic_reduction_kernel" (lean := "SerreNumberTheoryAI.mem_ker_padicReduction_iff") (uses := "padic_reduction")
level `n+1` から level `n` への剰余写像の核は、source levelでの `p^(n+1)` の倍数全体である。
これは書籍の `ker(φ_m)=p^(m-1)A_m` を0始まりの添字へ移した形である。
:::

## 整合列としてのp進整数

:::definition "padic_compatible" (lean := "SerreNumberTheoryAI.padicCompatible") (uses := "padic_reduction")
剰余列 `x=(x_n)` が整合的であるとは、すべての `n` について
level `n+1` の成分を下げると level `n` の成分になることである。
:::

:::definition "serre_padic_int" (lean := "SerreNumberTheoryAI.SerrePadicInt") (uses := "padic_compatible")
`SerrePadicInt p` は、剰余環の直積のうち整合条件を満たす列全体である。
加法・乗法は各成分ごとに行うので、これは直積環の部分環になる。
:::

:::definition "serre_padic_projection" (lean := "SerreNumberTheoryAI.serrePadicIntProj") (uses := "serre_padic_int")
各 `n` について、p進整数から level `n` の剰余成分を取り出す環準同型がある。
:::

:::lemma_ "serre_padic_projection_compatible" (lean := "SerreNumberTheoryAI.serrePadicIntProj_compat") (uses := "serre_padic_projection, padic_reduction")
隣り合う射影は剰余写像と可換する。
:::

:::lemma_ "serre_padic_projection_surjective" (lean := "SerreNumberTheoryAI.serrePadicIntProj_surjective") (uses := "serre_padic_projection")
各有限levelへの射影は全射である。
:::

:::lemma_ "serre_padic_extensionality" (lean := "SerreNumberTheoryAI.serrePadicInt_ext") (uses := "serre_padic_projection")
すべての有限levelで同じ剰余成分を持つ2つのp進整数は等しい。
:::

## 位相とコンパクト性

各有限剰余環には離散位相を入れ、直積には積位相を入れる。
整合条件は各座標についての等式の共通部分として閉条件になる。

:::lemma_ "padic_compatible_closed" (lean := "SerreNumberTheoryAI.padicCompatible_isClosed") (uses := "padic_compatible")
`p` が素数なら、整合列全体は剰余環の直積の閉部分集合である。
:::

:::theorem "serre_padic_int_compact" (lean := "SerreNumberTheoryAI.serrePadicInt_isCompact") (uses := "padic_compatible_closed, serre_padic_int")
`p` が素数なら、`SerrePadicInt p` は積位相から誘導される位相でコンパクトである。
:::

:::lemma_ "serre_padic_projection_continuous" (lean := "SerreNumberTheoryAI.serrePadicIntProj_continuous") (uses := "serre_padic_projection")
各有限levelへの射影は積位相から誘導される位相について連続である。
:::

## 整数の標準埋め込み

整数 `a` を各 `p^(n+1)` で割った剰余類の列へ送ると、その列は自動的に整合する。

:::definition "serre_padic_int_int_cast" (lean := "SerreNumberTheoryAI.serrePadicIntIntCast") (uses := "serre_padic_int")
整数をその整合剰余列へ送る標準環準同型 `ℤ → SerrePadicInt p` を定める。
:::

:::lemma_ "serre_padic_int_int_cast_projection" (lean := "SerreNumberTheoryAI.serrePadicIntIntCast_proj") (uses := "serre_padic_int_int_cast, serre_padic_projection")
整数 `a` の level `n` 成分は、`a` を `p^(n+1)` で割った通常の剰余類である。
:::

:::theorem "serre_padic_int_int_cast_injective" (lean := "SerreNumberTheoryAI.serrePadicIntIntCast_injective") (uses := "serre_padic_int_int_cast")
`p` が素数なら、この標準環準同型は単射である。
:::

:::proof "serre_padic_int_int_cast_injective"
2つの整数がすべての剰余成分で一致すると、その差は任意に高い `p` の冪で割り切れる。
差が0でないと仮定し、その絶対値より大きい `p` の冪を選ぶと、非零整数が自分の
絶対値より大きい整数で割り切れることになり矛盾する。したがって2つの整数は等しい。
:::
