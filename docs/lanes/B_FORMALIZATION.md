# B lane — End-to-end Formalizer

## Mission

Bは固定のLean専任ではありません。`docs/WORK_QUEUE.md` から安全なwork itemをatomic claimし、そのitemをsource interpretationからLean・Blueprint・CI・mergeまでend-to-endで進めるformalizer workerです。

## Startup

1. `AGENTS.md`
2. `docs/AI_WORKFLOW.md`
3. `docs/WORK_QUEUE.md`
4. `docs/LANE_STATUS.md`
5. このファイル
6. `FORMALIZATION_PROGRESS.md`
7. live branch / Issue / PR / CI / latest main
8. 対象のFormalization / Blueprint

## Worker loop

- 自分のactive canonical branch / PRがあれば最優先で復元する。
- active workがCI待ち・upstream待ち・item固有blockerならqueueを再走査する。
- `READY` / eligible `STACKABLE` / `PREFLIGHT` をcanonical branch作成でclaimする。
- source / dependency / mathlib / statementを確認する。
- 安全ならLean + Blueprint + independent exposition + verificationを同じwork itemで進める。
- PR作成やCI pendingで停止せず、in-flight上限の範囲でwork stealingする。
- blockerはwork itemに記録し、別の安全なworkへ移る。

## Historical note

このファイル名は旧「B = Lean Formalization」時代との互換性のため残します。現在はB/C/D/Eに専門分業の差はありません。

## Current handoff

### Completed on main

- `S1.2-MultGroup` #50 / PR #59 — finite-field multiplicative group / Theorem 2.
- `S2.2-Chevalley-Cor1` #70 / PR #80 — Chevalley–Warning Corollary 1 / nontrivial common zero.
- `C2S1.1-ZpConstruction` #71 / PR #86 — project-local inverse-limit construction of `SerrePadicInt p`, merged at `2f4366622121ce0d56e76d8e9a41c25c6917da8b` after root-integrated policy + Lean + Verso CI.

### Active implementation

- `C2S2.1-RootLiftingExistence` #99 / PR #103 / branch `work/c2-s2-1-root-existence`.
- Current head: `94058194f7749e6f6a5e9a886bcfbb25ad91baca`, reconciled with main `9d232f844e4de88967483e82bd783a4b6b155345`.
- CI #248: repository policy, `lake build`, and `lake exe vbp build` all green.
- Implemented: finite inverse-limit wrapper, polynomial coefficient reduction/evaluation compatibility, consecutive finite-level reduction compatibility, finite-level common-zero transition, closed/nonempty approximation sets, and full Proposition 5.
- Blueprint is integrated through the normal `SerreNumberTheoryAI/Blueprint.lean` aggregator and documents the proof-realization difference: the book applies finite inverse-limit nonemptiness directly to finite zero sets; Lean uses the equivalent decreasing-closed-set compactness realization in project `SerrePadicInt` while also exposing the finite-level inverse-system map.
- Downstream #100 subset frozen at exact green head `fe1a173e9665595b584d7f8235c5122b4f0cc373` (CI #226); later #99 commits do not change that Lean interface.
- Remaining blocker: C/#98 owns shared `SerreNumberTheoryAI/Formalization.lean`. Until it releases/merges, #103 keeps a temporary direct top-level import so the module is genuinely root-compiled. Once free: add normal Formalization aggregator import, remove temporary top-level import, resync latest main, rerun CI, mark ready and merge.

### Owned dependency-waiting work

- `C1-Supp-GaussLemma` #78 / branch `work/c1-supp-gauss-lemma` — PREFLIGHT complete, proof-code-clean. Wait for #56 to explicitly extend an exact STACK-READY promise to #78 or merge. Needed subset: `legendreValue` plus characteristic-independent sign/cast bridge. B requested this on #56.
- `C2S1.3-QpField` #96 / branch `work/c2-s1-3-qp-field` — PREFLIGHT complete, proof-code-clean. Algebraic layer waits for #72 integral-domain + unique `p^n * unit` decomposition + valuation laws; Proposition 4 additionally waits for the minimal #89 topology/neighborhood/density interface.
- `C2S2.1-PrimitiveHomogeneousZeros` #100 / branch `work/c2-s2-1-primitive-homogeneous-zeros` — PREFLIGHT complete, proof-code-clean. Wait for #99 frozen/released interface, #72 unit subset, and #96 algebraic `Q_p` scaling interface. B requested an explicit #100 STACK-READY unit subset from D/#72.
- `C2S2.2-HenselLifting` #102 / branch `work/c2-s2-2-hensel-lifting` — PREFLIGHT complete, proof-code-clean. Wait for #72 source-indexed valuation/congruence/decomposition and #89 compatible metric/completeness interface. Pinned mathlib helper `Polynomial.exists_mul_sq_add_linear_part_eq_eval_add` matches the source one-step Taylor argument.

### Shared-lane coordination

- C/#98 currently has priority on the shared Formalization root; do not race it.
- D/#72 / PR #92 is the upstream source for #96/#100/#102 contracts; do not implement or rename its declarations from B.
- A-owned central queue/progress docs are not B edit targets. Live Issue/PR/branch/CI state overrides stale static text.

### Immediate resume order

1. Recheck #98 live state. If merged/released, immediately finish normal Formalization-root integration for #103, latest-main CI, self-review, ready/merge.
2. Recheck #56 for an explicit #78 STACK-READY promise; only then move #78 from proof-code-clean preflight to proof implementation.
3. Recheck #72 for explicit downstream frozen subsets/full valuation interface; resume #96/#100/#102 only when their exact gates are satisfied.
4. If all owned work is waiting, rescan live queue for a new unclaimed `READY` / eligible `STACKABLE` / safe `PREFLIGHT` rather than stopping on one dependency chain.

## Short resume prompt

`Bレーンとして作業を続けて。最新mainとlive branch/Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、B_FORMALIZATION.md、FORMALIZATION_PROGRESS.mdを確認して。Bはend-to-end formalizer。現在のowned workがあればresumeし、無ければlive queueを再走査して未claimの最高priority READY/eligible STACKABLE/PREFLIGHTをcanonical branch lockでclaimしてend-to-endで進める。既に別workerがclaimしたitemは奪わない。PR作成やCI pendingで止まらず、実行時間が残る限りwork stealingする。`
