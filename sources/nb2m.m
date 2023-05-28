#!/usr/bin/env wolframscript
(* ::Package:: *)

argv=Rest@$ScriptCommandLine;
file=argv[[1]];

cellPattern = 
  "Title" | "Input" | "Chapter" | "Section" | "Subsection" | 
   "Subsubection" | "Text" | "Subchapter";

types = {
   "Title" -> "Cell" ,
   "Chapter" -> "Cell",
   "Subchapter" -> "Cell",
   "Section" -> "Cell",
   "Subsection" -> "Cell",
   "Subsubsection" -> "Cell",
   "Text" -> "Cell",
   "Input" -> "RowBox"};

finalSubs = {
   "\r" -> "",
   FromCharacterCode[62371] -> "\n",
   FromCharacterCode[62754] -> "->"
   };

cells = NotebookImport[file,
   cellPattern,
   "StyleImportRules" -> types];

cells = ReplaceRepeated[{
     RowBox[a_?(VectorQ[#, StringQ] &)] :> StringRiffle[a, ""],
     SubscriptBox[a_?StringQ, b_?StringQ] :> a <> b,
     SuperscriptBox[a_?StringQ, b_?StringQ] :> 
      "Power[" <> a <> "," <> b <> "]",
     SqrtBox[a_?StringQ] :> "Sqrt[" <> a <> "]",
     FractionBox[a_?StringQ, b_?StringQ] :> 
      "(" <> a <> ")/(" <> b <> ")",
     BoxData[a_] :> a
     }][cells]/. a_?(VectorQ[#, StringQ] &) :> StringRiffle[a, "\n"];

cells = Flatten@Replace[cells,
    {a_?StringQ :> {"(* ::Input::Initialization:: *)", a, "\n"},
     Cell[a_, b_, ___] :> {
      "(* ::" <> b <> ":: *)", 
       "(*" <> a <> "*)", "\n"}},
    1];

resString = 
  "(* ::Package:: *)\n\n" <> 
   StringReplace[StringRiffle[cells, "\n"], finalSubs];

Export[StringDrop[file, -2] <> "m", resString, "Text"];
