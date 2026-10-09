import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltrationQuotient
import Mathlib.Data.Nat.Choose.Dvd
import Mathlib.Data.Nat.Choose.Sum
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

/--
Iterating the weak p-power step: each further p-th power enters one
more principal-unit layer.  This gives the finite-quotient exponent bound
needed before proving that the chosen element has *exactly* that order.
-/
theorem serrePadicPrincipalUnit_pow_prime_iterate_mem
    (n k : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    ((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
      serrePadicPrincipalUnits p (n + k + 1) := by
  induction k with
  | zero =>
      simpa using u.property
  | succ k ih =>
      have hmem :
          ((u : (SerrePadicInt p)ˣ) ^ p ^ k) ∈
            serrePadicPrincipalUnits p ((n + k) + 1) := by
        simpa only [Nat.add_assoc] using ih
      have hstep :
          (((u : (SerrePadicInt p)ˣ) ^ p ^ k) ^ p) ∈
            serrePadicPrincipalUnits p ((n + k) + 2) :=
        serrePadicPrincipalUnit_pow_prime_mem_next p (n + k)
          ⟨_, hmem⟩
      simpa only [pow_mul, pow_succ, Nat.add_assoc] using hstep

/--
All binomial terms of degree between 2 and p vanish modulo p^(n+2)
in the source range.  The endpoint i=p is treated by the last-term bound.
-/
theorem serrePadicPowerStep_high_term_dvd
    (n i : ℕ) (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n)
    (hi : 2 ≤ i) (hip : i ≤ p) (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      (Nat.choose p i : SerrePadicInt p) *
        ((p : SerrePadicInt p) ^ n * a) ^ i := by
  rcases lt_or_eq_of_le hip with hlt | heq
  · exact serrePadicPowerStep_middle_term_dvd p n i hn hi hlt a
  · subst i
    simpa only [Nat.choose_self, Nat.cast_one, one_mul] using
      (serrePadicPowerStep_last_term_dvd p n hn hsource a)

/--
The sum of all higher-degree terms of the binomial expansion is divisible
by p^(n+2).  This is the aggregated remainder estimate for the sharp
filtration step.
-/
theorem serrePadicPowerStep_high_terms_sum_dvd
    (n : ℕ) (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n)
    (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      ∑ i ∈ Finset.Icc 2 p,
        (Nat.choose p i : SerrePadicInt p) *
          ((p : SerrePadicInt p) ^ n * a) ^ i := by
  apply Finset.dvd_sum
  intro i hi
  exact serrePadicPowerStep_high_term_dvd p n i hn hsource
    (Finset.mem_Icc.mp hi).1 (Finset.mem_Icc.mp hi).2 a

/--
Source binomial congruence: in the permitted odd-prime/dyadic range,
(1 + p^n a)^p is congruent to 1 + p^(n+1) a modulo p^(n+2).
This is the key calculation behind the *sharp* p-power filtration step.
-/
theorem serrePadicPowerStep_binomial_congr_dvd
    (n : ℕ) (hn : 1 ≤ n) (hsource : p ≠ 2 ∨ 2 ≤ n)
    (a : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 2) ∣
      ((1 + (p : SerrePadicInt p) ^ n * a) ^ p -
        (1 + (p : SerrePadicInt p) ^ (n + 1) * a)) := by
  let t : SerrePadicInt p := (p : SerrePadicInt p) ^ n * a
  let f : ℕ → SerrePadicInt p := fun i =>
    (Nat.choose p i : SerrePadicInt p) * t ^ i
  have hp2 : 2 ≤ p + 1 := by
    have hprime : 2 ≤ p := (Fact.out : p.Prime).two_le
    omega
  have hbinom :
      (1 + t) ^ p = ∑ i ∈ Finset.range (p + 1), f i := by
    simpa [f, add_comm, mul_comm] using
      (add_pow t (1 : SerrePadicInt p) p)
  have hsplit :
      (∑ i ∈ Finset.range (p + 1), f i) =
        f 0 + f 1 + ∑ i ∈ Finset.Icc 2 p, f i := by
    calc
      _ = (∑ i ∈ Finset.range 2, f i) +
          ∑ i ∈ Finset.Ico 2 (p + 1), f i :=
        (Finset.sum_range_add_sum_Ico f hp2).symm
      _ = f 0 + f 1 + ∑ i ∈ Finset.Icc 2 p, f i := by
        simp [Finset.sum_range_succ, Finset.Ico_add_one_right_eq_Icc, add_assoc]
  have hzero : f 0 = 1 := by simp [f]
  have hone :
      f 1 = (p : SerrePadicInt p) ^ (n + 1) * a := by
    simp [f, t, pow_succ, mul_assoc, mul_comm, mul_left_comm]
  have hrem :
      (1 + t) ^ p -
        (1 + (p : SerrePadicInt p) ^ (n + 1) * a) =
      ∑ i ∈ Finset.Icc 2 p, f i := by
    rw [hbinom, hsplit, hzero, hone]
    ring
  change (p : SerrePadicInt p) ^ (n + 2) ∣
    ((1 + t) ^ p -
      (1 + (p : SerrePadicInt p) ^ (n + 1) * a))
  rw [hrem]
  simpa [f, t, mul_comm] using
    (serrePadicPowerStep_high_terms_sum_dvd p n hn hsource a)

/--
Cancelling a nonzero p^(n+1) from a power divisibility statement:
if p^(n+2) divides p^(n+1) a, then p divides a.
-/
theorem serrePadicPowerStep_cancel_pow_dvd
    (n : ℕ) (a : SerrePadicInt p)
    (hdiv : (p : SerrePadicInt p) ^ (n + 2) ∣
      (p : SerrePadicInt p) ^ (n + 1) * a) :
    (p : SerrePadicInt p) ∣ a := by
  obtain ⟨b, hb⟩ := hdiv
  refine ⟨b, ?_⟩
  apply serrePadicInt_mul_pow_injective p (n + 1)
  calc
    (p : SerrePadicInt p) ^ (n + 1) * a =
        (p : SerrePadicInt p) ^ (n + 2) * b := hb
    _ = (p : SerrePadicInt p) ^ (n + 1) *
        ((p : SerrePadicInt p) * b) := by
      rw [show n + 2 = (n + 1) + 1 by omega, pow_succ]
      ring

/--
The sharp source power-step lemma in project indices: if a unit belongs to
U_(n+1) but not U_(n+2), its p-th power belongs to U_(n+2) but not
U_(n+3). The dyadic case requires n+1 >= 2, unlike odd prime p.
-/
theorem serrePadicPrincipalUnit_pow_prime_exact_next
    (n : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    ((u : (SerrePadicInt p)ˣ) ^ p ∈
        serrePadicPrincipalUnits p (n + 2)) ∧
      ((u : (SerrePadicInt p)ˣ) ^ p ∉
        serrePadicPrincipalUnits p (n + 3)) := by
  refine ⟨serrePadicPrincipalUnit_pow_prime_mem_next p n u, ?_⟩
  intro hdeep
  let a : SerrePadicInt p := serrePadicPrincipalUnitCoeff p n u
  have hnotdiv : ¬ (p : SerrePadicInt p) ∣ a := by
    intro hdiv
    have hzero : serrePadicPrincipalUnitCoeffResidue p n u = 0 := by
      change serrePadicIntProj p 0 a = 0
      exact (p_dvd_serrePadicInt_iff_proj_zero p a).1 hdiv
    exact hnot
      ((serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n u).1 hzero)
  have huval :
      (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p)) =
        1 + (p : SerrePadicInt p) ^ (n + 1) * a := by
    have hs := serrePadicPrincipalUnitCoeff_spec p n u
    calc
      (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p)) =
          (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) + 1 := by ring
      _ = (p : SerrePadicInt p) ^ (n + 1) * a + 1 := by
        simpa only [a] using
          congrArg (fun z : SerrePadicInt p => z + 1) hs
      _ = 1 + (p : SerrePadicInt p) ^ (n + 1) * a := by ring
  have hsource' : p ≠ 2 ∨ 2 ≤ n + 1 := by
    rcases hsource with hodd | hn
    · exact Or.inl hodd
    · exact Or.inr (by omega)
  have hbinom :=
    serrePadicPowerStep_binomial_congr_dvd p (n + 1)
      (by omega) hsource' a
  have hbinom' :
      (p : SerrePadicInt p) ^ (n + 3) ∣
        (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) ^ p -
          (1 + (p : SerrePadicInt p) ^ (n + 2) * a)) := by
    simpa [huval, Nat.add_assoc] using hbinom
  have hdeepdiv :
      (p : SerrePadicInt p) ^ (n + 3) ∣
        (((((u : (SerrePadicInt p)ˣ) ^ p) :
            (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) :=
    (mem_serrePadicPrincipalUnits_succ_iff_pow_dvd p (n + 2)
      ((u : (SerrePadicInt p)ˣ) ^ p)).1 (by
        simpa [Nat.add_assoc] using hdeep)
  have hdeepval :
      (p : SerrePadicInt p) ^ (n + 3) ∣
        (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) ^ p - 1) := by
    change (p : SerrePadicInt p) ^ (n + 3) ∣
      ((Units.coeHom (SerrePadicInt p))
        ((u : (SerrePadicInt p)ˣ) ^ p) - 1) at hdeepdiv
    rw [map_pow] at hdeepdiv
    simpa only [Units.coeHom_apply] using hdeepdiv
  have hcoefficient :
      (p : SerrePadicInt p) ^ (n + 3) ∣
        (p : SerrePadicInt p) ^ (n + 2) * a := by
    have hsub := dvd_sub hdeepval hbinom'
    have heq :
        ((((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) ^ p - 1) -
          (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) ^ p -
            (1 + (p : SerrePadicInt p) ^ (n + 2) * a))) =
          (p : SerrePadicInt p) ^ (n + 2) * a := by ring
    simpa only [heq] using hsub
  apply hnotdiv
  exact serrePadicPowerStep_cancel_pow_dvd p (n + 1) a
    (by simpa [Nat.add_assoc] using hcoefficient)

/--
Iterated sharp power-step lemma: a project principal unit in an exact
filtration layer remains in the corresponding exact layer after every
successive p-power.  The original source parity restriction persists.
-/
theorem serrePadicPrincipalUnit_pow_prime_iterate_exact
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    (((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∈
        serrePadicPrincipalUnits p (n + k + 1)) ∧
      (((u : (SerrePadicInt p)ˣ) ^ (p ^ k)) ∉
        serrePadicPrincipalUnits p (n + k + 2)) := by
  induction k with
  | zero =>
      simpa using (And.intro u.property hnot)
  | succ k ih =>
      obtain ⟨hmem, hdeep⟩ := ih
      have hsource' : p ≠ 2 ∨ 1 ≤ n + k := by
        rcases hsource with hp | hn
        · exact Or.inl hp
        · exact Or.inr (by omega)
      obtain ⟨hnext, hnotnext⟩ :=
        serrePadicPrincipalUnit_pow_prime_exact_next p (n + k)
          hsource'
          (⟨(u : (SerrePadicInt p)ˣ) ^ p ^ k, hmem⟩ :
            serrePadicPrincipalUnits p (n + k + 1)) hdeep
      constructor
      · simpa only [pow_succ, pow_mul, Nat.add_assoc] using hnext
      · simpa only [pow_succ, pow_mul, Nat.add_assoc] using hnotnext

end PadicPrincipalUnitPowerStep

end SerreNumberTheoryAI
