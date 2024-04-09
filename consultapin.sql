/*
Autor: Patrick Covre Rodrigues
Data: 09/04/2024;
*/SELECT DISTINCT X.NUMNOTA, X.* FROM (SELECT
	DISTINCT CAB.NUMNOTA,
	CAB.NUNOTA,
	--VEN.CODVEND,
	VEN.APELIDO AS VENDEDOR,
	UFS.UF,
 VAR.NUNOTAORIG,
	CAB.CODPARC,
	PAR.NOMEPARC,
	CAB.DTFATUR,
	CAB.CODTIPOPER,
	(SELECT DESCROPER FROM TGFTOP WHERE CODTIPOPER = CAB.CODTIPOPER AND ROWNUM = 1) AS TOP,
	(SELECT NUPIN FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA AND CODCONTROLE = (SELECT MAX(CODCONTROLE) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA)) AS NUPIN,
	(SELECT F_DESCROPC('AD_CONTROLEPIN', 'STATUS', STATUS) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA AND CODCONTROLE = (SELECT MAX(CODCONTROLE) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA)) AS STATUS,
CAB.AD_CONTROLLOG,
	(SELECT DTSOL FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA AND CODCONTROLE = (SELECT MAX(CODCONTROLE) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA)) AS DTSOL,
	CAB.CHAVENFE
FROM
	TGFCAB CAB
LEFT JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
LEFT JOIN TGFVEN VEN ON VEN.CODVEND = PAR.CODVEND
LEFT JOIN TSICID CID ON CID.CODCID = PAR.CODCID
LEFT JOIN TSIUFS UFS ON UFS.CODUF = CID.UF
LEFT JOIN TGFVAR VAR ON VAR.NUNOTA = CAB.NUNOTA
WHERE (CAB.CODTIPOPER = 3249 OR (CAB.CODTIPOPER = 3241 AND PAR.AD_BENIPI = 'S'))
AND CAB.STATUSNFE = 'A'
AND CAB.NUNOTA IN (SELECT NUNOTA FROM TGFITE I LEFT JOIN TGFPRO P ON P.CODPROD = I.CODPROD WHERE P.CODIPI != 4)
--AND TO_DATE(CAB.DTFATUR) BETWEEN :PERIODO.INI AND :PERIODO.FIN
AND VAR.NUNOTA = CAB.NUNOTA 
UNION ALL
SELECT
	DISTINCT CAB.NUMNOTA,
	CAB.NUNOTA,
	--VEN.CODVEND,
	VEN.APELIDO AS VENDEDOR,
	UFS.UF,
 VAR.NUNOTAORIG,
	CAB.CODPARC,
	PAR.NOMEPARC,
	CAB.DTFATUR,
	CAB.CODTIPOPER,
	(SELECT DESCROPER FROM TGFTOP WHERE CODTIPOPER = CAB.CODTIPOPER AND ROWNUM = 1) AS TOP,
	(SELECT NUPIN FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA AND CODCONTROLE = (SELECT MAX(CODCONTROLE) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA)) AS NUPIN,
	(SELECT F_DESCROPC('AD_CONTROLEPIN', 'STATUS', STATUS) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA AND CODCONTROLE = (SELECT MAX(CODCONTROLE) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA)) AS STATUS,
CAB.AD_CONTROLLOG,
	(SELECT DTSOL FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA AND CODCONTROLE = (SELECT MAX(CODCONTROLE) FROM AD_CONTROLEPIN WHERE NUNOTA = CAB.NUNOTA)) AS DTSOL ,
CAB.CHAVENFE
FROM
	TGFCAB CAB
LEFT JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
LEFT JOIN TGFCPL CPL ON CPL.CODPARC = PAR.CODPARC
LEFT JOIN TGFVEN VEN ON VEN.CODVEND = PAR.CODVEND
LEFT JOIN TSICID CID ON CID.CODCID = PAR.CODCID
LEFT JOIN TSIUFS UFS ON UFS.CODUF = CID.UF
LEFT JOIN TGFPAEM PAEM ON PAEM.CODPARC = PAR.CODPARC
LEFT JOIN TGFVAR VAR ON VAR.NUNOTA = CAB.NUNOTA
WHERE (CAB.CODTIPOPER = 3230 AND PAR.AD_DESCONTOICMS = 'S' OR (CAB.CODTIPOPER = 3230 AND PAR.AD_BENIPI = 'S') OR CAB.CODTIPOPER = 3249)
AND CAB.STATUSNFE IN ('A', 'P')
AND CPL.CODSUFRAMA IS NOT NULL
AND PAEM.GRUPOICMS IS NOT NULL
--AND TO_DATE(CAB.DTFATUR) BETWEEN :PERIODO.INI AND :PERIODO.FIN
AND VAR.NUNOTA = CAB.NUNOTA
)X

