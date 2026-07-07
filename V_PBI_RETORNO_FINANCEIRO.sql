CREATE OR REPLACE VIEW V_PBI_RETORNO_FINANCEIRO AS
SELECT
   -- Identificação da empresa e revenda
    VP.EMPRESA,
    VP.REVENDA,
    TO_CHAR(VP.EMPRESA) || ' - ' || TO_CHAR(VP.REVENDA)									                 AS CHAVE_EMP_REV,
  	TO_CHAR(VP.EMPRESA) || ' - ' || TO_CHAR(VP.REVENDA) || ' - ' || TO_CHAR(VP.PROPOSTA)   AS CHAVE_EMP_REV_PROPOSTA,

    VR.TIPO_RETORNO,
    VR.OBSERVACAO,

    -- Campos fixos zerados (placeholders para estrutura futura)
    CAST(0 AS NUMERIC)      AS FI_1,
    CAST(0 AS NUMERIC)      AS FI_2,

    -- Identificação da proposta
    VP.PROPOSTA,
    -- Dados do veículo
    VEI.VEICULO,
    -- Informações do vendedor, cliente e financeira
    VEN.NOME                AS VENDEDOR,
    CLI.NOME                AS CLIENTE,
    FIN.NOME                AS FINANCEIRA,
    FIN.CLIENTE             AS CODFINANCEIRA,

    -- Dados da negociação
    NEG.QTD_PARCELAS,
    NEG.NEGOCIACAO,
    NEG.FATOR_PARCELA,

    
   
   -- Valores financeiros zerados (não utilizados nesta query)
    CAST(0 AS NUMERIC)  AS VAL_FINANCIADO,
    CAST(0 AS NUMERIC)  AS VAL_PRESENTE_VENDA,
    -- Comissão
    VR.VAL_RETORNO,
    VR.VAL_COMISSAO

FROM CNP.CAC_CONTATO CAC


-- ============================================================
-- INNER JOIN COM PROPOSTA
-- ============================================================

INNER JOIN CNP.VEI_PROPOSTA VP
    ON  VP.EMPRESA  = CAC.EMPRESA
    AND VP.REVENDA  = CAC.REVENDA
    AND VP.CONTATO  = CAC.CONTATO


-- ============================================================
-- INNER JOIN COM RETORNO FINANCEIRO
-- ============================================================

INNER JOIN CNP.VEI_RETORNO VR
    ON  VR.EMPRESA  = VP.EMPRESA
    AND VR.REVENDA  = VP.REVENDA
    AND VR.PROPOSTA = VP.PROPOSTA


-- ============================================================
-- INNER JOIN COM VENDEDOR
-- ============================================================

INNER JOIN CNP.FAT_VENDEDOR VEN
    ON  VEN.EMPRESA  = VP.EMPRESA
    AND VEN.REVENDA  = VP.REVENDA
    AND VEN.VENDEDOR = VP.VENDEDOR


-- ============================================================
-- INNER JOIN COM NEGOCIACAO FINAL
-- ============================================================

INNER JOIN CNP.VEI_NEGOCIACAO NEG
    ON  NEG.EMPRESA    = VP.EMPRESA
    AND NEG.REVENDA    = VP.REVENDA
    AND NEG.PROPOSTA   = VP.PROPOSTA
    AND NEG.NEGOCIACAO = VP.NEGOCIACAO_FINAL


-- ============================================================
-- LEFT JOIN COM VEICULO
-- ============================================================

LEFT JOIN CNP.VEI_VEICULO VEI
    ON  VEI.EMPRESA = VP.EMPRESA
    AND VEI.VEICULO = VP.VEICULO


-- ============================================================
-- LEFT JOIN COM CLIENTE
-- ============================================================

LEFT JOIN CNP.FAT_CLIENTE CLI
    ON  CLI.CLIENTE = CAC.CLIENTE


-- ============================================================
-- LEFT JOIN COM FINANCEIRA
-- ============================================================

LEFT JOIN CNP.FAT_CLIENTE FIN
    ON  FIN.CLIENTE = VR.CLIENTE


-- ============================================================
-- BLOCO WHERE - FILTROS DE NEGOCIO
-- ============================================================

WHERE
    -- Situação da proposta
    VP.SITUACAO IN ('7', '9')

    -- Tipos de retorno considerados
    AND VR.TIPO_RETORNO IN ('3', '9', 'S')

    -- Filtro por empresa e revenda
    AND (
           (VP.EMPRESA = 1 AND VP.REVENDA IN (1, 2))
        OR (VP.EMPRESA = 2 AND VP.REVENDA IN (1))
        OR (VP.EMPRESA = 3 AND VP.REVENDA IN (1))
    );
