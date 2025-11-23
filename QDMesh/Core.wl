(* --- QDMesh Core Module --- *)

BeginPackage["QDMesh`Core`"];

$Wavelength::usage = "Longitud de onda (m).";
$Aperture::usage = "Apertura del sistema óptico (m).";
$DroneMass::usage = "Masa del dron (kg).";
$BatteryCapacity::usage = "Capacidad de energía de la batería (Joules).";

Begin["`Private`"];

$Wavelength = 1550*10^-9;
$Aperture = 0.10;
$DroneMass = 4.5;
$BatteryCapacity = 500000;

End[];
EndPackage[];
