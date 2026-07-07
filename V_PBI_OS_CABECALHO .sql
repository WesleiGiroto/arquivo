-- ========================================
-- VIEW: VW_BI_OS_CABECALHO
-- Descrição: Cabeçalho das Ordens de Serviço para BI pós-venda
--            Contém dados da OS, cliente, veículo, vendedor e totais financeiros
--            1 linha por OS
-- ========================================
CREATE OR REPLACE VIEW V_PBI_OS_CABECALHO AS
SELECT 

-- ========================================
-- DADOS PRINCIPAIS DA OS
-- ========================================
    OS.EMPRESA,
    OS.REVENDA,
    OS.NRO_OS,

-- ========================================
-- CHAVES DE RELACIONAMENTO BI
-- ========================================
    TO_CHAR(OS.EMPRESA)||' - '||TO_CHAR(OS.REVENDA) CHAVE_EMP_REV,
	
	TO_CHAR(OS.EMPRESA)||' - '||TO_CHAR(OS.REVENDA)||' - '||TO_CHAR(OS.NRO_OS) CHAVE_EMP_REV_NRO_OS,

    TO_CHAR(OS.EMPRESA)||' - '||TO_CHAR(OS.REVENDA)||' - '||TO_CHAR(AT.VENDEDOR)
        CHAVE_EMP_REV_VENDEDOR,

    /*TO_CHAR(OS.EMPRESA)||' - '||TO_CHAR(OS.REVENDA)||' - '||TO_CHAR(OS.USUARIO)
        CHAVE_EMP_REV_USUARIO,*/
    
	OS.DTA_EMISSAO,
    COALESCE(OS.DTA_HORA_ENCERRAMENTO, OS.DTA_ENCERRAMENTO) DTA_ENCERRAMENTO,
    OS.SITUACAO_OS,
    OS.CONTATO,
-- ========================================
-- DADOS DO VENDEDOR / CONSULTOR OFICINA
-- ========================================
    AT.VENDEDOR COD_VENDEDOR,
    AT.PLACA,
    AT.CHASSI,

-- ========================================
-- DADOS CLIENTE E VEÍCULO
-- ========================================
    CLI.NOME CLIENTE_NOME,
    VM.DES_MODELO,
    VF.MARCA,

-- ========================================
-- INFORMAÇÕES COMPLEMENTARES
-- ========================================
    OS.KILOMETRAGEM,
    OS.TEM_CONTRATO,
    OS.AGREGA_DESAGREGA,

-- ========================================
-- TOTAIS FINANCEIROS DA OS
-- ========================================
    NVL(PECAS.TOT_PECAS,0) TOT_PECAS,
    NVL(SERV.TOT_SERVICOS,0) TOT_SERVICOS,
    NVL(PECAS.TOT_PECAS,0)+NVL(SERV.TOT_SERVICOS,0) TOT_OS

FROM CNP.OFI_ORDEM_SERVICO OS

-- ========================================
-- JOIN: ATENDIMENTO (CONSULTOR / VEÍCULO)
-- ========================================
LEFT JOIN CNP.OFI_ATENDIMENTO AT
   ON AT.EMPRESA = OS.EMPRESA
  AND AT.REVENDA = OS.REVENDA
  AND AT.CONTATO = OS.CONTATO

-- ========================================
-- JOIN: CONTATO → CLIENTE
-- ========================================
LEFT JOIN CNP.CAC_CONTATO CC
   ON CC.EMPRESA = OS.EMPRESA
  AND CC.REVENDA = OS.REVENDA
  AND CC.CONTATO = OS.CONTATO

LEFT JOIN CNP.FAT_CLIENTE CLI
   ON CLI.CLIENTE = CC.CLIENTE

-- ========================================
-- JOIN: VEÍCULO / MODELO / MARCA
-- ========================================
LEFT JOIN CNP.OFI_FICHA_SEGUIMENTO OFS
   ON OFS.CHASSI = AT.CHASSI

LEFT JOIN CNP.VEI_MODELO VM
   ON VM.MODELO = OFS.MODELO
  AND VM.EMPRESA = AT.EMPRESA

LEFT JOIN CNP.VEI_FAMILIA VF
   ON VF.FAMILIA = VM.FAMILIA
  AND VF.EMPRESA = VM.EMPRESA

-- ========================================
-- SUBQUERY: TOTAL DE PEÇAS POR OS
-- ========================================
LEFT JOIN (
    SELECT EMPRESA, REVENDA, NRO_OS,
           SUM((QUANTIDADE*VAL_UNITARIO) 
               - NVL(VAL_DESCONTO,0) 
               + NVL(VAL_DESCONTO_FRANQUIA,0)) TOT_PECAS
    FROM CNP.OFI_PECA_OS
    GROUP BY EMPRESA, REVENDA, NRO_OS
) PECAS
 ON PECAS.EMPRESA = OS.EMPRESA
AND PECAS.REVENDA = OS.REVENDA
AND PECAS.NRO_OS  = OS.NRO_OS

-- ========================================
-- SUBQUERY: TOTAL DE SERVIÇOS POR OS
-- ========================================
LEFT JOIN (
    SELECT EMPRESA, REVENDA, NRO_OS,
           SUM((QUANTIDADE*VAL_SERVICO) 
               - NVL(VAL_DESCONTO,0) 
               + NVL(VAL_DESCONTO_FRANQUIA,0)) TOT_SERVICOS
    FROM CNP.OFI_SERVICO_OS
    GROUP BY EMPRESA, REVENDA, NRO_OS
) SERV
 ON SERV.EMPRESA = OS.EMPRESA
AND SERV.REVENDA = OS.REVENDA
AND SERV.NRO_OS  = OS.NRO_OS

-- ========================================
-- FILTRO EMPRESA / REVENDA (PADRÃO BI)
-- ========================================
WHERE OS.EMPRESA IN (1,2,3)
AND OS.REVENDA IN (1,2);
