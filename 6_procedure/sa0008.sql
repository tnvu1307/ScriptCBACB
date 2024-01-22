SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sa0008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TLTXCD         IN       VARCHAR2,
   MAKER          IN       VARCHAR2,
   CHECKER        IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- TRUONGLD    09/05/2017  ADD
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (15);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (100);        -- USED WHEN V_NUMOPTION > 0
   V_STRINBRID        VARCHAR2 (15);

   V_STRTLTXCD              VARCHAR2 (16);
   V_STRMAKER            VARCHAR2 (20);
   V_STRCHECKER             VARCHAR2 (20);
   V_STRCUSTOCYCD           VARCHAR2 (20);
   V_CURRDATE               DATE;
   v_frdate                 date;
   v_todate                 date;
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := upper(OPT);
   V_STRINBRID := BRID;

   IF (V_STROPTION = 'A' )
   THEN
      V_STRBRID := '%';
   ELSE if(V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_STRINBRID;
        else
            V_STRBRID := V_STRINBRID;
        end if;
   END IF;

   IF (TLTXCD <> 'ALL')
   THEN
      V_STRTLTXCD := TLTXCD;
   ELSE
      V_STRTLTXCD := '%%';
   END IF;

   IF (MAKER <> 'ALL')
   THEN
      V_STRMAKER := MAKER;
   ELSE
      V_STRMAKER := '%%';
   END IF;

   IF (CHECKER <> 'ALL')
   THEN
      V_STRCHECKER := CHECKER;
   ELSE
      V_STRCHECKER := '%%';
   END IF;

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTOCYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTOCYCD := '%%';
   END IF;

   V_CURRDATE := getcurrdate;
   v_frdate := to_date(F_DATE,'DD/MM/YYYY');
   v_todate := to_date(T_DATE,'DD/MM/YYYY');

   IF to_date(T_DATE,'DD/MM/YYYY' ) = V_CURRDATE AND to_date(T_DATE,'DD/MM/YYYY' ) = V_CURRDATE THEN
       OPEN PV_REFCURSOR
       FOR
            SELECT * FROM
            (
                SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE,
                       NVL(TR.NAMT, TL.MSGAMT) MSGAMT,
                       NVL(TR.ACCTNO, SUBSTR(TL.MSGACCT,1,10)) MSGACCT,
                       NVL(TR.TRDESC,TO_CHAR(TL.TXDESC)) TXDESC,
                       TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
                FROM TLLOG TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
                    (select tr.* from ddtran tr, apptx tx where tr.txcd=tx.txcd and tx.apptype='CI' and tx.FIELD IN ('BALANCE')) TR
                WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
                AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
                and af.acctno(+)= substr(TL.MSGACCT,1,10)
                and cf.custid (+)= af.custid
                and tl.txdate <= v_todate
                and tl.txdate >= v_frdate
                AND TL.TXDATE = TR.TXDATE(+)
                AND TL.TXNUM = TR.TXNUM (+)
                AND nvl(TL.tlID,'-') LIKE V_STRMAKER
                AND nvl(TL.offid,'-') LIKE V_STRCHECKER
                AND TL.tltxcd LIKE V_STRTLTXCD
                and cf.custodycd like V_STRCUSTOCYCD
                And Tl.Deltd <>'Y'
            )ORDER BY TLTXCD, BUSDATE, TXNUM, MAKER;
   ELSE
       OPEN PV_REFCURSOR
       FOR
            SELECT * FROM
            (
                SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE,
                       NVL(TR.NAMT, TL.MSGAMT) MSGAMT,
                       NVL(TR.ACCTNO, SUBSTR(TL.MSGACCT,1,10)) MSGACCT,
                       NVL(TR.TRDESC,TO_CHAR(TL.TXDESC)) TXDESC,
                       TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
                FROM VW_TLLOG_ALL TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
                    (SELECT * FROM VW_ddTRAN_GEN WHERE FIELD IN ('BALANCE')) TR
                WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
                AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
                and af.acctno(+)= substr(TL.MSGACCT,1,10)
                and cf.custid (+)= af.custid
                and tl.txdate <= v_todate
                and tl.txdate >= v_frdate
                AND TL.TXDATE = TR.TXDATE(+)
                AND TL.TXNUM = TR.TXNUM (+)
                AND nvl(TL.tlID,'-') LIKE V_STRMAKER
                AND nvl(TL.offid,'-') LIKE V_STRCHECKER
                AND TL.tltxcd LIKE V_STRTLTXCD
                and cf.custodycd like V_STRCUSTOCYCD
                And Tl.Deltd <>'Y'
            )ORDER BY TLTXCD, BUSDATE, TXNUM, MAKER;

END IF;
EXCEPTION
   WHEN OTHERS
   THEN
    plog.error ('SA0008: ' || SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
End;
/
