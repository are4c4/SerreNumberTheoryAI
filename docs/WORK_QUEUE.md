# WORK_QUEUE.md

このファイルは1レーン直列運用のdependency-aware backlogです。現行の数学的実装は `docs/ACTIVE_WORK.md` にある1件だけです。

2026-09-26以前のlane ownership / work stealing / STACK-READY / stacked implementationは廃止済みです。旧branchやPRは必要なコードを回収するための履歴資料であり、並行作業の許可ではありません。

live GitHub stateがこの文書より新しい場合はlive stateを優先し、そのrun内でこの文書を同期します。

## Queue states

- ACTIVE — 現在唯一の数学的実装対象。0または1件。
- READY — active完了後にlatest mainから開始可能。
- PREFLIGHT — 将来候補。read-onlyのsource/dependency/API確認のみ。
- WAITING — main上のupstream完了待ち。
- BLOCKED — hard blockerあり。
- PARKED — 旧branch/PRまたは明示的に中断したwork。activeではない。
- DONE — mainへ統合済みでcross-layer artifactとCIが揃っている。

## Serial selection rule

1. 現在のACTIVEをmergeまたは明示的にparkする。
2. latest mainを確認する。
3. source orderと実依存を確認する。
4. 次の1 itemだけをACTIVEへ昇格する。
5. main-based implementation PRを1本だけ作る。
6. policy / Lean / Blueprint / CI / self-review / mergeまで同じレーンで完了する。

downstreamがupstreamを必要とする場合は、upstreamをmainへmergeしてからdownstreamを開始します。新しいstacked proof implementationは行いません。

## Current serial state

- ACTIVE: `C2S1.3-QpField` — Issue #96 / recovery branch `work/c2-s1-3-qp-field-serial`
- JUST DONE: `C2S1.2-ZpMetric` — Issue #89 / PR #142 / main `f4f0710b…`, CI #374 green
- JUST DONE: `C2S1.2-ZpProperties` — Issue #72 / PR #140 / main `2edd751d…`

## Completed mathematical slices on main

- Chapter 1: Theorem 1(ii)/(iii)
- Chapter 1 §1.2: finite-field multiplicative group / Theorem 2
- Chapter 1 §2.1: power sums
- Chapter 1 §2.2: Chevalley–Warning + Corollaries 1–2
- Chapter 1 §3.1–3.3: square elements, Legendre symbol, quadratic reciprocity
- Chapter 1 supplement (i): Gauss's lemma
- Chapter 2 §1.1: project-local `Z_p` inverse-limit construction
- Chapter 2 §1.2: Proposition 1–3, unit/decomposition/valuation, p-adic metric/topology/completeness/density
- Chapter 2 §2.1: Proposition 5

## Dependency-aware backlog

| Order | Work ID | Target | State | Gate / next action | Preserved artifact |
| --- | --- | --- | --- | --- | --- |
| 1 | `C2S1.3-QpField` | §1.3 `Q_p`, decomposition/valuation, Proposition 4 | ACTIVE | recover #123 onto latest main and complete end-to-end | PR #123 / old branch `work/c2-s1-3-qp-field` |
| 2 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 Proposition 6 | WAITING | needs stable project `Q_p` scaling interface from current ACTIVE | Issue #100 |
| 3 | `C2S2.2-HenselLifting` | §2.2 Hensel theorem + Corollary 1 | READY | after current ACTIVE, recheck source-order/dependency against Proposition 6 | Issue #102 |
| 4 | `C2S2.2-HenselQuadraticOdd` | §2.2 Corollary 2 | WAITING | needs Hensel simple-root interface | Issue #104 |
| 5 | `C2S2.2-HenselQuadraticTwo` | §2.2 Corollary 3 | WAITING | needs main Hensel theorem | Issue #105 |
| 6 | `C2S3.1-UnitFiltration` | §3.1 unit filtration / Proposition 7 | PARKED | recover old #125 only when this item becomes ACTIVE | PR #125 |
| 7 | `C2S3.2-PrincipalUnits` | §3.2 Proposition 8 / multiplicative group | WAITING | depends on §3.1 and project `Q_p` | Issue #112 |
| 8 | `C2S3.3-PadicSquares` | §3.3 p-adic squares / Theorems 3–4 | WAITING | depends on §3.2 and project `Q_p` | Issue #120 |
| 9 | `C3S1.1-HilbertBasics` | Chapter 3 §1.1 Hilbert symbol basics | PREFLIGHT | future source-order work; `Q_p` specialization needs current chain | Issue #121 |
| 10 | `C3S1.2-HilbertLocalFormula` | Chapter 3 §1.2 local formula | WAITING | depends on Hilbert basics and p-adic square classes | Issue #122 |
| 11 | `C3S2.1-HilbertProductFormula` | Chapter 3 §2.1 product formula | WAITING | depends on local formula | Issue #124 |
| 12 | `C3S2.2-WeakApproximation` | Chapter 3 §2.2 CRT / weak approximation | PREFLIGHT | independent read-only preflight allowed; do not implement in parallel | Issue #129 |
| 13 | `C3S2.2-PrescribedHilbertSymbols` | Chapter 3 §2.2 Theorem 4 | WAITING | depends on product formula, square classes, weak approximation, Dirichlet interface | Issue #130 |
| 14 | `C4S1.1-QuadraticFormBasics` | Chapter 4 §1.1 quadratic-form basics | PREFLIGHT | future candidate only; no parallel proof branch | Issue #131 |

## Legacy recovery rule

When an old branch/PR reaches the front of the serial queue:

1. inspect latest main;
2. review the old diff;
3. create a fresh main-based recovery branch;
4. recover only still-valid code;
5. recheck source statement and actual dependencies;
6. synchronize Lean / Blueprint / explanation;
7. rerun policy / `lake build` / `lake exe vbp build` / PR-head CI from scratch;
8. self-review and merge before advancing the queue.

## End-of-run synchronization

各run終了時に、ACTIVE、PR/CI、blocker、next candidateを `docs/ACTIVE_WORK.md` とこのqueueへ同期します。複数worker用handoffやlane owner記録は作りません。

GitHubへの特定のwriteがChatGPT/OpenAI側の安全性チェック等で拒否された場合は、別itemへwork stealingせず、同じACTIVE itemで安全なread-only解析・review・patch設計を続ける。文書やコードが実際には永続化されていない場合、同期済み・commit済みとは記録しない。run結果に pending branch/path/変更内容/再開地点を明示し、次回はlive GitHub stateを再読して通常の構造化writeを再試行する。
