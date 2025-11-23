(* --- QDMesh Physics High-Fidelity --- *)

BeginPackage["QDMesh`Physics`", {"QDMesh`Core`"}];

BeamPropagation::usage = "Calcula pérdida total por distancia, turbulencia y apuntado.";
ThermalJitter::usage = "Cálculo de jitter adicional por temperatura y viento.";
Scintillation::usage = "Índice de scintillation estocástico según Cn² y distancia.";

Begin["`Private`"];

(* Beam divergence y pérdida atmosférica *)
BeamPropagation[alt_, dist_, wind_, tempGradient_, pointingError_] := Module[
    {Cn2, beamWander, scint, geometricLoss, totalLoss},

    Cn2 = 5.94*10^-53*(wind/27)^2*alt^10*Exp[-alt/1000] +
          2.7*10^-16*Exp[-alt/1500] +
          (1.7*10^-14*Exp[-alt/100])*(1 + tempGradient*0.5);

    (* Beam wander variable *)
    beamWander = 1.83 * Cn2 * $Wavelength^(-1/6) * dist^(17/6);

    (* Scintillation índice *)
    scint = Min[1.23 * Cn2 * (2*Pi/$Wavelength)^(7/6) * dist^(11/6), 1.0];

    (* Pérdida geométrica por apertura y divergencia *)
    geometricLoss = (1 - $Aperture^2/(dist * $Wavelength / Pi + $Aperture)^2);

    (* Pérdida total incluyendo pointing error *)
    totalLoss = geometricLoss*(1 - scint)*(1 - pointingError^2/2);

    <|"Cn2" -> Cn2, "BeamWander" -> beamWander, "Scintillation" -> scint, "TotalLoss" -> totalLoss|>
];

(* Jitter térmico avanzado *)
ThermalJitter[baseJitter_, temp_, wind_, controlGain_:1.0] :=
    baseJitter*(1 + 0.2*temp/30 + 0.5*wind/10)*controlGain;

(* Scintillation estocástica *)
Scintillation[Cn2_, dist_] := Module[{sigmaR2},
    sigmaR2 = 1.23 * Cn2 * (2*Pi/$Wavelength)^(7/6) * dist^(11/6);
    RandomVariate[NormalDistribution[sigmaR2, sigmaR2/5]]
];

End[];
EndPackage[];
