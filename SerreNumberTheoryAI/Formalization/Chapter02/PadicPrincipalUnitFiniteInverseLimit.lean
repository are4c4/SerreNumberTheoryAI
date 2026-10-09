import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientCompatibility

/-!
# An inverse-limit subgroup for the finite principal-unit quotients

Serre Chapter 2 §3.2: after proving the finite quotient identifications
and their compatibility, we collect the compatible sequences into a
subgroup of the direct product.  This construction is project-local
and does not assume the desired p-adic unit structure theorem.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitFiniteInverseLimit

variable (p : ℕ) [Fact p.Prime]

/--
The group of coherent residue classes in the tower
U_(n+1)/U_(n+k+2), k >= 0.
-/
def serrePadicPrincipalUnitFiniteInverseLimit (n : ℕ) :
    Subgroup (∀ k : ℕ, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) where
  carrier := { x | ∀ k,
    serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      (x (k + 1)) = x k }
  one_mem' := by
    intro k
    exact map_one (serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1))
  mul_mem' := by
    intro x y hx hy k
    change serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      (x (k + 1) * y (k + 1)) = x k * y k
    rw [map_mul, hx k, hy k]
  inv_mem' := by
    intro x hx k
    change serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
      ((x (k + 1))⁻¹) = (x k)⁻¹
    rw [map_inv, hx k]

/-- Membership in the inverse limit is exactly adjacent-stage compatibility. -/
theorem mem_serrePadicPrincipalUnitFiniteInverseLimit
    (n : ℕ)
    (x : ∀ k : ℕ, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) :
    x ∈ serrePadicPrincipalUnitFiniteInverseLimit p n ↔
      ∀ k, serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
        (x (k + 1)) = x k := Iff.rfl

/--
The canonical map from a principal unit to its compatible family of
classes in all finite quotients. This is the natural map to the
project-local inverse limit, prior to proving it is bijective.
-/
def serrePadicPrincipalUnitToFiniteInverseLimit (n : ℕ) :
    serrePadicPrincipalUnits p (n + 1) →*
      serrePadicPrincipalUnitFiniteInverseLimit p n where
  toFun u :=
    ⟨fun k => (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u,
      by
        intro k
        exact serrePadicPrincipalUnitFiniteQuotientTransition_mk p n
          (k + 1) u⟩
  map_one' := by
    apply Subtype.ext
    funext k
    exact map_one (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
  map_mul' u v := by
    apply Subtype.ext
    funext k
    exact map_mul (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u v

@[simp]
theorem serrePadicPrincipalUnitToFiniteInverseLimit_apply
    (n k : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    ((serrePadicPrincipalUnitToFiniteInverseLimit p n u :
      serrePadicPrincipalUnitFiniteInverseLimit p n) :
      ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u := rfl

/--
Separation of the project-local principal-unit filtration: the only
principal unit in arbitrarily deep layers is the identity.  We prove
this from all residue projections of the project-local p-adic integer,
rather than from a black-box completion theorem.
-/
theorem serrePadicPrincipalUnit_deep_separated
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1))
    (hdeep : ∀ k : ℕ,
      (u : (SerrePadicInt p)ˣ) ∈
        serrePadicPrincipalUnits p (n + k + 2)) :
    u = 1 := by
  apply Subtype.ext
  apply Units.ext
  apply serrePadicInt_ext p
  intro k
  have hdiv :
      (p : SerrePadicInt p) ^ (n + k + 2) ∣
        (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) :=
    (mem_serrePadicPrincipalUnits_succ_iff_pow_dvd p (n + k + 1)
      (u : (SerrePadicInt p)ˣ)).1 (by
        simpa only [Nat.add_assoc] using hdeep k)
  have hsmall :
      (p : SerrePadicInt p) ^ (k + 1) ∣
        (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) :=
    (pow_dvd_pow (p : SerrePadicInt p) (by omega)).trans hdiv
  have hzero :=
    (pow_dvd_serrePadicInt_iff_proj_zero p k _).1 hsmall
  change serrePadicIntProj p k
      ((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) =
    serrePadicIntProj p k (1 : SerrePadicInt p)
  rw [map_one]
  apply sub_eq_zero.mp
  simpa only [map_sub, map_one] using hzero

/--
The natural map from source principal units to the inverse limit of
their finite quotients is injective.
-/
theorem serrePadicPrincipalUnitToFiniteInverseLimit_injective
    (n : ℕ) :
    Function.Injective (serrePadicPrincipalUnitToFiniteInverseLimit p n) := by
  intro u v huv
  have hdeep : ∀ k : ℕ,
      ((u * v⁻¹ : serrePadicPrincipalUnits p (n + 1)) :
        (SerrePadicInt p)ˣ) ∈
      serrePadicPrincipalUnits p (n + k + 2) := by
    intro k
    have hcoords := congrArg
      (fun x : serrePadicPrincipalUnitFiniteInverseLimit p n =>
        (x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) huv
    have heq :
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) =
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) v) := by
      simpa only [serrePadicPrincipalUnitToFiniteInverseLimit_apply] using hcoords
    have hone :
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) (u * v⁻¹)) = 1 := by
      rw [map_mul, map_inv, heq, mul_inv_cancel]
    exact (QuotientGroup.eq_one_iff _).1 hone
  have hunit := serrePadicPrincipalUnit_deep_separated p n (u * v⁻¹) hdeep
  exact mul_inv_eq_one.mp hunit

end PadicPrincipalUnitFiniteInverseLimit

end SerreNumberTheoryAI
