import Mathlib
import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegers

/-!
# Common zeros over the project p-adic integers

Independent formalization of Serre, Chapter 2, §2.1.

Source metadata only: Japanese edition, printed pp. 18–19, uploaded PDF pp. 28–29.
This file uses the project-local inverse-limit `SerrePadicInt` from §1.1 and generic
finite inverse-limit / compactness infrastructure; it does not use a completed Hensel
or p-adic root-lifting theorem as a black box.
-/

namespace SerreNumberTheoryAI

open CategoryTheory

noncomputable section

section RootExistence

universe u v

/--
A generic finite inverse-limit nonemptiness lemma: an inverse system of nonempty finite
sets over a directed preorder has a nonempty space of compatible sections.
-/
theorem finiteInverseLimit_nonempty
    {J : Type u} [Preorder J] [IsDirectedOrder J]
    (F : Jᵒᵖ ⥤ Type v)
    [∀ j : Jᵒᵖ, Finite (F.obj j)] [∀ j : Jᵒᵖ, Nonempty (F.obj j)] :
    F.sections.Nonempty :=
  nonempty_sections_of_finite_inverse_system F

variable {σ ι : Type*}

/-- Reduce all coefficients of a multivariate polynomial to a finite residue level. -/
def padicPolynomialReduction (p n : ℕ) :
    MvPolynomial σ (SerrePadicInt p) →+* MvPolynomial σ (padicResidueRing p n) :=
  MvPolynomial.map (serrePadicIntProj p n)

/-- Polynomial evaluation commutes with residue projection. -/
theorem padicPolynomialReduction_eval
    (p n : ℕ) (f : MvPolynomial σ (SerrePadicInt p))
    (x : σ → SerrePadicInt p) :
    serrePadicIntProj p n (MvPolynomial.eval x f) =
      MvPolynomial.eval (fun s => serrePadicIntProj p n (x s))
        (padicPolynomialReduction p n f) := by
  simpa [padicPolynomialReduction, Function.comp_def] using
    (MvPolynomial.map_eval (serrePadicIntProj p n) x f)

/-- Common zeros of a polynomial family after reduction to one residue level. -/
def padicReducedCommonZeroSet
    (p n : ℕ) (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    Set (σ → padicResidueRing p n) :=
  {x | ∀ i, MvPolynomial.eval x (padicPolynomialReduction p n (f i)) = 0}

/--
P-adic tuples whose values on every polynomial vanish after projection to level `n`.
These are the finite-level approximation sets used in the inverse-limit argument.
-/
def padicApproxCommonZeroSet
    (p n : ℕ) (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    Set (σ → SerrePadicInt p) :=
  {x | ∀ i, serrePadicIntProj p n (MvPolynomial.eval x (f i)) = 0}

/-- The finite-level approximation sets form a decreasing sequence. -/
theorem padicApproxCommonZeroSet_antitone
    (p : ℕ) (f : ι → MvPolynomial σ (SerrePadicInt p)) (n : ℕ) :
    padicApproxCommonZeroSet p (n + 1) f ⊆ padicApproxCommonZeroSet p n f := by
  intro x hx i
  change serrePadicIntProj p n (MvPolynomial.eval x (f i)) = 0
  rw [← serrePadicIntProj_compat p n (MvPolynomial.eval x (f i))]
  rw [show serrePadicIntProj p (n + 1) (MvPolynomial.eval x (f i)) = 0 by
    exact hx i]
  exact map_zero (padicReduction p n)

/-- A finite-level common zero can be lifted coordinatewise to a p-adic approximation. -/
theorem padicApproxCommonZeroSet_nonempty_of_reduced
    (p n : ℕ) (f : ι → MvPolynomial σ (SerrePadicInt p))
    (h : (padicReducedCommonZeroSet p n f).Nonempty) :
    (padicApproxCommonZeroSet p n f).Nonempty := by
  rcases h with ⟨a, ha⟩
  choose x hx using fun s : σ => serrePadicIntProj_surjective p n (a s)
  refine ⟨x, ?_⟩
  intro i
  rw [padicPolynomialReduction_eval p n (f i) x]
  have hxa : (fun s => serrePadicIntProj p n (x s)) = a := by
    funext s
    exact hx s
  rw [hxa]
  exact ha i

/-- Each finite-level approximation set is closed in the product topology. -/
theorem padicApproxCommonZeroSet_isClosed
    (p n : ℕ) [Fact p.Prime] [Fintype σ]
    (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    IsClosed (padicApproxCommonZeroSet p n f) := by
  let proj : (σ → SerrePadicInt p) → (σ → padicResidueRing p n) :=
    fun x s => serrePadicIntProj p n (x s)
  have hproj : Continuous proj := by
    apply continuous_pi
    intro s
    exact (serrePadicIntProj_continuous p n).comp (continuous_apply s)
  have hset :
      padicApproxCommonZeroSet p n f =
        proj ⁻¹' padicReducedCommonZeroSet p n f := by
    ext x
    constructor
    · intro hx i
      change MvPolynomial.eval (proj x) (padicPolynomialReduction p n (f i)) = 0
      rw [← padicPolynomialReduction_eval p n (f i) x]
      exact hx i
    · intro hx i
      change serrePadicIntProj p n (MvPolynomial.eval x (f i)) = 0
      rw [padicPolynomialReduction_eval p n (f i) x]
      exact hx i
  rw [hset]
  exact (Set.toFinite (padicReducedCommonZeroSet p n f)).isClosed.preimage hproj

/--
Serre's Proposition 5: a family of polynomials over the project p-adic integers has a common
zero iff its reduction has a common zero at every finite residue level.
-/
theorem serre_proposition5_commonZero_iff_reductions
    (p : ℕ) [Fact p.Prime] [Fintype σ]
    (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    (∃ x : σ → SerrePadicInt p, ∀ i, MvPolynomial.eval x (f i) = 0) ↔
      ∀ n : ℕ, ∃ x : σ → padicResidueRing p n,
        ∀ i, MvPolynomial.eval x (padicPolynomialReduction p n (f i)) = 0 := by
  constructor
  · rintro ⟨x, hx⟩ n
    refine ⟨fun s => serrePadicIntProj p n (x s), ?_⟩
    intro i
    rw [← padicPolynomialReduction_eval p n (f i) x, hx i, map_zero]
  · intro hred
    let C : ℕ → Set (σ → SerrePadicInt p) := fun n => padicApproxCommonZeroSet p n f
    have hCn : ∀ n, (C n).Nonempty := by
      intro n
      apply padicApproxCommonZeroSet_nonempty_of_reduced p n f
      rcases hred n with ⟨x, hx⟩
      exact ⟨x, hx⟩
    have hCclosed : ∀ n, IsClosed (C n) := by
      intro n
      exact padicApproxCommonZeroSet_isClosed p n f
    have hCmono : ∀ n, C (n + 1) ⊆ C n := by
      intro n
      exact padicApproxCommonZeroSet_antitone p f n
    have hC0compact : IsCompact (C 0) :=
      (hCclosed 0).isCompact
    obtain ⟨x, hx⟩ :=
      IsCompact.nonempty_iInter_of_sequence_nonempty_isCompact_isClosed
        C hCmono hCn hC0compact hCclosed
    refine ⟨x, ?_⟩
    intro i
    apply serrePadicInt_ext p
    intro n
    have hxn : x ∈ C n := by
      exact Set.mem_iInter.mp hx n
    change serrePadicIntProj p n (MvPolynomial.eval x (f i)) =
      serrePadicIntProj p n 0
    rw [map_zero]
    exact hxn i

end RootExistence

end

end SerreNumberTheoryAI
