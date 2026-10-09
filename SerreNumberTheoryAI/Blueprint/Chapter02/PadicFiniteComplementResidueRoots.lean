import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicFiniteComplementResidueRoots

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "Chapter 2 section 3.1 finite complement residue roots" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§3・3.1、印刷頁22--24（uploaded PDF pages 32--34）。

このページは、有限剰余単数群の distinguished complement と、
第一剰余環での `(p-1)` 乗根部分群を比較する。前段で finite complement は
第一剰余単数群に同型であり、第一剰余の `(p-1)` 乗根は全ての第一剰余単数と
一致することを示した。ここではその2つを合成し、各有限レベルの補群を
第一剰余根部分群へ同型化する。

:::definition "finiteunitcomplementresiduerootsequiv"
  (lean := "SerreNumberTheoryAI.serrePadicFiniteUnitComplementResidueRootsEquiv")
有限レベルの finite complement は、第一剰余の `(p-1)` 乗根部分群と同型である。
:::

:::theorem "finiteunitcomplementresiduerootsequivtransition"
  (uses := "finiteunitcomplementresiduerootsequiv")
隣接 finite-complement transition は、この第一剰余根部分群への同型と整合する。
:::

```lean "finiteunitcomplementresiduerootsequivtransition"
namespace SerreNumberTheoryAI
theorem blueprint_finiteUnitComplementResidueRootsEquivTransition
    (p n : ℕ) [Fact p.Prime]
    (u : serrePadicFiniteUnitComplement p (n + 1)) :
    serrePadicFiniteUnitComplementResidueRootsEquiv p n
      (serrePadicFiniteUnitComplementTransition p n u) =
        serrePadicFiniteUnitComplementResidueRootsEquiv p (n + 1) u :=
  serrePadicFiniteUnitComplementResidueRootsEquiv_transition p n u
end SerreNumberTheoryAI
```
