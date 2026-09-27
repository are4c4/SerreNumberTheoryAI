import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.HenselLifting
import SerreNumberTheoryAI.Formalization.Chapter02.HenselTaylor

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

:::lemma_ "henselcongruencerelation"
  (uses := "henselcongruence")
この合同は反射的、対称的、推移的であり、より強い法からより弱い法への
単調性をもつ。これは後の反復列で、各段階の補正を同じ初期点に対する
近さとして整理するための基本 API である。
:::

:::definition "henselunivariatehypothesis"
一変数補題の仮定は、`2*k < n`、`f(x) ≡ 0 (mod p^n)`、および
`v_p(f'(x)) = k` である。
:::

:::definition "henselunivariateconclusion"
一変数版の結論は、`f(y)=0`、`y ≡ x (mod p^(n-k))`、および
`v_p(f'(y)) = k` を満たす `y ∈ Z_p` の存在である。
:::

:::definition "henselunivariatestep"
  (uses := "henselunivariatehypothesis, henselcongruence")
一回の Newton 改良では、真の零点までは要求せず、
`y ≡ x (mod p^(n-k))` かつ `f(y) ≡ 0 (mod p^(n+1))` を要求する。
これは反復構成の一段分である。
:::

:::definition "henselmultivariatehypothesis"
多変数定理では、選ばれた一つの座標 `X_j` について
`v_p(∂f/∂X_j(x)) = k` を仮定する。
:::

:::definition "henselmultivariateconclusion"
多変数版の結論は、`f(y)=0` かつ全座標で `y ≡ x (mod p^(n-k))`
となる `y` の存在である。
:::

:::definition "henselmultivariatestep"
  (uses := "henselmultivariatehypothesis, henselcongruence")
多変数版の一段改良も、全座標で初期点に合同なまま、
評価値の消滅を一段高い冪まで改良する形で表す。
:::

:::lemma_ "henselcoordinateupdate"
多変数の場合は、一つの座標だけを動かす写像を用い、
一変数の場合へ帰着する。
:::

:::lemma_ "henselcoordinatecongruence"
  (uses := "henselcoordinateupdate, henselcongruence")
選んだ座標で補正後の値が元の座標に合同なら、一座標更新後の tuple は
全座標で元の tuple に合同である。動かさない座標では反射性を使う。
:::

:::lemma_ "henselcorrectioncongruent"
  (uses := "henselcongruence")
補正が `y = x + p^(n-k) z` の形であれば、直ちに
`y ≡ x (mod p^(n-k))` が従う。
:::

:::lemma_ "henselinequalityapi"
  (uses := "henselunivariatehypothesis, henselmultivariatehypothesis")
仮定 `2*k < n` から `k < n` と `0 < n-k` を取り出す。
この小さな算術 API により、後続の `p^(n-k)` 補正を正の深さとして扱える。
:::

:::definition "henseltaylordefect"
  (uses := "henselunivariatestep")
一変数 Taylor 展開の余りを
`f(x+h) - f(x) - h*f'(x)` として切り出す。次に証明すべき核心は、
この余りが `h^2` の倍数であるという多項式的事実である。
:::

:::lemma_ "henseldivisibilitybookkeeping"
  (uses := "henselcongruence, henseltaylordefect")
`h` が `p^r` で割り切れ、Taylor 余りが `h^2` の倍数なら、余りは
`p^(r+r)` で割り切れる。特に `h = p^(n-k) z` なら、余りは
`p^((n-k)+(n-k))` の深さをもつ。
:::

:::lemma_ "henselmultivariatefromunivariate"
  (uses := "henselcoordinateupdate, henselcoordinatecongruence, henselunivariateconclusion, henselmultivariateconclusion")
一座標だけを動かした多変数多項式の評価と偏微分評価が、一変数特殊化の
評価と導関数評価に一致することが確認できれば、一変数 Hensel の結論から
多変数 Hensel の結論が従う。
:::

:::theorem "henselunivariatetheorem"
  (uses := "henselunivariatestep, henseldivisibilitybookkeeping")
一変数の Hensel 定理本体は、Newton 改良を反復して Cauchy 列を作り、
完全性によって極限を取り、評価の連続性から真の零点を得る部分である。
現在の PR では、この定理を証明するための入出力と補助 API を整備している。
:::

:::theorem "henseltheorem"
  (uses := "henselunivariatetheorem, henselmultivariatefromunivariate")
Serre の多変数定理は、一つの座標以外を固定した一変数特殊化に
一変数定理を適用し、その結果を座標更新として戻すことで得る。
:::
