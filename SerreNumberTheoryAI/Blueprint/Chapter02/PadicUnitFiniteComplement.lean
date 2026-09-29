import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiniteComplement

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 有限単数補群" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§3・3.1、印刷頁22--24（uploaded PDF pages 32--34）。

このページは、単数群のフィルトレーションから有限レベルの補群へ進むための
補助層を記録する。source では有限アーベル群の初等補題を用いて、
剰余単数群と principal-unit tower の coprime-order splitting を取り出す。
AI版形式化では、まず有限剰余単数群
`(Z / p^(n+1) Z)^× → (Z / p Z)^×` に対して、
核と商の位数が互いに素であることを示し、
`(p-1)` 乗して 1 になる元からなる有限補群を定義する。

:::definition "finiteunitreductiontofirst"
  (lean := "SerreNumberTheoryAI.serrePadicResidueUnitReductionToFirst")
有限剰余単数群 `mod p^(n+1)` から第一剰余単数群 `mod p` への還元準同型。
:::

:::theorem "finiteunitreductiontofirstsurjective"
  (uses := "finiteunitreductiontofirst")
有限剰余単数群の還元写像は全射である。
:::

```lean "finiteunitreductiontofirstsurjective"
namespace SerreNumberTheoryAI
theorem blueprint_finiteUnitReductionToFirstSurjective
    (p n : ℕ) [Fact p.Prime] :
    Function.Surjective (serrePadicResidueUnitReductionToFirst p n) :=
  serrePadicResidueUnitReductionToFirst_surjective p n
end SerreNumberTheoryAI
```

:::theorem "firstresidueunitscard"
  (uses := "finiteunitreductiontofirst")
第一剰余単数群の位数は `p - 1` である。
:::

```lean "firstresidueunitscard"
namespace SerreNumberTheoryAI
theorem blueprint_firstResidueUnitsCard
    (p : ℕ) [Fact p.Prime] :
    Nat.card (padicResidueRing p 0)ˣ = p - 1 :=
  serrePadicFirstResidueUnits_card p
end SerreNumberTheoryAI
```

:::theorem "residueunitscard"
  (uses := "finiteunitreductiontofirst")
`mod p^(n+1)` の単数群の位数は `p^n * (p - 1)` である。
:::

```lean "residueunitscard"
namespace SerreNumberTheoryAI
theorem blueprint_residueUnitsCard
    (p n : ℕ) [Fact p.Prime] :
    Nat.card (padicResidueRing p n)ˣ = p ^ n * (p - 1) :=
  serrePadicResidueUnits_card p n
end SerreNumberTheoryAI
```

:::theorem "finiteunitkernelcard"
  (uses := "firstresidueunitscard, residueunitscard")
還元写像の核の位数は `p^n` である。これは source の `U₁/Uₙ₊₁` に対応する有限レベルの核である。
:::

```lean "finiteunitkernelcard"
namespace SerreNumberTheoryAI
theorem blueprint_finiteUnitKernelCard
    (p n : ℕ) [Fact p.Prime] :
    Nat.card (serrePadicResidueUnitReductionToFirst p n).ker = p ^ n :=
  serrePadicResidueUnitReductionToFirst_ker_card p n
end SerreNumberTheoryAI
```

:::theorem "finiteunitkernelcoprime"
  (uses := "finiteunitkernelcard, firstresidueunitscard")
有限レベルの核の位数 `p^n` と第一剰余単数群の位数 `p - 1` は互いに素である。
これが finite abelian splitting supplement を使うための数値条件である。
:::

```lean "finiteunitkernelcoprime"
namespace SerreNumberTheoryAI
theorem blueprint_finiteUnitKernelCoprime
    (p n : ℕ) [Fact p.Prime] :
    Nat.Coprime
      (Nat.card (serrePadicResidueUnitReductionToFirst p n).ker)
      (Nat.card (padicResidueRing p 0)ˣ) :=
  serrePadicResidueUnitReductionToFirst_ker_card_coprime p n
end SerreNumberTheoryAI
```

:::definition "finiteunitcomplement"
  (lean := "SerreNumberTheoryAI.serrePadicFiniteUnitComplement")
  (uses := "finiteunitkernelcoprime")
有限剰余単数群のうち、`(p-1)` 乗して 1 になる元からなる distinguished complement。
:::

:::definition "finiteunitcomplementequiv"
  (lean := "SerreNumberTheoryAI.serrePadicFiniteUnitComplementEquiv")
  (uses := "finiteunitcomplement")
この finite complement は第一剰余単数群へ同型に写る。
:::

:::theorem "finiteunitcomplementunique"
  (uses := "finiteunitcomplementequiv")
第一剰余単数群への還元が全単射になる部分群は、この distinguished complement と一致する。
:::

```lean "finiteunitcomplementunique"
namespace SerreNumberTheoryAI
theorem blueprint_finiteUnitComplementUnique
    (p n : ℕ) [Fact p.Prime]
    (C : Subgroup (padicResidueRing p n)ˣ)
    (hbij :
      Function.Bijective
        ((serrePadicResidueUnitReductionToFirst p n).comp C.subtype)) :
    C = serrePadicFiniteUnitComplement p n :=
  serrePadicFiniteUnitComplement_unique p n C hbij
end SerreNumberTheoryAI
```
