/*
  ============================================================
  ARQUIVO SQL - LOG DE EXECUÇÕES DO SISTEMA
  Data de geração: 06/03/2026
  Total de comandos: 1563
  ============================================================
*/

/* ============================================================
   SEÇÃO: COMANDOS DE ATUALIZAÇÃO (UPDATE)
   Total: 3 comando(s)
   ============================================================ */

-- [0001] Executado em: 06/03/2026 16:57:48
UPDATE VEI_VEICULO SET CLIENTE_RESERVA = NULL, EMPRESA_VENDEDOR_RESERVA = NULL, REVENDA_VENDEDOR_RESERVA = NULL, VENDEDOR_RESERVA = NULL, DTA_RESERVA = NULL, 
		DTA_FIM_RESERVA = NULL, OBSERVACAO_RESERVA = NULL, RESERVADO = 'N', TIPO_RESERVA = NULL, LOC_PROPOSTA_RESERVA = NULL, LOC_CONTRATO_RESERVA = NULL 
			WHERE EMPRESA = 1 
			AND RESERVADO = 'S' 
			AND DTA_FIM_RESERVA < TO_DATE('06/03/2026 16:57:51','dd/mm/yyyy HH24:MI:SS') 
			AND SITUACAO NOT IN 
			(
			SELECT SITUACAO 
			FROM CNP.VEI_SITUACAO 
			WHERE EMPRESA = VEI_VEICULO.EMPRESA 
			AND LOCALIZACAO = 'V') 
			AND VEICULO NOT IN 
			(
			SELECT VEICULO 
			FROM CNP.VEI_PROPOSTA 
			WHERE EMPRESA = VEI_VEICULO.EMPRESA 
			AND VEICULO = VEI_VEICULO.VEICULO 
			AND SITUACAO in ('2','5'))
;

-- [0002] Executado em: 06/03/2026 16:57:48
update VEI_PEDIDO set CLIENTE_RESERVA = null, REVENDA_RESERVA = null, VENDEDOR_RESERVA = null, DTA_FIM_RESERVA = null, OBSERVACAO = null 
		where EMPRESA = 1 
		and DTA_FIM_RESERVA < TO_DATE('06/03/2026 16:57:51','dd/mm/yyyy HH24:MI:SS') 
		and not exists (
		select 1 
		from CNP.VEI_PROPOSTA 
		where EMPRESA = VEI_PEDIDO.EMPRESA 
		and PEDIDO = VEI_PEDIDO.PEDIDO 
		and SITUACAO in ('2','5'))
;

-- [0003] Executado em: 06/03/2026 16:57:48
update VEI_PRE_RESERVA set SITUACAO = 'C', VENDEDOR_PRE_RESERVA = null, DTA_FIM_RESERVA = null, OBSERVACAO = null 
		where EMPRESA = 1 
		and DTA_FIM_RESERVA < TO_DATE('06/03/2026 16:57:51','dd/mm/yyyy HH24:MI:SS')
;

/* ============================================================
   SEÇÃO: CONSULTAS (SELECT)
   Total: 1560 comando(s)
   ============================================================ */

-- [0001] Executado em: 06/03/2026 16:57:46
select TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') from DUAL
;

-- [0002] Executado em: 06/03/2026 16:57:48
select CANCELA_RESERVA_BANCO from CNP.GER_EMPRESA where EMPRESA = 1
;

-- [0003] Executado em: 06/03/2026 16:57:48
SELECT
 V.EMPRESA,
 V.VEICULO,
 V.REVENDA_ORIGEM REVENDA,
 V.CHASSI,
 V.DEPARTAMENTO,
 D.NOME DES_DEPARTAMENTO,
 M.MODELO,
 M.DES_MODELO,
 M.PRECO_PUBLICO,
 M.FRETE_VENDA,
 M.VAL_SEGURO,
 C.COR,
 C.DES_COR,
 F.ANO_FABRICACAO,
 F.ANO_MODELO,
 F.CATEGORIA,
 F.PORTAS,
 A.DES_CATEGORIA_VEICULO DES_CATEGORIA,
 F.PLACA,
 F.COMBUSTIVEL,
 F.EDICAO,
 V.TIPO_COMERCIALIZACAO,
 T.DES_COMERCIALIZACAO,
 V.RESERVADO,
 V.SITUACAO,
 S.DES_SITUACAO,
 S.LOCALIZACAO,
 V.NOVO_USADO,
 V.DTA_FAT_FABRICA,
 V.DTA_ENTRADA,
 V.NUMERO_NOTA_NFENTRADA,
 V.DTA_VENDA,
 V.NUMERO_NOTA_NFSAIDA,
 V.SERIE_NOTA_FISCAL_NFSAIDA,
 V.TIPO_TRANSACAO_NFSAIDA,
 V.CONTADOR_NFSAIDA,
 V.VAL_CUSTO_CONTABIL,
 V.VAL_PRESENTE_VENDA,
 V.PRECO_MINIMO_COMERCIALIZACAO,
 V.QUILOMETRAGEM,
 F.PACOTE,
 V.FOTO_FRENTE,
 V.FOTO_LATERAL,
 V.FOTO_INTERNA,
 V.FOTO_TRASEIRA,
 V.FOTO_DOCUMENTO,
 VFA.FAMILIA_GRUPO,
 VFA.MARCA,
 (SELECT VFG.DES_FAMILIA_GRUPO FROM CNP.VEI_FAMILIA_GRUPO VFG WHERE VFG.EMPRESA = VFA.EMPRESA AND VFG.FAMILIA_GRUPO = VFA.FAMILIA_GRUPO) DES_FAMILIA_GRUPO, 
 (SELECT P.DES_PACOTE FROM CNP.VEI_PACOTE P WHERE F.EMPRESA = P.EMPRESA AND F.PACOTE = P.PACOTE) DES_PACOTE,
 COALESCE((SELECT SUM(VC.VAL_PRESENTE)
 FROM CNP.VEI_VEICULO_CUSTEIO VC,
 CNP.VEI_FORMULA_LINHA FL 
 WHERE VC.EMPRESA = V.EMPRESA
 AND VC.VEICULO = V.VEICULO
 AND VC.EMPRESA = FL.EMPRESA
 AND VC.FORMULA = FL.FORMULA
 AND VC.LINHA_FORMULA = FL.LINHA_FORMULA
 AND (FL.CUSTO_TOTAL = '+' or (FL.TIPO = 'B' AND (FL.INCIDENCIA = '(' OR FL.INCIDENCIA = ')'))) 
 AND FL.STATUS = 'A'
 GROUP BY VC.EMPRESA, VC.VEICULO),0)-
 COALESCE((SELECT SUM(VC.VAL_PRESENTE)
 FROM CNP.VEI_VEICULO_CUSTEIO VC,
 CNP.VEI_FORMULA_LINHA FL
 WHERE VC.EMPRESA = V.EMPRESA
 AND VC.VEICULO = V.VEICULO
 AND VC.EMPRESA = FL.EMPRESA
 AND VC.FORMULA = FL.FORMULA
 AND VC.LINHA_FORMULA = FL.LINHA_FORMULA
 AND FL.CUSTO_TOTAL = '-'
 AND FL.STATUS = 'A'
 GROUP BY VC.EMPRESA, VC.VEICULO),0) CUSTO,
 V.EMPRESA_NFENTRADA,
 V.REVENDA_NFENTRADA,
 V.PRECO_CONCESSIONARIA 
 FROM CNP.VEI_MODELO M, CNP.VEI_COR C,
 CNP.GER_DEPARTAMENTO D, CNP.VEI_CATEGORIA_VEICULO A, CNP.VEI_SITUACAO S, 
 CNP.OFI_FICHA_SEGUIMENTO F, CNP.VEI_TIPO_COMERCIALIZACAO T, CNP.VEI_VEICULO V, CNP.VEI_FAMILIA VFA
 WHERE V.CHASSI = F.CHASSI
 AND V.EMPRESA = M.EMPRESA
 AND V.MODELO = M.MODELO
 AND VFA.EMPRESA = M.EMPRESA
 AND VFA.FAMILIA = M.FAMILIA
 AND V.EMPRESA = C.EMPRESA
 AND V.COR = C.COR
 AND V.EMPRESA = D.EMPRESA
 AND V.REVENDA_ORIGEM = D.REVENDA
 AND V.DEPARTAMENTO = D.DEPARTAMENTO
 AND F.EMPRESA = A.EMPRESA
 AND F.CATEGORIA = A.CATEGORIA_VEICULO
 AND V.EMPRESA = S.EMPRESA
 AND V.SITUACAO = S.SITUACAO
 AND V.EMPRESA = T.EMPRESA
 AND V.TIPO_COMERCIALIZACAO = T.TIPO_COMERCIALIZACAO
 and ( (V.EMPRESA = 1 and V.REVENDA_ORIGEM = 1))
 AND V.NOVO_USADO = 'N'
 AND ((V.RESERVADO = 'S' 
 --AND V.DTA_FIM_RESERVA < TO_DATE('28/02/2026 00:01:00','dd/mm/yyyy HH24:MI:SS'))
 OR (V.RESERVADO = 'N') 
 OR (V.RESERVADO = 'S' 
-- AND V.DTA_FIM_RESERVA > TO_DATE('28/02/2026 00:01:00','dd/mm/yyyy HH24:MI:SS') 
 AND V.VEICULO IN 
 (
 SELECT VEICULO 
 FROM CNP.VEI_PROPOSTA 
 WHERE EMPRESA = M.EMPRESA 
 AND VEICULO = V.VEICULO 
 AND SITUACAO IN ('2','5'))))
 AND V.SITUACAO IN ('ES')
;

-- [0004] Executado em: 06/03/2026 16:57:48
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10989
;

-- [0005] Executado em: 06/03/2026 16:57:48
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 order by LINHA_FORMULA
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
;

-- [0006] Executado em: 06/03/2026 16:57:48
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10989' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0007] Executado em: 06/03/2026 16:57:48
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10989' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0008] Executado em: 06/03/2026 16:57:48
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1275797 order by DTA_PAGTO desc
;

-- [0009] Executado em: 06/03/2026 16:57:48
SELECT F.CHASSI, F.MODELO, M.OPCIONAL_PUB FROM CNP.OFI_FICHA_OPCIONAL F INNER JOIN CNP.VEI_OPCIONAL_MODELO M ON (M.EMPRESA = F.EMPRESA AND M.MODELO = F.MODELO AND M.OPCIONAL = F.OPCIONAL) WHERE F.EMPRESA = 1
;

-- [0010] Executado em: 06/03/2026 16:57:49
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0011] Executado em: 06/03/2026 16:57:49
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEA48A0TG196618'
;

-- [0012] Executado em: 06/03/2026 16:57:49
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEA48A0TG196618'
;

-- [0013] Executado em: 06/03/2026 16:57:49
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0014] Executado em: 06/03/2026 16:57:49
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10989' and v.EMPRESA = 1
;

-- [0015] Executado em: 06/03/2026 16:57:49
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10989' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0016] Executado em: 06/03/2026 16:57:49
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4716770
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0017] Executado em: 06/03/2026 16:57:49
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0018] Executado em: 06/03/2026 16:57:49
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10989' and v.EMPRESA = 1
;

-- [0019] Executado em: 06/03/2026 16:57:49
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10989' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0020] Executado em: 06/03/2026 16:57:49
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4716770
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0021] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0022] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0023] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0024] Executado em: 06/03/2026 16:57:50
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10989' and v.EMPRESA = 1
;

-- [0025] Executado em: 06/03/2026 16:57:50
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10989' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0026] Executado em: 06/03/2026 16:57:50
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4716770
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0027] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0028] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0029] Executado em: 06/03/2026 16:57:50
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10989' and v.EMPRESA = 1
;

-- [0030] Executado em: 06/03/2026 16:57:50
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10989' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0031] Executado em: 06/03/2026 16:57:50
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4716770
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0032] Executado em: 06/03/2026 16:57:50
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0033] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0034] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0035] Executado em: 06/03/2026 16:57:50
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10989'
;

-- [0036] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0037] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0038] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0039] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0040] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0041] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0042] Executado em: 06/03/2026 16:57:50
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEA48A0TG196618
--   :2 (WideString,IN) = 5A48AT
;

-- [0043] Executado em: 06/03/2026 16:57:50
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEA48A0TG196618'
;

-- [0044] Executado em: 06/03/2026 16:57:50
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5A48AT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0045] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0046] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0047] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0048] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0049] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0050] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0051] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0052] Executado em: 06/03/2026 16:57:50
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10989' and v.EMPRESA = 1
;

-- [0053] Executado em: 06/03/2026 16:57:50
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10989' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0054] Executado em: 06/03/2026 16:57:50
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4716770
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0055] Executado em: 06/03/2026 16:57:50
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0056] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0057] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0058] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0059] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0060] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0061] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0062] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0063] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0064] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0065] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0066] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0067] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0068] Executado em: 06/03/2026 16:57:50
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0069] Executado em: 06/03/2026 16:57:50
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0070] Executado em: 06/03/2026 16:57:50
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEA48A0TG196618
--   :2 (WideString,IN) = 5A48AT
;

-- [0071] Executado em: 06/03/2026 16:57:51
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEA48A0TG196618'
;

-- [0072] Executado em: 06/03/2026 16:57:51
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5A48AT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0073] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0074] Executado em: 06/03/2026 16:57:51
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0075] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0076] Executado em: 06/03/2026 16:57:51
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10989' and v.EMPRESA = 1
;

-- [0077] Executado em: 06/03/2026 16:57:51
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10989' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0078] Executado em: 06/03/2026 16:57:51
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4716770
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0079] Executado em: 06/03/2026 16:57:51
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0080] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0081] Executado em: 06/03/2026 16:57:51
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0082] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0083] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0084] Executado em: 06/03/2026 16:57:51
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0085] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0086] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0087] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0088] Executado em: 06/03/2026 16:57:51
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0089] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0090] Executado em: 06/03/2026 16:57:51
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10989
;

-- [0091] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0092] Executado em: 06/03/2026 16:57:51
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10989
;

-- [0093] Executado em: 06/03/2026 16:57:51
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0094] Executado em: 06/03/2026 16:57:51
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEA48A0TG196618
--   :2 (WideString,IN) = 5A48AT
;

-- [0095] Executado em: 06/03/2026 16:57:51
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEA48A0TG196618'
;

-- [0096] Executado em: 06/03/2026 16:57:51
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5A48AT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0097] Executado em: 06/03/2026 16:57:51
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10983
;

-- [0098] Executado em: 06/03/2026 16:57:51
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10983' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0099] Executado em: 06/03/2026 16:57:51
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10983' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0100] Executado em: 06/03/2026 16:57:51
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1274110 order by DTA_PAGTO desc
;

-- [0101] Executado em: 06/03/2026 16:57:51
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0102] Executado em: 06/03/2026 16:57:51
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '8AGEY76T0TR102559'
;

-- [0103] Executado em: 06/03/2026 16:57:51
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '8AGEY76T0TR102559'
;

-- [0104] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0105] Executado em: 06/03/2026 16:57:51
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10983' and v.EMPRESA = 1
;

-- [0106] Executado em: 06/03/2026 16:57:51
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10983' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0107] Executado em: 06/03/2026 16:57:51
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4710981
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0108] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0109] Executado em: 06/03/2026 16:57:51
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10983' and v.EMPRESA = 1
;

-- [0110] Executado em: 06/03/2026 16:57:51
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10983' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0111] Executado em: 06/03/2026 16:57:51
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4710981
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0112] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0113] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0114] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0115] Executado em: 06/03/2026 16:57:51
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10983' and v.EMPRESA = 1
;

-- [0116] Executado em: 06/03/2026 16:57:51
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10983' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0117] Executado em: 06/03/2026 16:57:51
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4710981
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0118] Executado em: 06/03/2026 16:57:51
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0119] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0120] Executado em: 06/03/2026 16:57:52
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10983' and v.EMPRESA = 1
;

-- [0121] Executado em: 06/03/2026 16:57:52
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10983' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0122] Executado em: 06/03/2026 16:57:52
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4710981
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0123] Executado em: 06/03/2026 16:57:52
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0124] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0125] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0126] Executado em: 06/03/2026 16:57:52
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10983'
;

-- [0127] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0128] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0129] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0130] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0131] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0132] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0133] Executado em: 06/03/2026 16:57:52
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 8AGEY76T0TR102559
--   :2 (WideString,IN) = 3Y76TT
;

-- [0134] Executado em: 06/03/2026 16:57:52
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '8AGEY76T0TR102559'
;

-- [0135] Executado em: 06/03/2026 16:57:52
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3Y76TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0136] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0137] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0138] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0139] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0140] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0141] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0142] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0143] Executado em: 06/03/2026 16:57:52
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10983' and v.EMPRESA = 1
;

-- [0144] Executado em: 06/03/2026 16:57:52
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10983' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0145] Executado em: 06/03/2026 16:57:52
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4710981
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0146] Executado em: 06/03/2026 16:57:52
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0147] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0148] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0149] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0150] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0151] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0152] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0153] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0154] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0155] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0156] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0157] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0158] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0159] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0160] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0161] Executado em: 06/03/2026 16:57:52
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 8AGEY76T0TR102559
--   :2 (WideString,IN) = 3Y76TT
;

-- [0162] Executado em: 06/03/2026 16:57:52
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '8AGEY76T0TR102559'
;

-- [0163] Executado em: 06/03/2026 16:57:52
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3Y76TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0164] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0165] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0166] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0167] Executado em: 06/03/2026 16:57:52
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10983' and v.EMPRESA = 1
;

-- [0168] Executado em: 06/03/2026 16:57:52
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10983' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0169] Executado em: 06/03/2026 16:57:52
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4710981
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0170] Executado em: 06/03/2026 16:57:52
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0171] Executado em: 06/03/2026 16:57:52
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0172] Executado em: 06/03/2026 16:57:52
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0173] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0174] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0175] Executado em: 06/03/2026 16:57:53
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0176] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0177] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0178] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0179] Executado em: 06/03/2026 16:57:53
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0180] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0181] Executado em: 06/03/2026 16:57:53
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10983
;

-- [0182] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0183] Executado em: 06/03/2026 16:57:53
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10983
;

-- [0184] Executado em: 06/03/2026 16:57:53
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 8AGEY76T0TR102559
--   :2 (WideString,IN) = 3Y76TT
;

-- [0185] Executado em: 06/03/2026 16:57:53
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '8AGEY76T0TR102559'
;

-- [0186] Executado em: 06/03/2026 16:57:53
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3Y76TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0187] Executado em: 06/03/2026 16:57:53
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10988
;

-- [0188] Executado em: 06/03/2026 16:57:53
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10988' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0189] Executado em: 06/03/2026 16:57:53
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10988' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0190] Executado em: 06/03/2026 16:57:53
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1275378 order by DTA_PAGTO desc
;

-- [0191] Executado em: 06/03/2026 16:57:53
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0192] Executado em: 06/03/2026 16:57:53
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEY69H0TG195516'
;

-- [0193] Executado em: 06/03/2026 16:57:53
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEY69H0TG195516'
;

-- [0194] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0195] Executado em: 06/03/2026 16:57:53
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10988' and v.EMPRESA = 1
;

-- [0196] Executado em: 06/03/2026 16:57:53
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10988' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0197] Executado em: 06/03/2026 16:57:53
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4715533
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0198] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0199] Executado em: 06/03/2026 16:57:53
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10988' and v.EMPRESA = 1
;

-- [0200] Executado em: 06/03/2026 16:57:53
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10988' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0201] Executado em: 06/03/2026 16:57:53
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4715533
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0202] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0203] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0204] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0205] Executado em: 06/03/2026 16:57:53
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10988' and v.EMPRESA = 1
;

-- [0206] Executado em: 06/03/2026 16:57:53
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10988' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0207] Executado em: 06/03/2026 16:57:53
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4715533
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0208] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0209] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0210] Executado em: 06/03/2026 16:57:53
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10988' and v.EMPRESA = 1
;

-- [0211] Executado em: 06/03/2026 16:57:53
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10988' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0212] Executado em: 06/03/2026 16:57:53
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4715533
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0213] Executado em: 06/03/2026 16:57:53
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0214] Executado em: 06/03/2026 16:57:53
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0215] Executado em: 06/03/2026 16:57:53
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0216] Executado em: 06/03/2026 16:57:53
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10988'
;

-- [0217] Executado em: 06/03/2026 16:57:53
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0218] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0219] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0220] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0221] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0222] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0223] Executado em: 06/03/2026 16:57:54
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY69H0TG195516
--   :2 (WideString,IN) = 5Y69HT
;

-- [0224] Executado em: 06/03/2026 16:57:54
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY69H0TG195516'
;

-- [0225] Executado em: 06/03/2026 16:57:54
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y69HT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0226] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0227] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0228] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0229] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0230] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0231] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0232] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0233] Executado em: 06/03/2026 16:57:54
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10988' and v.EMPRESA = 1
;

-- [0234] Executado em: 06/03/2026 16:57:54
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10988' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0235] Executado em: 06/03/2026 16:57:54
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4715533
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0236] Executado em: 06/03/2026 16:57:54
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0237] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0238] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0239] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0240] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0241] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0242] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0243] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0244] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0245] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0246] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0247] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0248] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0249] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0250] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0251] Executado em: 06/03/2026 16:57:54
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY69H0TG195516
--   :2 (WideString,IN) = 5Y69HT
;

-- [0252] Executado em: 06/03/2026 16:57:54
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY69H0TG195516'
;

-- [0253] Executado em: 06/03/2026 16:57:54
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y69HT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0254] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0255] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0256] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0257] Executado em: 06/03/2026 16:57:54
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10988' and v.EMPRESA = 1
;

-- [0258] Executado em: 06/03/2026 16:57:54
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10988' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0259] Executado em: 06/03/2026 16:57:54
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4715533
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0260] Executado em: 06/03/2026 16:57:54
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0261] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0262] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0263] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0264] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0265] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0266] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0267] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0268] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0269] Executado em: 06/03/2026 16:57:54
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0270] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0271] Executado em: 06/03/2026 16:57:54
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10988
;

-- [0272] Executado em: 06/03/2026 16:57:54
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0273] Executado em: 06/03/2026 16:57:55
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10988
;

-- [0274] Executado em: 06/03/2026 16:57:55
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY69H0TG195516
--   :2 (WideString,IN) = 5Y69HT
;

-- [0275] Executado em: 06/03/2026 16:57:55
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY69H0TG195516'
;

-- [0276] Executado em: 06/03/2026 16:57:55
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y69HT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0277] Executado em: 06/03/2026 16:57:55
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN11003
;

-- [0278] Executado em: 06/03/2026 16:57:55
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN11003' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0279] Executado em: 06/03/2026 16:57:55
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN11003' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0280] Executado em: 06/03/2026 16:57:55
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1278856 order by DTA_PAGTO desc
;

-- [0281] Executado em: 06/03/2026 16:57:55
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0282] Executado em: 06/03/2026 16:57:55
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEA48A0TG200235'
;

-- [0283] Executado em: 06/03/2026 16:57:55
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEA48A0TG200235'
;

-- [0284] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0285] Executado em: 06/03/2026 16:57:55
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN11003' and v.EMPRESA = 1
;

-- [0286] Executado em: 06/03/2026 16:57:55
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN11003' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0287] Executado em: 06/03/2026 16:57:55
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4725244
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0288] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0289] Executado em: 06/03/2026 16:57:55
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN11003' and v.EMPRESA = 1
;

-- [0290] Executado em: 06/03/2026 16:57:55
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN11003' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0291] Executado em: 06/03/2026 16:57:55
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4725244
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0292] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0293] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0294] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0295] Executado em: 06/03/2026 16:57:55
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN11003' and v.EMPRESA = 1
;

-- [0296] Executado em: 06/03/2026 16:57:55
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN11003' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0297] Executado em: 06/03/2026 16:57:55
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4725244
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0298] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0299] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0300] Executado em: 06/03/2026 16:57:55
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN11003' and v.EMPRESA = 1
;

-- [0301] Executado em: 06/03/2026 16:57:55
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN11003' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0302] Executado em: 06/03/2026 16:57:55
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4725244
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0303] Executado em: 06/03/2026 16:57:55
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0304] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0305] Executado em: 06/03/2026 16:57:55
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0306] Executado em: 06/03/2026 16:57:55
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN11003'
;

-- [0307] Executado em: 06/03/2026 16:57:55
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0308] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0309] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0310] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0311] Executado em: 06/03/2026 16:57:55
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0312] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0313] Executado em: 06/03/2026 16:57:55
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEA48A0TG200235
--   :2 (WideString,IN) = 5A48AT
;

-- [0314] Executado em: 06/03/2026 16:57:55
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEA48A0TG200235'
;

-- [0315] Executado em: 06/03/2026 16:57:55
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5A48AT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0316] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0317] Executado em: 06/03/2026 16:57:55
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0318] Executado em: 06/03/2026 16:57:55
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0319] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0320] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0321] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0322] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0323] Executado em: 06/03/2026 16:57:56
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN11003' and v.EMPRESA = 1
;

-- [0324] Executado em: 06/03/2026 16:57:56
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN11003' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0325] Executado em: 06/03/2026 16:57:56
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4725244
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0326] Executado em: 06/03/2026 16:57:56
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0327] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0328] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0329] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0330] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0331] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0332] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0333] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0334] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0335] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0336] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0337] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0338] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0339] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0340] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0341] Executado em: 06/03/2026 16:57:56
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEA48A0TG200235
--   :2 (WideString,IN) = 5A48AT
;

-- [0342] Executado em: 06/03/2026 16:57:56
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEA48A0TG200235'
;

-- [0343] Executado em: 06/03/2026 16:57:56
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5A48AT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0344] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0345] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0346] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0347] Executado em: 06/03/2026 16:57:56
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN11003' and v.EMPRESA = 1
;

-- [0348] Executado em: 06/03/2026 16:57:56
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN11003' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0349] Executado em: 06/03/2026 16:57:56
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4725244
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0350] Executado em: 06/03/2026 16:57:56
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0351] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0352] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0353] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0354] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0355] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0356] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0357] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0358] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0359] Executado em: 06/03/2026 16:57:56
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0360] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0361] Executado em: 06/03/2026 16:57:56
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN11003
;

-- [0362] Executado em: 06/03/2026 16:57:56
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0363] Executado em: 06/03/2026 16:57:56
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN11003
;

-- [0364] Executado em: 06/03/2026 16:57:56
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEA48A0TG200235
--   :2 (WideString,IN) = 5A48AT
;

-- [0365] Executado em: 06/03/2026 16:57:56
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEA48A0TG200235'
;

-- [0366] Executado em: 06/03/2026 16:57:56
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5A48AT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0367] Executado em: 06/03/2026 16:57:56
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10954
;

-- [0368] Executado em: 06/03/2026 16:57:56
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10954' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0369] Executado em: 06/03/2026 16:57:56
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10954' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0370] Executado em: 06/03/2026 16:57:56
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1266736 order by DTA_PAGTO desc
;

-- [0371] Executado em: 06/03/2026 16:57:57
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0372] Executado em: 06/03/2026 16:57:57
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGJP7520TB169557'
;

-- [0373] Executado em: 06/03/2026 16:57:57
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGJP7520TB169557'
;

-- [0374] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0375] Executado em: 06/03/2026 16:57:57
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10954' and v.EMPRESA = 1
;

-- [0376] Executado em: 06/03/2026 16:57:57
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10954' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0377] Executado em: 06/03/2026 16:57:57
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2978706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0378] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0379] Executado em: 06/03/2026 16:57:57
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10954' and v.EMPRESA = 1
;

-- [0380] Executado em: 06/03/2026 16:57:57
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10954' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0381] Executado em: 06/03/2026 16:57:57
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2978706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0382] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0383] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0384] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0385] Executado em: 06/03/2026 16:57:57
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10954' and v.EMPRESA = 1
;

-- [0386] Executado em: 06/03/2026 16:57:57
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10954' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0387] Executado em: 06/03/2026 16:57:57
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2978706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0388] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0389] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0390] Executado em: 06/03/2026 16:57:57
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10954' and v.EMPRESA = 1
;

-- [0391] Executado em: 06/03/2026 16:57:57
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10954' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0392] Executado em: 06/03/2026 16:57:57
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2978706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0393] Executado em: 06/03/2026 16:57:57
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0394] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0395] Executado em: 06/03/2026 16:57:57
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0396] Executado em: 06/03/2026 16:57:57
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10954'
;

-- [0397] Executado em: 06/03/2026 16:57:57
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0398] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0399] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0400] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0401] Executado em: 06/03/2026 16:57:57
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0402] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0403] Executado em: 06/03/2026 16:57:57
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGJP7520TB169557
--   :2 (WideString,IN) = 5P752T
;

-- [0404] Executado em: 06/03/2026 16:57:57
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGJP7520TB169557'
;

-- [0405] Executado em: 06/03/2026 16:57:57
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5P752T
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0406] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0407] Executado em: 06/03/2026 16:57:57
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0408] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0409] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0410] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0411] Executado em: 06/03/2026 16:57:57
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0412] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0413] Executado em: 06/03/2026 16:57:57
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10954' and v.EMPRESA = 1
;

-- [0414] Executado em: 06/03/2026 16:57:57
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10954' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0415] Executado em: 06/03/2026 16:57:57
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2978706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0416] Executado em: 06/03/2026 16:57:57
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0417] Executado em: 06/03/2026 16:57:57
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0418] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0419] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0420] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0421] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0422] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0423] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0424] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0425] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0426] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0427] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0428] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0429] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0430] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0431] Executado em: 06/03/2026 16:57:58
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGJP7520TB169557
--   :2 (WideString,IN) = 5P752T
;

-- [0432] Executado em: 06/03/2026 16:57:58
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGJP7520TB169557'
;

-- [0433] Executado em: 06/03/2026 16:57:58
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5P752T
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0434] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0435] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0436] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0437] Executado em: 06/03/2026 16:57:58
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10954' and v.EMPRESA = 1
;

-- [0438] Executado em: 06/03/2026 16:57:58
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10954' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0439] Executado em: 06/03/2026 16:57:58
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2978706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0440] Executado em: 06/03/2026 16:57:58
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0441] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0442] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0443] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0444] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0445] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0446] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0447] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0448] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0449] Executado em: 06/03/2026 16:57:58
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0450] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0451] Executado em: 06/03/2026 16:57:58
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10954
;

-- [0452] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0453] Executado em: 06/03/2026 16:57:58
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10954
;

-- [0454] Executado em: 06/03/2026 16:57:58
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGJP7520TB169557
--   :2 (WideString,IN) = 5P752T
;

-- [0455] Executado em: 06/03/2026 16:57:58
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGJP7520TB169557'
;

-- [0456] Executado em: 06/03/2026 16:57:58
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5P752T
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0457] Executado em: 06/03/2026 16:57:58
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10990
;

-- [0458] Executado em: 06/03/2026 16:57:58
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10990' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0459] Executado em: 06/03/2026 16:57:58
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10990' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0460] Executado em: 06/03/2026 16:57:58
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1275897 order by DTA_PAGTO desc
;

-- [0461] Executado em: 06/03/2026 16:57:58
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0462] Executado em: 06/03/2026 16:57:58
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEX76D0TB190062'
;

-- [0463] Executado em: 06/03/2026 16:57:58
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEX76D0TB190062'
;

-- [0464] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0465] Executado em: 06/03/2026 16:57:58
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10990' and v.EMPRESA = 1
;

-- [0466] Executado em: 06/03/2026 16:57:58
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10990' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0467] Executado em: 06/03/2026 16:57:58
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3004706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0468] Executado em: 06/03/2026 16:57:58
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0469] Executado em: 06/03/2026 16:57:58
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10990' and v.EMPRESA = 1
;

-- [0470] Executado em: 06/03/2026 16:57:59
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10990' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0471] Executado em: 06/03/2026 16:57:59
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3004706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0472] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0473] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0474] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0475] Executado em: 06/03/2026 16:57:59
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10990' and v.EMPRESA = 1
;

-- [0476] Executado em: 06/03/2026 16:57:59
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10990' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0477] Executado em: 06/03/2026 16:57:59
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3004706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0478] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0479] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0480] Executado em: 06/03/2026 16:57:59
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10990' and v.EMPRESA = 1
;

-- [0481] Executado em: 06/03/2026 16:57:59
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10990' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0482] Executado em: 06/03/2026 16:57:59
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3004706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0483] Executado em: 06/03/2026 16:57:59
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0484] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0485] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0486] Executado em: 06/03/2026 16:57:59
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10990'
;

-- [0487] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0488] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0489] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0490] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0491] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0492] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0493] Executado em: 06/03/2026 16:57:59
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB190062
--   :2 (WideString,IN) = 5X76DT
;

-- [0494] Executado em: 06/03/2026 16:57:59
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB190062'
;

-- [0495] Executado em: 06/03/2026 16:57:59
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0496] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0497] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0498] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0499] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0500] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0501] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0502] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0503] Executado em: 06/03/2026 16:57:59
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10990' and v.EMPRESA = 1
;

-- [0504] Executado em: 06/03/2026 16:57:59
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10990' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0505] Executado em: 06/03/2026 16:57:59
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3004706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0506] Executado em: 06/03/2026 16:57:59
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0507] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0508] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0509] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0510] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0511] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0512] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0513] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0514] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0515] Executado em: 06/03/2026 16:57:59
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0516] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0517] Executado em: 06/03/2026 16:57:59
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0518] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0519] Executado em: 06/03/2026 16:58:00
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0520] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0521] Executado em: 06/03/2026 16:58:00
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB190062
--   :2 (WideString,IN) = 5X76DT
;

-- [0522] Executado em: 06/03/2026 16:58:00
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB190062'
;

-- [0523] Executado em: 06/03/2026 16:58:00
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0524] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0525] Executado em: 06/03/2026 16:58:00
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0526] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0527] Executado em: 06/03/2026 16:58:00
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10990' and v.EMPRESA = 1
;

-- [0528] Executado em: 06/03/2026 16:58:00
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10990' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0529] Executado em: 06/03/2026 16:58:00
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3004706
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0530] Executado em: 06/03/2026 16:58:00
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0531] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0532] Executado em: 06/03/2026 16:58:00
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0533] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0534] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0535] Executado em: 06/03/2026 16:58:00
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0536] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0537] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0538] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0539] Executado em: 06/03/2026 16:58:00
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0540] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0541] Executado em: 06/03/2026 16:58:00
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10990
;

-- [0542] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0543] Executado em: 06/03/2026 16:58:00
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10990
;

-- [0544] Executado em: 06/03/2026 16:58:00
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB190062
--   :2 (WideString,IN) = 5X76DT
;

-- [0545] Executado em: 06/03/2026 16:58:00
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB190062'
;

-- [0546] Executado em: 06/03/2026 16:58:00
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0547] Executado em: 06/03/2026 16:58:00
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10942
;

-- [0548] Executado em: 06/03/2026 16:58:00
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10942' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0549] Executado em: 06/03/2026 16:58:00
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10942' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0550] Executado em: 06/03/2026 16:58:00
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1263344 order by DTA_PAGTO desc
;

-- [0551] Executado em: 06/03/2026 16:58:00
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0552] Executado em: 06/03/2026 16:58:00
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEX76D0TB167284'
;

-- [0553] Executado em: 06/03/2026 16:58:00
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEX76D0TB167284'
;

-- [0554] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0555] Executado em: 06/03/2026 16:58:00
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10942' and v.EMPRESA = 1
;

-- [0556] Executado em: 06/03/2026 16:58:00
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10942' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0557] Executado em: 06/03/2026 16:58:00
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2973694
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0558] Executado em: 06/03/2026 16:58:00
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0559] Executado em: 06/03/2026 16:58:00
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10942' and v.EMPRESA = 1
;

-- [0560] Executado em: 06/03/2026 16:58:00
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10942' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0561] Executado em: 06/03/2026 16:58:00
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2973694
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0562] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0563] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0564] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0565] Executado em: 06/03/2026 16:58:01
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10942' and v.EMPRESA = 1
;

-- [0566] Executado em: 06/03/2026 16:58:01
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10942' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0567] Executado em: 06/03/2026 16:58:01
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2973694
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0568] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0569] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0570] Executado em: 06/03/2026 16:58:01
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10942' and v.EMPRESA = 1
;

-- [0571] Executado em: 06/03/2026 16:58:01
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10942' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0572] Executado em: 06/03/2026 16:58:01
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2973694
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0573] Executado em: 06/03/2026 16:58:01
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0574] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0575] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0576] Executado em: 06/03/2026 16:58:01
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10942'
;

-- [0577] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0578] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0579] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0580] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0581] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0582] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0583] Executado em: 06/03/2026 16:58:01
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB167284
--   :2 (WideString,IN) = 5X76DT
;

-- [0584] Executado em: 06/03/2026 16:58:01
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB167284'
;

-- [0585] Executado em: 06/03/2026 16:58:01
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0586] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0587] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0588] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0589] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0590] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0591] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0592] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0593] Executado em: 06/03/2026 16:58:01
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10942' and v.EMPRESA = 1
;

-- [0594] Executado em: 06/03/2026 16:58:01
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10942' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0595] Executado em: 06/03/2026 16:58:01
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2973694
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0596] Executado em: 06/03/2026 16:58:01
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0597] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0598] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0599] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0600] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0601] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0602] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0603] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0604] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0605] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0606] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0607] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0608] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0609] Executado em: 06/03/2026 16:58:01
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0610] Executado em: 06/03/2026 16:58:01
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0611] Executado em: 06/03/2026 16:58:02
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB167284
--   :2 (WideString,IN) = 5X76DT
;

-- [0612] Executado em: 06/03/2026 16:58:02
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB167284'
;

-- [0613] Executado em: 06/03/2026 16:58:02
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0614] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0615] Executado em: 06/03/2026 16:58:02
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0616] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0617] Executado em: 06/03/2026 16:58:02
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10942' and v.EMPRESA = 1
;

-- [0618] Executado em: 06/03/2026 16:58:02
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10942' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0619] Executado em: 06/03/2026 16:58:02
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2973694
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0620] Executado em: 06/03/2026 16:58:02
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0621] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0622] Executado em: 06/03/2026 16:58:02
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0623] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0624] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0625] Executado em: 06/03/2026 16:58:02
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0626] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0627] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0628] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0629] Executado em: 06/03/2026 16:58:02
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0630] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0631] Executado em: 06/03/2026 16:58:02
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10942
;

-- [0632] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0633] Executado em: 06/03/2026 16:58:02
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10942
;

-- [0634] Executado em: 06/03/2026 16:58:02
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB167284
--   :2 (WideString,IN) = 5X76DT
;

-- [0635] Executado em: 06/03/2026 16:58:02
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB167284'
;

-- [0636] Executado em: 06/03/2026 16:58:02
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0637] Executado em: 06/03/2026 16:58:02
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10993
;

-- [0638] Executado em: 06/03/2026 16:58:02
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10993' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0639] Executado em: 06/03/2026 16:58:02
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10993' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0640] Executado em: 06/03/2026 16:58:02
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1277322 order by DTA_PAGTO desc
;

-- [0641] Executado em: 06/03/2026 16:58:02
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0642] Executado em: 06/03/2026 16:58:02
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = 'LK6ADAE49TB056871'
;

-- [0643] Executado em: 06/03/2026 16:58:02
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = 'LK6ADAE49TB056871'
;

-- [0644] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0645] Executado em: 06/03/2026 16:58:02
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10993' and v.EMPRESA = 1
;

-- [0646] Executado em: 06/03/2026 16:58:02
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10993' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0647] Executado em: 06/03/2026 16:58:02
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3002922
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0648] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0649] Executado em: 06/03/2026 16:58:02
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10993' and v.EMPRESA = 1
;

-- [0650] Executado em: 06/03/2026 16:58:02
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10993' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0651] Executado em: 06/03/2026 16:58:02
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3002922
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0652] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0653] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0654] Executado em: 06/03/2026 16:58:02
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0655] Executado em: 06/03/2026 16:58:02
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10993' and v.EMPRESA = 1
;

-- [0656] Executado em: 06/03/2026 16:58:02
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10993' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0657] Executado em: 06/03/2026 16:58:03
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3002922
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0658] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0659] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0660] Executado em: 06/03/2026 16:58:03
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10993' and v.EMPRESA = 1
;

-- [0661] Executado em: 06/03/2026 16:58:03
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10993' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0662] Executado em: 06/03/2026 16:58:03
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3002922
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0663] Executado em: 06/03/2026 16:58:03
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0664] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0665] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0666] Executado em: 06/03/2026 16:58:03
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10993'
;

-- [0667] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0668] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0669] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0670] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0671] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0672] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0673] Executado em: 06/03/2026 16:58:03
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = LK6ADAE49TB056871
--   :2 (WideString,IN) = 1AAE4T
;

-- [0674] Executado em: 06/03/2026 16:58:03
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = 'LK6ADAE49TB056871'
;

-- [0675] Executado em: 06/03/2026 16:58:03
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 1AAE4T
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0676] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0677] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0678] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0679] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0680] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0681] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0682] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0683] Executado em: 06/03/2026 16:58:03
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10993' and v.EMPRESA = 1
;

-- [0684] Executado em: 06/03/2026 16:58:03
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10993' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0685] Executado em: 06/03/2026 16:58:03
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3002922
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0686] Executado em: 06/03/2026 16:58:03
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0687] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0688] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0689] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0690] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0691] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0692] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0693] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0694] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0695] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0696] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0697] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0698] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0699] Executado em: 06/03/2026 16:58:03
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0700] Executado em: 06/03/2026 16:58:03
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0701] Executado em: 06/03/2026 16:58:03
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = LK6ADAE49TB056871
--   :2 (WideString,IN) = 1AAE4T
;

-- [0702] Executado em: 06/03/2026 16:58:03
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = 'LK6ADAE49TB056871'
;

-- [0703] Executado em: 06/03/2026 16:58:03
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 1AAE4T
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0704] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0705] Executado em: 06/03/2026 16:58:04
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0706] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0707] Executado em: 06/03/2026 16:58:04
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10993' and v.EMPRESA = 1
;

-- [0708] Executado em: 06/03/2026 16:58:04
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10993' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0709] Executado em: 06/03/2026 16:58:04
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3002922
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0710] Executado em: 06/03/2026 16:58:04
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0711] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0712] Executado em: 06/03/2026 16:58:04
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0713] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0714] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0715] Executado em: 06/03/2026 16:58:04
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0716] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0717] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0718] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0719] Executado em: 06/03/2026 16:58:04
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0720] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0721] Executado em: 06/03/2026 16:58:04
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10993
;

-- [0722] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0723] Executado em: 06/03/2026 16:58:04
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10993
;

-- [0724] Executado em: 06/03/2026 16:58:04
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0725] Executado em: 06/03/2026 16:58:04
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = LK6ADAE49TB056871
--   :2 (WideString,IN) = 1AAE4T
;

-- [0726] Executado em: 06/03/2026 16:58:04
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = 'LK6ADAE49TB056871'
;

-- [0727] Executado em: 06/03/2026 16:58:04
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 1AAE4T
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0728] Executado em: 06/03/2026 16:58:04
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = PN01373
;

-- [0729] Executado em: 06/03/2026 16:58:04
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'PN01373' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0730] Executado em: 06/03/2026 16:58:04
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 2 and MV.VEICULO = 'PN01373' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0731] Executado em: 06/03/2026 16:58:04
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 2 and status = 'PT' and tipo = 'CP' and operacao = 211847 order by DTA_PAGTO desc
;

-- [0732] Executado em: 06/03/2026 16:58:04
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0733] Executado em: 06/03/2026 16:58:04
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEY76T0TB139260'
;

-- [0734] Executado em: 06/03/2026 16:58:04
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEY76T0TB139260'
;

-- [0735] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0736] Executado em: 06/03/2026 16:58:04
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01373' and v.EMPRESA = 1
;

-- [0737] Executado em: 06/03/2026 16:58:04
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0738] Executado em: 06/03/2026 16:58:04
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008601
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0739] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0740] Executado em: 06/03/2026 16:58:04
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01373' and v.EMPRESA = 1
;

-- [0741] Executado em: 06/03/2026 16:58:04
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0742] Executado em: 06/03/2026 16:58:04
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008601
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0743] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0744] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0745] Executado em: 06/03/2026 16:58:04
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0746] Executado em: 06/03/2026 16:58:04
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01373' and v.EMPRESA = 1
;

-- [0747] Executado em: 06/03/2026 16:58:04
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0748] Executado em: 06/03/2026 16:58:04
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008601
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0749] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0750] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0751] Executado em: 06/03/2026 16:58:05
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01373' and v.EMPRESA = 1
;

-- [0752] Executado em: 06/03/2026 16:58:05
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0753] Executado em: 06/03/2026 16:58:05
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008601
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0754] Executado em: 06/03/2026 16:58:05
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0755] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0756] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0757] Executado em: 06/03/2026 16:58:05
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'PN01373'
;

-- [0758] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0759] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0760] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0761] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0762] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0763] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0764] Executado em: 06/03/2026 16:58:05
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY76T0TB139260
--   :2 (WideString,IN) = 5Y76TT
;

-- [0765] Executado em: 06/03/2026 16:58:05
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY76T0TB139260'
;

-- [0766] Executado em: 06/03/2026 16:58:05
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y76TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0767] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0768] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0769] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0770] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0771] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0772] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0773] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0774] Executado em: 06/03/2026 16:58:05
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01373' and v.EMPRESA = 1
;

-- [0775] Executado em: 06/03/2026 16:58:05
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0776] Executado em: 06/03/2026 16:58:05
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008601
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0777] Executado em: 06/03/2026 16:58:05
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0778] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0779] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0780] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0781] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0782] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0783] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0784] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0785] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0786] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0787] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0788] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0789] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0790] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0791] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0792] Executado em: 06/03/2026 16:58:05
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY76T0TB139260
--   :2 (WideString,IN) = 5Y76TT
;

-- [0793] Executado em: 06/03/2026 16:58:05
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY76T0TB139260'
;

-- [0794] Executado em: 06/03/2026 16:58:05
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y76TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0795] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0796] Executado em: 06/03/2026 16:58:05
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0797] Executado em: 06/03/2026 16:58:05
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0798] Executado em: 06/03/2026 16:58:05
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01373' and v.EMPRESA = 1
;

-- [0799] Executado em: 06/03/2026 16:58:05
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01373' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0800] Executado em: 06/03/2026 16:58:05
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008601
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0801] Executado em: 06/03/2026 16:58:06
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0802] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0803] Executado em: 06/03/2026 16:58:06
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0804] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0805] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0806] Executado em: 06/03/2026 16:58:06
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0807] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0808] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0809] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0810] Executado em: 06/03/2026 16:58:06
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0811] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0812] Executado em: 06/03/2026 16:58:06
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = PN01373
;

-- [0813] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0814] Executado em: 06/03/2026 16:58:06
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = PN01373
;

-- [0815] Executado em: 06/03/2026 16:58:06
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY76T0TB139260
--   :2 (WideString,IN) = 5Y76TT
;

-- [0816] Executado em: 06/03/2026 16:58:06
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY76T0TB139260'
;

-- [0817] Executado em: 06/03/2026 16:58:06
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y76TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0818] Executado em: 06/03/2026 16:58:06
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10972
;

-- [0819] Executado em: 06/03/2026 16:58:06
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10972' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0820] Executado em: 06/03/2026 16:58:06
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10972' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0821] Executado em: 06/03/2026 16:58:06
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1268752 order by DTA_PAGTO desc
;

-- [0822] Executado em: 06/03/2026 16:58:06
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0823] Executado em: 06/03/2026 16:58:06
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEY48H0TG188862'
;

-- [0824] Executado em: 06/03/2026 16:58:06
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEY48H0TG188862'
;

-- [0825] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0826] Executado em: 06/03/2026 16:58:06
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10972' and v.EMPRESA = 1
;

-- [0827] Executado em: 06/03/2026 16:58:06
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10972' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0828] Executado em: 06/03/2026 16:58:06
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4706728
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0829] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0830] Executado em: 06/03/2026 16:58:06
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10972' and v.EMPRESA = 1
;

-- [0831] Executado em: 06/03/2026 16:58:06
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10972' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0832] Executado em: 06/03/2026 16:58:06
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4706728
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0833] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0834] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0835] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0836] Executado em: 06/03/2026 16:58:06
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10972' and v.EMPRESA = 1
;

-- [0837] Executado em: 06/03/2026 16:58:06
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10972' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0838] Executado em: 06/03/2026 16:58:06
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4706728
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0839] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0840] Executado em: 06/03/2026 16:58:06
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0841] Executado em: 06/03/2026 16:58:06
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10972' and v.EMPRESA = 1
;

-- [0842] Executado em: 06/03/2026 16:58:06
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10972' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0843] Executado em: 06/03/2026 16:58:07
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4706728
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0844] Executado em: 06/03/2026 16:58:07
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0845] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0846] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0847] Executado em: 06/03/2026 16:58:07
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10972'
;

-- [0848] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0849] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0850] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0851] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0852] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0853] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0854] Executado em: 06/03/2026 16:58:07
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY48H0TG188862
--   :2 (WideString,IN) = 5Y48HT
;

-- [0855] Executado em: 06/03/2026 16:58:07
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY48H0TG188862'
;

-- [0856] Executado em: 06/03/2026 16:58:07
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y48HT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0857] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0858] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0859] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0860] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0861] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0862] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0863] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0864] Executado em: 06/03/2026 16:58:07
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10972' and v.EMPRESA = 1
;

-- [0865] Executado em: 06/03/2026 16:58:07
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10972' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0866] Executado em: 06/03/2026 16:58:07
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4706728
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0867] Executado em: 06/03/2026 16:58:07
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0868] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0869] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0870] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0871] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0872] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0873] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0874] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0875] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0876] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0877] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0878] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0879] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0880] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0881] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0882] Executado em: 06/03/2026 16:58:07
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY48H0TG188862
--   :2 (WideString,IN) = 5Y48HT
;

-- [0883] Executado em: 06/03/2026 16:58:07
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY48H0TG188862'
;

-- [0884] Executado em: 06/03/2026 16:58:07
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y48HT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0885] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0886] Executado em: 06/03/2026 16:58:07
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0887] Executado em: 06/03/2026 16:58:07
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0888] Executado em: 06/03/2026 16:58:07
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10972' and v.EMPRESA = 1
;

-- [0889] Executado em: 06/03/2026 16:58:08
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10972' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0890] Executado em: 06/03/2026 16:58:08
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4706728
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0891] Executado em: 06/03/2026 16:58:08
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0892] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0893] Executado em: 06/03/2026 16:58:08
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0894] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0895] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0896] Executado em: 06/03/2026 16:58:08
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0897] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0898] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0899] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0900] Executado em: 06/03/2026 16:58:08
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0901] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0902] Executado em: 06/03/2026 16:58:08
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10972
;

-- [0903] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0904] Executado em: 06/03/2026 16:58:08
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10972
;

-- [0905] Executado em: 06/03/2026 16:58:08
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEY48H0TG188862
--   :2 (WideString,IN) = 5Y48HT
;

-- [0906] Executado em: 06/03/2026 16:58:08
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEY48H0TG188862'
;

-- [0907] Executado em: 06/03/2026 16:58:08
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5Y48HT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0908] Executado em: 06/03/2026 16:58:08
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = PN01354
;

-- [0909] Executado em: 06/03/2026 16:58:08
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'PN01354' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [0910] Executado em: 06/03/2026 16:58:08
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 2 and MV.VEICULO = 'PN01354' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [0911] Executado em: 06/03/2026 16:58:08
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 2 and status = 'PT' and tipo = 'CP' and operacao = 206965 order by DTA_PAGTO desc
;

-- [0912] Executado em: 06/03/2026 16:58:08
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [0913] Executado em: 06/03/2026 16:58:08
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '8AGEB76D0TR103085'
;

-- [0914] Executado em: 06/03/2026 16:58:08
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '8AGEB76D0TR103085'
;

-- [0915] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0916] Executado em: 06/03/2026 16:58:08
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01354' and v.EMPRESA = 1
;

-- [0917] Executado em: 06/03/2026 16:58:08
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0918] Executado em: 06/03/2026 16:58:08
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4662097
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0919] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0920] Executado em: 06/03/2026 16:58:08
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01354' and v.EMPRESA = 1
;

-- [0921] Executado em: 06/03/2026 16:58:08
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0922] Executado em: 06/03/2026 16:58:08
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4662097
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0923] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0924] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0925] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0926] Executado em: 06/03/2026 16:58:08
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01354' and v.EMPRESA = 1
;

-- [0927] Executado em: 06/03/2026 16:58:08
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0928] Executado em: 06/03/2026 16:58:08
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4662097
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0929] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0930] Executado em: 06/03/2026 16:58:08
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0931] Executado em: 06/03/2026 16:58:09
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01354' and v.EMPRESA = 1
;

-- [0932] Executado em: 06/03/2026 16:58:09
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0933] Executado em: 06/03/2026 16:58:09
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4662097
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0934] Executado em: 06/03/2026 16:58:09
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0935] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [0936] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [0937] Executado em: 06/03/2026 16:58:09
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'PN01354'
;

-- [0938] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [0939] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0940] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [0941] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [0942] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0943] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0944] Executado em: 06/03/2026 16:58:09
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 8AGEB76D0TR103085
--   :2 (WideString,IN) = 3B76DT
;

-- [0945] Executado em: 06/03/2026 16:58:09
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '8AGEB76D0TR103085'
;

-- [0946] Executado em: 06/03/2026 16:58:09
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3B76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0947] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [0948] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0949] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0950] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [0951] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [0952] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0953] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0954] Executado em: 06/03/2026 16:58:09
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01354' and v.EMPRESA = 1
;

-- [0955] Executado em: 06/03/2026 16:58:09
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0956] Executado em: 06/03/2026 16:58:09
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4662097
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0957] Executado em: 06/03/2026 16:58:09
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0958] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [0959] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0960] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0961] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [0962] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [0963] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0964] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0965] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [0966] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0967] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0968] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0969] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [0970] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0971] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0972] Executado em: 06/03/2026 16:58:09
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 8AGEB76D0TR103085
--   :2 (WideString,IN) = 3B76DT
;

-- [0973] Executado em: 06/03/2026 16:58:09
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '8AGEB76D0TR103085'
;

-- [0974] Executado em: 06/03/2026 16:58:09
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3B76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0975] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [0976] Executado em: 06/03/2026 16:58:09
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0977] Executado em: 06/03/2026 16:58:09
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0978] Executado em: 06/03/2026 16:58:09
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'PN01354' and v.EMPRESA = 1
;

-- [0979] Executado em: 06/03/2026 16:58:10
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR union select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'PN01354' and MC.EMPRESA = 1 and MC.REVENDA = 2 and MC.MODALIDADE = 'C' and MC.STATUS = 'F' and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [0980] Executado em: 06/03/2026 16:58:10
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 2
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4662097
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [0981] Executado em: 06/03/2026 16:58:10
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [0982] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [0983] Executado em: 06/03/2026 16:58:10
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0984] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0985] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [0986] Executado em: 06/03/2026 16:58:10
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0987] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0988] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [0989] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [0990] Executado em: 06/03/2026 16:58:10
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [0991] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0992] Executado em: 06/03/2026 16:58:10
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = PN01354
;

-- [0993] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [0994] Executado em: 06/03/2026 16:58:10
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = PN01354
;

-- [0995] Executado em: 06/03/2026 16:58:10
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 8AGEB76D0TR103085
--   :2 (WideString,IN) = 3B76DT
;

-- [0996] Executado em: 06/03/2026 16:58:10
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '8AGEB76D0TR103085'
;

-- [0997] Executado em: 06/03/2026 16:58:10
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3B76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [0998] Executado em: 06/03/2026 16:58:10
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10910
;

-- [0999] Executado em: 06/03/2026 16:58:10
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10910' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [1000] Executado em: 06/03/2026 16:58:10
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10910' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [1001] Executado em: 06/03/2026 16:58:10
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1255872 order by DTA_PAGTO desc
;

-- [1002] Executado em: 06/03/2026 16:58:10
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [1003] Executado em: 06/03/2026 16:58:10
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '3GNAX9EB4TL165868'
;

-- [1004] Executado em: 06/03/2026 16:58:10
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '3GNAX9EB4TL165868'
;

-- [1005] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1006] Executado em: 06/03/2026 16:58:10
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10910' and v.EMPRESA = 1
;

-- [1007] Executado em: 06/03/2026 16:58:10
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10910' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1008] Executado em: 06/03/2026 16:58:10
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4655338
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1009] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1010] Executado em: 06/03/2026 16:58:10
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10910' and v.EMPRESA = 1
;

-- [1011] Executado em: 06/03/2026 16:58:10
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10910' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1012] Executado em: 06/03/2026 16:58:10
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4655338
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1013] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1014] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1015] Executado em: 06/03/2026 16:58:10
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1016] Executado em: 06/03/2026 16:58:10
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10910' and v.EMPRESA = 1
;

-- [1017] Executado em: 06/03/2026 16:58:10
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10910' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1018] Executado em: 06/03/2026 16:58:10
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4655338
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1019] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1020] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1021] Executado em: 06/03/2026 16:58:11
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10910' and v.EMPRESA = 1
;

-- [1022] Executado em: 06/03/2026 16:58:11
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10910' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1023] Executado em: 06/03/2026 16:58:11
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4655338
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1024] Executado em: 06/03/2026 16:58:11
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1025] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1026] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [1027] Executado em: 06/03/2026 16:58:11
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10910'
;

-- [1028] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [1029] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1030] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [1031] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1032] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1033] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1034] Executado em: 06/03/2026 16:58:11
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 3GNAX9EB4TL165868
--   :2 (WideString,IN) = 3A9EZT
;

-- [1035] Executado em: 06/03/2026 16:58:11
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '3GNAX9EB4TL165868'
;

-- [1036] Executado em: 06/03/2026 16:58:11
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3A9EZT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1037] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1038] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1039] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1040] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [1041] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1042] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1043] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1044] Executado em: 06/03/2026 16:58:11
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10910' and v.EMPRESA = 1
;

-- [1045] Executado em: 06/03/2026 16:58:11
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10910' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1046] Executado em: 06/03/2026 16:58:11
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4655338
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1047] Executado em: 06/03/2026 16:58:11
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1048] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1049] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1050] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1051] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1052] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1053] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1054] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1055] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1056] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1057] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1058] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1059] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1060] Executado em: 06/03/2026 16:58:11
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1061] Executado em: 06/03/2026 16:58:11
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1062] Executado em: 06/03/2026 16:58:12
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 3GNAX9EB4TL165868
--   :2 (WideString,IN) = 3A9EZT
;

-- [1063] Executado em: 06/03/2026 16:58:12
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '3GNAX9EB4TL165868'
;

-- [1064] Executado em: 06/03/2026 16:58:12
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3A9EZT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1065] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1066] Executado em: 06/03/2026 16:58:12
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1067] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1068] Executado em: 06/03/2026 16:58:12
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10910' and v.EMPRESA = 1
;

-- [1069] Executado em: 06/03/2026 16:58:12
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10910' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1070] Executado em: 06/03/2026 16:58:12
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4655338
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1071] Executado em: 06/03/2026 16:58:12
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1072] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1073] Executado em: 06/03/2026 16:58:12
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1074] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1075] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1076] Executado em: 06/03/2026 16:58:12
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1077] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1078] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1079] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1080] Executado em: 06/03/2026 16:58:12
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1081] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1082] Executado em: 06/03/2026 16:58:12
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10910
;

-- [1083] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1084] Executado em: 06/03/2026 16:58:12
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10910
;

-- [1085] Executado em: 06/03/2026 16:58:12
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 3GNAX9EB4TL165868
--   :2 (WideString,IN) = 3A9EZT
;

-- [1086] Executado em: 06/03/2026 16:58:12
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '3GNAX9EB4TL165868'
;

-- [1087] Executado em: 06/03/2026 16:58:12
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3A9EZT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1088] Executado em: 06/03/2026 16:58:12
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10946
;

-- [1089] Executado em: 06/03/2026 16:58:12
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10946' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [1090] Executado em: 06/03/2026 16:58:12
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10946' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [1091] Executado em: 06/03/2026 16:58:12
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1264271 order by DTA_PAGTO desc
;

-- [1092] Executado em: 06/03/2026 16:58:12
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [1093] Executado em: 06/03/2026 16:58:12
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BG148MK0TC433240'
;

-- [1094] Executado em: 06/03/2026 16:58:12
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BG148MK0TC433240'
;

-- [1095] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1096] Executado em: 06/03/2026 16:58:12
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10946' and v.EMPRESA = 1
;

-- [1097] Executado em: 06/03/2026 16:58:12
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10946' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1098] Executado em: 06/03/2026 16:58:12
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 157346
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1099] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1100] Executado em: 06/03/2026 16:58:12
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10946' and v.EMPRESA = 1
;

-- [1101] Executado em: 06/03/2026 16:58:12
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10946' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1102] Executado em: 06/03/2026 16:58:12
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 157346
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1103] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1104] Executado em: 06/03/2026 16:58:12
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1105] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1106] Executado em: 06/03/2026 16:58:13
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10946' and v.EMPRESA = 1
;

-- [1107] Executado em: 06/03/2026 16:58:13
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10946' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1108] Executado em: 06/03/2026 16:58:13
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 157346
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1109] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1110] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1111] Executado em: 06/03/2026 16:58:13
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10946' and v.EMPRESA = 1
;

-- [1112] Executado em: 06/03/2026 16:58:13
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10946' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1113] Executado em: 06/03/2026 16:58:13
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 157346
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1114] Executado em: 06/03/2026 16:58:13
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1115] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1116] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [1117] Executado em: 06/03/2026 16:58:13
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10946'
;

-- [1118] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [1119] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1120] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [1121] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1122] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1123] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1124] Executado em: 06/03/2026 16:58:13
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BG148MK0TC433240
--   :2 (WideString,IN) = 148MKT
;

-- [1125] Executado em: 06/03/2026 16:58:13
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BG148MK0TC433240'
;

-- [1126] Executado em: 06/03/2026 16:58:13
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 148MKT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1127] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1128] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1129] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1130] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [1131] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1132] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1133] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1134] Executado em: 06/03/2026 16:58:13
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10946' and v.EMPRESA = 1
;

-- [1135] Executado em: 06/03/2026 16:58:13
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10946' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1136] Executado em: 06/03/2026 16:58:13
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 157346
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1137] Executado em: 06/03/2026 16:58:13
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1138] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1139] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1140] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1141] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1142] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1143] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1144] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1145] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1146] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1147] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1148] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1149] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1150] Executado em: 06/03/2026 16:58:13
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1151] Executado em: 06/03/2026 16:58:13
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1152] Executado em: 06/03/2026 16:58:14
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BG148MK0TC433240
--   :2 (WideString,IN) = 148MKT
;

-- [1153] Executado em: 06/03/2026 16:58:14
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BG148MK0TC433240'
;

-- [1154] Executado em: 06/03/2026 16:58:14
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 148MKT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1155] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1156] Executado em: 06/03/2026 16:58:14
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1157] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1158] Executado em: 06/03/2026 16:58:14
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10946' and v.EMPRESA = 1
;

-- [1159] Executado em: 06/03/2026 16:58:14
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10946' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1160] Executado em: 06/03/2026 16:58:14
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 157346
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1161] Executado em: 06/03/2026 16:58:14
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1162] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1163] Executado em: 06/03/2026 16:58:14
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1164] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1165] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1166] Executado em: 06/03/2026 16:58:14
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1167] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1168] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1169] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1170] Executado em: 06/03/2026 16:58:14
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1171] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1172] Executado em: 06/03/2026 16:58:14
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10946
;

-- [1173] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1174] Executado em: 06/03/2026 16:58:14
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10946
;

-- [1175] Executado em: 06/03/2026 16:58:14
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1176] Executado em: 06/03/2026 16:58:14
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BG148MK0TC433240
--   :2 (WideString,IN) = 148MKT
;

-- [1177] Executado em: 06/03/2026 16:58:14
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BG148MK0TC433240'
;

-- [1178] Executado em: 06/03/2026 16:58:14
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 148MKT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1179] Executado em: 06/03/2026 16:58:14
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10998
;

-- [1180] Executado em: 06/03/2026 16:58:14
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10998' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [1181] Executado em: 06/03/2026 16:58:14
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10998' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [1182] Executado em: 06/03/2026 16:58:14
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1278005 order by DTA_PAGTO desc
;

-- [1183] Executado em: 06/03/2026 16:58:14
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [1184] Executado em: 06/03/2026 16:58:14
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEX76D0TB192009'
;

-- [1185] Executado em: 06/03/2026 16:58:14
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEX76D0TB192009'
;

-- [1186] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1187] Executado em: 06/03/2026 16:58:14
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10998' and v.EMPRESA = 1
;

-- [1188] Executado em: 06/03/2026 16:58:14
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10998' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1189] Executado em: 06/03/2026 16:58:14
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008301
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1190] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1191] Executado em: 06/03/2026 16:58:14
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10998' and v.EMPRESA = 1
;

-- [1192] Executado em: 06/03/2026 16:58:14
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10998' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1193] Executado em: 06/03/2026 16:58:14
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008301
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1194] Executado em: 06/03/2026 16:58:14
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1195] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1196] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1197] Executado em: 06/03/2026 16:58:15
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10998' and v.EMPRESA = 1
;

-- [1198] Executado em: 06/03/2026 16:58:15
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10998' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1199] Executado em: 06/03/2026 16:58:15
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008301
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1200] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1201] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1202] Executado em: 06/03/2026 16:58:15
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10998' and v.EMPRESA = 1
;

-- [1203] Executado em: 06/03/2026 16:58:15
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10998' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1204] Executado em: 06/03/2026 16:58:15
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008301
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1205] Executado em: 06/03/2026 16:58:15
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1206] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1207] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [1208] Executado em: 06/03/2026 16:58:15
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10998'
;

-- [1209] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [1210] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1211] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [1212] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1213] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1214] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1215] Executado em: 06/03/2026 16:58:15
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB192009
--   :2 (WideString,IN) = 5X76DT
;

-- [1216] Executado em: 06/03/2026 16:58:15
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB192009'
;

-- [1217] Executado em: 06/03/2026 16:58:15
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1218] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1219] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1220] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1221] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [1222] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1223] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1224] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1225] Executado em: 06/03/2026 16:58:15
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10998' and v.EMPRESA = 1
;

-- [1226] Executado em: 06/03/2026 16:58:15
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10998' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1227] Executado em: 06/03/2026 16:58:15
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008301
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1228] Executado em: 06/03/2026 16:58:15
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1229] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1230] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1231] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1232] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1233] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1234] Executado em: 06/03/2026 16:58:15
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1235] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1236] Executado em: 06/03/2026 16:58:15
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1237] Executado em: 06/03/2026 16:58:16
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1238] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1239] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1240] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1241] Executado em: 06/03/2026 16:58:16
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1242] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1243] Executado em: 06/03/2026 16:58:16
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB192009
--   :2 (WideString,IN) = 5X76DT
;

-- [1244] Executado em: 06/03/2026 16:58:16
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB192009'
;

-- [1245] Executado em: 06/03/2026 16:58:16
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1246] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1247] Executado em: 06/03/2026 16:58:16
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1248] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1249] Executado em: 06/03/2026 16:58:16
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10998' and v.EMPRESA = 1
;

-- [1250] Executado em: 06/03/2026 16:58:16
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10998' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1251] Executado em: 06/03/2026 16:58:16
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 3008301
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1252] Executado em: 06/03/2026 16:58:16
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1253] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1254] Executado em: 06/03/2026 16:58:16
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1255] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1256] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1257] Executado em: 06/03/2026 16:58:16
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1258] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1259] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1260] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1261] Executado em: 06/03/2026 16:58:16
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1262] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1263] Executado em: 06/03/2026 16:58:16
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10998
;

-- [1264] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1265] Executado em: 06/03/2026 16:58:16
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10998
;

-- [1266] Executado em: 06/03/2026 16:58:16
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEX76D0TB192009
--   :2 (WideString,IN) = 5X76DT
;

-- [1267] Executado em: 06/03/2026 16:58:16
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEX76D0TB192009'
;

-- [1268] Executado em: 06/03/2026 16:58:16
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5X76DT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1269] Executado em: 06/03/2026 16:58:16
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10953
;

-- [1270] Executado em: 06/03/2026 16:58:16
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10953' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [1271] Executado em: 06/03/2026 16:58:16
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10953' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [1272] Executado em: 06/03/2026 16:58:16
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1266660 order by DTA_PAGTO desc
;

-- [1273] Executado em: 06/03/2026 16:58:16
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [1274] Executado em: 06/03/2026 16:58:16
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '3GCUK9ED6TG148357'
;

-- [1275] Executado em: 06/03/2026 16:58:16
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '3GCUK9ED6TG148357'
;

-- [1276] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1277] Executado em: 06/03/2026 16:58:16
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10953' and v.EMPRESA = 1
;

-- [1278] Executado em: 06/03/2026 16:58:16
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10953' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1279] Executado em: 06/03/2026 16:58:16
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4697701
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1280] Executado em: 06/03/2026 16:58:16
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1281] Executado em: 06/03/2026 16:58:16
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10953' and v.EMPRESA = 1
;

-- [1282] Executado em: 06/03/2026 16:58:16
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10953' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1283] Executado em: 06/03/2026 16:58:17
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4697701
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1284] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1285] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1286] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1287] Executado em: 06/03/2026 16:58:17
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10953' and v.EMPRESA = 1
;

-- [1288] Executado em: 06/03/2026 16:58:17
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10953' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1289] Executado em: 06/03/2026 16:58:17
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4697701
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1290] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1291] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1292] Executado em: 06/03/2026 16:58:17
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10953' and v.EMPRESA = 1
;

-- [1293] Executado em: 06/03/2026 16:58:17
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10953' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1294] Executado em: 06/03/2026 16:58:17
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4697701
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1295] Executado em: 06/03/2026 16:58:17
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1296] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1297] Executado em: 06/03/2026 16:58:17
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [1298] Executado em: 06/03/2026 16:58:17
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10953'
;

-- [1299] Executado em: 06/03/2026 16:58:17
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [1300] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1301] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [1302] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1303] Executado em: 06/03/2026 16:58:17
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1304] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1305] Executado em: 06/03/2026 16:58:17
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 3GCUK9ED6TG148357
--   :2 (WideString,IN) = 3PJEDT
;

-- [1306] Executado em: 06/03/2026 16:58:17
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '3GCUK9ED6TG148357'
;

-- [1307] Executado em: 06/03/2026 16:58:17
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3PJEDT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1308] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1309] Executado em: 06/03/2026 16:58:17
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1310] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1311] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [1312] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1313] Executado em: 06/03/2026 16:58:17
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1314] Executado em: 06/03/2026 16:58:17
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1315] Executado em: 06/03/2026 16:58:17
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10953' and v.EMPRESA = 1
;

-- [1316] Executado em: 06/03/2026 16:58:17
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10953' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1317] Executado em: 06/03/2026 16:58:17
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4697701
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1318] Executado em: 06/03/2026 16:58:17
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1319] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1320] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1321] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1322] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1323] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1324] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1325] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1326] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1327] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1328] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1329] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1330] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1331] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1332] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1333] Executado em: 06/03/2026 16:58:18
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 3GCUK9ED6TG148357
--   :2 (WideString,IN) = 3PJEDT
;

-- [1334] Executado em: 06/03/2026 16:58:18
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '3GCUK9ED6TG148357'
;

-- [1335] Executado em: 06/03/2026 16:58:18
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3PJEDT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1336] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1337] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1338] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1339] Executado em: 06/03/2026 16:58:18
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10953' and v.EMPRESA = 1
;

-- [1340] Executado em: 06/03/2026 16:58:18
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10953' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1341] Executado em: 06/03/2026 16:58:18
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 4697701
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1342] Executado em: 06/03/2026 16:58:18
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1343] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1344] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1345] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1346] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1347] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1348] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1349] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1350] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1351] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1352] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1353] Executado em: 06/03/2026 16:58:18
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10953
;

-- [1354] Executado em: 06/03/2026 16:58:18
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1355] Executado em: 06/03/2026 16:58:18
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10953
;

-- [1356] Executado em: 06/03/2026 16:58:18
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1357] Executado em: 06/03/2026 16:58:18
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 3GCUK9ED6TG148357
--   :2 (WideString,IN) = 3PJEDT
;

-- [1358] Executado em: 06/03/2026 16:58:18
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '3GCUK9ED6TG148357'
;

-- [1359] Executado em: 06/03/2026 16:58:18
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 3PJEDT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1360] Executado em: 06/03/2026 16:58:18
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10925
;

-- [1361] Executado em: 06/03/2026 16:58:18
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10925' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [1362] Executado em: 06/03/2026 16:58:18
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10925' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [1363] Executado em: 06/03/2026 16:58:19
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1259666 order by DTA_PAGTO desc
;

-- [1364] Executado em: 06/03/2026 16:58:19
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [1365] Executado em: 06/03/2026 16:58:19
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BG148MK0TC427009'
;

-- [1366] Executado em: 06/03/2026 16:58:19
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BG148MK0TC427009'
;

-- [1367] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1368] Executado em: 06/03/2026 16:58:19
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10925' and v.EMPRESA = 1
;

-- [1369] Executado em: 06/03/2026 16:58:19
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10925' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1370] Executado em: 06/03/2026 16:58:19
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 154114
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1371] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1372] Executado em: 06/03/2026 16:58:19
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10925' and v.EMPRESA = 1
;

-- [1373] Executado em: 06/03/2026 16:58:19
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10925' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1374] Executado em: 06/03/2026 16:58:19
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 154114
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1375] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1376] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1377] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1378] Executado em: 06/03/2026 16:58:19
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10925' and v.EMPRESA = 1
;

-- [1379] Executado em: 06/03/2026 16:58:19
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10925' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1380] Executado em: 06/03/2026 16:58:19
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 154114
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1381] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1382] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1383] Executado em: 06/03/2026 16:58:19
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10925' and v.EMPRESA = 1
;

-- [1384] Executado em: 06/03/2026 16:58:19
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10925' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1385] Executado em: 06/03/2026 16:58:19
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 154114
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1386] Executado em: 06/03/2026 16:58:19
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1387] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1388] Executado em: 06/03/2026 16:58:19
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [1389] Executado em: 06/03/2026 16:58:19
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10925'
;

-- [1390] Executado em: 06/03/2026 16:58:19
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [1391] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1392] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [1393] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1394] Executado em: 06/03/2026 16:58:19
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1395] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1396] Executado em: 06/03/2026 16:58:19
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BG148MK0TC427009
--   :2 (WideString,IN) = 148MKT
;

-- [1397] Executado em: 06/03/2026 16:58:19
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BG148MK0TC427009'
;

-- [1398] Executado em: 06/03/2026 16:58:19
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 148MKT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1399] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1400] Executado em: 06/03/2026 16:58:19
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1401] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1402] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [1403] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1404] Executado em: 06/03/2026 16:58:19
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1405] Executado em: 06/03/2026 16:58:19
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1406] Executado em: 06/03/2026 16:58:19
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10925' and v.EMPRESA = 1
;

-- [1407] Executado em: 06/03/2026 16:58:19
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10925' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1408] Executado em: 06/03/2026 16:58:19
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 154114
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1409] Executado em: 06/03/2026 16:58:20
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1410] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1411] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1412] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1413] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1414] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1415] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1416] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1417] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1418] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1419] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1420] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1421] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1422] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1423] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1424] Executado em: 06/03/2026 16:58:20
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BG148MK0TC427009
--   :2 (WideString,IN) = 148MKT
;

-- [1425] Executado em: 06/03/2026 16:58:20
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BG148MK0TC427009'
;

-- [1426] Executado em: 06/03/2026 16:58:20
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 148MKT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1427] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1428] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1429] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1430] Executado em: 06/03/2026 16:58:20
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10925' and v.EMPRESA = 1
;

-- [1431] Executado em: 06/03/2026 16:58:20
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10925' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1432] Executado em: 06/03/2026 16:58:20
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 154114
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1433] Executado em: 06/03/2026 16:58:20
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1434] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1435] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1436] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1437] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1438] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1439] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1440] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1441] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1442] Executado em: 06/03/2026 16:58:20
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1443] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1444] Executado em: 06/03/2026 16:58:20
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10925
;

-- [1445] Executado em: 06/03/2026 16:58:20
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1446] Executado em: 06/03/2026 16:58:20
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10925
;

-- [1447] Executado em: 06/03/2026 16:58:20
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BG148MK0TC427009
--   :2 (WideString,IN) = 148MKT
;

-- [1448] Executado em: 06/03/2026 16:58:20
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BG148MK0TC427009'
;

-- [1449] Executado em: 06/03/2026 16:58:20
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 148MKT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1450] Executado em: 06/03/2026 16:58:20
select v.*,
 v.FORMULA FORMULA_CUSTEIO,
 case f.tipo_pintura
 when 'S' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_s, m.val_pintura_s, 0)
 when 'M' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_m, m.val_pintura_m, 0)
 when 'P' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_p, m.val_pintura_p, 0)
 when 'E' then
 coalesce(p.preco_publico, m.preco_publico, 0) + coalesce(p.val_pintura_e, m.val_pintura_e, 0)
 else
 coalesce(p.preco_publico, m.preco_publico, 0)
 end PRECO_PUBLICO,
 m.*,
 f.ANO_FABRICACAO,
 f.ANO_MODELO,
 f.PACOTE,
 f.PORTAS,
 f.TIPO_PINTURA,
 f.EDICAO EDICAO_MODELO
 from CNP.VEI_VEICULO v
 inner join CNP.VEI_MODELO m
 on (v.EMPRESA = m.EMPRESA and 
 v.MODELO = m.MODELO)
 inner join CNP.OFI_FICHA_SEGUIMENTO f
 on (v.CHASSI = f.CHASSI)
 left outer join CNP.VEI_MODELO_PRECO p
 on (v.EMPRESA = P.EMPRESA and 
 v.MODELO = P.MODELO and
 v.REVENDA_ORIGEM = P.REVENDA)
 where v.EMPRESA = :1 
 and v.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10977
;

-- [1451] Executado em: 06/03/2026 16:58:20
select TT.TIPO, CI.CLIENTE CLIENTE_REVENDA, CL.CLIENTE, CI.FANTASIA NOME_FANTASIA, CL.FANTASIA NOME from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT, CNP.FAT_CLIENTE CL, CNP.GER_REVENDA GR, CNP.FAT_CLIENTE CI where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MC.CLIENTE = CL.CLIENTE and MV.EMPRESA = GR.EMPRESA and MV.REVENDA = GR.REVENDA and GR.CLIENTE = CI.CLIENTE and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10977' and MC.STATUS <> 'C' order by MC.FATOPERACAO desc
;

-- [1452] Executado em: 06/03/2026 16:58:21
select MC.OPERACAO, MC.EMPRESA, MC.REVENDA from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC, CNP.FAT_TIPO_TRANSACAO TT where MV.EMPRESA = MC.EMPRESA and MV.REVENDA = MC.REVENDA and MV.NUMERO_NOTA_FISCAL = MC.NUMERO_NOTA_FISCAL and MV.SERIE_NOTA_FISCAL = MC.SERIE_NOTA_FISCAL and MV.TIPO_TRANSACAO = MC.TIPO_TRANSACAO and MV.CONTADOR = MC.CONTADOR and MC.TIPO_TRANSACAO = TT.TIPO_TRANSACAO and MV.EMPRESA = 1 and MV.REVENDA = 1 and MV.VEICULO = 'AN10977' and MC.STATUS <> 'C' and TT.TIPO = 'E' and TT.SUBTIPO_TRANSACAO = 'N' order by MC.OPERACAO desc
;

-- [1453] Executado em: 06/03/2026 16:58:21
select STATUS, DTA_ULTIMA_ALTERACAO, (select max(dta_pagamento) from CNP.fin_titulo_pagamento where fin_titulo.empresa = empresa and fin_titulo.revenda = revenda and fin_titulo.titulo = titulo and fin_titulo.duplicata = duplicata and TIPO_TRANSACAO = 'BN' and LCTO_ESTORNO IS NULL and fin_titulo.cliente = cliente and fin_titulo.tipo = tipo) DTA_PAGTO from CNP.fin_titulo where empresa = 1 and revenda = 1 and status = 'PT' and tipo = 'CP' and operacao = 1269538 order by DTA_PAGTO desc
;

-- [1454] Executado em: 06/03/2026 16:58:21
select
UTILIZA_NISSAN_DI
from
CNP.NIS_PARAMETRO
where
EMPRESA = 1
and REVENDA = 1
;

-- [1455] Executado em: 06/03/2026 16:58:21
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEN43T0TB177139'
;

-- [1456] Executado em: 06/03/2026 16:58:21
select sum(coalesce(o.val_opcional, e.val_opcional, m.val_opcional)) VAL_OPC from CNP.ofi_ficha_opcional o inner join CNP.ofi_ficha_seguimento f on (f.chassi = o.chassi) inner join CNP.vei_opcional_modelo m on (m.empresa = o.empresa and m.modelo = o.modelo and m.opcional = o.opcional) left outer join CNP.vei_opcional_modelo_edicao e on (e.empresa = m.empresa and e.modelo = m.modelo and e.opcional = m.opcional and e.ano_modelo = f.ano_modelo and e.edicao = f.edicao) where o.EMPRESA = f.EMPRESA and o.CHASSI = '9BGEN43T0TB177139'
;

-- [1457] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1458] Executado em: 06/03/2026 16:58:21
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10977' and v.EMPRESA = 1
;

-- [1459] Executado em: 06/03/2026 16:58:21
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10977' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1460] Executado em: 06/03/2026 16:58:21
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2993558
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1461] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1462] Executado em: 06/03/2026 16:58:21
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10977' and v.EMPRESA = 1
;

-- [1463] Executado em: 06/03/2026 16:58:21
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10977' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1464] Executado em: 06/03/2026 16:58:21
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2993558
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1465] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1466] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1467] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1468] Executado em: 06/03/2026 16:58:21
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10977' and v.EMPRESA = 1
;

-- [1469] Executado em: 06/03/2026 16:58:21
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10977' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1470] Executado em: 06/03/2026 16:58:21
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2993558
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1471] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1472] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1473] Executado em: 06/03/2026 16:58:21
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10977' and v.EMPRESA = 1
;

-- [1474] Executado em: 06/03/2026 16:58:21
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10977' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1475] Executado em: 06/03/2026 16:58:21
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2993558
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1476] Executado em: 06/03/2026 16:58:21
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1477] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 1
;

-- [1478] Executado em: 06/03/2026 16:58:21
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
;

-- [1479] Executado em: 06/03/2026 16:58:21
select DTA_FIM_CORRECAO from CNP.VEI_VEICULO where EMPRESA = 1 and VEICULO = 'AN10977'
;

-- [1480] Executado em: 06/03/2026 16:58:21
select * from CNP.FIN_VALOR_INDICE where EMPRESA = :1 and INDICE = :2 and DTA_INDICE = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (TimeStamp,IN)
;

-- [1481] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1482] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = C
;

-- [1483] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 3
;

-- [1484] Executado em: 06/03/2026 16:58:21
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1485] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1486] Executado em: 06/03/2026 16:58:21
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEN43T0TB177139
--   :2 (WideString,IN) = 5N43TT
;

-- [1487] Executado em: 06/03/2026 16:58:21
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEN43T0TB177139'
;

-- [1488] Executado em: 06/03/2026 16:58:21
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5N43TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1489] Executado em: 06/03/2026 16:58:21
select * from CNP.vei_bonus_opcional where EMPRESA = :1 and BONUS = :2 and MODELO = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
--   :3 (WideString,IN) = 5N43TT
;

-- [1490] Executado em: 06/03/2026 16:58:21
select * from CNP.VEI_BONUS_OPCIONAL_SEM where EMPRESA = :1 and BONUS = :2 and MODELO = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
--   :3 (WideString,IN) = 5N43TT
;

-- [1491] Executado em: 06/03/2026 16:58:21
select * from CNP.vei_bonus_pacote where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1492] Executado em: 06/03/2026 16:58:21
select * from CNP.vei_bonus_edicao where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1493] Executado em: 06/03/2026 16:58:22
select REVENDA_ORIGEM from CNP.vei_veiculo where EMPRESA = :1 and VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10977
;

-- [1494] Executado em: 06/03/2026 16:58:22
select * from CNP.vei_bonus_revenda where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1495] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 4
;

-- [1496] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1497] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1498] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 3
;

-- [1499] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 5
;

-- [1500] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1501] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1502] Executado em: 06/03/2026 16:58:22
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10977' and v.EMPRESA = 1
;

-- [1503] Executado em: 06/03/2026 16:58:22
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10977' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1504] Executado em: 06/03/2026 16:58:22
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2993558
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1505] Executado em: 06/03/2026 16:58:22
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1506] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 6
;

-- [1507] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1508] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1509] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = D
;

-- [1510] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 7
;

-- [1511] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1512] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1513] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 10
;

-- [1514] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1515] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1516] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1517] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 11
;

-- [1518] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1519] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1520] Executado em: 06/03/2026 16:58:22
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEN43T0TB177139
--   :2 (WideString,IN) = 5N43TT
;

-- [1521] Executado em: 06/03/2026 16:58:22
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEN43T0TB177139'
;

-- [1522] Executado em: 06/03/2026 16:58:22
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5N43TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1523] Executado em: 06/03/2026 16:58:22
select * from CNP.vei_bonus_opcional where EMPRESA = :1 and BONUS = :2 and MODELO = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
--   :3 (WideString,IN) = 5N43TT
;

-- [1524] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_BONUS_OPCIONAL_SEM where EMPRESA = :1 and BONUS = :2 and MODELO = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
--   :3 (WideString,IN) = 5N43TT
;

-- [1525] Executado em: 06/03/2026 16:58:22
select * from CNP.vei_bonus_pacote where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1526] Executado em: 06/03/2026 16:58:22
select * from CNP.vei_bonus_edicao where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1527] Executado em: 06/03/2026 16:58:22
select REVENDA_ORIGEM from CNP.vei_veiculo where EMPRESA = :1 and VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10977
;

-- [1528] Executado em: 06/03/2026 16:58:22
select * from CNP.vei_bonus_revenda where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1529] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 12
;

-- [1530] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1531] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1532] Executado em: 06/03/2026 16:58:22
select v.REVENDA_NFENTRADA, f.DTA_ENTRADA_SAIDA DTA_FRETE from CNP.VEI_VEICULO v left outer join CNP.FAT_MOVIMENTO_CAPA f on (f.EMPRESA = v.EMPRESA_NFFRETE and f.REVENDA = v.REVENDA_NFFRETE and f.NUMERO_NOTA_FISCAL = v.NUMERO_NOTA_FISCAL_NFFRETE and f.SERIE_NOTA_FISCAL = v.SERIE_NOTA_FISCAL_NFFRETE and f.TIPO_TRANSACAO = v.TIPO_TRANSACAO_NFFRETE and f.CONTADOR = v.CONTADOR_NFFRETE) where v.VEICULO = 'AN10977' and v.EMPRESA = 1
;

-- [1533] Executado em: 06/03/2026 16:58:22
select MC.VAL_FRETE_PF, MC.TOT_NOTA_FISCAL, MC.VALDESCONTO, MV.VAL_PIS_SUBTRIBUTARIA, MV.VAL_COFINS_SUBTRIBUTARIA, MV.VAL_PIS, MV.VAL_COFINS, MV.VAL_ICMS, MV.VAL_ICMS_RETIDO, MV.VAL_IPI, MV.VAL_MAJORACAO_COFINS, MV.VALOR_ICMSRET_ARECOLHER from CNP.FAT_MOVIMENTO_VEICULO MV, CNP.FAT_MOVIMENTO_CAPA MC where MV.VEICULO = 'AN10977' and MC.EMPRESA = 1 and MC.REVENDA = 1 and MC.MODALIDADE = 'C' and MC.STATUS IN ('F', 'A') and MC.EMPRESA = MV.EMPRESA and MC.REVENDA = MV.REVENDA and MC.NUMERO_NOTA_FISCAL = MV.NUMERO_NOTA_FISCAL and MC.SERIE_NOTA_FISCAL = MV.SERIE_NOTA_FISCAL and MC.TIPO_TRANSACAO = MV.TIPO_TRANSACAO and MC.CONTADOR = MV.CONTADOR
;

-- [1534] Executado em: 06/03/2026 16:58:22
select * from CNP.FAT_MOVIMENTO_CAPA where EMPRESA = :1 and REVENDA = :2 and TIPO_TRANSACAO = :3 and NUMERO_NOTA_FISCAL = :4 and SERIE_NOTA_FISCAL = :5 and CONTADOR = :6
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (WideString,IN) = V01
--   :4 (Number,IN) = 2993558
--   :5 (WideString,IN) = 3
--   :6 (Number,IN) = 0
;

-- [1535] Executado em: 06/03/2026 16:58:22
select INCIDENCIA from CNP.VEI_FORMULA_LINHA where EMPRESA = 1 and FORMULA = 'UF' and (INCIDENCIA = '(' or INCIDENCIA = ')' or INCIDENCIA = '[') and TIPO = 'B' and STATUS <> 'D'
;

-- [1536] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 18
;

-- [1537] Executado em: 06/03/2026 16:58:22
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1538] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1539] Executado em: 06/03/2026 16:58:22
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 19
;

-- [1540] Executado em: 06/03/2026 16:58:23
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1541] Executado em: 06/03/2026 16:58:23
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1542] Executado em: 06/03/2026 16:58:23
select * from CNP.VEI_RETORNO where EMPRESA = :1 and REVENDA = :2 and PROPOSTA = :3 and NEGOCIACAO = :4 and TIPO_RETORNO = :5
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 1
--   :3 (Number,IN) = 0
--   :4 (Number,IN) = 0
--   :5 (WideString,IN) = 1
;

-- [1543] Executado em: 06/03/2026 16:58:23
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 20
;

-- [1544] Executado em: 06/03/2026 16:58:23
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1545] Executado em: 06/03/2026 16:58:23
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1546] Executado em: 06/03/2026 16:58:23
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10977
;

-- [1547] Executado em: 06/03/2026 16:58:23
select * from CNP.VEI_FORMULA_LINHA where EMPRESA = :1 and FORMULA = :2 and LINHA_FORMULA = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = UF
--   :3 (Number,IN) = 21
;

-- [1548] Executado em: 06/03/2026 16:58:23
select d1.*, d2.* from CNP.VEI_DESPESA_VEICULO d1, CNP.VEI_DESPESA d2 where d1.EMPRESA = d2.EMPRESA and d1.DESPESA = d2.DESPESA and d1.EMPRESA = :1 and d1.VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10977
;

-- [1549] Executado em: 06/03/2026 16:58:23
select * from CNP.FIN_INDICE_FINANCEIRO where EMPRESA = :1 and INDICE = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 0
;

-- [1550] Executado em: 06/03/2026 16:58:23
select fo.OPCIONAL
 from CNP.ofi_ficha_seguimento fs,
 ofi_ficha_opcional fo
 where fs.chassi = fo.chassi
 and fo.EMPRESA = fs.Empresa
 and fo.CHASSI = :1 
 and fo.MODELO = :2
-- Parâmetros:
--   :1 (WideString,IN) = 9BGEN43T0TB177139
--   :2 (WideString,IN) = 5N43TT
;

-- [1551] Executado em: 06/03/2026 16:58:23
select DTA_PRODUCAO from CNP.OFI_FICHA_SEGUIMENTO where CHASSI = '9BGEN43T0TB177139'
;

-- [1552] Executado em: 06/03/2026 16:58:23
select * from CNP.vei_bonus where EMPRESA = :1 and MODELO = :2 and ((( :3 between dta_compra_inicio and dta_compra_fim) or (dta_compra_inicio is null)) and (( :4 between dta_venda_inicio and dta_venda_fim) or (dta_venda_inicio is null)) AND (( :5 BETWEEN dta_producao_inicio AND dta_producao_fim) OR (dta_producao_inicio IS NULL))) order by GRUPO_BONUS
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = 5N43TT
--   :3 (TimeStamp,IN)
--   :4 (TimeStamp,IN)
--   :5 (TimeStamp,IN)
;

-- [1553] Executado em: 06/03/2026 16:58:23
select * from CNP.vei_bonus_opcional where EMPRESA = :1 and BONUS = :2 and MODELO = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
--   :3 (WideString,IN) = 5N43TT
;

-- [1554] Executado em: 06/03/2026 16:58:23
select * from CNP.VEI_BONUS_OPCIONAL_SEM where EMPRESA = :1 and BONUS = :2 and MODELO = :3
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
--   :3 (WideString,IN) = 5N43TT
;

-- [1555] Executado em: 06/03/2026 16:58:23
select * from CNP.vei_bonus_pacote where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1556] Executado em: 06/03/2026 16:58:23
select * from CNP.vei_bonus_edicao where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1557] Executado em: 06/03/2026 16:58:23
select REVENDA_ORIGEM from CNP.vei_veiculo where EMPRESA = :1 and VEICULO = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (WideString,IN) = AN10977
;

-- [1558] Executado em: 06/03/2026 16:58:23
select * from CNP.vei_bonus_revenda where EMPRESA = :1 and BONUS = :2
-- Parâmetros:
--   :1 (Number,IN) = 1
--   :2 (Number,IN) = 80678
;

-- [1559] Executado em: 06/03/2026 16:58:23
select count(SITUACAO) SITUACAO from CNP.GER_MENSAGEM where USUARIO_DESTINO = 644 and SITUACAO = 'N'
;

-- [1560] Executado em: 06/03/2026 16:58:23
select APROVADO from CNP.GER_APROVACAO where USUARIO_APROV = 644 and APROVADO is null
;