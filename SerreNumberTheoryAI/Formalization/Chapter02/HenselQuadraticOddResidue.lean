import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOdd

/-!
# First-residue bridge for odd-prime quadratic Hensel lifting

This file adds the next lightweight bridge after `HenselQuadraticOdd`: nonzero
first residue of a gradient expression gives valuation zero, and the first
residue of Serre's expanded symmetric gradient is expressed as a matrix-vector
coordinate over the first residue ring.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticOddResidue

/-- A nonzero first residue is exactly the valuation-zero input needed by Hensel. -/
theorem serrePadicIntAddValuation_eq_zero_of_firstResidue_ne_zero
    {p : ℕ} [Fact p.Prime] {z : SerrePadicInt p}
    (hz : serrePadicIntProj p 0 z ≠ 0) :
    serrePadicIntAddValuation p z = (0 : ℕ∞) := by
  have hz0 : z ≠ 0 := by
    intro hzero
    apply hz
    rw [hzero, map_zero]
  have horder : serrePadicIntOrder p z hz0 = 0 := by
    unfold serrePadicIntOrder
    exact (Nat.find_eq_zero _).2 hz
  simpa [horder] using serrePadicIntAddValuation_eq_order (p := p) hz0

/-- For odd prime `p`, the source factor `2` is nonzero in the first residue ring. -/
theorem serreFirstResidue_two_ne_zero_of_ne_two
    {p : ℕ} [Fact p.Prime] (hp2 : p ≠ 2) :
    (2 : padicResidueRing p 0) ≠ 0 := by
  intro hzero
  have hpowdvd : p ^ (0 + 1) ∣ 2 := by
    exact (ZMod.natCast_eq_zero_iff 2 (p ^ (0 + 1))).1
      (by simpa [padicResidueRing] using hzero)
  have hpdvd : p ∣ 2 := by
    simpa using hpowdvd
  exact hp2 ((Nat.prime_dvd_prime_iff_eq (Fact.out : p.Prime) Nat.prime_two).1 hpdvd)

/-- The first projection of the p-adic integer `2` is the residue class `2`. -/
theorem serrePadicIntProj_two
    (p : ℕ) :
    serrePadicIntProj p 0 (2 : SerrePadicInt p) = (2 : padicResidueRing p 0) := by
  rfl

/-- For odd prime `p`, the projected p-adic integer `2` is nonzero. -/
theorem serrePadicIntProj_two_ne_zero_of_ne_two
    {p : ℕ} [Fact p.Prime] (hp2 : p ≠ 2) :
    serrePadicIntProj p 0 (2 : SerrePadicInt p) ≠ 0 := by
  rw [serrePadicIntProj_two]
  exact serreFirstResidue_two_ne_zero_of_ne_two (p := p) hp2

/--
The first-residue matrix whose `j`-th row is the first residue of the `j`-th
Serre gradient column `i ↦ aᵢⱼ`.
-/
abbrev serreFirstResidueGradientMatrix
    {σ : Type*} {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) :
    Matrix σ σ (padicResidueRing p 0) :=
  fun j i => serrePadicIntProj p 0 (A i j)

/--
The matrix-vector coordinate of the first-residue gradient matrix is the first
residue of `Σᵢ aᵢⱼ xᵢ`.
-/
theorem serreFirstResidueGradientMatrix_mulVec
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    (serreFirstResidueGradientMatrix A).mulVec (serreFirstResidueVector p x) j =
      serrePadicIntProj p 0 (∑ i : σ, A i j * x i) := by
  rw [Matrix.mulVec]
  change (∑ i : σ, serrePadicIntProj p 0 (A i j) *
      serrePadicIntProj p 0 (x i)) =
    serrePadicIntProj p 0 (∑ i : σ, A i j * x i)
  simp [map_sum, map_mul]

/-- First residue of Serre's expanded symmetric gradient expression. -/
theorem serreQuadraticSymmetricGradientExpression_firstResidue
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    serrePadicIntProj p 0 (serreQuadraticSymmetricGradientExpression A x j) =
      serrePadicIntProj p 0 (2 : SerrePadicInt p) *
        (serreFirstResidueGradientMatrix A).mulVec (serreFirstResidueVector p x) j := by
  rw [serreQuadraticSymmetricGradientExpression, map_mul,
    ← serreFirstResidueGradientMatrix_mulVec (A := A) (x := x) (j := j)]

/--
A first-residue nonvanishing witness for the expanded symmetric gradient itself.
This is one step before proving that odd `p` makes the factor `2` harmless.
-/
def serreQuadraticOddFirstResidueExpressionWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ,
    serrePadicIntProj p 0 (serreQuadraticSymmetricGradientExpression A x j) ≠ 0

/--
A matrix-shaped first-residue witness for the expanded symmetric gradient,
including the source factor `2`.
-/
def serreQuadraticOddFirstResidueGradientWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ,
    serrePadicIntProj p 0 (2 : SerrePadicInt p) *
      (serreFirstResidueGradientMatrix A).mulVec (serreFirstResidueVector p x) j ≠ 0

/--
A nonzero matrix-vector coordinate gives the matrix-shaped gradient witness when
`p` is odd.
-/
theorem serreQuadraticOddFirstResidueGradientWitness_of_matrixCoordinateWitness
    {σ : Type*} [Fintype σ] [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (h : serreFirstResidueMatrixCoordinateWitness (serreFirstResidueGradientMatrix A) x) :
    serreQuadraticOddFirstResidueGradientWitness A x := by
  rcases h with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  haveI : Fact (Nat.Prime (p ^ 1)) := ⟨by simpa using (Fact.out : p.Prime)⟩
  haveI : NoZeroDivisors (padicResidueRing p 0) := by
    simpa [padicResidueRing] using (inferInstance : NoZeroDivisors (ZMod (p ^ 1)))
  exact mul_ne_zero (serrePadicIntProj_two_ne_zero_of_ne_two (p := p) hp2) hj

/-- The matrix-shaped first-residue witness gives the expression nonvanishing witness. -/
theorem serreQuadraticOddFirstResidueExpressionWitness_of_gradientWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientWitness A x) :
    serreQuadraticOddFirstResidueExpressionWitness A x := by
  rcases h with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  rw [serreQuadraticSymmetricGradientExpression_firstResidue]
  exact hj

/-- A nonzero first-residue expression gives the valuation-zero expression witness. -/
theorem serreQuadraticOddExpressionWitness_of_firstResidueExpressionWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueExpressionWitness A x) :
    serreQuadraticOddExpressionWitness A x := by
  rcases h with ⟨j, hj⟩
  exact ⟨j, serrePadicIntAddValuation_eq_zero_of_firstResidue_ne_zero hj⟩

/-- Matrix-shaped first-residue nonvanishing gives the valuation-zero expression witness. -/
theorem serreQuadraticOddExpressionWitness_of_firstResidueGradientWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientWitness A x) :
    serreQuadraticOddExpressionWitness A x :=
  serreQuadraticOddExpressionWitness_of_firstResidueExpressionWitness
    (serreQuadraticOddFirstResidueExpressionWitness_of_gradientWitness h)

end HenselQuadraticOddResidue

end

end SerreNumberTheoryAI
