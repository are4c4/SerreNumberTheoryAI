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

end HenselQuadraticOddDerivativeBridge

end

end SerreNumberTheoryAI
