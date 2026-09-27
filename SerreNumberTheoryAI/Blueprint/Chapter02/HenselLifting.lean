import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.HenselLifting

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 2.2 近似解の改良" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§2・2.2、印刷頁20--21（uploaded PDF pages 30--31）。

この節では、mod `p^n` の近似解から、Newton 型の改良によって
`Z_p` 上の真の解を作る。まず一変数の場合に、
`y = x + p^(n-k) z` という形の補正を選び、Taylor 公式で
誤差を一段高い冪まで押し上げる。その後、この操作を繰り返して
Cauchy 列を作り、完全性により極限の零点を得る。

:::definition "henselcongruence"
source congruence `y ≡ x (mod p^n)` is represented by divisibility of `y - x`
by the project-local element `p^n` in `SerrePadicInt`.
:::

:::definition "henselunivariatehypothesis"
一変数補題の仮定は、`2*k < n`、`f(x) ≡ 0 (mod p^n)`、および
`v_p(f'(x)) = k` である。
:::

:::definition "henselunivariateconclusion"
一変数版の結論は、`f(y)=0`、`y ≡ x (mod p^(n-k))`、および
`v_p(f'(y)) = k` を満たす `y ∈ Z_p` の存在である。
:::

:::definition "henselmultivariatehypothesis"
多変数定理では、選ばれた一つの座標 `X_j` について
`v_p(∂f/∂X_j(x)) = k` を仮定する。
:::

:::definition "henselmultivariateconclusion"
多変数版の結論は、`f(y)=0` かつ全座標で `y ≡ x (mod p^(n-k))`
となる `y` の存在である。
:::

:::lemma_ "henselcoordinateupdate"
多変数の場合は、一つの座標だけを動かす写像を用い、
一変数の場合へ帰着する。
:::

:::lemma_ "henselcorrectioncongruent"
補正が `y = x + p^(n-k) z` の形であれば、直ちに
`y ≡ x (mod p^(n-k))` が従う。
:::
