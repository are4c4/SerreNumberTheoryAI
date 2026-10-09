import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientTransition

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 有限主単数商の射影" =>

*出典メタデータ:* セール『数論講義』日本語版、§3.2、
印刷24–25頁。逆極限の構成に向けて、
有限商 `U_(n+1)/U_(n+k+1)` を自然な射影で結ぶ。

:::theorem "principalunitfinitequotienttransitioninclusion"
  (uses := "principalunitfinitequotientpowerbound")
より深い層で割る部分群は、浅い層で割る部分群に含まれる。
:::

```lean "principalunitfinitequotienttransitioninclusion"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitDeepSubgroupInclusion
    (p n k : ℕ) [Fact p.Prime] :
    serrePadicPrincipalUnitDeepSubgroup p n (k + 1) ≤
      serrePadicPrincipalUnitDeepSubgroup p n k :=
  serrePadicPrincipalUnitDeepSubgroup_succ_le p n k
end SerreNumberTheoryAI
```

:::definition "principalunitfinitequotienttransition"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteQuotientTransition")
  (uses := "principalunitfinitequotienttransitioninclusion")
隣接する有限商を結ぶ自然な群準同型を定義する。
:::

:::theorem "principalunitfinitequotienttransitionmk"
  (uses := "principalunitfinitequotienttransition")
射影写像は、元の主単数の剰余類を同じ元の浅い商での剰余類へ写す。
:::

```lean "principalunitfinitequotienttransitionmk"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientTransitionMk
    (p n k : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    serrePadicPrincipalUnitFiniteQuotientTransition p n k
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) =
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n k)) u) :=
  serrePadicPrincipalUnitFiniteQuotientTransition_mk p n k u
end SerreNumberTheoryAI
```
