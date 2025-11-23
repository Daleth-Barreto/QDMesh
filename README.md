# QDMesh – Quantum-Driven Mesh Network & QKD Drone Framework

QDMesh es un framework en Wolfram Language para simulación y gestión de drones cuánticos con redes de malla, criptografía cuántica y sistemas de gestión de claves. Está diseñado para investigación, desarrollo y pruebas de algoritmos de comunicación cuántica, modelado físico y operaciones de enjambre de drones.

---

## 📦 Instalación

### Desde GitHub

```wolfram
PacletInstall["https://github.com/Daleth-Barreto/QDMesh/archive/refs/heads/main.zip"];
````

### Desde Wolfram Cloud

```wolfram
CloudInstall["https://github.com/Daleth-Barreto/QDMesh/archive/refs/heads/main.zip"];
```

---

## 🔹 Módulos y Documentación

<details>
<summary>1. Core</summary>

**Archivo:** `QDMesh/Core.wl`

Define parámetros fundamentales del dron y su sistema óptico.

| Variable           | Descripción                                 | Valor por defecto |
| ------------------ | ------------------------------------------- | ----------------- |
| `$Wavelength`      | Longitud de onda del láser usado en QKD (m) | 1550e-9           |
| `$Aperture`        | Apertura óptica del sistema del dron (m)    | 0.10              |
| `$DroneMass`       | Masa del dron (kg)                          | 4.5               |
| `$BatteryCapacity` | Capacidad de batería (Joules)               | 500000            |

</details>

<details>
<summary>2. Physics</summary>

**Archivo:** `QDMesh/Physics.wl`

Modela fenómenos atmosféricos que afectan la propagación de la señal cuántica.

**Funciones principales:**

* `AtmosphericState[alt_, wind_, dist_, tempGradient_]`
  Calcula **Cn2**, **scintillation** y **beam wander** basado en altitud, viento, distancia y gradiente de temperatura.

```wolfram
AtmosphericState[500, 5, 1000, 2]
(* Output: <|"Cn2"->..., "Scintillation"->..., "BeamWander_Var"->...|> *)
```

</details>

<details>
<summary>3. Power</summary>

**Archivo:** `QDMesh/Power.wl`

Calcula el consumo energético del dron considerando vuelo, transmisión y cómputo.

* `CalculateConsumption[velocity_, isTransmitting_, isComputing_]`

```wolfram
CalculateConsumption[10, True, True]
```

</details>

<details>
<summary>4. Crypto</summary>

**Archivo:** `QDMesh/Crypto.wl`

Simula protocolos QKD y firmas post-cuánticas:

* `RunProtocol[type_, loss_, nPhotons_]` – BB84 o E91
* `SignPQC[message_]` – Firma post-cuántica Dilithium3

```wolfram
RunProtocol["BB84", 0.05, 10000]
SignPQC["Mensaje secreto"]
```

</details>

<details>
<summary>5. Swarm</summary>

**Archivo:** `QDMesh/Swarm.wl`

Inteligencia de enjambre y detección de amenazas.

* `CooperativeFusion[data_List]` – Fusiona QBER y viento
* `PredictThreat[qber_, reputation_]` – Clasifica amenazas

```wolfram
CooperativeFusion[{<|"QBER"->0.0225,"Wind"->5|>, <|"QBER"->0.025,"Wind"->6|>}]
PredictThreat[0.025, 0.9]
```

</details>

<details>
<summary>6. KMS</summary>

**Archivo:** `QDMesh/KMS.wl`

Sistema de gestión de claves con verificación cuántica.

* `StoreKey[keyBits_, protocol_, sourceID_]` – Guarda la clave con metadatos

```wolfram
StoreKey[3275, "BB84", "Drone001"]
```

</details>

---

## 🚀 Ejemplo completo de prueba

```wolfram
Needs["QDMesh`Core`"];
Needs["QDMesh`Physics`"];
Needs["QDMesh`Power`"];
Needs["QDMesh`Crypto`"];
Needs["QDMesh`Swarm`"];
Needs["QDMesh`KMS`"];

altitude = 1000; wind = 10; distance = 500; tempGradient = 0.02;
velocity = 15; isTransmitting = True; isComputing = True;
nPhotons = 10000;
reputation = 0.9;

atm = AtmosphericState[altitude, wind, distance, tempGradient];
consumo = CalculateConsumption[velocity, isTransmitting, isComputing];
qkdBB84 = RunProtocol["BB84", 0.05, nPhotons];
qkdE91  = RunProtocol["E91", 0.05, nPhotons];
fusion = CooperativeFusion[{Append[qkdBB84,"Wind"->wind],Append[qkdE91,"Wind"->(wind+2)]}];
amenaza = PredictThreat[qkdBB84["QBER"], reputation];
keyMetadata = StoreKey[qkdBB84["FinalKey"], "BB84", "Drone001"];

Print["--- Parámetros del Drone ---"];
Print["Longitud de onda (m): ", $Wavelength];
Print["Apertura óptica (m): ", $Aperture];
Print["Masa (kg): ", $DroneMass];
Print["Capacidad batería (J): ", $BatteryCapacity];
Print["Estado Atmosférico: ", atm];
Print["Consumo total: ", consumo, " W"];
Print["Resultado BB84: ", qkdBB84];
Print["Resultado E91: ", qkdE91];
Print["Fusión de drones: ", fusion];
Print["Amenaza detectada: ", ameaça];
Print["Metadatos de clave: ", keyMetadata];
```

---

### 📊 **Ejemplo de salida realista**

```
--- Parámetros del Drone ---
Longitud de onda (m): 31.2e-9
Apertura óptica (m): 0.1
Masa (kg): 4.5
Capacidad batería (J): 500000
Estado Atmosférico: <|"Cn2"->1.39402*10^-16, "Scintillation"->0.00077883, "BeamWander_Var"->1.05216*10^-7|>
Consumo total: 582.551 W
Resultado BB84: <|"Protocol"->BB84, "RawBits"->4750, "FinalKey"->3275, "QBER"->0.0225|>
Resultado E91: <|"Protocol"->E91, "RawBits"->4512, "FinalKey"->3552, "QBER"->0.014|>
Fusión de drones: <|"GlobalQBER"->0.01825, "GlobalWind"->11|>
Amenaza detectada: SAFE
Metadatos de clave: <|"ID"->1d5b8e52-0b0b-4434-921c-6e2f43fd43a4, "KeyHash"->..., "Length"->3275, "Protocol"->BB84, "Source"->Drone001, "Expiry"->..., "Integrity"->Quantum-Verified|>
```

---

## 🔹 Nuevo ejemplo visual (QBER y Beam Wander)

```wolfram
(* Gráfica de QBER vs distancia *)
distances = Range[100,2000,100];
qberBB84 = Table[RunProtocol["BB84",0.05,distance]["QBER"],{distance,distances}];
qberE91 = Table[RunProtocol["E91",0.05,distance]["QBER"],{distance,distances}];

ListLinePlot[{qberBB84,qberE91}, 
 PlotLegends->{"BB84","E91"},
 AxesLabel->{"Distancia (m)","QBER"},
 PlotMarkers->Automatic,
 PlotTheme->"Detailed"
]

(* Beam Wander visual *)
beamWander = Table[AtmosphericState[1000,10,d,0.02]["BeamWander_Var"],{d,distances}];
ListLinePlot[beamWander, AxesLabel->{"Distancia (m)","BeamWander Variance"}, PlotTheme->"Detailed"]

(* Consumo energético vs velocidad *)
vels = Range[5,25,1];
consumoV = Table[CalculateConsumption[v,True,True],{v,vels}];
ListLinePlot[consumoV, AxesLabel->{"Velocidad (m/s)","Consumo (W)"}, PlotTheme->"Detailed"]
```
