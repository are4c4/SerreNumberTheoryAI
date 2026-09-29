import SerreNumberTheoryAI.Formalization.Chapter02.FiniteAbelianCoprimeSplit
import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltration
import Mathlib.Data.Nat.Totient
import Mathlib.Data.ZMod.Units

/-!
# Finite complements in the p-adic unit filtration

This file applies Serre's coprime finite-abelian supplement to the finite
residue-unit groups.  Project level `n` is reduction modulo `p^(n+1)`, so
the complement here models the source subgroup `V_(n+1)`.
-/

namespace SerreNumberTheoryAI

section PadicUnitFiniteComplement

variable (p : ℕ) [Fact p.Prime]

/-- Reduction of units modulo `p^(n+1)` to units modulo `p`. -/
def serrePadicResidueUnitReductionToFirst (n : ℕ) :
    (padicResidueRing p n)ˣ →* (padicResidueRing p 0)ˣ :=
  ZMod.unitsMap
    (pow_dvd_pow p (Nat.add_le_add_right (Nat.zero_le n) 1))

/-- The finite residue-unit reduction to the first level is surjective. -/
theorem serrePadicResidueUnitReductionToFirst_surjective (n : ℕ) :
    Function.Surjective (serrePadicResidueUnitReductionToFirst p n) := by
  haveI : NeZero (p ^ (n + 1)) :=
    ⟨pow_ne_zero _ (Fact.out : p.Prime).ne_zero⟩
  exact
    ZMod.unitsMap_surjective
      (pow_dvd_pow p (Nat.add_le_add_right (Nat.zero_le n) 1))

/-- The first residue-unit group has order `p - 1`. -/
theorem serrePadicFirstResidueUnits_card :
    Nat.card (padicResidueRing p 0)ˣ = p - 1 := by
  haveI : NeZero p := ⟨(Fact.out : p.Prime).ne_zero⟩
  rw [Nat.card_eq_fintype_card, ZMod.card_units_eq_totient]
  simpa [padicResidueRing] using Nat.totient_prime (Fact.out : p.Prime)

/-- Units modulo `p^(n+1)` have order `p^n (p-1)`. -/
theorem serrePadicResidueUnits_card (n : ℕ) :
    Nat.card (padicResidueRing p n)ˣ = p ^ n * (p - 1) := by
  haveI : NeZero (p ^ (n + 1)) :=
    ⟨pow_ne_zero _ (Fact.out : p.Prime).ne_zero⟩
  rw [Nat.card_eq_fintype_card, ZMod.card_units_eq_totient]
  exact Nat.totient_prime_pow_succ (Fact.out : p.Prime) n

/--
The kernel of reduction from units modulo `p^(n+1)` to units modulo `p`
has order `p^n`, matching `U_1/U_(n+1)` in the source filtration.
-/
theorem serrePadicResidueUnitReductionToFirst_ker_card (n : ℕ) :
    Nat.card (serrePadicResidueUnitReductionToFirst p n).ker = p ^ n := by
  let f := serrePadicResidueUnitReductionToFirst p n
  have hsurj : Function.Surjective f :=
    serrePadicResidueUnitReductionToFirst_surjective p n
  have hindex :
      f.ker.index = Nat.card (padicResidueRing p 0)ˣ := by
    rw [Subgroup.index_ker, f.range_eq_top_of_surjective hsurj,
      Subgroup.card_top]
  have hmul :
      Nat.card f.ker * Nat.card (padicResidueRing p 0)ˣ =
        Nat.card (padicResidueRing p n)ˣ := by
    rw [← hindex]
    exact f.ker.card_mul_index
  rw [serrePadicFirstResidueUnits_card p,
    serrePadicResidueUnits_card p n] at hmul
  exact
    Nat.eq_of_mul_eq_mul_right
      (Nat.sub_pos_of_lt (Fact.out : p.Prime).one_lt) hmul

/--
The kernel order and the first residue-unit order are coprime, which is the
numerical hypothesis of Serre's finite-abelian supplement.
-/
theorem serrePadicResidueUnitReductionToFirst_ker_card_coprime (n : ℕ) :
    Nat.Coprime
      (Nat.card (serrePadicResidueUnitReductionToFirst p n).ker)
      (Nat.card (padicResidueRing p 0)ˣ) := by
  rw [serrePadicResidueUnitReductionToFirst_ker_card p n,
    serrePadicFirstResidueUnits_card p]
  apply Nat.Coprime.pow_left
  rw [Nat.coprime_self_sub_right (Fact.out : p.Prime).one_le]
  simp

/--
The source finite complement at project level `n`: elements of the residue
unit group whose `(p-1)`-st power is one.
-/
abbrev serrePadicFiniteUnitComplement (n : ℕ) :
    Subgroup (padicResidueRing p n)ˣ :=
  serreCoprimeKernelComplement
    (serrePadicResidueUnitReductionToFirst p n)

/--
At the first finite level, the complement is the whole residue-unit group.
-/
theorem serrePadicFiniteUnitComplement_zero_eq_top :
    serrePadicFiniteUnitComplement p 0 = ⊤ := by
  ext a
  constructor
  · intro _
    trivial
  · intro _
    change a ^ Nat.card (padicResidueRing p 0)ˣ = 1
    exact pow_card_eq_one'

/-- Reduction of residue-unit groups from level `n+1` to level `n`. -/
def serrePadicResidueUnitTransition (n : ℕ) :
    (padicResidueRing p (n + 1))ˣ →* (padicResidueRing p n)ˣ :=
  ZMod.unitsMap
    (show p ^ (n + 1) ∣ p ^ ((n + 1) + 1) from
      pow_dvd_pow p (Nat.le_succ (n + 1)))

/-- Reduction to the first residue level factors through adjacent reductions. -/
theorem serrePadicResidueUnitReductionToFirst_transition (n : ℕ) :
    (serrePadicResidueUnitReductionToFirst p n).comp
      (serrePadicResidueUnitTransition p n) =
        serrePadicResidueUnitReductionToFirst p (n + 1) := by
  simpa [serrePadicResidueUnitReductionToFirst,
    serrePadicResidueUnitTransition] using
    (ZMod.unitsMap_comp
      (pow_dvd_pow p (Nat.add_le_add_right (Nat.zero_le n) 1))
      (show p ^ (n + 1) ∣ p ^ ((n + 1) + 1) from
        pow_dvd_pow p (Nat.le_succ (n + 1))))

/-- The finite complements are compatible with adjacent residue reductions. -/
def serrePadicFiniteUnitComplementTransition (n : ℕ) :
    serrePadicFiniteUnitComplement p (n + 1) →*
      serrePadicFiniteUnitComplement p n where
  toFun u := by
    refine ⟨serrePadicResidueUnitTransition p n u, ?_⟩
    have hu := u.property
    change ((u : (padicResidueRing p (n + 1))ˣ) ^
      Nat.card (padicResidueRing p 0)ˣ = 1) at hu
    change (serrePadicResidueUnitTransition p n
      (u : (padicResidueRing p (n + 1))ˣ)) ^
        Nat.card (padicResidueRing p 0)ˣ = 1
    simpa using congrArg (serrePadicResidueUnitTransition p n) hu
  map_one' := by
    ext
    simp [serrePadicResidueUnitTransition]
  map_mul' u v := by
    ext
    simp [serrePadicResidueUnitTransition]

/--
At every finite level, the distinguished complement maps isomorphically to
the first residue-unit group.
-/
noncomputable def serrePadicFiniteUnitComplementEquiv (n : ℕ) :
    serrePadicFiniteUnitComplement p n ≃*
      (padicResidueRing p 0)ˣ :=
  serreCoprimeKernelComplementEquiv
    (serrePadicResidueUnitReductionToFirst p n)
    (serrePadicResidueUnitReductionToFirst_surjective p n)
    (serrePadicResidueUnitReductionToFirst_ker_card_coprime p n)

/--
Adjacent finite complements are isomorphic by reducing both sides to the first
residue-unit group.
-/
noncomputable def serrePadicFiniteUnitComplementTransitionEquiv (n : ℕ) :
    serrePadicFiniteUnitComplement p (n + 1) ≃*
      serrePadicFiniteUnitComplement p n :=
  (serrePadicFiniteUnitComplementEquiv p (n + 1)).trans
    (serrePadicFiniteUnitComplementEquiv p n).symm

/-- The concrete transition agrees with the first-residue equivalences. -/
theorem serrePadicFiniteUnitComplementEquiv_transition_apply
    (n : ℕ) (u : serrePadicFiniteUnitComplement p (n + 1)) :
    serrePadicFiniteUnitComplementEquiv p n
      (serrePadicFiniteUnitComplementTransition p n u) =
        serrePadicFiniteUnitComplementEquiv p (n + 1) u := by
  change serrePadicResidueUnitReductionToFirst p n
      (serrePadicResidueUnitTransition p n
        (u : (padicResidueRing p (n + 1))ˣ)) =
    serrePadicResidueUnitReductionToFirst p (n + 1)
      (u : (padicResidueRing p (n + 1))ˣ)
  simpa using congrFun
    (congrArg DFunLike.coe
      (serrePadicResidueUnitReductionToFirst_transition p n))
    (u : (padicResidueRing p (n + 1))ˣ)

/--
The adjacent complement transition is the same map as the equivalence obtained
by comparing both complements with the first residue-unit group.
-/
theorem serrePadicFiniteUnitComplementTransitionEquiv_apply
    (n : ℕ) (u : serrePadicFiniteUnitComplement p (n + 1)) :
    serrePadicFiniteUnitComplementTransitionEquiv p n u =
      serrePadicFiniteUnitComplementTransition p n u := by
  apply (serrePadicFiniteUnitComplementEquiv p n).injective
  rw [serrePadicFiniteUnitComplementEquiv_transition_apply]
  rfl

/--
The finite complement is the unique subgroup of the residue-unit group on
which reduction to the first residue units is bijective.
-/
theorem serrePadicFiniteUnitComplement_unique
    (n : ℕ)
    (C : Subgroup (padicResidueRing p n)ˣ)
    (hbij :
      Function.Bijective
        ((serrePadicResidueUnitReductionToFirst p n).comp C.subtype)) :
    C = serrePadicFiniteUnitComplement p n :=
  serreCoprimeKernelComplement_unique_of_bijective
    (serrePadicResidueUnitReductionToFirst p n)
    (serrePadicResidueUnitReductionToFirst_ker_card_coprime p n)
    C hbij

end PadicUnitFiniteComplement

end SerreNumberTheoryAI
