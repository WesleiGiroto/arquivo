CREATE OR REPLACE VIEW V_PBI_CADASTRO_PECAS AS
SELECT
    -- ========== IDENTIFICAÇÃO DA EMPRESA ==========
    IE.EMPRESA,
    IE.ITEM_ESTOQUE,

    -- ========== CHAVES DE RELACIONAMENTO ==========
    -- Relacionamento com V_PBI_TABELA_PECAS
    TO_CHAR(IE.EMPRESA) || ' - ' || TO_CHAR(IE.ITEM_ESTOQUE)                   AS CHAVE_EMP_ITEM,

    -- Relacionamento com V_PBI_DEMANDA_HISTORICA
    -- (a demanda usa CHAVE_EMP_REV e CHAVE_EMP_REV_ITEM — precisamos de REVENDA)
    PIJ.REVENDA,
    TO_CHAR(IE.EMPRESA) || ' - ' || TO_CHAR(PIJ.REVENDA)                       AS CHAVE_EMP_REV,
    TO_CHAR(IE.EMPRESA) || ' - ' || TO_CHAR(PIJ.REVENDA) || ' - ' ||
        TO_CHAR(IE.ITEM_ESTOQUE)                                                AS CHAVE_EMP_REV_ITEM,

    -- ========== DADOS MESTRE DA PEÇA ==========
    IE.ITEM_ESTOQUE_PUB,
    IE.ITEM_EDICAO,
    IE.CODIGO_INVERTIDO,
    IE.MARCA,
    IE.GRUPO,
    IE.GRUPO_DESCONTO,
    IE.DES_ITEM_ESTOQUE,
    IE.CATEGORIA,
    IE.SITUACAO,
    IE.SAZONAL,
    IE.UNIDADE_MEDIDA,
    IE.QTD_EMBALAGEM,
    IE.COD_EAN_GTIN,

    -- ========== PREÇOS ==========
    IE.PRECO_PUBLICO_ATUAL,
    IE.PRECO_PUBLICO_ANTER,
    IE.PRECO_GARANTIA,
    IE.PRECO_GARANTIA_BALCAO,
    IE.PRECO_BASE_GARANTIA,
    IE.PRECO_A_VISTA,
    IE.PRECO_ALTERNATIVO,
    IE.PRECO_CUSTO,
    IE.INDICE_DE_PRECO,

    -- ========== TRIBUTOS E FISCAL ==========
    IE.ALIQUOTA_IPI,
    IE.BASE_PIS,
    IE.BASE_COFINS,
    IE.CODIGO_TRIBUTACAO_E,
    IE.CODIGO_TRIBUTACAO_S,
    IE.POSICAO_FISCAL,
    IE.CEST,
    IE.COD_SEGMENTO_NCM,

    -- ========== DATAS ==========
    IE.DTA_DO_CADASTRO,
    IE.DTA_PRECO_ATUAL,
    IE.DTA_PRECO_ANTER,

    -- ========== DADOS DE ESTOQUE POR REVENDA ==========
    PIJ.CLASS_ABC,
    PIJ.ESTOQUE_MEDIO                      AS CUSTO_MEDIO,
    PIJ.DTA_SAIDA                          AS DTA_ULTIMA_SAIDA,
    PIJ.DTA_ULT_ENTRADA,
    PIJ.DTA_ULT_COMPRA,
    PIJ.DTA_PRIM_ENTRADA,

    -- ========== ESTOQUE DISPONÍVEL POR REVENDA ==========
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
         WHERE PIR.EMPRESA      = IE.EMPRESA
           AND PIR.REVENDA      = PIJ.REVENDA
           AND PIR.ITEM_ESTOQUE = IE.ITEM_ESTOQUE)
    AS NUMERIC(12,2))                      AS DISPONIVEL_REVENDA,

    -- ========== DESCONTO DO GRUPO ==========
    PGD.PCT_DESCONTO

FROM CNP.PEC_ITEM_ESTOQUE IE

    -- Expande por revenda (1 linha por empresa+revenda+item)
    LEFT JOIN CNP.PEC_ITEM_REVENDA PIJ
           ON PIJ.EMPRESA      = IE.EMPRESA
          AND PIJ.ITEM_ESTOQUE = IE.ITEM_ESTOQUE

    LEFT JOIN CNP.PEC_GRUPO_DESCONTO PGD
           ON PGD.EMPRESA        = IE.EMPRESA
          AND PGD.GRUPO_DESCONTO = IE.GRUPO_DESCONTO

    LEFT JOIN CNP.PEC_GRUPO PGR
           ON PGR.MARCA = IE.MARCA
          AND PGR.GRUPO = IE.GRUPO;