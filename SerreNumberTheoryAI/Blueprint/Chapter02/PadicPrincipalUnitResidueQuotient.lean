import Verso
import VersoManual
import VersoBlueprint
import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitResidueQuotient

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章3.2 有限主単数商と剰余環の対応" =>

*出典メタデータ:* セール『数論講義』第2章§3.2、印刷24–25頁。
主単数を有限商へ写す操作は、元の`p`進整数の剰余射影と同じ
合同情報を保持する。この事実を独立の補題として整理する。

:::definition "principalunitresiduehom"
  (lean := "SerreNumberTheoryAI.serrePadicPrincipalUnitResidueHom")
`U_(n+1)`を法`p^(n+k+2)`の剰余単数群へ写す群準同型。
:::

:::theorem "principalunitresiduehomker"
  (uses := "principalunitresiduehom")
この準同型の核は`U_(n+k+2)`と一致する。
:::

```lean "principalunitresiduehomker"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitResidueHomKer
    (p n k : ℕ) [Fact p.Prime] :
    (serrePadicPrincipalUnitResidueHom p n k).ker =
      serrePadicPrincipalUnitDeepSubgroup p n (k + 1) :=
  serrePadicPrincipalUnitResidueHom_ker p n k
end SerreNumberTheoryAI
```

:::theorem "principalunitfinitequotientresidueeq"
  (uses := "principalunitresiduehomker")
有限商での同じ合同類の条件と、剰余単数群での像の一致は同値である。
:::

```lean "principalunitfinitequotientresidueeq"
namespace SerreNumberTheoryAI
theorem blueprint_principalUnitFiniteQuotientResidueEq
    (p n k : ℕ) [Fact p.Prime]
    (u v : serrePadicPrincipalUnits p (n + 1)) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) v ↔
      serrePadicPrincipalUnitResidueHom p n k u =
        serrePadicPrincipalUnitResidueHom p n k v :=
  serrePadicPrincipalUnitFiniteQuotient_mk_eq_iff_residue_eq p n k u v
end SerreNumberTheoryAI
```
