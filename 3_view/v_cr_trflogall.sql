SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CR_TRFLOGALL
(AUTOID, VERSION, VERSIONLOCAL, CUSTODYCD, TXDATE, 
 AFFECTDATE, CRDATE, TLID, CHECKER, REFBANK, 
 BANKQUEUE, TRFCODE, CREATETST, SENDTST, VOUCHERNO, 
 AMT, ITEMCNT, STATUS, CHECKSTATUS, DESC_STATUS, 
 DESC_TRFCODE, ERRDESC, APRALLOW, EDITALLOW, DISPALLOW)
AS 
SELECT MST.AUTOID, MST.VERSION,MST.VERSIONLOCAL,DTL.CUSTODYCD CUSTODYCD,MST.TXDATE, MST.AFFECTDATE,DTL.CRDATE,TLP.tlname TLID,TTLP.TLNAME CHECKER,
MST.REFBANK||':'||A2.CDCONTENT REFBANK,MST.REFBANK BANKQUEUE,MST.TRFCODE, to_char(MST.CREATETST,'dd/mm/rrrr hh24:mi:ss') CREATETST, MST.SENDTST,
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
FROM CRBTRFLOG MST, ALLCODE A0, ALLCODE A1,DEFERROR ERR,CRBDEFACCT CRA,ALLCODE A2,TLPROFILES TLP,TLPROFILES TTLP,
(
    SELECT DTL.BANKCODE,max(CF.CUSTODYCD) CUSTODYCD,DTL.VERSION,DTL.TRFCODE,DTL.TXDATE,MAX(REQ.TXDATE) CRDATE,SUM(DTL.AMT) AMT,COUNT(DTL.AUTOID) ITEMCNT,
    MAX(CASE WHEN DTL.STATUS IN ('D','B') THEN 'Z' ELSE 'A' END) STATUS
    FROM CRBTRFLOGDTL DTL,CRBTXREQ REQ,CFMAST CF,AFMAST AF
    WHERE DTL.REFREQID=REQ.REQID AND CF.CUSTID = AF.CUSTID AND DTL.AFACCTNO = AF.ACCTNO
    GROUP BY DTL.BANKCODE,DTL.VERSION,DTL.TRFCODE,DTL.TXDATE--,CF.CUSTODYCD
) DTL
WHERE A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGSTS' AND A0.CDVAL=(CASE WHEN MST.STATUS='E' AND DTL.STATUS='Z' THEN 'D' ELSE MST.STATUS END)
AND A1.CDTYPE='SY' AND A1.CDNAME='TRFCODE' AND A1.CDVAL=MST.TRFCODE
AND MST.REFBANK=A2.CDVAL AND A2.CDNAME='BANKNAME' AND A2.CDTYPE='CF'
AND MST.TRFCODE=CRA.TRFCODE AND MST.STATUS <> 'B'
AND MST.REFBANK=CRA.REFBANK AND cspks_rmproc.is_number(CRA.MSGID)=1
AND MST.REFBANK=DTL.BANKCODE AND MST.TRFCODE=DTL.TRFCODE AND MST.TXDATE=DTL.TXDATE
and MST.TLID = TLP.TLID(+)
--and (case when mst.tlid is null or mst.tlid ='0000' then fn_getCRBTRFLOG_CreateUser(mst.autoid) else mst.tlid end) = TLP.TLID(+)
AND MST.OFFID = TTLP.TLID(+)
AND MST.VERSION=DTL.VERSION AND MST.ERRCODE=ERR.ERRNUM(+)
ORDER BY MST.TXDATE DESC,MST.AFFECTDATE DESC,MST.REFBANK,MST.VERSION DESC
/
