import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFieldRoots

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 Qpにおける1の冪根の系" =>

*出典メタデータ:* セール『数論講義』日本語版、第2章・§3・3.1、
印刷24ページ（uploaded PDF page 34）。

命題7で `Z_p` の `(p-1)` 乗根の部分群 `V` が
第一剰余単数群と同型であることを確立した。
project `Z_p` をその分数体 `Q_p` に単射で埋め込めば、
`V` の各元は引き続き相異なる `(p-1)` 乗根となる。
第一剰余単数群の位数は `p-1` だから、この方法で
`p-1` 個の相異なる冪根を得る。

:::definition "padicfieldrootmap"
  (lean := "SerreNumberTheoryAI.serrePadicUnitRootsToField")
  (uses := "unitproductpropositionseven")
project `Z_p` の `(p-1)` 乗根を、分数体 `Q_p` の単数群へ送る。
:::

:::theorem "padicfieldrootmapinjective"
  (uses := "padicfieldrootmap")
整数環から分数体への標準埋め込みが単射であるため、
異なる根は分数体でも異なる。
:::

```lean "padicfieldrootmapinjective"
namespace SerreNumberTheoryAI
theorem blueprint_padicFieldRootsInjection
    (p : ℕ) [Fact p.Prime] :
    Function.Injective (serrePadicUnitRootsToField p) :=
  serrePadicUnitRootsToField_injective p
end SerreNumberTheoryAI
```

:::theorem "padicfieldrootspow"
  (uses := "padicfieldrootmap")
project `Z_p` における `(p-1)` 乗根は、分数体 `Q_p` でも
同じ根の条件を満たす。
:::

```lean "padicfieldrootspow"
namespace SerreNumberTheoryAI
theorem blueprint_padicFieldRootsPow
    (p : ℕ) [Fact p.Prime]
    (u : serrePadicUnitRootsOfUnity p) :
    (serrePadicUnitRootsToField p u) ^ (p - 1) = 1 :=
  serrePadicUnitRootsToField_pow p u
end SerreNumberTheoryAI
```

:::theorem "padicfieldrootsexistcorollary"
  (uses := "padicfieldrootspow padicfieldrootmapinjective unitrootsactualreductionequiv")
原典の系。第一剰余単数群の `p-1` 個の元によって
`Q_p` 内の互いに異なる `(p-1)` 乗根を添字付けできる。
:::

```lean "padicfieldrootsexistcorollary"
namespace SerreNumberTheoryAI
theorem blueprint_padicFieldRootsCorollary
    (p : ℕ) [Fact p.Prime] :
    ∃ f : (padicResidueRing p 0)ˣ ↪ (SerrePadicField p)ˣ,
      Nat.card (padicResidueRing p 0)ˣ = p - 1 ∧
        ∀ a, (f a) ^ (p - 1) = 1 :=
  serrePadicField_contains_p_sub_one_roots p
end SerreNumberTheoryAI
```
