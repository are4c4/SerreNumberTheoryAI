import VersoManual
import VersoBlueprint.PreviewManifest
import SerreNumberTheoryAI.Blueprint

open Verso Doc
open Verso.Genre Manual

def main (args : List String) : IO UInt32 :=
  Informal.PreviewManifest.blueprintMainWithPreviewData
    (%doc SerreNumberTheoryAI.Blueprint)
    args
    (extensionImpls := by exact extension_impls%)
