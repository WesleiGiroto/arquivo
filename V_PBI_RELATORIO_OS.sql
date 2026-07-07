
	
	
CREATE OR REPLACE VIEW V_PBI_RELATORIO_OS AS
SELECT
    OS.EMPRESA,
    OS.REVENDA,
    TO_CHAR(OS.EMPRESA) || ' - ' || TO_CHAR(OS.REVENDA)                                        AS CHAVE_EMP_REV,
    TO_CHAR(OS.EMPRESA) || ' - ' || TO_CHAR(OS.REVENDA) || ' - ' || TO_CHAR(OS.NRO_OS)        AS CHAVE_EMP_REV_NRO,
    TO_CHAR(OS.EMPRESA) || ' - ' || TO_CHAR(OS.REVENDA) || ' - ' || TO_CHAR(CAC.CLIENTE)      AS CHAVE_EMP_REV_CLIENTE,

    CAST(OS.DTA_EMISSAO      AS DATE) AS DTA_EMISSAO,
    CAST(OS.DTA_ENCERRAMENTO AS DATE) AS DTA_ENCERRAMENTO,
    CAST(OS.DTA_FIM_EXTERNO  AS DATE) AS DTA_FIM_EXTERNO,
    CAST(OS.DTA_FIM_INTERNO  AS DATE) AS DTA_FIM_INTERNO,
    CAST(OS.DTA_FIM_GARANTIA AS DATE) AS DTA_FIM_GARANTIA,
    CAST(OS.DTA_FIM_REVISAO  AS DATE) AS DTA_FIM_REVISAO,

    OS.NRO_OS,
    OS.SITUACAO_OS,
    OS.SERVICO_EXTERNO,
    OS.SERVICO_INTERNO,
    OS.SERVICO_GARANTIA,
    OS.SERVICO_REVISAO,

    ATE.PLACA,
    ATE.DEPARTAMENTO,
    ATE.MODELO,

    CAC.CLIENTE,
    CLI.NOME,

    CASE
        WHEN CLI.DDD_CELULAR > 99
        THEN CAST(CLI.DDD_CELULAR AS CHAR(3)) || CAST(CLI.CELULAR AS CHAR(10))
        ELSE CAST(CLI.DDD_CELULAR AS CHAR(2)) || CAST(CLI.CELULAR AS CHAR(10))
    END AS CLI_CELULAR,

    OS.CATEGORIA_OS,
    OS.DEPARTAMENTO_DEBITO,
    CAT.DES_CATEGORIA,
    DEP.NOME                                                            AS DES_DEPARTAMENTO,
    MD.DES_MODELO,

    TRIM(
        REGEXP_SUBSTR(VEN.NOME, '^\S+') || ' ' ||
        REGEXP_SUBSTR(VEN.NOME, '\S+$')
    )                                                                   AS NOME_VENDEDOR,


-- ============================================================
-- SUBQUERY - VEICULO (ULTIMO REGISTRO POR CHASSI)
-- ============================================================
    (
        SELECT MAX(VEI.VEICULO)
        FROM   CNP.VEI_VEICULO VEI
        WHERE  VEI.EMPRESA = ATE.EMPRESA
          AND  VEI.CHASSI  = ATE.CHASSI
          AND  VEI.DTA_ENTRADA = (
                    SELECT MAX(DTA_ENTRADA)
                    FROM   CNP.VEI_VEICULO
                    WHERE  EMPRESA = VEI.EMPRESA
                      AND  CHASSI  = VEI.CHASSI
               )
    ) AS VEICULO,


-- ============================================================
-- SUBQUERY - TOTAL DE PECAS
-- ============================================================
    (
        SELECT SUM(
                   (POS.VAL_UNITARIO * POS.QUANTIDADE)
                   - (POS.VAL_DESCONTO - COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0))
               )
        FROM   CNP.OFI_PECA_OS      POS
               JOIN CNP.OFI_TIPO_SERVICO TS
                 ON TS.EMPRESA      = POS.EMPRESA
                AND TS.REVENDA      = POS.REVENDA
                AND TS.TIPO_SERVICO = POS.TIPO_SERVICO
        WHERE  POS.EMPRESA = OS.EMPRESA
          AND  POS.REVENDA = OS.REVENDA
          AND  POS.NRO_OS  = OS.NRO_OS
    ) AS TOT_PECAS,


-- ============================================================
-- SUBQUERY - TOTAL DE SERVICOS (TIPO_REQUISICAO = 1)
-- ============================================================
    (
        SELECT SUM(
                   (SOS.VAL_SERVICO * SOS.QUANTIDADE)
                   - (SOS.VAL_DESCONTO - COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0))
               )
        FROM   CNP.OFI_SERVICO_OS   SOS
               JOIN CNP.OFI_TIPO_SERVICO TS
                 ON TS.EMPRESA      = SOS.EMPRESA
                AND TS.REVENDA      = SOS.REVENDA
                AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO
        WHERE  SOS.EMPRESA         = OS.EMPRESA
          AND  SOS.REVENDA         = OS.REVENDA
          AND  SOS.NRO_OS          = OS.NRO_OS
          AND  SOS.TIPO_REQUISICAO = 1
    ) AS TOT_SERVICOS,


-- ============================================================
-- SUBQUERY - TOTAL VENDIDO / QUANTIDADE (TIPO_REQUISICAO = 1)
-- ============================================================
    (
        SELECT SUM(SOS.QUANTIDADE)
        FROM   CNP.OFI_SERVICO_OS   SOS
               JOIN CNP.OFI_TIPO_SERVICO TS
                 ON TS.EMPRESA      = SOS.EMPRESA
                AND TS.REVENDA      = SOS.REVENDA
                AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO
        WHERE  SOS.EMPRESA         = OS.EMPRESA
          AND  SOS.REVENDA         = OS.REVENDA
          AND  SOS.NRO_OS          = OS.NRO_OS
          AND  SOS.TIPO_REQUISICAO = 1
    ) AS TOT_VENDIDO,


-- ============================================================
-- SUBQUERY - TOTAL GASTO (HORA_REAL)
-- Sem filtro de data: o Power BI filtra pelo periodo desejado
-- ============================================================
    (
        SELECT SUM(CDT.HORA_REAL)
        FROM   CNP.OFI_SERVICO_OS   SOS
               JOIN CNP.OFI_TIPO_SERVICO TS
                 ON TS.EMPRESA      = SOS.EMPRESA
                AND TS.REVENDA      = SOS.REVENDA
                AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO
               JOIN CNP.OFI_CDT CDT
                 ON CDT.EMPRESA        = SOS.EMPRESA
                AND CDT.REVENDA        = SOS.REVENDA
                AND CDT.NRO_OS         = SOS.NRO_OS
                AND CDT.NRO_LANCAMENTO = SOS.NRO_LANCAMENTO
        WHERE  SOS.EMPRESA         = OS.EMPRESA
          AND  SOS.REVENDA         = OS.REVENDA
          AND  SOS.NRO_OS          = OS.NRO_OS
          AND  SOS.TIPO_REQUISICAO = 1
    ) AS TOT_GASTO,


-- ============================================================
-- SUBQUERY - TOTAL TERCEIROS (TIPO_REQUISICAO > 1)
-- ============================================================
    (
        SELECT SUM(
                   (SOS.VAL_SERVICO * SOS.QUANTIDADE)
                   - (SOS.VAL_DESCONTO - COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0))
               )
        FROM   CNP.OFI_SERVICO_OS   SOS
               JOIN CNP.OFI_TIPO_SERVICO TS
                 ON TS.EMPRESA      = SOS.EMPRESA
                AND TS.REVENDA      = SOS.REVENDA
                AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO
        WHERE  SOS.EMPRESA         = OS.EMPRESA
          AND  SOS.REVENDA         = OS.REVENDA
          AND  SOS.NRO_OS          = OS.NRO_OS
          AND  SOS.TIPO_REQUISICAO > 1
    ) AS TOT_TERCEIROS,


-- ============================================================
-- SUBQUERY - TOTAL GERAL (PECAS + TODOS OS SERVICOS)
-- ============================================================
    (
        COALESCE((
            SELECT SUM(
                       (POS.VAL_UNITARIO * POS.QUANTIDADE)
                       - (POS.VAL_DESCONTO - COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0))
                   )
            FROM   CNP.OFI_PECA_OS      POS
                   JOIN CNP.OFI_TIPO_SERVICO TS
                     ON TS.EMPRESA      = POS.EMPRESA
                    AND TS.REVENDA      = POS.REVENDA
                    AND TS.TIPO_SERVICO = POS.TIPO_SERVICO
            WHERE  POS.EMPRESA = OS.EMPRESA
              AND  POS.REVENDA = OS.REVENDA
              AND  POS.NRO_OS  = OS.NRO_OS
        ), 0)
        +
        COALESCE((
            SELECT SUM(
                       (SOS.VAL_SERVICO * SOS.QUANTIDADE)
                       - (SOS.VAL_DESCONTO - COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0))
                   )
            FROM   CNP.OFI_SERVICO_OS   SOS
                   JOIN CNP.OFI_TIPO_SERVICO TS
                     ON TS.EMPRESA      = SOS.EMPRESA
                    AND TS.REVENDA      = SOS.REVENDA
                    AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO
            WHERE  SOS.EMPRESA = OS.EMPRESA
              AND  SOS.REVENDA = OS.REVENDA
              AND  SOS.NRO_OS  = OS.NRO_OS
        ), 0)
    ) AS TOT_GERAL,


-- ============================================================
-- COLUNA CALCULADA - NUMERO DE DIAS
-- SYSDATE para OS abertas | DTA_ENCERRAMENTO para OS fechadas
-- ============================================================
    CASE
        WHEN OS.SITUACAO_OS IN (0, 1)
        THEN TRUNC(SYSDATE) - TRUNC(OS.DTA_EMISSAO)
        ELSE TRUNC(OS.DTA_ENCERRAMENTO) - TRUNC(OS.DTA_EMISSAO)
    END AS NRO_DIAS


-- ============================================================
-- FROM + JOINS
-- ============================================================
FROM
    CNP.OFI_ORDEM_SERVICO OS

    INNER JOIN CNP.OFI_ATENDIMENTO  ATE ON  ATE.EMPRESA  = OS.EMPRESA
                                        AND ATE.REVENDA  = OS.REVENDA
                                        AND ATE.CONTATO  = OS.CONTATO

    INNER JOIN CNP.OFI_CATEGORIA_OS CAT ON  CAT.EMPRESA      = OS.EMPRESA
                                        AND CAT.REVENDA      = OS.REVENDA
                                        AND CAT.CATEGORIA_OS = OS.CATEGORIA_OS

    INNER JOIN CNP.CAC_CONTATO      CAC ON  CAC.EMPRESA = ATE.EMPRESA
                                        AND CAC.REVENDA = ATE.REVENDA
                                        AND CAC.CONTATO = ATE.CONTATO

    INNER JOIN CNP.FAT_CLIENTE      CLI ON  CLI.CLIENTE = CAC.CLIENTE

    INNER JOIN CNP.GER_DEPARTAMENTO DEP ON  DEP.EMPRESA      = ATE.EMPRESA
                                        AND DEP.REVENDA      = ATE.REVENDA
                                        AND DEP.DEPARTAMENTO = ATE.DEPARTAMENTO

    INNER JOIN CNP.VEI_MODELO       MD  ON  MD.EMPRESA = ATE.EMPRESA
                                        AND MD.MODELO  = ATE.MODELO

    INNER JOIN CNP.FAT_VENDEDOR     VEN ON  VEN.EMPRESA  = ATE.EMPRESA
                                        AND VEN.REVENDA  = ATE.REVENDA
                                        AND VEN.VENDEDOR = ATE.VENDEDOR


-- ============================================================
-- WHERE - FILTROS FIXOS DE NEGOCIO
-- Filtros de DATA e PERIODO devem ser aplicados pelo Power BI
-- ============================================================
WHERE
    OS.EMPRESA        IN (1, 2, 3)
    AND OS.REVENDA    IN (1, 2)
    AND ATE.DEPARTAMENTO IN (1, 2, 3)
    AND (
           OS.SERVICO_EXTERNO  IN (0, 1, 8, 9)
        OR OS.SERVICO_INTERNO  IN (0, 1, 8, 9)
        OR OS.SERVICO_GARANTIA IN (0, 1, 8, 9)
        OR OS.SERVICO_REVISAO  IN (0, 1, 8, 9)
    );