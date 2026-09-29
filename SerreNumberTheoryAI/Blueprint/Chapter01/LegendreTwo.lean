import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.LegendreTwo

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "3.2 定理5(iii) — 2の補充法則" =>

# 3.2 定理5(iii) — 2の補充法則

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§3・3.2、印刷頁9（uploaded PDF page 19）。

奇素数 `p` に対する `2` のLegendre記号を計算する。
書籍の証明と同じく、`F_p` の代数閉包に原始8乗根を取り、
そこから平方根 `2` に相当する元を作ってFrobenius作用を調べる。

:::theorem "serre_theorem5_iii" (lean := "SerreNumberTheoryAI.serre_theorem5_iii") (uses := "legendre_sign")
奇素数 `p` に対し、`2` のLegendre記号は
`(-1)^((p^2-1)/8)` である。
:::

:::proof "serre_theorem5_iii"
`F_p` の代数閉包で原始8乗根 `α` を取り、
`y=α+α⁻¹` とおく。`α^4=-1` から `y²=2` を得る。

Frobeniusは `α` を `α^p` へ送る。`p mod 8` が `1` または
`7` なら `α^p` は `α` または `α⁻¹` となるので
`y^p=y` である。`3` または `5` なら `y^p=-y` となる。
`y≠0` より、前者では `y^(p-1)=1`、後者では
`y^(p-1)=-1` である。

`y²=2` を用いると、これは `2^((p-1)/2)` の符号を与える。
最後に `p mod 8` の4場合について `(p²-1)/8` の偶奇を確認すると、
`1,7` の場合は偶数、`3,5` の場合は奇数となり、
結論 `(2/p)=(-1)^((p²-1)/8)` が得られる。
:::
