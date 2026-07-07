SELECT
        OFS.EMPRESA           ,
        OFS.CHASSI            ,
        OFS.IDENTIFICACAO     ,
        OFS.PLACA             ,
        OFS.PLACA_ANTERIOR    ,
        VF.MARCA              ,
        OFS.MODELO            ,
        OFS.ANO_FABRICACAO    ,
        OFS.ANO_MODELO        ,
        OFS.VEICULO_TEST_DRIVE,
        OFS.DTA_PRIMEIRA_VENDA,
        VC.DES_COR            ,
        (
                SELECT DISTINCT
                        'S'
                FROM
                        CNP.OFI_CONTRATO_CHASSI     OCC,
                        CNP.OFI_CONTRATO_MANUTENCAO OCM
                WHERE
                        OCC.EMPRESA     = OCM.EMPRESA
                AND     OCC.REVENDA     = OCM.REVENDA
                AND     OCC.CONTRATO    = OCM.CONTRATO
                AND     OCC.CHASSI      = OFS.CHASSI
                AND     OCM.DTA_INICIAL <= TO_DATE('04/07/2026','DD/MM/YYYY')
                AND     (
                                OCM.DTA_FINAL IS NULL
                                OR OCM.DTA_FINAL >= TO_DATE('04/07/2026','DD/MM/YYYY'))) CONTRATO
FROM
        CNP.OFI_FICHA_SEGUIMENTO OFS
INNER JOIN
        CNP.VEI_MODELO VM
ON
        VM.MODELO  = OFS.MODELO
AND     VM.EMPRESA = OFS.EMPRESA
INNER JOIN
        CNP.VEI_COR VC
ON
        VC.COR     = OFS.COR
AND     VC.EMPRESA = OFS.EMPRESA
INNER JOIN
        CNP.VEI_FAMILIA VF
ON
        VF.FAMILIA = VM.FAMILIA
AND     VF.EMPRESA = VM.EMPRESA
WHERE
        OFS.PLACA = 'UGM1J18'
AND     (
                OFS.EXCLUIDO = 'N'
                OR OFS.EXCLUIDO IS NULL)
ORDER BY
        OFS.CHASSI