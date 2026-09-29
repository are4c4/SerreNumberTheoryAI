import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltration

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 単数群のフィルトレーション" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§3・3.1、印刷頁22--24（uploaded PDF pages 32--34）。

この節では、p進整数環 の単数群 `U` を、1 に近い単数の列 `U_n` によって調べる。
AI版形式化では、まず project-local な `SerrePadicInt` の単数群上で、有限剰余環への
還元写像の核として `U_n` を定義する。これにより、剰余写像・核・商群の標準 API を使って
最初の商 `U/U₁` を有限剰余環の単数群へ結びつける。

:::definition "padicunitreductionlevel"
  (lean := "SerreNumberTheoryAI.serrePadicUnitReductionLevel")
有限剰余レベル `n` への射影 `Z_p → Z/p^(n+1)Z` を単数に制限し、
`U → (Z/p^(n+1)Z)^×` という群準同型を得る。
:::

:::definition "padicprincipalunits"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnits")
source-indexed な principal-unit filtration を定義する。
`U₀` は単数群全体、`Uₙ₊₁` はレベル `n` の単数還元写像の核である。
:::

:::lemma_ "padicprincipalunitsmembership"
  (lean := "SerreNumberTheoryAI.mem_serrePadicPrincipalUnits_succ_iff_pow_dvd")
  (uses := "padicprincipalunits")
`u ∈ U_(n+1)` であることは、`u - 1` が `p^(n+1)` で割り切れることと同値である。
これは、kernel 表現と source の 1 に p の n+1 乗の倍数を加えた形 表現を結ぶ基本変換である。
:::

:::definition "padicunitreductionfirst"
  (lean := "SerreNumberTheoryAI.serrePadicUnitReduction")
  (uses := "padicunitreductionlevel")
最初の剰余単数群への還元写像 `U → (Z/pZ)^×` を、project の剰余レベル `0` で表す。
:::

:::lemma_ "padicunitreductionsurjective"
  (lean := "SerreNumberTheoryAI.serrePadicUnitReduction_surjective")
  (uses := "padicunitreductionfirst")
剰余射影の全射性と一階剰余での単元判定を用いて、任意の `mod p` 単数を
p進整数環 の単数へ持ち上げる。
:::

:::theorem "padicunitsfirstquotient"
  (lean := "SerreNumberTheoryAI.serrePadicUnitsQuotientPrincipalOneEquiv")
  (uses := "padicprincipalunits, padicunitreductionsurjective")
第一同型定理により、最初の商 `U/U₁` は `(Z/pZ)^×` と同型になる。
後続では、これを successive quotient と finite complement の議論の入口として使う。
:::
