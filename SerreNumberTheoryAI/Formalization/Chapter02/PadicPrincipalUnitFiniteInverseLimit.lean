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

end PadicPrincipalUnitFiniteInverseLimit

end SerreNumberTheoryAI
