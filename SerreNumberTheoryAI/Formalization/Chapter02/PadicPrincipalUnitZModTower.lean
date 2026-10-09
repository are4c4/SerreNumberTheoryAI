import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitInverseLimitReconstruction

/-!
# Reindexing project p-adic integers as the additive residue tower

The project-local p-adic integers were defined in §1.1 as compatible
sequences of residue-ring elements. Interpreting addition as
multiplication yields the source's finite cyclic inverse system.
This is not an imported p-adic unit structure theorem.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitZModTower

variable (p : ℕ) [Fact p.Prime]

/-- Compatible residue rings, regarded as a subgroup of multiplicative type tags. -/
def serrePadicPrincipalUnitZModTower :
    Subgroup (∀ k : ℕ, Multiplicative (padicResidueRing p k)) where
  carrier := {x | ∀ k,
    serrePadicPrincipalUnitZModTransition p k (x (k + 1)) = x k}
  one_mem' := by
    intro k
    exact map_one (serrePadicPrincipalUnitZModTransition p k)
  mul_mem' := by
    intro x y hx hy k
    change serrePadicPrincipalUnitZModTransition p k
      (x (k + 1) * y (k + 1)) = x k * y k
    rw [map_mul, hx k, hy k]
  inv_mem' := by
    intro x hx k
    change serrePadicPrincipalUnitZModTransition p k
      ((x (k + 1))⁻¹) = (x k)⁻¹
    rw [map_inv, hx k]

/--
The project p-adic integers, considered additively, are exactly the
compatible residue tower with the multiplicative type tag.
-/
def serrePadicIntMultiplicativeEquivZModTower :
    Multiplicative (SerrePadicInt p) ≃*
      serrePadicPrincipalUnitZModTower p where
  toFun z := ⟨fun k => Multiplicative.ofAdd
      (serrePadicIntProj p k (Multiplicative.toAdd z)), by
        intro k
        change Multiplicative.ofAdd
          (padicReduction p k
            (serrePadicIntProj p (k + 1) (Multiplicative.toAdd z))) =
          Multiplicative.ofAdd
            (serrePadicIntProj p k (Multiplicative.toAdd z))
        rw [serrePadicIntProj_compat]⟩
  invFun z := Multiplicative.ofAdd
    (⟨fun k => Multiplicative.toAdd
      ((z : ∀ k, Multiplicative (padicResidueRing p k)) k),
      by
        intro k
        have h := z.property k
        exact congrArg Multiplicative.toAdd h⟩ : SerrePadicInt p)
  left_inv z := by
    apply congrArg Multiplicative.ofAdd
    apply serrePadicInt_ext p
    intro k
    rfl
  right_inv z := by
    apply Subtype.ext
    funext k
    rfl
  map_mul' x y := by
    apply Subtype.ext
    funext k
    change Multiplicative.ofAdd
      (serrePadicIntProj p k (Multiplicative.toAdd x + Multiplicative.toAdd y)) =
        Multiplicative.ofAdd (serrePadicIntProj p k (Multiplicative.toAdd x)) *
          Multiplicative.ofAdd (serrePadicIntProj p k (Multiplicative.toAdd y))
    rw [map_add]
    rfl

end PadicPrincipalUnitZModTower

end SerreNumberTheoryAI
