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

## 🔹 Módulos y Documentación Detallada

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

**Ejemplo:**

```wolfram
Needs["QDMesh`Core`"];
$Wavelength
$Aperture
```

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

* `ThermalJitter[baseJitter_, temp_, wind_]`
  Calcula jitter térmico inducido por cambios de temperatura y viento.

```wolfram
ThermalJitter[0.001, 30, 5]
```

</details>

<details>
<summary>3. Power</summary>

**Archivo:** `QDMesh/Power.wl`

Calcula el consumo energético del dron considerando vuelo, transmisión y cómputo.

**Funciones principales:**

* `CalculateConsumption[velocity_, isTransmitting_, isComputing_]`
  Retorna el consumo total en watts, combinando energía para hover, drag, avionics, láser y CPU.

```wolfram
CalculateConsumption[10, True, True]
```

</details>

<details>
<summary>4. Crypto</summary>

**Archivo:** `QDMesh/Crypto.wl`

Implementa simulación de protocolos QKD y firmas post-cuánticas.

**Funciones principales:**

* `RunProtocol[type_, loss_, nPhotons_]`
  Simula **BB84** o **E91** con pérdida de fotones y retorna:

  * `RawBits` – bits obtenidos después de sift
  * `FinalKey` – longitud de clave final segura
  * `QBER` – tasa de error cuántico

```wolfram
RunProtocol["BB84", 0.05, 10000]
```

* `SignPQC[message_]`
  Genera firma post-cuántica usando Dilithium3.

```wolfram
SignPQC["Mensaje secreto"]
```

</details>

<details>
<summary>5. Swarm</summary>

**Archivo:** `QDMesh/Swarm.wl`

Proporciona herramientas para inteligencia de enjambre y detección de amenazas.

**Funciones principales:**

* `CooperativeFusion[data_List]`
  Fusión de información de múltiples drones (consenso sobre QBER y viento).

* `PredictThreat[qber_, reputation_]`
  Clasifica amenazas basado en QBER y reputación de nodo.

```wolfram
data = {<|"QBER"->0.0225,"Wind"->5|>,<|"QBER"->0.025,"Wind"->6|>};
CooperativeFusion[data]
PredictThreat[0.025,0.9]
```

</details>

<details>
<summary>6. KMS</summary>

**Archivo:** `QDMesh/KMS.wl`

Sistema de gestión de claves con verificación cuántica.

**Funciones principales:**

* `StoreKey[keyBits_, protocol_, sourceID_]`
  Almacena la clave con metadatos como ID, hash, protocolo, origen y expiración.

```wolfram
StoreKey[3275, "BB84", "Drone001"]
```

</details>

---

## 🚀 Ejemplo completo de prueba

```wolfram
(* ===================== *)
(*  Ejemplo de uso QDMesh *)
(* ===================== *)

(* 1. Cargar módulos del paclet *)
Needs["QDMesh`Core`"];
Needs["QDMesh`Physics`"];
Needs["QDMesh`Power`"];
Needs["QDMesh`Crypto`"];
Needs["QDMesh`Swarm`"];
Needs["QDMesh`KMS`"];

(* ===================== *)
(* Parámetros básicos del dron *)
Print["--- Parámetros del Drone ---"];
Print["Longitud de onda (m): ", $Wavelength];
Print["Apertura óptica (m): ", $Aperture];
Print["Masa (kg): ", $DroneMass];
Print["Capacidad batería (J): ", $BatteryCapacity];

(* ===================== *)
(* 2. Simular estado atmosférico *)
altitude = 1000;        (* Altura en metros *)
wind = 10;              (* Velocidad de viento m/s *)
distance = 500;         (* Distancia del enlace en metros *)
tempGradient = 0.02;    (* Gradiente térmico *)

atm = AtmosphericState[altitude, wind, distance, tempGradient];
Print["Estado Atmosférico: ", atm];

(* ===================== *)
(* 3. Calcular consumo energético *)
velocity = 15;          (* m/s *)
isTransmitting = True;
isComputing = True;

consumo = CalculateConsumption[velocity, isTransmitting, isComputing];
Print["Consumo total: ", consumo, " W"];

(* ===================== *)
(* 4. Ejecutar protocolo QKD *)
nPhotons = 10000;
qkdBB84 = RunProtocol["BB84", 0.05, nPhotons];
qkdE91 = RunProtocol["E91", 0.05, nPhotons];

Print["Resultado BB84: ", qkdBB84];
Print["Resultado E91: ", qkdE91];

(* ===================== *)
(* 5. Fusión de drones (Swarm) *)
(* Agregamos valores de viento a los datos para evitar KeyAbsent *)
fusion = CooperativeFusion[
    {
        Append[qkdBB84, "Wind" -> wind],
        Append[qkdE91, "Wind" -> (wind + 2)]
    }
];
Print["Fusión de drones: ", fusion];

(* ===================== *)
(* 6. Predicción de amenazas *)
reputation = 0.9;  (* confianza del nodo *)
amenaza = PredictThreat[qkdBB84["QBER"], reputation];
Print["Amenaza detectada: ", amenaza];

(* ===================== *)
(* 7. Generar y almacenar clave con KMS *)
keyMetadata = StoreKey[qkdBB84["FinalKey"], "BB84", "Drone001"];
Print["Metadatos de clave: ", keyMetadata];

```

---

## 🔧 Requisitos

* Wolfram Language 14+
* QuantumFramework (opcional para simulaciones cuánticas)
* Conexión a Internet para instalación desde GitHub/Wolfram Cloud

---

## 📄 Licencia

MIT License – Alan Daleth Hernandez Barreto

---
