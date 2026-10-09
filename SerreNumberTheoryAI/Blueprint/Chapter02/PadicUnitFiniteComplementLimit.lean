import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiniteComplementLimit

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 p進根と有限補群塔の比較" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§3・3.1、印刷頁22--24（uploaded PDF pages 32--34）。

このページは、project p進単元群の `(p-1)` 乗根部分群と、
有限剰余単元群に作った distinguished finite complement の塔を比較する。
具体的には、project 側の根を任意の有限レベルへ還元すると、
その像が有限レベルの補群に入ること、また隣接レベルの遷移写像と整合することを記録する。

:::definition "unitrootsfinitecomplementreduction"
  (lean := "SerreNumberTheoryAI.serrePadicUnitRootsReductionLevelToFiniteComplement")
project 側の `(p-1)` 乗根は、任意の有限レベルの finite complement へ還元できる。
:::

:::theorem "unitrootsfinitecomplementtransition"
  (uses := "unitrootsfinitecomplementreduction")
project 側の根を有限レベルへ還元する写像は、有限補群の隣接 transition と可換である。
:::

```lean "unitrootsfinitecomplementtransition"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsFiniteComplementTransition
    (p n : ℕ) [Fact p.Prime]
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicFiniteUnitComplementTransition p n
        (serrePadicUnitRootsReductionLevelToFiniteComplement p (n + 1) u) =
      serrePadicUnitRootsReductionLevelToFiniteComplement p n u :=
  serrePadicUnitRootsReductionLevelToFiniteComplement_transition p n u
end SerreNumberTheoryAI
```

:::theorem "unitrootsreductionseparation"
  (uses := "unitrootsfinitecomplementreduction")
project 側の根がすべての有限補群レベルで `1` に還元されるなら、
その根自体が `1` である。これは project `Z_p` の成分ごとの extensionality を使う分離性である。
:::

```lean "unitrootsreductionseparation"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsReductionSeparation
    (p : ℕ) [Fact p.Prime]
    (u : serrePadicUnitRootsOfUnity p)
    (hred : ∀ n : ℕ,
      serrePadicUnitRootsReductionLevelToFiniteComplement p n u = 1) :
    u = 1 :=
  serrePadicUnitRoots_eq_one_of_reductions_eq_one p u hred
end SerreNumberTheoryAI
```

:::theorem "unitrootsreductiononepropagation"
  (uses := "unitrootsfinitecomplementtransition")
level `0` の有限補群への還元が `1` なら、有限補群の transition が単射であることから、
すべての有限レベルで還元は `1` になる。
:::

```lean "unitrootsreductiononepropagation"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsReductionOnePropagation
    (p : ℕ) [Fact p.Prime]
    (u : serrePadicUnitRootsOfUnity p)
    (h0 : serrePadicUnitRootsReductionLevelToFiniteComplement p 0 u = 1) :
    ∀ n : ℕ, serrePadicUnitRootsReductionLevelToFiniteComplement p n u = 1 :=
  serrePadicUnitRootsReductionLevelToFiniteComplement_eq_one_of_zero p u h0
end SerreNumberTheoryAI
```

:::theorem "unitrootsprincipalonetrivial"
  (uses := "unitrootsreductionseparation unitrootsreductiononepropagation")
`U_1` に入る project 側の `(p-1)` 乗根は自明である。
これにより、有限補群塔との比較から、根部分群の第一剰余への還元の核が消える。
:::

```lean "unitrootsprincipalonetrivial"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsPrincipalOneTrivial
    (p : ℕ) [Fact p.Prime] :
    ∀ u : serrePadicUnitRootsOfUnity p,
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1 :=
  serrePadicUnitRoots_principal_one_trivial p
end SerreNumberTheoryAI
```

:::theorem "unitrootsreductioninjective"
  (uses := "unitrootsprincipalonetrivial")
したがって、project 側の根部分群から第一剰余単元群への還元は単射である。
:::

```lean "unitrootsreductioninjective"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsReductionInjective
    (p : ℕ) [Fact p.Prime] :
    Function.Injective (serrePadicUnitRootsReduction p) :=
  serrePadicUnitRootsReduction_injective p
end SerreNumberTheoryAI
```

:::theorem "unitrootsresiduerootsreductioninjective"
  (uses := "unitrootsprincipalonetrivial")
同じ単射性は、codomain を第一剰余の根部分群に狭めた還元写像についても成り立つ。
:::

```lean "unitrootsresiduerootsreductioninjective"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsResidueRootsReductionInjective
    (p : ℕ) [Fact p.Prime] :
    Function.Injective (serrePadicUnitRootsReductionToResidueRoots p) :=
  serrePadicUnitRootsReductionToResidueRoots_injective p
end SerreNumberTheoryAI
```

:::theorem "unitrootsreductiontrivialfiber"
  (uses := "unitrootsprincipalonetrivial")
第一剰余単元群への還元で `1` に移る project 側の根は、ちょうど `1` 自身である。
:::

```lean "unitrootsreductiontrivialfiber"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsReductionTrivialFiber
    (p : ℕ) [Fact p.Prime]
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicUnitRootsReduction p u = 1 ↔ u = 1 :=
  serrePadicUnitRootsReduction_eq_one_iff_eq_one p u
end SerreNumberTheoryAI
```

:::theorem "unitrootsreductionkernelbot"
  (uses := "unitrootsreductiontrivialfiber")
第一剰余単元群への還元の kernel は bottom subgroup である。
:::

```lean "unitrootsreductionkernelbot"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsReductionKernelBot
    (p : ℕ) [Fact p.Prime] :
    (serrePadicUnitRootsReduction p).ker = ⊥ :=
  serrePadicUnitRootsReduction_ker_eq_bot p
end SerreNumberTheoryAI
```

:::definition "unitrootsresiduerootsequivofsurjective"
  (uses := "unitrootsresiduerootsreductioninjective")
第一剰余の根部分群への還元が全射であることを別途証明できれば、
すでに得た単射性と合わせて、それは同型として package できる。
:::

```lean "unitrootsresiduerootsequivofsurjective"
namespace SerreNumberTheoryAI
noncomputable def blueprint_unitRootsResidueRootsEquivOfSurjective
    (p : ℕ) [Fact p.Prime]
    (hsurj : Function.Surjective (serrePadicUnitRootsReductionToResidueRoots p)) :
    serrePadicUnitRootsOfUnity p ≃* serreResidueUnitRootsOfUnity p :=
  serrePadicUnitRootsReductionToResidueRootsEquivOfSurjective p hsurj
end SerreNumberTheoryAI
```

:::definition "unitrootsresidueunitsequivofsurjective"
  (uses := "unitrootsresiduerootsequivofsurjective")
さらに第一剰余の根部分群が全第一剰余単元群であることを合成して、
全射性だけを残した `V ≃ (Z/pZ)^×` 型の条件付き同型を得る。
:::

```lean "unitrootsresidueunitsequivofsurjective"
namespace SerreNumberTheoryAI
noncomputable def blueprint_unitRootsResidueUnitsEquivOfSurjective
    (p : ℕ) [Fact p.Prime]
    (hsurj : Function.Surjective (serrePadicUnitRootsReductionToResidueRoots p)) :
    serrePadicUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  serrePadicUnitRootsReductionEquivResidueUnitsOfSurjective p hsurj
end SerreNumberTheoryAI
```

:::definition "finitecomplementtower"
  (lean := "SerreNumberTheoryAI.serrePadicFiniteUnitComplementTowerSubgroup")
有限補群の compatible tower を、各レベルの finite complement の列で、
隣接 transition と整合するものとして定義する。
:::

:::definition "unitrootstofinitecomplementtower"
  (uses := "unitrootsfinitecomplementtransition")
project 側の `(p-1)` 乗根は、各有限レベルへの還元を並べることで、
compatible finite-complement tower を与える。
:::

```lean "unitrootstofinitecomplementtower"
namespace SerreNumberTheoryAI
def blueprint_unitRootsToFiniteComplementTower
    (p : ℕ) [Fact p.Prime] :
    serrePadicUnitRootsOfUnity p →*
      serrePadicFiniteUnitComplementTower p :=
  serrePadicUnitRootsToFiniteComplementTower p
end SerreNumberTheoryAI
```

:::theorem "finitecomplementtowerresiduevalue"
  (uses := "finitecomplementtower")
compatible finite-complement tower を第一剰余根へ送る値は、
どの有限レベルで見ても同じである。
:::

```lean "finitecomplementtowerresiduevalue"
namespace SerreNumberTheoryAI
theorem blueprint_finiteComplementTowerResidueValue
    (p n : ℕ) [Fact p.Prime]
    (x : serrePadicFiniteUnitComplementTower p) :
    serrePadicFiniteUnitComplementResidueRootsEquiv p n
        (serrePadicFiniteUnitComplementTowerProj p n x) =
      serrePadicFiniteUnitComplementResidueRootsEquiv p 0
        (serrePadicFiniteUnitComplementTowerProj p 0 x) :=
  serrePadicFiniteUnitComplementTower_residueRoots_eq_zero p x n
end SerreNumberTheoryAI
```

:::definition "finitecomplementtowerresiduerootsequiv"
  (uses := "finitecomplementtowerresiduevalue")
finite-complement tower 全体は、第一剰余根部分群と標準的に同型である。
これは project 側への持ち上げではなく、有限補群塔そのものの inverse-compatible 構造を package したものである。
:::

```lean "finitecomplementtowerresiduerootsequiv"
namespace SerreNumberTheoryAI
noncomputable def blueprint_finiteComplementTowerResidueRootsEquiv
    (p : ℕ) [Fact p.Prime] :
    serrePadicFiniteUnitComplementTower p ≃*
      serreResidueUnitRootsOfUnity p :=
  serrePadicFiniteUnitComplementTowerEquivResidueRoots p
end SerreNumberTheoryAI
```

:::theorem "unitrootstofinitecomplementtowerinjective"
  (uses := "unitrootstofinitecomplementtower unitrootsreductioninjective")
project 側の根から compatible finite-complement tower への写像は単射である。
したがって、残る inverse-limit bridge はこの写像の全射性に集約される。
:::

```lean "unitrootstofinitecomplementtowerinjective"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsToFiniteComplementTowerInjective
    (p : ℕ) [Fact p.Prime] :
    Function.Injective (serrePadicUnitRootsToFiniteComplementTower p) :=
  serrePadicUnitRootsToFiniteComplementTower_injective p
end SerreNumberTheoryAI
```

:::definition "unitrootstowerequivofsurjective"
  (uses := "unitrootstofinitecomplementtowerinjective")
project 側の根が compatible finite-complement tower 全体へ全射であることを別途示せば、
根部分群はその tower と同型になる。
:::

```lean "unitrootstowerequivofsurjective"
namespace SerreNumberTheoryAI
noncomputable def blueprint_unitRootsTowerEquivOfSurjective
    (p : ℕ) [Fact p.Prime]
    (hsurj : Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p)) :
    serrePadicUnitRootsOfUnity p ≃* serrePadicFiniteUnitComplementTower p :=
  serrePadicUnitRootsEquivFiniteComplementTowerOfSurjective p hsurj
end SerreNumberTheoryAI
```

:::definition "unitrootsresiduerootsequivoftowersurjective"
  (uses := "unitrootstowerequivofsurjective finitecomplementtowerresiduerootsequiv")
上の全射性を仮定すると、project 側の根部分群は第一剰余根部分群と同型になる。
:::

```lean "unitrootsresiduerootsequivoftowersurjective"
namespace SerreNumberTheoryAI
noncomputable def blueprint_unitRootsResidueRootsEquivOfTowerSurjective
    (p : ℕ) [Fact p.Prime]
    (hsurj : Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p)) :
    serrePadicUnitRootsOfUnity p ≃* serreResidueUnitRootsOfUnity p :=
  serrePadicUnitRootsEquivResidueRootsOfTowerSurjective p hsurj
end SerreNumberTheoryAI
```

:::definition "unitrootsresidueunitsequivoftowersurjective"
  (uses := "unitrootsresiduerootsequivoftowersurjective")
さらに第一剰余根部分群と全第一剰余単元群の同型を合成して、
`V ≃ (Z/pZ)^×` 型の条件付き同型を得る。
:::

```lean "unitrootsresidueunitsequivoftowersurjective"
namespace SerreNumberTheoryAI
noncomputable def blueprint_unitRootsResidueUnitsEquivOfTowerSurjective
    (p : ℕ) [Fact p.Prime]
    (hsurj : Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p)) :
    serrePadicUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  serrePadicUnitRootsEquivResidueUnitsOfTowerSurjective p hsurj
end SerreNumberTheoryAI
```


# 有限補群の復元と命題7

有限剰余レベルごとの補群は、射影と整合する元の列から
project `Z_p` の単数として復元できる。
各有限レベルで `(p-1)` 乗が `1` なので、射影の分離性により
復元した単数も `(p-1)` 乗根になる。

:::definition "finitecomplementtowerreconstruction"
  (lean := "SerreNumberTheoryAI.serrePadicFiniteUnitComplementTowerToUnitRoots")
有限補群塔から `(p-1)` 乗根を構成する。
:::

:::theorem "unitrootstofinitecomplementtowersurjective"
  (uses := "finitecomplementtowerreconstruction unitrootstofinitecomplementtower")
project 側の根から有限補群塔への還元写像は全射である。
:::

```lean "unitrootstofinitecomplementtowersurjective"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsToFiniteComplementTowerSurjective
    (p : ℕ) [Fact p.Prime] :
    Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p) :=
  serrePadicUnitRootsToFiniteComplementTower_surjective p
end SerreNumberTheoryAI
```

:::theorem "unitrootsactualreductionsurjective"
  (uses := "unitrootstofinitecomplementtowersurjective unitrootsreductioninjective")
補群 `V` は第一剰余単数群と同じ有限位数を持つ。
根の第一剰余還元は単射なので、有限集合の同位数性から全射でもある。
:::

```lean "unitrootsactualreductionsurjective"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsActualReductionSurjective
    (p : ℕ) [Fact p.Prime] :
    Function.Surjective (serrePadicUnitRootsReduction p) :=
  serrePadicUnitRootsReduction_surjective p
end SerreNumberTheoryAI
```

:::definition "unitrootsactualreductionequiv"
  (lean := "SerreNumberTheoryAI.serrePadicUnitRootsReductionEquiv")
  (uses := "unitrootsactualreductionsurjective")
根の部分群 `V` から第一剰余単数群への実際の還元写像が群同型になる。
:::

:::definition "unitproducthom"
  (lean := "SerreNumberTheoryAI.serrePadicUnitProductHom")
  (uses := "unitrootsactualreductionequiv")
根の部分群と `U_1` を掛け合わせる準同型を定義する。
:::

:::theorem "unitproductsurjective"
  (uses := "unitrootsactualreductionsurjective unitproducthom")
任意の単数 `u` について、同じ第一剰余を持つ根 `v` を選べば、
`v⁻¹u` は `U_1` に属する。したがって任意の単数は両者の積で表せる。
:::

```lean "unitproductsurjective"
namespace SerreNumberTheoryAI
theorem blueprint_unitProductSurjective
    (p : ℕ) [Fact p.Prime] :
    Function.Surjective (serrePadicUnitProductHom p) :=
  serrePadicUnitProductHom_surjective p
end SerreNumberTheoryAI
```

:::definition "unitproductpropositionseven"
  (lean := "SerreNumberTheoryAI.serrePadicUnitsMulEquivRootsProdPrincipal")
  (uses := "unitproductsurjective unitrootsreductioninjective")
命題7。project p進整数の単数群は、有限の `(p-1)` 乗根部分群
`V` と第一主単数群 `U_1` の直積に群同型である。
:::


:::theorem "unitrootsuniquefinitecomplement"
  (uses := "unitrootsactualreductionequiv unitproductpropositionseven")
命題7の一意性。第一剰余単数群への還元が全単射となる部分群は、
`(p-1)` 乗根からなる `V` に限られる。
:::

```lean "unitrootsuniquefinitecomplement"
namespace SerreNumberTheoryAI
theorem blueprint_unitRootsUniqueFiniteComplement
    (p : ℕ) [Fact p.Prime]
    (C : Subgroup (SerrePadicInt p)ˣ)
    (hbij : Function.Bijective
      ((serrePadicUnitReduction p).comp C.subtype)) :
    C = serrePadicUnitRootsOfUnity p :=
  serrePadicUnitRootsOfUnity_unique p C hbij
end SerreNumberTheoryAI
```
