	-- =====================================================================
	-- VIEW: V_PBI_FATURAMENTO_VEICULOS
	-- DESCRIÇÃO: Consolida dados de faturamento de veículos, contatos,
	--            vendedores, usuários e revendas para uso no Power BI
	-- =====================================================================

	CREATE OR REPLACE VIEW V_PBI_FATURAMENTO_VEICULOS
	AS

	-- SEÇÃO: CAMPOS DE CHAVE (CHAVES DE RELACIONAMENTO / MODELO BI)
	SELECT
			(TO_CHAR(FMV.EMPRESA) || ' - ' || TO_CHAR(FMV.VEICULO))                                  AS CHAVE_VEICULO        ,
			(TO_CHAR(FMC.EMPRESA) || ' - ' || TO_CHAR(FMC.REVENDA))                                  AS CHAVE_EMP_REV        ,
			(TO_CHAR(FMC.EMPRESA) || ' - ' || TO_CHAR(FMC.REVENDA) || ' - ' || TO_CHAR(FMC.CONTATO)) AS CHAVE_EMP_REV_CONTATO,

	-- SEÇÃO: DADOS DA EMPRESA / REVENDA
			FMC.EMPRESA                                                                                                      ,
			FMC.REVENDA                                                                                                      ,
			T2.NOME_EMPRESA                                                                                                  ,

	-- SEÇÃO: DATAS
			CAST(FMC.DTA_ENTRADA_SAIDA AS DATE)                                                      AS DTA_ENTRADA_SAIDA    ,
			CAST(FMC.DTA_DOCUMENTO AS DATE)                                                          AS DTA_DOCUMENTO        ,

			-- DATA DO CONTATO VINDO DA CAC_CONTATO
			CAST(CC.DTA_CONTATO AS DATE)                                                             AS DTA_CONTATO          ,

	-- SEÇÃO: DADOS OPERACIONAIS / TRANSAÇÃO
			FMC.MODALIDADE                                                                                                   ,
			FMC.TIPO_TRANSACAO                                                                                               ,
			FMC.FATOPERACAO                                                                                                  ,
			FMC.OPERACAO                                                                                                     ,
			FMC.CAIXA                                                                                                        ,

	-- SEÇÃO: CLIENTE / DEPARTAMENTO / USUÁRIO
			FMC.CLIENTE                                                                                                      ,
			FMC.CLIENTE_FATURAMENTO                                                                                          ,
			FMC.DEPARTAMENTO                                                                         AS DEPARTAMENTO_FAT     ,
			FMC.USUARIO                                                                                                      ,

	-- SEÇÃO: CHAVES DE VENDEDOR / USUÁRIO BI
			VEND.CHAVE_EMP_REV_VENDEDOR                                                                                      ,
			VEND.CHAVE_EMP_REV_USUARIO                                                                                       ,

    -- SEÇÃO: CONTATO / TOTAIS DE MERCADORIA
			FMC.CONTATO                                                                                                      ,
			FMC.TOT_MERCADORIA                                                                                               ,
			FMC.TOT_CUSTO_MEDIO                                                                                              ,
			FMC.TOT_QUANTIDADES                                                                                              ,

	-- SEÇÃO: DADOS DO VEÍCULO FATURADO / VALORES FINANCEIROS
			FMV.VEICULO                                                                              AS VEICULO_FATURAMENTO  ,
			FMV.VAL_TOTAL                                                                                                    ,
			FMV.VAL_CUSTO                                                                                                    ,
			FMV.VAL_OPCIONAIS                                                                                                ,
			FMV.VAL_DESCONTO                                                                                                 ,
			FMV.VAL_FRETE                                                                                                    ,
			FMV.VAL_DEVERIA

	-- SEÇÃO: TABELA BASE
	FROM
			CNP.FAT_MOVIMENTO_CAPA FMC

	-- =====================================================================
	-- SEÇÃO: JOIN - FAT_MOVIMENTO_VEICULO
	INNER JOIN
			CNP.FAT_MOVIMENTO_VEICULO FMV
	ON
			FMV.EMPRESA             = FMC.EMPRESA
	AND     FMV.REVENDA             = FMC.REVENDA
	AND     FMV.NUMERO_NOTA_FISCAL = FMC.NUMERO_NOTA_FISCAL
	AND     FMV.SERIE_NOTA_FISCAL  = FMC.SERIE_NOTA_FISCAL
	AND     FMV.TIPO_TRANSACAO     = FMC.TIPO_TRANSACAO
	AND     FMV.CONTADOR           = FMC.CONTADOR

	-- SEÇÃO: JOIN - VEÍCULOS
	INNER JOIN
			CNP.VEI_VEICULO VEI
	ON
			VEI.EMPRESA = FMV.EMPRESA
	AND     VEI.VEICULO = FMV.VEICULO

	-- SEÇÃO: JOIN - USUÁRIOS
	INNER JOIN
			CNP.GER_USUARIO USU
	ON
			USU.USUARIO = FMC.USUARIO

	-- SEÇÃO: JOIN - TIPO DE TRANSAÇÃO
	INNER JOIN
			CNP.FAT_TIPO_TRANSACAO FTT
	ON
			FTT.TIPO_TRANSACAO = FMC.TIPO_TRANSACAO

	-- SEÇÃO: JOIN - REVENDAS (POWER BI)
	INNER JOIN
			V_PBI_REVENDAS T2
	ON
			FMC.EMPRESA = T2.EMPRESA
	AND     FMC.REVENDA = T2.REVENDA

	-- SEÇÃO: JOIN - VENDEDORES (POWER BI)
	INNER JOIN (
		SELECT
			USUARIO,
			MAX(CHAVE_EMP_REV_VENDEDOR) AS CHAVE_EMP_REV_VENDEDOR,
			MAX(CHAVE_EMP_REV_USUARIO)  AS CHAVE_EMP_REV_USUARIO
		FROM V_PBI_VENDEDORES
		GROUP BY USUARIO
	) VEND
	ON VEND.USUARIO = USU.USUARIO

	-- SEÇÃO: LEFT JOIN - CONTATO (DATA DO CONTATO - CAC_CONTATO)
	LEFT JOIN
			CNP.CAC_CONTATO CC
	ON
			CC.EMPRESA = FMC.EMPRESA
	AND     CC.REVENDA = FMC.REVENDA
	AND     CC.CONTATO = FMC.CONTATO

	-- SEÇÃO: FILTROS
	WHERE
			FMC.TIPO_TRANSACAO IN ('V21','U21')
			-- U21 - VENDA DE VEÍCULOS/MOTOS USADOS
			-- V21 - VENDA DE VEÍCULOS/MOTOS NOVOS

			-- FILTRO DINÂMICO DOS ÚLTIMOS 5 ANOS
	AND     FMC.DTA_ENTRADA_SAIDA >= ADD_MONTHS(TRUNC(SYSDATE), -60)

			-- SOMENTE FATURADOS
	AND     FMC.STATUS = 'F';
