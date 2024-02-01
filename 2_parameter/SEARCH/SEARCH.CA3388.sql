SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3388','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3388', 'Tra cứu kết thúc đợt thực hiện quyền', 'Tra cứu kết thúc đợt thực hiện quyền', 'SELECT DT.AUTOID, DT.VSDMSGID, CA.CAMASTID, CA.DESCRIPTION, CA.ISINCODE, DT.TXDESC,
    A1.<@CDCONTENT> CATYPE, A2.<@CDCONTENT> CASTATUS, A3.<@CDCONTENT> STATUS
FROM CAMAST CA, 
(
    SELECT MSG.VSDCAID, MSG.STATUS, DECODE(LG.MSGTYPE, ''567'', ''CLOSE'', ''CANCEL'') TXDESC,
           MSG.AUTOID, LG.REFMSGID VSDMSGID
    FROM MSGCARECEIVED MSG, VSDTRFLOG LG
    WHERE MSG.VSDMSGID = LG.REFMSGID
    AND (
            LG.MSGTYPE = ''567'' AND INSTR(LG.FUNCNAME, ''.EPRC//COMP'') > 0 OR
            LG.MSGTYPE = ''564'' AND INSTR(LG.FUNCNAME, ''564.CANC.'') > 0
        )
    AND MSG.STATUS = ''P''
) DT,
(
    SELECT * FROM ALLCODE WHERE CDNAME = ''CATYPE'' AND CDTYPE = ''CA''
) A1,
(
    SELECT * FROM ALLCODE WHERE CDNAME = ''CASTATUS'' AND CDTYPE = ''CA''
) A2,
(
    SELECT * FROM ALLCODE WHERE CDNAME = ''MSGCARECEIVEDSTS'' AND CDTYPE = ''RM''
) A3
WHERE CA.VSDCAID = DT.VSDCAID
AND CA.CATYPE = A1.CDVAL(+)
AND CA.STATUS = A2.CDVAL(+)
AND DT.STATUS = A3.CDVAL(+)
AND CA.STATUS NOT IN ''C''
AND CA.DELTD NOT IN ''Y''', 'CAMAST', 'frm', NULL, '3388', 0, 5000, 'N', 30, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;