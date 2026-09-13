#!/usr/bin/env bash
set -euo pipefail

mapfile -t lean_files < <(
  find SerreNumberTheoryAI -type f -name '*.lean' -print 2>/dev/null || true
  if [[ -f SerreNumberTheoryAI.lean ]]; then
    printf '%s\n' SerreNumberTheoryAI.lean
  fi
)

if [[ ${#lean_files[@]} -eq 0 ]]; then
  echo 'No Lean source files found.' >&2
  exit 1
fi

echo 'Checking formalization placeholders...'
if grep -nE '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)' "${lean_files[@]}"; then
  echo 'Formalization placeholder found.' >&2
  exit 1
fi

if grep -nE '^[[:space:]]*axiom[[:space:]]' "${lean_files[@]}"; then
  echo 'Unexpected axiom declaration found.' >&2
  exit 1
fi

echo 'Checking repository independence...'
if grep -nE '^[[:space:]]*import[[:space:]].*SerreNumberTheoryBlueprint' "${lean_files[@]}"; then
  echo 'Unexpected import from the human formalization repository.' >&2
  exit 1
fi

echo 'Policy checks passed.'
