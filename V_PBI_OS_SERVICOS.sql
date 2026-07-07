-- ========================================
-- VIEW: VW_BI_OS_SERVICOS
-- Descrição: Serviços executados nas Ordens de Serviço
--            Contém mão de obra, mecânico, valores e vendedor
--            1 linha por serviço da OS
-- ========================================
CREATE OR REPLACE VIEW V_PBI_OS_SERVICOS AS
SELECT 

-- ========================================
-- CHAVES PRINCIPAIS
-- ========================================
    SOS.EMPRESA,
    SOS.REVENDA,
    SOS.NRO_OS,

-- ========================================   
-- CHAVE RELACIONAMENTO VENDEDOR BI
-- ========================================
  TO_CHAR(SOS.EMPRESA)||' - '||TO_CHAR(SOS.REVENDA) CHAVE_EMP_REV,
  
  TO_CHAR(SOS.EMPRESA)||' - '||TO_CHAR(SOS.REVENDA)||' - '||TO_CHAR(SOS.NRO_OS) CHAVE_EMP_REV_NRO_OS,
  
  TO_CHAR(SOS.EMPRESA)||' - '||TO_CHAR(SOS.REVENDA)||' - '||TO_CHAR(AT.VENDEDOR)
        CHAVE_EMP_REV_VENDEDOR,
    
-- ========================================
-- DADOS DO SERVIÇO
-- ========================================
    SOS.NRO_LANCAMENTO,
	SOS.SERVICO,
    SOS.DESCRICAO,
    SOS.QUANTIDADE,
    SOS.VAL_SERVICO,
    SOS.VAL_DESCONTO,
    SOS.MECANICO,

-- ========================================
-- CONSULTOR / VENDEDOR OFICINA
-- ========================================
    AT.VENDEDOR COD_VENDEDOR,

-- ========================================
-- INFORMAÇÕES TÉCNICAS DO SERVIÇO
-- ========================================
    SERV.MAODEOBRA,
    MO.DES_RESUMIDA MAO_OBRA_DESC,
    TIPO.TIPO_SERVICO_OS,
    MEC.NOME MECANICO_NOME,

-- ========================================
-- VALOR TOTAL DO SERVIÇO
-- ========================================
    (SOS.VAL_SERVICO*SOS.QUANTIDADE) VAL_TOTAL_SERVICO

FROM CNP.OFI_SERVICO_OS SOS

-- ========================================
-- JOIN: ATENDIMENTO (VENDEDOR)
-- ========================================
LEFT JOIN CNP.OFI_ATENDIMENTO AT
 ON AT.EMPRESA = SOS.EMPRESA
AND AT.REVENDA = SOS.REVENDA
AND AT.CONTATO = SOS.CONTATO

-- ========================================
-- JOIN: CADASTRO SERVIÇO
-- ========================================
LEFT JOIN CNP.OFI_SERVICO SERV
 ON SERV.EMPRESA = SOS.EMPRESA
AND SERV.SERVICO = SOS.SERVICO

-- ========================================
-- JOIN: MÃO DE OBRA
-- ========================================
LEFT JOIN CNP.OFI_MAODEOBRA MO
 ON MO.EMPRESA = SERV.EMPRESA
AND MO.MAODEOBRA = SERV.MAODEOBRA

-- ========================================
-- JOIN: TIPO SERVIÇO
-- ========================================
LEFT JOIN CNP.OFI_TIPO_SERVICO TIPO
 ON TIPO.EMPRESA = SOS.EMPRESA
AND TIPO.REVENDA = SOS.REVENDA
AND TIPO.TIPO_SERVICO = SOS.TIPO_SERVICO

-- ========================================
-- JOIN: MECÂNICO
-- ========================================
LEFT JOIN CNP.OFI_MECANICO MEC
 ON MEC.EMPRESA = SOS.EMPRESA
AND MEC.REVENDA = SOS.REVENDA
AND MEC.MECANICO = SOS.MECANICO;
