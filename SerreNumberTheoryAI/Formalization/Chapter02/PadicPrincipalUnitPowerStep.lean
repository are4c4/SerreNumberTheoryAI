import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltrationQuotient
import Mathlib.Data.Nat.Choose.Dvd
import Mathlib.Tactic.Linarith

/-!
# The first steps toward the structure of principal p-adic units

Independent, source-shaped formalization of Serre, Chapter 2, §3.2.
The source proves a sharp p-power filtration step by the binomial theorem.
We first isolate the exact-layer criterion and the exponent inequalities needed
to control the terms in that expansion.

Source: Japanese edition, printed pp. 24–25 (uploaded PDF pp. 34–35).
The main exact-step lemma and Proposition 8 are not claimed below.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitPowerStep

variable (p : ℕ) [Fact p.Prime]

/--
An element of U_(n+1) lies outside U_(n+2) precisely when its
source coefficient has nonzero first residue.
-/
theorem serrePadicPrincipalUnit_exactLayer_iff_coeff_ne_zero
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    ((u : (SerrePadicInt p)ˣ) ∉ serrePadicPrincipalUnits p (n + 2)) ↔
      serrePadicPrincipalUnitCoeffResidue p n u ≠ 0 := by
  constructor
  · intro h hzero
    exact h ((serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n u).1 hzero)
  · intro h hu
    exact h ((serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n u).2 hu)

/--
Each positive filtration layer has a concrete element outside the next:
the project unit represented by 1 + p^(n+1).
-/
theorem serrePadicPrincipalUnitOfCoeff_one_exactLayer (n : ℕ) :
    ((serrePadicPrincipalUnitOfCoeff p n 1 :
        serrePadicPrincipalUnits p (n + 1)) : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2) := by
  have hcoeff :
      serrePadicPrincipalUnitCoeffResidue p n
          (serrePadicPrincipalUnitOfCoeff p n 1) = 1 := by
    simp
  intro h
  have hzero :=
    (serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n
      (serrePadicPrincipalUnitOfCoeff p n 1)).2 h
  letI : Nontrivial (padicResidueRing p 0) := by
    simpa [padicResidueRing] using (inferInstance : Nontrivial (ZMod p))
  exact (one_ne_zero : (1 : padicResidueRing p 0) ≠ 0) (hcoeff.symm.trans hzero)

/--
For i >= 2 the p-divisible intermediate binomial terms have order at least
n+2 when n >= 1.
-/
theorem serrePadicPowerStep_middle_exponent_bound
    (n i : ℕ) (hn : 1 ≤ n) (hi : 2 ≤ i) :
    n + 2 ≤ n * i + 1 := by
  nlinarith [Nat.mul_le_mul_left n hi]

/--
The final binomial term has sufficiently large order: odd p permits n >= 1,
whereas at p = 2 the source requires n >= 2.
-/
theorem serrePadicPowerStep_last_exponent_bound
    (n : ℕ) (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n) :
    n + 2 ≤ n * p := by
  have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
  rcases hsource with hodd | hn2
  · have hp3 : 3 ≤ p := by omega
    nlinarith [Nat.mul_le_mul_left n hp3]
  · nlinarith [Nat.mul_le_mul_left n hp2]

/--
A p-th power of any source principal unit passes to the next filtration
level.  This is the weak half of the source's sharp power-step lemma:
it follows from the already established coefficient-residue homomorphism
to the additive group of F_p.  The sharp exclusion from the following level
will require the source's binomial argument and index restrictions.
-/
theorem serrePadicPrincipalUnit_pow_prime_mem_next
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    ((u : (SerrePadicInt p)ˣ) ^ p) ∈
      serrePadicPrincipalUnits p (n + 2) := by
  have hcard :
      Nat.card (Multiplicative (padicResidueRing p 0)) = p := by
    simp [padicResidueRing, Nat.card_eq_fintype_card, ZMod.card]
  have hpowerCard :
      ((serrePadicPrincipalUnitCoeffResidueHom p n) u) ^
        Nat.card (Multiplicative (padicResidueRing p 0)) = 1 :=
    pow_card_eq_one'
  have hpower :
      ((serrePadicPrincipalUnitCoeffResidueHom p n) u) ^ p = 1 := by
    simpa only [hcard] using hpowerCard
  have hker :
      u ^ p ∈ (serrePadicPrincipalUnitCoeffResidueHom p n).ker := by
    change (serrePadicPrincipalUnitCoeffResidueHom p n) (u ^ p) = 1
    rw [map_pow]
    exact hpower
  rw [serrePadicPrincipalUnitCoeffResidueHom_ker p n] at hker
  exact hker

/--
Every strictly intermediate binomial coefficient in (1+t)^p is divisible
by p.  Together with the exponent bounds above, this is the arithmetic
input for the source's sharp p-power step.
-/
theorem serrePadicPowerStep_middle_choose_dvd
    (i : ℕ) (hi0 : 0 < i) (hip : i < p) :
    p ∣ Nat.choose p i :=
  (Fact.out : p.Prime).dvd_choose_self (by omega) hip

/--
An intermediate term of (1 + p^n a)^p is divisible by p^(n+2).
This combines p-divisibility of the interior binomial coefficients
with the source exponent bound.
-/
theorem serrePadicPowerStep_middle_term_dvd
    (n i : ℕ) (hn : 1 ≤ n) (hi : 2 ≤ i) (hip : i < p)
    (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      (Nat.choose p i : SerrePadicInt p) *
        ((p : SerrePadicInt p) ^ n * a) ^ i := by
  obtain ⟨k, hk⟩ :=
    serrePadicPowerStep_middle_choose_dvd p i (by omega) hip
  obtain ⟨z, hz⟩ :=
    (pow_dvd_pow (p : SerrePadicInt p)
      (serrePadicPowerStep_middle_exponent_bound n i hn hi))
  have hterm :
      (Nat.choose p i : SerrePadicInt p) *
          ((p : SerrePadicInt p) ^ n * a) ^ i =
        (p : SerrePadicInt p) ^ (n * i + 1) * ((k : SerrePadicInt p) * a ^ i) := by
    simp [hk, mul_pow, pow_mul, pow_succ, mul_comm, mul_left_comm, mul_assoc]
  refine ⟨z * ((k : SerrePadicInt p) * a ^ i), ?_⟩
  calc
    (Nat.choose p i : SerrePadicInt p) *
        ((p : SerrePadicInt p) ^ n * a) ^ i =
          (p : SerrePadicInt p) ^ (n * i + 1) *
            ((k : SerrePadicInt p) * a ^ i) := hterm
    _ = (p : SerrePadicInt p) ^ (n + 2) *
        (z * ((k : SerrePadicInt p) * a ^ i)) := by
          rw [hz]
          ring

/--
The final term of the binomial expansion has valuation at least n+2
under exactly the source's odd-prime/dyadic lower-bound disjunction.
-/
theorem serrePadicPowerStep_last_term_dvd
    (n : ℕ) (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n)
    (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      ((p : SerrePadicInt p) ^ n * a) ^ p := by
  obtain ⟨z, hz⟩ :=
    (pow_dvd_pow (p : SerrePadicInt p)
      (serrePadicPowerStep_last_exponent_bound p n hn hsource))
  refine ⟨z * a ^ p, ?_⟩
  calc
    ((p : SerrePadicInt p) ^ n * a) ^ p =
        (p : SerrePadicInt p) ^ (n * p) * a ^ p := by
          rw [mul_pow, pow_mul]
    _ = (p : SerrePadicInt p) ^ (n + 2) * (z * a ^ p) := by
          rw [hz]
          ring

end PadicPrincipalUnitPowerStep

end SerreNumberTheoryAI
