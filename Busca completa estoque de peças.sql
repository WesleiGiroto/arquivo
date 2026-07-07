
-- ============================================================
-- 3. ITEM DE ESTOQUE: Consulta detalhada do item pelo código público
--    Inclui preços de tabela (garantia, à vista, público, alternativo),
--    classificação ABC/XYZ, quantidades disponíveis, MVA, NRO_DIAS em
--    aberto em pedidos, e informações de itens referenciados/substitutos.
-- ============================================================
SELECT
        -- Identificação do item
    PIE.EMPRESA,
    PIE.ITEM_ESTOQUE,
    PIE.ITEM_ESTOQUE_PUB,
    PIE.ITEM_EDICAO,
    PIE.DES_ITEM_ESTOQUE,
    PIE.GRUPO_DESCONTO,
    PIE.UNIDADE_MEDIDA,
    PIE.UTILIZACAO_ITEM,
    PIE.ITEM_ESTOQUE_SUBSTITUTO,

    -- Preço de Garantia (busca da tabela de preços parametrizada; fallback para campo direto)
    COALESCE(
        (SELECT PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
               -- AND PPZ.REVENDA  = 1
                AND PPZ.PRECO_GARANTIA = ZZY.TABELA
         WHERE ZZY.EMPRESA      = PIE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE),
        PIE.PRECO_GARANTIA
    )                               AS PRECO_GARANTIA,

    PIE.PRECO_GARANTIA_BALCAO,
    PIE.PRECO_BASE_GARANTIA,

    -- Preço à Vista (busca da tabela de preços parametrizada; fallback para campo direto)
    COALESCE(
        (SELECT PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
               -- AND PPZ.REVENDA  = 1
                AND PPZ.PRECO_A_VISTA = ZZY.TABELA
         WHERE ZZY.EMPRESA      = PIE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE),
        PIE.PRECO_A_VISTA
    )                               AS PRECO_A_VISTA,

    -- Dados complementares do item
    PIE.MARCA,
    PIE.GRUPO,
    PIE.DTA_DO_CADASTRO,
    PIE.QTD_EMBALAGEM,
    NIE.QT_PEDIDO_MINIMO,
    PIE.CATEGORIA,
    PIE.ALIQUOTA_IPI,
    PIE.DTA_PRECO_ATUAL,

    -- Preço Público Atual (busca da tabela de preços parametrizada; fallback para campo direto)
    COALESCE(
        (SELECT PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
               -- AND PPZ.REVENDA  = 1
                AND PPZ.PRECO_PUBLICO_ATUAL = ZZY.TABELA
         WHERE ZZY.EMPRESA      = PIE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE),
        PIE.PRECO_PUBLICO_ATUAL
    )                               AS PRECO_PUBLICO_ATUAL,

    -- Dados de demanda e fábrica
    PIE.DEMANDA_DIARIA_GMB,
    PIE.ITEM_DE_FABRICA,
    PIE.ACRESCIMO_DESCONTO,
    PIE.IPI_VENDA,
    PIE.FORNECEDOR,
    PIE.LOTE_ECONOMICO,
    PIE.PCT_PIS_IMPORTA,

    -- Grupo da montadora e descontos
    PGR.GRUPO_DA_MONTADORA,
    PGD.PCT_DESCONTO_VENDA,
    PGD.PCT_DESCONTO,

    -- Preço Alternativo (busca da tabela de preços parametrizada; fallback para campo direto)
    COALESCE(
        (SELECT PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
               -- AND PPZ.REVENDA  = 1
                AND PPZ.PRECO_ALTERNATIVO = ZZY.TABELA
         WHERE ZZY.EMPRESA      = PIE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE),
        PIE.PRECO_ALTERNATIVO
    )                               AS PRECO_ALTERNATIVO,

    -- Informações de distribuição e tributação
    PIE.CLASSE_FABRICA,
    PIE.CANCEL_DISTRIB,
    PIE.DTA_CANCEL_DISTRIB,
    PIE.CODIGO_TRIBUTACAO_S,
    PIE.SITUACAO,

    -- Indicador de promoção (fixo 'N' nesta consulta)
    'N'                             AS TEM_PROMOCAO,

    PIE.BASE_PIS,
    PIE.BASE_COFINS,
    PIJ.CODIGO_ITEM_JUNSOFT,

    CAST(COALESCE(PIE.LOTE_COMPRA, 0) AS NUMERIC(8)) AS LOTE_COMPRA,
    CAST(0 AS NUMERIC(11,2))        AS PRECO_ACRESCIMO_PARTILHA,

    PIE.CANCELADO_FABRICA,
    PIE.BASE_DA_TROCA,
    PIE.ITEM_RECON,

    -- MVA (Margem de Valor Agregado) da tabela de revenda
    CAST(
        (SELECT PCT_MARGEM_LUCRO
         FROM CNP.PEC_ITEM_REVENDA
         WHERE EMPRESA      = PIE.EMPRESA
         --  AND REVENDA       = 1
           AND ITEM_ESTOQUE  = PIE.ITEM_ESTOQUE)
    AS NUMERIC(5,2))                AS MVA,

    -- Quantidade de venda futura reservada
    CAST(
        (SELECT QTD_VENDA_FUTURA
         FROM CNP.PEC_ITEM_REVENDA
         WHERE EMPRESA      = PIE.EMPRESA
          -- AND REVENDA       = 1
           AND ITEM_ESTOQUE  = PIE.ITEM_ESTOQUE)
    AS NUMERIC(12,3))               AS QTD_VENDA_FUTURA,

    -- Quantidade em ordem
    CAST(
        (SELECT QTD_ORDEM
         FROM CNP.PEC_ITEM_REVENDA
         WHERE EMPRESA      = PIE.EMPRESA
         --  AND REVENDA       = 1
           AND ITEM_ESTOQUE  = PIE.ITEM_ESTOQUE)
    AS NUMERIC(12,3))               AS QTD_ORDEM,

    -- Quantidade disponível = Contábil menos todas as reservas/comprometimentos
    CAST(
        (SELECT (PIR.QTD_CONTABIL) - (
                    PIR.QTD_NEGOCIACAO
                  + PIR.QTD_BOUTIQUE
                  + PIR.QTD_RES_OFICINA
                  + PIR.QTD_ALOCADA
                  + PIR.QTD_ORCADA
                  + PIR.QTD_LITIGIO
                  + PIR.QTD_TERCEIROS
                  + COALESCE(PIR.QTD_ORDEM, 0)
                  + PIR.QTD_CONFERENCIA
                  + COALESCE(PIR.QTD_FULFILLMENT, 0)
                  + COALESCE(PIR.QTD_NEGOCIACAO_FULFILLMEN, 0)
                  + PIR.QTD_COMPROMETIDA
                )
         FROM CNP.PEC_ITEM_REVENDA PIR
         WHERE PIR.EMPRESA     = PIE.EMPRESA
         -- AND PIR.REVENDA      = 1
           AND PIR.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE)
    AS NUMERIC(12,2))               AS DISPONIVEL,

    -- Quantidade que pertence a terceiros
    CAST(
        (SELECT COALESCE(QTD_PERTENCE_TERCEIROS, 0)
         FROM CNP.PEC_ITEM_REVENDA PIR
         WHERE PIR.EMPRESA     = PIE.EMPRESA
          -- AND PIR.REVENDA      = 1
           AND PIR.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE)
    AS NUMERIC(12,2))               AS QTD_PERTENCE_TERCEIROS,

    CAST(0 AS NUMERIC(12,2))        AS QTD_CLIENTE_CWS,
    CAST(0 AS NUMERIC(12,2))        AS QTD_ESTOQUE_PADRAO,

    -- Código público do item de estoque referenciado (menor referência alternativa)
    (SELECT PEI.ITEM_ESTOQUE_PUB
     FROM CNP.PEC_ITEM_ESTOQUE PEI
     WHERE PEI.EMPRESA      = PIE.EMPRESA
       AND PEI.ITEM_ESTOQUE  = (
           SELECT MIN(PIA.ITEM_ESTOQUE_REFERENCIADO)
           FROM CNP.PEC_ITEM_ALTERNATIVO PIA
           WHERE PIE.EMPRESA      = PIA.EMPRESA
             AND PIE.ITEM_ESTOQUE  = PIA.ITEM_ESTOQUE
       )
    )                               AS ITEM_PUB_REFERENCIADO,

    PIE.SUBSTITUIDO_VNR_FIAT,
    PIE.SUBSTITUIDO_CITROEN_PEUGEOT,

    -- Número de dias desde o pedido mais antigo em aberto para este item
    COALESCE(
        CAST(
            TO_DATE('18/03/2026', 'dd/mm/yyyy') - (
                SELECT MIN(COALESCE(PED.DTA_EMISSAO, PIP.DTA_EMISSAO))
                FROM CNP.PEC_ITEM_PEDIDO PIP
                INNER JOIN CNP.PEC_PEDIDO PED
                        ON PIP.EMPRESA  = PED.EMPRESA
                       AND PED.REVENDA  = PIP.REVENDA
                       AND PED.PEDIDO   = PIP.PEDIDO
                WHERE PIP.EMPRESA        IN (1,2,3)
                  AND PIE.EMPRESA        = PIE.EMPRESA
                  AND PIP.ITEM_ESTOQUE   = PIE.ITEM_ESTOQUE
                  AND PIP.REVENDA        IN (1,2)
                  AND PIP.SITUACAO      <> '9'
                  AND PIP.QTDE_PEDIDA   > PIP.QTDE_BAIXADA
                  AND PED.SITUACAO      <> '9'
            )
        AS INTEGER),
        0
    )                               AS NRO_DIAS,

    PIE.ORIGEM_PECA,

    -- Preço público atual (cast final para numérico, com fallback da tabela de preços)
    CAST(
        COALESCE(
            (SELECT PRECO
             FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
             INNER JOIN CNP.PEC_PARAMETRO PPZ
                     ON PPZ.EMPRESA  = ZZY.EMPRESA
                   -- AND PPZ.REVENDA  = 1
                    AND PPZ.PRECO_PUBLICO_ATUAL = ZZY.TABELA
             WHERE ZZY.EMPRESA      = PIE.EMPRESA
               AND ZZY.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE),
            PIE.PRECO_PUBLICO_ATUAL
        )
    AS NUMERIC(15,2))               AS PRECO

FROM CNP.PEC_ITEM_ESTOQUE PIE

-- Join com tabela de parâmetros NISSAN do item (pedido mínimo)
LEFT JOIN CNP.NIS_ITEM_ESTOQUE NIE
       ON NIE.EMPRESA      = PIE.EMPRESA
      AND NIE.ITEM_ESTOQUE = PIE.ITEM_ESTOQUE

-- Join com tabela de revenda (código Junsoft)
LEFT OUTER JOIN CNP.PEC_ITEM_REVENDA PIJ
             ON PIE.EMPRESA      = PIJ.EMPRESA
            AND PIE.ITEM_ESTOQUE = PIJ.ITEM_ESTOQUE
           -- AND PIJ.REVENDA       = 1

-- Join com tabela de grupo de desconto
LEFT OUTER JOIN CNP.PEC_GRUPO_DESCONTO PGD
             ON PIE.EMPRESA        = PGD.EMPRESA
            AND PIE.GRUPO_DESCONTO = PGD.GRUPO_DESCONTO

-- Join com tabela de grupos (montadora)
LEFT OUTER JOIN CNP.PEC_GRUPO PGR
             ON PIE.MARCA  = PGR.MARCA
            AND PIE.GRUPO  = PGR.GRUPO

WHERE PIE.EMPRESA          IN ( 1,2,3 )
 -- AND PIE.ITEM_ESTOQUE_PUB LIKE '93344704%'   -- Filtra pelo prefixo do código público
  AND PIE.SITUACAO         <> 'E';            -- Exclui itens com situação 'E' (excluído)


-- ============================================================
-- 4. PARÂMETRO: Verifica política de origem para cálculo de preço/IT
-- ============================================================
SELECT
    UTILIZA_POLITICA_ORIGEM_PC_IT,
    PER_ORIGEM_NACIONAL_PC_IT,
    PER_ORIGEM_IMPORTADO_PC_IT
FROM CNP.PEC_PARAMETRO
WHERE EMPRESA = 1
  AND REVENDA = 1;


-- ============================================================
-- 5. CLASSIFICAÇÃO ABC/XYZ: Consulta por item específico
--    (Executada para cada item retornado: 41636, 151738, 154933, 276411, 284426)
-- ============================================================
SELECT CLASS_ABC, CLASS_XYZ
FROM CNP.PEC_ITEM_REVENDA
WHERE EMPRESA      = 1
  AND REVENDA       = 1
  AND ITEM_ESTOQUE  = :ITEM_ESTOQUE;   -- Ex: 41636


-- ============================================================
-- 6. MODELO DE REPOSIÇÃO: Busca giro ideal e prazo de entrega
--    conforme classificação ABC/XYZ do item
--    (Combinações utilizadas: A/2, D/3, D/2)
-- ============================================================
SELECT GIRO_IDEAL, PRAZO_ENTREGA
FROM CNP.PEC_MODELO_REPOSICAO
WHERE EMPRESA   = 1
  AND CLASS_ABC = :CLASS_ABC    -- Ex: 'A', 'D'
  AND CLASS_XYZ = :CLASS_XYZ;   -- Ex: '2', '3'


-- ============================================================
-- 7. QUANTIDADES EM ESTOQUE: Detalhamento de todas as modalidades
--    de reserva/comprometimento por item
-- ============================================================
SELECT
    QTD_CONTABIL,
    QTD_PEDIDA,
    QTD_RES_OFICINA,
    QTD_NEGOCIACAO,
    QTD_ALOCADA,
    QTD_ORCADA,
    QTD_LITIGIO,
    QTD_TRANSITO,
    QTD_TERCEIROS,
    QTD_CONFERENCIA,
    QTD_COMPROMETIDA,
    QTD_FABRICACAO,
    QTD_NEGOCIACAO_BOUTIQUE,
    QTD_BOUTIQUE,
    QTD_ORDEM,
    QTD_PERTENCE_TERCEIROS,
    QTD_FULFILLMENT,
    QTD_NEGOCIACAO_FULFILLMEN
FROM CNP.PEC_ITEM_REVENDA
WHERE EMPRESA      = 1
  AND REVENDA       = 1
  AND ITEM_ESTOQUE  = :ITEM_ESTOQUE;   -- Ex: 41636


-- ============================================================
-- 8. PREÇO DE CUSTO MÉDIO: Calcula o custo médio unitário
--    (apenas para itens com estoque positivo)
-- ============================================================
SELECT ROUND((VAL_ESTOQUE / QTD_CONTABIL), 2) AS PRECO_CUSTO
FROM CNP.PEC_ITEM_REVENDA
WHERE EMPRESA      = 1
  AND REVENDA       = 1
  AND ITEM_ESTOQUE  = :ITEM_ESTOQUE   -- Ex: 41636
  AND QTD_CONTABIL > 0;


-- ============================================================
-- 9. DADOS COMPLETOS DO ITEM NA REVENDA: Todos os campos da
--    tabela PEC_ITEM_REVENDA para um item específico
-- ============================================================
SELECT *
FROM CNP.PEC_ITEM_REVENDA
WHERE EMPRESA      = :1   -- 1
  AND REVENDA       = :2   -- 1
  AND ITEM_ESTOQUE  = :3;  -- Ex: 41636


-- ============================================================
-- 11. ESTOQUE POR REVENDA: Situação do item em todas as revendas
--     da mesma empresa (para visão consolidada de estoque)
-- ============================================================
SELECT
    PIR.EMPRESA,
    PIR.REVENDA,
    PIR.ITEM_ESTOQUE,
    PIR.QTD_CONTABIL,
    PIR.QTD_PEDIDA,
    PIR.DEMANDA_MEDIA,
    PIR.DTA_SAIDA,
    PIR.CLASS_ABC,
    PIR.CLASS_XYZ,

    -- Custo médio unitário (zero se sem estoque)
    CASE
        WHEN PIR.QTD_CONTABIL > 0
        THEN CAST((PIR.VAL_ESTOQUE / PIR.QTD_CONTABIL) AS NUMERIC(13,2))
        ELSE 0
    END                         AS CUSTO_MEDIO,

    -- Dias sem movimentação de saída
    CAST((TO_DATE('18/03/2026', 'dd/mm/yyyy') - PIR.DTA_SAIDA) AS NUMERIC(10)) AS DIAS_SEM_MOVIMENTO,

    -- Quantidade disponível (contábil menos reservas)
    (PIR.QTD_CONTABIL) - (
          PIR.QTD_NEGOCIACAO
        + PIR.QTD_BOUTIQUE
        + PIR.QTD_RES_OFICINA
        + PIR.QTD_ALOCADA
        + PIR.QTD_ORCADA
        + PIR.QTD_LITIGIO
        + PIR.QTD_TERCEIROS
        + COALESCE(PIR.QTD_ORDEM, 0)
        + PIR.QTD_CONFERENCIA
        + COALESCE(PIR.QTD_FULFILLMENT, 0)
        + COALESCE(PIR.QTD_NEGOCIACAO_FULFILLMEN, 0)
        + PIR.QTD_COMPROMETIDA
    )                           AS DISPONIVEL

FROM CNP.PEC_ITEM_REVENDA PIR
WHERE PIR.EMPRESA      = 1
  AND PIR.ITEM_ESTOQUE  = :ITEM_ESTOQUE   -- Ex: 41636
ORDER BY REVENDA;


-- ============================================================
-- 12. ESTOQUE EM OUTRAS EMPRESAS: Busca disponibilidade do item
--     em revendas de outras empresas (exceto empresa 1)
-- ============================================================
SELECT
    PIR.EMPRESA,
    PIR.REVENDA,
    GER.NOME_FANTASIA,
    PIE.ITEM_ESTOQUE,
    PIR.QTD_CONTABIL,
    PIR.QTD_PEDIDA,
    PIR.DEMANDA_MEDIA,
    PIR.CLASS_ABC,
    PIR.CLASS_XYZ,

    -- Custo médio unitário
    CASE
        WHEN PIR.QTD_CONTABIL > 0
        THEN CAST((PIR.VAL_ESTOQUE / PIR.QTD_CONTABIL) AS NUMERIC(13,2))
        ELSE 0
    END                         AS CUSTO_MEDIO,

    -- Disponível (não permite negativo; retorna 0 se resultado < 0)
    CASE
        WHEN (PIR.QTD_CONTABIL) - (
              PIR.QTD_NEGOCIACAO
            + PIR.QTD_BOUTIQUE
            + PIR.QTD_RES_OFICINA
            + PIR.QTD_ALOCADA
            + PIR.QTD_ORCADA
            + PIR.QTD_LITIGIO
            + PIR.QTD_TERCEIROS
            + COALESCE(PIR.QTD_ORDEM, 0)
            + PIR.QTD_CONFERENCIA
            + COALESCE(PIR.QTD_FULFILLMENT, 0)
            + COALESCE(PIR.QTD_NEGOCIACAO_FULFILLMEN, 0)
            + PIR.QTD_COMPROMETIDA
        ) < 0
        THEN 0
        ELSE (PIR.QTD_CONTABIL) - (
              PIR.QTD_NEGOCIACAO
            + PIR.QTD_BOUTIQUE
            + PIR.QTD_RES_OFICINA
            + PIR.QTD_ALOCADA
            + PIR.QTD_ORCADA
            + PIR.QTD_LITIGIO
            + PIR.QTD_TERCEIROS
            + COALESCE(PIR.QTD_ORDEM, 0)
            + PIR.QTD_CONFERENCIA
            + COALESCE(PIR.QTD_FULFILLMENT, 0)
            + COALESCE(PIR.QTD_NEGOCIACAO_FULFILLMEN, 0)
            + PIR.QTD_COMPROMETIDA
        )
    END                         AS DISPONIVEL

FROM CNP.PEC_ITEM_REVENDA PIR

INNER JOIN CNP.PEC_ITEM_ESTOQUE PIE
        ON PIE.ITEM_ESTOQUE = PIR.ITEM_ESTOQUE
       AND PIR.EMPRESA       = PIE.EMPRESA

LEFT OUTER JOIN CNP.GER_REVENDA GER
             ON GER.EMPRESA  = PIR.EMPRESA
            AND GER.REVENDA  = PIR.REVENDA

WHERE PIE.ITEM_ESTOQUE_PUB = '93344704'   -- Código público do item
  AND PIR.EMPRESA          <> 1           -- Exclui a empresa corrente

ORDER BY PIR.EMPRESA, PIR.REVENDA, PIE.ITEM_ESTOQUE;


-- ============================================================
-- 13. ÚLTIMA SAÍDA: Nota fiscal e data da última venda do item
--     (tipo 'S' - saída normal, status finalizado, sem substituição)
-- ============================================================
SELECT
    FMC.NUMERO_NOTA_FISCAL,
    FMC.DTA_ENTRADA_SAIDA
FROM CNP.FAT_MOVIMENTO_ITEM FMI

INNER JOIN CNP.FAT_MOVIMENTO_CAPA FMC
        ON FMI.EMPRESA            = FMC.EMPRESA
       AND FMI.REVENDA             = FMC.REVENDA
       AND FMI.NUMERO_NOTA_FISCAL  = FMC.NUMERO_NOTA_FISCAL
       AND FMI.SERIE_NOTA_FISCAL   = FMC.SERIE_NOTA_FISCAL
       AND FMI.TIPO_TRANSACAO      = FMC.TIPO_TRANSACAO
       AND FMI.CONTADOR            = FMC.CONTADOR

INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT
        ON FMI.TIPO_TRANSACAO = FTT.TIPO_TRANSACAO

WHERE FMI.EMPRESA                = 1
  AND FMI.REVENDA                 = 1
  AND FMI.ITEM_ESTOQUE            = :ITEM_ESTOQUE    -- Ex: 41636
  AND FTT.TIPO                    = 'S'              -- Saída
  AND FMC.STATUS                  = 'F'              -- Finalizado
  AND FTT.SUBTIPO_TRANSACAO       = 'N'              -- Normal

  -- Filtra apenas a última operação de saída
  AND FMC.OPERACAO = (
      SELECT MAX(FMC2.OPERACAO)
      FROM CNP.FAT_MOVIMENTO_ITEM FMI2
      INNER JOIN FAT_MOVIMENTO_CAPA FMC2
              ON FMI2.EMPRESA           = FMC2.EMPRESA
             AND FMI2.REVENDA            = FMC2.REVENDA
             AND FMI2.NUMERO_NOTA_FISCAL = FMC2.NUMERO_NOTA_FISCAL
             AND FMI2.SERIE_NOTA_FISCAL  = FMC2.SERIE_NOTA_FISCAL
             AND FMI2.TIPO_TRANSACAO     = FMC2.TIPO_TRANSACAO
             AND FMI2.CONTADOR           = FMC2.CONTADOR
      INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT2
              ON FMI2.TIPO_TRANSACAO = FTT2.TIPO_TRANSACAO
      WHERE FMI2.EMPRESA          = 1
        AND FMI2.REVENDA           = 1
        AND FMI2.ITEM_ESTOQUE      = :ITEM_ESTOQUE
        AND FTT2.TIPO              = 'S'
        AND FMC2.STATUS            = 'F'
        AND FTT2.SUBTIPO_TRANSACAO = 'N'
  );


-- ============================================================
-- 14. DATAS DE ENTRADA: Primeira entrada e última compra do item
-- ============================================================
SELECT DTA_PRIM_ENTRADA, DTA_ULT_COMPRA
FROM CNP.PEC_ITEM_REVENDA
WHERE EMPRESA      = 1
  AND REVENDA       = 1
  AND ITEM_ESTOQUE  = :ITEM_ESTOQUE;   -- Ex: 41636


-- ============================================================
-- 15. ÚLTIMA ENTRADA (NF): Dados da última nota fiscal de entrada
--     do item (tipo 'E' - entrada normal, status finalizado)
-- ============================================================
SELECT
    FMC.NUMERO_NOTA_FISCAL,
    FMC.DTA_ENTRADA_SAIDA,
    FMI.VAL_CUSTO_MEDIO,
    FMI.VAL_TOTAL_NOTA_ITEM,
    FMI.VAL_IPI,
    FMI.QUANTIDADE,
    FMC.DTA_DOCUMENTO,
    FTT.TIPO
FROM CNP.FAT_MOVIMENTO_ITEM FMI

INNER JOIN CNP.FAT_MOVIMENTO_CAPA FMC
        ON FMI.EMPRESA            = FMC.EMPRESA
       AND FMI.REVENDA             = FMC.REVENDA
       AND FMI.NUMERO_NOTA_FISCAL  = FMC.NUMERO_NOTA_FISCAL
       AND FMI.SERIE_NOTA_FISCAL   = FMC.SERIE_NOTA_FISCAL
       AND FMI.TIPO_TRANSACAO      = FMC.TIPO_TRANSACAO
       AND FMI.CONTADOR            = FMC.CONTADOR

INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT
        ON FMI.TIPO_TRANSACAO = FTT.TIPO_TRANSACAO

WHERE FMI.EMPRESA                = 1
  AND FMI.REVENDA                 = 1
  AND FMI.ITEM_ESTOQUE            = :ITEM_ESTOQUE    -- Ex: 41636
  AND FTT.TIPO                    = 'E'              -- Entrada
  AND FMC.STATUS                  = 'F'              -- Finalizado
  AND FTT.SUBTIPO_TRANSACAO       = 'N'              -- Normal

  -- Filtra apenas a última operação de entrada
  AND FMC.OPERACAO = (
      SELECT MAX(FMC2.OPERACAO)
      FROM CNP.FAT_MOVIMENTO_ITEM FMI2
      INNER JOIN CNP.FAT_MOVIMENTO_CAPA FMC2
              ON FMI2.EMPRESA           = FMC2.EMPRESA
             AND FMI2.REVENDA            = FMC2.REVENDA
             AND FMI2.NUMERO_NOTA_FISCAL = FMC2.NUMERO_NOTA_FISCAL
             AND FMI2.SERIE_NOTA_FISCAL  = FMC2.SERIE_NOTA_FISCAL
             AND FMI2.TIPO_TRANSACAO     = FMC2.TIPO_TRANSACAO
             AND FMI2.CONTADOR           = FMC2.CONTADOR
      INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT2
              ON FMI2.TIPO_TRANSACAO = FTT2.TIPO_TRANSACAO
      WHERE FMI2.EMPRESA          = 1
        AND FMI2.REVENDA           = 1
        AND FMI2.ITEM_ESTOQUE      = :ITEM_ESTOQUE
        AND FTT2.TIPO              = 'E'
        AND FMC2.STATUS            = 'F'
        AND FTT2.SUBTIPO_TRANSACAO = 'N'
  );


-- ============================================================
-- 16. ÚLTIMO MOVIMENTO GERAL: Dados do último movimento
--     (qualquer tipo) vinculado à última entrada finalizada do item
-- ============================================================
SELECT
    FMC.NUMERO_NOTA_FISCAL,
    FMC.DTA_ENTRADA_SAIDA,
    FMC.DTA_DOCUMENTO,
    FMI.VAL_CUSTO_MEDIO,
    FMI.VAL_TOTAL_NOTA_ITEM,
    FMI.VAL_IPI,
    FMI.QUANTIDADE,
    FTT.TIPO
FROM CNP.FAT_MOVIMENTO_ITEM FMI

INNER JOIN CNP.FAT_MOVIMENTO_CAPA FMC
        ON FMI.EMPRESA            = FMC.EMPRESA
       AND FMI.REVENDA             = FMC.REVENDA
       AND FMI.NUMERO_NOTA_FISCAL  = FMC.NUMERO_NOTA_FISCAL
       AND FMI.SERIE_NOTA_FISCAL   = FMC.SERIE_NOTA_FISCAL
       AND FMI.TIPO_TRANSACAO      = FMC.TIPO_TRANSACAO
       AND FMI.CONTADOR            = FMC.CONTADOR

INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT
        ON FMI.TIPO_TRANSACAO = FTT.TIPO_TRANSACAO

WHERE FMI.EMPRESA      = 1
  AND FMI.REVENDA       = 1
  AND FMI.ITEM_ESTOQUE  = :ITEM_ESTOQUE    -- Ex: 41636

  -- Filtra pela última operação de entrada finalizada (independente do tipo do item atual)
  AND FMC.OPERACAO = (
      SELECT MAX(FMC2.OPERACAO)
      FROM CNP.FAT_MOVIMENTO_ITEM FMI2
      INNER JOIN CNP.FAT_MOVIMENTO_CAPA FMC2
              ON FMI2.EMPRESA           = FMC2.EMPRESA
             AND FMI2.REVENDA            = FMC2.REVENDA
             AND FMI2.NUMERO_NOTA_FISCAL = FMC2.NUMERO_NOTA_FISCAL
             AND FMI2.SERIE_NOTA_FISCAL  = FMC2.SERIE_NOTA_FISCAL
             AND FMI2.TIPO_TRANSACAO     = FMC2.TIPO_TRANSACAO
             AND FMI2.CONTADOR           = FMC2.CONTADOR
      INNER JOIN CNP.FAT_TIPO_TRANSACAO FTT2
              ON FMI2.TIPO_TRANSACAO = FTT2.TIPO_TRANSACAO
      WHERE FMI2.EMPRESA     = 1
        AND FMI2.REVENDA      = 1
        AND FMI2.ITEM_ESTOQUE = :ITEM_ESTOQUE
        AND FTT2.TIPO         = 'E'        -- Referência: última entrada
        AND FMC2.STATUS       = 'F'        -- Finalizado
  );