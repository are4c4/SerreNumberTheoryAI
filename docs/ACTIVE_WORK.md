# ACTIVE_WORK.md

このファイルは単一レーン運用の唯一のactive workと、直近の統合完了workを管理します。
GitHubのlive PR / main stateがこのファイルより新しい場合は、live stateを優先します。

## Current ACTIVE

- なし（**PR #149 のmain統合後**の状態）。
- PR #149がopenの間は `C2S3.1-UnitFiltration` / Issue #108 がまだ唯一のACTIVE work。
- 複数の実装PRを同時にACTIVEにしない。

## Just completed / ready to merge

- Work: `C2S3.1-UnitFiltration`
- Issue: #108
- PR: #149
- Branch: `work/c2-s3-1-unit-filtration-serial`
- Source: Serre Chapter 2 §3.1, printed pp.22–24 / uploaded PDF pp.32–34.
- Completed results: project `U_n` filtration; `U/U₁ ≃ (Z/pZ)ˣ`; successive quotients; finite complements and inverse-compatible tower; `V ≃ (Z/pZ)ˣ`; Proposition 7 `serrePadicUnitsMulEquivRootsProdPrincipal`; uniqueness `serrePadicUnitRootsOfUnity_unique`; project `Q_p` corollary `serrePadicField_contains_p_sub_one_roots`.
- Verified PR-head CIs: #868 (Proposition 7), #870 (uniqueness), #873 (fraction-field corollary), all policy / Lean / Blueprint green.
- Final docs-only sync and merge gate: pending successful latest PR-head CI and main merge.
- The former #125 branch is legacy recovery material, not a parallel ACTIVE lane.

## Next serial candidate

- Issue #112: `C2S3.2-PrincipalUnits`, Serre Chapter 2 §3.2 Proposition 8 / multiplicative group structure.
- State: READY **only after #149 merges into main**.
- Create a single new implementation branch from latest main; source check -> explanation -> Lean -> Blueprint -> CI -> self-review -> merge.
- Downstream #120 (p-adic squares) stays WAITING until #112 completes.
- Do not start §3.2 as part of PR #149.

## Run-length and safety rule

When the user says `続けて` / `形式化を続けて`, advance the currently ACTIVE work for up to approximately 25 minutes, with CI repair first. Do not steal work across lanes or start an overlapping implementation PR. Commit explanatory messages in clear Japanese. Synchronize Lean, Blueprint, progress documents, and issue/PR metadata before merge. A failing or pending CI is never recorded as green.
