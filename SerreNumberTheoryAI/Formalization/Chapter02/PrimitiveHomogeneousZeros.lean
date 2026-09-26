import SerreNumberTheoryAI.Formalization.Chapter02.RootExistence
import SerreNumberTheoryAI.Formalization.Chapter02.PadicFieldTopology

/-!
# Primitive homogeneous p-adic zeros

Independent formalization of the primitive/inverse-limit part of Serre, Chapter 2, §2.1,
Proposition 6.

The source notion “primitive” means that at least one coordinate is a unit.  This file first
shows that this condition is compatible with all finite residue projections, then strengthens
the compact inverse-limit proof of Proposition 5 to primitive common zeros.  The project-local
`SerrePadicInt` and `SerrePadicField` constructions are used throughout.
-/

namespace SerreNumberTheoryAI

noncomputable section

section PrimitiveHomogeneousZeros

variable {σ ι : Type*}

/-- Reduction from any project residue level to the first residue field `A₁ = Z/pZ`. -/
def padicResidueToFirst (p n : ℕ) :
    padicResidueRing p n →+* padicResidueRing p 0 :=
  ZMod.castHom
    (pow_dvd_pow p (Nat.add_le_add_right (Nat.zero_le n) 1))
    (padicResidueRing p 0)

/-- Higher project coordinates reduce to the first residue coordinate. -/
theorem padicResidueToFirst_proj
    (p n : ℕ) (x : SerrePadicInt p) :
    padicResidueToFirst p n (serrePadicIntProj p n x) =
      serrePadicIntProj p 0 x := by
  simpa [padicResidueToFirst] using
    serrePadicIntProj_cast_of_le p x (m := 0) (n := n) (Nat.zero_le n)

/-- A project p-adic tuple is primitive when at least one coordinate is a unit. -/
def serrePadicTuplePrimitive (x : σ → SerrePadicInt p) : Prop :=
  ∃ s, IsUnit (x s)

/-- A finite residue tuple is primitive when at least one coordinate is a unit. -/
def padicReducedTuplePrimitive (x : σ → padicResidueRing p n) : Prop :=
  ∃ s, IsUnit (x s)

/-- A primitive project p-adic tuple remains primitive after every residue projection. -/
theorem padicReducedTuplePrimitive_proj
    (p n : ℕ) (x : σ → SerrePadicInt p)
    (hx : serrePadicTuplePrimitive x) :
    padicReducedTuplePrimitive (fun s => serrePadicIntProj p n (x s)) := by
  rcases hx with ⟨s, hs⟩
  exact ⟨s, hs.map (serrePadicIntProj p n)⟩

/--
If a lift has a primitive image at one residue level, then the lifted p-adic tuple is primitive.
The key point is that a unit remains a unit after reduction to the first residue field.
-/
theorem serrePadicTuplePrimitive_of_reduced
    (p n : ℕ) [Fact p.Prime]
    (x : σ → SerrePadicInt p)
    (hx : padicReducedTuplePrimitive (fun s => serrePadicIntProj p n (x s))) :
    serrePadicTuplePrimitive x := by
  rcases hx with ⟨s, hs⟩
  have hfirstUnit :
      IsUnit (padicResidueToFirst p n (serrePadicIntProj p n (x s))) :=
    hs.map (padicResidueToFirst p n)
  have hfirst : IsUnit (serrePadicIntProj p 0 (x s)) := by
    rw [padicResidueToFirst_proj p n (x s)] at hfirstUnit
    exact hfirstUnit
  exact ⟨s, serrePadicInt_isUnit_of_proj_zero_isUnit p (x s) hfirst⟩

/-- Primitivity is equivalent to nonvanishing of the tuple in the first residue field. -/
theorem serrePadicTuplePrimitive_iff_firstProj_ne_zero
    (p : ℕ) [Fact p.Prime] (x : σ → SerrePadicInt p) :
    serrePadicTuplePrimitive x ↔
      (fun s => serrePadicIntProj p 0 (x s)) ≠ 0 := by
  constructor
  · rintro ⟨s, hs⟩ hzero
    have hcoord : serrePadicIntProj p 0 (x s) = 0 := by
      simpa using congrFun hzero s
    exact ((serrePadicInt_isUnit_iff_proj_zero_ne_zero p (x s)).1 hs) hcoord
  · intro h
    classical
    by_contra hnot
    apply h
    funext s
    by_contra hne
    apply hnot
    exact ⟨s, (serrePadicInt_isUnit_iff_proj_zero_ne_zero p (x s)).2 hne⟩

/-- The primitive locus in a finite product of project p-adic integers is closed. -/
theorem serrePadicTuplePrimitive_isClosed
    (p : ℕ) [Fact p.Prime] [Fintype σ] :
    IsClosed {x : σ → SerrePadicInt p | serrePadicTuplePrimitive x} := by
  let proj0 : (σ → SerrePadicInt p) → (σ → padicResidueRing p 0) :=
    fun x s => serrePadicIntProj p 0 (x s)
  have hproj : Continuous proj0 := by
    apply continuous_pi
    intro s
    exact (serrePadicIntProj_continuous p 0).comp (continuous_apply s)
  have hset :
      {x : σ → SerrePadicInt p | serrePadicTuplePrimitive x} =
        proj0 ⁻¹' {y : σ → padicResidueRing p 0 | y ≠ 0} := by
    ext x
    change serrePadicTuplePrimitive x ↔ proj0 x ≠ 0
    simpa [proj0] using serrePadicTuplePrimitive_iff_firstProj_ne_zero p x
  rw [hset]
  exact (Set.toFinite {y : σ → padicResidueRing p 0 | y ≠ 0}).isClosed.preimage hproj

/-- Primitive p-adic tuples satisfying the common-zero equations modulo one residue level. -/
def padicPrimitiveApproxCommonZeroSet
    (p n : ℕ) (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    Set (σ → SerrePadicInt p) :=
  padicApproxCommonZeroSet p n f ∩
    {x | serrePadicTuplePrimitive x}

/-- Primitive approximation sets are decreasing with the residue level. -/
theorem padicPrimitiveApproxCommonZeroSet_antitone
    (p : ℕ) (f : ι → MvPolynomial σ (SerrePadicInt p)) (n : ℕ) :
    padicPrimitiveApproxCommonZeroSet p (n + 1) f ⊆
      padicPrimitiveApproxCommonZeroSet p n f := by
  rintro x ⟨hx, hprim⟩
  exact ⟨padicApproxCommonZeroSet_antitone p f n hx, hprim⟩

/-- Primitive approximation sets are closed. -/
theorem padicPrimitiveApproxCommonZeroSet_isClosed
    (p n : ℕ) [Fact p.Prime] [Fintype σ]
    (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    IsClosed (padicPrimitiveApproxCommonZeroSet p n f) := by
  exact (padicApproxCommonZeroSet_isClosed p n f).inter
    (serrePadicTuplePrimitive_isClosed p)

/--
A primitive finite-level common zero lifts coordinatewise to a primitive p-adic approximation
at the same level.
-/
theorem padicPrimitiveApproxCommonZeroSet_nonempty_of_reduced
    (p n : ℕ) [Fact p.Prime]
    (f : ι → MvPolynomial σ (SerrePadicInt p))
    (h : ∃ a : σ → padicResidueRing p n,
      padicReducedTuplePrimitive a ∧
        ∀ i, MvPolynomial.eval a (padicPolynomialReduction p n (f i)) = 0) :
    (padicPrimitiveApproxCommonZeroSet p n f).Nonempty := by
  rcases h with ⟨a, haPrim, haZero⟩
  choose x hx using fun s : σ => serrePadicIntProj_surjective p n (a s)
  refine ⟨x, ?_, ?_⟩
  · intro i
    rw [padicPolynomialReduction_eval p n (f i) x]
    have hxa : (fun s => serrePadicIntProj p n (x s)) = a := by
      funext s
      exact hx s
    rw [hxa]
    exact haZero i
  · apply serrePadicTuplePrimitive_of_reduced p n x
    simpa only [hx] using haPrim

/--
Primitive form of Serre's Proposition 5: a polynomial family has a primitive common zero over
project `Z_p` iff every finite residue reduction has a primitive common zero.
-/
theorem primitiveCommonZero_iff_reductions
    (p : ℕ) [Fact p.Prime] [Fintype σ]
    (f : ι → MvPolynomial σ (SerrePadicInt p)) :
    (∃ x : σ → SerrePadicInt p,
        serrePadicTuplePrimitive x ∧
          ∀ i, MvPolynomial.eval x (f i) = 0) ↔
      ∀ n : ℕ, ∃ a : σ → padicResidueRing p n,
        padicReducedTuplePrimitive a ∧
          ∀ i, MvPolynomial.eval a (padicPolynomialReduction p n (f i)) = 0 := by
  constructor
  · rintro ⟨x, hxPrim, hxZero⟩ n
    refine ⟨fun s => serrePadicIntProj p n (x s),
      padicReducedTuplePrimitive_proj p n x hxPrim, ?_⟩
    intro i
    rw [← padicPolynomialReduction_eval p n (f i) x, hxZero i, map_zero]
  · intro hred
    let C : ℕ → Set (σ → SerrePadicInt p) :=
      fun n => padicPrimitiveApproxCommonZeroSet p n f
    have hCn : ∀ n, (C n).Nonempty := by
      intro n
      exact padicPrimitiveApproxCommonZeroSet_nonempty_of_reduced p n f (hred n)
    have hCclosed : ∀ n, IsClosed (C n) := by
      intro n
      exact padicPrimitiveApproxCommonZeroSet_isClosed p n f
    have hCmono : ∀ n, C (n + 1) ⊆ C n := by
      intro n
      exact padicPrimitiveApproxCommonZeroSet_antitone p f n
    have hC0compact : IsCompact (C 0) :=
      (hCclosed 0).isCompact
    obtain ⟨x, hx⟩ :=
      IsCompact.nonempty_iInter_of_sequence_nonempty_isCompact_isClosed
        C hCmono hCn hC0compact hCclosed
    have hx0 : x ∈ C 0 := Set.mem_iInter.mp hx 0
    refine ⟨x, hx0.2, ?_⟩
    intro i
    apply serrePadicInt_ext p
    intro n
    have hxn : x ∈ C n := Set.mem_iInter.mp hx n
    change serrePadicIntProj p n (MvPolynomial.eval x (f i)) =
      serrePadicIntProj p n 0
    rw [map_zero]
    exact hxn.1 i

end PrimitiveHomogeneousZeros

end

end SerreNumberTheoryAI
