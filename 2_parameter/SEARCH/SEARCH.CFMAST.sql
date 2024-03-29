SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFMAST', 'Thông tin khách hàng', 'Customer information', 'SELECT CF.*, AMC.SHORTNAME AMCSHORTNAME, TRU.SHORTNAME TRUSHORTNAME,LCB.SHORTNAME LCB,
            a1.<@CDCONTENT> FCT,A3.<@CDCONTENT> TRADEONLINE,A4.<@CDCONTENT> STCREVOKE,A5.<@CDCONTENT> CLOSEFEE,A6.<@CDCONTENT> BONDAGENT,A7.<@CDCONTENT> SENDSWIFT,A8.<@CDCONTENT> SUPEBANK
            ,a9.<@CDCONTENT> AUTOSETTLEFEE1
FROM VW_CFMAST CF,
        (
            SELECT 0 AUTOID, ''---'' SHORTNAME FROM DUAL
            UNION ALL
            SELECT AUTOID, SHORTNAME  FROM FAMEMBERS WHERE ROLES = ''AMC'' ORDER BY SHORTNAME
        ) AMC,
        (
            SELECT 0 AUTOID, ''---'' SHORTNAME FROM DUAL
            UNION ALL
            SELECT AUTOID, SHORTNAME  FROM FAMEMBERS WHERE ROLES = ''LCB'' ORDER BY SHORTNAME
        ) LCB,
        (
            SELECT 0 AUTOID, ''---'' SHORTNAME FROM DUAL
            UNION ALL
            SELECT AUTOID, SHORTNAME  FROM FAMEMBERS WHERE ROLES = ''TRU'' ORDER BY SHORTNAME
        ) TRU,
            (SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a1 --fct,
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a2 --custatom
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a3 --TRADEONLINE
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a4 --stcrevoke_val
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a5 --closefee_val
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a6 --BONDAGENT
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a7 --sendswift
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a8 --SUPEBANK
            ,(SELECT *fROM ALLCODE WHERE CDNAME = ''YESNO'') a9 --AUTOSETTLEFEE1
WHERE (''<$TELLERID>'' = ''0001''
    OR CF.CAREBYID IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
    OR EXISTS (
        SELECT AF.CUSTID FROM AFMAST AF,TLGRPUSERS TLG
        WHERE AF.CAREBY=TLG.GRPID AND TLG.TLID = ''<$TELLERID>''
        AND AF.CUSTID=CF.CUSTID
   )
)
AND CF.AMCID = AMC.AUTOID(+)
and cf.lcbid = LCB.AUTOID(+)
AND CF.TRUSTEEID = TRU.AUTOID(+)
and cf.fct_val = a1.cdval(+)
and cf.custatcom_val = a2.cdval(+)
AND CF.tradeonline_val = A3.CDVAL(+)
AND CF.stcrevoke_val  =A4.CDVAL(+)
AND CF.closefee_val = A5.CDVAL(+)
AND CF.bondagent_val = A6.CDVAL(+)
and cf.sendswift_val= a7.cdval(+)
and cf.supebank_val = a8.cdval(+)
and cf.AUTOSETTLEFEE = a9.cdval(+)', 'CFMAST', 'frmCFMAST', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;