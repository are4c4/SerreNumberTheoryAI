import Verso
import VersoManual
import VersoBlueprint
import VersoBlueprint.Commands.Graph
import VersoBlueprint.Commands.Summary

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "セール『数論講義』AI形式化 Blueprint" =>

# このBlueprintについて

この文書は、セール『数論講義』を参考にAIが独立に構成する自然言語説明とLean形式化の依存関係を管理する。

書籍本文を転載・逐語的に言い換えるのではなく、数学的内容を定義・補題・命題・定理へ分解し、各ノードをLean declarationへ対応付ける。

現在は初期インフラのみを構築しており、数学的ノードはPhase 1から追加する。

# 定理の依存関係

{blueprint_graph}

# 形式化の進捗

{blueprint_summary}
