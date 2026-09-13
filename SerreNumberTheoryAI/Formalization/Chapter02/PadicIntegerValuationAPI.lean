import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerValuation

/-!
# Valuation API for the project p-adic integers

The algebraic work in the preceding files identifies projection kernels with powers of `p`,
constructs division by `p`, and proves a `p^n * unit` factorization.  Here we package the resulting
source valuation through mathlib's general prime-multiplicity valuation infrastructure.

No theorem about mathlib's completed `PadicInt` type is used.
-/

namespace SerreNumberTheoryAI

section PadicIntegerValuationAPI

variable (p : ℕ) [Fact p.Prime]

/-- Multiplication by a power of `p` is injective on the project p-adic integers. -/
theorem serrePadicInt_mul_pow_injective (n : ℕ) :
    Function.Injective (fun x : SerrePadicInt p => (p : SerrePadicInt p) ^ n * x) := by
  intro x y hxy
  exact mul_left_cancel₀ (serrePadicInt_p_pow_ne_zero p n) hxy

/-- In a factorization `x = p^n u` with `u` a unit, one more factor of `p` cannot divide `x`. -/
theorem serrePadicInt_pow_succ_not_dvd_of_eq_pow_mul_isUnit
    {x u : SerrePadicInt p} {n : ℕ} (hu : IsUnit u)
    (hx : x = (p : SerrePadicInt p) ^ n * u) :
    ¬ (p : SerrePadicInt p) ^ (n + 1) ∣ x := by
  intro hdiv
  obtain ⟨z, hz⟩ := hdiv
  have heq :
      (p : SerrePadicInt p) ^ n * u =
        (p : SerrePadicInt p) ^ n * ((p : SerrePadicInt p) * z) := by
    calc
      (p : SerrePadicInt p) ^ n * u = x := hx.symm
      _ = (p : SerrePadicInt p) ^ (n + 1) * z := hz
      _ = (p : SerrePadicInt p) ^ n * ((p : SerrePadicInt p) * z) := by
        rw [pow_succ]
        ac_rfl
  have hueq : u = (p : SerrePadicInt p) * z :=
    serrePadicInt_mul_pow_injective p n heq
  have hpdiv : (p : SerrePadicInt p) ∣ u := ⟨z, hueq⟩
  exact ((serrePadicInt_isUnit_iff_not_p_dvd p u).1 hu) hpdiv

/-- The exponent in a `p^n * unit` factorization of a nonzero element is unique. -/
theorem serrePadicInt_pow_mul_isUnit_exponent_unique
    {x u v : SerrePadicInt p} {n m : ℕ}
    (hu : IsUnit u) (hv : IsUnit v)
    (hn : x = (p : SerrePadicInt p) ^ n * u)
    (hm : x = (p : SerrePadicInt p) ^ m * v) :
    n = m := by
  have hnotn : ¬ (p : SerrePadicInt p) ^ (n + 1) ∣ x :=
    serrePadicInt_pow_succ_not_dvd_of_eq_pow_mul_isUnit p hu hn
  have hnotm : ¬ (p : SerrePadicInt p) ^ (m + 1) ∣ x :=
    serrePadicInt_pow_succ_not_dvd_of_eq_pow_mul_isUnit p hv hm
  apply le_antisymm
  · by_contra hnm
    have hle : m + 1 ≤ n := by omega
    apply hnotm
    exact (pow_dvd_pow (p : SerrePadicInt p) hle).trans ⟨u, hn⟩
  · by_contra hmn
    have hle : n + 1 ≤ m := by omega
    apply hnotn
    exact (pow_dvd_pow (p : SerrePadicInt p) hle).trans ⟨v, hm⟩

/-- Both the exponent and the unit factor in the source decomposition are unique. -/
theorem serrePadicInt_pow_mul_isUnit_unique
    {x u v : SerrePadicInt p} {n m : ℕ}
    (hu : IsUnit u) (hv : IsUnit v)
    (hn : x = (p : SerrePadicInt p) ^ n * u)
    (hm : x = (p : SerrePadicInt p) ^ m * v) :
    n = m ∧ u = v := by
  have hnm := serrePadicInt_pow_mul_isUnit_exponent_unique p hu hv hn hm
  subst m
  refine ⟨rfl, ?_⟩
  apply serrePadicInt_mul_pow_injective p n
  exact hn.symm.trans hm

/-- Every nonzero element has a unique exponent in its source `p^n * unit` decomposition. -/
theorem existsUnique_pow_mul_isUnit_of_ne_zero
    {x : SerrePadicInt p} (hx : x ≠ 0) :
    ∃! n : ℕ, ∃ u : SerrePadicInt p,
      IsUnit u ∧ x = (p : SerrePadicInt p) ^ n * u := by
  obtain ⟨n, u, hu, hn⟩ := exists_pow_mul_isUnit_of_ne_zero p hx
  refine ⟨n, ⟨u, hu, hn⟩, ?_⟩
  intro m hm
  obtain ⟨v, hv, hmrepr⟩ := hm
  exact serrePadicInt_pow_mul_isUnit_exponent_unique p hu hv hn hmrepr

/-- The source pair `(n,u)` in `x = p^n u` is unique for every nonzero element. -/
theorem existsUnique_pow_unitPair_of_ne_zero
    {x : SerrePadicInt p} (hx : x ≠ 0) :
    ∃! nu : ℕ × SerrePadicInt p,
      IsUnit nu.2 ∧ x = (p : SerrePadicInt p) ^ nu.1 * nu.2 := by
  obtain ⟨n, u, hu, hn⟩ := exists_pow_mul_isUnit_of_ne_zero p hx
  refine ⟨(n, u), ⟨hu, hn⟩, ?_⟩
  rintro ⟨m, v⟩ ⟨hv, hm⟩
  obtain ⟨hnm, huv⟩ := serrePadicInt_pow_mul_isUnit_unique p hu hv hn hm
  simp [hnm, huv]

/-- The distinguished element `p` is prime in the project p-adic integer ring. -/
theorem serrePadicInt_p_prime : Prime (p : SerrePadicInt p) := by
  refine ⟨?_, ?_, ?_⟩
  · simpa [pow_one] using serrePadicInt_p_pow_ne_zero p 1
  · intro hpunit
    have hnotdvd := (serrePadicInt_isUnit_iff_not_p_dvd p (p : SerrePadicInt p)).1 hpunit
    exact hnotdvd (dvd_refl _)
  · intro a b hab
    have hproj : serrePadicIntProj p 0 (a * b) = 0 :=
      (p_dvd_serrePadicInt_iff_proj_zero p (a * b)).1 hab
    rw [map_mul] at hproj
    rcases eq_zero_or_eq_zero_of_mul_eq_zero hproj with ha | hb
    · exact Or.inl ((p_dvd_serrePadicInt_iff_proj_zero p a).2 ha)
    · exact Or.inr ((p_dvd_serrePadicInt_iff_proj_zero p b).2 hb)

/--
The additive `p`-adic valuation on the project-local p-adic integers.

This uses only the general prime-multiplicity valuation constructor after proving, inside the
project representation, that the distinguished element `p` is prime.
-/
noncomputable def serrePadicIntAddValuation :
    AddValuation (SerrePadicInt p) ℕ∞ :=
  multiplicity_addValuation (serrePadicInt_p_prime p)

@[simp]
theorem serrePadicIntAddValuation_zero :
    serrePadicIntAddValuation p (0 : SerrePadicInt p) = ⊤ := by
  change emultiplicity (p : SerrePadicInt p) 0 = ⊤
  exact emultiplicity_zero_right _

/-- On a nonzero element, the additive valuation is the first nonzero residue level. -/
theorem serrePadicIntAddValuation_eq_order
    {x : SerrePadicInt p} (hx : x ≠ 0) :
    serrePadicIntAddValuation p x = (serrePadicIntOrder p x hx : ℕ∞) := by
  change emultiplicity (p : SerrePadicInt p) x = (serrePadicIntOrder p x hx : ℕ∞)
  exact emultiplicity_eq_of_dvd_of_not_dvd
    (serrePadicInt_pow_order_dvd p hx)
    (serrePadicInt_pow_succ_order_not_dvd p hx)

/-- Powers of `p` divide exactly to the depth measured by the project additive valuation. -/
theorem serrePadicInt_pow_dvd_iff_le_addValuation
    (n : ℕ) (x : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ n ∣ x ↔
      (n : ℕ∞) ≤ serrePadicIntAddValuation p x := by
  change (p : SerrePadicInt p) ^ n ∣ x ↔
    (n : ℕ∞) ≤ emultiplicity (p : SerrePadicInt p) x
  exact pow_dvd_iff_le_emultiplicity

/-- The source multiplicativity identity for the additive valuation. -/
theorem serrePadicIntAddValuation_mul (x y : SerrePadicInt p) :
    serrePadicIntAddValuation p (x * y) =
      serrePadicIntAddValuation p x + serrePadicIntAddValuation p y := by
  exact (serrePadicIntAddValuation p).map_mul x y

/-- The source ultrametric inequality for the additive valuation. -/
theorem serrePadicIntAddValuation_add (x y : SerrePadicInt p) :
    min (serrePadicIntAddValuation p x) (serrePadicIntAddValuation p y) ≤
      serrePadicIntAddValuation p (x + y) := by
  exact (serrePadicIntAddValuation p).map_add x y

end PadicIntegerValuationAPI

end SerreNumberTheoryAI
