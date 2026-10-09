import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientCard

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.2 主単数群の有限商の位数と巡回性" =>

*出典メタデータ:* セール『数論講義』日本語版、第2章・§3.2、印刷24–25頁。

隣接商 `U_(n+1)/U_(n+2)` は有限体の加法群と同型で、
元の個数は `p` である。部分群の指数の乗法性によって、
より深い商 `U_(n+1)/U_(n+k+1)` の元の個数は `p^k` となる。
これと厳密な`p`乗上昇の補題を合わせると、
最初の層の元が有限商全体を生成することが従う。

:::theorem "principalunitadjacentrelindex"
  (uses := "principalunitfinitequotient principalunitexactlayercriterion")
隣接する主単数層の相対指数は `p` である。
:::

```lean "principalunitadjacentrelindex"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitAdjacentRelIndex
    (p n : ℕ) [Fact p.Prime] :
    (serrePadicPrincipalUnits p (n + 2)).relIndex
      (serrePadicPrincipalUnits p (n + 1)) = p :=
  serrePadicPrincipalUnits_adjacent_relIndex p n
end SerreNumberTheoryAI
```

:::theorem "principalunitdeeprelindex"
  (uses := "principalunitadjacentrelindex")
相対指数の乗法性により、
`[U_(n+1):U_(n+k+1)] = p^k` が成り立つ。
:::

```lean "principalunitdeeprelindex"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitDeepRelIndex
    (p n k : ℕ) [Fact p.Prime] :
    (serrePadicPrincipalUnits p (n + k + 1)).relIndex
      (serrePadicPrincipalUnits p (n + 1)) = p ^ k :=
  serrePadicPrincipalUnits_deep_relIndex p n k
end SerreNumberTheoryAI
```

:::theorem "principalunitfinitequotientcard"
  (uses := "principalunitdeeprelindex principalunitfinitequotient")
任意の有限商 `U_(n+1)/U_(n+k+1)` には `p^k` 個の元がある。
:::

```lean "principalunitfinitequotientcard"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientCard
    (p n k : ℕ) [Fact p.Prime] :
    Nat.card (serrePadicPrincipalUnitFiniteQuotient p n k) = p ^ k :=
  serrePadicPrincipalUnitFiniteQuotient_card p n k
end SerreNumberTheoryAI
```

:::theorem "principalunitfinitequotientgenerator"
  (uses := "principalunitfinitequotientcard principalunitfinitequotientexactorder")
原典の許容範囲で第一層に属する元が作る巡回部分群は
商全体と同じ位数 `p^(k+1)` を持ち、有限商全体を生成する。
この結論は「部分群の位数」だけでなく商全体の巡回性を与える。
:::

```lean "principalunitfinitequotientgenerator"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientGenerator
    (p n k : ℕ) [Fact p.Prime] (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    Subgroup.zpowers
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) = ⊤ :=
  serrePadicPrincipalUnitFiniteQuotient_generator_zpowers_eq_top
    p n k hsource u hnot
end SerreNumberTheoryAI
```
