(* --- QDMesh Core High-Fidelity --- *)

BeginPackage["QDMesh`Core`"];

$Wavelength::usage = "Longitud de onda de transmisión láser (m).";
$Aperture::usage = "Diámetro de apertura del sistema óptico (m).";
$DroneMass::usage = "Masa del dron (kg).";
$BatteryCapacity::usage = "Capacidad de energía de la batería (Joules).";
$DragCoeff::usage = "Coeficiente de arrastre aerodinámico del dron.";
$CrossSection::usage = "Área frontal efectiva del dron (m^2).";

Begin["`Private`"];

$Wavelength = 1550*10^-9; 
$Aperture = 0.12; 
$DroneMass = 4.5;
$BatteryCapacity = 600000; 
$DragCoeff = 0.4; 
$CrossSection = 0.1;

End[];
EndPackage[];
