# D lane — Mathlib Research

## Mission

assigned targetに必要なmathlib APIを調査し、使える一般定理・避けるべきnear-target theorem・型や仮定上の注意をB/Aへ渡す。原則として完成formalizationを実装しない。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/LANE_STATUS.md`
4. このファイル
5. assigned focused Issue / latest main

## Owned work

- theorem / definition search
- API signature確認
- minimal experiments for elaboration / coercion / namespace
- strong near-target theoremの識別
- B向けの候補一覧と注意点

## Normally do not own

- target theoremの完成proof
- Blueprint prose
- roadmap / ownership決定
- CI infrastructure

## Research output format

Issueコメントまたはこのhandoffに次を残す。

- searched concepts / namespaces
- candidate declarations and exact roles
- assumptions / coercions / typeclass requirements
- whether a candidate is too strong / near-target
- recommended path for B
- unresolved questions

探索用コードをcommitする場合は、再利用価値がないものを完成PRに残さない。

## Current handoff

- Focused Issue: #10 — mathlib research for `S1.1.Theorem1(ii)`
- Parent: #2 Phase 1 finite fields
- Semantic contract: #6
- Branch: `research/s1-1-theorem1-ii-10`
- PR: pending
- Completed: pinned mathlib `v4.32.0` API survey; detailed findings posted to Issue #10
- Next: merge this D-handoff update, then B #7 can consume the Issue #10 research; do not take ownership of B's proof
- Blockers: none; no `TARGET-THEOREM-ONLY` blocker because a general-purpose elementary route exists
- Cross-lane dependency: B #7 owns the Lean implementation; C #9 / PR #18 owns Blueprint/exposition; E integrates after B/C readiness
- Shared hotspots: none; this work only updates the D-owned handoff
- Independence: human `are4c4/SerreNumberTheoryBlueprint` mathematical content was not inspected or used

## S1.1 Theorem 1(ii) — research summary

Recommended route for B:

1. Construct the subfield with carrier `{x : Ω | x ^ (p ^ f) = x}` directly.
2. Use characteristic-`p` power identities to prove closure.
3. Let `g = X ^ (p ^ f) - X`; identify the carrier with `g.rootSet Ω`.
4. Prove `g` separable by the elementary derivative calculation `g' = -1`.
5. Use `[IsAlgClosed Ω]` to split `g` and `Polynomial.card_rootSet_eq_natDegree` to count exactly `p ^ f` distinct roots.
6. For uniqueness, use the general finite identity `FiniteField.pow_card` on any competing finite subfield, obtain inclusion in the fixed-point subfield, then conclude equality from inclusion plus equal finite cardinality.

### Main acceptable APIs

- `IsAlgClosed.splits`
- `Polynomial.mem_rootSet_of_ne`
- `Polynomial.Separable` / `Polynomial.separable_def`
- `Polynomial.card_rootSet_eq_natDegree`
- `Polynomial.natDegree_X_pow`
- `Polynomial.natDegree_sub_eq_left_of_natDegree_lt`
- `add_pow_char_pow`, `sub_pow_char_pow`, `neg_one_pow_char_pow`
- `mul_pow`, `inv_pow`
- `CharP.cast_eq_zero_iff`
- `dvd_pow_self`
- `FiniteField.pow_card` — acceptable as the general finite-group power identity for the uniqueness inclusion step
- `Nat.card_pos_iff`, `Fintype.ofFinite`, `Nat.card_eq_fintype_card`
- `Set.Finite.eq_of_subset_of_card_le` for the final finite-set equality pattern

### Prefer local/general lemmas over these conveniences

- `galois_poly_separable` is logically below the target but lives in `Mathlib/FieldTheory/Finite/GaloisField.lean`, which also exposes many near-target finite-field constructions; prefer a local derivative proof.
- `FiniteField.X_pow_card_pow_sub_X_natDegree_eq` / `_ne_zero` are unnecessary finite-field-flavored conveniences; generic polynomial degree lemmas are clearer.
- `FixedPoints.subfield` would require group-action/Galois machinery and is unnecessary for the fixed set `{x | x^(p^f)=x}`.

### Near-target results not to use as completion arguments

The following are too strong or substantially at/beyond the target boundary under `AGENTS.md`:

- `GaloisField p n`
- `GaloisField.card`
- `FiniteField.isSplittingField_of_card_eq`
- `FiniteField.isSplittingField_of_nat_card_eq`
- `FiniteField.algEquivGaloisFieldOfFintype`
- `FiniteField.algEquivGaloisField`
- `FiniteField.algEquivOfCardEq`
- `FiniteField.ringEquivOfCardEq`

`FiniteField.roots_X_pow_card_sub_X` is also stronger and more specialized than needed for the construction; prefer the generic root-set route above.

### Implementation cautions for B

- `Polynomial.card_rootSet_eq_natDegree` expects splitting of `p.map (algebraMap F K)`; for `F = K = Ω`, a `simpa` across the self-algebra map may be required.
- Applying `FiniteField.pow_card` to a competitor `Subfield Ω` requires installing `Finite`/`Fintype` on its subtype from the cardinality hypothesis and managing subtype/coercion rewriting back into `Ω`.
- These are elaboration/coercion details only; no mathematical blocker was found.

## Short resume prompt

`Dレーンとして作業を続けて。最新main、Issue/PR、AGENTS.md、AI_WORKFLOW.md、LANE_STATUS.md、D_MATHLIB.mdを確認し、割り当てられたtargetのmathlib API調査だけを進めて。完成proofを奪わず、候補の強さ・仮定・near-target判定をBへhandoffして。`
