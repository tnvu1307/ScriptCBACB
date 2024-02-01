SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE9999','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE9999', 'Quản lý chứng khoán', 'Securities management', 'SELECT CODEID,ISSUERID,SYMBOL,A0.<@CDCONTENT> SECTYPE,A2.<@CDCONTENT> TRADEPLACE,PARVALUE,FOREIGNRATE,ISSUEDATE,EXPDATE,INTCOUPON, A3.<@CDCONTENT> ISSEDEPOFEE,A4.<@CDCONTENT> DEPOSITORY
FROM SBSECURITIES,ALLCODE A0, ALLCODE A2 , ALLCODE A3,ALLCODE A4 WHERE   A0.CDTYPE = ''SA'' AND A0.CDNAME = ''SECTYPE'' AND  A3.CDTYPE = ''SY'' AND A3.CDNAME = ''YESNO'' AND ISSEDEPOFEE =A3.CDVAL(+)
AND A0.CDVAL=SECTYPE and  A2.CDTYPE = ''SA'' AND A2.CDNAME = ''TRADEPLACE'' AND A2.CDVAL= TRADEPLACE AND A4.CDTYPE = ''SA'' AND A4.CDNAME = ''DEPOSITORY''  AND A4.CDVAL= DEPOSITORY', 'SBSECURITIES', 'frmSBSECURITIES', NULL, NULL, NULL, 10000, 'Y', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;