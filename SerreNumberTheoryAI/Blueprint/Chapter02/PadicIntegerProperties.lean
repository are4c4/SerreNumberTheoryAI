import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerValuationAPI

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 1.2 p進整数の代数的性質" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§1・1.2、印刷頁16–17（uploaded PDF pages 26–27）。

前節で構成した `SerrePadicInt p` を使い、有限剰余環への射影の核、単元、
`p` の冪による分解、そしてその分解から得られる加法的p進付値を整理する。
ここではmetric・完備性・整数の稠密性は扱わず、後続のProposition 3に相当する別sliceへ分離する。

Lean側ではlevel `n` が `ℤ / p^(n+1)ℤ` を表すため、書籍の正の添字と1だけずれる。
したがってlevel `n` の射影核は `p^(n+1)` で生成されるイデアルになる。

**有限剰余環への射影と商.**

:::theorem "serre_padic_projection_kernel_power"
  (lean := "SerreNumberTheoryAI.ker_serrePadicIntProj_eq_span_pow")
  (uses := "serre_padic_projection")
素数 `p` に対し、level `n` の射影の核は `p^(n+1)` が生成する主イデアルに一致する。
:::

:::definition "serre_padic_quotient_power_equiv"
  (lean := "SerreNumberTheoryAI.serrePadicIntQuotientPowEquiv")
  (uses := "serre_padic_projection_kernel_power, serre_padic_projection_surjective")
したがって `SerrePadicInt p` を `p^(n+1)` の倍数で割った商環は、
level `n` の有限剰余環と自然に環同型になる。
:::

:::proof "serre_padic_projection_kernel_power"
射影で0になることと `p^(n+1)` で割り切れることを、整合列の座標を1段ずつ
`p` で割る構成によって往復させる。射影の全射性と第一同型定理を組み合わせると
商環の記述が得られる。
:::

**単元と `p` の倍数.**

:::theorem "serre_padic_unit_iff_not_p_divisible"
  (lean := "SerreNumberTheoryAI.serrePadicInt_isUnit_iff_not_p_dvd")
  (uses := "serre_padic_projection_kernel_power")
`SerrePadicInt p` の元は、`p` で割り切れないことと単元であることが同値である。
同値な判定として、最初の剰余成分が0でないことを用いることができる。
:::

:::proof "serre_padic_unit_iff_not_p_divisible"
最初の剰余成分が単元なら、整合性を使って全ての高いlevelでも単元であることを示し、
各座標の逆元から再び整合列を作る。逆に全体が単元なら任意の環準同型で像も単元なので、
最初の剰余成分は0にはならない。さらに最初の成分が0であることと `p` で割り切れることを結ぶ。
:::

**非零元の `p^n` と単元への分解.**

:::definition "serre_padic_order"
  (lean := "SerreNumberTheoryAI.serrePadicIntOrder")
  (uses := "serre_padic_projection")
非零元 `x` に対し、最初に `x` を非零として検出する剰余levelを `serrePadicIntOrder` とする。
このlevelより下では全ての剰余成分が0であり、そのlevel自身では0でない。
:::

:::theorem "serre_padic_pow_unit_decomposition"
  (lean := "SerreNumberTheoryAI.existsUnique_pow_unitPair_of_ne_zero")
  (uses := "serre_padic_order, serre_padic_unit_iff_not_p_divisible")
非零の `x : SerrePadicInt p` は一意的に `x = p^n u` と書ける。
ここで `n : ℕ`、`u` は単元であり、指数だけでなく単元因子も一意である。
:::

:::proof "serre_padic_pow_unit_decomposition"
最初の非零levelを `n` とする。より低いlevelが全て0なので `p^n ∣ x` が得られ、
商を `u` とする。もしさらに `p ∣ u` なら `p^(n+1) ∣ x` となり、
level `n` が非零であることに反するため `u` は単元である。
2つの分解があれば、小さい方の指数の `p` の冪を消去し、単元が `p` の倍数にはなれないことから
指数が一致する。`p^n` 倍写像の単射性で単元因子も一致する。
:::

**p進付値.**

:::definition "serre_padic_add_valuation"
  (lean := "SerreNumberTheoryAI.serrePadicIntAddValuation")
  (uses := "serre_padic_pow_unit_decomposition")
`0` には `⊤`、非零の `p^n u` には指数 `n` を割り当てる加法的付値を考える。
Leanでは、project内で `p` が素元であることを先に証明し、一般的なprime-multiplicityの
`AddValuation` 構成を利用してこれを実装する。
:::

:::lemma_ "serre_padic_add_valuation_zero"
  (lean := "SerreNumberTheoryAI.serrePadicIntAddValuation_zero")
  (uses := "serre_padic_add_valuation")
`0` の付値は `⊤` である。
:::

:::theorem "serre_padic_power_divides_iff_valuation"
  (lean := "SerreNumberTheoryAI.serrePadicInt_pow_dvd_iff_le_addValuation")
  (uses := "serre_padic_add_valuation")
`p^n` が `x` を割ることと、付値が少なくとも `n` であることは同値である。
:::

:::theorem "serre_padic_add_valuation_mul"
  (lean := "SerreNumberTheoryAI.serrePadicIntAddValuation_mul")
  (uses := "serre_padic_add_valuation")
積の付値は付値の和である。
:::

:::theorem "serre_padic_add_valuation_add"
  (lean := "SerreNumberTheoryAI.serrePadicIntAddValuation_add")
  (uses := "serre_padic_add_valuation")
和の付値は2つの付値の小さい方以上である。
:::

**整域性.**

:::theorem "serre_padic_integral_domain"
  (lean := "SerreNumberTheoryAI.serrePadicInt_isDomain")
  (uses := "serre_padic_pow_unit_decomposition")
素数 `p` に対し、project-localなp進整数環 `SerrePadicInt p` は整域である。
:::

:::proof "serre_padic_integral_domain"
非零の2元をそれぞれ `p^m u`, `p^n v` と分解すると、その積は
`p^(m+n) (uv)` になる。`uv` は単元で、有限levelを調べれば `p` の正の冪も0ではない。
したがって非零元どうしの積が0になることはなく、零因子は存在しない。
:::
