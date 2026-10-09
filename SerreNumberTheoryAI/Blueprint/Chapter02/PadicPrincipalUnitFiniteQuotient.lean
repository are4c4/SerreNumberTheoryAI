import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotient

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.2 主単数群の有限商" =>

*出典メタデータ:* セール『数論講義』日本語版、第2章・§3.2、
印刷24--25頁（uploaded PDF pages 34--35）。

原典は各主単数群の隣接する層を比較した後、
奇素数の場合の `U₁/Uₘ` と2進の場合の `U₂/Uₘ` を通して
`Z_p` の加法群を逆極限として構成する。

:::definition "principalunitdeepfiltrationsubgroup"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitDeepSubgroup")
後方の層 `U_(n+k+1)` を `U_(n+1)` 内の部分群として定義する。
:::

:::definition "principalunitfinitequotient"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteQuotient")
  (uses := "principalunitdeepfiltrationsubgroup")
原典の有限商 `U_(n+1)/U_(n+k+1)` を定義する。
:::

:::theorem "principalunitfinitequotientpowerbound"
  (uses := "principalunitfinitequotient principalunitpowiterate")
`U_(n+1)/U_(n+k+1)` の全ての元の `p^k` 乗は自明である。
従って有限商の元の位数は `p^k` を割り切る。
:::

```lean "principalunitfinitequotientpowerbound"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientPowerBound
    (p n k : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    ((QuotientGroup.mk' (serrePadicPrincipalUnitDeepSubgroup p n k)) u) ^
        (p ^ k) = 1 :=
  serrePadicPrincipalUnitFiniteQuotient_pow_prime_eq_one p n k u
end SerreNumberTheoryAI
```
