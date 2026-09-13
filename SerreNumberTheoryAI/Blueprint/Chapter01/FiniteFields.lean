import Verso
import VersoManual
import VersoBlueprint

import SerreNumberTheoryAI.Formalization.Chapter01.FiniteFields

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "1.1 有限体 — 基礎部分" =>

# 第1章 有限体

## §1 有限体の性質

### 1.1 有限体

*出典メタデータ:* J.-P. セール著・弥永健一訳『数論講義』日本語版、
第1部・第1章・§1・1.1、印刷頁3–4（uploaded PDF pages 13–14）。

この節では、有限体の標数とFrobenius写像から出発して、有限体の位数が標数のべきになることを整理する。
書籍の文章を再現するのではなく、Leanで必要な依存関係に沿って数学的内容を独立に構成する。

## 記法とLeanでの対応

有限集合の要素数はLeanでは主に `Fintype.card` で表す。
また、環の可逆元全体は `Kˣ` という型で扱う。
標数 `p` の条件は `CharP K p` または、Frobeniusに適した `ExpChar K p` で表現する。

:::definition "frobenius_power_map" (lean := "SerreNumberTheoryAI.frobeniusPowerMap")
標数が正の素数 `p` である状況では、`x ↦ x^p` は積だけでなく和も保つので環準同型になる。
Leanではこの写像を `frobeniusPowerMap` として明示的に構成する。
:::

:::proof "frobenius_power_map"
積については通常のべきの法則を使う。
和については標数 `p` におけるFrobeniusの恒等式を使い、`(x+y)^p=x^p+y^p` を得る。
Leanではこの加法性を一般的な `add_pow_expChar` から得るが、有限体についての完成済み定理は使用しない。
:::

:::definition "frobenius_image" (lean := "SerreNumberTheoryAI.frobeniusImage") (uses := "frobenius_power_map")
Frobenius写像の像を部分体としてとらえたものを `K^p` に対応する対象とみなす。
ここでは `RingHom.fieldRange` を用いて、像そのものを部分体として保持する。
:::

:::lemma_ "frobenius_equiv_image" (lean := "SerreNumberTheoryAI.frobeniusEquivImage") (uses := "frobenius_image")
Frobenius写像により、体 `K` はその像部分体と環同型になる。
:::

:::proof "frobenius_equiv_image"
Frobenius写像が環準同型であることを先に構成した。
体から体への単位元を保つ環準同型は単射なので、その写像を像に制限すると全単射になる。
Leanでは一般的な field-range equivalence を使ってこの同型を組み立てる。
:::

:::theorem "finite_field_characteristic_prime" (lean := "SerreNumberTheoryAI.finiteField_characteristic_prime")
有限体の標数は素数である。
:::

:::proof "finite_field_characteristic_prime"
体の標数は一般に `0` または素数である。
一方、有限な環では標数 `0` は起こらない。
したがって有限体の標数は素数になる。
:::

:::theorem "finite_field_cardinality_prime_power" (lean := "SerreNumberTheoryAI.finiteField_cardinality_prime_power") (uses := "finite_field_characteristic_prime")
有限体 `K` の標数を `p` とすると、ある正整数 `f` が存在して
`Card(K)=p^f` となる。
:::

:::proof "finite_field_cardinality_prime_power"
標数が `p` なので、`K` は素体 `F_p` 上のベクトル空間とみなせる。
有限体であるためこのベクトル空間の次元 `f` は有限であり、各座標には `p` 通りの選択肢がある。
したがって要素数は `p^f` である。
さらに `K` は非自明な体なので次元は0ではなく、`f>0` となる。

Leanでは `F_p` を `ZMod p` で表し、一般的な有限次元ベクトル空間の要素数公式
`Module.card_eq_pow_finrank` を使う。
対象そのものに近い `FiniteField.card` は意図的に使用しない。
:::

## 定理1(ii) — 固定された代数閉体の中の有限部分体

以下では、素数 `p`、正整数 `f`、`q=p^f` を固定し、標数 `p` の代数閉体 `Ω` の中で考える。
ここでの一意性は、抽象的な体の同型を除いて一意という意味ではなく、同じ `Ω` の部分体として一意という意味である。

:::definition "q_power_fixed_points" (lean := "SerreNumberTheoryAI.primePowerFixedSubfield") (uses := "frobenius_power_map")
`Ω` の元のうち `x^q=x` を満たすもの全体を考える。
これは `q` 乗写像の固定点集合であり、多項式 `X^q-X` の `Ω` における根の集合と同じである。
:::

:::lemma_ "q_power_fixed_points_form_subfield" (lean := "SerreNumberTheoryAI.mem_primePowerFixedSubfield") (uses := "q_power_fixed_points, frobenius_power_map")
`q=p^f` であるため、標数 `p` では `q` 乗写像はFrobenius写像を `f` 回合成した写像として振る舞う。
したがって `x^q=x` を満たす元は、加法・乗法・加法逆元について閉じ、非零元の逆元についても閉じる。
このため `q_power_fixed_points` は `Ω` の部分体を定める。
:::

:::proof "q_power_fixed_points_form_subfield"
固定点 `x,y` に対し、Frobeniusの加法性と乗法性を `f` 回反復すると
`(x+y)^q=x^q+y^q=x+y` および `(xy)^q=x^q y^q=xy` が得られる。
加法逆元も同様に固定される。
さらに `x≠0` なら `(x⁻¹)^q=(x^q)⁻¹=x⁻¹` なので、逆元についても閉じる。
`0` と `1` も固定点であるため、これらの元全体は部分体をなす。
:::

:::lemma_ "q_power_fixed_points_cardinality" (lean := "SerreNumberTheoryAI.primePowerFixedSubfield_natCard") (uses := "q_power_fixed_points")
`q_power_fixed_points` はちょうど `q` 個の元を持つ。
:::

:::proof "q_power_fixed_points_cardinality"
多項式 `P(X)=X^q-X` を考える。`Ω` は代数閉体なので `P` は `Ω` 上で一次式の積に分解する。
また `q=p^f` だから標数 `p` では係数 `q` は0になり、形式微分は `P'(X)=-1` となる。
したがって `P` は重根を持たない。
次数が `q` で、すべての根が `Ω` にあり、しかも重複しないので、根はちょうど `q` 個存在する。
これらの根はまさに `x^q=x` を満たす元である。
:::

:::theorem "finite_subfield_cardinality_q_unique" (lean := "SerreNumberTheoryAI.serre_theorem1_ii") (uses := "q_power_fixed_points_form_subfield, q_power_fixed_points_cardinality")
標数 `p` の代数閉体 `Ω` には、位数 `q=p^f` の部分体がただ一つ存在する。
その部分体の台集合は `x^q=x` を満たす元全体であり、したがって `X^q-X` の `Ω` における根全体でもある。
:::

:::proof "finite_subfield_cardinality_q_unique"
存在については、`q_power_fixed_points_form_subfield` で得た固定点部分体を用いる。
`q_power_fixed_points_cardinality` により、その位数は正確に `q` である。

一意性のため、`Ω` の任意の `q` 元部分体 `E` をとる。
`E` の非零元全体は位数 `q-1` の有限群なので、各 `x≠0` について `x^(q-1)=1` が成り立つ。
従って `x^q=x` であり、`x=0` の場合も同じ等式を満たす。
よって `E` のすべての元は `q_power_fixed_points` に含まれる。
両者の位数はともに `q` だから、包含は等号である。
したがって `Ω` の中の `q` 元部分体はこの固定点部分体ただ一つである。

この議論は固定された代数閉体の内部での一意性を示すものであり、異なる有限体同士の抽象的な同型一意性は次の別ターゲットに残す。
:::

## 定理1(iii) — 位数による有限体の抽象同型一意性

引き続き `q=p^f` とし、定理1(ii)で得た `Ω` 内の `q` 元部分体を標準的な代表 `F_q` とみなす。
ここでは、別の有限体 `K` が同じ `q` 個の元を持つなら、`K` と `F_q` が環同型になることを示す。
これは二つの体を同じ集合として等しいと主張するのではなく、体構造を保つ全単射が存在するという主張である。

:::definition "finite_field_equiv_canonical_q_field" (lean := "SerreNumberTheoryAI.finiteFieldEquivPrimePowerFixedSubfield") (uses := "finite_subfield_cardinality_q_unique")
位数が `q=p^f` の有限体 `K` をとる。要素数が素数 `p` のべきであることから `K` の標数は `p` と分かるので、`K` は `F_p` 上の有限代数拡大とみなせる。
標数 `p` の代数閉体 `Ω` への埋め込みを一つ選び、その像を `Ω` の部分体 `E` とする。
埋め込みは `K` と `E` の間の体同型を与え、`E` の要素数も `q` である。
定理1(ii)の一意性によって `E=F_q` となるため、この同型を `F_q` への同型へ移すことができる。
:::

:::proof "finite_field_equiv_canonical_q_field"
まず `|K|=p^f` から一般的な標数と濃度の関係を用いて `CharP K p` を得る。
次に `F_p` をLeanでは `ZMod p` として扱い、有限性から `K/F_p` が代数的であることを使う。
代数閉体では代数拡大の各最小多項式が分解するので、拡大体の埋め込み定理により `K` から `Ω` への `F_p`-代数準同型が得られる。
体からの準同型は単射であり、像への制限は `K` と像部分体 `E` の同型になる。
この同型から `|E|=|K|=q` を得て、`finite_subfield_cardinality_q_unique` を適用すると `E` は定理1(ii)の固定点部分体と一致する。
最後に像への同型とこの部分体の同一視を合成する。

Leanでは有限体同士が同じ位数なら同型になるという完成済みの有限体分類定理を直接使わず、定理1(ii)へ戻るこの構成を明示する。
:::

:::theorem "finite_field_cardinality_q_isomorphic" (lean := "SerreNumberTheoryAI.serre_theorem1_iii") (uses := "finite_field_equiv_canonical_q_field")
`p` を素数、`f>0` とし、`K` が `p^f` 個の元を持つ有限体なら、`K` は定理1(ii)で構成した `p^f` 元体と同型である。
したがって、位数 `q=p^f` を固定すると有限体は抽象的な体同型を除いて一意である。
:::

:::proof "finite_field_cardinality_q_isomorphic"
`finite_field_equiv_canonical_q_field` が必要な体同型そのものを構成しているので、その同型の存在を取り出せばよい。
定理1(ii)が「一つの代数閉体の中での部分体の一意性」を与えるのに対し、この定理は任意の有限体をその代数閉体へ埋め込むことで「抽象的な同型を除く一意性」へ移している。
:::
