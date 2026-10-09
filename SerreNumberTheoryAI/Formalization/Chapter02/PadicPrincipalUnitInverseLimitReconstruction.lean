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

/-- The reconstructed project-local p-adic integer is a unit. -/
theorem serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_isUnit
    (n : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    IsUnit (serrePadicPrincipalUnitFiniteInverseLimitToPadicInt p n x) := by
  apply serrePadicInt_isUnit_of_proj_zero_isUnit p
  rw [serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_proj]
  exact ⟨serrePadicUnitReductionLevel p 0
    ((serrePadicPrincipalUnitFiniteInverseLimitRep p n 0 x :
      serrePadicPrincipalUnits p (n + 1)) : (SerrePadicInt p)ˣ), rfl⟩

/-- The unit represented by the reconstructed p-adic integer. -/
noncomputable def serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit
    (n : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (SerrePadicInt p)ˣ :=
  (serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_isUnit p n x).unit

@[simp]
theorem serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit_proj
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicIntProj p k
      ((serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit p n x :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) =
    serrePadicIntProj p k
      (((serrePadicPrincipalUnitFiniteInverseLimitRep p n k x :
          serrePadicPrincipalUnits p (n + 1)) :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) := by
  unfold serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit
  rw [IsUnit.unit_spec (serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_isUnit p n x)]
  exact serrePadicPrincipalUnitFiniteInverseLimitToPadicInt_proj p n k x

/--
The reconstructed unit belongs to the original principal-unit layer
U_(n+1), because its nth residue coordinate is that of a principal unit.
-/
theorem serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit_mem
    (n : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit p n x ∈
      serrePadicPrincipalUnits p (n + 1) := by
  change serrePadicUnitReductionLevel p n
    (serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit p n x) = 1
  apply Units.ext
  change serrePadicIntProj p n
      ((serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit p n x :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) = 1
  rw [serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit_proj]
  have hmem :=
    (serrePadicPrincipalUnitFiniteInverseLimitRep p n n x).property
  change serrePadicUnitReductionLevel p n
    ((serrePadicPrincipalUnitFiniteInverseLimitRep p n n x :
      serrePadicPrincipalUnits p (n + 1)) : (SerrePadicInt p)ˣ) = 1 at hmem
  have hval := congrArg
    (fun z : (padicResidueRing p n)ˣ =>
      (z : padicResidueRing p n)) hmem
  simpa [serrePadicUnitReductionLevel] using hval

/-- A canonical candidate inverse from the finite-unit tower to U_(n+1). -/
noncomputable def serrePadicPrincipalUnitFiniteInverseLimitToPrincipalUnit
    (n : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicPrincipalUnits p (n + 1) :=
  ⟨serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit p n x,
    serrePadicPrincipalUnitFiniteInverseLimitToPadicUnit_mem p n x⟩

end PadicPrincipalUnitInverseLimitReconstruction

end SerreNumberTheoryAI
