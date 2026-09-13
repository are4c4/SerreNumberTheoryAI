# C lane — End-to-end Formalizer

## Mission

Cは固定のBlueprint専任ではありません。`docs/WORK_QUEUE.md` から安全なwork itemをatomic claimし、そのitemをsource interpretationからmathlib調査・Lean・Blueprint・CI・mergeまでend-to-endで進めるformalizer workerです。

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

このファイル名は旧「C = Blueprint / Exposition」時代との互換性のため残します。現在はB/C/D/Eに専門分業の差はありません。

## Current handoff

- State: active worker; `S3.2-LegendreSymbol` preflight complete, upstream-gated
- Active work: #56 / `S3.2-LegendreSymbol`
- Canonical branch: `work/s3-2-legendre-symbol`
- Base mode: `main`
- Base SHA at claim: `8d682413d4fc45cc957502f5fc93f80ae7ce64e7`
- Last completed work: #49 / `S1.1-T1iii` via PR #58, merged on main as `8d682413d4fc45cc957502f5fc93f80ae7ce64e7`; CI run #95 passed repository policy, `lake build`, and `lake exe vbp build`
- Current source boundary: Japanese edition Chapter 1 §3.2, printed pp. 8–9 / uploaded PDF pp. 18–19; §3.3 quadratic reciprocity is excluded from this work item
- Preflight: source statement, exact dependency split, mathlib boundary, theorem-strength audit, and the source primitive-eighth-root/Frobenius strategy for Theorem 5(iii) are recorded on #56
- Required upstream from #55 / `S3.1-QuadraticElements`: a frozen odd-characteristic half-power `{±1}` interface and a theorem identifying value `1` / kernel with the nonzero-square subgroup
- `S1.2-MultGroup` is now integrated on main via PR #59; #56 still depends on #55 rather than consuming §1.2 directly
- Implementation state: no #56 proof-code commit yet; the canonical branch is intentionally kept clean until #55 is `DONE` or explicitly `STACK-READY`
- STACK-READY: no for #56; waiting for #55 to publish exact declaration names/types and head SHA
- Blocker: #55 has not yet published the required `STACK-READY` interface at the latest live check
- Next safe action: monitor #55; once its exact interface is frozen, move `work/s3-2-legendre-symbol` to the approved stack base following `WORK_QUEUE.md`, then implement Lean + Blueprint + CI end-to-end. Until then, do not guess §3.1 declaration names or commit dependent proof code.

## Short resume prompt

`Cレーンとして作業を続けて。最新mainとlive branch/Issue/PR/CI、AGENTS.md、AI_WORKFLOW.md、WORK_QUEUE.md、LANE_STATUS.md、C_BLUEPRINT.md、FORMALIZATION_PROGRESS.mdを確認して。Cはend-to-end formalizerなので固定Blueprint担当として待機せず、active workを復元するかcanonical branch lockで最高priorityの実行可能workをclaimし、source解釈・mathlib調査・Lean・Blueprint・CIまで進めて。PR作成やCI pendingで止まらず、実行時間が残る限りwork stealingして。`
