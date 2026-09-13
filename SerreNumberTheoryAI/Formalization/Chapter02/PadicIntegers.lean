import Mathlib

/-!
# p-adic integers as an inverse limit

Independent formalization of Serre, Chapter 2, §1.1.

Source metadata only: Japanese edition, printed pp. 15–16, uploaded PDF pp. 25–26.
The construction here is project-local: it realizes the p-adic integers as compatible
sequences in the residue rings `ℤ / p^n ℤ`, rather than reusing mathlib's completed
`PadicInt` construction as a black box.
-/

namespace SerreNumberTheoryAI

section PadicIntegers

/-- The source residue ring `A_{n+1} = ℤ / p^(n+1)ℤ`, reindexed by `n : ℕ`. -/
abbrev padicResidueRing (p n : ℕ) := ZMod (p ^ (n + 1))

/-- Natural reduction from level `n+1` to level `n`. -/
def padicReduction (p n : ℕ) : padicResidueRing p (n + 1) →+* padicResidueRing p n :=
  ZMod.castHom (by
    apply pow_dvd_pow
    omega) _

/-- The adjacent residue reduction is surjective. -/
theorem padicReduction_surjective (p n : ℕ) : Function.Surjective (padicReduction p n) := by
  simpa [padicReduction, padicResidueRing] using
    ZMod.castHom_surjective (by
      apply pow_dvd_pow p
      omega : p ^ (n + 1) ∣ p ^ ((n + 1) + 1))

/--
The kernel of the adjacent reduction consists exactly of the multiples of `p^(n+1)`
in the source residue ring. This is the reindexed form of the source identity
`ker(φ_m) = p^(m-1) A_m`.
-/
theorem mem_ker_padicReduction_iff (p n : ℕ) (x : padicResidueRing p (n + 1)) :
    x ∈ RingHom.ker (padicReduction p n) ↔
      ∃ y : padicResidueRing p (n + 1),
        x = (p ^ (n + 1) : padicResidueRing p (n + 1)) * y := by
  constructor
  · intro hx
    change padicReduction p n x = 0 at hx
    obtain ⟨z, rfl⟩ := ZMod.intCast_surjective x
    have hz : ((z : ℤ) : padicResidueRing p n) = 0 := by
      simpa [padicReduction] using hx
    have hdvd : ((p ^ (n + 1) : ℕ) : ℤ) ∣ z :=
      (ZMod.intCast_zmod_eq_zero_iff_dvd z (p ^ (n + 1))).1 hz
    obtain ⟨k, rfl⟩ := hdvd
    refine ⟨(k : padicResidueRing p (n + 1)), ?_⟩
    simp
  · rintro ⟨y, rfl⟩
    change padicReduction p n
      ((p ^ (n + 1) : padicResidueRing p (n + 1)) * y) = 0
    rw [map_mul]
    have hpzero :
        padicReduction p n (p ^ (n + 1) : padicResidueRing p (n + 1)) = 0 := by
      rw [map_pow, map_natCast, ← Nat.cast_pow, ZMod.natCast_self]
    rw [hpzero, zero_mul]

/-- Compatibility condition defining the projective limit. -/
def padicCompatible (p : ℕ) (x : ∀ n : ℕ, padicResidueRing p n) : Prop :=
  ∀ n, padicReduction p n (x (n + 1)) = x n

/-- The p-adic integers as the subring of compatible residue sequences. -/
def serrePadicIntSubring (p : ℕ) : Subring (∀ n : ℕ, padicResidueRing p n) where
  carrier := {x | padicCompatible p x}
  zero_mem' := by
    intro n
    exact map_zero (padicReduction p n)
  one_mem' := by
    intro n
    exact map_one (padicReduction p n)
  add_mem' := by
    intro x y hx hy n
    change padicReduction p n (x (n + 1) + y (n + 1)) = x n + y n
    rw [map_add, hx n, hy n]
  mul_mem' := by
    intro x y hx hy n
    change padicReduction p n (x (n + 1) * y (n + 1)) = x n * y n
    rw [map_mul, hx n, hy n]
  neg_mem' := by
    intro x hx n
    change padicReduction p n (-x (n + 1)) = -x n
    rw [map_neg, hx n]

/-- Project-local type of p-adic integers. -/
abbrev SerrePadicInt (p : ℕ) := ↥(serrePadicIntSubring p)

/-- The `n`-th residue projection from the inverse limit. -/
def serrePadicIntProj (p n : ℕ) : SerrePadicInt p →+* padicResidueRing p n :=
  (Pi.evalRingHom (fun m : ℕ => padicResidueRing p m) n).comp (serrePadicIntSubring p).subtype

@[simp]
theorem serrePadicIntProj_apply (p n : ℕ) (x : SerrePadicInt p) :
    serrePadicIntProj p n x = x.1 n := rfl

/-- Two compatible sequences are equal when all their residue projections agree. -/
@[ext]
theorem serrePadicInt_ext (p : ℕ) {x y : SerrePadicInt p}
    (h : ∀ n, serrePadicIntProj p n x = serrePadicIntProj p n y) : x = y := by
  apply Subtype.ext
  funext n
  exact h n

/-- The projections satisfy the defining transition compatibility. -/
theorem serrePadicIntProj_compat (p n : ℕ) (x : SerrePadicInt p) :
    padicReduction p n (serrePadicIntProj p (n + 1) x) = serrePadicIntProj p n x :=
  x.2 n

/-- Componentwise integer reduction into the ambient product of residue rings. -/
def serrePadicIntIntCastAmbient (p : ℕ) : ℤ →+* (∀ n : ℕ, padicResidueRing p n) :=
  RingHom.pi fun n => Int.castRingHom (padicResidueRing p n)

/-- Integer residue sequences satisfy the inverse-limit compatibility equations. -/
theorem serrePadicIntIntCastAmbient_compatible (p : ℕ) (z : ℤ) :
    padicCompatible p (serrePadicIntIntCastAmbient p z) := by
  intro n
  change padicReduction p n (z : padicResidueRing p (n + 1)) =
    (z : padicResidueRing p n)
  simp [padicReduction]

/-- Canonical ring homomorphism from ordinary integers to the project p-adic integers. -/
def serrePadicIntIntCast (p : ℕ) : ℤ →+* SerrePadicInt p :=
  RingHom.codRestrict (serrePadicIntIntCastAmbient p) (serrePadicIntSubring p)
    (serrePadicIntIntCastAmbient_compatible p)

@[simp]
theorem serrePadicIntIntCast_proj (p n : ℕ) (z : ℤ) :
    serrePadicIntProj p n (serrePadicIntIntCast p z) = (z : padicResidueRing p n) := rfl

/-- Every residue class occurs as a projection of a compatible p-adic sequence. -/
theorem serrePadicIntProj_surjective (p n : ℕ) : Function.Surjective (serrePadicIntProj p n) := by
  intro a
  obtain ⟨z, rfl⟩ := ZMod.intCast_surjective a
  exact ⟨serrePadicIntIntCast p z, serrePadicIntIntCast_proj p n z⟩

/-- A prime modulus is nonzero at every positive residue level. -/
instance padicResidueRing_neZero (p n : ℕ) [Fact p.Prime] : NeZero (p ^ (n + 1)) :=
  ⟨pow_ne_zero _ (Fact.out : p.Prime).ne_zero⟩

/-- The compatible-sequence locus is closed in the product of discrete residue rings. -/
theorem padicCompatible_isClosed (p : ℕ) [Fact p.Prime] :
    IsClosed {x : ∀ n : ℕ, padicResidueRing p n | padicCompatible p x} := by
  rw [show {x : ∀ n : ℕ, padicResidueRing p n | padicCompatible p x} =
      ⋂ n, {x | padicReduction p n (x (n + 1)) = x n} by
    ext x
    simp [padicCompatible]]
  apply isClosed_iInter
  intro n
  apply isClosed_eq
  · exact (continuous_of_discreteTopology : Continuous (padicReduction p n)).comp
      (continuous_apply (n + 1))
  · exact continuous_apply n

/-- The project p-adic integers form a compact space in the product topology. -/
theorem serrePadicInt_isCompact (p : ℕ) [Fact p.Prime] :
    IsCompact (serrePadicIntSubring p : Set (∀ n : ℕ, padicResidueRing p n)) := by
  simpa [serrePadicIntSubring] using (padicCompatible_isClosed p).isCompact

instance serrePadicInt_compactSpace (p : ℕ) [Fact p.Prime] : CompactSpace (SerrePadicInt p) :=
  isCompact_iff_compactSpace.mp (serrePadicInt_isCompact p)

/-- Each residue projection is continuous for the induced product topology. -/
theorem serrePadicIntProj_continuous (p n : ℕ) : Continuous (serrePadicIntProj p n) := by
  exact (continuous_apply n).comp continuous_subtype_val

/-- The canonical map `ℤ → ℤ_p` is injective for prime `p`. -/
theorem serrePadicIntIntCast_injective (p : ℕ) [Fact p.Prime] :
    Function.Injective (serrePadicIntIntCast p) := by
  intro a b hab
  let N : ℕ := (a - b).natAbs
  have hcoord : (a : padicResidueRing p N) = (b : padicResidueRing p N) := by
    have h := congrArg (fun x : SerrePadicInt p => serrePadicIntProj p N x) hab
    simpa using h
  have hdvd : ((p ^ (N + 1) : ℕ) : ℤ) ∣ a - b := by
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    change ((a - b : ℤ) : padicResidueRing p N) = 0
    rw [Int.cast_sub, hcoord, sub_self]
  have hp : p.Prime := Fact.out
  have hpowNat : N < p ^ (N + 1) := by
    have hnext : N + 1 < p ^ (N + 1) := Nat.lt_pow_self hp.one_lt
    omega
  have hpowInt : |a - b| < ((p ^ (N + 1) : ℕ) : ℤ) := by
    rw [Int.abs_eq_natAbs]
    exact_mod_cast hpowNat
  have hz : a - b = 0 := Int.eq_zero_of_abs_lt_dvd hdvd hpowInt
  exact sub_eq_zero.mp hz

end PadicIntegers

end SerreNumberTheoryAI
