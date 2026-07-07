
SELECT
        SUM (
                CASE
                WHEN
                        VR.TIPO_RETORNO IN ('3',
                                            '9')
                THEN
                        VR.VAL_RETORNO
                END)             VLR_FI            ,
        CAST(0 AS NUMERIC)       FI_1              ,
        CAST(0 AS NUMERIC)       FI_2              ,
        SUM (CAST(0 AS NUMERIC)) VAL_FINANCIADO    ,
        SUM (CAST(0 AS NUMERIC)) VAL_PRESENTE_VENDA,
        VP.PROPOSTA                                ,
        VEN.NOME                 VENDEDOR          ,
        CLI.NOME                 CLIENTE           ,
        FIN.NOME                 FINANCEIRA        ,
        FIN.CLIENTE              CODFINANCEIRA     ,
        NEG.QTD_PARCELAS                           ,
        NEG.NEGOCIACAO                             ,
        NEG.FATOR_PARCELA                          ,
        VEI.VEICULO                                ,
        VR.VAL_COMISSAO
FROM
        CAC_CONTATO CAC
INNER JOIN
        VEI_PROPOSTA VP
ON
        (
                VP.EMPRESA     = CAC.EMPRESA
                AND VP.REVENDA = CAC.REVENDA
                AND VP.CONTATO = CAC.CONTATO)
INNER JOIN
        VEI_RETORNO VR
ON
        (
                VR.EMPRESA      = VP.EMPRESA
                AND VR.REVENDA  = VP.REVENDA
                AND VR.PROPOSTA = VP.PROPOSTA)
INNER JOIN
        FAT_VENDEDOR VEN
ON
        (
                VP.EMPRESA      = VEN.EMPRESA
                AND VP.REVENDA  = VEN.REVENDA
                AND VP.VENDEDOR = VEN.VENDEDOR)
INNER JOIN
        VEI_NEGOCIACAO NEG
ON
        (
                VP.EMPRESA              = NEG.EMPRESA
                AND VP.REVENDA          = NEG.REVENDA
                AND VP.PROPOSTA         = NEG.PROPOSTA
                AND VP.NEGOCIACAO_FINAL = NEG.NEGOCIACAO)
LEFT OUTER JOIN
        VEI_VEICULO VEI
ON
        (
                VP.EMPRESA     = VEI.EMPRESA
                AND VP.VEICULO = VEI.VEICULO)
LEFT OUTER JOIN
        FAT_CLIENTE CLI
ON
        (
                CAC.CLIENTE = CLI.CLIENTE)
LEFT OUTER JOIN
        FAT_CLIENTE FIN
ON
        (
                VR.CLIENTE = FIN.CLIENTE)
WHERE
        VP.SITUACAO IN ('7',
                        '9')
AND     (
                (
                        VP.TIPO_VENDA IN ('N',
                                          'F')
                        AND VEI.DTA_VENDA BETWEEN TO_DATE('01/10/2025 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('31/12/2025 23:59:59','DD/MM/YYYY HH24:MI:SS'))
                OR (
                        VP.TIPO_VENDA IN ('D',
                                          'F')
                        AND VEI.DTA_NOTIFICACAO_CREDITO BETWEEN TO_DATE('01/10/2025 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('31/12/2025 23:59:59','DD/MM/YYYY HH24:MI:SS')) )
AND     VR.TIPO_RETORNO IN ('3',
                            '9')
AND     (
                (
                        (
                                VP.EMPRESA = 1
                                AND VP.REVENDA IN (1,2))))
GROUP BY
        VP.PROPOSTA           ,
        VEN.NOME              ,
        CLI.NOME              ,
        FIN.NOME              ,
        FIN.CLIENTE           ,
        NEG.QTD_PARCELAS      ,
        NEG.VAL_FINANCIADO    ,
        NEG.NEGOCIACAO        ,
        NEG.FATOR_PARCELA     ,
        VEI.VAL_PRESENTE_VENDA,
        VEI.VEICULO           ,
        VR.VAL_COMISSAO
ORDER BY
        VP.PROPOSTA