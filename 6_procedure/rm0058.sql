SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RM0058 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
  )
IS
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   v_FromDate date;
   v_ToDate date;
   v_CurrDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_TLID varchar2(4);

   -- added by Truong for logging
   V_TRADELOG CHAR(2);
   V_AUTOID NUMBER;
   v_tmtracham NUMBER;

BEGIN

-- return;

V_STROPTION := OPT;
IF V_STROPTION = 'A' then
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := substr(BRID,1,2) || '__' ;
else
    V_STRBRID:=BRID;
END IF;

v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
v_ToDate:= to_date(T_DATE,'DD/MM/RRRR');

/*
v_CustodyCD:= upper(replace(pv_custodycd,'.',''));
v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;

if v_CustodyCD = 'ALL' or v_CustodyCD is null then
    v_CustodyCD := '%';
else
    v_CustodyCD := v_CustodyCD;
end if;
*/
---------------------------------------------------------------------------------
select to_date(VARVALUE,'DD/MM/YYYY') into v_CurrDate from sysvar where grname='SYSTEM' and varname='CURRDATE';


OPEN PV_REFCURSOR FOR
/*
select a.*,v.* from (
    SELECT a.autoid, A.TXDATE CHGDATE, B.TXNUM , B.FRSTATUS, B.FR_DESC_STATUS, C.TOSTATUS, C.TO_DESC_STATUS FROM
    (
        SELECT TL01.TXDATE,TL01.TXNUM,FLDCD, DTL01.nVALUE AUTOID
        FROM vw_tllog_all TL01, vw_tllogfld_all DTL01
        WHERE TLTXCD = '6611' AND TL01.TXDATE=DTL01.TXDATE AND TL01.TXNUM=DTL01.TXNUM and FLDCD = '01'
            and TL01.txdate between  v_FromDate and v_ToDate
    ) A,
    (
        SELECT TL01.TXDATE,TL01.TXNUM,FLDCD, DTL01.cVALUE FRSTATUS, A0.CDCONTENT FR_DESC_STATUS
        FROM vw_tllog_all TL01, vw_tllogfld_all DTL01, (select * from allcode where cdtype='RM' and cdname='TRFLOGSTS') A0
        WHERE TLTXCD = '6611' AND TL01.TXDATE=DTL01.TXDATE AND TL01.TXNUM=DTL01.TXNUM and FLDCD = '08'
            AND A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGSTS' AND A0.CDVAL= DTL01.cVALUE
            and TL01.txdate between  v_FromDate and v_ToDate
    ) B,
    (
        SELECT TL01.TXDATE,TL01.TXNUM,FLDCD, DTL01.cVALUE TOSTATUS, A0.CDCONTENT TO_DESC_STATUS
        FROM vw_tllog_all TL01, vw_tllogfld_all DTL01, (select * from allcode where cdtype='RM' and cdname='TRFLOGSTS') A0
        WHERE TLTXCD = '6611' AND TL01.TXDATE=DTL01.TXDATE AND TL01.TXNUM=DTL01.TXNUM and FLDCD = '07'
            AND A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGSTS' AND A0.CDVAL= DTL01.cVALUE
            and TL01.txdate between  v_FromDate and v_ToDate
    ) C

    WHERE A.TXDATE=B.TXDATE AND B.TXDATE=C.TXDATE AND A.TXNUM=B.TXNUM AND B.TXNUM=C.TXNUM

) a, v_cr_trflogall_hist V      where  A.AUTOID = V.AUTOID

ORDER BY A.CHGDATE, A.TXNUM*/




select a.* ,

MST.AUTOID, MST.VERSION,MST.VERSIONLOCAL, MST.TXDATE, MST.AFFECTDATE,DTL.CRDATE, DTL.TXDATE TRANDATE,
MST.REFBANK||':'||A2.CDCONTENT REFBANK,MST.REFBANK BANKQUEUE,MST.TRFCODE, MST.CREATETST, MST.SENDTST,
FN_CRB_GETVOUCHERNO(MST.TRFCODE, MST.TXDATE, MST.VERSION) VOUCHERNO,DTL.AMT,DTL.ITEMCNT,
CASE WHEN MST.STATUS='E' AND DTL.STATUS='Z' THEN 'D' ELSE MST.STATUS END STATUS,
CASE WHEN (MST.STATUS='S' AND MST.AFFECTDATE>(SELECT TO_DATE(SYS.VARVALUE,'DD/MM/RRRR')
                                              FROM SYSVAR SYS WHERE SYS.VARNAME='CURRDATE'))
           OR MST.STATUS IN ('F','C','B') THEN 'Y'
     WHEN MST.STATUS='H' AND DTL.STATUS='Z' THEN 'Y'
     WHEN CASE WHEN MST.STATUS='E' AND DTL.STATUS='Z' THEN 'D' ELSE MST.STATUS END='D' THEN 'Y'
           ELSE 'N' END CHECKSTATUS,
A0.CDCONTENT DESC_STATUS, A1.CDCONTENT DESC_TRFCODE, ERR.ERRDESC,
DECODE(MST.STATUS,'P','Y','N') APRALLOW, DECODE(MST.STATUS,'P','Y','N') EDITALLOW,
CASE WHEN MST.STATUS IN ('B') THEN 'N' ELSE 'Y' END DISPALLOW




from (
    SELECT a.autoid, A.TXDATE CHGDATE, B.TXNUM , B.FRSTATUS, B.FR_DESC_STATUS, C.TOSTATUS, C.TO_DESC_STATUS FROM
    (
        SELECT TL01.TXDATE,TL01.TXNUM,FLDCD, DTL01.nVALUE AUTOID
        FROM vw_tllog_all TL01, vw_tllogfld_all DTL01
        WHERE TLTXCD = '6611' AND TL01.TXDATE=DTL01.TXDATE AND TL01.TXNUM=DTL01.TXNUM and FLDCD = '01'
        AND TL01.DELTD <> 'Y'
            and TL01.txdate between  v_FromDate and v_ToDate
    ) A,
    (
        SELECT TL01.TXDATE,TL01.TXNUM,FLDCD, DTL01.cVALUE FRSTATUS, A0.CDCONTENT FR_DESC_STATUS
        FROM vw_tllog_all TL01, vw_tllogfld_all DTL01, (select * from allcode where cdtype='RM' and cdname='TRFLOGSTS') A0
        WHERE TLTXCD = '6611' AND TL01.TXDATE=DTL01.TXDATE AND TL01.TXNUM=DTL01.TXNUM and FLDCD = '08'
            AND A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGSTS' AND A0.CDVAL= DTL01.cVALUE
            AND TL01.DELTD <> 'Y'
            and TL01.txdate between  v_FromDate and v_ToDate
    ) B,
    (
        SELECT TL01.TXDATE,TL01.TXNUM,FLDCD, DTL01.cVALUE TOSTATUS, A0.CDCONTENT TO_DESC_STATUS
        FROM vw_tllog_all TL01, vw_tllogfld_all DTL01, (select * from allcode where cdtype='RM' and cdname='TRFLOGSTS') A0
        WHERE TLTXCD = '6611' AND TL01.TXDATE=DTL01.TXDATE AND TL01.TXNUM=DTL01.TXNUM and FLDCD = '07'
            AND A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGSTS' AND A0.CDVAL= DTL01.cVALUE
            AND TL01.DELTD <> 'Y'
            and TL01.txdate between  v_FromDate and v_ToDate
    ) C

    WHERE A.TXDATE=B.TXDATE AND B.TXDATE=C.TXDATE AND A.TXNUM=B.TXNUM AND B.TXNUM=C.TXNUM
        AND A.txdate between  v_FromDate and v_ToDate
) a,

(
SELECT * FROM CRBTRFLOG
    UNION ALL
SELECT * FROM CRBTRFLOGHIST
)MST,

ALLCODE A0, ALLCODE A1,DEFERROR ERR,CRBDEFACCT CRA,ALLCODE A2,

(
    SELECT DTL.BANKCODE,DTL.VERSION,DTL.TRFCODE,DTL.TXDATE,MAX(REQ.TXDATE) CRDATE,SUM(DTL.AMT) AMT,COUNT(DTL.AUTOID) ITEMCNT,
    MAX(CASE WHEN DTL.STATUS IN ('D','B') THEN 'Z' ELSE 'A' END) STATUS
    FROM
    (
        SELECT * FROM CRBTRFLOGDTL --WHERE txdate between  v_FromDate and v_ToDate
        UNION ALL
        SELECT * FROM CRBTRFLOGDTLHIST --WHERE txdate between  v_FromDate and v_ToDate
    ) DTL,
    (
        SELECT * FROM CRBTXREQ --WHERE txdate between  v_FromDate and v_ToDate
        UNION ALL
        SELECT * FROM CRBTXREQHIST --WHERE txdate between  v_FromDate and v_ToDate
     )
     REQ

    WHERE DTL.REFREQID=REQ.REQID
    GROUP BY DTL.BANKCODE,DTL.VERSION,DTL.TRFCODE,DTL.TXDATE
) DTL
WHERE A.AUTOID = MST.AUTOID
AND  A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGSTS' AND A0.CDVAL=(CASE WHEN MST.STATUS='E' AND DTL.STATUS='Z' THEN 'D' ELSE MST.STATUS END)
AND A1.CDTYPE='SY' AND A1.CDNAME='TRFCODE' AND A1.CDVAL=MST.TRFCODE
AND MST.REFBANK=A2.CDVAL AND A2.CDNAME='BANKNAME' AND A2.CDTYPE='CF'
AND MST.TRFCODE=CRA.TRFCODE
AND MST.REFBANK=CRA.REFBANK AND CRA.MSGID not in ('CI','SE')
AND MST.REFBANK=DTL.BANKCODE AND MST.TRFCODE=DTL.TRFCODE AND MST.TXDATE=DTL.TXDATE
AND MST.VERSION=DTL.VERSION AND MST.ERRCODE=ERR.ERRNUM(+)


--ORDER BY A.CHGDATE, A.TXNUM


;

EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;

 
 
 
 
 
 
 
 
 
 
 
 
/
