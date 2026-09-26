import SerreNumberTheoryAI.Formalization.Chapter02.PadicField
import Mathlib.Topology.Algebra.Valued.ValuationTopology

/-!
# Topology on the project p-adic field

This file starts the topological part of Serre, Chapter 2, §1.3, Proposition 4.

The topology is obtained from the discrete valuation attached to the project-local DVR
`SerrePadicInt p`.  The construction remains independent of mathlib's completed
`Padic` / `PadicInt` types.
-/

namespace SerreNumberTheoryAI

section PadicFieldTopology

variable (p : ℕ) [Fact p.Prime]

/--
The canonical discrete valuation on the project fraction field.

It is the adic valuation of the maximal ideal of the project-local DVR
`SerrePadicInt p`.
-/
noncomputable def serrePadicFieldValuation :
    Valuation (SerrePadicField p) (WithZero (Multiplicative ℤ)) :=
  (IsDiscreteValuationRing.maximalIdeal (SerrePadicInt p)).valuation
    (SerrePadicField p)

/--
The project p-adic field carries the valuation topology attached to
`serrePadicFieldValuation`.
-/
@[instance_reducible]
noncomputable instance serrePadicFieldValued :
    Valued (SerrePadicField p) (WithZero (Multiplicative ℤ)) :=
  Valued.mk' (serrePadicFieldValuation p)

/--
Use the valuation topology, rather than the generic final ring topology carried by
`Localization`, as the canonical topology on the project p-adic field.
-/
noncomputable instance (priority := 1100) serrePadicFieldTopologicalSpace :
    TopologicalSpace (SerrePadicField p) :=
  (serrePadicFieldValued p).toTopologicalSpace

/-- The order-of-vanishing interface is the inverse of the field valuation. -/
theorem serrePadicFieldOrder_eq_valuation_inv (x : SerrePadicField p) :
    serrePadicFieldOrder p x = (serrePadicFieldValuation p x)⁻¹ := by
  simpa [serrePadicFieldOrder, serrePadicFieldValuation] using
    (Ring.ordFrac_eq_valuation_inv (R := SerrePadicInt p) x)

/-- The image of project `Z_p` inside its fraction field. -/
def serrePadicIntImage : Subring (SerrePadicField p) :=
  Subring.map (serrePadicIntToField p) ⊤

/--
The image of project `Z_p` is exactly the valuation subring of the project p-adic field.
-/
theorem serrePadicIntImage_eq_valuationSubring :
    serrePadicIntImage p =
      (serrePadicFieldValuation p).valuationSubring.toSubring := by
  simpa [serrePadicIntImage, serrePadicIntToField, serrePadicFieldValuation] using
    (IsDiscreteValuationRing.map_algebraMap_eq_valuationSubring
      (A := SerrePadicInt p) (K := SerrePadicField p))

/--
The project `Z_p` image is open in the valuation topology on the project p-adic field.
This is the openness part of Proposition 4.
-/
theorem isOpen_serrePadicIntImage :
    IsOpen (serrePadicIntImage p : Set (SerrePadicField p)) := by
  rw [serrePadicIntImage_eq_valuationSubring]
  exact Valued.isOpen_valuationSubring (SerrePadicField p)

end PadicFieldTopology

end SerreNumberTheoryAI
