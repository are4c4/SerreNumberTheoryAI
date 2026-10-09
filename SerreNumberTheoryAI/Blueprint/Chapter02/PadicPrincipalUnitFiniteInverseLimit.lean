import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteInverseLimit

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 主単数有限商の逆極限" =>

*出典:* セール『数論講義』§3.2。有限段階の巡回商
`U_(n+1)/U_(n+k+2)` は、自然な射影と整合するため
逆極限の対象を構成する。

:::definition "principalunitfiniteinverselimit"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteInverseLimit")
  (uses := "principalunitcyclictransitionall")
各段階の有限主単数商の直積のうち、隣接段階の射影と
整合する列全体を部分群として定義する。
:::

:::theorem "principalunitfiniteinverselimitmem"
  (uses := "principalunitfiniteinverselimit")
逆極限部分群への所属は、すべての隣接段階での
射影の整合条件と同値である。
:::

```lean "principalunitfiniteinverselimitmem"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteInverseLimitMem
    (p n : ℕ) [Fact p.Prime]
    (x : ∀ k : ℕ, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) :
    x ∈ serrePadicPrincipalUnitFiniteInverseLimit p n ↔
      ∀ k, serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
        (x (k + 1)) = x k :=
  mem_serrePadicPrincipalUnitFiniteInverseLimit p n x
end SerreNumberTheoryAI
```


:::definition "principalunittofiniteinverselimit"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitToFiniteInverseLimit")
  (uses := "principalunitfiniteinverselimit principalunitfinitequotienttransitionmk")
主単数を全ての有限商における剰余類の整合列に送る自然な群準同型を定義する。
同型であることはこの段階ではまだ主張しない。
:::

:::theorem "principalunittofiniteinverselimitapply"
  (uses := "principalunittofiniteinverselimit")
上記準同型の第`k`成分は`U_(n+1)/U_(n+k+2)`への自然な商写像である。
:::

```lean "principalunittofiniteinverselimitapply"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitToFiniteInverseLimitApply
    (p n k : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    ((serrePadicPrincipalUnitToFiniteInverseLimit p n u :
      serrePadicPrincipalUnitFiniteInverseLimit p n) :
      ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u :=
  serrePadicPrincipalUnitToFiniteInverseLimit_apply p n k u
end SerreNumberTheoryAI
```
