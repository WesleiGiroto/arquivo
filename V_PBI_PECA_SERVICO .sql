CREATE OR REPLACE VIEW V_PBI_PECA_SERVICO AS

/*==============================================================================
    VIEW RESPONSÁVEL POR CONSOLIDAR SERVIÇOS DE O.S PARA POWER BI
==============================================================================*/

SELECT DISTINCT

       /*======================================================================
           IDENTIFICAÇÃO DA O.S
       ======================================================================*/
       SOS.EMPRESA,
       SOS.REVENDA,
       SOS.NRO_OS,
       TO_CHAR(SOS.EMPRESA)||' - '||TO_CHAR(SOS.REVENDA) CHAVE_EMP_REV,
       TO_CHAR(SOS.EMPRESA)||' - '||TO_CHAR(SOS.REVENDA)||' - '||TO_CHAR(SOS.NRO_OS) CHAVE_EMP_REV_NRO_OS, 
       TO_CHAR(SOS.EMPRESA)||' - '||TO_CHAR(SOS.REVENDA)||' - '||TO_CHAR(FMC.CONTATO) CHAVE_EMP_REV_CONTATO,
       
       CAST('S' AS VARCHAR(1))                                            TIPO_ITEM,
       
       SOS.NRO_LANCAMENTO,
       OTS.TIPO_SERVICO,
       OTS.DES_TIPO_SERVICO,
       CASE OTS.TIPO_SERVICO_OS
         WHEN 'E' THEN 'EXTERNA'
         WHEN 'G' THEN 'GARANTIA'
         WHEN 'R' THEN 'REVISAO'
         WHEN 'I' THEN 'INTERNO'
           END TIPO_SERVICO_OS,
       FMC.CONTATO,

       /*======================================================================
           DADOS DE FATURAMENTO / NOTA
       ======================================================================*/
       OOS.DTA_FIM_FRANQUIA,
       OFM.NUMERO_NOTA_FISCAL                                             NRO_NOTA,
       OFM.SERIE_NOTA_FISCAL                                              SERIE_NOTA,
       OOS.DTA_EMISSAO                                                    DTA_EMISSAO,

       /*======================================================================
           INFORMAÇÕES COMPLEMENTARES DA O.S
       ======================================================================*/
       SOL.DES_DIAGNOSTICO,
       OOS.OBSERVACAO,

       /*======================================================================
           DATA FINAL CONFORME TIPO DA O.S
       ======================================================================*/
       CASE OTS.TIPO_SERVICO_OS
            WHEN 'E' THEN OOS.DTA_FIM_EXTERNO
            WHEN 'G' THEN OOS.DTA_FIM_GARANTIA
            WHEN 'R' THEN OOS.DTA_FIM_REVISAO
            WHEN 'I' THEN OOS.DTA_FIM_INTERNO
       END                                                                DATA,

       /*======================================================================
           VALORES DO SERVIÇO
       ======================================================================*/
       SOS.VAL_SERVICO                                                    VAL_UNITARIO,

       CAST(
            (
                (SOS.VAL_SERVICO * SOS.QUANTIDADE)
                - COALESCE(SOS.VAL_DESCONTO, 0)
            ) AS NUMERIC(13,2)
       )                                                                  VLR_ITEM,

       SOS.QUANTIDADE,
       SOS.VAL_DESCONTO,
       COALESCE(SOS.VAL_DESCONTO_FRANQUIA, 0)                             VAL_DESCONTO_FRANQUIA,

       /*======================================================================
           DADOS DO CLIENTE
       ======================================================================*/
       CLI.NOME                                                           NOME_CLIENTE,

       /*======================================================================
           DADOS DO MECÂNICO
       ======================================================================*/
       MEC.MECANICO,
       MEC.NOME                                                           NOME_MECANICO,
       MEC.EQUIPE,

       (
           SELECT OEM.NOME_EQUIPE
             FROM CNP.OFI_EQUIPE_MECANICO OEM
            WHERE OEM.EMPRESA = MEC.EMPRESA
              AND OEM.REVENDA = MEC.REVENDA
              AND OEM.EQUIPE  = MEC.EQUIPE
       )                                                                  NOME_EQUIPE,

       MEC.SECAO_OFICINA,

       (
           SELECT OSE.DES_SECAO
             FROM CNP.OFI_SECAO OSE
            WHERE OSE.EMPRESA       = MEC.EMPRESA
              AND OSE.REVENDA       = MEC.REVENDA
              AND OSE.SECAO_OFICINA = MEC.SECAO_OFICINA
       )                                                                  NOME_SECAO,

       /*======================================================================
           DADOS DA CATEGORIA DA O.S
       ======================================================================*/
       OOS.CATEGORIA_OS,

       (
           SELECT OCO.DES_CATEGORIA
             FROM CNP.OFI_CATEGORIA_OS OCO
            WHERE OCO.EMPRESA      = OOS.EMPRESA
              AND OCO.REVENDA      = OOS.REVENDA
              AND OCO.CATEGORIA_OS = OOS.CATEGORIA_OS
       )                                                                  NOME_CATEGORIA,

       /*======================================================================
           DESCRIÇÃO E IDENTIFICAÇÃO DO SERVIÇO
       ======================================================================*/
       SOS.DESCRICAO,

       CAST(
           (
               SELECT OSV.MAODEOBRA
                 FROM CNP.OFI_SERVICO OSV
                WHERE OSV.EMPRESA = SOS.EMPRESA
                  AND OSV.SERVICO = SOS.SERVICO
           ) AS VARCHAR(20)
       )                                                                  ITEM,

       1                                                                  RATEIO

  /*==========================================================================
      TABELA PRINCIPAL - ORDEM DE SERVIÇO
  ==========================================================================*/
  FROM CNP.OFI_ORDEM_SERVICO OOS

 /*===========================================================================
     MOVIMENTO DA FICHA
 ===========================================================================*/
 INNER JOIN
 (
     SELECT EMPRESA,
            REVENDA,
            NUMERO_NOTA_FISCAL,
            SERIE_NOTA_FISCAL,
            TIPO_TRANSACAO,
            CONTADOR,
            NRO_OS,
            OBSERVACAO
       FROM CNP.OFI_FICHA_MOVIMENTO
 ) OFM
    ON OFM.EMPRESA = OOS.EMPRESA
   AND OFM.REVENDA = OOS.REVENDA
   AND OFM.NRO_OS  = OOS.NRO_OS

 /*===========================================================================
     CAPA DO MOVIMENTO FATURADO
 ===========================================================================*/
 INNER JOIN
 (
     SELECT EMPRESA,
            REVENDA,
            NUMERO_NOTA_FISCAL,
            SERIE_NOTA_FISCAL,
            TIPO_TRANSACAO,
            CONTADOR,
            CLIENTE,
            TIPO_OS,
            FATOPERACAO,
            CONTATO,
            TOT_SERVICOS
       FROM CNP.FAT_MOVIMENTO_CAPA
 ) FMC
    ON FMC.EMPRESA                = OFM.EMPRESA
   AND FMC.REVENDA                = OFM.REVENDA
   AND FMC.NUMERO_NOTA_FISCAL     = OFM.NUMERO_NOTA_FISCAL
   AND FMC.SERIE_NOTA_FISCAL      = OFM.SERIE_NOTA_FISCAL
   AND FMC.TIPO_TRANSACAO         = OFM.TIPO_TRANSACAO
   AND FMC.CONTADOR               = OFM.CONTADOR

 /*===========================================================================
     SERVIÇOS FATURADOS
 ===========================================================================*/
 INNER JOIN
 (
     SELECT EMPRESA,
            REVENDA,
            NUMERO_NOTA_FISCAL,
            SERIE_NOTA_FISCAL,
            TIPO_TRANSACAO,
            CONTADOR,
            SERVICO
       FROM CNP.FAT_MOVIMENTO_SERVICO
 ) FMS
    ON FMS.EMPRESA                = FMC.EMPRESA
   AND FMS.REVENDA                = FMC.REVENDA
   AND FMS.NUMERO_NOTA_FISCAL     = FMC.NUMERO_NOTA_FISCAL
   AND FMS.SERIE_NOTA_FISCAL      = FMC.SERIE_NOTA_FISCAL
   AND FMS.TIPO_TRANSACAO         = FMC.TIPO_TRANSACAO
   AND FMS.CONTADOR               = FMC.CONTADOR

 /*===========================================================================
     SERVIÇOS EXECUTADOS NA O.S
 ===========================================================================*/
 INNER JOIN
 (
     SELECT OSO.EMPRESA,
            OSO.REVENDA,
            OSO.NRO_OS,
            OSO.NRO_LANCAMENTO,
            OSO.CONTATO,
            OSO.NRO_SOLICITACAO,
            OSO.SERVICO,
            OSO.MECANICO              MECANICO,
            OSO.SITUACAO,
            OSO.QUANTIDADE,
            OSO.VAL_SERVICO,
            OSO.VAL_DESCONTO,
            OSO.VAL_DESCONTO_FRANQUIA,
            OSO.DESCRICAO,
            1                         RATEIO
       FROM CNP.OFI_SERVICO_OS OSO
 ) SOS
    ON SOS.EMPRESA      = OOS.EMPRESA
   AND SOS.REVENDA      = OOS.REVENDA
   AND SOS.NRO_OS       = OOS.NRO_OS
   AND SOS.SITUACAO     = 'N'
   AND SOS.SERVICO      = FMS.SERVICO

 /*===========================================================================
     CADASTRO DE MECÂNICOS
 ===========================================================================*/
 INNER JOIN
 (
     SELECT EMPRESA,
            REVENDA,
            MECANICO,
            NOME,
            EQUIPE,
            SECAO_OFICINA
       FROM CNP.OFI_MECANICO
 ) MEC
    ON MEC.EMPRESA      = SOS.EMPRESA
   AND MEC.REVENDA      = SOS.REVENDA
   AND MEC.MECANICO     = SOS.MECANICO

 /*===========================================================================
     TIPOS DE SERVIÇO
 ===========================================================================*/
INNER JOIN
 (
     SELECT EMPRESA,
            REVENDA,
            TIPO_SERVICO,
            DES_TIPO_SERVICO,        
            TIPO_SERVICO_OS
       FROM CNP.OFI_TIPO_SERVICO
 ) OTS
    ON OTS.EMPRESA          = SOS.EMPRESA
   AND OTS.REVENDA          = SOS.REVENDA
   --AND OTS.TIPO_SERVICO     = SOS.TIPO_SERVICO
   AND OTS.TIPO_SERVICO_OS IN ('E', 'G', 'R', 'I')

 /*===========================================================================
     DADOS DO CLIENTE
 ===========================================================================*/
 LEFT JOIN
 (
     SELECT CLIENTE,
            NOME
       FROM CNP.FAT_CLIENTE
 ) CLI
    ON CLI.CLIENTE = FMC.CLIENTE

 /*===========================================================================
     SOLICITAÇÕES / DIAGNÓSTICOS
 ===========================================================================*/
 LEFT JOIN CNP.OFI_SOLICITACAO SOL
    ON SOL.EMPRESA             = SOS.EMPRESA
   AND SOL.REVENDA             = SOS.REVENDA
   AND SOL.CONTATO             = SOS.CONTATO
   AND SOL.NRO_SOLICITACAO     = SOS.NRO_SOLICITACAO

/*==============================================================================
    FILTROS DA VIEW
==============================================================================*/
 WHERE OOS.EMPRESA in (1,2)
   AND OOS.REVENDA in (1,2,3)
  -- AND FMC.TIPO_OS IN ('E', 'G', 'R', 'I')

   /*==========================================================================
       FILTRO DE ÚLTIMOS 36 MESES POR TIPO DE O.S
   ==========================================================================*/
   AND (
            (OTS.TIPO_SERVICO_OS = 'E' AND OOS.DTA_FIM_EXTERNO  >= ADD_MONTHS(SYSDATE, -36))
         OR (OTS.TIPO_SERVICO_OS = 'G' AND OOS.DTA_FIM_GARANTIA >= ADD_MONTHS(SYSDATE, -36))
         OR (OTS.TIPO_SERVICO_OS = 'R' AND OOS.DTA_FIM_REVISAO  >= ADD_MONTHS(SYSDATE, -36))
         OR (OTS.TIPO_SERVICO_OS = 'I' AND OOS.DTA_FIM_INTERNO  >= ADD_MONTHS(SYSDATE, -36))
       );