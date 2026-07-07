CREATE OR REPLACE VIEW V_PBI_DEMANDA_HISTORICA AS
SELECT
    PDH.EMPRESA,
    PDH.REVENDA,
    PDH.ITEM_ESTOQUE,
    -- Chave para relacionamento com a view principal no Power BI
    TO_CHAR(PDH.EMPRESA) || ' - ' || TO_CHAR(PDH.REVENDA)                                        AS CHAVE_EMP_REV,
    TO_CHAR(PDH.EMPRESA) || ' - ' || TO_CHAR(PDH.REVENDA) || ' - ' || TO_CHAR(PDH.ITEM_ESTOQUE)  AS CHAVE_EMP_REV_ITEM,
    
    PDH.ANO,                                                                               
    PDH.MES,
    
    TO_DATE(PDH.ANO||'-'||LPAD(PDH.MES,2,'0')||'-01','YYYY-MM-DD')                        AS DEMANDA_DATA_REF,
    
    PDH.DEMANDABALCAO,
    PDH.DEMANDAOFICINA,
    PDH.DEMANDATELEMARK,    
    PDH.OCORRENCIAVENDAS,
    
    PDH.CLASS_ABC,   
    PDH.CLASS_XYZ,  
    PDH.TAXA_ESGOTAMENTO
    
FROM CNP.PEC_DEMANDA_HISTORICA PDH;












```

---

## Como relacionar no Power BI

No modelo do Power BI, criar relacionamento entre as duas tabelas pela chave:
```
fEstoquePecas[CHAVE_EMP_REV_ITEM]  →  V_PBI_DEMANDA_HISTORICA[CHAVE_EMP_REV_ITEM]