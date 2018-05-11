BeginPackage["VFD`"]

CreateVFD::usage="Use the ListPlot syntax to generate a Vernacular Figure Description."
PlotToVFD::usage="Transform an existing plot into a Vernacular Figure Description."

RawVFD::usage="Option to generate a VFD-like structure with Mma objects, but not to convert it to a string. Set it to True if you need to debug a failing call."
ThemeVFD::usage="Theme option to interpret a VFD file."

ExportVFD::usage="Export a Vernacular Figure Description. Provide a path with extension 'vfd' to export the VFD itself, or any other valid format (e.g., 'pdf') to generate it with matplotlib."
PreviewVFD::usage="Open a Vernacular Figure Description with the cli."


Begin["`Private`"]

If[Quiet[Check[RunProcess[{"vfd"}], err, RunProcess::pnfd], 
   RunProcess::pnfd] === err, 
 Print["Warning: vfd executable not found. Make sure it is installed \
and in the PATH. You can still use this package to export to a vfd \
file."]
 ]

(*Data is defined to be a matrix of numbers*)
pData = x_List /; MatrixQ[x, NumberQ];
DataQ = MatchQ[#, pData] &;

(*Make an option cycled in a list of given length*)
CycleOption[len_, value_] := If[ListQ[value], 
  PadRight[{}, len, value],
  Table[value, len]
]


(*Convert from Mma format to VFD format*)

DataToVFD[data_] := Module[{},
  If[DataQ[data],
   (*2D data*)
   
   Association["x" -> data[[All, 1]], "y" -> data[[All, 2]]],
   (*1D data*)
   Association["y" -> data]
   ]
  ]
  
(*Convert to strings, perhaps with TeX*)
CleanString[str_] := 
 If[Head[str] === String, str, "$"<>ToString[TeXForm[str]]<>"$"]
 
 
Options[CreateVFD] = Join[Map[#[[1]] -> None &, Options[ListPlot]], {RawVFD->False}];
  
CreateVFD[data_, opts : OptionsPattern[]] := 
 Module[{f, data2, series, axesLabel, plotLegends, joined},
  f = {};
  data2 = N[data];
  If[DataQ[data2], data2 = {data2}];
  series = Map[DataToVFD, data2];
  If[OptionValue[PlotLabel] =!= None, 
   AppendTo[f, "title" -> CleanString[OptionValue[PlotLabel]]]];
  axesLabel = OptionValue[AxesLabel];
  If[axesLabel =!= None, If[ListQ[axesLabel],
    (*If a list*)
    If[axesLabel[[1]] =!= None , AppendTo[f, "xlabel" -> CleanString[axesLabel[[1]]]]];
    If[Length[axesLabel] > 1, If[axesLabel[[2]] =!= None, AppendTo[f, "ylabel" -> CleanString[axesLabel[[2]]]]]],
    (*If just one label*)
    AppendTo[f, "ylabel" -> CleanString[axesLabel]]]
   (*TODO: FrameLabel too here*)];
  plotLegends = OptionValue[PlotLegends];
  If[plotLegends =!= None && ListQ[plotLegends], 
   series = MapThread[Append[#1, "label" -> CleanString[#2]] &, {series, PadRight[plotLegends, Length[series], ""]}]];
  joined = OptionValue[Joined];
  If[joined =!= None,joined=CycleOption[Length[series],joined];
  	series = MapThread[Append[#1, "joined" -> #2] &, {series, joined}]
  ];
  AppendTo[f, "type" -> "plot"];
  AppendTo[f, "series" -> series];
  If[OptionValue[RawVFD]===True,Association[f],ExportString[Association[f], "JSON"]]
  ]
  
  
Options[PlotToVFD]={RawVFD->False, PlotLegends->None};

PlotToVFD[plot_Graphics, opts:OptionsPattern[]] := Module[{data, options},
	data = {Cases[First@plot, Line[d_] | Point[d_] :> d, -4]};
	options = Join[{plot[[2]]},{RawVFD->OptionValue[RawVFD], PlotLegends->OptionValue[PlotLegends]}];
    CreateVFD @@ Join[data, options]
]

PlotToVFD[plot_Legended, opts:OptionsPattern[]] := PlotToVFD[plot[[1]],
	PlotLegends->Cases[plot[[2]], PointLegend[d__] | LineLegend[d__] | SwatchLegend[d__] :> d, {0, Infinity}, 1][[2]]
	]

(*A environment with no Mma libraries*)
cleanEnvironment = Association[DeleteCases[GetEnvironment[All], "LD_LIBRARY_PATH" -> _]]

Options[ExportVFD]={ThemeVFD->None};

ExportVFD[path_, vfd_, opts:OptionsPattern[]]:= Module[{ext,args},
	ext=StringSplit[path, "."][[-1]];
	If[ext==="vfd",
	Export[path,vfd,"string"],
	SetDirectory[$TemporaryDirectory];
	ExportVFD["vfdmma.vfd", vfd];
	args={"vfd", "vfdmma.vfd","--format="<>ext};
	If[OptionValue[ThemeVFD]=!=None,AppendTo[args,"--theme="<>OptionValue[ThemeVFD]]];
	RunProcess[args, ProcessEnvironment -> cleanEnvironment];
	ResetDirectory[];
	If[FileExistsQ[path],DeleteFile[path]];
	CopyFile[FileNameJoin[{$TemporaryDirectory,"vfdmma."<>ext}],path];
	DeleteFile[FileNameJoin[{$TemporaryDirectory,"vfdmma."<>ext}]];
	DeleteFile[FileNameJoin[{$TemporaryDirectory,"vfdmma.py"}]];
	DeleteFile[FileNameJoin[{$TemporaryDirectory,"vfdmma.vfd"}]];
	path
	]
]


Options[PreviewVFD]={ThemeVFD->None};

PreviewVFD[vfd_, opts:OptionsPattern[]]:= Module[{cmd},
	SetDirectory[$TemporaryDirectory];
	ExportVFD["vfdmma.vfd", vfd];
	cmd=If[OptionValue[ThemeVFD]===None,{"vfd", "vfdmma.vfd"},{"vfd", "vfdmma.vfd","--theme="<>OptionValue[ThemeVFD]}];
	RunProcess[cmd, ProcessEnvironment -> cleanEnvironment];
	DeleteFile["vfdmma.py"];
	DeleteFile["vfdmma.vfd"];
	ResetDirectory[];
]




End[]

EndPackage[]

