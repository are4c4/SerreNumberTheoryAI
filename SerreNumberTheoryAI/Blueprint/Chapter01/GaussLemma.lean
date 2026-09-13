import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.GaussLemma

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第1章 補遺 (i) Gaussの補題" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1章補遺 (i)、印刷頁12–13（uploaded PDF pages 22–23）。

この節では、奇素数 `p` の非零剰余類を、各組 `{u,-u}` から一方だけ選んだ
半分系に分ける。非零元 `a` を掛けた後、それぞれを符号 `±1` を使って再び
同じ半分系へ戻すと、戻した代表元は半分系の置換になる。すべての等式を掛け合わせると
代表元の積が消去され、残る符号の積がLegendre記号を与える。

_半分系と符号付き代表元._

:::definition "gauss_half_system" (lean := "SerreNumberTheoryAI.GaussHalfSystem")
`GaussHalfSystem p` は、`(ZMod p)ˣ` の有限部分集合 `S` として、要素数が
`(p-1)/2` であり、任意の単元 `u` について `u` または `-u` が `S` に入り、
両方が同時には入らないという条件を保持する。
:::

:::definition "gauss_representative" (lean := "SerreNumberTheoryAI.gaussRepresentative") (uses := "gauss_half_system")
半分系 `S` と単元 `a` を固定する。`s∈S` に対し、`as` が `S` に入ればそのまま、
入らなければ `-as` を選び、再び `S` の元を得る。
:::

:::definition "gauss_sign" (lean := "SerreNumberTheoryAI.gaussSign") (uses := "gauss_half_system")
上の代表元を得るとき符号反転をしなければ `1`、したなら `-1` を割り当てる。
したがって `as` はこの符号と選ばれた代表元の積に分解される。
:::

:::lemma_ "gauss_sign_mul_representative" (lean := "SerreNumberTheoryAI.gaussSign_mul_representative") (uses := "gauss_representative, gauss_sign")
各 `s∈S` について、有限体内で `a s = ε_s(a) s_a` が成り立つ。
:::

_代表元写像は置換になる._

:::lemma_ "gauss_representative_injective" (lean := "SerreNumberTheoryAI.gaussRepresentative_injective") (uses := "gauss_representative, gauss_half_system")
二つの元が同じ代表元へ送られたと仮定する。両方で符号反転の有無が一致すれば
`a` を消去して元が等しい。符号反転の有無が異なる場合には、一方がもう一方の負元となり、
半分系が `u` と `-u` を同時に含まないことに反する。よって代表元写像は単射である。
:::

:::lemma_ "gauss_representative_bijective" (lean := "SerreNumberTheoryAI.gaussRepresentative_bijective") (uses := "gauss_representative_injective")
半分系は有限なので、自己写像の単射性から全射性も従う。したがって `s↦s_a` は半分系の置換である。
:::

_積を取る議論._

:::lemma_ "gauss_signed_permutation_legendre_value" (lean := "SerreNumberTheoryAI.gaussSignedPermutation_legendreValue")
要素数 `(p-1)/2` の有限集合上で `a s = ε_s s_a` が成り立ち、`s↦s_a` が置換なら、
全ての式の積を取ることで `a^((p-1)/2)` は符号の積に等しい。
左辺はこのプロジェクトで定義した `legendreValue` なので、有限体値のGauss積公式が得られる。
:::

:::lemma_ "gauss_signed_permutation_legendre_sign" (lean := "SerreNumberTheoryAI.gaussSignedPermutation_legendreSign") (uses := "gauss_signed_permutation_legendre_value")
各符号が整数の `1` または `-1` であるとき、有限体値の等式を整数値 `legendreSign` へ戻せる。
奇標数では `1` と `-1` が異なるため、符号の積そのものが `legendreSign` に一致する。
:::

:::theorem "serre_gauss_lemma" (lean := "SerreNumberTheoryAI.serre_gaussLemma") (uses := "gauss_half_system, gauss_sign_mul_representative, gauss_representative_bijective, gauss_signed_permutation_legendre_sign")
奇素数 `p`、半分系 `S`、非零剰余類 `a` を固定する。各 `s∈S` について
`as` を `±S` のどちら側から `S` に戻したかを表す符号を `ε_s(a)` とすると、
`a` のLegendre符号は `∏_{s∈S} ε_s(a)` に等しい。
:::

:::proof "serre_gauss_lemma"
各 `s` の等式 `as=ε_s(a)s_a` を全て掛け合わせる。`s↦s_a` は置換なので、
右辺の代表元の積は元の `S` の積と同じである。`S` は非零元だけからなるためその積は0でなく、
両辺から消去できる。残った左辺は `a` の `(p-1)/2` 乗であり、
§3.2で構成したLegendre値・Legendre符号との対応から結論が従う。
:::
