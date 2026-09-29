import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltration

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 単数群のフィルトレーション" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§3・3.1、印刷頁22--24（uploaded PDF pages 32--34）。

この節では、p進整数環の単数群 `U` を、1 に近い単数の列 `Uₙ` によって調べる。
AI版形式化では、まず project-local な `SerrePadicInt` の単数群上で、有限剰余環への
還元写像の核として `Uₙ` を定義する。これにより、剰余写像・核・商群の標準 API を使って
最初の商 `U/U₁` を有限剰余環の単数群へ結びつける。

:::definition "padicunitreductionlevel"
  (lean := "SerreNumberTheoryAI.serrePadicUnitReductionLevel")
有限剰余レベル `n` への射影を単数に制限し、剰余単数群への群準同型を得る。
:::

:::definition "padicprincipalunits"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnits")
source-indexed な principal-unit filtration を定義する。
`U₀` は単数群全体、`Uₙ₊₁` はレベル `n` の単数還元写像の核である。
:::

:::lemma_ "padicprincipalunitsmembership"
  (uses := "padicprincipalunits")
`u ∈ Uₙ₊₁` であることは、`u - 1` が対応する `p` の冪で割り切れることと同値である。
これは、kernel 表現と source の「1 に高次の `p` 倍を加えた形」を結ぶ基本変換である。
:::

```lean "padicprincipalunitsmembership"
namespace SerreNumberTheoryAI

theorem blueprint_mem_serrePadicPrincipalUnits_succ_iff_pow_dvd
    (p n : ℕ) [Fact p.Prime] (u : (SerrePadicInt p)ˣ) :
    u ∈ serrePadicPrincipalUnits p (n + 1) ↔
      (p : SerrePadicInt p) ^ (n + 1) ∣
        ((u : SerrePadicInt p) - 1) :=
  mem_serrePadicPrincipalUnits_succ_iff_pow_dvd p n u

end SerreNumberTheoryAI
```

:::lemma_ "padicprincipalunitsdescending"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnits_succ_succ_le_succ")
  (uses := "padicprincipalunitsmembership")
隣り合う正のレベルでは filtration が降下する。すなわち次のレベルは現在のレベルの部分群である。
:::

:::definition "padicprincipalunitsnextsubgroup"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitsNextSubgroup")
  (uses := "padicprincipalunitsdescending")
次の filtration level を、現在の principal-unit group の内部の部分群として表す。
この形が successive quotient の母体になる。
:::

:::definition "padicprincipalunitssuccessivequotient"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitsSuccessiveQuotient")
  (uses := "padicprincipalunitsnextsubgroup")
正のレベルの successive principal-unit quotient を定義する。
後続の目標は、この商を最初の剰余環の加法群と同型にすることである。
:::

:::definition "padicprincipalunitcoeff"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitCoeff")
  (uses := "padicprincipalunitsmembership")
principal unit の `u - 1` から、対応する `p` の冪を割った係数を選ぶ。
:::

:::lemma_ "padicprincipalunitcoeffkernel"
  (uses := "padicprincipalunitcoeff, padicprincipalunitsnextsubgroup")
係数の一階剰余が 0 であることは、その principal unit が一つ深い level に属することと同値である。
:::

```lean "padicprincipalunitcoeffkernel"
namespace SerreNumberTheoryAI

theorem blueprint_serrePadicPrincipalUnitCoeffResidue_eq_zero_iff
    (p n : ℕ) [Fact p.Prime]
    (u : serrePadicPrincipalUnits p (n + 1)) :
    serrePadicPrincipalUnitCoeffResidue p n u = 0 ↔
      ((u : (SerrePadicInt p)ˣ) ∈
        serrePadicPrincipalUnits p (n + 2)) :=
  serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n u

end SerreNumberTheoryAI
```

:::lemma_ "padicprincipalunitmulcongruence"
  (uses := "padicprincipalunitcoeff")
source の合同式として、二つの principal unit を掛けると係数は一階剰余では加法的に振る舞う。
これは successive quotient を加法群へ送る準同型の中核である。
:::

```lean "padicprincipalunitmulcongruence"
namespace SerreNumberTheoryAI

theorem blueprint_serrePadicPrincipalUnit_mul_congruent_add
    (p n : ℕ) [Fact p.Prime] (hn : 1 ≤ n)
    (x y : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 1) ∣
      ((1 + (p : SerrePadicInt p) ^ n * x) *
          (1 + (p : SerrePadicInt p) ^ n * y) -
        (1 + (p : SerrePadicInt p) ^ n * (x + y))) :=
  serrePadicPrincipalUnit_mul_congruent_add p n hn x y

end SerreNumberTheoryAI
```

:::definition "padicunitreductionfirst"
  (lean := "SerreNumberTheoryAI.serrePadicUnitReduction")
  (uses := "padicunitreductionlevel")
最初の剰余単数群への還元写像を、project の剰余レベル `0` で表す。
:::

:::lemma_ "padicunitreductionsurjective"
  (uses := "padicunitreductionfirst")
剰余射影の全射性と一階剰余での単元判定を用いて、任意の `mod p` 単数を
p進整数環の単数へ持ち上げる。
:::

```lean "padicunitreductionsurjective"
namespace SerreNumberTheoryAI

theorem blueprint_serrePadicUnitReduction_surjective
    (p : ℕ) [Fact p.Prime] :
    Function.Surjective (serrePadicUnitReduction p) :=
  serrePadicUnitReduction_surjective p

end SerreNumberTheoryAI
```

:::theorem "padicunitsfirstquotient"
  (lean := "SerreNumberTheoryAI.serrePadicUnitsQuotientPrincipalOneEquiv")
  (uses := "padicprincipalunits, padicunitreductionsurjective")
第一同型定理により、最初の商 `U/U₁` は最初の剰余単数群と同型になる。
後続では、これを successive quotient と finite complement の議論の入口として使う。
:::
