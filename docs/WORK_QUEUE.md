# WORK_QUEUE.md

このファイルは1レーン直列運用のdependency-aware backlogです。現行の数学的実装は `docs/ACTIVE_WORK.md` に記録します。

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

## 25-minute single-run operation

ユーザーが単に「続けて」「形式化を続けて」と言った場合、このqueueは「次のwork itemへ移れ」という意味ではなく、現在のACTIVE itemを原則最大25分間の連続作業予算で進める指示として解釈する。

1 run内では、次の順で可能な限り前進する:

1. ACTIVE PR / branch / CI を復元する。
2. CI failure があれば、そのログ解析と修正を最優先する。
3. CIがgreenまたはpendingなら、同じACTIVE item内で次の小さなLean補題、Blueprint同期、docs同期、PR本文更新、self-reviewを進める。
4. CI pendingだけで終了しない。待ち時間にはread-only review、次proof sliceのstatement設計、source-boundary確認、既存API調査、docs更新を行う。
5. 新しいcommitを作った場合は、latest headのCI起動状況を確認してから報告する。
6. ただし、数学的statementが不明確、CI failure未解析、write拒否、conflict、権限エラー、source policy risk、時間/context上限がある場合は停止する。
7. ユーザーが明示的に短い時間や停止を指定した場合は、その指定を優先する。

この25分run運用はwork stealingや並列化を復活させるものではない。常に現在のACTIVE itemだけを対象にする。

## Current serial state

- ACTIVE: none（PR #149をmainへmergeした時点の予定状態）。
- Last validated implementation: PR #149, CI #873 green (unit filtration / Proposition 7 / `Q_p` roots corollary).
- ACTIVE repair note: CI #735 failed at the first unit-filtration membership bridge; repaired by `d140c36...`, then extended by `bdb0a88...` with the consecutive filtration inclusion.
- JUST DONE: `C2S2.2-HenselQuadraticTwo` — Issue #105 / PR #148 / main `c7c03076…`, PR-head CI #729 green
- JUST DONE: `C2S2.2-HenselQuadraticOdd` — Issue #104 / PR #147 / main `3bd49171…`, PR-head CI #700 green
- JUST DONE: `C2S2.2-HenselLifting` — Issue #102 / PR #146 / main `3695fa0b…`, CI #590 green
- JUST DONE: `C2S2.1-PrimitiveHomogeneousZeros` — Issue #100 / PR #145 / main `32c68109…`, CI #462 green
- JUST DONE: `C2S1.3-QpField` — Issue #96 / PR #143 / main `5b021cb9…`, CI #428 green
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
- Chapter 2 §1.3: project `Q_p`, valuation/decomposition and topology entry points
- Chapter 2 §2.1: Propositions 5–6
- Chapter 2 §2.2: Hensel theorem + Corollary 1; quadratic Corollaries 2–3

## Dependency-aware backlog

| Order | Work ID | Target | State | Gate / next action | Preserved artifact |
| --- | --- | --- | --- | --- | --- |
| 1 | `C2S1.3-QpField` | §1.3 `Q_p`, decomposition/valuation, Proposition 4 | DONE | PR #143 merged as `5b021cb9…`, CI #428 green | PR #123 / old branch `work/c2-s1-3-qp-field` |
| 2 | `C2S2.1-PrimitiveHomogeneousZeros` | §2.1 Proposition 6 | DONE | PR #145 merged as `32c68109…`, CI #462 green | Issue #100 |
| 3 | `C2S2.2-HenselLifting` | §2.2 Hensel theorem + Corollary 1 | DONE | PR #146 merged as `3695fa0b…`, CI #590 green | Issue #102 |
| 4 | `C2S2.2-HenselQuadraticOdd` | §2.2 Corollary 2 | DONE | PR #147 merged as `3bd49171…`, PR-head CI #700 green | Issue #104 |
| 5 | `C2S2.2-HenselQuadraticTwo` | §2.2 Corollary 3 | DONE | PR #148 merged as `c7c03076…`, PR-head CI #729 green | Issue #105 |
| 6 | `C2S3.1-UnitFiltration` | §3.1 unit filtration / Proposition 7 / `Q_p` root corollary | DONE | PR #149 all source-facing Lean/Blueprint proofs built; CI #873 green, pending final merge | Issue #108 / PR #149; recovery source PR #125 |
| 7 | `C2S3.2-PrincipalUnits` | §3.2 Proposition 8 / multiplicative group | ACTIVE | PR #152 from merged #149 main; initial power-step lemmas and Blueprint under CI | Issue #112 |
| 8 | `C2S3.3-PadicSquares` | §3.3 p-adic squares / Theorems 3–4 | WAITING | depends on §3.2 and project `Q_p` | Issue #120 |
| 9 | `C3S1.1-HilbertBasics` | Chapter 3 §1.1 Hilbert symbol basics | PREFLIGHT | future source-order work; `Q_p` specialization needs current chain | Issue #121 |
| 10 | `C3S1.2-HilbertLocalFormula` | Chapter 3 §1.2 local formula | WAITING | depends on Hilbert basics and p-adic square classes | Issue #122 |
| 11 | `C3S2.1-HilbertProductFormula` | Chapter 3 §2.1 product formula | WAITING | depends on local formula | Issue #124 |
| 12 | `C3S2.2-WeakApproximation` | Chapter 3 §2.2 CRT / weak approximation | PREFLIGHT | independent read-only preflight allowed; do not implement in parallel | Issue #129 |
| 13 | `C3S2.2-PrescribedHilbertSymbols` | Chapter 3 §2.2 Theorem 4 | WAITING | depends on product formula, square classes, weak approximation, Dirichlet interface | Issue #130 |
| 14 | `C4S1.1-QuadraticFormBasics` | Chapter 4 §1.1 quadratic-form basics | PREFLIGHT | read-only source/API preflight only until promoted after earlier serial work | Issue #131 |
| 15 | `C4S1.2-Orthogonality` | Chapter 4 §1.2 orthogonality / radicals | WAITING | depends on §1.1 source-facing quadratic-form interface | Issue #134 |
| 16 | `C4S1.3-IsotropicHyperbolic` | Chapter 4 §1.3 isotropic vectors / hyperbolic planes | WAITING | depends on §1.1–§1.2 | Issue #136 |
| 17 | `C4S1.4-OrthogonalBases` | Chapter 4 §1.4 orthogonal bases | WAITING | depends on §1.1–§1.2; keep §1.5 Witt theorem out of scope | Issue #137 |

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


## 2026-10-10 serial checkpoint

- ACTIVEは依然`C2S3.1-UnitFiltration`（Issue #108 / PR #149）一件のみ。
- 有限補群の根への復元は`c23280cd` / CI #863で検証済み。
- 命題7の直積同型のLean定義は`d8b864d`、Blueprintは`22373e7`で追加し、まだ新headのCI検証待ち。
- #112 (§3.2) は命題7のsource-facing proof・Blueprint・CI・main merge後までWAITINGのまま。

## Ready-to-merge handoff 2026-10-10

- 今回のserial implementationはIssue #108 / PR #149だけ。source §3.1の命題7・有限補群一意性・`Q_p`根の系がCI #873 green。
- 上記DONE/READY/noneは**PR #149をmainへmergeした時点で成立**する次状態を示す。merge前にlive GitHub PRがopenならまだ当該itemをACTIVE扱いする。
- merge後、最新mainから§3.2 Issue #112を唯一の次itemとして昇格。先行実装PRを並列に走らせない。

## 2026-10-10 §3.2 シリアル移行

- PR #149 / Issue #108 はmainへ統合され、§3.1の命題7・補群一意性・Q_pの根に関する系まで完了。
- 現在唯一のACTIVEはIssue #112 / PR #152 / `work/c2-s3-2-principal-units-serial`。
- 出典 §3.2 に合わせ、冪の補題と命題8の奇素数／2進の分岐を先に形式化。§3.3はWAITINGを維持。


## 2026-10-10 §3.2 serial inverse-limit checkpoint

- ACTIVE remains `C2S3.2-PrincipalUnits` (Issue #112 / draft PR #152), sole mathematical implementation.
- CI #935 success verifies quotient transitions and all-class cyclic compatibility/inverse-limit definition.
- CI #942 failure in finite-inverse-limit injectivity proof repaired at `6a14c068`; latest proof additions need fresh PR-head CI.
- New work within PR #152: finite-quotient residues comparison, compatible representative choices and reconstructed project p-adic integer. Surjectivity, Proposition 8, dyadic sign factor, Theorem 2 remain pending.
- Resume by latest CI review (do not start next ACTIVE or parallel work).


## 2026-10-10 §3.2 Proposition 8 late-stage serial checkpoint

- ACTIVE continues as Issue #112 / draft PR #152 only.
- CI #935 succeeded (finite cyclic quotients and compatibility). CI #964 checked the new Lean source successfully, including both infinite additive-group equivalence definitions, but failed in Blueprint parsing; patched Blueprint ID `38a5f7f0`.
- Dyadic `-1` sign subgroup, order 2 and generator of U₁/U₂ have been added; await latest PR-head CI before calling these proved.
- Remaining in the same active item: direct product `U₁ ≃ {±1} × U₂`, project `Q_p^×` structure theorem, source/CI/self-review and merge. §3.3 remains waiting.
