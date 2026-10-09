import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitDyadicSign

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 2進主単数群の符号" =>

*出典:* セール『数論講義』第2章§3.2、印刷25頁。
2進の場合の`U₁ = {±1} × U₂`を導くため、
まず`-1`が`U₁`の元で`U₂`には属さないことを確かめる。
この補題は符号部分群の分解そのものとは区別する。

:::definition "dyadicnegativeoneprincipal"
  (lean := "SerreNumberTheoryAI.serrePadicDyadicNegOnePrincipal")
`-1 ≡ 1 (mod 2)`を用いて`-1`を`U₁`の元とする。
:::

:::theorem "dyadicnegativeoneprincipalsquare"
  (uses := "dyadicnegativeoneprincipal")
符号元の平方は1である。
:::

```lean "dyadicnegativeoneprincipalsquare"
namespace SerreNumberTheoryAI
theorem blueprint_dyadicNegOnePrincipalSquare :
    (serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) ^ 2 = 1 :=
  serrePadicDyadicNegOnePrincipal_sq
end SerreNumberTheoryAI
```

:::theorem "dyadicnegativeoneprincipalnotleveltwo"
  (uses := "dyadicnegativeoneprincipal")
`-1`は`U₂`に属さない。
:::

```lean "dyadicnegativeoneprincipalnotleveltwo"
namespace SerreNumberTheoryAI
theorem blueprint_dyadicNegOnePrincipalNotLevelTwo :
    ((serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) : (SerrePadicInt 2)ˣ) ∉
      serrePadicPrincipalUnits 2 2 :=
  serrePadicDyadicNegOnePrincipal_not_mem_levelTwo
end SerreNumberTheoryAI
```

:::theorem "dyadicnegativeoneprincipalquotientnontrivial"
  (uses := "dyadicnegativeoneprincipalnotleveltwo")
符号元は2元商`U₁/U₂`で非自明な剰余類を表す。
:::
