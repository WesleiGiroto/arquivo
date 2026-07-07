
PESQUISA POR DATA



-- POR DATA 

SELECT dta_agenda
FROM cnp.cac_agenda_painel
WHERE TRUNC(dta_agenda) = TO_DATE('24/10/2019', 'DD/MM/YYYY');


-- PERIODO

SELECT *
FROM V_PBI_PAINEL_VENDAS
WHERE dta_contato >= TO_DATE('26/11/2025', 'DD/MM/YYYY')
  AND dta_contato <  TO_DATE('27/11/2025', 'DD/MM/YYYY');



-- INTERVALO DE DATAS

SELECT 
    MIN(dta_contato) AS menor_data,
    MAX(dta_contato) AS maior_data
FROM V_PBI_PAINEL_VENDAS;



