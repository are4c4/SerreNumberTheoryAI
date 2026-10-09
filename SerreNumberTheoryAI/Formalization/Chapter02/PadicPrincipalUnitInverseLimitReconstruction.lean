import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitResidueQuotient
import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricTopology

/-!
# Reconstructing project principal units from coherent finite quotients

The source's inverse-limit argument in §3.2 requires extracting
compatible representatives of every finite principal-unit quotient.
The lemmas below are preparatory: they do not yet claim the resulting
map to project p-adic units is surjective.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitInverseLimitReconstruction

variable (p : ℕ) [Fact p.Prime]

/-- Choose a source principal-unit representative at each finite-quotient level. -/
noncomputable def serrePadicPrincipalUnitFiniteInverseLimitRep
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicPrincipalUnits p (n + 1) :=
  Quotient.out
    ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k)

/-- The chosen representative maps to the specified finite quotient class. -/
theorem serrePadicPrincipalUnitFiniteInverseLimitRep_spec
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) =
    ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) := by
  exact Quotient.out_eq'

/--
Adjacent representatives are congruent in the *shallower* finite quotient.
This is the projective compatibility needed to glue residue coordinates.
-/
theorem serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) := by
  calc
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
      serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 2)))
          (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x)) := by
            symm
            exact serrePadicPrincipalUnitFiniteQuotientTransition_mk p n (k + 1) _
    _ = serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
          ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1))
            (k + 1)) := by
          rw [serrePadicPrincipalUnitFiniteInverseLimitRep_spec]
    _ = ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) :=
      x.property k
    _ = (QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) :=
      (serrePadicPrincipalUnitFiniteInverseLimitRep_spec p n k x).symm

/--
Adjacent chosen representatives have the same finite residue at the
shallower level, by the quotient-residue comparison.
-/
theorem serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent_residue
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicPrincipalUnitResidueHom p n k
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
    serrePadicPrincipalUnitResidueHom p n k
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) :=
  (serrePadicPrincipalUnitFiniteQuotient_mk_eq_iff_residue_eq p n k
    (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x)
    (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x)).1
    (serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent p n k x)

/--
Adjacent representatives have equal project p-adic residues at the
higher modulus p^(n+k+2).
-/
theorem serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent_proj
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicIntProj p (n + k + 1)
      (((serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x :
          serrePadicPrincipalUnits p (n + 1)) :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) =
    serrePadicIntProj p (n + k + 1)
      (((serrePadicPrincipalUnitFiniteInverseLimitRep p n k x :
          serrePadicPrincipalUnits p (n + 1)) :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) := by
  have h :=
    serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent_residue p n k x
  have hval := congrArg
    (fun z : (padicResidueRing p (n + k + 1))ˣ =>
      (z : padicResidueRing p (n + k + 1))) h
  simpa [serrePadicPrincipalUnitResidueHom,
    serrePadicUnitReductionLevel] using hval

/--
A compatible inverse system of finite principal-unit classes determines
an element of the project-local p-adic integer ring by its residue
coordinates. The next step is to show this element is a principal unit.
-/
noncomputable def serrePadicPrincipalUnitFiniteInverseLimitToPadicInt
    (n : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    SerrePadicInt p :=
  ⟨fun k => serrePadicIntProj p k
      (((serrePadicPrincipalUnitFiniteInverseLimitRep p n k x :
        serrePadicPrincipalUnits p (n + 1)) :
        (SerrePadicInt p)ˣ) : SerrePadicInt p),
    by
      intro k
      have hhigh :=
        serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent_proj p n k x
      have hlow :=
        serrePadicIntProj_eq_of_le p (m := k) (n := n + k + 1)
          (by omega) hhigh
      exact (serrePadicIntProj_compat p k
          (((serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x :
            serrePadicPrincipalUnits p (n + 1)) :
            (SerrePadicInt p)ˣ) : SerrePadicInt p)).trans hlow⟩

@[simp]
theorem serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_proj
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicIntProj p k
      (serrePadicPrincipalUnitFiniteInverseLimitToPadicInt p n x) =
    serrePadicIntProj p k
      (((serrePadicPrincipalUnitFiniteInverseLimitRep p n k x :
        serrePadicPrincipalUnits p (n + 1)) :
        (SerrePadicInt p)ˣ) : SerrePadicInt p) := rfl

end PadicPrincipalUnitInverseLimitReconstruction

end SerreNumberTheoryAI
