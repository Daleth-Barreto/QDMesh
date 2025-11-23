(* --- QDMesh Power High-Fidelity --- *)

BeginPackage["QDMesh`Power`", {"QDMesh`Core`"}];

CalculateConsumption::usage =
    "Potencia total (Watts) considerando hover, avance, arrastre, láser y CPU.";

Begin["`Private`"];

CalculateConsumption[velocity_, isTransmitting_, isComputing_, altitude_] := Module[
    {rho, dragPower, hoverPower, liftPower, avionicsPower, laserPower, cpuPower},

    rho = 1.225*Exp[-altitude/8500]; (* Densidad atmosférica según altitud *)

    (* Hover y lift *)
    liftPower = ($DroneMass*9.81)^(3/2)/Sqrt[2*rho*$CrossSection];
    dragPower = 0.5*rho*$DragCoeff*$CrossSection*velocity^3;

    avionicsPower = 20;
    laserPower = If[isTransmitting, 15, 0];
    cpuPower = If[isComputing, 45, 5];

    liftPower + dragPower + avionicsPower + laserPower + cpuPower
];

End[];
EndPackage[];
