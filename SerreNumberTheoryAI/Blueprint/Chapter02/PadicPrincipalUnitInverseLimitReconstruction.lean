import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitInverseLimitReconstruction

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 有限商逆極限からの復元" =>

*出典:* セール『数論講義』第2章§3.2。
主単数群を有限巡回商の逆極限と同一視するため、
逆極限の各成分から主単数の代表元を選び、隣接する代表元が
より浅い有限商では等しいことを確認する。

:::definition "principalunitfiniteinverselimitrep"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteInverseLimitRep")
有限商の要素に対応する主単数群内の代表元を選ぶ。
:::

:::theorem "principalunitfiniteinverselimitrepspec"
  (uses := "principalunitfiniteinverselimitrep")
代表元を再び商へ写すと、元の有限商の剰余類が得られる。
:::

```lean "principalunitfiniteinverselimitrepspec"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteInverseLimitRepSpec
    (p n k : ℕ) [Fact p.Prime]
    (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) =
    ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) :=
  serrePadicPrincipalUnitFiniteInverseLimitRep_spec p n k x
end SerreNumberTheoryAI
```

:::theorem "principalunitfiniteinverselimitrepadjacent"
  (uses := "principalunitfiniteinverselimitrepspec principalunitfinitequotienttransitionmk")
隣接する代表元は、浅い側の有限商において同じ剰余類である。
:::

```lean "principalunitfiniteinverselimitrepadjacent"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteInverseLimitRepAdjacent
    (p n k : ℕ) [Fact p.Prime]
    (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) :=
  serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent p n k x
end SerreNumberTheoryAI
```


:::theorem "principalunitfiniteinverselimitrepadjacentresidue"
  (uses := "principalunitfiniteinverselimitrepadjacent principalunitfinitequotientresidueeq")
隣接する主単数の代表元は、適切な法の剰余環でも一致する。
:::

```lean "principalunitfiniteinverselimitrepadjacentresidue"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteInverseLimitRepAdjacentResidue
    (p n k : ℕ) [Fact p.Prime]
    (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicPrincipalUnitResidueHom p n k
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
    serrePadicPrincipalUnitResidueHom p n k
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) :=
  serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent_residue p n k x
end SerreNumberTheoryAI
```

:::theorem "principalunitfiniteinverselimitrepadjacentproj"
  (uses := "principalunitfiniteinverselimitrepadjacentresidue")
隣接代表元の法`p^(n+k+2)`での像が一致する。
:::

:::definition "principalunitfiniteinverselimittopadicint"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteInverseLimitToPadicInt")
  (uses := "principalunitfiniteinverselimitrepadjacentproj")
整合する有限主単数商の代表元の剰余座標を並べ、
project-localな`SerrePadicInt p`の元を構成する。
この段階では単数性・主単数性の証明とは区別する。
:::

:::theorem "principalunitfiniteinverselimittopadicintproj"
  (uses := "principalunitfiniteinverselimittopadicint")
構成した`p`進整数の第`k`剰余成分は選んだ代表元の同じ成分である。
:::

```lean "principalunitfiniteinverselimittopadicintproj"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteInverseLimitToPadicIntProj
    (p n k : ℕ) [Fact p.Prime]
    (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicIntProj p k
      (serrePadicPrincipalUnitFiniteInverseLimitToPadicInt p n x) =
    serrePadicIntProj p k
      (((serrePadicPrincipalUnitFiniteInverseLimitRep p n k x :
        serrePadicPrincipalUnits p (n + 1)) :
        (SerrePadicInt p)ˣ) : SerrePadicInt p) :=
  serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_proj p n k x
end SerreNumberTheoryAI
```
