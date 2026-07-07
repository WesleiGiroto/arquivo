-- ========================================
-- Query 1: Consulta principal de Ordem de Serviço
-- Descrição: Busca completa de ordens de serviço com valores de peças, serviços, franquia e informações de cliente/veículo
-- ========================================
SELECT 
    OS.EMPRESA, 
    OS.REVENDA, 
    OS.TEM_CONTRATO, 
    OS.NRO_OS, 
    JUN.PEDIDO, 
    OS.DTA_EMISSAO, 
    COALESCE(OS.DTA_HORA_ENCERRAMENTO, OS.DTA_ENCERRAMENTO) DTA_ENCERRAMENTO, 
    OS.SITUACAO_OS, 
    OS.SITUACAO_LANCAMENTO, 
    OS.DTA_FIM_FRANQUIA, 
    OS.KILOMETRAGEM, 
    OS.KM_ELETRICA, 
    OS.NIVEL_BATERIA, 
    OS.NF_REFERENCIAL_NOTA, 
    OS.NF_REFERENCIAL_SERIE, 
    OS.NF_REFERENCIAL_TRANSACAO, 
    OS.NF_REFERENCIAL_CONTADOR, 
    OS.NF_REFERENCIAL_CHAVE_ACESSO, 
    OS.CONTATO, 
    ATENDE.PLACA, 
    ATENDE.CHASSI, 
    ATENDE.CLIENTE_EMISSAO_NF, 
    ATENDE.SEGURADORA, 
    ATENDE.CLIENTE_FATURAMENTO, 
    ATENDE.DEPARTAMENTO, 
    ATENDE.POLITICA_PRECO, 
    CLIENTE.CLIENTE, 
    ATENDE.CLIENTE_EMISSAO_NF_S, 
    ATENDE.CLIENTE_FATURAMENTO_S, 
    CLIENTE.NOME, 
    CASE OS.SERVICO_EXTERNO 
        WHEN 0 THEN '' 
        WHEN 1 THEN 'A' 
        WHEN 8 THEN 'A' 
        WHEN 9 THEN 'F' 
    END AS SERVICO_EXTERNO_SIT,
    OS.SERVICO_EXTERNO, 
    OS.DTA_FIM_EXTERNO, 
    CASE OS.SERVICO_INTERNO 
        WHEN 0 THEN '' 
        WHEN 1 THEN 'A' 
        WHEN 8 THEN 'A' 
        WHEN 9 THEN 'F' 
    END AS SERVICO_INTERNO_SIT, 
    OS.SERVICO_INTERNO, 
    OS.DTA_FIM_INTERNO, 
    CASE OS.SERVICO_GARANTIA 
        WHEN 0 THEN '' 
        WHEN 1 THEN 'A' 
        WHEN 8 THEN 'A' 
        WHEN 9 THEN 'F' 
    END AS SERVICO_GARANTIA_SIT, 
    OS.SERVICO_GARANTIA, 
    OS.DTA_FIM_GARANTIA, 
    CASE OS.SERVICO_REVISAO 
        WHEN 0 THEN '' 
        WHEN 1 THEN 'A' 
        WHEN 8 THEN 'A' 
        WHEN 9 THEN 'F' 
    END AS SERVICO_REVISAO_SIT, 
    OS.SERVICO_REVISAO, 
    OS.DTA_FIM_REVISAO, 
    CASE COALESCE(OS.SERVICO_PMS_SCANIA, 0) 
        WHEN 0 THEN '' 
        WHEN 1 THEN 'A' 
        WHEN 7 THEN 'A' 
        WHEN 8 THEN 'A' 
        WHEN 9 THEN 'F' 
    END AS SERVICO_PMS_SCANIA_SIT, 
    OS.SERVICO_PMS_SCANIA, 
    OS.DTA_FIM_PMS_SCANIA, 
    OS.VAL_FRANQUIA, 
    OS.DESCONTO_FRANQUIA, 
    CAST((COALESCE(OS.VAL_FRANQUIA, 0) - COALESCE(OS.DESCONTO_FRANQUIA, 0)) AS NUMERIC(17, 2)) DESC_FRANQUIA, 
    ((SELECT 
          COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
      FROM 
          CNP.OFI_PECA_OS POS, 
          CNP.OFI_TIPO_SERVICO TS 
      WHERE 
          POS.EMPRESA = OS.EMPRESA 
          AND POS.REVENDA = OS.REVENDA 
          AND POS.NRO_OS = OS.NRO_OS 
          AND TS.EMPRESA = POS.EMPRESA 
          AND TS.REVENDA = POS.REVENDA 
          AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
          AND TS.TIPO_SERVICO_OS = 'E') 
     + (SELECT 
            COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
        FROM 
            CNP.OFI_SERVICO_OS SOS, 
            CNP.OFI_TIPO_SERVICO TS 
        WHERE 
            SOS.EMPRESA = OS.EMPRESA 
            AND SOS.REVENDA = OS.REVENDA 
            AND SOS.NRO_OS = OS.NRO_OS 
            AND TS.EMPRESA = SOS.EMPRESA 
            AND TS.REVENDA = SOS.REVENDA 
            AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
            AND TS.TIPO_SERVICO_OS = 'E')) VLR_EXTERNO, 
    (SELECT 
         COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_PECA_OS POS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         POS.EMPRESA = OS.EMPRESA 
         AND POS.REVENDA = OS.REVENDA 
         AND POS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = POS.EMPRESA 
         AND TS.REVENDA = POS.REVENDA 
         AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'E') VLR_EXTERNO_PECA, 
    (SELECT 
         COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_SERVICO_OS SOS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         SOS.EMPRESA = OS.EMPRESA 
         AND SOS.REVENDA = OS.REVENDA 
         AND SOS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = SOS.EMPRESA 
         AND TS.REVENDA = SOS.REVENDA 
         AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'E') VLR_EXTERNO_SERVICO, 
    ((SELECT 
          COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
      FROM 
          CNP.OFI_PECA_OS POS, 
          CNP.OFI_TIPO_SERVICO TS 
      WHERE 
          POS.EMPRESA = OS.EMPRESA 
          AND POS.REVENDA = OS.REVENDA 
          AND POS.NRO_OS = OS.NRO_OS 
          AND TS.EMPRESA = POS.EMPRESA 
          AND TS.REVENDA = POS.REVENDA 
          AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
          AND TS.TIPO_SERVICO_OS = 'I') 
     + (SELECT 
            COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
        FROM 
            CNP.OFI_SERVICO_OS SOS, 
            CNP.OFI_TIPO_SERVICO TS 
        WHERE 
            SOS.EMPRESA = OS.EMPRESA 
            AND SOS.REVENDA = OS.REVENDA 
            AND SOS.NRO_OS = OS.NRO_OS 
            AND TS.EMPRESA = SOS.EMPRESA 
            AND TS.REVENDA = SOS.REVENDA 
            AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
            AND TS.TIPO_SERVICO_OS = 'I')) VLR_INTERNO, 
    (SELECT 
         COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_PECA_OS POS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         POS.EMPRESA = OS.EMPRESA 
         AND POS.REVENDA = OS.REVENDA 
         AND POS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = POS.EMPRESA 
         AND TS.REVENDA = POS.REVENDA 
         AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'I') VLR_INTERNO_PECA, 
    (SELECT 
         COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_SERVICO_OS SOS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         SOS.EMPRESA = OS.EMPRESA 
         AND SOS.REVENDA = OS.REVENDA 
         AND SOS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = SOS.EMPRESA 
         AND TS.REVENDA = SOS.REVENDA 
         AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'I') VLR_INTERNO_SERVICO, 
    ((SELECT 
          COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
      FROM 
          CNP.OFI_PECA_OS POS, 
          CNP.OFI_TIPO_SERVICO TS 
      WHERE 
          POS.EMPRESA = OS.EMPRESA 
          AND POS.REVENDA = OS.REVENDA 
          AND POS.NRO_OS = OS.NRO_OS 
          AND TS.EMPRESA = POS.EMPRESA 
          AND TS.REVENDA = POS.REVENDA 
          AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
          AND TS.TIPO_SERVICO_OS = 'R') 
     + (SELECT 
            COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
        FROM 
            CNP.OFI_SERVICO_OS SOS, 
            CNP.OFI_TIPO_SERVICO TS 
        WHERE 
            SOS.EMPRESA = OS.EMPRESA 
            AND SOS.REVENDA = OS.REVENDA 
            AND SOS.NRO_OS = OS.NRO_OS 
            AND TS.EMPRESA = SOS.EMPRESA 
            AND TS.REVENDA = SOS.REVENDA 
            AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
            AND TS.TIPO_SERVICO_OS = 'R')) VLR_REVISAO, 
    (SELECT 
         COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_PECA_OS POS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         POS.EMPRESA = OS.EMPRESA 
         AND POS.REVENDA = OS.REVENDA 
         AND POS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = POS.EMPRESA 
         AND TS.REVENDA = POS.REVENDA 
         AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'R') VLR_REVICAO_PECA, 
    (SELECT 
         COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_SERVICO_OS SOS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         SOS.EMPRESA = OS.EMPRESA 
         AND SOS.REVENDA = OS.REVENDA 
         AND SOS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = SOS.EMPRESA 
         AND TS.REVENDA = SOS.REVENDA 
         AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'R') VLR_REVISAO_SERVICO, 
    ((SELECT 
          COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
      FROM 
          CNP.OFI_PECA_OS POS, 
          CNP.OFI_TIPO_SERVICO TS 
      WHERE 
          POS.EMPRESA = OS.EMPRESA 
          AND POS.REVENDA = OS.REVENDA 
          AND POS.NRO_OS = OS.NRO_OS 
          AND TS.EMPRESA = POS.EMPRESA 
          AND TS.REVENDA = POS.REVENDA 
          AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
          AND TS.TIPO_SERVICO_OS = 'G') 
     + (SELECT 
            COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
        FROM 
            CNP.OFI_SERVICO_OS SOS, 
            CNP.OFI_TIPO_SERVICO TS 
        WHERE 
            SOS.EMPRESA = OS.EMPRESA 
            AND SOS.REVENDA = OS.REVENDA 
            AND SOS.NRO_OS = OS.NRO_OS 
            AND TS.EMPRESA = SOS.EMPRESA 
            AND TS.REVENDA = SOS.REVENDA 
            AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
            AND TS.TIPO_SERVICO_OS = 'G')) VLR_GARANTIA, 
    (SELECT 
         COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_PECA_OS POS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         POS.EMPRESA = OS.EMPRESA 
         AND POS.REVENDA = OS.REVENDA 
         AND POS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = POS.EMPRESA 
         AND TS.REVENDA = POS.REVENDA 
         AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'G') VLR_GARANTIA_PECA, 
    (SELECT 
         COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_SERVICO_OS SOS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         SOS.EMPRESA = OS.EMPRESA 
         AND SOS.REVENDA = OS.REVENDA 
         AND SOS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = SOS.EMPRESA 
         AND TS.REVENDA = SOS.REVENDA 
         AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'G') VLR_GARANTIA_SERVICO, 
    ((SELECT 
          COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
      FROM 
          CNP.OFI_PECA_OS POS, 
          CNP.OFI_TIPO_SERVICO TS 
      WHERE 
          POS.EMPRESA = OS.EMPRESA 
          AND POS.REVENDA = OS.REVENDA 
          AND POS.NRO_OS = OS.NRO_OS 
          AND TS.EMPRESA = POS.EMPRESA 
          AND TS.REVENDA = POS.REVENDA 
          AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
          AND TS.TIPO_SERVICO_OS = 'C') 
     + (SELECT 
            COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
        FROM 
            CNP.OFI_SERVICO_OS SOS, 
            CNP.OFI_TIPO_SERVICO TS 
        WHERE 
            SOS.EMPRESA = OS.EMPRESA 
            AND SOS.REVENDA = OS.REVENDA 
            AND SOS.NRO_OS = OS.NRO_OS 
            AND TS.EMPRESA = SOS.EMPRESA 
            AND TS.REVENDA = SOS.REVENDA 
            AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
            AND TS.TIPO_SERVICO_OS = 'C')) VLR_PMS_SCANIA, 
    (SELECT 
         COALESCE(SUM(CAST((POS.QUANTIDADE * POS.VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(POS.VAL_DESCONTO, 0)) + COALESCE(POS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_PECA_OS POS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         POS.EMPRESA = OS.EMPRESA 
         AND POS.REVENDA = OS.REVENDA 
         AND POS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = POS.EMPRESA 
         AND TS.REVENDA = POS.REVENDA 
         AND TS.TIPO_SERVICO = POS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'C') VLR_PMS_SCANIA_PECA, 
    (SELECT 
         COALESCE(SUM(CAST((SOS.QUANTIDADE * SOS.VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(SOS.VAL_DESCONTO, 0)) + COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)), 0) 
     FROM 
         CNP.OFI_SERVICO_OS SOS, 
         CNP.OFI_TIPO_SERVICO TS 
     WHERE 
         SOS.EMPRESA = OS.EMPRESA 
         AND SOS.REVENDA = OS.REVENDA 
         AND SOS.NRO_OS = OS.NRO_OS 
         AND TS.EMPRESA = SOS.EMPRESA 
         AND TS.REVENDA = SOS.REVENDA 
         AND TS.TIPO_SERVICO = SOS.TIPO_SERVICO 
         AND TS.TIPO_SERVICO_OS = 'C') VLR_PMS_SCANIA_SERVICO, 
    (SELECT 
         SUM(CAST((QUANTIDADE * VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(VAL_DESCONTO, 0)) + COALESCE(VAL_DESCONTO_FRANQUIA, 0)) 
     FROM 
         CNP.OFI_PECA_OS 
     WHERE 
         EMPRESA = OS.EMPRESA 
         AND REVENDA = OS.REVENDA 
         AND NRO_OS = OS.NRO_OS) TOT_PECAS, 
    (SELECT 
         SUM(CAST((QUANTIDADE * VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(VAL_DESCONTO, 0)) + COALESCE(VAL_DESCONTO_FRANQUIA, 0)) 
     FROM 
         CNP.OFI_SERVICO_OS 
     WHERE 
         EMPRESA = OS.EMPRESA 
         AND REVENDA = OS.REVENDA 
         AND NRO_OS = OS.NRO_OS) TOT_SERVICOS, 
    ((SELECT 
          COALESCE(SUM(CAST((QUANTIDADE * VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(VAL_DESCONTO, 0)) + COALESCE(VAL_DESCONTO_FRANQUIA, 0)), 0) 
      FROM 
          CNP.OFI_PECA_OS 
      WHERE 
          EMPRESA = OS.EMPRESA 
          AND REVENDA = OS.REVENDA 
          AND NRO_OS = OS.NRO_OS) 
     + (SELECT 
            COALESCE(SUM(CAST((QUANTIDADE * VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(VAL_DESCONTO, 0)) + COALESCE(VAL_DESCONTO_FRANQUIA, 0)), 0) 
        FROM 
            CNP.OFI_SERVICO_OS 
        WHERE 
            EMPRESA = OS.EMPRESA 
            AND REVENDA = OS.REVENDA 
            AND NRO_OS = OS.NRO_OS)) TOT_OS, 
    ((SELECT 
          COALESCE(SUM(CAST((QUANTIDADE * VAL_UNITARIO) AS NUMERIC(17, 2)) - (COALESCE(VAL_DESCONTO, 0))), 0) 
      FROM 
          CNP.OFI_PECA_OS 
      WHERE 
          EMPRESA = OS.EMPRESA 
          AND REVENDA = OS.REVENDA 
          AND NRO_OS = OS.NRO_OS) 
     + (SELECT 
            COALESCE(SUM(CAST((QUANTIDADE * VAL_SERVICO) AS NUMERIC(17, 2)) - (COALESCE(VAL_DESCONTO, 0))), 0) 
        FROM 
            CNP.OFI_SERVICO_OS 
        WHERE 
            EMPRESA = OS.EMPRESA 
            AND REVENDA = OS.REVENDA 
            AND NRO_OS = OS.NRO_OS)) TOTAL_LIQUIDO, 
  /*  CASE 
        WHEN OS.SITUACAO_OS IN (0, 1) THEN (TO_DATE('06/02/2026', 'dd/mm/yyyy') - TO_DATE(TO_CHAR(OS.DTA_EMISSAO, 'DD/MM/YYYY'), 'DD/MM/YYYY')) 
        ELSE 0 
    END NRO_DIAS,*/ 
    (SELECT 
         DES_CATEGORIA 
     FROM 
         CNP.OFI_CATEGORIA_OS 
     WHERE 
         EMPRESA = OS.EMPRESA 
         AND REVENDA = OS.REVENDA 
         AND CATEGORIA_OS = OS.CATEGORIA_OS) DES_CATEGORIA, 
    OS.CATEGORIA_OS, 
    CASE 
        WHEN (PAR.DIAS_VENCIMENTO_OS_E > 0 AND OS.SERVICO_EXTERNO > 0) THEN OS.DTA_EMISSAO + PAR.DIAS_VENCIMENTO_OS_E 
        ELSE NULL 
    END VENCIMENTO_OS_E, 
    (SELECT 
         US.LOGIN 
     FROM 
         CNP.GER_USUARIO US 
     WHERE 
         US.USUARIO = OS.USUARIO_AUTORIZANTE_OS_E) AUTORIZANTE_OS_E, 
    CASE 
        WHEN (PAR.DIAS_VENCIMENTO_OS_I > 0 AND OS.SERVICO_INTERNO > 0) THEN OS.DTA_EMISSAO + PAR.DIAS_VENCIMENTO_OS_I 
        ELSE NULL 
    END VENCIMENTO_OS_I, 
    (SELECT 
         US.LOGIN 
     FROM 
         CNP.GER_USUARIO US 
     WHERE 
         US.USUARIO = OS.USUARIO_AUTORIZANTE_OS_I) AUTORIZANTE_OS_I, 
    CASE 
        WHEN (PAR.DIAS_VENCIMENTO_OS_G > 0 AND OS.SERVICO_GARANTIA > 0) THEN OS.DTA_EMISSAO + PAR.DIAS_VENCIMENTO_OS_G 
        ELSE NULL 
    END VENCIMENTO_OS_G, 
    (SELECT 
         US.LOGIN 
     FROM 
         CNP.GER_USUARIO US 
     WHERE 
         US.USUARIO = OS.USUARIO_AUTORIZANTE_OS_G) AUTORIZANTE_OS_G, 
    CASE 
        WHEN (PAR.DIAS_VENCIMENTO_OS_R > 0 AND OS.SERVICO_REVISAO > 0) THEN OS.DTA_EMISSAO + PAR.DIAS_VENCIMENTO_OS_R 
        ELSE NULL 
    END VENCIMENTO_OS_R, 
    (SELECT 
         US.LOGIN 
     FROM 
         CNP.GER_USUARIO US 
     WHERE 
         US.USUARIO = OS.USUARIO_AUTORIZANTE_OS_R) AUTORIZANTE_OS_R, 
    CASE 
        WHEN (PAR.DIAS_VENCIMENTO_OS_G > 0 AND OS.SERVICO_PMS_SCANIA > 0) THEN OS.DTA_EMISSAO + PAR.DIAS_VENCIMENTO_OS_G 
        ELSE NULL 
    END VENCIMENTO_OS_PMS, 
    (SELECT 
         US.LOGIN 
     FROM 
         CNP.GER_USUARIO US 
     WHERE 
         US.USUARIO = OS.USUARIO_AUTORIZANTE_OS_PMS_SCA) AUTORIZANTE_OS_PMS_SCA, 
    VM.DES_MODELO,   
    VF.MARCA, 
    OS.AGREGA_DESAGREGA
FROM 
    CNP.OFI_ORDEM_SERVICO OS
    INNER JOIN (
        SELECT 
            EMPRESA, 
            REVENDA, 
            CONTATO, 
            CHASSI, 
            CLIENTE_FATURAMENTO_S, 
            CLIENTE_EMISSAO_NF_S, 
            CLIENTE_EMISSAO_NF, 
            POLITICA_PRECO, 
            DEPARTAMENTO, 
            CLIENTE_FATURAMENTO, 
            SEGURADORA, 
            VENDEDOR, 
            PLACA 
        FROM 
            CNP.OFI_ATENDIMENTO
    ) ATENDE ON OS.EMPRESA = ATENDE.EMPRESA 
        AND OS.REVENDA = ATENDE.REVENDA 
        AND OS.CONTATO = ATENDE.CONTATO
    INNER JOIN (
        SELECT 
            EMPRESA, 
            REVENDA, 
            DIAS_VENCIMENTO_OS_R, 
            DIAS_VENCIMENTO_OS_G, 
            DIAS_VENCIMENTO_OS_I, 
            DIAS_VENCIMENTO_OS_E 
        FROM 
            CNP.OFI_PARAMETRO
    ) PAR ON PAR.EMPRESA = OS.EMPRESA 
        AND PAR.REVENDA = OS.REVENDA
    INNER JOIN (
        SELECT 
            EMPRESA, 
            REVENDA, 
            CONTATO, 
            CLIENTE 
        FROM 
            CNP.CAC_CONTATO
    ) CONTATO ON CONTATO.EMPRESA = OS.EMPRESA 
        AND CONTATO.REVENDA = OS.REVENDA 
        AND CONTATO.CONTATO = OS.CONTATO
    INNER JOIN (
        SELECT 
            CLIENTE, 
            NOME 
        FROM 
            CNP.FAT_CLIENTE
    ) CLIENTE ON CLIENTE.CLIENTE = CONTATO.CLIENTE
    INNER JOIN (
        SELECT 
            CHASSI, 
            MODELO 
        FROM 
            CNP.OFI_FICHA_SEGUIMENTO
    ) OFS ON OFS.CHASSI = ATENDE.CHASSI
    LEFT JOIN (
        SELECT 
            VM.DES_MODELO, 
            VM.MODELO, 
            VM.FAMILIA, 
            VM.EMPRESA 
        FROM 
            CNP.VEI_MODELO VM
    ) VM ON (VM.EMPRESA = ATENDE.EMPRESA 
        AND VM.MODELO = OFS.MODELO)
    LEFT JOIN (
        SELECT 
            VF.FAMILIA, 
            VF.MARCA, 
            VF.EMPRESA 
        FROM 
            CNP.VEI_FAMILIA VF
    ) VF ON (VF.EMPRESA = VM.EMPRESA 
        AND VF.FAMILIA = VM.FAMILIA)
    LEFT OUTER JOIN (
        SELECT 
            MAX(PEDIDO) PEDIDO, 
            EMPRESA, 
            REVENDA, 
            NRO_OS 
        FROM 
            CNP.JUN_PEDIDO_CAPA 
        GROUP BY 
            EMPRESA, 
            REVENDA, 
            NRO_OS
    ) JUN ON (JUN.EMPRESA = OS.EMPRESA 
        AND JUN.REVENDA = OS.REVENDA 
        AND JUN.NRO_OS = OS.NRO_OS)
WHERE 
    OS.EMPRESA in (1,2,3) 
    AND OS.REVENDA in (1,2) 
 
ORDER BY 
    OS.NRO_OS;

-- ========================================
-- Query 2: Buscar serviços da ordem de serviço com detalhes completos
-- Descrição: Retorna todos os serviços da OS incluindo mão de obra, valores, mecânico e requisições
-- ========================================
SELECT 
    SOS.*, 
    SERV.MODELO_SERVICO, 
    SERV.MAODEOBRA, 
    SERV.DETALHAMENTO_ENGENHARIA, 
    SERV.ADICIONAL_SERVICO, 
    MO.DES_RESUMIDA, 
    TIPO.TIPO_SERVICO_OS, 
    MEC.NOME, 
    SOL.NRO_ORCAMENTO, 
    OPP.DES_POLITICA, 
    CAST((SOS.VAL_DESCONTO - COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)) AS NUMERIC(11, 2)) VAL_DESCONTO_REAL, 
    REQ.NRO_REQUISICAO_SERV, 
    REQ.VALOR_CUSTO, 
    CASE REQ.SITUACAO 
        WHEN 'P' THEN 'Pendente' 
        WHEN 'D' THEN 'Serviço Deletado' 
        WHEN 'A' THEN 'Aprovada' 
        WHEN 'F' THEN 'Nota Faturada' 
        WHEN 'N' THEN 'Reprovada' 
        ELSE '' 
    END DESCRICAO_SITUACAO, 
    CASE SOS.TIPO_REQUISICAO 
        WHEN 2 THEN 'SIM' 
        ELSE 'NÃO' 
    END SERVICO_TERCEIRO, 
    SOL.GAR_RECALL_FCA, 
    SOL.SOLICITACAO_SERV_PADRAO, 
    CASE 
        WHEN SOL.SOLICITACAO_SERV_PADRAO = 'S' THEN COALESCE(MO.DES_RESUMIDA, SOS.DESCRICAO) 
        ELSE SOS.DESCRICAO 
    END CONCAT_DES, 
    SOL.PSA_FF_TIPO 
FROM 
    CNP.OFI_SERVICO_OS SOS
    INNER JOIN CNP.OFI_SERVICO SERV ON (SERV.EMPRESA = SOS.EMPRESA 
        AND SERV.SERVICO = SOS.SERVICO)
    INNER JOIN CNP.OFI_MAODEOBRA MO ON (MO.EMPRESA = SERV.EMPRESA 
        AND MO.MAODEOBRA = SERV.MAODEOBRA)
    INNER JOIN CNP.OFI_TIPO_SERVICO TIPO ON (TIPO.EMPRESA = SOS.EMPRESA 
        AND TIPO.REVENDA = SOS.REVENDA 
        AND TIPO.TIPO_SERVICO = SOS.TIPO_SERVICO)
    LEFT OUTER JOIN CNP.OFI_MECANICO MEC ON (MEC.EMPRESA = SOS.EMPRESA 
        AND MEC.REVENDA = SOS.REVENDA 
        AND MEC.MECANICO = SOS.MECANICO)
    INNER JOIN CNP.OFI_SOLICITACAO SOL ON (SOL.EMPRESA = SOS.EMPRESA 
        AND SOL.REVENDA = SOS.REVENDA 
        AND SOL.CONTATO = SOS.CONTATO 
        AND SOL.NRO_SOLICITACAO = SOS.NRO_SOLICITACAO)
    LEFT JOIN CNP.OFI_REQUISICAO_SERVTERC REQ ON (SOS.EMPRESA = REQ.EMPRESA 
        AND SOS.REVENDA = REQ.REVENDA 
        AND SOS.NRO_OS = REQ.NRO_OS 
        AND SOS.NRO_LANCAMENTO = REQ.NRO_LANCAMENTO), 
    CNP.OFI_ATENDIMENTO OAT, 
    CNP.OFI_POLITICA_PRECO OPP 
WHERE 
    SOS.EMPRESA = 1 
    AND SOS.REVENDA = 1 
    AND OAT.EMPRESA = SOS.EMPRESA 
    AND OAT.REVENDA = SOS.REVENDA 
    AND OAT.CONTATO = SOS.CONTATO 
    AND OAT.EMPRESA = OPP.EMPRESA 
    AND OAT.REVENDA = OPP.REVENDA 
    AND COALESCE(TIPO.POLITICA_PRECO_SERVICOS, OAT.POLITICA_PRECO) = OPP.POLITICA_PRECO 
ORDER BY 
    SOS.NRO_LANCAMENTO;


-- ========================================
-- Query 2: Buscar configuração de grid do usuário
-- Descrição: Retorna a configuração personalizada da grade de visualização de resultados
-- ========================================
SELECT 
    CONFIGURACAO 
FROM 
    CNP.GER_GRID_USUARIO 
WHERE 
    USUARIO = 644 
    AND NOME_UNIT = 'FRAMEMNTORDEMSERVICO' 
    AND NOME_GRID = 'VWRESULTADODBTABLEVIEW1' 
    AND CONTADOR = 0;

-- ========================================
-- Query 3: Verificar mensagens não lidas
-- Descrição: Busca mensagens com situação 'N' (Não lida) para o usuário
-- ========================================
SELECT DISTINCT 
    SITUACAO 
FROM 
    CNP.GER_MENSAGEM 
WHERE 
    USUARIO_DESTINO = 644 
    AND SITUACAO = 'N';

-- ========================================
-- Query 4: Buscar aprovações pendentes do usuário
-- Descrição: Retorna aprovações gerais e de oficina pendentes para o usuário
-- ========================================
SELECT 
    USUARIO_APROV, 
    APROVADO 
FROM 
    CNP.GER_APROVACAO 
WHERE 
    USUARIO_APROV = 644 
    AND APROVADO IS NULL 
    AND (ITEM_PARTNET IS NULL 
        AND ITEM_CUMPAS IS NULL)
UNION
SELECT 
    OA.USUARIO_APROV, 
    OA.APROVADO 
FROM 
    CNP.OFI_APROVACAO OA
    INNER JOIN OFI_DEPARTAMENTO_USUARIO_APROV OAD ON (OAD.EMPRESA = OA.EMPRESA 
        AND OAD.REVENDA = OA.REVENDA 
        AND OAD.DEPARTAMENTO = OA.DEPARTAMENTO 
        AND OAD.USUARIO = 644) 
WHERE 
    OA.APROVADO IS NULL;

-- ========================================
-- Query 5: Verificar solicitações bloqueadas/canceladas do usuário
-- Descrição: Busca aprovações com status 'B' (Bloqueada) ou 'C' (Cancelada) onde o usuário é solicitante
-- ========================================
SELECT 
    APROVADO 
FROM 
    CNP.GER_APROVACAO 
WHERE 
    USUARIO_SOLIC = 644 
    AND APROVADO IN ('B', 'C') 
    AND (ITEM_PARTNET IS NULL 
        AND ITEM_CUMPAS IS NULL) 
    AND FUNCAO IN (
        SELECT 
            FUNCAO 
        FROM 
            CNP.GER_FUNCAO 
        WHERE 
            TRATAMENTO = 'A'
    );

-- ========================================
-- Query 6: Verificar se utiliza controle de qualidade (CQ)
-- Descrição: Retorna parâmetro que indica se o controle de qualidade está ativo
-- ========================================
SELECT 
    UTILIZA_CQ 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 7: Verificar uso de percentual de acréscimo em partilha
-- Descrição: Busca configuração de acréscimo de partilha na revenda
-- ========================================
SELECT 
    USAR_PER_ACRESCIMO_PARTILHA 
FROM 
    GER_REVENDA 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 8: Buscar identificação do departamento do contato
-- Descrição: Retorna a identificação do departamento vinculado ao contato
-- ========================================
SELECT 
    GDP.IDENTIFICACAO 
FROM 
    CNP.CAC_CONTATO CON
    INNER JOIN GER_DEPARTAMENTO GDP ON (CON.EMPRESA = GDP.EMPRESA 
        AND CON.REVENDA = GDP.REVENDA 
        AND GDP.DEPARTAMENTO = CON.DEPARTAMENTO) 
WHERE 
    CON.EMPRESA = 1 
    AND CON.REVENDA = 1 
    AND CON.CONTATO = 804064;

-- ========================================
-- Query 9: Buscar indicador de presença da forma de contato
-- Descrição: Retorna o tipo de indicador de presença configurado nos parâmetros
-- ========================================
SELECT 
    CFC.INDICADOR_PRESENCA 
FROM 
    CNP.CAC_FORMA_CONTATO CFC, 
    CNP.OFI_PARAMETRO PAR 
WHERE 
    PAR.EMPRESA = 1 
    AND PAR.REVENDA = 1 
    AND CFC.EMPRESA = PAR.EMPRESA 
    AND CFC.FORMA_CONTATO = PAR.FORMA_CONTATO;

-- ========================================
-- Query 10: Buscar dados adicionais de faturamento do contato
-- Descrição: Retorna informações fiscais e de consumidor do contato/cliente
-- ========================================
SELECT 
    FDA.INDICADOR_PRESENCA, 
    FDA.CONSUMIDOR_FINAL, 
    FCL.EH_ZONA_FRANCA_MANAUS, 
    FCL.UF_ENTREGA, 
    FCL.FISJUR, 
    FCC.CONSUMIDOR_FINAL CONSUMIDOR_FINAL_CAT 
FROM 
    CNP.FAT_DADO_ADICIONAL FDA
    LEFT OUTER JOIN CAC_CONTATO CON ON (CON.EMPRESA = FDA.EMPRESA 
        AND CON.REVENDA = FDA.REVENDA 
        AND CON.CONTATO = FDA.CONTATO)
    LEFT OUTER JOIN FAT_CLIENTE FCL ON (CON.CLIENTE = FCL.CLIENTE)
    INNER JOIN FAT_CATEGORIA_CLIENTE FCC ON (FCL.CATEGORIA = FCC.CATEGORIA) 
WHERE 
    FDA.EMPRESA = 1 
    AND FDA.REVENDA = 1 
   -- AND FDA.CONTATO = 804064;

-- ========================================
-- Query 11: Buscar informações operacionais do atendimento
-- Descrição: Retorna flags de teste de rodagem, lavagem, inspeção, etc.
-- ========================================
SELECT 
    PRECISA_TESTE_RODAGEM, 
    LAVAR_CARRO, 
    AGENDAMENTO_INSPECAO, 
    OFIC_DEDICADA_ATEND_CAMPO, 
    VEICULO_REBOCADO 
FROM 
    CNP.OFI_ATENDIMENTO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
   -- AND CONTATO = 804064;

-- ========================================
-- Query 12: Buscar motivo da venda do contato
-- Descrição: Retorna o código do motivo que originou o contato de venda
-- ========================================
SELECT 
    MOTIVO_VENDA 
FROM 
    CNP.CAC_CONTATO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
  --  AND CONTATO = 804064;

-- ========================================
-- Query 13: Buscar dados Scania CWS da ordem de serviço
-- Descrição: Retorna identificadores de integração com sistema Scania CWS
-- ========================================
SELECT 
    SCA_CWS, 
    ID_LOCAL_OPERACAO 
FROM 
    CNP.OFI_ORDEM_SERVICO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
   -- AND NRO_OS = 221261;

-- ========================================
-- Query 14: Buscar todos os parâmetros da oficina (com bind variables)
-- Descrição: Retorna todos os parâmetros configurados para a empresa e revenda
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1

-- ========================================
-- Query 15: Verificar se utiliza serviços de terceiros (1ª verificação)
-- Descrição: Retorna parâmetro de utilização de serviços terceirizados
-- ========================================
SELECT 
    UTILIZA_SERVICO_TERCEIROS 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 16: Buscar dados completos do vendedor (com bind variables)
-- Descrição: Retorna todos os dados cadastrais do vendedor específico
-- ========================================
SELECT 
    * 
FROM 
    CNP.FAT_VENDEDOR 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND VENDEDOR = :3;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 646

-- ========================================
-- Query 17: Buscar dados completos do cliente (1ª busca - com bind variables)
-- Descrição: Retorna todos os dados cadastrais do cliente
-- ========================================
SELECT 
    * 
FROM 
    CNP.FAT_CLIENTE 
WHERE 
    CLIENTE = :1;
-- :1 (Number,IN) = 47173

-- ========================================
-- Query 18: Buscar dados completos do cliente (2ª busca - com bind variables)
-- Descrição: Segunda consulta aos dados do cliente (possível revalidação)
-- ========================================
SELECT 
    * 
FROM 
    CNP.FAT_CLIENTE 
WHERE 
    CLIENTE = :1;
-- :1 (Number,IN) = 47173

-- ========================================
-- Query 19: Buscar ficha de seguimento completa do veículo (com bind variables)
-- Descrição: Retorna dados do veículo incluindo modelo, cor, marca e garantia
-- ========================================
SELECT 
    FICHA.*, 
    MARCA.MARCA, 
    MARCA.NOME_MARCA, 
    COR.DES_COR, 
    MODELO.PRAZO_GARANTIA 
FROM 
    CNP.OFI_FICHA_SEGUIMENTO FICHA, 
    CNP.VEI_MODELO MODELO, 
    CNP.VEI_FAMILIA FAMILIA, 
    CNP.GER_MARCA MARCA, 
    CNP.VEI_COR COR 
WHERE 
    FICHA.CHASSI = :1 
    AND COR.EMPRESA = FICHA.EMPRESA 
    AND COR.COR = FICHA.COR 
    AND MODELO.EMPRESA = FICHA.EMPRESA 
    AND MODELO.MODELO = FICHA.MODELO 
    AND FAMILIA.EMPRESA = MODELO.EMPRESA 
    AND FAMILIA.FAMILIA = MODELO.FAMILIA 
    AND MARCA.MARCA = FAMILIA.MARCA 
ORDER BY 
    CHASSI;
-- :1 (WideString,IN) = 9BGJC6920HB197542

-- ========================================
-- Query 20: Buscar descrição do modelo do veículo
-- Descrição: Retorna a descrição do modelo baseado no chassi
-- ========================================
SELECT 
    DES_MODELO 
FROM 
    CNP.VEI_MODELO 
WHERE 
    MODELO = '5C69ZE' 
    AND EMPRESA = (
        SELECT 
            OFS.EMPRESA 
        FROM 
            CNP.OFI_FICHA_SEGUIMENTO OFS 
        WHERE 
            OFS.CHASSI = '9BGJC6920HB197542'
    );

-- ========================================
-- Query 21: Buscar observações padrão cadastradas (com bind variables)
-- Descrição: Retorna todas as observações padrão disponíveis para uso
-- ========================================
SELECT 
    * 
FROM 
    CNP.GER_OBSERVACAO_PADRAO 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
ORDER BY 
    OBSERVACAO_PADRAO;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1

-- ========================================
-- Query 22: Buscar dados completos da ordem de serviço (com bind variables)
-- Descrição: Retorna todos os dados da OS específica
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_ORDEM_SERVICO 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND NRO_OS = :3;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 221261

-- ========================================
-- Query 23: Buscar histórico de impressões da OS
-- Descrição: Retorna datas de todas as impressões realizadas da OS
-- ========================================
SELECT 
    DATA 
FROM 
    CNP.OFI_IMPRESSOES_OS 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
  --  AND NRO_OS = 221261 
ORDER BY 
    ID;

-- ========================================
-- Query 24: Buscar nome do usuário
-- Descrição: Retorna o nome do usuário específico
-- ========================================
SELECT 
    NOME 
FROM 
    CNP.GER_USUARIO 
WHERE 
    USUARIO = 365;

-- ========================================
-- Query 25: Buscar dados completos do atendimento (com bind variables)
-- Descrição: Retorna todas as informações do atendimento vinculado ao contato
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_ATENDIMENTO 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND CONTATO = :3;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 804064

-- ========================================
-- Query 26: Verificar existência da coluna INATIVO_CONSULTAS em FAT_VENDEDOR
-- Descrição: Valida se a coluna existe na estrutura da tabela
-- ========================================
SELECT 
    COLUMN_NAME NOME_CAMPO 
FROM 
    CNP.USER_TAB_COLUMNS 
WHERE 
    TABLE_NAME = 'FAT_VENDEDOR' 
    AND COLUMN_NAME = 'INATIVO_CONSULTAS';

-- ========================================
-- Query 27: Listar vendedores ativos
-- Descrição: Retorna vendedores que não estão inativos para consultas
-- ========================================
SELECT 
    V.VENDEDOR, 
    V.NOME 
FROM 
    CNP.FAT_VENDEDOR V 
WHERE 
    V.EMPRESA = 1 
    AND V.REVENDA = 1 
    AND (COALESCE(V.INATIVO_CONSULTAS, 'N') <> 'S');

-- ========================================
-- Query 28: Verificar existência da coluna INATIVO_CONSULTAS em GER_DEPARTAMENTO
-- Descrição: Valida se a coluna existe na estrutura da tabela
-- ========================================
SELECT 
    COLUMN_NAME NOME_CAMPO 
FROM 
    CNP.USER_TAB_COLUMNS 
WHERE 
    TABLE_NAME = 'GER_DEPARTAMENTO' 
    AND COLUMN_NAME = 'INATIVO_CONSULTAS';

-- ========================================
-- Query 29: Listar departamentos ativos
-- Descrição: Retorna departamentos que não estão inativos para consultas
-- ========================================
SELECT 
    DEPARTAMENTO, 
    NOME 
FROM 
    CNP.GER_DEPARTAMENTO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND (INATIVO_CONSULTAS = 'N' 
        OR INATIVO_CONSULTAS IS NULL) 
    AND (COALESCE(GER_DEPARTAMENTO.INATIVO_CONSULTAS, 'N') <> 'S');

-- ========================================
-- Query 30: Buscar peças solicitadas do contato
-- Descrição: Retorna todas as peças previamente solicitadas para o contato
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_PECA_SOLICITADA 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND CONTATO = 804064;

-- ========================================
-- Query 31: Buscar dados básicos de solicitações do contato
-- Descrição: Retorna número, tipo de serviço e política de preço das solicitações
-- ========================================
SELECT 
    NRO_SOLICITACAO, 
    TIPO_SERVICO_OS, 
    POLITICA_PRECO_PECA 
FROM 
    CNP.OFI_SOLICITACAO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND CONTATO = 804064;



-- ========================================
-- Query 33: Buscar resumo de valores de serviços da OS (com bind variables)
-- Descrição: Retorna quantidade, valor e desconto dos serviços agrupados por tipo
-- ========================================
SELECT 
    OSO.QUANTIDADE, 
    OSO.VAL_SERVICO, 
    (OSO.VAL_DESCONTO - COALESCE(OSO.VAL_DESCONTO_FRANQUIA, 0)) DESCONTO, 
    OTS.TIPO_SERVICO_OS 
FROM 
    CNP.OFI_SERVICO_OS OSO, 
    CNP.OFI_TIPO_SERVICO OTS 
WHERE 
    OSO.EMPRESA = :1 
    AND OSO.REVENDA = :2 
    AND OSO.NRO_OS = :3 
    AND OTS.EMPRESA = OSO.EMPRESA 
    AND OTS.REVENDA = OSO.REVENDA 
    AND OTS.TIPO_SERVICO = OSO.TIPO_SERVICO;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 221261

-- ========================================
-- Query 34: Buscar serviços cancelados da OS
-- Descrição: Retorna histórico de serviços que foram cancelados com motivo e usuário
-- ========================================
SELECT 
    OSC.NRO_LANCAMENTO, 
    OMO.DES_RESUMIDA DESCRICAO, 
    OSC.QUANTIDADE, 
    OSC.VALOR, 
    OSC.DTA_CANCELAMENTO, 
    GUS.NOME, 
    GMO.DES_MOTIVO 
FROM 
    CNP.OFI_SERVICO_CANCELADO_OS OSC
    LEFT JOIN GER_MOTIVO GMO ON GMO.EMPRESA = OSC.EMPRESA 
        AND GMO.REVENDA = OSC.REVENDA 
        AND GMO.MOTIVO = OSC.MOTIVO_CANCELAMENTO
    LEFT JOIN GER_USUARIO GUS ON GUS.USUARIO = OSC.USUARIO
    LEFT JOIN OFI_SERVICO OSE ON OSE.EMPRESA = OSC.EMPRESA 
        AND OSE.SERVICO = OSC.SERVICO
    LEFT OUTER JOIN OFI_MAODEOBRA OMO ON OMO.EMPRESA = OSE.EMPRESA 
        AND OMO.MAODEOBRA = OSE.MAODEOBRA 
WHERE 
    OSC.EMPRESA = 1 
    AND OSC.REVENDA = 1 
  --  AND OSC.NRO_OS = 221261;

-- ========================================
-- Query 35: Buscar peças da ordem de serviço com detalhes completos (1ª busca)
-- Descrição: Retorna todas as peças da OS incluindo valores, estoque, localização e mecânico
-- ========================================
SELECT 
    COALESCE(PECAOS.INDTOT, 1) INDTOT, 
    PECAOS.*, 
    IE.ITEM_ESTOQUE_PUB, 
    IE.DES_ITEM_ESTOQUE, 
    TIPO.TIPO_SERVICO_OS, 
    TIPO.TIPO_SERVICO, 
    MEC.NOME, 
    SOL.NRO_ORCAMENTO, 
    SOL.POLITICA_PRECO_PECA, 
    IR.PCT_MARGEM_LUCRO, 
    CAST((PECAOS.VAL_DESCONTO - COALESCE(PECAOS.VAL_DESCONTO_FRANQUIA, 0)) AS NUMERIC(11, 2)) VAL_DESCONTO_REAL, 
    (IR.LOCACAO_ZONA || ' ' || IR.LOCACAO_RUA || ' ' || IR.LOCACAO_ESTANTE || ' ' || IR.LOCACAO_PRATELEIRA || ' ' || IR.LOCACAO_NUMERO) LOCACAO, 
    SOL.GAR_RECALL_FCA, 
    SOL.PSA_FF_TIPO 
FROM 
    CNP.OFI_PECA_OS PECAOS, 
    CNP.PEC_ITEM_ESTOQUE IE, 
    CNP.OFI_TIPO_SERVICO TIPO, 
    CNP.OFI_MECANICO MEC, 
    CNP.PEC_ITEM_REVENDA IR, 
    CNP.OFI_SOLICITACAO SOL 
WHERE 
    PECAOS.EMPRESA = 1 
    AND PECAOS.REVENDA = 1 
   -- AND PECAOS.NRO_OS = 221261 
    AND IE.EMPRESA = PECAOS.EMPRESA 
    AND IE.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND IR.EMPRESA = PECAOS.EMPRESA 
    AND IR.REVENDA = PECAOS.REVENDA 
    AND IR.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND TIPO.EMPRESA = PECAOS.EMPRESA 
    AND TIPO.REVENDA = PECAOS.REVENDA 
    AND TIPO.TIPO_SERVICO = PECAOS.TIPO_SERVICO 
    AND SOL.EMPRESA = PECAOS.EMPRESA 
    AND SOL.REVENDA = PECAOS.REVENDA 
    AND SOL.CONTATO = PECAOS.CONTATO 
    AND SOL.NRO_SOLICITACAO = PECAOS.NRO_SOLICITACAO 
    AND MEC.EMPRESA (+) = PECAOS.EMPRESA 
    AND MEC.REVENDA (+) = PECAOS.REVENDA 
    AND MEC.MECANICO (+) = PECAOS.MECANICO 
ORDER BY 
    PECAOS.NRO_LANCAMENTO;

-- ========================================
-- Query 36: Calcular total de peças da OS (com bind variables)
-- Descrição: Retorna o valor total das peças considerando descontos
-- ========================================
SELECT 
    SUM(ROUND((QUANTIDADE * VAL_UNITARIO), 2) - (VAL_DESCONTO - COALESCE(VAL_DESCONTO_FRANQUIA, 0))) TOT_PECAS 
FROM 
    CNP.OFI_PECA_OS 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND NRO_OS = :3;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 221261

-- ========================================
-- Query 37: Buscar dados completos da ordem de serviço (revalidação)
-- Descrição: Segunda busca completa da OS
-- ========================================
SELECT 
    * 
FROM 
   CNP.OFI_ORDEM_SERVICO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND NRO_OS = 221261;

-- ========================================
-- Query 38: Buscar solicitações externas em andamento/finalizadas
-- Descrição: Retorna solicitações de serviço externo com situações específicas (6, 7, 9)
-- ========================================
SELECT 
    OS.* 
FROM 
    CNP.OFI_SOLICITACAO OS 
WHERE 
    OS.EMPRESA = 1 
    AND OS.REVENDA = 1 
    AND OS.CONTATO = 804064 
    AND OS.TIPO_SERVICO_OS IN ('E') 
    AND OS.SITUACAO IN (6, 7, 9) 
ORDER BY 
    OS.NRO_SOLICITACAO;

-- ========================================
-- Query 39: Buscar solicitações canceladas do contato (com bind variables)
-- Descrição: Retorna todas as solicitações com situação 8 (Cancelada) e motivo
-- ========================================
SELECT 
    SOL.*, 
    (SELECT 
         DES_MOTIVO 
     FROM 
         CNP.GER_MOTIVO 
     WHERE 
         EMPRESA = SOL.EMPRESA 
         AND REVENDA = SOL.REVENDA 
         AND MOTIVO = SOL.MOTIVO_CANCELAMENTO) DES_MOTIVO 
FROM 
    CNP.OFI_SOLICITACAO SOL, 
    CNP.CAC_CONTATO CT 
WHERE 
    CT.EMPRESA = :1 
    AND CT.REVENDA = :2 
    AND CT.CONTATO = :3 
    AND SOL.EMPRESA = CT.EMPRESA 
    AND SOL.REVENDA = CT.REVENDA 
    AND SOL.CONTATO = CT.CONTATO 
    AND SOL.SITUACAO = 8 
ORDER BY 
    SOL.NRO_SOLICITACAO;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 804064

-- ========================================
-- Query 40: Buscar vendedores agregados ao contato (com bind variables)
-- Descrição: Retorna vendedores vinculados ao atendimento/contato
-- ========================================
SELECT 
    VA.*, 
    VE.NOME 
FROM 
    CNP.OFI_VENDEDOR_AGREGADO VA, 
    CNP.FAT_VENDEDOR VE 
WHERE 
    VA.EMPRESA = :1 
    AND VA.REVENDA = :2 
    AND VA.CONTATO = :3 
    AND VE.EMPRESA = VA.EMPRESA 
    AND VE.REVENDA = VA.REVENDA 
    AND VE.VENDEDOR = VA.VENDEDOR 
ORDER BY 
    VE.NOME;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 804064

-- ========================================
-- Query 41: Buscar configuração de romaneio do usuário (com bind variables)
-- Descrição: Verifica se o usuário tem permissão/configuração para romaneio
-- ========================================
SELECT 
    * 
FROM 
    CNP.GER_USUARIO_ROMANEIO 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND USUARIO = :3;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 644

-- ========================================
-- Query 42: Buscar acessórios do veículo na OS (com bind variables)
-- Descrição: Retorna lista de acessórios registrados no check-in do veículo
-- ========================================
SELECT 
    AOS.*, 
    ACE.DES_ACESSORIO 
FROM 
    CNP.OFI_ACESSORIO_VEICULO_OS AOS, 
    CNP.OFI_ACESSORIO_VEICULO ACE 
WHERE 
    AOS.EMPRESA = :1 
    AND AOS.REVENDA = :2 
    AND AOS.NRO_OS = :3 
    AND ACE.EMPRESA = AOS.EMPRESA 
    AND ACE.REVENDA = AOS.REVENDA 
    AND ACE.ACESSORIO_VEICULO = AOS.ACESSORIO_VEICULO;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 221261

-- ========================================
-- Query 43: Verificar se utiliza serviços de terceiros (2ª verificação)
-- Descrição: Segunda verificação do parâmetro de serviços terceirizados
-- ========================================
SELECT 
    UTILIZA_SERVICO_TERCEIROS 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 44: Buscar categorias de OS permitidas nas solicitações
-- Descrição: Retorna categorias permitidas com base nos tipos de serviço das solicitações
-- ========================================
SELECT DISTINCT 
    OTS.CATEGORIA_OS_PERMITIDA 
FROM 
    CNP.OFI_SOLICITACAO OSO, 
    CNP.OFI_TIPO_SERVICO OTS 
WHERE 
    OSO.EMPRESA = 1 
    AND OSO.REVENDA = 1 
    AND OSO.CONTATO = 804064 
    AND OSO.SITUACAO <> 8 
    AND OTS.EMPRESA = OSO.EMPRESA 
    AND OTS.REVENDA = OSO.REVENDA 
    AND OTS.TIPO_SERVICO = OSO.TIPO_SERVICO 
    AND OTS.CATEGORIA_OS_PERMITIDA IS NOT NULL;

-- ========================================
-- Query 45: Listar categorias de OS ativas
-- Descrição: Retorna todas as categorias de ordem de serviço não inativas
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_CATEGORIA_OS 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND ((INATIVO_CONSULTAS <> 'S') 
        OR (INATIVO_CONSULTAS IS NULL));

-- ========================================
-- Query 46: Buscar log de lançamentos da OS e contato
-- Descrição: Retorna histórico de alterações/ações realizadas na OS ou contato
-- ========================================
SELECT 
    GLL.*, 
    GU.NOME 
FROM 
    CNP.GER_LOG_LANCAMENTO GLL
    INNER JOIN GER_USUARIO GU ON GLL.USUARIO = GU.USUARIO 
WHERE 
    GLL.EMPRESA = 1 
    AND GLL.REVENDA = 1 
    AND ((GLL.NRO_OS = 221261 
            OR GLL.CONTATO = 804064) 
        OR (GLL.CONTATO = (
                SELECT 
                    CAC.CONTATO_ORIGEM 
                FROM 
                    CNP.CAC_CONTATO CAC 
                WHERE 
                    CAC.CONTATO = 804064 
                    AND CAC.EMPRESA = 1 
                    AND CAC.REVENDA = 1
            ) 
            AND GLL.NRO_OS IS NULL)) 
ORDER BY 
    GLL.SEQUENCIA;

-- ========================================
-- Query 47: Buscar informações de contato do cliente
-- Descrição: Retorna horários, períodos e telefones preferenciais para contato
-- ========================================
SELECT 
    MELHOR_HORARIO, 
    MELHOR_PERIODO, 
    MELHOR_TELEFONE, 
    PESSOA_CONTATO, 
    DTA_NOVO_CONTATO, 
    DDD_1, 
    TELEFONE_1, 
    DDD_2, 
    TELEFONE_2, 
    DDD_3, 
    TELEFONE_3 
FROM 
    CNP.CAC_CONTATO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND CONTATO = 804064;

-- ========================================
-- Query 48: Buscar proprietário atual do veículo
-- Descrição: Retorna dados do proprietário atual e informações de contato
-- ========================================
SELECT 
    FP.CHASSI, 
    FP.CLIENTE, 
    FP.PROPRIETARIO_ATUAL, 
    CL.CLIENTE, 
    CL.NOME, 
    CL.TELEFONE, 
    CL.DDD_TELEFONE, 
    CL.CELULAR, 
    CL.DDD_CELULAR 
FROM 
    CNP.OFI_FICHA_PROPRIETARIO FP
    INNER JOIN FAT_CLIENTE CL ON (FP.CLIENTE = CL.CLIENTE) 
WHERE 
    FP.CHASSI = '9BGJC6920HB197542' 
    AND FP.PROPRIETARIO_ATUAL = 'S';

-- ========================================
-- Query 49: Buscar solicitações internas ativas do contato
-- Descrição: Retorna solicitações de serviço interno não canceladas
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_SOLICITACAO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1 
    AND SITUACAO <> 8 
    AND CONTATO = 804064 
    AND TIPO_SERVICO_OS = 'I';

-- ========================================
-- Query 50: Buscar histórico de check-list de recebimento do veículo
-- Descrição: Retorna datas e responsáveis pelos checks de recebimento realizados
-- ========================================
SELECT 
    OCV.DTA_REALIZACAO, 
    GUS.NOME 
FROM 
    CNP.OFI_CHECK_VEICULO OCV, 
    CNP.GER_USUARIO GUS 
WHERE 
    OCV.EMPRESA = 1 
    AND OCV.REVENDA = 1 
    AND OCV.CONTATO = 804064 
    AND OCV.TIPO = 'R' 
    AND GUS.USUARIO = OCV.USU_RESPONSAVEL 
ORDER BY 
    OCV.DTA_REALIZACAO;

-- ========================================
-- Query 51: Listar vendedores ativos exceto um específico (com bind variables)
-- Descrição: Retorna vendedores ativos excluindo um vendedor específico
-- ========================================
SELECT 
    * 
FROM 
    CNP.FAT_VENDEDOR 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND VENDEDOR <> :3 
    AND ATIVO = 'S' 
ORDER BY 
    VENDEDOR;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 189

-- ========================================
-- Query 52: Verificar se utiliza serviços de terceiros (3ª verificação)
-- Descrição: Terceira verificação do parâmetro de serviços terceirizados
-- ========================================
SELECT 
    UTILIZA_SERVICO_TERCEIROS 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 53: Verificar se utiliza serviços de terceiros (4ª verificação)
-- Descrição: Quarta verificação do parâmetro de serviços terceirizados
-- ========================================
SELECT 
    UTILIZA_SERVICO_TERCEIROS 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 54: Verificar se utiliza serviços de terceiros (5ª verificação)
-- Descrição: Quinta verificação do parâmetro de serviços terceirizados
-- ========================================
SELECT 
    UTILIZA_SERVICO_TERCEIROS 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 55: Verificar se utiliza serviços de terceiros (6ª verificação)
-- Descrição: Sexta verificação do parâmetro de serviços terceirizados
-- ========================================
SELECT 
    UTILIZA_SERVICO_TERCEIROS 
FROM 
    CNP.OFI_PARAMETRO 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 56: Verificar se utiliza empenho (1ª verificação)
-- Descrição: Primeira verificação do parâmetro de utilização de empenho
-- ========================================
SELECT 
    UTILIZA_EMPENHO 
FROM 
    CNP.GMA_PARAMETRO_REVENDA 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 57: Verificar se utiliza empenho (2ª verificação)
-- Descrição: Segunda verificação do parâmetro de utilização de empenho
-- ========================================
SELECT 
    UTILIZA_EMPENHO 
FROM 
    CNP.GMA_PARAMETRO_REVENDA 
WHERE 
    EMPRESA = 1 
    AND REVENDA = 1;

-- ========================================
-- Query 58: Buscar peças da ordem de serviço com detalhes completos (2ª busca)
-- Descrição: Segunda busca das peças da OS (possível atualização de dados)
-- ========================================
SELECT 
    COALESCE(PECAOS.INDTOT, 1) INDTOT, 
    PECAOS.*, 
    IE.ITEM_ESTOQUE_PUB, 
    IE.DES_ITEM_ESTOQUE, 
    TIPO.TIPO_SERVICO_OS, 
    TIPO.TIPO_SERVICO, 
    MEC.NOME, 
    SOL.NRO_ORCAMENTO, 
    SOL.POLITICA_PRECO_PECA, 
    IR.PCT_MARGEM_LUCRO, 
    CAST((PECAOS.VAL_DESCONTO - COALESCE(PECAOS.VAL_DESCONTO_FRANQUIA, 0)) AS NUMERIC(11, 2)) VAL_DESCONTO_REAL, 
    (IR.LOCACAO_ZONA || ' ' || IR.LOCACAO_RUA || ' ' || IR.LOCACAO_ESTANTE || ' ' || IR.LOCACAO_PRATELEIRA || ' ' || IR.LOCACAO_NUMERO) LOCACAO, 
    SOL.GAR_RECALL_FCA, 
    SOL.PSA_FF_TIPO 
FROM 
    CNP.OFI_PECA_OS PECAOS, 
    CNP.PEC_ITEM_ESTOQUE IE, 
    CNP.OFI_TIPO_SERVICO TIPO, 
    CNP.OFI_MECANICO MEC, 
    CNP.PEC_ITEM_REVENDA IR, 
    CNP.OFI_SOLICITACAO SOL 
WHERE 
    PECAOS.EMPRESA = 1 
    AND PECAOS.REVENDA = 1 
    AND PECAOS.NRO_OS = 221261 
    AND IE.EMPRESA = PECAOS.EMPRESA 
    AND IE.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND IR.EMPRESA = PECAOS.EMPRESA 
    AND IR.REVENDA = PECAOS.REVENDA 
    AND IR.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND TIPO.EMPRESA = PECAOS.EMPRESA 
    AND TIPO.REVENDA = PECAOS.REVENDA 
    AND TIPO.TIPO_SERVICO = PECAOS.TIPO_SERVICO 
    AND SOL.EMPRESA = PECAOS.EMPRESA 
    AND SOL.REVENDA = PECAOS.REVENDA 
    AND SOL.CONTATO = PECAOS.CONTATO 
    AND SOL.NRO_SOLICITACAO = PECAOS.NRO_SOLICITACAO 
    AND MEC.EMPRESA (+) = PECAOS.EMPRESA 
    AND MEC.REVENDA (+) = PECAOS.REVENDA 
    AND MEC.MECANICO (+) = PECAOS.MECANICO 
ORDER BY 
    PECAOS.NRO_LANCAMENTO;

-- ========================================
-- Query 59: Buscar peças da ordem de serviço com detalhes completos (3ª busca)
-- Descrição: Terceira busca das peças da OS (possível nova atualização)
-- ========================================
SELECT 
    COALESCE(PECAOS.INDTOT, 1) INDTOT, 
    PECAOS.*, 
    IE.ITEM_ESTOQUE_PUB, 
    IE.DES_ITEM_ESTOQUE, 
    TIPO.TIPO_SERVICO_OS, 
    TIPO.TIPO_SERVICO, 
    MEC.NOME, 
    SOL.NRO_ORCAMENTO, 
    SOL.POLITICA_PRECO_PECA, 
    IR.PCT_MARGEM_LUCRO, 
    CAST((PECAOS.VAL_DESCONTO - COALESCE(PECAOS.VAL_DESCONTO_FRANQUIA, 0)) AS NUMERIC(11, 2)) VAL_DESCONTO_REAL, 
    (IR.LOCACAO_ZONA || ' ' || IR.LOCACAO_RUA || ' ' || IR.LOCACAO_ESTANTE || ' ' || IR.LOCACAO_PRATELEIRA || ' ' || IR.LOCACAO_NUMERO) LOCACAO, 
    SOL.GAR_RECALL_FCA, 
    SOL.PSA_FF_TIPO 
FROM 
    CNP.OFI_PECA_OS PECAOS, 
    CNP.PEC_ITEM_ESTOQUE IE, 
    CNP.OFI_TIPO_SERVICO TIPO, 
    CNP.OFI_MECANICO MEC, 
    CNP.PEC_ITEM_REVENDA IR, 
    CNP.OFI_SOLICITACAO SOL 
WHERE 
    PECAOS.EMPRESA = 1 
    AND PECAOS.REVENDA = 1 
    AND PECAOS.NRO_OS = 221261 
    AND IE.EMPRESA = PECAOS.EMPRESA 
    AND IE.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND IR.EMPRESA = PECAOS.EMPRESA 
    AND IR.REVENDA = PECAOS.REVENDA 
    AND IR.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND TIPO.EMPRESA = PECAOS.EMPRESA 
    AND TIPO.REVENDA = PECAOS.REVENDA 
    AND TIPO.TIPO_SERVICO = PECAOS.TIPO_SERVICO 
    AND SOL.EMPRESA = PECAOS.EMPRESA 
    AND SOL.REVENDA = PECAOS.REVENDA 
    AND SOL.CONTATO = PECAOS.CONTATO 
    AND SOL.NRO_SOLICITACAO = PECAOS.NRO_SOLICITACAO 
    AND MEC.EMPRESA (+) = PECAOS.EMPRESA 
    AND MEC.REVENDA (+) = PECAOS.REVENDA 
    AND MEC.MECANICO (+) = PECAOS.MECANICO 
ORDER BY 
    PECAOS.NRO_LANCAMENTO;

-- ========================================
-- Query 60: Buscar UF de entrega do cliente
-- Descrição: Retorna o estado de entrega do cliente para cálculos fiscais
-- ========================================
SELECT 
    UF_ENTREGA 
FROM 
    CNP.FAT_CLIENTE 
WHERE 
    CLIENTE = 47173;

-- ========================================
-- Query 61: Buscar peças da ordem de serviço com detalhes completos (4ª busca)
-- Descrição: Quarta busca das peças da OS (validação final)
-- ========================================
SELECT 
    COALESCE(PECAOS.INDTOT, 1) INDTOT, 
    PECAOS.*, 
    IE.ITEM_ESTOQUE_PUB, 
    IE.DES_ITEM_ESTOQUE, 
    TIPO.TIPO_SERVICO_OS, 
    TIPO.TIPO_SERVICO, 
    MEC.NOME, 
    SOL.NRO_ORCAMENTO, 
    SOL.POLITICA_PRECO_PECA, 
    IR.PCT_MARGEM_LUCRO, 
    CAST((PECAOS.VAL_DESCONTO - COALESCE(PECAOS.VAL_DESCONTO_FRANQUIA, 0)) AS NUMERIC(11, 2)) VAL_DESCONTO_REAL, 
    (IR.LOCACAO_ZONA || ' ' || IR.LOCACAO_RUA || ' ' || IR.LOCACAO_ESTANTE || ' ' || IR.LOCACAO_PRATELEIRA || ' ' || IR.LOCACAO_NUMERO) LOCACAO, 
    SOL.GAR_RECALL_FCA, 
    SOL.PSA_FF_TIPO 
FROM 
    CNP.OFI_PECA_OS PECAOS, 
    CNP.PEC_ITEM_ESTOQUE IE, 
    CNP.OFI_TIPO_SERVICO TIPO, 
    CNP.OFI_MECANICO MEC, 
    CNP.PEC_ITEM_REVENDA IR, 
    CNP.OFI_SOLICITACAO SOL 
WHERE 
    PECAOS.EMPRESA = 1 
    AND PECAOS.REVENDA = 1 
    AND PECAOS.NRO_OS = 221261 
    AND IE.EMPRESA = PECAOS.EMPRESA 
    AND IE.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND IR.EMPRESA = PECAOS.EMPRESA 
    AND IR.REVENDA = PECAOS.REVENDA 
    AND IR.ITEM_ESTOQUE = PECAOS.ITEM_ESTOQUE 
    AND TIPO.EMPRESA = PECAOS.EMPRESA 
    AND TIPO.REVENDA = PECAOS.REVENDA 
    AND TIPO.TIPO_SERVICO = PECAOS.TIPO_SERVICO 
    AND SOL.EMPRESA = PECAOS.EMPRESA 
    AND SOL.REVENDA = PECAOS.REVENDA 
    AND SOL.CONTATO = PECAOS.CONTATO 
    AND SOL.NRO_SOLICITACAO = PECAOS.NRO_SOLICITACAO 
    AND MEC.EMPRESA (+) = PECAOS.EMPRESA 
    AND MEC.REVENDA (+) = PECAOS.REVENDA 
    AND MEC.MECANICO (+) = PECAOS.MECANICO 
ORDER BY 
    PECAOS.NRO_LANCAMENTO;

-- ========================================
-- Query 62: Buscar relatório de visita da OS (com bind variables)
-- Descrição: Retorna dados de relatório de visita técnica se existir
-- ========================================
SELECT 
    * 
FROM 
    CNP.OFI_RELATORIO_VISITA 
WHERE 
    EMPRESA = :1 
    AND REVENDA = :2 
    AND NRO_OS = :3;
-- :1 (Number,IN) = 1 
-- :2 (Number,IN) = 1 
-- :3 (Number,IN) = 221261

-- ========================================
-- Query 63: Buscar configuração de grid de log de lançamento
-- Descrição: Retorna configuração personalizada da grade de log de lançamento
-- ========================================
SELECT 
    CONFIGURACAO 
FROM 
    CNP.GER_GRID_USUARIO 
WHERE 
    USUARIO = 644 
    AND NOME_UNIT = 'FRAMEMNTORDEMSERVICO' 
    AND NOME_GRID = 'CXGRDBTBLVWLOGLANC' 
    AND CONTADOR = 0;

-- ========================================
-- Query 64: Buscar configuração de grid de impressões
-- Descrição: Retorna configuração personalizada da grade de histórico de impressões
-- ========================================
SELECT 
    CONFIGURACAO 
FROM 
    CNP.GER_GRID_USUARIO 
WHERE 
    USUARIO = 644 
    AND NOME_UNIT = 'FRAMEMNTORDEMSERVICO' 
    AND NOME_GRID = 'CXGRDBTBLVWIMPRESSOES' 
    AND CONTADOR = 0;