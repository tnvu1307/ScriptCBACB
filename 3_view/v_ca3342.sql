SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CA3342
(AUTOID, CAMASTID, DESCRIPTION, SYMBOL, ACTIONDATE, 
 POSTINGDATE, ALLAMT, AMT, SCVATAMT, IDCATYPE, 
 CODEID, ISINCODE, PITRATEMETHOD, ALLAMT_TAX, INTAMT)
AS 
SELECT A."AUTOID",
   A."CAMASTID",
   A."DESCRIPTION",
   A."SYMBOL",
   A."ACTIONDATE",
   A."POSTINGDATE",
   CASE WHEN A.PITRATEMETHOD='IS' THEN A.ALLAMT-(CASE WHEN A.PITRATEMETHOD='NO' THEN 0 ELSE SCVATAMT END) ELSE A.ALLAMT END ALLAMT,
   GREATEST(ALLAMT - (CASE WHEN A.PITRATEMETHOD='NO' THEN 0 ELSE SCVATAMT END),0) AMT,
   CASE WHEN A.PITRATEMETHOD='IS' OR A.PITRATEMETHOD='NO' THEN 0 ELSE A.SCVATAMT END SCVATAMT,
   A."IDCATYPE",
   A."CODEID",
   A."ISINCODE",
   A."PITRATEMETHOD",
   GREATEST(ALLAMT - (CASE WHEN A.PITRATEMETHOD='NO' THEN 0 ELSE SCVATAMT END),0) ALLAMT_TAX,
   INTAMT
FROM (SELECT *
      FROM (  SELECT MAX (A.AUTOID) AUTOID,
                     A.CAMASTID,
                     A.DESCRIPTION,
                     B.SYMBOL,
                     A.PITRATEMETHOD,
                     A.ACTIONDATE,
                     A.ACTIONDATE POSTINGDATE,
                     SUM (CASE WHEN A.CATYPE = '010' THEN ROUND(NVL(CAD.AMT, CHD.AMT)) ELSE ROUND(CHD.AMT) END) ALLAMT, --So tien truoc thue ngay 25/02/2020 NamTv chinh sau
                     SUM (CHD.AMT) AMT, --So tien phan bo
                     SUM (
                        (CASE
                            WHEN CF.VAT = 'Y'
                            THEN
                               (CASE
                                   WHEN TRIM(a.CATYPE) in ('016','023','033') THEN ROUND (CHD.INTAMT * A.PITRATE / 100)
                                   WHEN a.CATYPE = '024' THEN round(chd.balance*a.EXPRICE*a.pitrate/100/(to_number(SUBSTR(A.exrate ,0,INSTR(A.exrate ,'/') - 1))/to_number(SUBSTR(A.exrate ,INSTR(A.exrate ,'/')+1,LENGTH(A.exrate )))))
                                   WHEN A.CATYPE = '010' and cf.custtype ='I' THEN ROUND(NVL(CAD.AMT, CHD.AMT) * A.PITRATE / 100)
                                   when A.CATYPE = '010' and cf.custtype ='B' then 0 --trung.luu: 09-06-2020 SHBVNEX-1362 KH to chuc thi so tien thue = 0
                                   ELSE ROUND (CHD.AMT * A.PITRATE / 100)
                                END)
                            ELSE
                               0
                         END)) SCVATAMT, --So tien thue
                     A.CATYPE IDCATYPE,
                     MAX (A.CODEID) CODEID,
                     A.ISINCODE,
                     SUM(CASE WHEN A.CATYPE IN ('016', '023', '033') THEN CHD.INTAMT ELSE 0 END) INTAMT
                FROM CAMAST A,
                     SBSECURITIES B,
                     CASCHD CHD,
                     ALLCODE CD,
                     AFMAST AF,
                     AFTYPE AFT,
                     CFMAST CF,
                    (SELECT CSD1.* FROM CASCHDDTL CSD1 WHERE CSD1.DELTD <> 'Y' AND CSD1.STATUS ='P') CAD
               WHERE     A.CODEID = B.CODEID
                     AND CHD.STATUS IN ('S',
                                        'H',
                                        'W',
                                        'K',
                                        'I')
                     AND A.STATUS IN ('K', 'I', 'H') /*AND A.STATUS  IN ('I','G','H','K')*/
                     AND CHD.AFACCTNO = AF.ACCTNO
                     AND AF.ACTYPE = AFT.ACTYPE
                     AND AF.CUSTID = CF.CUSTID
                     AND A.DELTD <> 'Y'
                     AND A.CAMASTID = CHD.CAMASTID
                     AND CHD.AUTOID = CAD.autoid_caschd (+)
                     AND CHD.afacctno = CAD.afacctno (+)
                     AND CHD.DELTD <> 'Y'
                     AND CHD.ISEXEC = 'Y'
                     AND CHD.STATUS <> 'C'
                     AND (CHD.ISCI = 'N' OR (A.STATUS = 'K' AND A.CATYPE = '010'))
                     AND (CASE WHEN A.CATYPE = '010' THEN DECODE (NVL (CAD.STATUS, 'C'), 'P', 1, 0) ELSE 1 END) = 1
                     AND (SELECT COUNT (1)
                            FROM CASCHD
                            WHERE CAMASTID = A.CAMASTID
                            AND STATUS <> 'C'
                            AND (ISCI = 'N' OR (A.STATUS = 'K'AND A.CATYPE = '010'))
                            AND ISEXEC = 'Y'
                            AND AMT > 0
                            AND DELTD = 'N') > 0
                            AND CD.CDNAME = 'CATYPE'
                            AND CD.CDTYPE = 'CA'
                            AND CD.CDVAL = A.CATYPE
                            GROUP BY A.ISINCODE,A.CAMASTID,A.DESCRIPTION,A.CATYPE,B.SYMBOL,A.PITRATEMETHOD,A.ACTIONDATE
                            HAVING SUM (CHD.AMT) <> 0)
     WHERE 0 = 0) A
WHERE 0 = 0
/
