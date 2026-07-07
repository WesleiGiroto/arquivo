-- ========================================
-- VIEW: VW_BI_OS_PECAS
-- Descrição: Peças aplicadas nas Ordens de Serviço
--            Contém produto, quantidade, valores e vendedor
--            1 linha por peça da OS
-- ========================================
CREATE OR REPLACE VIEW V_PBI_OS_PECAS AS
SELECT

-- ========================================
-- CHAVES PRINCIPAIS
-- ========================================
    POS.EMPRESA,
    POS.REVENDA,
     
-- ========================================
-- CHAVE RELACIONAMENTO VENDEDOR BI
-- ========================================
    TO_CHAR(OS.EMPRESA)||' - '||TO_CHAR(OS.REVENDA) CHAVE_EMP_REV,
  
  TO_CHAR(OS.EMPRESA)||' - '||TO_CHAR(OS.REVENDA)||' - '||TO_CHAR(OS.NRO_OS) CHAVE_EMP_REV_NRO_OS,
  
  TO_CHAR(POS.EMPRESA)||' - '||TO_CHAR(POS.REVENDA)||' - '||TO_CHAR(AT.VENDEDOR)
        CHAVE_EMP_REV_VENDEDOR,  
        
   POS.NRO_OS,
   POS.NRO_LANCAMENTO, 
-- ========================================
-- DADOS DA PEÇA
-- ========================================
   
    POS.DESCRICAO,
    POS.QUANTIDADE,
    POS.VAL_UNITARIO,
    POS.VAL_DESCONTO,

-- ========================================
-- CONSULTOR / VENDEDOR OFICINA
-- ========================================
    AT.VENDEDOR COD_VENDEDOR,

-- ========================================
-- VALOR TOTAL DA PEÇA
-- ========================================
    (POS.QUANTIDADE*POS.VAL_UNITARIO) VAL_TOTAL_PECA

FROM CNP.OFI_PECA_OS POS

-- ========================================
-- JOIN: ORDEM DE SERVIÇO (PEGAR CONTATO)
-- ========================================
LEFT JOIN CNP.OFI_ORDEM_SERVICO OS
 ON OS.EMPRESA = POS.EMPRESA
AND OS.REVENDA = POS.REVENDA
AND OS.NRO_OS = POS.NRO_OS

-- ========================================
-- JOIN: ATENDIMENTO (PEGAR VENDEDOR)
-- ========================================
LEFT JOIN CNP.OFI_ATENDIMENTO AT
 ON AT.EMPRESA = OS.EMPRESA
AND AT.REVENDA = OS.REVENDA
AND AT.CONTATO = OS.CONTATO;
