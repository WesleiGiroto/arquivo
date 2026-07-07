
-- ============================================================
-- VIEW: V_PBI_VENDAS_DETALHADO
-- Schema: CNP
-- Módulo: BI Oficina — Vendas Detalhado
-- Escopo: Empresas IN (1,2) | Revendas IN (1,2,3)
-- Filtro: Últimos 36 meses a partir de SYSDATE
--
-- COLUNAS PRINCIPAIS
--   EMPRESA / REVENDA        → escopo
--   CHAVE_EMP_REV            → EMPRESA||'-'||REVENDA (join com dimensões)
--   NR_ORDEM                 → 1=SERVIÇO | 2=PEÇA | 3=DEVOLUÇÃO | 5=FRANQUIA
--   TIPO_LINHA               → 'SERVICO' | 'PECA' | 'DEVOLUCAO' | 'FRANQUIA'
--   ORDEM_LINHA              → '1 - SERVIÇOS' | '2 - PEÇAS' | etc. (label da tela)
--   DESCRICAO                → DES_CATEGORIA (serviço) ou DES_GRUPO (peça)
--   TIPO_OS                  → E=EXTERNA | I=INTERNO | R=REVISAO | G=GARANTIA | NULL
--   DTA_REFERENCIA           → data de encerramento do tipo da OS (para filtro PBI)
--   VLR_SERVICO_EXTERNO      → valor de serviço externo faturado
--   VLR_SERVICO_INTERNO      → valor de serviço interno faturado
--   VLR_SERVICO_REVISAO      → valor de serviço de revisão faturado
--   VLR_SERVICO_GARANTIA     → valor de serviço de garantia faturado
--   VLR_PECAS_OS             → peças consumidas em OS (por tipo E/I/R/G)
--   VLR_PECAS_BALCAO         → peças vendidas no balcão (sem OS)
--   VLR_CUSTO_TOTAL          → custo médio das saídas (FAT_MOVIMENTO_ITEM)
--   VALOR_TOTAL              → soma de todos os VLRs (exceto custo)
--
-- NOTA SOBRE TOTALIZADOR NA TELA:
--   TOTAL = VLR_SERVICO_EXTERNO + VLR_SERVICO_INTERNO
--         + VLR_SERVICO_REVISAO + VLR_SERVICO_GARANTIA
--         + VLR_PECAS_OS       + VLR_PECAS_BALCAO
--   VLR_CUSTO_TOTAL não entra no total (coluna informativa)
-- ============================================================

CREATE OR REPLACE VIEW V_PBI_OFVENDAS_DETALHADO AS

-- ============================================================
-- BLOCO 1 — SERVIÇOS
-- Origem : OFI_SERVICO_OS
-- Grupo  : OFI_CATEGORIA_SERVICO.DES_CATEGORIA
-- Linhas : uma por (EMPRESA, REVENDA, DES_CATEGORIA, TIPO_OS, DTA_REFERENCIA)
-- ============================================================

SELECT
    OS.EMPRESA,
    OS.REVENDA,
    OS.EMPRESA || ' - ' || OS.REVENDA                          AS CHAVE_EMP_REV,

    -- ordenação e label da tela
    1                                                        AS NR_ORDEM,
    'SERVICO'                                                AS TIPO_LINHA,
    '1 - SERVIÇOS'                                           AS ORDEM_LINHA,

    CAT.DES_CATEGORIA                                        AS DESCRICAO,
    OTS.TIPO_SERVICO_OS                                      AS TIPO_OS,

    -- data de referência para filtro no Power BI
    CASE OTS.TIPO_SERVICO_OS
        WHEN 'E' THEN OS.DTA_FIM_EXTERNO
        WHEN 'I' THEN OS.DTA_FIM_INTERNO
        WHEN 'R' THEN OS.DTA_FIM_REVISAO
        WHEN 'G' THEN OS.DTA_FIM_GARANTIA
    END                                                      AS DTA_REFERENCIA,

    -- valores de serviço por tipo de OS
    SUM(CASE WHEN OTS.TIPO_SERVICO_OS = 'E'
             THEN CAST((SOS.VAL_SERVICO * SOS.QUANTIDADE) AS NUMERIC(12,2))
                  - COALESCE(SOS.VAL_DESCONTO,    0)
                  - COALESCE(SOS.VAL_ISS_RETIDO,  0)
             ELSE 0 END)                                     AS VLR_SERVICO_EXTERNO,

    SUM(CASE WHEN OTS.TIPO_SERVICO_OS = 'I'
             THEN CAST((SOS.VAL_SERVICO * SOS.QUANTIDADE) AS NUMERIC(12,2))
                  - COALESCE(SOS.VAL_DESCONTO, 0)
             ELSE 0 END)                                     AS VLR_SERVICO_INTERNO,

    SUM(CASE WHEN OTS.TIPO_SERVICO_OS = 'R'
             THEN (SOS.VAL_SERVICO * SOS.QUANTIDADE)
                  - COALESCE(SOS.VAL_DESCONTO, 0)
             ELSE 0 END)                                     AS VLR_SERVICO_REVISAO,

    SUM(CASE WHEN OTS.TIPO_SERVICO_OS = 'G'
             THEN (SOS.VAL_SERVICO * SOS.QUANTIDADE)
                  - COALESCE(SOS.VAL_DESCONTO, 0)
             ELSE 0 END)                                     AS VLR_SERVICO_GARANTIA,

    -- peças e custo não se aplicam a serviços
    0                                                        AS VLR_PECAS_OS,
    0                                                        AS VLR_PECAS_BALCAO,
    0                                                        AS VLR_CUSTO_TOTAL,

    -- total da linha
    SUM(CAST((SOS.VAL_SERVICO * SOS.QUANTIDADE) AS NUMERIC(12,2))
        - COALESCE(SOS.VAL_DESCONTO,   0)
        - CASE WHEN OTS.TIPO_SERVICO_OS = 'E'
               THEN COALESCE(SOS.VAL_ISS_RETIDO, 0)
               ELSE 0
          END)                                               AS VALOR_TOTAL

FROM   CNP.OFI_SERVICO_OS      SOS
INNER  JOIN CNP.OFI_TIPO_SERVICO   OTS  ON  OTS.EMPRESA          = SOS.EMPRESA
                                    AND OTS.REVENDA          = SOS.REVENDA
                                    AND OTS.TIPO_SERVICO     = SOS.TIPO_SERVICO
                                    AND OTS.TIPO_SERVICO_OS  IN ('E','I','R','G')
INNER  JOIN CNP.OFI_SERVICO        SERV ON  SERV.EMPRESA         = SOS.EMPRESA
                                    AND SERV.SERVICO         = SOS.SERVICO
INNER  JOIN CNP.OFI_CATEGORIA_SERVICO CAT
                                    ON  CAT.EMPRESA          = SERV.EMPRESA
                                    AND CAT.CATEGORIA_SERVICO = SERV.CATEGORIA_SERVICO
INNER  JOIN CNP.OFI_ORDEM_SERVICO  OS   ON  OS.EMPRESA           = SOS.EMPRESA
                                    AND OS.REVENDA           = SOS.REVENDA
                                    AND OS.NRO_OS            = SOS.NRO_OS
INNER  JOIN CNP.OFI_ATENDIMENTO    ATE  ON  ATE.EMPRESA          = OS.EMPRESA
                                    AND ATE.REVENDA          = OS.REVENDA
                                    AND ATE.CONTATO          = OS.CONTATO
WHERE  SOS.SITUACAO     = 'N'
AND    OS.SITUACAO_OS   <> 7
AND    OS.EMPRESA       IN (1, 2)
AND    OS.REVENDA       IN (1, 2, 3)
AND    ATE.DEPARTAMENTO IN (3, 4, 5, 6)
AND    (   OS.DTA_FIM_EXTERNO  >= ADD_MONTHS(SYSDATE, -36)
        OR OS.DTA_FIM_INTERNO  >= ADD_MONTHS(SYSDATE, -36)
        OR OS.DTA_FIM_REVISAO  >= ADD_MONTHS(SYSDATE, -36)
        OR OS.DTA_FIM_GARANTIA >= ADD_MONTHS(SYSDATE, -36))
AND    EXISTS (
           SELECT 1
           FROM   CNP.OFI_CATEGORIA_OS
           WHERE  EMPRESA              = OS.EMPRESA
           AND    REVENDA              = OS.REVENDA
           AND    CATEGORIA_OS         = OS.CATEGORIA_OS
           AND    TIPO_INDUSTRIALIZACAO IS NULL
       )
GROUP  BY
    OS.EMPRESA,
    OS.REVENDA,
    OS.EMPRESA || '-' || OS.REVENDA,
    CAT.DES_CATEGORIA,
    OTS.TIPO_SERVICO_OS,
    CASE OTS.TIPO_SERVICO_OS
        WHEN 'E' THEN OS.DTA_FIM_EXTERNO
        WHEN 'I' THEN OS.DTA_FIM_INTERNO
        WHEN 'R' THEN OS.DTA_FIM_REVISAO
        WHEN 'G' THEN OS.DTA_FIM_GARANTIA
    END

UNION ALL

-- ============================================================
-- BLOCO 2 — PEÇAS DE OS
-- Origem : OFI_PECA_OS
-- Grupo  : PEC_GRUPO.DES_GRUPO
-- Linhas : uma por (EMPRESA, REVENDA, DES_GRUPO, TIPO_OS, DTA_REFERENCIA)
-- ============================================================

SELECT
    OS.EMPRESA,
    OS.REVENDA,
    OS.EMPRESA || '-' || OS.REVENDA                          AS CHAVE_EMP_REV,

    2                                                        AS NR_ORDEM,
    'PECA'                                                   AS TIPO_LINHA,
    '2 - PEÇAS'                                              AS ORDEM_LINHA,

    GRP.DES_GRUPO                                            AS DESCRICAO,
    OTS.TIPO_SERVICO_OS                                      AS TIPO_OS,

    CASE OTS.TIPO_SERVICO_OS
        WHEN 'E' THEN OS.DTA_FIM_EXTERNO
        WHEN 'I' THEN OS.DTA_FIM_INTERNO
        WHEN 'R' THEN OS.DTA_FIM_REVISAO
        WHEN 'G' THEN OS.DTA_FIM_GARANTIA
    END                                                      AS DTA_REFERENCIA,

    -- serviço não se aplica a peças
    0                                                        AS VLR_SERVICO_EXTERNO,
    0                                                        AS VLR_SERVICO_INTERNO,
    0                                                        AS VLR_SERVICO_REVISAO,
    0                                                        AS VLR_SERVICO_GARANTIA,

    -- peças por tipo de OS
    SUM(CASE WHEN OTS.TIPO_SERVICO_OS = 'E'
             THEN CAST((OPO.VAL_UNITARIO * OPO.QUANTIDADE) AS NUMERIC(12,2))
                  - COALESCE(OPO.VAL_DESCONTO, 0)
             ELSE 0 END
      + CASE WHEN OTS.TIPO_SERVICO_OS = 'I'
             THEN CAST((OPO.VAL_UNITARIO * OPO.QUANTIDADE) AS NUMERIC(12,2))
                  - COALESCE(OPO.VAL_DESCONTO, 0)
             ELSE 0 END
      + CASE WHEN OTS.TIPO_SERVICO_OS = 'R'
             THEN CAST((OPO.VAL_UNITARIO * OPO.QUANTIDADE) AS NUMERIC(12,2))
                  - COALESCE(OPO.VAL_DESCONTO, 0)
             ELSE 0 END
      + CASE WHEN OTS.TIPO_SERVICO_OS = 'G'
             THEN (OPO.VAL_UNITARIO * OPO.QUANTIDADE)
                  - COALESCE(OPO.VAL_DESCONTO, 0)
             ELSE 0 END)                                     AS VLR_PECAS_OS,

    0                                                        AS VLR_PECAS_BALCAO,
    0                                                        AS VLR_CUSTO_TOTAL,

    -- total = mesma soma acima
    SUM(CAST((OPO.VAL_UNITARIO * OPO.QUANTIDADE) AS NUMERIC(12,2))
        - COALESCE(OPO.VAL_DESCONTO, 0))                     AS VALOR_TOTAL

FROM   CNP.OFI_PECA_OS         OPO
INNER  JOIN CNP.OFI_TIPO_SERVICO   OTS  ON  OTS.EMPRESA         = OPO.EMPRESA
                                    AND OTS.REVENDA         = OPO.REVENDA
                                    AND OTS.TIPO_SERVICO    = OPO.TIPO_SERVICO
                                    AND OTS.TIPO_SERVICO_OS IN ('E','I','R','G')
INNER  JOIN CNP.PEC_ITEM_ESTOQUE   IE   ON  IE.EMPRESA          = OPO.EMPRESA
                                    AND IE.ITEM_ESTOQUE     = OPO.ITEM_ESTOQUE
INNER  JOIN CNP.PEC_GRUPO          GRP  ON  GRP.MARCA           = IE.MARCA
                                    AND GRP.GRUPO           = IE.GRUPO
INNER  JOIN CNP.OFI_ORDEM_SERVICO  OS   ON  OS.EMPRESA          = OPO.EMPRESA
                                    AND OS.REVENDA          = OPO.REVENDA
                                    AND OS.NRO_OS           = OPO.NRO_OS
INNER  JOIN CNP.OFI_ATENDIMENTO    ATE  ON  ATE.EMPRESA         = OS.EMPRESA
                                    AND ATE.REVENDA         = OS.REVENDA
                                    AND ATE.CONTATO         = OS.CONTATO
WHERE  OPO.SITUACAO     = 'N'
AND    OS.SITUACAO_OS   <> 7
AND    OS.EMPRESA       IN (1, 2)
AND    OS.REVENDA       IN (1, 2, 3)
AND    ATE.DEPARTAMENTO IN (3, 4, 5, 6)
AND    (   OS.DTA_FIM_EXTERNO  >= ADD_MONTHS(SYSDATE, -36)
        OR OS.DTA_FIM_INTERNO  >= ADD_MONTHS(SYSDATE, -36)
        OR OS.DTA_FIM_REVISAO  >= ADD_MONTHS(SYSDATE, -36)
        OR OS.DTA_FIM_GARANTIA >= ADD_MONTHS(SYSDATE, -36))
AND    EXISTS (
           SELECT 1
           FROM   CNP.OFI_CATEGORIA_OS
           WHERE  EMPRESA              = OS.EMPRESA
           AND    REVENDA              = OS.REVENDA
           AND    CATEGORIA_OS         = OS.CATEGORIA_OS
           AND    TIPO_INDUSTRIALIZACAO IS NULL
       )
GROUP  BY
    OS.EMPRESA,
    OS.REVENDA,
    OS.EMPRESA || '-' || OS.REVENDA,
    GRP.DES_GRUPO,
    OTS.TIPO_SERVICO_OS,
    CASE OTS.TIPO_SERVICO_OS
        WHEN 'E' THEN OS.DTA_FIM_EXTERNO
        WHEN 'I' THEN OS.DTA_FIM_INTERNO
        WHEN 'R' THEN OS.DTA_FIM_REVISAO
        WHEN 'G' THEN OS.DTA_FIM_GARANTIA
    END

UNION ALL

-- ============================================================
-- BLOCO 3 — PEÇAS BALCÃO (sem OS vinculada)
-- Origem : FAT_MOVIMENTO_CAPA / FAT_MOVIMENTO_ITEM
-- Filtro : COALESCE(NRO_OS,0) = 0 + TIPO='S' + SUBTIPO IN ('N','I')
-- Grupo  : PEC_GRUPO.DES_GRUPO
-- DTA_REFERENCIA = FMC.DTA_ENTRADA_SAIDA
-- ============================================================

SELECT
    FMC.EMPRESA,
    FMC.REVENDA,
    FMC.EMPRESA || '-' || FMC.REVENDA                        AS CHAVE_EMP_REV,

    2                                                        AS NR_ORDEM,
    'PECA'                                                   AS TIPO_LINHA,
    '2 - PEÇAS'                                              AS ORDEM_LINHA,

    MAX(
	(SELECT DES_GRUPO
         FROM   CNP.PEC_GRUPO
         WHERE  MARCA = PIE.MARCA
         AND    GRUPO = PIE.GRUPO))                          AS DESCRICAO,

    'BALCAO'                                                 AS TIPO_OS,
    FMC.DTA_ENTRADA_SAIDA                                    AS DTA_REFERENCIA,

    0                                                        AS VLR_SERVICO_EXTERNO,
    0                                                        AS VLR_SERVICO_INTERNO,
    0                                                        AS VLR_SERVICO_REVISAO,
    0                                                        AS VLR_SERVICO_GARANTIA,
    0                                                        AS VLR_PECAS_OS,

    SUM(FMI.VAL_TOTAL_REAL_ITEM
        - COALESCE(FMI.VAL_DESCONTO, 0))                     AS VLR_PECAS_BALCAO,

    0                                                        AS VLR_CUSTO_TOTAL,

    SUM(FMI.VAL_TOTAL_REAL_ITEM
        - COALESCE(FMI.VAL_DESCONTO, 0))                     AS VALOR_TOTAL

FROM   CNP.FAT_MOVIMENTO_ITEM    FMI

INNER  JOIN CNP.FAT_MOVIMENTO_CAPA   FMC 
								     ON  FMC.EMPRESA            = FMI.EMPRESA
                                     AND FMC.REVENDA            = FMI.REVENDA
                                     AND FMC.NUMERO_NOTA_FISCAL = FMI.NUMERO_NOTA_FISCAL
                                     AND FMC.SERIE_NOTA_FISCAL  = FMI.SERIE_NOTA_FISCAL
                                     AND FMC.TIPO_TRANSACAO     = FMI.TIPO_TRANSACAO
                                     AND FMC.CONTADOR           = FMI.CONTADOR 
									 
INNER  JOIN CNP.PEC_ITEM_ESTOQUE     PIE 
								     ON  PIE.EMPRESA            = FMI.EMPRESA
                                     AND PIE.ITEM_ESTOQUE       = FMI.ITEM_ESTOQUE
									 
INNER  JOIN CNP.FAT_TIPO_TRANSACAO    TT  
									ON  TT.TIPO_TRANSACAO      = FMC.TIPO_TRANSACAO
									
INNER  JOIN CNP.GER_DEPARTAMENTO     DPT 
								     ON  DPT.EMPRESA            = FMC.EMPRESA
                                     AND DPT.REVENDA            = FMC.REVENDA
                                     AND DPT.DEPARTAMENTO       = FMC.DEPARTAMENTO
WHERE  COALESCE(FMC.NRO_OS, 0)  = 0
AND    FMC.STATUS                = 'F'
AND    TT.TIPO                   = 'S'
AND    TT.SUBTIPO_TRANSACAO      IN ('N', 'I')
AND    PIE.TIPO_INDUSTRIALIZACAO IS NULL
AND    FMC.EMPRESA               IN (1, 2)
AND    FMC.REVENDA               IN (1, 2, 3)
AND    DPT.DEPARTAMENTO          IN (3, 4, 5, 6)
AND    FMC.DTA_ENTRADA_SAIDA     >= ADD_MONTHS(SYSDATE, -36)
GROUP  BY
    FMC.EMPRESA,
    FMC.REVENDA,
    FMC.EMPRESA || '-' || FMC.REVENDA,
    PIE.GRUPO,
    FMC.DTA_ENTRADA_SAIDA

UNION ALL

-- ============================================================
-- BLOCO 4 — CUSTO TOTAL DAS PEÇAS
-- Origem : FAT_MOVIMENTO_ITEM.VAL_CUSTO_MEDIO
-- Filtro : IDENTIFICACAO IN ('O','B','T') + TIPO='S' + SUBTIPO IN ('N','I')
-- Grupo  : PEC_GRUPO.DES_GRUPO
-- DTA_REFERENCIA = FMC.DTA_ENTRADA_SAIDA
-- ============================================================

SELECT
    FMC.EMPRESA,
    FMC.REVENDA,
    FMC.EMPRESA || '-' || FMC.REVENDA                        AS CHAVE_EMP_REV,

    2                                                        AS NR_ORDEM,
    'PECA'                                                   AS TIPO_LINHA,
    '2 - PEÇAS'                                              AS ORDEM_LINHA,

    PGR.DES_GRUPO                                            AS DESCRICAO,
    'CUSTO'                                                  AS TIPO_OS,
    FMC.DTA_ENTRADA_SAIDA                                    AS DTA_REFERENCIA,

    0                                                        AS VLR_SERVICO_EXTERNO,
    0                                                        AS VLR_SERVICO_INTERNO,
    0                                                        AS VLR_SERVICO_REVISAO,
    0                                                        AS VLR_SERVICO_GARANTIA,
    0                                                        AS VLR_PECAS_OS,
    0                                                        AS VLR_PECAS_BALCAO,

    SUM(FMI.VAL_CUSTO_MEDIO)                                 AS VLR_CUSTO_TOTAL,

    -- custo não entra no VALOR_TOTAL
    0                                                        AS VALOR_TOTAL

FROM   CNP.FAT_MOVIMENTO_CAPA    FMC
INNER  JOIN CNP.FAT_MOVIMENTO_ITEM   FMI ON  FMI.EMPRESA            = FMC.EMPRESA
                                     AND FMI.REVENDA            = FMC.REVENDA
                                     AND FMI.NUMERO_NOTA_FISCAL = FMC.NUMERO_NOTA_FISCAL
                                     AND FMI.SERIE_NOTA_FISCAL  = FMC.SERIE_NOTA_FISCAL
                                     AND FMI.TIPO_TRANSACAO     = FMC.TIPO_TRANSACAO
                                     AND FMI.CONTADOR           = FMC.CONTADOR
									 
INNER  JOIN CNP.PEC_ITEM_ESTOQUE     PIE 
								     ON  PIE.EMPRESA            = FMI.EMPRESA
                                     AND PIE.ITEM_ESTOQUE       = FMI.ITEM_ESTOQUE
									 
INNER  JOIN CNP.PEC_GRUPO            PGR 
									 ON  PGR.MARCA              = PIE.MARCA
                                     AND PGR.GRUPO              = PIE.GRUPO
									 
INNER  JOIN CNP.FAT_TIPO_TRANSACAO    TT 
									ON  TT.TIPO_TRANSACAO      = FMC.TIPO_TRANSACAO
									
INNER  JOIN CNP.GER_DEPARTAMENTO     DPT 
								     ON  DPT.EMPRESA            = FMC.EMPRESA
                                     AND DPT.REVENDA            = FMC.REVENDA
                                     AND DPT.DEPARTAMENTO       = FMC.DEPARTAMENTO
WHERE  DPT.IDENTIFICACAO         IN ('O', 'B', 'T')
AND    FMC.TIPO_INDUSTRIALIZACAO IS NULL
AND    FMC.STATUS                = 'F'
AND    TT.TIPO                   = 'S'
AND    TT.SUBTIPO_TRANSACAO      IN ('N', 'I')
AND    FMC.EMPRESA               IN (1, 2)
AND    FMC.REVENDA               IN (1, 2, 3)
AND    DPT.DEPARTAMENTO          IN (3, 4, 5, 6)
AND    FMC.DTA_ENTRADA_SAIDA     >= ADD_MONTHS(SYSDATE, -36)
GROUP  BY
    FMC.EMPRESA,
    FMC.REVENDA,
    FMC.EMPRESA || '-' || FMC.REVENDA,
    PGR.DES_GRUPO,
    FMC.DTA_ENTRADA_SAIDA

UNION ALL

-- ============================================================
-- BLOCO 5 — DEVOLUÇÕES DE PEÇAS (−)
-- Origem : FAT_MOVIMENTO_CAPA TIPO='E' / SUBTIPO='D'
--          referenciando saída COM NRO_OS (oficina)
-- Valores: negativos em VLR_PECAS_BALCAO e VLR_CUSTO_TOTAL
-- DTA_REFERENCIA = FMC.DTA_ENTRADA_SAIDA
-- ============================================================

SELECT
    FMC.EMPRESA,
    FMC.REVENDA,
    FMC.EMPRESA || '-' || FMC.REVENDA                        AS CHAVE_EMP_REV,

    3                                                        AS NR_ORDEM,
    'DEVOLUCAO'                                              AS TIPO_LINHA,
    '3 - DEVOL. DE PEÇAS'                                    AS ORDEM_LINHA,

    'DEVOLUÇÕES DE PEÇAS (-)'                                AS DESCRICAO,
    NULL                                                     AS TIPO_OS,
    FMC.DTA_ENTRADA_SAIDA                                    AS DTA_REFERENCIA,

    0                                                        AS VLR_SERVICO_EXTERNO,
    0                                                        AS VLR_SERVICO_INTERNO,
    0                                                        AS VLR_SERVICO_REVISAO,
    0                                                        AS VLR_SERVICO_GARANTIA,
    0                                                        AS VLR_PECAS_OS,

    -- negativo: reduz o total de peças
    -1 * COALESCE(SUM(FMI.VAL_TOTAL_REAL_ITEM
                      - COALESCE(FMI.VAL_DESCONTO, 0)
                      + COALESCE(FMI.VAL_FRETE,    0)), 0)   AS VLR_PECAS_BALCAO,

    -1 * COALESCE(SUM(FMI.VAL_CUSTO_MEDIO), 0)               AS VLR_CUSTO_TOTAL,

    -1 * COALESCE(SUM(FMI.VAL_TOTAL_REAL_ITEM
                      - COALESCE(FMI.VAL_DESCONTO, 0)
                      + COALESCE(FMI.VAL_FRETE,    0)), 0)   AS VALOR_TOTAL

FROM   CNP.FAT_MOVIMENTO_ITEM    FMI

INNER  JOIN CNP.FAT_MOVIMENTO_CAPA   FMC ON  FMC.EMPRESA            = FMI.EMPRESA
                                     AND FMC.REVENDA            = FMI.REVENDA
                                     AND FMC.NUMERO_NOTA_FISCAL = FMI.NUMERO_NOTA_FISCAL
                                     AND FMC.SERIE_NOTA_FISCAL  = FMI.SERIE_NOTA_FISCAL
                                     AND FMC.TIPO_TRANSACAO     = FMI.TIPO_TRANSACAO
                                     AND FMC.CONTADOR           = FMI.CONTADOR
									 
INNER  JOIN CNP.FAT_TIPO_TRANSACAO    TT 
								     ON  TT.TIPO_TRANSACAO      = FMC.TIPO_TRANSACAO
									 
INNER  JOIN CNP.GER_DEPARTAMENTO     DPT 
								     ON  DPT.EMPRESA            = FMC.EMPRESA
                                     AND DPT.REVENDA            = FMC.REVENDA
                                     AND DPT.DEPARTAMENTO       = FMC.DEPARTAMENTO
WHERE  FMC.STATUS                = 'F'
AND    TT.TIPO                   = 'E'
AND    TT.SUBTIPO_TRANSACAO      = 'D'
AND    DPT.IDENTIFICACAO         = 'O'
AND    COALESCE(FMC.FATOPERACAO_ORIGINAL, 0) > 0
AND    FMC.EMPRESA               IN (1, 2)
AND    FMC.REVENDA               IN (1, 2, 3)
AND    DPT.DEPARTAMENTO          IN (3, 4, 5, 6)
AND    FMC.DTA_ENTRADA_SAIDA     >= ADD_MONTHS(SYSDATE, -36)
AND    EXISTS (
           SELECT 1
           FROM   CNP.FAT_MOVIMENTO_CAPA  FMCV
		   
           INNER  JOIN CNP.FAT_TIPO_TRANSACAO TTV  ON  TTV.TIPO_TRANSACAO   = FMCV.TIPO_TRANSACAO
		   
           INNER  JOIN CNP.GER_DEPARTAMENTO  DPTV  ON  DPTV.EMPRESA         = FMCV.EMPRESA
                                              AND  DPTV.REVENDA         = FMCV.REVENDA
                                              AND  DPTV.DEPARTAMENTO    = FMCV.DEPARTAMENTO
           WHERE  FMCV.EMPRESA             = FMC.EMPRESA
           AND    FMCV.REVENDA             = FMC.REVENDA
           AND    FMCV.FATOPERACAO         = FMC.FATOPERACAO_ORIGINAL
           AND    FMCV.STATUS              = 'F'
           AND    TTV.TIPO                 = 'S'
           AND    TTV.SUBTIPO_TRANSACAO    IN ('N', 'I')
           AND    DPTV.IDENTIFICACAO       = 'O'
           AND    COALESCE(FMCV.NRO_OS, 0) > 0
       )
GROUP  BY
    FMC.EMPRESA,
    FMC.REVENDA,
    FMC.EMPRESA || '-' || FMC.REVENDA,
    FMC.DTA_ENTRADA_SAIDA

UNION ALL

-- ============================================================
-- BLOCO 6 — FRANQUIA
-- Origem : OFI_ORDEM_SERVICO onde SITUACAO_FRANQUIA = 9
-- Valor  : VAL_FRANQUIA - DESCONTO_FRANQUIA → VLR_CUSTO_TOTAL
-- DTA_REFERENCIA = OS.DTA_FIM_FRANQUIA
-- ============================================================

SELECT
    OS.EMPRESA,
    OS.REVENDA,
    OS.EMPRESA || '-' || OS.REVENDA                          AS CHAVE_EMP_REV,

    5                                                        AS NR_ORDEM,
    'FRANQUIA'                                               AS TIPO_LINHA,
    '5 - FRANQUIA'                                           AS ORDEM_LINHA,

    'FRANQUIA'                                               AS DESCRICAO,
    NULL                                                     AS TIPO_OS,
    OS.DTA_FIM_FRANQUIA                                      AS DTA_REFERENCIA,

    0                                                        AS VLR_SERVICO_EXTERNO,
    0                                                        AS VLR_SERVICO_INTERNO,
    0                                                        AS VLR_SERVICO_REVISAO,
    0                                                        AS VLR_SERVICO_GARANTIA,
    0                                                        AS VLR_PECAS_OS,
    0                                                        AS VLR_PECAS_BALCAO,

    SUM(COALESCE(OS.VAL_FRANQUIA,      0)
        - COALESCE(OS.DESCONTO_FRANQUIA, 0))                 AS VLR_CUSTO_TOTAL,

    -- franquia não compõe o VALOR_TOTAL da tela
    0                                                        AS VALOR_TOTAL

FROM   CNP.OFI_ORDEM_SERVICO OS
INNER  JOIN CNP.OFI_ATENDIMENTO ATE 
								ON  ATE.EMPRESA = OS.EMPRESA
                                AND ATE.REVENDA  = OS.REVENDA
                                AND ATE.CONTATO  = OS.CONTATO
WHERE  OS.SITUACAO_FRANQUIA  = 9
AND    OS.EMPRESA            IN (1, 2)
AND    OS.REVENDA            IN (1, 2, 3)
AND    ATE.DEPARTAMENTO      IN (3, 4, 5, 6)
AND    OS.DTA_FIM_FRANQUIA   >= ADD_MONTHS(SYSDATE, -36)
GROUP  BY
    OS.EMPRESA,
    OS.REVENDA,
    OS.EMPRESA || '-' || OS.REVENDA,
    OS.DTA_FIM_FRANQUIA;

-- ============================================================
-- GRANT DE LEITURA (ajustar conforme usuário do Power BI)
-- ============================================================
-- GRANT SELECT ON CNP.V_PBI_VENDAS_DETALHADO TO <usuario_pbi>;