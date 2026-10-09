import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientCompatibility

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 有限巡回商と射影の整合性" =>

*出典:* セール『数論講義』§3.2。奇素数の `U₁` および
2進の `U₂` から `Z_p` 加法群への同型を得るには、
各有限商を独立に同型とするだけでなく、固定された元の冪による
表示が有限段階の射影と整合している必要がある。

:::theorem "principalunitfinitequotientcyclicintcast"
  (uses := "principalunitfinitequotienttransition")
具体的な有限巡回群同型は整数 `i` の剰余類を選んだ元の `i` 乗に移す。
:::

```lean "principalunitfinitequotientcyclicintcast"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitCyclicIntCast
    (p n k : ℕ) [Fact p.Prime]
    (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) (i : ℤ) :
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k hsource u hnot
      (Multiplicative.ofAdd (i : ZMod (p ^ (k + 1)))) =
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) ^ i :=
  serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_intCast p n k hsource u hnot i
end SerreNumberTheoryAI
```

:::theorem "principalunitfinitequotientcyclictransitionintcast"
  (uses := "principalunitfinitequotientcyclicintcast principalunitfinitequotienttransitionmk")
隣接する有限商の射影は、整数の剰余類を固定生成元の同じ冪に
写すという同型と可換である。これが逆極限へ移る前の整合性である。
:::

```lean "principalunitfinitequotientcyclictransitionintcast"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitCyclicTransitionIntCast
    (p n k : ℕ) [Fact p.Prime]
    (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) (i : ℤ) :
    serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      (serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n (k + 1)
        hsource u hnot
        (Multiplicative.ofAdd (i : ZMod (p ^ (k + 2))))) =
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k
      hsource u hnot
      (Multiplicative.ofAdd (i : ZMod (p ^ (k + 1)))) :=
  serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition_intCast
    p n k hsource u hnot i
end SerreNumberTheoryAI
```


:::definition "principalunitzmodtransition"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitZModTransition")
`ZMod(p^(k+2)) → ZMod(p^(k+1))` の標準的な剰余写像を
乗法的な型の群準同型として扱う。
:::

:::theorem "principalunitzmodtransitionintcast"
  (uses := "principalunitzmodtransition")
標準的な剰余写像は整数の剰余類をそのまま下位の剰余類へ写す。
:::

```lean "principalunitzmodtransitionintcast"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitZModTransitionIntCast
    (p k : ℕ) [Fact p.Prime] (i : ℤ) :
    serrePadicPrincipalUnitZModTransition p k
      (Multiplicative.ofAdd (i : ZMod (p ^ (k + 2)))) =
        Multiplicative.ofAdd (i : ZMod (p ^ (k + 1))) :=
  serrePadicPrincipalUnitZModTransition_intCast p k i
end SerreNumberTheoryAI
```

:::theorem "principalunitcyclictransitionall"
  (uses := "principalunitzmodtransitionintcast principalunitfinitequotientcyclictransitionintcast")
任意の剰余類に対し、有限巡回群の明示的な同型と
主単数商間の自然射影は可換になる。
これにより個々の有限群の同型が射影系として整合する。
:::

```lean "principalunitcyclictransitionall"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitCyclicTransitionAll
    (p n k : ℕ) [Fact p.Prime]
    (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2))
    (x : Multiplicative (ZMod (p ^ (k + 2)))) :
    serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      (serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n (k + 1)
        hsource u hnot x) =
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k
      hsource u hnot
      (serrePadicPrincipalUnitZModTransition p k x) :=
  serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition
    p n k hsource u hnot x
end SerreNumberTheoryAI
```
