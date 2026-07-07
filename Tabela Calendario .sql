let
// Criando Range de Data Entre 01/01/2023 e Hoje
Fonte = #date(2023, 1, 1),

ListaDatas = List.Dates(
    Fonte,
    Number.From(Date.From(DateTime.LocalNow())) - Number.From(Fonte) + 1,
    #duration(1,0,0,0)
),

#"ConverteTabela"= Table.FromList(ListaDatas, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

// Renomeando e formatando a coluna para Data
#"Renomeia Coluna para Data" = Table.RenameColumns(#"ConverteTabela",{{"Column1", "Data"}}),
#"Formata Coluna como Data" = Table.TransformColumnTypes(#"Renomeia Coluna para Data",{{"Data", type date}}),

// Dia
DiaNum = Table.AddColumn(#"Formata Coluna como Data", "DiaNum", each Date.Day([Data]), Int64.Type),
DiaComZero = Table.AddColumn(DiaNum, "DiaComZero", each Text.PadStart(Text.From(Date.Day([Data])),2,"0"), type text),
DiaNome = Table.AddColumn(DiaComZero, "DiaNome", each "Dia" & [DiaComZero] , type text),
DiaAno = Table.AddColumn(DiaNome, "DiaAno", each Date.DayOfYear([Data]), type text),

// Mês
MesNum = Table.AddColumn(DiaAno, "MesNum", each Date.Month([Data]), Int64.Type),
MesComZero = Table.AddColumn(MesNum, "MesComZero", each Text.PadStart(Text.From(Date.Month([Data])),2,"0"), type text),

MesNome = Table.AddColumn(MesComZero, "MesNome", each Text.Proper(Date.MonthName([Data], "pt-BR")), type text),

MesNomeAbrev = Table.AddColumn(MesNome, "MesNomeAbrev", each Date.ToText([Data],"MMM"), type text),
MesNomeAbrevAno = Table.AddColumn(MesNomeAbrev, "MesNomeAbrevAno", each Date.ToText([Data],"MMM-yyyy"), type text),
MesExtenso = Table.AddColumn(MesNomeAbrevAno, "Mes Extenso", each "Mês" & [MesComZero]),

// Ano
Ano = Table.AddColumn(MesExtenso, "Ano", each Date.Year([Data]), type text),
#"Ano/Mes" = Table.AddColumn(Ano, "Competência", each Date.ToText([Data],"yyyyMM"), type text),

// Semana
DiaSemana = Table.AddColumn(#"Ano/Mes", "DiaSemana",each Date.DayOfWeek([Data], Day.Sunday) + 1, type number),
DiaSemanaAbrev = Table.AddColumn(DiaSemana, "DiaSemanaAbrev", each Date.ToText([Data],"ddd"), type text),
DiaSemanaNome = Table.AddColumn(DiaSemanaAbrev, "DiaSemanaNome", each Date.ToText([Data],"dddd"), type text),
SemanaAno = Table.AddColumn(DiaSemanaNome, "SemanaAno", each Text.PadStart(Text.From(Date.WeekOfYear([Data])),2,"0"), type text),
#"Semana, Ano" = Table.AddColumn(SemanaAno, "Semana, Ano", each "Semana " & [SemanaAno] & ", " & Text.From([Ano]), type text),
SemanaExtenso = Table.AddColumn(#"Semana, Ano", "SemanaExtenso", each "Semana " & [SemanaAno], type text),
SemanaMes = Table.AddColumn(SemanaExtenso, "SemanaMes", each Date.WeekOfMonth([Data]), type text),

// Bimestre
Bimestre = Table.AddColumn(SemanaMes, "Bimestre",
each if [MesNum] <= 2 then 1
else if [MesNum] <= 4 then 2
else if [MesNum] <= 6 then 3
else if [MesNum] <= 8 then 4
else if [MesNum] <= 10 then 5
else 6 , type text),

// Semestre
Semestre = Table.AddColumn(Bimestre, "Semestre",
each if [MesNum] <= 6 then 1 else 2, type text),

// Trimestre
TrimestreNum = Table.AddColumn(Semestre, "TrimestreNum", each Date.QuarterOfYear([Data]), type text),
TrimestreNom = Table.AddColumn(TrimestreNum, "TrimestreNom", each Number.ToText([TrimestreNum]) & "º – Trimestre", type text),

// Data Inicio e Fim mês
InicioMes = Table.AddColumn(TrimestreNom, "InicioMes", each Date.StartOfMonth([Data]), type text),
FimMes = Table.AddColumn(InicioMes, "FimMes", each Date.EndOfMonth([Data]), type text),

//Calendário Ano
#"Calendario Ano" = Table.AddColumn(FimMes, "Calendario Ano", each "Calendário " & Text.From([Ano]), type text),

//Flags
FlagFinalSemana = Table.AddColumn(#"Calendario Ano", "FinalSemana", each if([DiaSemana] = 0 or [DiaSemana] = 6) then "Sim" else "Não", type text),
FlagHoje = Table.AddColumn(FlagFinalSemana, "FlagHoje", each Date.IsInCurrentDay([Data]), type logical),
FlagMesAtual = Table.AddColumn(FlagHoje, "FlagMesAtual", each Date.IsInCurrentMonth([Data]), type logical),
FlagTrimestreAtual = Table.AddColumn(FlagMesAtual, "FlagTrimestreAtual", each Date.IsInCurrentQuarter([Data]), type logical),
FlagSemanaAtual = Table.AddColumn(FlagTrimestreAtual, "FlagSemanaAtual", each Date.IsInCurrentWeek([Data]), type logical),
FlagAnoAtual = Table.AddColumn(FlagSemanaAtual, "FlagAnoAtual", each Date.IsInCurrentYear([Data]), type logical),
FlagYTD = Table.AddColumn(FlagAnoAtual, "YTD", each if [FlagAnoAtual] = true and [Data] <= Date.From(DateTime.LocalNow()) then true else false, type logical),

#"Tipo Alterado" = Table.TransformColumnTypes(FlagYTD,{{"Data", type date}, {"DiaNum", Int64.Type}, {"DiaAno", Int64.Type}, {"MesNum", Int64.Type}, {"Ano", Int64.Type}, {"Competência", Int64.Type}, {"DiaSemana", Int64.Type}, {"SemanaAno", Int64.Type}, {"SemanaMes", Int64.Type}, {"Bimestre", Int64.Type}, {"Semestre", Int64.Type}, {"TrimestreNum", Int64.Type}, {"InicioMes", type date}, {"FimMes", type date}}),

#"Texto Substituído inserido" = Table.AddColumn(#"Tipo Alterado", "MesAnoAbrev", each Text.Replace([MesNomeAbrevAno], "-20", "/"), type text),
#"Remove Brancos" = Table.SelectRows(#"Texto Substituído inserido", each ([Data] <> null)),
    #"Texto em Maiúscula" = Table.TransformColumns(#"Remove Brancos",{{"MesNome", Text.Upper, type text}}),
    #"Colocar Cada Palavra Em Maiúscula" = Table.TransformColumns(#"Texto em Maiúscula",{{"DiaSemanaNome", Text.Proper, type text}, {"MesAnoAbrev", Text.Proper, type text}, {"DiaSemanaAbrev", Text.Proper, type text}, {"MesNomeAbrevAno", Text.Proper, type text}, {"MesNomeAbrev", Text.Proper, type text}})
in
    #"Colocar Cada Palavra Em Maiúscula"