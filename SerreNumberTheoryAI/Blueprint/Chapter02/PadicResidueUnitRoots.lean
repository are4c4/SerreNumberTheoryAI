import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicResidueUnitRoots

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 第一剰余単数の根" =>

有限補群 `V` を p進側で得る前に、第一剰余単数群の側では
`(p-1)` 乗根条件が余分な条件ではないことを確認する。
第一剰余単数群の位数が `p - 1` であるため、すべての剰余単数は
`(p-1)` 乗して 1 になる。

:::theorem "residueunitrootsequalstop"
  (uses := "residueunitrootsofunity, firstresidueunitscard")
第一剰余単数群における roots-of-unity subgroup は、剰余単数群全体である。
:::

```lean "residueunitrootsequalstop"
namespace SerreNumberTheoryAI
theorem blueprint_residueUnitRootsEqualTop
    (p : ℕ) [Fact p.Prime] :
    serreResidueUnitRootsOfUnity p = ⊤ :=
  serreResidueUnitRootsOfUnity_eq_top p
end SerreNumberTheoryAI
```
