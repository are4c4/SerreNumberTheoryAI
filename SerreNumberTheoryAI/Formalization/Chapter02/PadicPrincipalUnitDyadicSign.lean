import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitZModTower

/-!
# The sign component in the dyadic principal-unit group

Serre Chapter 2 §3.2 identifies U₁ = {±1} × U₂ for p=2.
We start by constructing the nontrivial sign element and verifying
that its class is not in U₂. No source-level sign decomposition is
assumed as a prepackaged theorem.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitDyadicSign

private instance : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩

/-- The dyadic sign -1 belongs to U₁, since -1 ≡ 1 (mod 2). -/
def serrePadicDyadicNegOnePrincipal : serrePadicPrincipalUnits 2 1 := by
  refine ⟨(-1 : (SerrePadicInt 2)ˣ), ?_⟩
  change serrePadicUnitReductionLevel 2 0 (-1 : (SerrePadicInt 2)ˣ) = 1
  apply Units.ext
  change serrePadicIntProj 2 0
    ((-1 : (SerrePadicInt 2)ˣ) : SerrePadicInt 2) = 1
  have h : (-1 : padicResidueRing 2 0) = 1 := by decide
  simpa using h

/-- The sign element has order dividing two. -/
theorem serrePadicDyadicNegOnePrincipal_sq :
    (serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) ^ 2 = 1 := by
  apply Subtype.ext
  change (-1 : (SerrePadicInt 2)ˣ) ^ 2 = 1
  simp

/-- The sign is not in U₂, since -1 ≠ 1 (mod 4). -/
theorem serrePadicDyadicNegOnePrincipal_not_mem_levelTwo :
    ((serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) : (SerrePadicInt 2)ˣ) ∉
      serrePadicPrincipalUnits 2 2 := by
  intro hdeep
  change serrePadicUnitReductionLevel 2 1
    ((serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) : (SerrePadicInt 2)ˣ) = 1 at hdeep
  have hval := congrArg
    (fun z : (padicResidueRing 2 1)ˣ =>
      (z : padicResidueRing 2 1)) hdeep
  have hbad : (-1 : padicResidueRing 2 1) = 1 := by
    simpa [serrePadicUnitReductionLevel,
      serrePadicDyadicNegOnePrincipal] using hval
  have hneq : (-1 : padicResidueRing 2 1) ≠ 1 := by decide
  exact hneq hbad

/-- The class of -1 is nontrivial in the two-element quotient U₁/U₂. -/
theorem serrePadicDyadicNegOnePrincipal_quotient_ne_one :
    ((QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup 2 0 1))
      serrePadicDyadicNegOnePrincipal) ≠ 1 := by
  intro heq
  have hmem :
      serrePadicDyadicNegOnePrincipal ∈
        serrePadicPrincipalUnitDeepSubgroup 2 0 1 :=
    (QuotientGroup.eq_one_iff _).1 heq
  exact serrePadicDyadicNegOnePrincipal_not_mem_levelTwo hmem

/-- The dyadic sign has exact order two in U₁. -/
theorem serrePadicDyadicNegOnePrincipal_order_two :
    orderOf (serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) = 2 := by
  have hne : (serrePadicDyadicNegOnePrincipal :
      serrePadicPrincipalUnits 2 1) ≠ 1 := by
    intro heq
    apply serrePadicDyadicNegOnePrincipal_not_mem_levelTwo
    rw [heq]
    exact Subgroup.one_mem _
  exact orderOf_eq_prime serrePadicDyadicNegOnePrincipal_sq hne

/--
The class of the sign generates the entire two-element quotient U₁/U₂.
This is the finite sign factor used in Serre's dyadic decomposition.
-/
theorem serrePadicDyadicNegOnePrincipal_quotient_generates :
    Subgroup.zpowers
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup 2 0 1))
        serrePadicDyadicNegOnePrincipal) = ⊤ := by
  let q : serrePadicPrincipalUnitFiniteQuotient 2 0 1 :=
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup 2 0 1))
      serrePadicDyadicNegOnePrincipal
  have hpow : q ^ 2 = 1 := by
    change ((QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup 2 0 1))
      serrePadicDyadicNegOnePrincipal) ^ 2 = 1
    rw [← map_pow, serrePadicDyadicNegOnePrincipal_sq, map_one]
  have hnot : q ≠ 1 :=
    serrePadicDyadicNegOnePrincipal_quotient_ne_one
  have horder : orderOf q = 2 :=
    orderOf_eq_prime hpow hnot
  have hcard :
      Nat.card (Subgroup.zpowers q) =
        Nat.card (serrePadicPrincipalUnitFiniteQuotient 2 0 1) := by
    calc
      Nat.card (Subgroup.zpowers q) = orderOf q := Nat.card_zpowers q
      _ = 2 := horder
      _ = Nat.card (serrePadicPrincipalUnitFiniteQuotient 2 0 1) :=
        (serrePadicPrincipalUnitFiniteQuotient_card 2 0 1).symm
  have hpositive : 0 < Nat.card (Subgroup.zpowers q) := by
    rw [hcard, serrePadicPrincipalUnitFiniteQuotient_card]
    decide
  letI : Finite (Subgroup.zpowers q) :=
    Nat.finite_of_card_ne_zero (Nat.ne_of_gt hpositive)
  exact Subgroup.eq_top_of_card_eq _ hcard

/--
Every element of U₁ lies in U₂ or becomes an element of U₂ when
multiplied by -1. This uses the index-two statement already proved
for the finite principal-unit quotient.
-/
theorem serrePadicDyadicPrincipalUnit_mem_levelTwo_or_sign_mul_mem
    (u : serrePadicPrincipalUnits 2 1) :
    u ∈ serrePadicPrincipalUnitDeepSubgroup 2 0 1 ∨
      serrePadicDyadicNegOnePrincipal * u ∈
        serrePadicPrincipalUnitDeepSubgroup 2 0 1 := by
  let K := serrePadicPrincipalUnitDeepSubgroup 2 0 1
  have hindex : K.index = 2 := by
    change Nat.card (serrePadicPrincipalUnitFiniteQuotient 2 0 1) = 2
    exact serrePadicPrincipalUnitFiniteQuotient_card 2 0 1
  have hsign : serrePadicDyadicNegOnePrincipal ∉ K :=
    serrePadicDyadicNegOnePrincipal_not_mem_levelTwo
  by_cases hu : u ∈ K
  · exact Or.inl hu
  · right
    exact (Subgroup.mul_mem_iff_of_index_two hindex
      (a := serrePadicDyadicNegOnePrincipal) (b := u)).2
        (by simp [hsign, hu])

end PadicPrincipalUnitDyadicSign

end SerreNumberTheoryAI
