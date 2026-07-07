CREATE OR REPLACE VIEW V_PBI_TABELA_PECAS AS
SELECT
    -- ========== IDENTIFICAÇÃO DA EMPRESA E REVENDA ==========
    PB.EMPRESA,
    PB.REVENDA,
    TO_CHAR(PB.EMPRESA) || ' - ' || TO_CHAR(PB.REVENDA)                                             AS CHAVE_EMP_REV,
    TO_CHAR(PB.EMPRESA) || ' - ' || TO_CHAR(IE.ITEM_ESTOQUE)                                        AS CHAVE_EMP_ITEM,
    TO_CHAR(PB.EMPRESA) || ' - ' || TO_CHAR(PB.REVENDA) || ' - ' || TO_CHAR(PB.ATENDE_BALCAO)       AS CHAVE_EMP_REV_BALCAO,
    TO_CHAR(PB.EMPRESA) || ' - ' || TO_CHAR(PB.REVENDA) || ' - ' || TO_CHAR(PB.ITEM_ESTOQUE)        AS CHAVE_EMP_REV_ITEM,
    TO_CHAR(PB.EMPRESA) || ' - ' || TO_CHAR(PB.REVENDA) || ' - ' || TO_CHAR(PB.USUARIO)             AS CHAVE_EMP_REV_USUARIO,
    TO_CHAR(PB.EMPRESA) || ' - ' || TO_CHAR(PB.REVENDA) || ' - ' || TO_CHAR(PB.CLIENTE_ATENDIMENTO) AS CHAVE_EMP_REV_CONTATO,

    -- ========== IDENTIFICAÇÃO DO ATENDIMENTO ==========
    PB.USUARIO,
    PB.ATENDE_BALCAO,
    PB.ITEM_ESTOQUE,
    PB.CLIENTE_ATENDIMENTO                 AS CONTATO,
    PB.ORDEM,

    -- ========== DADOS MESTRE DA PEÇA (PEC_ITEM_ESTOQUE) ==========
    IE.MARCA,
    IE.GRUPO,
    IE.GRUPO_DESCONTO,
    IE.ITEM_ESTOQUE_PUB,
    IE.ITEM_EDICAO,
    IE.CODIGO_INVERTIDO,
    IE.DES_ITEM_ESTOQUE,
    IE.CATEGORIA,
    IE.SITUACAO                            AS SITUACAO_ITEM,   -- exclusivo do ESTOQUE_PECAS
    IE.SAZONAL,
    IE.UNIDADE_MEDIDA,
    IE.QTD_EMBALAGEM,
    IE.COD_EAN_GTIN,

    -- ========== PREÇOS (com COALESCE da tabela de preço — lógica da principal) ==========
    COALESCE(
        (SELECT ZZY.PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
                AND PPZ.REVENDA  IN (1,2,3)
                AND PPZ.PRECO_PUBLICO_ATUAL = ZZY.TABELA
         WHERE ZZY.EMPRESA      = IE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = IE.ITEM_ESTOQUE),
        IE.PRECO_PUBLICO_ATUAL
    )                                      AS PRECO_PUBLICO_ATUAL,

    IE.PRECO_PUBLICO_ANTER,                -- exclusivo do ESTOQUE_PECAS

    COALESCE(
        (SELECT ZZY.PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
                AND PPZ.REVENDA  IN (1,2,3)
                AND PPZ.PRECO_GARANTIA = ZZY.TABELA
         WHERE ZZY.EMPRESA      = IE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = IE.ITEM_ESTOQUE),
        IE.PRECO_GARANTIA
    )                                      AS PRECO_GARANTIA,

    IE.PRECO_GARANTIA_BALCAO,
    IE.PRECO_BASE_GARANTIA,

    COALESCE(
        (SELECT ZZY.PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
                AND PPZ.REVENDA  IN (1,2,3)
                AND PPZ.PRECO_A_VISTA = ZZY.TABELA
         WHERE ZZY.EMPRESA      = IE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = IE.ITEM_ESTOQUE),
        IE.PRECO_A_VISTA
    )                                      AS PRECO_A_VISTA,

    COALESCE(
        (SELECT ZZY.PRECO
         FROM CNP.PEC_TABELA_PRECO_ITEM ZZY
         INNER JOIN CNP.PEC_PARAMETRO PPZ
                 ON PPZ.EMPRESA  = ZZY.EMPRESA
                AND PPZ.REVENDA  IN (1,2,3)
                AND PPZ.PRECO_ALTERNATIVO = ZZY.TABELA
         WHERE ZZY.EMPRESA      = IE.EMPRESA
           AND ZZY.ITEM_ESTOQUE = IE.ITEM_ESTOQUE),
        IE.PRECO_ALTERNATIVO
    )                                      AS PRECO_ALTERNATIVO,

    IE.PRECO_CUSTO,
    IE.INDICE_DE_PRECO,                    -- exclusivo do ESTOQUE_PECAS

    -- ========== TRIBUTOS E FISCAL ==========
    IE.ALIQUOTA_IPI,                       -- exclusivo do ESTOQUE_PECAS
    IE.BASE_PIS,
    IE.BASE_COFINS,
    IE.CODIGO_TRIBUTACAO_E,
    IE.CODIGO_TRIBUTACAO_S,
    IE.POSICAO_FISCAL,
    IE.CEST,
    IE.COD_SEGMENTO_NCM,

    -- ========== DATAS (PEC_ITEM_ESTOQUE) ==========
    IE.DTA_DO_CADASTRO,
    IE.DTA_PRECO_ATUAL,
    IE.DTA_PRECO_ANTER,

    -- ========== DATAS (PEC_ITEM_REVENDA) ==========
    PIJ.DTA_SAIDA                          AS DTA_ULTIMA_SAIDA,
    PIJ.DTA_ULT_ENTRADA,
    PIJ.DTA_ULT_COMPRA,
    PIJ.DTA_PRIM_ENTRADA,

    -- ========== GRUPO MONTADORA E DESCONTOS ==========
    PGD.PCT_DESCONTO,

    -- ========== ESTOQUE / REVENDA ==========
    PIJ.ESTOQUE_MEDIO                      AS CUSTO_MEDIO,
    PIJ.CLASS_ABC,

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
           AND PIR.REVENDA      = PB.REVENDA
           AND PIR.ITEM_ESTOQUE = IE.ITEM_ESTOQUE)
    AS NUMERIC(12,2))                      AS DISPONIVEL_REVENDA,

    -- ========== PEDIDOS EM ABERTO ==========
    COALESCE(
        TRUNC(SYSDATE) - (
            SELECT MIN(COALESCE(PED.DTA_EMISSAO, PIP.DTA_EMISSAO))
            FROM CNP.PEC_ITEM_PEDIDO PIP
            INNER JOIN CNP.PEC_PEDIDO PED
                    ON PIP.EMPRESA  = PED.EMPRESA
                   AND PED.REVENDA  = PIP.REVENDA
                   AND PED.PEDIDO   = PIP.PEDIDO
            WHERE PIP.EMPRESA       = IE.EMPRESA
              AND PIP.ITEM_ESTOQUE  = IE.ITEM_ESTOQUE
              AND PIP.REVENDA       = PB.REVENDA
              AND PIP.QTDE_PEDIDA  > PIP.QTDE_BAIXADA
        ),
        0
    )                                      AS NRO_DIAS,

    -- ========== QUANTIDADES E ROMANEIO (BALCÃO) ==========
    PB.QTDE_DISPONIVEL,
    PB.QUANTIDADE,
    PB.QTDE_ROMANEIO,
    PB.QTDE_COMPROMETIDA,
    PB.NRO_ROMANEIO,
    PB.QTD_EXPEDICAO,                      -- exclusivo do ESTOQUE_PECAS

    -- ========== VALORES E PREÇOS (BALCÃO) ==========
    PB.VAL_UNITARIO,
    PB.VAL_TOTAL,
    PB.VAL_TOTAL_ORIGINAL,                 -- exclusivo do ESTOQUE_PECAS
    PB.VAL_CUSTO,
    PB.VAL_DESPESAS,

    -- ========== DESCONTOS (BALCÃO) ==========
    PB.VAL_DESCONTO,
    PB.PER_DESCONTO,

    -- ========== FISCAL DO BALCÃO ==========
    PB.BASE_ICMS,                          -- exclusivo do ESTOQUE_PECAS
    PB.VALOR_ICMS,                         -- exclusivo do ESTOQUE_PECAS
    PB.VAL_OUTROS,                         -- exclusivo do ESTOQUE_PECAS

    -- ========== BALCÃO — IDENTIFICAÇÃO ADICIONAL ==========
    PB.ITEM_ESTOQUE_PUB_PAF,               -- exclusivo do ESTOQUE_PECAS

    -- ========== INFORMAÇÕES COMERCIAIS (BALCÃO) ==========
    PB.TIPO_VENDA,
    PB.TIPO_TRANSACAO,
    PB.SITUACAO                            AS SITUACAO_BALCAO,
    PB.RENTABILIDADE,

    -- ========== FLAG ÚLTIMO MOVIMENTO (HISTORICO_BALCAO) ==========
    CASE
        WHEN PB.ATENDE_BALCAO = (
            SELECT MAX(PB2.ATENDE_BALCAO)
            FROM CNP.PEC_PECA_BALCAO PB2
            WHERE PB2.EMPRESA      = PB.EMPRESA
              AND PB2.REVENDA      = PB.REVENDA
              AND PB2.ITEM_ESTOQUE = PB.ITEM_ESTOQUE
        ) THEN 'S'
        ELSE 'N'
    END                                    AS FLAG_ULTIMO_MOVIMENTO

FROM
    CNP.PEC_PECA_BALCAO PB

    INNER JOIN CNP.PEC_ITEM_ESTOQUE IE
           ON IE.EMPRESA      = PB.EMPRESA
          AND IE.ITEM_ESTOQUE = PB.ITEM_ESTOQUE

    LEFT JOIN CNP.NIS_ITEM_ESTOQUE NIE
           ON NIE.EMPRESA      = IE.EMPRESA
          AND NIE.ITEM_ESTOQUE = IE.ITEM_ESTOQUE

    LEFT JOIN CNP.PEC_ITEM_REVENDA PIJ
           ON PIJ.EMPRESA      = IE.EMPRESA
          AND PIJ.ITEM_ESTOQUE = IE.ITEM_ESTOQUE
          AND PIJ.REVENDA      = PB.REVENDA

    LEFT JOIN CNP.PEC_GRUPO_DESCONTO PGD
           ON PGD.EMPRESA        = IE.EMPRESA
          AND PGD.GRUPO_DESCONTO = IE.GRUPO_DESCONTO

    LEFT JOIN CNP.PEC_GRUPO PGR
           ON PGR.MARCA = IE.MARCA
          AND PGR.GRUPO = IE.GRUPO;