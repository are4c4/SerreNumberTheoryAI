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

/--
The cyclic isomorphisms at each finite level glue to a group
isomorphism of their inverse limits, since every square with the
standard reduction transitions has already been proved commutative.
-/
noncomputable def serrePadicPrincipalUnitZModTowerEquivFiniteInverseLimit
    (n : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    serrePadicPrincipalUnitZModTower p ≃*
      serrePadicPrincipalUnitFiniteInverseLimit p n := by
  let e (k : ℕ) :
      Multiplicative (padicResidueRing p k) ≃*
        serrePadicPrincipalUnitFiniteQuotient p n (k + 1) :=
    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p n k hsource u hnot
  refine
    { toFun := fun z =>
        ⟨fun k => e k ((z : ∀ k, Multiplicative (padicResidueRing p k)) k),
          by
            intro k
            calc
              serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
                  (e (k + 1)
                    ((z : ∀ k, Multiplicative (padicResidueRing p k)) (k + 1))) =
                e k (serrePadicPrincipalUnitZModTransition p k
                  ((z : ∀ k, Multiplicative (padicResidueRing p k)) (k + 1))) :=
                    serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition
                      p n k hsource u hnot _
              _ = e k ((z : ∀ k, Multiplicative (padicResidueRing p k)) k) :=
                congrArg (e k) (z.property k)⟩
      invFun := fun y =>
        ⟨fun k => (e k).symm
            ((y : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k),
          by
            intro k
            apply (e k).injective
            calc
              e k (serrePadicPrincipalUnitZModTransition p k
                  ((e (k + 1)).symm
                    ((y : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1))
                      (k + 1)))) =
                serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
                  (e (k + 1) ((e (k + 1)).symm
                    ((y : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1))
                      (k + 1)))) :=
                    (serrePadicPrincipalUnitFiniteQuotientCyclicEquiv_transition
                      p n k hsource u hnot _).symm
              _ = serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
                    ((y : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1))
                      (k + 1)) := by
                  rw [MulEquiv.apply_symm_apply]
              _ = ((y : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) :=
                y.property k
              _ = e k ((e k).symm
                    ((y : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1))
                      k)) := ((e k).apply_symm_apply _).symm⟩
      left_inv := by
        intro z
        apply Subtype.ext
        funext k
        exact (e k).symm_apply_apply _
      right_inv := by
        intro y
        apply Subtype.ext
        funext k
        exact (e k).apply_symm_apply _
      map_mul' := by
        intro z w
        apply Subtype.ext
        funext k
        exact (e k).map_mul
          ((z : ∀ k, Multiplicative (padicResidueRing p k)) k)
          ((w : ∀ k, Multiplicative (padicResidueRing p k)) k) }

end PadicPrincipalUnitZModTower

end SerreNumberTheoryAI
