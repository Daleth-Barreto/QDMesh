(* --- QDMesh Power Module --- *)

BeginPackage["QDMesh`Power`", {"QDMesh`Core`"}];

CalculateConsumption::usage = "Consumo energético por vuelo y actividad computacional.";

Begin["`Private`"];

CalculateConsumption[velocity_, isTransmitting_, isComputing_] := Module[
    {hoverPower, dragPower, avionics, laserPower, cpuPower},

    hoverPower = ($DroneMass*9.8)^1.5/Sqrt[2*1.225*($Aperture*4)];
    dragPower = 0.5*1.225*0.1*velocity^3;

    avionics = 20;
    laserPower = If[isTransmitting, 15, 0];
    cpuPower = If[isComputing, 45, 5];

    hoverPower + dragPower + avionics + laserPower + cpuPower
];

End[];
EndPackage[];
