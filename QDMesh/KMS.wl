(* --- QDMesh Key Management System (KMS) --- *)

BeginPackage["QDMesh`KMS`"];

StoreKey::usage = "Guarda clave con metadatos y expiración.";

Begin["`Private`"];

StoreKey[keyBits_, protocol_, sourceID_] := <|
    "ID" -> CreateUUID[],
    "KeyHash" -> Hash[keyBits, "SHA256"],
    "Length" -> keyBits,
    "Protocol" -> protocol,
    "Source" -> sourceID,
    "Expiry" -> DatePlus[Now, {1, "Hour"}],
    "Integrity" -> "Quantum-Verified"
|>;

End[];
EndPackage[];
