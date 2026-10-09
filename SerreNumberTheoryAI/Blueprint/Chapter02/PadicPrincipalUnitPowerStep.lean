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


:::theorem "principalunitpowiterate"
  (uses := "principalunitpowmemnext")
主単数を繰り返し `p` 乗すると、その都度フィルトレーションの次の層へ入る。
将来の有限商の位数の評価に用いる。
:::

```lean "principalunitpowiterate"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitPowIterate
    (p n k : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    ((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
      serrePadicPrincipalUnits p (n + k + 1) :=
  serrePadicPrincipalUnit_pow_prime_iterate_mem p n k u
end SerreNumberTheoryAI
```


:::theorem "principalunithightermdivisibility"
  (uses := "principalunitmiddletermdivisibility principalunitlasttermdivisibility")
原典で必要な条件下で、二項展開の次数 `2≤i≤p` の項は
いずれも `p^(n+2)` で割り切れる。
:::

```lean "principalunithightermdivisibility"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitHighTermDivisibility
    (p n i : ℕ) [Fact p.Prime] (hn : 1 ≤ n)
    (hsource : p ≠ 2 ∨ 2 ≤ n) (hi : 2 ≤ i) (hip : i ≤ p)
    (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      (Nat.choose p i : SerrePadicInt p) *
        ((p : SerrePadicInt p) ^ n * a) ^ i :=
  serrePadicPowerStep_high_term_dvd p n i hn hsource hi hip a
end SerreNumberTheoryAI
```

:::theorem "principalunithightermssumdivisibility"
  (uses := "principalunithightermdivisibility")
次数 `2` から `p` までの二項展開の高次項を全て足した余りも
`p^(n+2)` で割り切れる。次の合同式のための余剰評価である。
:::

```lean "principalunithightermssumdivisibility"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitHighTermsSumDivisibility
    (p n : ℕ) [Fact p.Prime]
    (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n)
    (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      ∑ i ∈ Finset.Icc 2 p,
        (Nat.choose p i : SerrePadicInt p) *
          ((p : SerrePadicInt p) ^ n * a) ^ i :=
  serrePadicPowerStep_high_terms_sum_dvd p n hn hsource a
end SerreNumberTheoryAI
```


:::theorem "principalunitbinomialcongruence"
  (uses := "principalunithightermssumdivisibility")
原典の補題で用いる中心的な合同式。
`p≠2,n≥1`、または`p=2,n≥2`のもとで
`(1+p^n a)^p ≡ 1+p^(n+1)a (mod p^(n+2))` が成り立つ。
ここではフィルトレーションへの所属条件をまだ使わずに、
二項展開の計算そのものを独立に記録する。
:::

```lean "principalunitbinomialcongruence"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitBinomialCongruence
    (p n : ℕ) [Fact p.Prime] (hn : 1 ≤ n)
    (hsource : p ≠ 2 ∨ 2 ≤ n) (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      ((1 + (p : SerrePadicInt p) ^ n * a) ^ p -
        (1 + (p : SerrePadicInt p) ^ (n + 1) * a)) :=
  serrePadicPowerStep_binomial_congr_dvd p n hn hsource a
end SerreNumberTheoryAI
```


:::theorem "principalunitcancelpowdivisibility"
  (uses := "principalunitbinomialcongruence")
`p^(n+2)` が `p^(n+1)a` を割るならば、`p` が `a` を割る。
project `Z_p` 内で `p` の冪が非零因子であるという既存の証明を利用する。
:::

```lean "principalunitcancelpowdivisibility"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitCancelPowDivisibility
    (p n : ℕ) [Fact p.Prime] (a : SerrePadicInt p)
    (hdiv : (p : SerrePadicInt p) ^ (n + 2) ∣
      (p : SerrePadicInt p) ^ (n + 1) * a) :
    (p : SerrePadicInt p) ∣ a :=
  serrePadicPowerStep_cancel_pow_dvd p n a hdiv
end SerreNumberTheoryAI
```


:::theorem "principalunitexactpowerstep"
  (uses := "principalunitbinomialcongruence principalunitcancelpowdivisibility principalunitpowmemnext principalunitexactlayercriterion")
原典の補題。添字をprojectの`U_(n+1)`に合わせた形で、
`u∈U_(n+1)＼U_(n+2)`なら`u^p∈U_(n+2)＼U_(n+3)`となる。
奇素数には`n≥0`、`p=2`には`n≥1`を仮定する。
:::

```lean "principalunitexactpowerstep"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitExactPowerStep
    (p n : ℕ) [Fact p.Prime] (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    ((u : (SerrePadicInt p)ˣ) ^ p ∈
        serrePadicPrincipalUnits p (n + 2)) ∧
      ((u : (SerrePadicInt p)ˣ) ^ p ∉
        serrePadicPrincipalUnits p (n + 3)) :=
  serrePadicPrincipalUnit_pow_prime_exact_next p n hsource u hnot
end SerreNumberTheoryAI
```


:::theorem "principalunitexactpoweriterate"
  (uses := "principalunitexactpowerstep")
厳密な層上昇を反復する。原典の奇素数・2進の場合分けを保ったまま、
`u∈U_(n+1)＼U_(n+2)` なら任意の `k` について
`u^(p^k)∈U_(n+k+1)＼U_(n+k+2)` を得る。
これは有限商における生成元の位数を調べるための基礎となる。
:::

```lean "principalunitexactpoweriterate"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitExactPowerIterate
    (p n k : ℕ) [Fact p.Prime] (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    (((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
        serrePadicPrincipalUnits p (n + k + 1)) ∧
      (((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∉
        serrePadicPrincipalUnits p (n + k + 2)) :=
  serrePadicPrincipalUnit_pow_prime_iterate_exact p n k hsource u hnot
end SerreNumberTheoryAI
```
