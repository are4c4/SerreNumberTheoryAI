import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitRoots

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 3.1 単数群の有限補群候補" =>

このページは、principal-unit filtration と successive quotient の次に使う
有限補群候補を記録する。source では、`U` の中の `(p-1)` 乗して 1 になる
単数たちが、最終的に residue unit group と対応する有限部分群 `V` として働く。

ここではまだ Hensel 型の持ち上げや一意性の完成までは進めず、まず
project-local な `SerrePadicInt` の単数群の中で roots-of-unity subgroup と
最初の剰余単数群への還元写像を切り出す。

:::definition "padicunitrootsofunity"
  (lean := "SerreNumberTheoryAI.serrePadicUnitRootsOfUnity")
`(SerrePadicInt p)ˣ` の部分群として、`u^(p-1)=1` を満たす単数を集める。
これは source の有限補群 `V` の候補である。
:::

:::definition "padicteichmuellersubgroup"
  (lean := "SerreNumberTheoryAI.serrePadicTeichmuellerSubgroup")
同じ部分群を、後続の Teichmüller 型有限補群の名前で参照するための alias として置く。
:::

:::definition "padicunitrootsreduction"
  (lean := "SerreNumberTheoryAI.serrePadicUnitRootsReduction")
roots-of-unity subgroup から最初の剰余単数群への還元写像を定義する。
:::

:::theorem "padicunitrootsreductionpow"
  (uses := "padicunitrootsreduction")
`(p-1)` 乗して 1 になる p進単数を還元すると、剰余単数群でも `(p-1)` 乗して 1 になる。
Lean 側では `serrePadicUnitRootsReduction_pow` として実装している。
:::

:::definition "residueunitrootsofunity"
  (lean := "SerreNumberTheoryAI.serreResidueUnitRootsOfUnity")
最初の剰余単数群の側でも、同じ `(p-1)` 乗根条件を満たす部分群を切り出す。
これにより還元写像の target を、単なる residue units から residue roots に狭められる。
:::

:::definition "padicunitrootsreductiontoresidueroots"
  (lean := "SerreNumberTheoryAI.serrePadicUnitRootsReductionToResidueRoots")
`serrePadicUnitRootsReduction` の余域を residue roots-of-unity subgroup へ狭めた写像である。
:::

:::theorem "padicunitrootsnarrowkernel"
  (uses := "padicunitrootsreductiontoresidueroots, padicunitrootsreduction")
余域を residue roots に狭めても、還元写像の kernel は変わらない。
Lean 側では `serrePadicUnitRootsReductionToResidueRoots_ker` として実装している。
:::

:::theorem "padicunitrootsreductionkernel"
  (uses := "padicunitrootsreduction, padicunitreductionfirst")
roots-of-unity subgroup の還元写像の核は、第一 principal-unit subgroup との交わりとして表せる。
この核が自明であることが、`V` が residue unit group へ単射的に写ることの次の目標である。
Lean 側では `serrePadicUnitRootsReduction_ker` として実装している。
:::

:::theorem "padicunitrootsnarrowkernelprincipal"
  (uses := "padicunitrootsnarrowkernel, padicunitrootsreductionkernel")
余域を狭めた還元写像の kernel も、第一 principal-unit subgroup との交わりとして表せる。
Lean 側では `serrePadicUnitRootsReductionToResidueRoots_ker_principal` として実装している。
:::
