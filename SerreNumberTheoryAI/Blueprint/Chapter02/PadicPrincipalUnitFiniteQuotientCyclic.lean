import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientCyclic

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.2 主単数の有限巡回商" =>

*出典メタデータ:* セール『数論講義』第2章 §3.2、印刷24–25頁。

前節までに確立した二つの事実、すなわち有限商の位数と
候補生成元の正確な位数から、有限商は巡回群である。
`ZMod (p^k)` を加法群とみなしたものを
`Multiplicative` で包み、商の乗法群との同型を構成する。

:::definition "principalunitfinitecyclicpresentation"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteQuotientCyclicEquiv")
  (uses := "principalunitfinitequotientgenerator principalunitfinitequotientcard")
`U_(n+1)/U_(n+k+2)` は、原典の範囲で
`Z/p^(k+1)Z` の加法巡回群と同型である。
:::

:::definition "principalunitoddcyclicpresentation"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteQuotientOddCyclicEquiv")
  (uses := "principalunitfinitecyclicpresentation")
奇素数の場合、`1+p` を標準生成元として、
`U₁/U_(k+2) ≃ Z/p^(k+1)Z` を構成する。
:::

:::definition "principalunitdyadiccyclicpresentation"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteQuotientDyadicCyclicEquiv")
  (uses := "principalunitfinitecyclicpresentation")
2進の場合、`1+4` を標準生成元として、
`U₂/U_(k+3) ≃ Z/2^(k+1)Z` を構成する。
:::

これらの同型が有限商の射影と整合すること、および逆極限から
`U₁ ≃ Z_p` または `U₂ ≃ Z_2` を得ることは、次の形式化段階で証明する。
