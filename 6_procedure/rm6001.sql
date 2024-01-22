SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE rm6001 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2,
   T_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   PV_DDACCTNO            IN       VARCHAR2
   )
IS
    -- Import_tien_NHGS
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      04-03-2020           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate          DATE;
    v_ToDate            DATE;
    v_custodycd     VARCHAR2 (50);
    v_ddacctno      VARCHAR2 (50);
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
    --
    IF PV_CUSTODYCD = 'ALL' THEN
        v_custodycd:= '%';
    ELSE
        v_custodycd:= REPLACE(PV_CUSTODYCD,'.','');
    END IF;
    IF PV_DDACCTNO = 'ALL' THEN
        v_ddacctno:= '%';
    ELSE
        v_ddacctno:= PV_DDACCTNO;
    END IF;
    v_FromDate      :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate        :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    --
OPEN PV_REFCURSOR FOR
    SELECT DD.REFCASAACCT ACCTNO --SO TAI KHOAN NGAN HANG
         , TLF.CVALUE TXNUM
         , TO_CHAR(DT.BUSDATE,'DD/MM/RRRR') TXDATE
         , NVL(DT.NAMT,0) AMT
         , DT.TXDESC TRDESC
         , DT.TXTIME
    FROM VW_DDTRAN_GEN DT, DDMAST DD, CFMAST CF, VW_TLLOGFLD_ALL TLF
    WHERE DT.TLTXCD ='6645' AND
          DT.ACCTNO = DD.ACCTNO AND
          DD.CUSTID = CF.CUSTID AND
          CF.SUPEBANK ='Y' AND
          TLF.TXNUM = DT.TXNUM AND TLF.TXDATE = DT.TXDATE AND TLF.FLDCD ='02' AND
          DT.BUSDATE BETWEEN v_FromDate AND v_ToDate
          AND CF.CUSTODYCD LIKE v_custodycd
          AND DD.REFCASAACCT LIKE v_ddacctno
    ORDER BY DT.BUSDATE, DT.AUTOID;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('RM6001: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
