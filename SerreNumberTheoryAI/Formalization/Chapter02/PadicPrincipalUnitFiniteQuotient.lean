import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitPowerStep
import Mathlib.GroupTheory.QuotientGroup.Basic

/-!
# Finite quotients of the principal-unit filtration

Serre Chapter 2, §3.2 uses the quotients U₁/Uₘ (odd p) or
U₂/Uₘ (p = 2).  These definitions reuse the already formalized
project p-adic integer filtration, without replacing it by a packaged
structure theorem for p-adic units.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitFiniteQuotient

variable (p : ℕ) [Fact p.Prime]

/-- The deeper source filtration, as a subgroup of an earlier positive layer. -/
def serrePadicPrincipalUnitDeepSubgroup (n k : ℕ) :
    Subgroup (serrePadicPrincipalUnits p (n + 1)) :=
  (serrePadicPrincipalUnits p (n + k + 1)).comap
    (serrePadicPrincipalUnits p (n + 1)).subtype

/-- The source finite quotient U_(n+1) / U_(n+k+1). -/
abbrev serrePadicPrincipalUnitFiniteQuotient (n k : ℕ) :=
  serrePadicPrincipalUnits p (n + 1) ⧸
    serrePadicPrincipalUnitDeepSubgroup p n k

/--
Every class in U_(n+1)/U_(n+k+1) is killed by p^k.
The stronger statement that a distinguished class has exact order p^k
will use the previously proved *sharp* power-step lemma.
-/
theorem serrePadicPrincipalUnitFiniteQuotient_pow_prime_eq_one
    (n k : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    ((QuotientGroup.mk' (serrePadicPrincipalUnitDeepSubgroup p n k)) u) ^
        (p ^ k) = 1 := by
  rw [← map_pow]
  apply (QuotientGroup.eq_one_iff _).2
  change ((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
    serrePadicPrincipalUnits p (n + k + 1)
  exact serrePadicPrincipalUnit_pow_prime_iterate_mem p n k u

end PadicPrincipalUnitFiniteQuotient

end SerreNumberTheoryAI
