import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientCyclic
import Mathlib.GroupTheory.QuotientGroup.Basic

/-!
# Transitions between finite quotients of principal units

Serre Chapter 2 §3.2: the finite cyclic quotients must form a compatible
inverse system, not merely be abstractly isomorphic to cyclic groups.
This file begins by constructing the *natural* transition induced by
the inclusion of deeper levels of the source filtration.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitFiniteQuotientTransition

variable (p : ℕ) [Fact p.Prime]

/-- The kernel subgroup for level k+1 is contained in the kernel for level k. -/
theorem serrePadicPrincipalUnitDeepSubgroup_succ_le
    (n k : ℕ) :
    serrePadicPrincipalUnitDeepSubgroup p n (k + 1) ≤
      serrePadicPrincipalUnitDeepSubgroup p n k := by
  intro u hu
  change ((u : (SerrePadicInt p)ˣ) ∈
    serrePadicPrincipalUnits p (n + (k + 1) + 1)) at hu
  change ((u : (SerrePadicInt p)ˣ) ∈
    serrePadicPrincipalUnits p (n + k + 1))
  have hstep :=
    serrePadicPrincipalUnits_succ_succ_le_succ p (n + k)
  apply hstep
  simpa only [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hu

/-- The natural transition U_(n+1)/U_(n+k+2) → U_(n+1)/U_(n+k+1). -/
def serrePadicPrincipalUnitFiniteQuotientTransition (n k : ℕ) :
    serrePadicPrincipalUnitFiniteQuotient p n (k + 1) →*
      serrePadicPrincipalUnitFiniteQuotient p n k :=
  QuotientGroup.map
    (serrePadicPrincipalUnitDeepSubgroup p n k)
    (MonoidHom.id _)
    (by
      intro u hu
      exact serrePadicPrincipalUnitDeepSubgroup_succ_le p n k hu)

/-- The transition preserves the residue class of every principal unit. -/
theorem serrePadicPrincipalUnitFiniteQuotientTransition_mk
    (n k : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    serrePadicPrincipalUnitFiniteQuotientTransition p n k
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) =
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n k)) u) := by
  rfl

/-- Every class at a shallow finite level lifts to a class at the next level. -/
theorem serrePadicPrincipalUnitFiniteQuotientTransition_surjective
    (n k : ℕ) :
    Function.Surjective (serrePadicPrincipalUnitFiniteQuotientTransition p n k) := by
  intro x
  obtain ⟨u, rfl⟩ :=
    (QuotientGroup.mk'_surjective
      (serrePadicPrincipalUnitDeepSubgroup p n k)) x
  refine ⟨(QuotientGroup.mk'
    (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u, ?_⟩
  exact serrePadicPrincipalUnitFiniteQuotientTransition_mk p n k u

end PadicPrincipalUnitFiniteQuotientTransition

end SerreNumberTheoryAI
