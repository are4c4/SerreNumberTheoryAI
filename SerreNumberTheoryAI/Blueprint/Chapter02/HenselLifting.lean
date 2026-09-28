import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter02.HenselLifting
import SerreNumberTheoryAI.Formalization.Chapter02.HenselTaylor
import SerreNumberTheoryAI.Formalization.Chapter02.HenselIteration
import SerreNumberTheoryAI.Formalization.Chapter02.HenselLimit
import SerreNumberTheoryAI.Formalization.Chapter02.HenselConclusion
import SerreNumberTheoryAI.Formalization.Chapter02.HenselLimitRoot
import SerreNumberTheoryAI.Formalization.Chapter02.HenselCorollary
import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticCorollary

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "第2章 2.2 近似解の改良" =>

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第2章・§2・2.2、印刷頁20--21（uploaded PDF pages 30--32）。

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
一変数版の最終結論は、`f(y)=0` かつ
`y ≡ x (mod p^(n-k))` を満たす `y ∈ Z_p` の存在である。
導関数の付値 `v_p(f'(y)) = k` は反復中の一段改良で保存する不変量であり、
Serre の最終定理の結論には含めない。
:::

:::definition "henselunivariatestep"
  (uses := "henselunivariatehypothesis, henselcongruence")
一回の Newton 改良では、真の零点までは要求せず、
`y ≡ x (mod p^(n-k))`、`f(y) ≡ 0 (mod p^(n+1))`、
および `v_p(f'(y)) = k` を要求する。
最後の条件を各段階で保存することで、同じ `k` を使って改良を反復できる。
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
評価値の消滅を一段高い冪まで改良し、選んだ偏微分の付値 `k` を保存する形で表す。
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

:::lemma_ "henseltaylordefectalgebra"
  (uses := "henseltaylordefect")
Taylor 余りの `h^2` 因子性について、零多項式・定数多項式・`X` の基礎例、
定数倍、加法・反数・減法、積、`X` の冪、係数付き単項式、そして一般多項式に対する閉性を準備する。
これにより、Serre の Taylor 展開で使う「余りは補正の二乗の倍数」という部分が、抽象仮定ではなく多項式代数の補題として使える。
:::

:::lemma_ "henseldivisibilitybookkeeping"
  (uses := "henselcongruence, henseltaylordefect")
`h` が `p^r` で割り切れ、Taylor 余りが `h^2` の倍数なら、余りは
`p^(r+r)` で割り切れる。特に `h = p^(n-k) z` なら、余りは
`p^((n-k)+(n-k))` の深さをもつ。
:::

:::lemma_ "henseliterationcauchy"
  (uses := "henselunivariatestep, henselcongruencerelation")
一段改良を指数 `n, n+1, n+2, ...` で反復して近似列 `y_r` を選ぶ。
各段階で `p^(n+r) ∣ f(y_r)` と導関数付値 `k` を保存し、
後ろの二項 `y_r, y_s` が任意に高い `p` 冪で合同になることを示す。
この合同深さの主張を、project-local metric の半径評価と `CauchySeq` に変換し、
project-local completeness から極限を得る。
:::

:::lemma_ "hensellimitcandidate"
  (uses := "henseliterationcauchy, henselunivariateconclusion")
完全性で得た極限を、反復列の各段階で成立している
評価値の可除性、導関数付値不変量、初期点との合同とともに束ねる。
さらに閉球を用いて、極限でも初期点との合同が保たれることを示す。
:::

:::lemma_ "henselexactroot"
  (uses := "hensellimitcandidate")
有限剰余レベルへの射影と一変数多項式評価の可換性を使い、
`p^(n+r) ∣ f(y_r)` という増大する可除性を極限へ渡す。
全ての有限深さで `f(y)` が割り切れることから、反復極限 `y` は
実際に `f(y)=0` を満たす。
:::

:::lemma_ "henselconclusionfromlimitroot"
  (uses := "hensellimitcandidate, henselexactroot, henselunivariateconclusion")
選ばれた反復極限で `f(y)=0` が示せれば、すでに得た初期合同性と合わせて、
Serre の一変数最終結論 `f(y)=0` かつ `y ≡ x (mod p^(n-k))` が従う。
:::

:::lemma_ "henselmultivariatefromunivariate"
  (uses := "henselcoordinateupdate, henselcoordinatecongruence, henselunivariateconclusion, henselmultivariateconclusion")
一座標だけを動かした多変数多項式について、評価の一致から一変数の根を
多変数の根へ戻せる。偏微分評価と一変数導関数の一致は、最初の
多変数仮定を一変数仮定へ移すために使い、最終結論そのものには
導関数の付値を追加しない。
:::

:::lemma_ "henselcoordinatespecialization"
  (uses := "henselcoordinateupdate, henselmultivariatefromunivariate")
`X_j` 以外の座標を `x_i` に固定して、一変数多項式
`serreHenselCoordinateSpecialization x j f` を作る。この多項式の評価は
一座標更新後の `f` の評価と一致し、その導関数の `x_j` での値は
選んだ偏微分 `∂f/∂X_j` の `x` での値と一致する。
:::

:::theorem "henselunivariatetheorem"
  (uses := "henselunivariatestep, henseldivisibilitybookkeeping, henseltaylordefectalgebra, henseliterationcauchy, hensellimitcandidate, henselexactroot, henselconclusionfromlimitroot")
一変数の Hensel 定理本体は、Newton 改良を反復して Cauchy 列を作り、
完全性によって極限を取り、有限剰余レベルへの射影で真の零点を得る部分である。
現在の PR では、この一変数境界までを project-local な補題として実装している。
:::

:::theorem "henseltheorem"
  (uses := "henselunivariatetheorem, henselmultivariatefromunivariate, henselcoordinatespecialization")
Serre の多変数定理は、一つの座標以外を固定した一変数特殊化に
一変数定理を適用し、その結果を座標更新として戻すことで得る。
現在の形式化では、座標特殊化を具体的に構成し、
source-shaped な多変数仮定から多変数結論を直接得る境界まで実装している。
:::

:::theorem "henselsimplerootcorollary"
  (uses := "henselunivariatetheorem, henseltheorem")
`n = 1`, `k = 0` の特殊化として、単純零点 modulo `p` が
`Z_p` 上の真の零点へ持ち上がる Corollary 1 を得る。一変数版と多変数版の
両方を source-shaped な仮定・結論として包装している。
:::

:::theorem "henselquadraticvaluecorollary"
  (uses := "henselsimplerootcorollary, henseltheorem")
系 2・系 3 の Hensel に依存する部分を包装する。
`f(x) ≡ a` に対して、奇素数の場合は選んだ偏微分が単元であれば
mod `p` の解を `f(y)=a` へ持ち上げる。`p=2` の場合は
mod `8` の解と偏微分付値 `1` から、mod `4` で合同な真の解を得る。
行列式や原始ベクトルからそのような偏微分を取り出す線形代数部分は、
別の境界として残す。
:::