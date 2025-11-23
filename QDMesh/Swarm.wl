(* --- QDMesh Swarm Intelligence Module --- *)

BeginPackage["QDMesh`Swarm`"];

CooperativeFusion::usage =
    "Fusión de información entre drones (consenso).";
PredictThreat::usage =
    "IA ligera para detectar eavesdropping o nodos maliciosos.";

Begin["`Private`"];

$AttackClassifier = Classify[
    {
        {0.01, 0.1, "HighTrust"} -> "SAFE",
        {0.20, 0.1, "HighTrust"} -> "ATTACK",
        {0.05, 0.9, "LowTrust"}  -> "RISK",
        {0.15, 0.5, "Unknown"}   -> "ATTACK"
    },
    Method -> "NearestNeighbors"
];

PredictThreat[qber_, reputation_] :=
    $AttackClassifier[{qber, reputation, "HighTrust"}];

CooperativeFusion[data_List] := Module[{avgQBER, wind},
    avgQBER = Mean[data[[All, "QBER"]]];
    wind = Median[data[[All, "Wind"]]];
    <|"GlobalQBER" -> avgQBER, "GlobalWind" -> wind|>
];

End[];
EndPackage[];
