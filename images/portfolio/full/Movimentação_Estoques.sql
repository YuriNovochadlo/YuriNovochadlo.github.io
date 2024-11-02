SELECT sd3.D3_EMISSAO AS Data, 
       sd3.D3_COD AS Codigo, 
       CASE 
           WHEN LEFT(sd3.D3_CF, 2) IN ('RE', 'ER') THEN 'Retirado' 
           WHEN LEFT(sd3.D3_CF, 2) IN ('DE', 'PR') THEN 'Depositado' 
           ELSE D3_CF 
       END AS Movimento, 
       sd3.D3_LOCAL AS Armazem,  
       SUM(sd3.D3_QUANT) AS Quantidade 
FROM SD3010 sd3 
LEFT JOIN SB1010 sb1_a
    ON sb1_a.B1_COD = sd3.D3_COD
    AND sb1_a.D_E_L_E_T_ = '' 
    AND sb1_a.B1_FILIAL = ''

WHERE sd3.D3_FILIAL = '01' 
  AND sd3.D3_LOCAL IN ('01', '03', '25', '26') 
  AND sd3.D_E_L_E_T_ = '' 
  AND YEAR(sd3.D3_EMISSAO) >= YEAR(GETDATE()) - 5 
  AND sd3.D3_EMISSAO >= '20190331' 
  AND sb1_a.B1_GRUPO IN ('0005', '0014', '0015', '0017', '0024', '0028', '0036', '0037', '0046', '0048', '0059', '0067', '0068', '0069', '0070', '0071')
GROUP BY sd3.D3_EMISSAO, sd3.D3_CF, sd3.D3_LOCAL, sd3.D3_COD

UNION

SELECT sd1.D1_DTDIGIT AS Data,
       sd1.D1_COD AS Codigo,
       'Depositado NF' AS Movimento,
       sd1.D1_LOCAL AS Armazem, 
       SUM(sd1.D1_QUANT) AS Quantidade
FROM SD1010 sd1 
LEFT JOIN SB1010 sb1_b
    ON sb1_b.B1_COD = sd1.D1_COD
    AND sb1_b.D_E_L_E_T_ = '' 
    AND sb1_b.B1_FILIAL = ''
	
LEFT JOIN SF4010 sf4
	ON sf4.D_E_L_E_T_ = ''
	AND SD1.D1_TES = sf4.F4_CODIGO

WHERE sd1.D1_FILIAL = '01' 
  AND sd1.D1_LOCAL IN ('01', '03', '25', '26') 
  AND sd1.D_E_L_E_T_ = '' 
  AND YEAR(sd1.D1_DTDIGIT) >= YEAR(GETDATE()) - 5 
  AND sd1.D1_DTDIGIT >= '20190331' 
  AND sb1_b.B1_GRUPO IN ('0005', '0014', '0015', '0017', '0024', '0028', '0036', '0037', '0046', '0048', '0059', '0067', '0068', '0069', '0070', '0071')
  AND sf4.F4_ESTOQUE = 'S'
GROUP BY sd1.D1_DTDIGIT, sd1.D1_LOCAL, sd1.D1_COD

UNION

SELECT sd2.D2_EMISSAO AS Data,
       sd2.D2_COD AS Codigo,
       'Retirado' AS Movimento,
       sd2.D2_LOCAL AS Armazem, 
       SUM(sd2.D2_QUANT) AS Quantidade
FROM SD2010 sd2 
LEFT JOIN SB1010 sb1_c
    ON sb1_c.B1_COD = sd2.D2_COD
    AND sb1_c.D_E_L_E_T_ = '' 
    AND sb1_c.B1_FILIAL = ''
WHERE sd2.D2_FILIAL = '01' 
  AND sd2.D2_LOCAL IN ('01', '03', '25', '26') 
  AND sd2.D_E_L_E_T_ = '' 
  AND YEAR(sd2.D2_EMISSAO) >= YEAR(GETDATE()) - 5 
  AND sd2.D2_EMISSAO >= '20190331' 
  AND sb1_c.B1_GRUPO IN ('0005', '0014', '0015', '0017', '0024', '0028', '0036', '0037', '0046', '0048', '0059', '0067', '0068', '0069', '0070', '0071')
  AND sd2.D2_ESTOQUE != 'N'

GROUP BY sd2.D2_EMISSAO, sd2.D2_LOCAL, sd2.D2_COD
