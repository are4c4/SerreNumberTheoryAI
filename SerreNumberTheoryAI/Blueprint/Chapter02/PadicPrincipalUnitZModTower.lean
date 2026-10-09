import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitZModTower

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 p進整数と有限巡回剰余系の逆極限" =>

*出典:* セール『数論講義』第2章§3.2。
第2章§1.1で独立に構成した`SerrePadicInt p`は、
有限剰余環の整合列からなる。
その加法群は、同じ整合列を乗法的に表した有限巡回剰余系の
逆極限と自然に同型である。

:::definition "principalunitzmodtower"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitZModTower")
有限剰余環の加法群を乗法的にタグ付けし、
標準的な剰余写像と整合する列からなる部分群。
:::

:::definition "padicintmultiplicativeequivzmodtower"
  (lean := "SerreNumberTheoryAI.serrePadicIntMultiplicativeEquivZModTower")
  (uses := "principalunitzmodtower")
project-localな`p`進整数の加法群と、
有限巡回剰余環の整合列が自然な群同型となることを構成する。
:::
