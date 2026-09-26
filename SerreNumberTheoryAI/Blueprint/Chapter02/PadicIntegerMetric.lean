import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricCompletion

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 1.2 p進整数の距離・完備性・稠密性" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§1・1.2・命題3、印刷頁16–17（uploaded PDF pages 26–27）。

この節では、前節までに構成した射影極限としての p進整数と、その上の加法的
p進付値を用いて距離を定める。距離の小ささは高い p の冪で差が割り切れることと
同値であり、したがって有限剰余環への射影が一致することと対応する。この対応から
距離位相が既存の射影極限位相と一致する。完備性はその位相のコンパクト性から従い、
整数の稠密性は任意の有限剰余 level を整数で代表できることから従う。

:::definition "serre_padic_radius" (lean := "SerreNumberTheoryAI.serrePadicRadius")
有限の付値深さ `n` には `exp(-n)`、無限大の付値には `0` を対応させる実数値の重みを定める。
:::

:::definition "serre_padic_int_dist" (lean := "SerreNumberTheoryAI.serrePadicIntDist") (uses := "serre_padic_radius")
二つの p進整数 `x,y` の距離を、差 `x-y` の project-local 加法的付値に上の重みを適用して定める。
:::

:::lemma_ "serre_padic_int_dist_pow_dvd" (lean := "SerreNumberTheoryAI.serrePadicIntDist_le_radius_iff_pow_dvd") (uses := "serre_padic_int_dist")
距離が `exp(-n)` 以下であることと、差が `p^n` で割り切れることは同値である。
:::

:::lemma_ "serre_padic_int_dist_projection" (lean := "SerreNumberTheoryAI.serrePadicIntDist_le_radius_succ_iff_proj_eq") (uses := "serre_padic_int_dist_pow_dvd")
距離が level `n` に対応する半径以下であることは、その level の剰余射影が一致することと同値である。
:::

:::lemma_ "serre_padic_projection_fiber_basis" (lean := "SerreNumberTheoryAI.exists_projFiber_subset_of_mem_open") (uses := "serre_padic_int_dist_projection")
射影極限位相の任意の開近傍は、十分高い一つの有限 level で座標を固定する cylinder を含む。
:::

:::theorem "serre_padic_metric_topology" (lean := "SerreNumberTheoryAI.serrePadicInt_isOpen_iff_dist") (uses := "serre_padic_int_dist_projection, serre_padic_projection_fiber_basis")
射影極限位相の開集合は、上で定めた距離による開集合とちょうど一致する。
:::

:::definition "serre_padic_metric_space" (lean := "SerreNumberTheoryAI.serrePadicIntMetricSpace") (uses := "serre_padic_metric_topology")
上の距離を、既存の射影極限位相を保つ `MetricSpace` として束ねる。
:::

:::theorem "serre_padic_int_complete" (lean := "SerreNumberTheoryAI.serrePadicIntSourceMetricCompleteSpace") (uses := "serre_padic_metric_space")
p進整数はこの距離について完備である。既に得られている射影極限位相のコンパクト性と、
距離位相との一致から一般の「コンパクト距離空間は完備」という事実を適用する。
:::

:::theorem "serre_padic_int_integers_dense" (lean := "SerreNumberTheoryAI.serrePadicIntIntCast_denseRange") (uses := "serre_padic_projection_fiber_basis")
標準埋め込み `ℤ → Z_p` の像は稠密である。
:::

:::proof "serre_padic_int_integers_dense"
空でない開集合 `U` とその点 `x` を取る。射影極限位相の有限 level 基底により、
`x` のある剰余射影 fiber が `U` に含まれる。その level で `x` と同じ剰余類を持つ
整数 `z` を選べば、`z` の標準埋め込みはその fiber、したがって `U` に属する。
よって整数像はすべての空でない開集合と交わり、稠密である。
:::
