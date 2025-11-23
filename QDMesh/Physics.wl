(* --- QDMesh Physics Module: Beam Wander, Scintillation, Thermal Jitter --- *)

BeginPackage["QDMesh`Physics`", {"QDMesh`Core`"}];

AtmosphericState::usage = "Modelo físico con Cn2, scintillation y beam wander.";
ThermalJitter::usage = "Cálculo de jitter debido a térmicas y viento.";

Begin["`Private`"];

AtmosphericState[alt_, wind_, dist_, tempGradient_] := Module[
    {Cn2, rytov, scintillation, beamWander},

    Cn2 = 5.94*10^-53*(wind/27)^2*alt^10*Exp[-alt/1000] +
          2.7*10^-16*Exp[-alt/1500] +
          (1.7*10^-14*Exp[-alt/100])*(1 + tempGradient*0.5);

    rytov = 1.23 * Cn2 * (2*Pi/$Wavelength)^(7/6) * dist^(11/6);
    scintillation = Min[rytov, 1.0];

    beamWander = 1.83 * Cn2 * ($Wavelength)^(-1/6) * dist^(17/6);

    <|"Cn2" -> Cn2, "Scintillation" -> scintillation, "BeamWander_Var" -> beamWander|>
];

ThermalJitter[baseJitter_, temp_, wind_] :=
    baseJitter*(1 + (temp/30.0)*0.2 + (wind/10.0)*0.5);

End[];
EndPackage[];
