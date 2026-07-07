CREATE OR REPLACE VIEW V_PBI_FATO_VENDAS
AS
SELECT

    /* ============================= */
    /* CHAVES BI */
    /* ============================= */
    FMC.EMPRESA || '-' || FMC.REVENDA                         AS CHAVE_EMP_REV,
    FMC.EMPRESA || '-' || FMC.REVENDA || '-' || FMC.CONTATO AS CHAVE_EMP_REV_CONTATO,

    /* ============================= */
    /* EMPRESA / REVENDA */
    /* ============================= */
    FMC.EMPRESA   AS EMP_EMPRESA_ID,
    FMC.REVENDA  AS REV_REVENDA_ID,

    /* ============================= */
    /* NOTA FISCAL */
    /* ============================= */
    FMC.NUMERO_NOTA_FISCAL AS NF_NUMERO,
    FMC.SERIE_NOTA_FISCAL AS NF_SERIE,

    /* ============================= */
    /* TRANSAÇÃO */
    /* ============================= */
    FMC.TIPO_TRANSACAO,
    FTT.DES_TIPO_TRANSACAO     AS DESCRICAO,
    FMC.STATUS,

    /* ============================= */
    /* USUÁRIO / VENDEDOR */
    /* ============================= */
    FMC.USUARIO AS USR_ID,
    USU.NOME    AS VENDEDOR,

    /* ============================= */
    /* DATAS */
    /* ============================= */
    TRUNC(FMC.DTA_ENTRADA_SAIDA) AS DTA_ENTRADA_SAIDA,

    /* ============================= */
    /* MÉTRICAS */
    /* ============================= */
    1 AS QTD_VENDA

FROM CNP.FAT_MOVIMENTO_CAPA FMC

INNER JOIN CNP.GER_USUARIO USU
    ON USU.USUARIO = FMC.USUARIO

INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT
    ON FTT.TIPO_TRANSACAO = FMC.TIPO_TRANSACAO

/* ============================= */
/* FILTROS BI / PERFORMANCE */
/* ============================= */
WHERE FMC.TIPO_TRANSACAO IN ('V21','U21')
  AND FMC.STATUS = 'F'
  AND FMC.DTA_ENTRADA_SAIDA >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -60);
