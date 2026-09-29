import Mathlib.Data.Int.GCD
import Mathlib.GroupTheory.Index
import Mathlib.GroupTheory.OrderOfElement

/-!
# Coprime splitting for finite commutative groups

Serre Chapter 2, §3.1 inserts an elementary supplement before Proposition 7:
for a short exact sequence of finite abelian groups whose kernel and quotient
have coprime orders, the middle group has a unique complement to the kernel.

The book states the supplement additively.  This file records the multiplicative
form needed for the unit groups in Proposition 7.  The distinguished complement
consists of the elements killed by the order of the quotient.
-/

namespace SerreNumberTheoryAI

section FiniteAbelianCoprimeSplit

variable {E B : Type*} [CommGroup E] [CommGroup B] [Finite E] [Finite B]

/--
For a homomorphism onto a finite group (B), the source-shaped candidate for
the coprime complement is the subgroup of elements whose `Nat.card B`-th
power is one.
-/
def serreCoprimeKernelComplement (f : E →* B) : Subgroup E where
  carrier := {x | x ^ Nat.card B = 1}
  one_mem' := by simp
  mul_mem' := by
    intro x y hx hy
    change x ^ Nat.card B = 1 at hx
    change y ^ Nat.card B = 1 at hy
    change (x * y) ^ Nat.card B = 1
    rw [mul_pow, hx, hy, one_mul]
  inv_mem' := by
    intro x hx
    change x ^ Nat.card B = 1 at hx
    change x⁻¹ ^ Nat.card B = 1
    rw [inv_pow, hx, inv_one]

@[simp]
theorem mem_serreCoprimeKernelComplement
    (f : E →* B) (x : E) :
    x ∈ serreCoprimeKernelComplement f ↔ x ^ Nat.card B = 1 :=
  Iff.rfl

/--
If the kernel order and quotient order are coprime, an element lying both in
the kernel and in the distinguished complement is one.
-/
theorem serreCoprimeKernelComplement_eq_one_of_mem_ker
    (f : E →* B)
    (hcop : Nat.Coprime (Nat.card f.ker) (Nat.card B))
    (x : E)
    (hxker : x ∈ f.ker)
    (hxcomp : x ∈ serreCoprimeKernelComplement f) :
    x = 1 := by
  have hxkerPowSubtype :
      (⟨x, hxker⟩ : f.ker) ^ Nat.card f.ker = 1 :=
    pow_card_eq_one'
  have hxkerPow : x ^ Nat.card f.ker = 1 := by
    exact congrArg Subtype.val hxkerPowSubtype
  change x ^ Nat.card B = 1 at hxcomp
  exact (pow_eq_one_iff_of_coprime hcop).1 ⟨hxkerPow, hxcomp⟩

/-- The distinguished complement meets the kernel trivially. -/
theorem serreCoprimeKernelComplement_inf_ker_eq_bot
    (f : E →* B)
    (hcop : Nat.Coprime (Nat.card f.ker) (Nat.card B)) :
    serreCoprimeKernelComplement f ⊓ f.ker = ⊥ := by
  apply le_antisymm
  · intro x hx
    have hx1 :=
      serreCoprimeKernelComplement_eq_one_of_mem_ker f hcop x hx.2 hx.1
    simpa [hx1]
  · exact bot_le

/--
For a surjection, every target element has a representative in the
distinguished complement.  This is the multiplicative version of the
(x = arx + bsx) construction in Serre's supplement.
-/
theorem serreCoprimeKernelComplement_surjective
    (f : E →* B)
    (hsurj : Function.Surjective f)
    (hcop : Nat.Coprime (Nat.card f.ker) (Nat.card B)) :
    Function.Surjective (f.comp (serreCoprimeKernelComplement f).subtype) := by
  intro z
  obtain ⟨x, rfl⟩ := hsurj z
  have hord :
      Nat.Coprime (Nat.card f.ker) (orderOf (f x)) :=
    hcop.coprime_dvd_right (orderOf_dvd_natCard (f x))
  obtain ⟨m, hm⟩ :=
    exists_pow_eq_self_of_coprime hord
  have hcard :
      Nat.card f.ker * Nat.card B = Nat.card E :=
    Subgroup.card_ker_mul_card_of_surjective f hsurj
  have hxcard : x ^ Nat.card E = 1 :=
    pow_card_eq_one'
  refine ⟨⟨x ^ (Nat.card f.ker * m), ?_⟩, ?_⟩
  · change (x ^ (Nat.card f.ker * m)) ^ Nat.card B = 1
    calc
      (x ^ (Nat.card f.ker * m)) ^ Nat.card B =
          x ^ ((Nat.card f.ker * m) * Nat.card B) :=
        (pow_mul _ _ _).symm
      _ = x ^ ((Nat.card f.ker * Nat.card B) * m) := by
        congr 1
        ac_rfl
      _ = (x ^ (Nat.card f.ker * Nat.card B)) ^ m := by
        rw [pow_mul]
      _ = 1 := by
        rw [hcard, hxcard, one_pow]
  · change f (x ^ (Nat.card f.ker * m)) = f x
    rw [map_pow, pow_mul]
    exact hm

/-- The restricted map from the distinguished complement is injective. -/
theorem serreCoprimeKernelComplement_injective
    (f : E →* B)
    (hcop : Nat.Coprime (Nat.card f.ker) (Nat.card B)) :
    Function.Injective (f.comp (serreCoprimeKernelComplement f).subtype) := by
  intro x y hxy
  apply Subtype.ext
  change (x : E) = (y : E)
  change f (x : E) = f (y : E) at hxy
  have hker : (x : E) * (y : E)⁻¹ ∈ f.ker := by
    change f ((x : E) * (y : E)⁻¹) = 1
    rw [map_mul, map_inv, hxy, mul_inv_cancel]
  have hcomp :
      (x : E) * (y : E)⁻¹ ∈ serreCoprimeKernelComplement f := by
    exact (serreCoprimeKernelComplement f).mul_mem x.property
      ((serreCoprimeKernelComplement f).inv_mem y.property)
  have hmul :
      (x : E) * (y : E)⁻¹ = 1 :=
    serreCoprimeKernelComplement_eq_one_of_mem_ker f hcop
      ((x : E) * (y : E)⁻¹) hker hcomp
  calc
    (x : E) = (x : E) * 1 := by rw [mul_one]
    _ = (x : E) * ((y : E)⁻¹ * (y : E)) := by rw [inv_mul_cancel]
    _ = ((x : E) * (y : E)⁻¹) * (y : E) := by rw [mul_assoc]
    _ = 1 * (y : E) := by rw [hmul]
    _ = (y : E) := by rw [one_mul]

/--
Serre's coprime-order supplement, in the form used later for
`U / U_n → F_pˣ`: the distinguished complement maps isomorphically onto the
quotient.
-/
noncomputable def serreCoprimeKernelComplementEquiv
    (f : E →* B)
    (hsurj : Function.Surjective f)
    (hcop : Nat.Coprime (Nat.card f.ker) (Nat.card B)) :
    serreCoprimeKernelComplement f ≃* B :=
  MulEquiv.ofBijective
    (f.comp (serreCoprimeKernelComplement f).subtype)
    ⟨serreCoprimeKernelComplement_injective f hcop,
      serreCoprimeKernelComplement_surjective f hsurj hcop⟩

end FiniteAbelianCoprimeSplit

end SerreNumberTheoryAI
