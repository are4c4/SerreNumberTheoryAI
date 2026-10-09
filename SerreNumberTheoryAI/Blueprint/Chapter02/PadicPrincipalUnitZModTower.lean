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


:::definition "principalunitzmodtowerequivfinlimit"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitZModTowerEquivFiniteInverseLimit")
  (uses := "padicintmultiplicativeequivzmodtower principalunitcyclictransitionall principalunitequivfiniteinverselimit")
有限巡回群の明示的同型を整合列の逆極限へ持ち上げ、
剰余環の整合列と有限主単数商の整合列の群同型を作る。
:::

:::definition "padicintmultiplicativeequivprincipalunits"
  (lean := "SerreNumberTheoryAI.serrePadicIntMultiplicativeEquivPrincipalUnits")
  (uses := "principalunitzmodtowerequivfinlimit")
選んだ厳密な第1層の元の冪を用いて、
`Z_p`の加法群と主単数群を同型にする。
:::

:::definition "principalunitsoddaddequiv"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitsOddAddEquiv")
  (uses := "padicintmultiplicativeequivprincipalunits principalunitlevelonegenerator")
奇素数`p`における命題8：加法群`Z_p`と
主単数群`U₁`の自然な（生成元の選択に依存する）同型。
:::

:::definition "principalunitsdyadicleveltwoaddequiv"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitsDyadicLevelTwoAddEquiv")
  (uses := "padicintmultiplicativeequivprincipalunits principalunitleveltwogenerator")
2進の場合の命題8の一部：加法群`Z₂`と`U₂`の同型。
この段階では`U₁\cong\{±1\}×U₂`の分解とは区別する。
:::
