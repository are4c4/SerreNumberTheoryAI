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

/--
The source's standard reduction between additive cyclic residue groups,
viewed as a multiplicative-group homomorphism. It reuses the project
p-adic residue transition from Chapter 2 §1.1.
-/
def serrePadicPrincipalUnitZModTransition (k : ℕ) :
    Multiplicative (ZMod (p ^ (k + 2))) →*
      Multiplicative (ZMod (p ^ (k + 1))) :=
  (padicReduction p k).toAddMonoidHom.toMultiplicative

/-- The standard cyclic reduction preserves integer residue classes. -/
theorem serrePadicPrincipalUnitZModTransition_intCast
    (k : ℕ) (i : ℤ) :
    serrePadicPrincipalUnitZModTransition p k
      (Multiplicative.ofAdd (i : ZMod (p ^ (k + 2)))) =
        Multiplicative.ofAdd (i : ZMod (p ^ (k + 1))) := by
  change Multiplicative.ofAdd
      (padicReduction p k (i : padicResidueRing p (k + 1))) =
    Multiplicative.ofAdd (i : padicResidueRing p k)
  simp [padicReduction]

/--
The cyclic identifications commute with the *actual reduction map*
on all finite residue classes, not just on a chosen generator.
-/
theorem serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2))
    (x : Multiplicative (ZMod (p ^ (k + 2)))) :
    serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      (serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n (k + 1)
        hsource u hnot x) =
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k
      hsource u hnot
      (serrePadicPrincipalUnitZModTransition p k x) := by
  obtain ⟨i, hi⟩ :=
    ZMod.intCast_surjective (Multiplicative.toAdd x)
  have hx : x = Multiplicative.ofAdd (i : ZMod (p ^ (k + 2))) := by
    simpa using congrArg Multiplicative.ofAdd hi.symm
  rw [hx, serrePadicPrincipalUnitZModTransition_intCast]
  exact
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition_intCast
      p n k hsource u hnot i

end PadicPrincipalUnitFiniteQuotientCompatibility

end SerreNumberTheoryAI
