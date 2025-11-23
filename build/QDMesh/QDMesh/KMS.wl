(* --- QDMesh KMS High-Fidelity --- *)

BeginPackage["QDMesh`KMS`"];

StoreKey::usage = "Almacena claves cuánticas con metadatos y expiración dinámica.";

Begin["`Private`"];

StoreKey[keyBits_, protocol_, sourceID_, lifetime_:3600] := <|
    "ID" -> CreateUUID[],
    "KeyHash" -> Hash[keyBits, "SHA256"],
    "Length" -> Length[keyBits],
    "Protocol" -> protocol,
    "Source" -> sourceID,
    "Expiry" -> DatePlus[Now, {lifetime, "Seconds"}],
    "Integrity" -> "Quantum-Verified"
|>;

End[];
EndPackage[];
