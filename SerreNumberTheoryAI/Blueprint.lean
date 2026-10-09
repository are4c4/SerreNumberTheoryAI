import Verso
import VersoManual
import VersoBlueprint
import VersoBlueprint.Commands.Graph
import VersoBlueprint.Commands.Summary

import SerreNumberTheoryAI.Blueprint.Chapter01.FiniteFields
import SerreNumberTheoryAI.Blueprint.Chapter01.MultiplicativeGroup
import SerreNumberTheoryAI.Blueprint.Chapter01.PowerSums
import SerreNumberTheoryAI.Blueprint.Chapter01.Chevalley
import SerreNumberTheoryAI.Blueprint.Chapter01.ChevalleyNontrivialZero
import SerreNumberTheoryAI.Blueprint.Chapter01.ChevalleyQuadraticForm
import SerreNumberTheoryAI.Blueprint.Chapter01.QuadraticElements
import SerreNumberTheoryAI.Blueprint.Chapter01.LegendreSymbol
import SerreNumberTheoryAI.Blueprint.Chapter01.LegendreTwo
import SerreNumberTheoryAI.Blueprint.Chapter01.QuadraticReciprocity
import SerreNumberTheoryAI.Blueprint.Chapter01.GaussLemma
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicIntegers
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicIntegerProperties
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicIntegerMetric
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicField
import SerreNumberTheoryAI.Blueprint.Chapter02.RootExistence
import SerreNumberTheoryAI.Blueprint.Chapter02.PrimitiveHomogeneousZeros
import SerreNumberTheoryAI.Blueprint.Chapter02.HenselLifting
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFiltration
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitRoots
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFiniteComplement
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicResidueUnitRoots
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicFiniteComplementResidueRoots
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFiniteComplementLimit
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFieldRoots
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitPowerStep
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotient
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientCard
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientCyclic
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientTransition
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientCompatibility
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteInverseLimit
import SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitResidueQuotient

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "セール『数論講義』AI形式化 Blueprint" =>

# このBlueprintについて

この文書は、セール『数論講義』を参考にAIが独立に構成する自然言語説明とLean形式化の依存関係を管理する。

書籍本文を転載・逐語的に言い換えるのではなく、数学的内容を定義・補題・命題・定理へ分解し、各ノードをLean declarationへ対応付ける。

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.FiniteFields}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.MultiplicativeGroup}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.PowerSums}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.Chevalley}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.ChevalleyNontrivialZero}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.ChevalleyQuadraticForm}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.QuadraticElements}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.LegendreSymbol}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.LegendreTwo}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.QuadraticReciprocity}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter01.GaussLemma}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicIntegers}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicIntegerProperties}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicIntegerMetric}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicField}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.RootExistence}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PrimitiveHomogeneousZeros}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.HenselLifting}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFiltration}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitRoots}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFiniteComplement}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicResidueUnitRoots}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicFiniteComplementResidueRoots}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFiniteComplementLimit}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicUnitFieldRoots}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitPowerStep}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotient}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientCard}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientCyclic}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientTransition}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteQuotientCompatibility}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitFiniteInverseLimit}

{include 0 SerreNumberTheoryAI.Blueprint.Chapter02.PadicPrincipalUnitResidueQuotient}

# 定理の依存関係

{blueprint_graph}

# 形式化の進捗

{blueprint_summary}
