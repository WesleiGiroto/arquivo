
Atendimento OPV = fContatos[forma_contato] = 7, "FLUXO OPV'S"

Atendimento Loja = fContatos[forma_contato] = 3, "FLUXO DE LOJA"

Atendimento Telefone = fContatos[forma_contato] = 1, "FLUXO TELEFONE"

--------------------------------


Qtd Fluxo OPV = 
CALCULATE(
    COUNTROWS(fContatos),
    fContatos[FORMA_CONTATO] = 7
)

Qtd Fluxo Loja = 
CALCULATE(
    COUNTROWS(fContatos),
    fContatos[FORMA_CONTATO] = 3
)


Qtd Fluxo Telefone = 
CALCULATE(
    COUNTROWS(fContatos),
    fContatos[FORMA_CONTATO] = 1
)

Fluxo Loja = CALCULATE([Qtd Contato], fContatos[FORMA_CONTATO] = 3)

 -------------------------------------------------
 
Qtd Atendida Novos = 
CALCULATE(
	[Qtd Fluxo Loja], 
		fContatos[DEPARTAMENTO_CONT]="NOVOS")
		
Qtd Atendida Novos_2 = 
CALCULATE(
	[Qtd Fluxo Loja], 
		fVendedor[DEPARTAMENTO]="VEICULO NOVO")
		
td Atendida Usados = 
CALCULATE(
	[Qtd Fluxo Loja], 
		fContatos[DEPARTAMENTO_CONT]="USADOS")
			
Qtd Atendida Usados_2 = 
CALCULATE(
	[Qtd Fluxo Loja],
	fVendedor[DEPARTAMENTO]="VEICULO USADO")
	
Qtd Atendida OPV = 
COALESCE(
	CALCULATE(
    [Qtd Fluxo OPV],         
        fContatos[FORMA_CONTATO] = 7 
    ),0
)
	
Qtd Atendida Fone = 
CALCULATE(
    [Qtd Fluxo OPV], 
    FILTER(
        fContatos,                  
        fContatos[FORMA_CONTATO] = 1 
    )
)

---------------------------------------

Qtd Vendida = sum(fFaturamentoVeiculos[TOT_QUANTIDADES_TRATADO])

---------------------------------------------------------------

Qtd fContato = COUNTROWS(fContatos)

Qtd Atendida_3 = COUNTROWS(fContatos[CONTATO])

Qtd Atendida_2 = DISTINCTCOUNT(fContatos[CONTATO])


-----------------------------------------------------------

% Atingimento Fluxo Loja = 
VAR Realizado = [Fluxo Loja]
VAR Meta = [Meta Fluxo Loja]
RETURN
    DIVIDE(Realizado, Meta, 0)
	
----------------------------------------------------------------------------------


	
 -------------------------  METAS --------------------------------
 
  
Meta Fluxo Loja = CALCULATE(SUM(fMetaFluxo[Meta Fluxo]), fMetaFluxo[Tipo de Fluxo] = "FLUXO DE LOJA")

Meta Fluxo Telefone = CALCULATE(SUM(fMetaFluxo[Meta Fluxo]), fMetaFluxo[Tipo de Fluxo] = "FLUXO TELEMARKETING")

Meta Fluxo OPV = CALCULATE(SUM(fMetaFluxo[Meta Fluxo]), fMetaFluxo[Tipo de Fluxo] = "FLUXO TELEMARKETING")



