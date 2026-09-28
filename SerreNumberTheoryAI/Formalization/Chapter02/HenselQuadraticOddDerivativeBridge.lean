import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticCorollary

/-!
# Algebraic derivative bridge for odd-prime quadratic forms

This file isolates the polynomial-algebra part of Serre's odd-prime quadratic
corollary.  It starts from a single quadratic monomial and builds toward the
expanded symmetric gradient formula without mixing in the residue/determinant
argument.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticOddDerivativeBridge

/--
Evaluating the partial derivative of one quadratic monomial contributes one
term from each occurrence of the selected variable.
-/
theorem serreQuadraticTerm_pderiv_eval
    {σ : Type*} [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    (a : SerrePadicInt p) (x : σ → SerrePadicInt p) (i k j : σ) :
    MvPolynomial.eval x
        (MvPolynomial.pderiv j
          (MvPolynomial.C a * MvPolynomial.X i * MvPolynomial.X k)) =
      (if j = i then a * x k else 0) +
        (if j = k then a * x i else 0) := by
  by_cases hji : j = i <;> by_cases hjk : j = k
  · subst i
    subst k
    simp [MvPolynomial.pderiv_mul]
  · subst i
    simp [MvPolynomial.pderiv_mul, hjk]
  · subst k
    simp [MvPolynomial.pderiv_mul, hji]
  · simp [MvPolynomial.pderiv_mul, hji, hjk]

/--
Summing the monomial formula shows that the formal derivative is the sum of
the selected row and selected column of the coordinate matrix.
-/
theorem serreQuadraticGradientCoordinate_eq_row_add_column
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    serreQuadraticGradientCoordinate A x j =
      (∑ i : σ, A j i * x i) + ∑ i : σ, A i j * x i := by
  classical
  unfold serreQuadraticGradientCoordinate serreQuadraticPolynomial
  simp_rw [map_sum]
  simp_rw [serreQuadraticTerm_pderiv_eval]
  simp [Finset.sum_add_distrib, eq_comm]


end HenselQuadraticOddDerivativeBridge

end

end SerreNumberTheoryAI
