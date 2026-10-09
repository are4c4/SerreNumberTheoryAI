import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitPowerStep

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.2 主単数群とp乗によるフィルトレーション" =>

*出典メタデータ:* セール『数論講義』日本語版、
第2章・§3・3.2、印刷24–25ページ（uploaded PDF pages 34–35）。

主単数群 `U_n` の冪による遷移を示すため、
まず隣接するフィルトレーション層の判定と、
二項展開の各項に必要な指数の不等式を用意する。
以下の結果は、後続の「p乗がちょうど次の層に進む」という補題の
準備であり、命題8の証明が完成したという意味ではない。

:::theorem "principalunitexactlayercriterion"
  (uses := "unitproductpropositionseven")
`U_(n+1)` の元が `U_(n+2)` に入らないことは、その係数の第一剰余が非零であることと同値。
:::

```lean "principalunitexactlayercriterion"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitExactLayerCriterion
    (p n : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    ((u : (SerrePadicInt p)ˣ) ∉ serrePadicPrincipalUnits p (n + 2)) ↔
      serrePadicPrincipalUnitCoeffResidue p n u ≠ 0 :=
  serrePadicPrincipalUnit_exactLayer_iff_coeff_ne_zero p n u
end SerreNumberTheoryAI
```

:::theorem "principalunitexactlayerwitness"
  (uses := "principalunitexactlayercriterion")
各正の層には、次の層に入らない具体的な単数 `1+p^(n+1)` が存在する。
:::

```lean "principalunitexactlayerwitness"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitExactLayerWitness
    (p n : ℕ) [Fact p.Prime] :
    ((serrePadicPrincipalUnitOfCoeff p n 1 :
        serrePadicPrincipalUnits p (n + 1)) : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2) :=
  serrePadicPrincipalUnitOfCoeff_one_exactLayer p n
end SerreNumberTheoryAI
```

:::theorem "principalunitmiddlebound"
  (uses := "principalunitexactlayercriterion")
二項係数が `p` で割れる中間項の指数評価。
:::

```lean "principalunitmiddlebound"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitMiddleBound
    (n i : ℕ) (hn : 1 ≤ n) (hi : 2 ≤ i) :
    n + 2 ≤ n * i + 1 :=
  serrePadicPowerStep_middle_exponent_bound n i hn hi
end SerreNumberTheoryAI
```

:::theorem "principalunitlastbound"
  (uses := "principalunitmiddlebound")
二項展開の最終項は、`p≠2` で `n≥1`、`p=2` で `n≥2` なら十分高い冪で割れる。
:::

```lean "principalunitlastbound"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitLastBound
    (p n : ℕ) [Fact p.Prime]
    (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n) :
    n + 2 ≤ n * p :=
  serrePadicPowerStep_last_exponent_bound p n hn hsource
end SerreNumberTheoryAI
```


:::theorem "principalunitpowmemnext"
  (uses := "principalunitexactlayercriterion")
`U_(n+1)` の任意の元の `p` 乗は `U_(n+2)` に入る。
これは層の係数剰余が `F_p` の加法群に値をとることによる、
原典の冪に関する補題の弱い方向である。
:::

```lean "principalunitpowmemnext"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitPowMemNext
    (p n : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    ((u : (SerrePadicInt p)ˣ) ^ p) ∈
      serrePadicPrincipalUnits p (n + 2) :=
  serrePadicPrincipalUnit_pow_prime_mem_next p n u
end SerreNumberTheoryAI
```


:::theorem "principalunitmiddlechoosedvd"
  (uses := "principalunitmiddlebound")
素数 `p` の二項展開において `0<i<p` ならば `p` が `p.choose i` を割り切る。
各中間項のp進位数を1だけ引き上げる算術的な根拠となる。
:::

```lean "principalunitmiddlechoosedvd"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitMiddleChooseDvd
    (p i : ℕ) [Fact p.Prime] (hi0 : 0 < i) (hip : i < p) :
    p ∣ Nat.choose p i :=
  serrePadicPowerStep_middle_choose_dvd p i hi0 hip
end SerreNumberTheoryAI
```


:::theorem "principalunitmiddletermdivisibility"
  (uses := "principalunitmiddlechoosedvd principalunitmiddlebound")
`(1+p^n a)^p` の二項展開の中間項は、
`n≥1`、`2≤i<p` ならば `p^(n+2)` で割り切れる。
:::

```lean "principalunitmiddletermdivisibility"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitMiddleTermDivisibility
    (p n i : ℕ) [Fact p.Prime] (hn : 1 ≤ n) (hi : 2 ≤ i)
    (hip : i < p) (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      (Nat.choose p i : SerrePadicInt p) *
        ((p : SerrePadicInt p) ^ n * a) ^ i :=
  serrePadicPowerStep_middle_term_dvd p n i hn hi hip a
end SerreNumberTheoryAI
```

:::theorem "principalunitlasttermdivisibility"
  (uses := "principalunitlastbound")
同じ二項展開の最終項が `p^(n+2)` で割れるための
ソースに記載された指数条件を確認する。
:::

```lean "principalunitlasttermdivisibility"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitLastTermDivisibility
    (p n : ℕ) [Fact p.Prime] (hn : 1 ≤ n)
    (hsource : p ≠ 2 ∨ 2 ≤ n) (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      ((p : SerrePadicInt p) ^ n * a) ^ p :=
  serrePadicPowerStep_last_term_dvd p n hn hsource a
end SerreNumberTheoryAI
```
