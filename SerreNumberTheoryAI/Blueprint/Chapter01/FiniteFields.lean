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
