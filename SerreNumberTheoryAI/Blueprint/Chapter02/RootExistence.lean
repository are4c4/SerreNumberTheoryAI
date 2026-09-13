import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.RootExistence

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 2.1 有限剰余環からの共通零点の復元" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§2・2.1、印刷頁18–19（uploaded PDF pages 28–29）。

この節では、有限な各剰余levelで方程式系が解けることと、逆極限として構成した
`SerrePadicInt p` 上で同じ方程式系が解けることを結びつける。
Leanでは §1.1 と同じく level `n` が書籍の法 `p^(n+1)` に対応する。

_有限逆極限の非空性._

:::lemma_ "finite_inverse_limit_nonempty" (lean := "SerreNumberTheoryAI.finiteInverseLimit_nonempty")
有向順序で添字づけられた有限・非空な型の逆系を考えると、その互換なsection全体は非空である。
ここでは一般的な有限逆極限のKőnig型補題を、後続のp進方程式に使う形で公開する。
:::

_多項式の有限levelへの還元._

:::definition "padic_polynomial_reduction" (lean := "SerreNumberTheoryAI.padicPolynomialReduction")
`SerrePadicInt p` 係数の多変数多項式の全係数に有限level射影を適用し、
`padicResidueRing p n` 係数の多項式を得る。
:::

:::lemma_ "padic_polynomial_reduction_eval" (lean := "SerreNumberTheoryAI.padicPolynomialReduction_eval") (uses := "padic_polynomial_reduction")
p進整数の組で多項式を評価してからlevel `n` へ射影した値は、
係数と各変数をlevel `n` へ還元して評価した値に一致する。
:::

:::lemma_ "padic_polynomial_reduction_compat" (lean := "SerreNumberTheoryAI.padicPolynomialReduction_compat") (uses := "padic_polynomial_reduction")
level `n+1` へ係数還元した多項式を自然な剰余写像でさらにlevel `n` へ送ると、
初めからlevel `n` へ係数還元した多項式と一致する。
:::

:::definition "padic_reduced_common_zero_set" (lean := "SerreNumberTheoryAI.padicReducedCommonZeroSet") (uses := "padic_polynomial_reduction")
level `n` で、還元された多項式族をすべて0にする点の集合を有限level共通零点集合とする。
:::

:::lemma_ "padic_reduced_common_zero_maps_to_reduction" (lean := "SerreNumberTheoryAI.padicReducedCommonZeroSet_mapsTo_reduction") (uses := "padic_polynomial_reduction_compat, padic_reduced_common_zero_set")
level `n+1` の共通零点を各座標ごとに自然な剰余写像でlevel `n` へ送ると、
還元された方程式族のlevel `n` 共通零点になる。したがって有限levelの零点集合は自然な逆系をなす。
:::

:::definition "padic_approx_common_zero_set" (lean := "SerreNumberTheoryAI.padicApproxCommonZeroSet")
すべての多項式値がlevel `n` で0になるp進整数の組を、level `n` の近似共通零点とする。
:::

_近似集合のコンパクト性による復元._

:::lemma_ "padic_approx_common_zero_set_antitone" (lean := "SerreNumberTheoryAI.padicApproxCommonZeroSet_antitone") (uses := "padic_approx_common_zero_set")
level `n+1` で0になる値は自然な剰余写像によってlevel `n` でも0になるので、
近似共通零点集合はlevelが上がるにつれて包含関係で減少する。
:::

:::lemma_ "padic_approx_common_zero_set_nonempty" (lean := "SerreNumberTheoryAI.padicApproxCommonZeroSet_nonempty_of_reduced") (uses := "padic_reduced_common_zero_set, padic_approx_common_zero_set, padic_polynomial_reduction_eval")
有限levelに共通零点があれば、各座標を §1.1 の全射な射影でp進整数へ持ち上げることで、
対応する近似共通零点集合は非空になる。
:::

:::lemma_ "padic_approx_common_zero_set_closed" (lean := "SerreNumberTheoryAI.padicApproxCommonZeroSet_isClosed") (uses := "padic_reduced_common_zero_set, padic_approx_common_zero_set, padic_polynomial_reduction_eval")
変数集合が有限なら、有限level共通零点集合は有限集合なので閉である。
近似共通零点集合は連続な有限level射影によるその逆像として閉になる。
:::

:::theorem "serre_proposition5_common_zero_iff_reductions" (lean := "SerreNumberTheoryAI.serre_proposition5_commonZero_iff_reductions") (uses := "padic_polynomial_reduction_eval, padic_approx_common_zero_set_antitone, padic_approx_common_zero_set_nonempty, padic_approx_common_zero_set_closed")
素数 `p` と有限個の変数を固定する。`SerrePadicInt p` 係数の任意の多項式族について、
p進整数上に共通零点が存在することと、すべての有限levelで還元族に共通零点が存在することは同値である。
:::

:::proof "serre_proposition5_common_zero_iff_reductions"
一方向はp進共通零点を各有限levelへ射影すればよく、評価と係数還元の可換性を使う。
逆方向では、level `n` ごとにp進整数の組の近似集合 `C_n` を考える。
有限levelの零点から `C_n` の非空性が従い、互換な剰余写像により `C_{n+1} ⊆ C_n`、
また有限levelへの連続射影から各 `C_n` は閉である。§1.1で得たp進整数のコンパクト性により
減少する非空閉集合族の共通部分は非空になる。その共通部分の点では各多項式値の
すべての有限level射影が0なので、射影による外延性から多項式値そのものが0である。
:::
