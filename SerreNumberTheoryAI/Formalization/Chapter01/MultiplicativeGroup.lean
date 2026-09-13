import Mathlib.RingTheory.IntegralDomain

/-!
# Multiplicative group of a finite field

Independent formalization of Serre, Chapter 1, §1, 1.2.

Source metadata only: Japanese edition, printed pp. 5–6, uploaded PDF pp. 15–16.
-/

namespace SerreNumberTheoryAI

open Finset Polynomial

section MultiplicativeGroup

/--
Euler's totient function sums to `n` over the positive divisors of `n`.
This is the arithmetic counting identity used in the cyclicity argument.
-/
theorem totient_divisor_sum (n : ℕ) :
    n.divisors.sum Nat.totient = n :=
  Nat.sum_totient n

/--
A finite group is cyclic if, for every positive exponent `n`, the equation
`x^n = 1` has at most `n` solutions.

This convenient form is slightly stronger in its hypothesis than Serre's
lemma, which only asks for divisors of the group order. The underlying
counting argument is the same totient/order argument.
-/
theorem finiteGroup_isCyclic_of_power_root_bound
    {G : Type*} [Group G] [Fintype G] [DecidableEq G]
    (hroots : ∀ n : ℕ, 0 < n → #{g : G | g ^ n = 1} ≤ n) :
    IsCyclic G :=
  isCyclic_of_card_pow_eq_one_le hroots

variable (K : Type*) [Field K] [Fintype K]

/--
For a finite field, the equation `u^n = 1` has at most `n` solutions among
units. This is the polynomial root bound for `X^n - 1`, transferred through
the injective map from units to the field.
-/
theorem finiteField_units_power_root_bound [DecidableEq K]
    (n : ℕ) (hn : 0 < n) :
    #{u : Kˣ | u ^ n = 1} ≤ n := by
  exact
    (card_nthRoots_subgroup_units (Units.coeHom K) Units.val_injective hn 1).trans
      (card_nthRoots n ((Units.coeHom K) 1))

/-- The multiplicative group of a finite field is cyclic. -/
theorem finiteField_units_isCyclic : IsCyclic Kˣ := by
  classical
  exact
    finiteGroup_isCyclic_of_power_root_bound
      (G := Kˣ) (fun n hn => finiteField_units_power_root_bound K n hn)

/-- The multiplicative group of a finite field has one fewer element than the field. -/
theorem finiteField_units_natCard : Nat.card Kˣ = Nat.card K - 1 := by
  exact Nat.card_units K

/--
Serre, Chapter 1, §1.2, Theorem 2: the multiplicative group of a finite field
is cyclic, and its order is the cardinality of the field minus one.
-/
theorem serre_theorem2 :
    IsCyclic Kˣ ∧ Nat.card Kˣ = Nat.card K - 1 := by
  exact ⟨finiteField_units_isCyclic K, finiteField_units_natCard K⟩

end MultiplicativeGroup

end SerreNumberTheoryAI
