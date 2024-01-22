SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sa0004 (
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
-- HUNG.LB   26-Aug-10  UPDATED
-- ANH.PT    17-Sep-10  UPDATED
-- ANH.PT   23-Sep-10  UPDATED, CHANGE ID 38
-- HUYNH.ND 06-Oct-10  UPDATED, ADD filter CUSTOCYCD ( Chon tai khoan luu ky )
-- HUYNH.ND 13-Oct-10  UPDATED, Doi ten tham so dau vao CUSTODYCD -> PV_CUSTODYCD
-- HUNG.LB  27-Oct-10  UPDATED  CHANGE ID 102
-- SINH.TN  01-Nov-10  UPDATED, Them ma giao dich 5573 cho bao cao va thay the dieu kien cf.custodycd<>'017P000002' thanh nvl(cf.custodycd,'-')<>'017P000002' trong dk where
-- HUYNH.ND 05-Nov-2010 UPDATE, CHANGE ID 118: GD 8879 bi trung` records
-- HUYNH.ND 12-Nov-2010  UPDATE, CHANGE ID   : GD 3387 them thong tin MaCK  Ck vao thong tin mieu ta.
-- HUYNH.ND 16-Nov-2010  UPDATE, CHANGE ID   : GD 2650 2675 khong tao duoc bao cao.
-- HUYNH.ND 16-Nov-2010   UPDATE, CHANGE ID  : GD 3386 them thong tin MaCK  sua gia tri cot "so tien/SL" tu` SL thanh So Tien.
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (15);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (100);        -- USED WHEN V_NUMOPTION > 0
   V_STRINBRID        VARCHAR2 (15);

   V_STRTLTXCD              VARCHAR2 (16);
   V_STRMAKER            VARCHAR2 (20);
   V_STRCHECKER             VARCHAR2 (20);
   V_STRCUSTOCYCD           VARCHAR2 (20);
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

OPEN PV_REFCURSOR
  FOR
select * from(

SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
       NVL(TR.NAMT, TL.MSGAMT) MSGAMT,
       NVL(TR.ACCTNO, SUBSTR(TL.MSGACCT,1,10)) MSGACCT,
       NVL(TR.TRDESC,TO_CHAR(TL.TXDESC)) TXDESC,
       TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOGALL TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
    (select * from vw_ddtran_gen where FIELD IN ('BALANCE')) TR
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and cf.custodycd(+)= substr(TL.CFCUSTODYCD,1,10)
and cf.custid (+)= af.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND TL.TXDATE = TR.TXDATE(+)
AND TL.TXNUM = TR.TXNUM (+)
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND TL.tltxcd LIKE V_STRTLTXCD
And Tl.Deltd <>'Y'
and TL.tltxcd not in ('1101','3369','3342','3341','2650','2675','3386','3387','2643','2642','1196',
                      '2297','2298','0071','1171','2271','1172','0072','2272','8871','8872','8864','8878',
                      '8879','8804', '8809','8822','8824','9900','5573')
--and nvl(cf.custodycd,'-')<>'017P000002' -- Sinh fixed (old: cf.custodycd<>'017P000002')
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD
/*UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,TL.MSGAMT,substr(TL.MSGACCT,1,10) MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOGALL TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf--, VW_DFMAST_ALL DF
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and af.acctno(+)= DF.AFACCTNO
AND DF.ACCTNO = TL.MSGACCT
and cf.custid (+)= af.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND TL.tltxcd LIKE V_STRTLTXCD
And Tl.Deltd <>'Y'
and TL.tltxcd IN  ('2643','2642')
--and nvl(cf.custodycd,'-')<>'017P000002' -- Sinh fixed (old: cf.custodycd<>'017P000002')
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD*/
UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE,
       --TL.MSGAMT,TL.MSGACCT MSGACCT , to_char(TL.TXDESC) txdesc ,
       CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
       NVL(TR.NAMT, TL.MSGAMT) MSGAMT,
       NVL(TR.ACCTNO, SUBSTR(TL.MSGACCT,1,10)) MSGACCT,
       NVL(TR.TRDESC,TO_CHAR(TL.TXDESC)) TXDESC,
       TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOG TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
     (select * from vw_ddtran_gen where FIELD IN ('BALANCE')) TR
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and cf.custodycd(+)= substr(TL.CFCUSTODYCD,1,10)
and cf.custid (+)= af.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND TL.TXDATE = TR.TXDATE(+)
AND TL.TXNUM = TR.TXNUM (+)
--AND TR.FIELD IN ('BALANCE')
And Tl.Tltxcd Like V_Strtltxcd
and TL.tltxcd not in ('1101','3369','3342','3341','2650','2675','3386','3387','2643','1196','2297',
                      '2298','0071','1171','2271','1172','0072','2272','8871','8872','8864','8878',
                      '8879','8804','8809','8822','8824','9900','5573')
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
and tl.deltd <>'Y'
--and nvl(cf.custodycd,'-')<>'017P000002' -- Sinh fixed (old: cf.custodycd<>'017P000002')
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD
/*UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,TL.MSGAMT,substr(TL.MSGACCT,1,10) MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOG TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf, VW_DFMAST_ALL DF
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and af.acctno(+)= DF.AFACCTNO
AND DF.ACCTNO = TL.MSGACCT
and cf.custid (+)= af.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND TL.tltxcd LIKE V_STRTLTXCD
And Tl.Deltd <>'Y'
and TL.tltxcd IN  ('2643','2642')
--and nvl(cf.custodycd,'-')<>'017P000002' -- Sinh fixed (old: cf.custodycd<>'017P000002')
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD*/

------------------- GD 2650  ------------------------------------------
UNION ALL
SELECT TLF.CVALUE CUSTODYCD,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
TL.MSGAMT,substr(TL.MSGACCT,1,10) MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOG TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,TLLOGFLD TLF
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and af.acctno(+)= substr(TL.MSGACCT,1,10)
and cf.custid (+)= af.custid
and tl.txdate between to_date(F_DATE,'DD/MM/YYYY') and  to_date(T_DATE,'DD/MM/YYYY')
And Tl.Deltd <>'Y'
AND TL.TLTXCD IN ('2650','2675')
AND TL.TXDATE=TLF.TXDATE AND TL.TXNUM=TLF.TXNUM
AND TLF.FLDCD='88'
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND TL.tltxcd like V_STRTLTXCD
AND TLF.CVALUE like V_STRCUSTOCYCD
--and nvl(cf.custodycd,'-')<>'017P000002'
and nvl(cf.custodycd,'-') not like '022P%'
UNION ALL
SELECT TLF.CVALUE CUSTODYCD,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
TL.MSGAMT,substr(TL.MSGACCT,1,10) MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOGALL TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,TLLOGFLDALL TLF
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and af.acctno(+)= substr(TL.MSGACCT,1,10)
and cf.custid (+)= af.custid
and tl.txdate between to_date(F_DATE,'DD/MM/YYYY') and  to_date(T_DATE,'DD/MM/YYYY')
And Tl.Deltd <>'Y'
AND TL.TLTXCD IN ('2650','2675')
AND TL.TXDATE=TLF.TXDATE AND TL.TXNUM=TLF.TXNUM
AND TLF.FLDCD='88'
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND TL.tltxcd like V_STRTLTXCD
AND TLF.CVALUE like V_STRCUSTOCYCD
--and nvl(cf.custodycd,'-')<>'017P000002'
and nvl(cf.custodycd,'-') not like '022P%'

------------------- GD 3386 them thong tin MaCK  sua gia tri cot "so tien/soluong" tu` SL thanh So Tien.
UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
tlf.qtty*tlf.price MSGAMT,TL.MSGACCT MSGACCT,
  to_char(TL.TXDESC||'-Ma CK:'||tlf.symbol||'-SL:'||tlf.qtty) as TXDESC,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM tllog TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
    (select txdate,txnum,sum(decode(fldcd,05,nvalue)) price,
  sum(decode(fldcd,21,nvalue)) qtty,
  LISTAGG(decode(fldcd,04,cvalue)) within group (order by  cvalue) symbol
  from tllogfld where fldcd in ('04','05','21') -- 04: Price, 05: symbol, 21: MaxQtty
  and txdate between to_date(F_DATE,'DD/MM/YYYY') and  to_date(T_DATE,'DD/MM/YYYY')
  group by txdate,txnum) tlf
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
  AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
  and af.acctno(+)= substr(TL.MSGACCT,1,10)
  and cf.custid (+)= af.custid
  and tl.txdate between to_date(F_DATE,'DD/MM/YYYY') and  to_date(T_DATE,'DD/MM/YYYY')
  AND tl.tltxcd IN('3386')
  and tl.deltd <>'Y'
  --and nvl(cf.custodycd,'-')<>'017P000002'
  and nvl(cf.custodycd,'-') not like '022P%'
  and tlf.txnum=tl.txnum
  and tlf.txdate=tl.txdate
   AND nvl(TL.tlID,'-') LIKE V_STRMAKER
  AND nvl(TL.offid,'-') LIKE V_STRCHECKER
  And Tl.Tltxcd Like V_STRTLTXCD
  and cf.custodycd like V_STRCUSTOCYCD
UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
tlf.qtty*tlf.price MSGAMT,TL.MSGACCT MSGACCT,
  to_char(TL.TXDESC||'-MA CK:'||tlf.symbol||'-SL:'||tlf.qtty) as TXDESC,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM tllogall TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
    (select txdate,txnum,sum(decode(fldcd,05,nvalue)) price,
  sum(decode(fldcd,21,nvalue)) qtty,
  LISTAGG(decode(fldcd,04,cvalue)) within group (order by  cvalue) symbol
  from tllogfldall where fldcd in ('04','05','21') -- 04: Price, 05: symbol, 21: MaxQtty
  and txdate between to_date(F_DATE,'DD/MM/YYYY') and  to_date(T_DATE,'DD/MM/YYYY')
  group by txdate,txnum) tlf
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
  AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
  and af.acctno(+)= substr(TL.MSGACCT,1,10)
  and cf.custid (+)= af.custid
  and tl.txdate between to_date(F_DATE,'DD/MM/YYYY') and  to_date(T_DATE,'DD/MM/YYYY')
  AND tl.tltxcd IN('3386')
  and tl.deltd <>'Y'
  --and nvl(cf.custodycd,'-')<>'017P000002'
  and nvl(cf.custodycd,'-') not like '022P%'
  and tlf.txnum=tl.txnum
  and tlf.txdate=tl.txdate
  AND nvl(TL.tlID,'-') LIKE V_STRMAKER
  AND nvl(TL.offid,'-') LIKE V_STRCHECKER
  And Tl.Tltxcd Like V_STRTLTXCD
  and cf.custodycd like V_STRCUSTOCYCD

------------------- GD 3387 them thong tin MaCK  Ck vao thong tin mieu ta
UNION ALL
SELECT CF.CUSTODYCD, TL.TLTXCD, TL.TXNUM, TL.TXDATE, TL.BUSDATE,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
           NVL(TR.NAMT, TL.MSGAMT) MSGAMT,
           NVL(SUBSTR(TL.MSGACCT,1,10), TR.ACCTNO) MSGACCT,
           TO_CHAR(NVL(TR.txdesc, TL.TXDESC)) TXDESC ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
    FROM CFMAST CF, AFMAST AF, VW_TLLOG_ALL TL,
         (SELECT * FROM VW_ddTRAN_GEN WHERE FIELD IN ('FLOATAMT')) TR,
         ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2
    WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
          AND TL.TXNUM = TR.TXNUM (+)
          AND TL.TXDATE = TR.TXDATE (+)
          AND TLPR1.TLID(+) = TL.TLID  AND TLPR2.TLID (+) = TL.OFFID
          AND AF.ACCTNO(+)= SUBSTR(TL.MSGACCT,1,10)
          AND CF.CUSTID (+)= AF.CUSTID
          AND TL.TXDATE <= TO_DATE(T_DATE,'DD/MM/YYYY' )
          AND TL.TXDATE >= TO_DATE(F_DATE,'DD/MM/YYYY' )
          AND NVL(TL.TLID,'-') LIKE V_STRMAKER
          AND NVL(TL.OFFID,'-') LIKE V_STRCHECKER
          AND TL.TLTXCD LIKE V_STRTLTXCD
          AND TL.DELTD <>'Y'
          AND TL.TLTXCD IN ('3387')
          --AND NVL(CF.CUSTODYCD,'-')<>'017P000002'
          and nvl(cf.custodycd,'-') not like '022P%'
          AND CF.CUSTODYCD LIKE V_STRCUSTOCYCD

-----------------GD 8878 8879
UNION ALL
SELECT cf.custodycd, TL.tltxcd , TL.txnum,TL.TXDATE,TL.BUSDATE,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
SE.namt, TL.MSGACCT MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOG TL, vw_setran_gen SE,
ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf
WHERE tl.txnum = se.txnum
AND tl.txdate = se.txdate
AND AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and af.acctno(+)= se.acctno
and cf.custid (+)= se.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND tl.tltxcd IN('8878','8879')
AND TL.tltxcd LIKE V_STRTLTXCD
and tl.deltd <>'Y'
--and nvl(cf.custodycd,'-')<>'017P000002' -- Sinh fixed (old: cf.custodycd<>'017P000002')
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD
--and se.txcd in ('0019','0020') -- Fix 8879 8879 bi trung records CHANGE ID 118
AND se.FIELD IN ('TRADE','RECEIVING')
UNION ALL
SELECT cf.custodycd,TL.tltxcd , TL.txnum,TL.TXDATE,TL.BUSDATE,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
SE.namt, TL.MSGACCT MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOGALL TL, vw_setran_gen SE,
ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf
WHERE tl.txnum = se.txnum
AND tl.txdate = se.txdate
AND AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and af.acctno(+)= se.acctno
and cf.custid (+)= se.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND tl.tltxcd IN('8878','8879')
AND se.FIELD IN ('TRADE','RECEIVING')
AND TL.tltxcd LIKE V_STRTLTXCD
and tl.deltd <>'Y'
--and nvl(cf.custodycd,'-')<>'017P000002' -- Sinh fixed (old: cf.custodycd<>'017P000002')
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD
--and se.txcd in ('0019','0020')  -- Fix 8879 8879 bi trung records CHANGE ID 118
/*
--iiiiii
UNION ALL -- Diem Huong added
SELECT tci.custodycd,tci.TLTXCD ,tci.TXNUM,tci.TXDATE,tci.BUSDATE ,nvl(tci.namt,0) namt,tci.acctno MSGACCT,
--decode(tci.tltxcd,'1153',to_char(decode(tci.txtype,'D','Phi ung truoc',tci.txdesc)),decode(tci.txcd,'0028','Phi '||tci.txdesc,tci.txdesc)) txdesc
tci.txdesc
,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
from vw_CITRAN_gen tci,tlprofiles tlpr1, tlprofiles tlpr2, allcode al, afmast af, cfmast cf
where  tci.busdate between to_date(F_DATE,'DD/MM/YYYY' ) and to_date(T_DATE,'DD/MM/YYYY' )
       and tci.field = 'BALANCE'
       and tci.tltxcd in('1153','1101')
       and tci.txtype='D'
       and al.cdtype='SY' and al.cdname='TXSTATUS' and al.cdval =1
       and  TLPR1.TLID(+) =tci.TLID  AND TLPR2.TLID (+)=tci.OFFID
       and af.acctno(+)= substr(tci.dfacctno,1,10)
       and cf.custid (+)= af.custid
       AND nvl(tci.tlID,'-') LIKE V_STRMAKER
       AND nvl(tci.offid,'-') LIKE V_STRCHECKER
       AND tci.tltxcd LIKE V_STRTLTXCD
       and tci.deltd <>'Y'
       --and nvl(tci.custodycd,'-')<>'017P000002' -- Sinh fixed (old: tci.custodycd<>'017P000002')
       and nvl(cf.custodycd,'-') not like '022P%'
       and tci.custodycd like V_STRCUSTOCYCD
*/
 -- Sinh added (1-nov-2010)
/*UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,TL.MSGAMT,substr(TL.MSGACCT,1,10) MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOG TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf, VW_DFMAST_ALL DF
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
    AND  TLPR1.TLID =TL.TLID  AND TLPR2.TLID =TL.OFFID
    and af.acctno(+)= DF.AFACCTNO
    AND DF.LNACCTNO = TL.MSGACCT
    and cf.custid (+)= af.custid
    and tl.txdate between to_date(F_DATE,'DD/MM/YYYY' ) and to_date(T_DATE,'DD/MM/YYYY' )
    AND nvl(TL.tlID,'-') LIKE V_STRMAKER
    AND nvl(TL.offid,'-') LIKE V_STRCHECKER
    AND TL.tltxcd LIKE V_STRTLTXCD
    And Tl.Deltd <>'Y'
    and TL.tltxcd IN  ('5573')
    --and nvl(cf.custodycd,'-') <>'017P000002'
    and nvl(cf.custodycd,'-') not like '022P%'
    and cf.custodycd like V_STRCUSTOCYCD*/
/*UNION ALL
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,TL.MSGAMT,substr(TL.MSGACCT,1,10) MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM TLLOGALL TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf, VW_DFMAST_ALL DF
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
    AND  TLPR1.TLID =TL.TLID  AND TLPR2.TLID =TL.OFFID
    and af.acctno(+)= DF.AFACCTNO
    AND DF.LNACCTNO = TL.MSGACCT
    and cf.custid (+)= af.custid
    and tl.txdate between to_date(F_DATE,'DD/MM/YYYY' ) and to_date(T_DATE,'DD/MM/YYYY' )
    AND nvl(TL.tlID,'-') LIKE V_STRMAKER
    AND nvl(TL.offid,'-') LIKE V_STRCHECKER
    AND TL.tltxcd LIKE V_STRTLTXCD
    And Tl.Deltd <>'Y'
    and TL.tltxcd IN  ('5573')
    --and nvl(cf.custodycd,'-') <>'017P000002'
    and nvl(cf.custodycd,'-') not like '022P%'
    and cf.custodycd like V_STRCUSTOCYCD
 -- End, Sinh added (1-nov-2010)*/


union all
SELECT cf.custodycd,TL.TLTXCD ,TL.TXNUM,TL.TXDATE,TL.BUSDATE ,
CASE WHEN TL.TXTIME IS NULL THEN TL.OFFTIME ELSE TL.TXTIME END TXTIME,TL.OFFTIME,
TL.MSGAMT, od.afacctno MSGACCT, to_char(TL.TXDESC) txdesc ,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,AL.CDCONTENT STATUS
FROM VW_TLLOG_ALL TL,ALLCODE AL ,TLPROFILES TLPR1 ,TLPROFILES TLPR2,afmast af, cfmast cf,
    (select * from vw_odmast_all where txdate <= to_date(T_DATE,'DD/MM/YYYY' ) and txdate >= to_date(F_DATE,'DD/MM/YYYY' )) od
WHERE AL.CDTYPE ='SY' AND AL.CDNAME ='TXSTATUS' AND AL.CDVAL =TL.TXSTATUS
AND  TLPR1.TLID(+) =TL.TLID  AND TLPR2.TLID (+)=TL.OFFID
and (af.acctno = substr(TL.MSGACCT,1,10) or od.orderid = TL.MSGACCT)
and af.acctno = od.afacctno
and cf.custid = af.custid
and tl.txdate <= to_date(T_DATE,'DD/MM/YYYY' )
and tl.txdate >= to_date(F_DATE,'DD/MM/YYYY' )
AND nvl(TL.tlID,'-') LIKE V_STRMAKER
AND nvl(TL.offid,'-') LIKE V_STRCHECKER
AND TL.tltxcd LIKE V_STRTLTXCD
And Tl.Deltd <>'Y'
and TL.tltxcd in ('8829')
--and nvl(cf.custodycd,'-')<>'017P000002'
and nvl(cf.custodycd,'-') not like '022P%'
and cf.custodycd like V_STRCUSTOCYCD

)ORDER BY TLTXCD, BUSDATE, TXNUM, MAKER
;

EXCEPTION
   WHEN OTHERS
   THEN
    plog.error ('SA0004: ' || SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
End;
/
