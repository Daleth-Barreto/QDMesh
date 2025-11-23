(* --- QDMesh Crypto High-Fidelity --- *)

Needs["Wolfram`QuantumFramework`"];
BeginPackage["QDMesh`Crypto`", {"Wolfram`QuantumFramework`","QDMesh`Core`","QDMesh`Physics`"}];

RunProtocol::usage = 
    "Simula QKD BB84/E91 considerando pérdidas atmosféricas y jitter.";
SignPQC::usage = "Firma post-cuántica simulada.";

Begin["`Private`"];

SignPQC[message_] := <|
    "Algorithm" -> "Dilithium3",
    "Signature" -> Hash[message,"SHA3-512"],
    "EnergyCost_J" -> 0.5
|>;

BinaryEntropy[p_] := If[p <= 0 || p >= 1, 0, -p Log2[p] - (1-p) Log2[1-p]];

RunProtocol[type_, nPhotons_, loss_, pointingError_:0] := Module[
    {efficiency, qber, sifted, totalLoss},
    totalLoss = (1 - loss)*(1 - pointingError^2/2);
    Switch[type,
        "BB84",
            efficiency = 0.5*totalLoss;
            sifted = Floor[nPhotons*efficiency];
            qber = 0.02 + 0.05*(1 - totalLoss),
        "E91",
            efficiency = 0.5*totalLoss^2;
            sifted = Floor[nPhotons*efficiency];
            qber = 0.01 + 0.08*(1 - totalLoss),
        _,
            sifted = 0; qber = 1.0;
    ];
    <|
        "Protocol" -> type,
        "RawBits" -> sifted,
        "FinalKey" -> Floor[sifted*(1 - 2*BinaryEntropy[qber])],
        "QBER" -> qber,
        "Loss" -> totalLoss
    |>
];

End[];
EndPackage[];
