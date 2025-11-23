TestReport[{
    VerificationTest[
        QDMesh`Power`CalculateConsumption[10, True, True] > 0,
        True
    ],

    VerificationTest[
        KeyExistsQ[
            QDMesh`Crypto`RunProtocol["BB84", 0.1, 1000],
            "FinalKey"
        ],
        True
    ]
}]
