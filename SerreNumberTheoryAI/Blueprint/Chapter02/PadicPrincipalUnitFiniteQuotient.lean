import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotient

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.2 主単数群の有限商" =>

*出典メタデータ:* セール『数論講義』日本語版、第2章・§3.2、
印刷24--25頁（uploaded PDF pages 34--35）。

原典は各主単数群の隣接する層を比較した後、
奇素数の場合の `U₁/Uₘ` と2進の場合の `U₂/Uₘ` を通して
`Z_p` の加法群を逆極限として構成する。

:::definition "principalunitdeepfiltrationsubgroup"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitDeepSubgroup")
後方の層 `U_(n+k+1)` を `U_(n+1)` 内の部分群として定義する。
:::

:::definition "principalunitfinitequotient"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitFiniteQuotient")
  (uses := "principalunitdeepfiltrationsubgroup")
原典の有限商 `U_(n+1)/U_(n+k+1)` を定義する。
:::

:::theorem "principalunitfinitequotientpowerbound"
  (uses := "principalunitfinitequotient principalunitpowiterate")
`U_(n+1)/U_(n+k+1)` の全ての元の `p^k` 乗は自明である。
従って有限商の元の位数は `p^k` を割り切る。
:::

```lean "principalunitfinitequotientpowerbound"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientPowerBound
    (p n k : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    ((QuotientGroup.mk' (serrePadicPrincipalUnitDeepSubgroup p n k)) u) ^
        (p ^ k) = 1 :=
  serrePadicPrincipalUnitFiniteQuotient_pow_prime_eq_one p n k u
end SerreNumberTheoryAI
```


:::theorem "principalunitfinitequotientexactorder"
  (uses := "principalunitfinitequotientpowerbound principalunitexactpoweriterate")
原典の範囲で、次層に属さない主単数の有限商での位数は
ちょうど `p^(k+1)` となる。冪の上界と、ひとつ前の冪が
さらに深い層に属さないことを組み合わせる。
:::

```lean "principalunitfinitequotientexactorder"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientExactOrder
    (p n k : ℕ) [Fact p.Prime] (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    orderOf
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) =
      p ^ (k + 1) :=
  serrePadicPrincipalUnitFiniteQuotient_exact_order p n k hsource u hnot
end SerreNumberTheoryAI
```

:::theorem "principalunitfinitequotientoddgenerator"
  (uses := "principalunitfinitequotientexactorder principalunitlevelonegenerator")
奇素数の `U₁/U_(k+2)` で、`1+p` の像の位数は `p^(k+1)`。
:::

```lean "principalunitfinitequotientoddgenerator"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientOddGenerator
    (p k : ℕ) [Fact p.Prime] (hpodd : p ≠ 2) :
    orderOf
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p 0 (k + 1)))
        (serrePadicPrincipalUnitOfCoeff p 0 1)) =
      p ^ (k + 1) :=
  serrePadicPrincipalUnitFiniteQuotient_odd_generator_order p hpodd k
end SerreNumberTheoryAI
```

:::theorem "principalunitfinitequotientleveltwogenerator"
  (uses := "principalunitfinitequotientexactorder principalunitleveltwogenerator")
特に2進で用いる `U₂/U_(k+3)` の候補生成元 `1+p²` の位数も
`p^(k+1)` となる。
:::

```lean "principalunitfinitequotientleveltwogenerator"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientLevelTwoGenerator
    (p k : ℕ) [Fact p.Prime] :
    orderOf
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p 1 (k + 1)))
        (serrePadicPrincipalUnitOfCoeff p 1 1)) =
      p ^ (k + 1) :=
  serrePadicPrincipalUnitFiniteQuotient_levelTwo_generator_order p k
end SerreNumberTheoryAI
```
