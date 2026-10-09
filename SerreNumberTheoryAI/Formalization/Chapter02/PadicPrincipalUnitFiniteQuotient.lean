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

/--
The exact order of a source generator candidate in the finite quotient
U_(n+1) / U_(n+k+2) is p^(k+1).  In the allowed source range, the
sharp filtration lemma says that its p^k-th power is not yet trivial,
while the next p-power is trivial.
-/
theorem serrePadicPrincipalUnitFiniteQuotient_exact_order
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    orderOf
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) =
      p ^ (k + 1) := by
  let q : serrePadicPrincipalUnitFiniteQuotient p n (k + 1) :=
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u
  have hpow : q ^ (p ^ (k + 1)) = 1 :=
    serrePadicPrincipalUnitFiniteQuotient_pow_prime_eq_one p n (k + 1) u
  have hnotpow : q ^ (p ^ k) ≠ 1 := by
    intro h
    have hq : (QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (u ^ (p ^ k)) = 1 := by
      simpa only [map_pow] using h
    have hmem :
        ((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
          serrePadicPrincipalUnits p (n + k + 2) := by
      have hmem' := (QuotientGroup.eq_one_iff _).1 hq
      change
        ((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
          serrePadicPrincipalUnits p (n + (k + 1) + 1)
        at hmem'
      simpa only [Nat.add_assoc] using hmem'
    exact (serrePadicPrincipalUnit_pow_prime_iterate_exact p n k
      hsource u hnot).2 hmem
  exact Nat.eq_prime_pow_of_dvd_least_prime_pow
    (Fact.out : p.Prime)
    (fun hd => hnotpow ((orderOf_dvd_iff_pow_eq_one).1 hd))
    ((orderOf_dvd_iff_pow_eq_one).2 hpow)

/-- For odd p, the residue class of 1+p has exact order p^(k+1). -/
theorem serrePadicPrincipalUnitFiniteQuotient_odd_generator_order
    (hpodd : p ≠ 2) (k : ℕ) :
    orderOf
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p 0 (k + 1)))
        (serrePadicPrincipalUnitOfCoeff p 0 1)) =
      p ^ (k + 1) :=
  serrePadicPrincipalUnitFiniteQuotient_exact_order p 0 k
    (Or.inl hpodd)
    (serrePadicPrincipalUnitOfCoeff p 0 1)
    (serrePadicPrincipalUnitOfCoeff_one_exactLayer p 0)

/-- The residue class of 1+p² has exact order p^(k+1) in U₂/U_(k+3). -/
theorem serrePadicPrincipalUnitFiniteQuotient_levelTwo_generator_order
    (k : ℕ) :
    orderOf
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p 1 (k + 1)))
        (serrePadicPrincipalUnitOfCoeff p 1 1)) =
      p ^ (k + 1) :=
  serrePadicPrincipalUnitFiniteQuotient_exact_order p 1 k
    (Or.inr (by omega))
    (serrePadicPrincipalUnitOfCoeff p 1 1)
    (serrePadicPrincipalUnitOfCoeff_one_exactLayer p 1)

end PadicPrincipalUnitFiniteQuotient

end SerreNumberTheoryAI
