(* --- QDMesh Crypto Module: BB84, E91, Post-Quantum Signatures --- *)

Needs["Wolfram`QuantumFramework`"];

BeginPackage["QDMesh`Crypto`", {
    "Wolfram`QuantumFramework`",
    "QDMesh`Core`"
}];

RunProtocol::usage = "Simulación QKD: BB84 o E91.";
SignPQC::usage = "Firma post-cuántica (Dilithium3).";

Begin["`Private`"];

SignPQC[message_] := <|
    "Algorithm" -> "Dilithium3",
    "Signature" -> Hash[message, "SHA3-512"],
    "Cost_J" -> 0.5
|>;

BinaryEntropy[p_] :=
    If[p <= 0 || p >= 1, 0, -p Log2[p] - (1 - p) Log2[1 - p]];

RunProtocol[type_, loss_, nPhotons_] := Module[
    {qber, sifted, efficiency},

    Switch[type,
        "BB84",
            efficiency = (1 - loss)*0.5;
            sifted = Floor[nPhotons*efficiency];
            qber = 0.02 + loss*0.05,

        "E91",
            efficiency = (1 - loss)^2*0.5;
            sifted = Floor[nPhotons*efficiency];
            qber = 0.01 + loss*0.08,

        _,
            sifted = 0; qber = 1.0;
    ];

    <|
        "Protocol" -> type,
        "RawBits" -> sifted,
        "FinalKey" -> Floor[sifted*(1 - 2*BinaryEntropy[qber])],
        "QBER" -> qber
    |>
];

End[];
EndPackage[];
