CREATE OR REPLACE VIEW V_PBI_FATO_FATURAMENTO AS
SELECT
    /* ============================= */
    /* EMPRESA / REVENDA */
    /* ============================= */
    FMC.EMPRESA,
    FMC.REVENDA,
    /* ============================= */
    /* CHAVES BI */
    /* ============================= */
    FMC.EMPRESA || ' - ' || FMC.REVENDA                         AS CHAVE_EMP_REV,
    FMC.EMPRESA || ' - ' || FMC.REVENDA || ' - ' || FMV.VEICULO AS CHAVE_EMP_REV_VEICULO,
    FMC.EMPRESA || ' - ' || FMC.REVENDA || ' - ' || FMC.CONTATO AS CHAVE_EMP_REV_CONTATO,
    
    /* ============================= */
    /* TRANSAÇÃO */
    /* ============================= */
    FMC.TIPO_TRANSACAO,
    FTT.DES_TIPO_TRANSACAO     AS DESCRICAO,
    FMC.STATUS,
    /* ============================= */
    /* VEÍCULO */
    /* ============================= */
    FMV.VEICULO,
    VEI.MODELO,
    VEI.CHASSI,
    CAST(
       CASE
         WHEN VEI.NOVO_USADO = 'N' THEN 'NOVOS'
         WHEN VEI.NOVO_USADO = 'U' THEN 'USADOS'
           ELSE TO_CHAR(VEI.NOVO_USADO)
            END
      AS VARCHAR2(30))AS DEPARTAMENTO,   
    
    
    MD.DES_MODELO,      -- ? NOVO: vindo do JOIN com VEI_MODELO
    VF.MARCA,           -- ? NOVO: vindo do JOIN com VEI_FAMILIA
    VF.DES_FAMILIA,     -- ? NOVO: vindo do JOIN com VEI_FAMILIA
    /* ============================= */
    /* USUÁRIO / VENDEDOR */
    /* ============================= */
    FMC.USUARIO AS USR_ID,
    --USU.NOME    AS VENDEDOR,
    TRIM(
          REGEXP_SUBSTR(USU.NOME, '^\S+') || ' ' ||
          REGEXP_SUBSTR(USU.NOME, '\S+$')
          ) AS VENDEDOR,
    /* ============================= */
    /* DATAS */
    /* ============================= */
    TRUNC(FMC.DTA_ENTRADA_SAIDA) AS DTA_ENTRADA_SAIDA,
    VEI.DTA_VENDA,
    /* ============================= */
    /* VALORES */
    /* ============================= */
    FMV.VAL_TOTAL,
    FMV.VAL_CUSTO,
    FMV.VAL_OPCIONAIS,
    FMV.VAL_DESCONTO,
    FMV.VAL_FRETE,
    FMV.VAL_DEVERIA,
    /* ============================= */
    /* NOTA FISCAL */
    /* ============================= */
    FMC.NUMERO_NOTA_FISCAL AS NF_NUMERO,
    FMC.SERIE_NOTA_FISCAL AS NF_SERIE,
    -- SEÇÃO: CONTATO / TOTAIS DE MERCADORIA
    FMC.CONTATO,
    FMC.TOT_MERCADORIA,
    FMC.TOT_CUSTO_MEDIO,
    FMC.TOT_QUANTIDADES
    
FROM CNP.FAT_MOVIMENTO_CAPA FMC

INNER JOIN CNP.FAT_MOVIMENTO_VEICULO FMV
    ON FMV.EMPRESA            = FMC.EMPRESA
   AND FMV.REVENDA            = FMC.REVENDA
   AND FMV.NUMERO_NOTA_FISCAL = FMC.NUMERO_NOTA_FISCAL
   AND FMV.SERIE_NOTA_FISCAL  = FMC.SERIE_NOTA_FISCAL
   AND FMV.TIPO_TRANSACAO     = FMC.TIPO_TRANSACAO
   AND FMV.CONTADOR           = FMC.CONTADOR
   
INNER JOIN CNP.VEI_VEICULO VEI
    ON VEI.EMPRESA  = FMV.EMPRESA
   AND VEI.VEICULO  = FMV.VEICULO
   
INNER JOIN CNP.VEI_MODELO MD          -- ? NOVO: traz DES_MODELO
    ON MD.EMPRESA   = VEI.EMPRESA
   AND MD.MODELO    = VEI.MODELO
   
LEFT JOIN CNP.VEI_FAMILIA VF          -- ? NOVO: traz MARCA e DES_FAMILIA
    ON VF.FAMILIA   = MD.FAMILIA
   AND VF.EMPRESA   = MD.EMPRESA
   
INNER JOIN CNP.GER_USUARIO USU
    ON USU.USUARIO  = FMC.USUARIO
    
INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT
    ON FTT.TIPO_TRANSACAO = FMC.TIPO_TRANSACAO
    
/* ============================= */
/* FILTROS BI / PERFORMANCE */
/* ============================= */
WHERE FMC.TIPO_TRANSACAO IN ('V21','U21')
  AND FMC.STATUS = 'F'
  AND FMC.DTA_ENTRADA_SAIDA >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -60);
