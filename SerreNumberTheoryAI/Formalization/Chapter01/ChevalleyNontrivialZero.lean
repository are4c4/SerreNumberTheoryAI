import SerreNumberTheoryAI.Formalization.Chapter01.Chevalley

/-!
# First corollary of Chevalley–Warning

Independent formalization of the first corollary following Serre's
Chevalley–Warning theorem in Chapter 1, §2, 2.2.

Source metadata only: Japanese edition, printed p. 7, uploaded PDF p. 17.
-/

namespace SerreNumberTheoryAI

open MvPolynomial

section ChevalleyNontrivialZero

variable {K σ ι : Type*} [Fintype K] [Field K] [Fintype σ] [DecidableEq σ]
variable [DecidableEq K]

/--
If a finite family of multivariate polynomials has total-degree sum smaller
than the number of variables and every polynomial vanishes at the origin,
then the family has a common zero different from the origin.

This is the direct counting corollary of the project-local Chevalley–Warning
theorem: the origin is one common zero, while a singleton common-zero set
cannot have cardinality divisible by the characteristic.
-/
theorem serre_chevalleyWarning_exists_nontrivial_zero
    (p : ℕ) [CharP K p]
    {s : Finset ι} {f : ι → MvPolynomial σ K}
    (hdeg : (∑ i ∈ s, (f i).totalDegree) < Fintype.card σ)
    (hzero : ∀ i ∈ s, eval (0 : σ → K) (f i) = 0) :
    ∃ x : σ → K, x ≠ 0 ∧ ∀ i ∈ s, eval x (f i) = 0 := by
  classical
  by_contra hno
  have honly :
      ∀ x : σ → K, (∀ i ∈ s, eval x (f i) = 0) → x = 0 := by
    intro x hx
    by_contra hx0
    exact hno ⟨x, hx0, hx⟩

  let z0 : {x : σ → K // ∀ i ∈ s, eval x (f i) = 0} := ⟨0, hzero⟩
  letI : Unique {x : σ → K // ∀ i ∈ s, eval x (f i) = 0} :=
    { default := z0
      uniq := by
        intro z
        apply Subtype.ext
        exact honly z.1 z.2 }

  have hcard :
      Fintype.card {x : σ → K // ∀ i ∈ s, eval x (f i) = 0} = 1 :=
    Fintype.card_unique
  have hdiv :
      p ∣ Fintype.card {x : σ → K // ∀ i ∈ s, eval x (f i) = 0} :=
    serre_chevalleyWarning (K := K) (σ := σ) (ι := ι) p hdeg
  rw [hcard] at hdiv
  have hcast : (1 : K) = 0 := by
    simpa using (CharP.cast_eq_zero_iff K p 1).2 hdiv
  exact one_ne_zero hcast

end ChevalleyNontrivialZero

end SerreNumberTheoryAI
