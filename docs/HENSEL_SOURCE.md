# Hensel source statement summary

Basis: Serre, Chapter 2 §2.2, printed pp.20-21 / uploaded PDF pp.30-31.

This note records only the mathematical boundary needed for the current formalization.

## One-step lemma

For `f ∈ Z_p[X]`, `f'` its derivative, `x ∈ Z_p`, and integers `n,k` with
`0 ≤ 2*k < n`, assume

- `f(x) ≡ 0 (mod p^n)`,
- `v_p(f'(x)) = k`.

Then there exists `y ∈ Z_p` such that

- `f(y) ≡ 0 (mod p^(n+1))`,
- `v_p(f'(y)) = k`,
- `y ≡ x (mod p^(n-k))`.

The proof chooses `y = x + p^(n-k) z`, expands by Taylor's formula, writes
`f(x) = p^n b` and `f'(x) = p^k c` with `c` a unit, then chooses `z` so that
`b + z*c ≡ 0 (mod p)`.

## Theorem 1

For `f ∈ Z_p[X_1,...,X_m]`, `x ∈ Z_p^m`, and one chosen coordinate `j`, assume

- `0 ≤ 2*k < n`,
- `f(x) ≡ 0 (mod p^n)`,
- `v_p((∂f/∂X_j)(x)) = k`.

Then there exists a zero `y ∈ Z_p^m` of `f` with `y ≡ x (mod p^(n-k))`.

The proof first treats `m = 1` by iterating the one-step lemma to get a Cauchy
sequence.  The general `m` case is reduced to `m = 1` by freezing all coordinates
except `X_j`.

## Corollary 1

If `f(x) ≡ 0 (mod p)` and some partial derivative has valuation `0`, i.e. the
reduction of `x` is a simple zero modulo `p`, then `x` lifts to a zero over `Z_p`
congruent modulo `p`.
