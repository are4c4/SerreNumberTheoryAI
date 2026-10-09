import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientTransition

/-!
# Compatibility of cyclic presentations with finite quotient transitions

Serre Chapter 2 §3.2: the chosen generator is one *fixed* principal
unit at all levels, so the cyclic identifications must commute with
the natural finite-quotient transitions.  We first verify this on the
integer powers of the generator, rather than assuming that abstract
isomorphisms of cyclic groups are compatible.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitFiniteQuotientCompatibility

variable (p : ℕ) [Fact p.Prime]

/--
The explicit cyclic equivalence sends the residue of an integer i
to the i-th power of the chosen principal-unit class.
-/
theorem serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_intCast
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2))
    (i : ℤ) :
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k hsource u hnot
      (Multiplicative.ofAdd (i : ZMod (p ^ (k + 1)))) =
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) ^ i := by
  simp [serrePadicPrincipalUnitFiniteQuotientCyclicEquiv]

/--
The two finite cyclic presentations agree with the natural principal-unit
projection on every integer power. This is the key compatibility statement
needed before passing to the p-adic inverse limit.
-/
theorem serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition_intCast
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2))
    (i : ℤ) :
    serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      (serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n (k + 1)
        hsource u hnot
        (Multiplicative.ofAdd (i : ZMod (p ^ (k + 2))))) =
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k
      hsource u hnot
      (Multiplicative.ofAdd (i : ZMod (p ^ (k + 1)))) := by
  rw [serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_intCast,
      serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_intCast,
      map_zpow,
      serrePadicPrincipalUnitFiniteQuotientTransition_mk]

end PadicPrincipalUnitFiniteQuotientCompatibility

end SerreNumberTheoryAI
