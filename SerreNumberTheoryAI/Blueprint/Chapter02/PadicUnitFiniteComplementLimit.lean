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
