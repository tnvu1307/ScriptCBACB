SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6021 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   PV_ISSUECODE     IN       VARCHAR2
)
IS

   V_BRID       VARCHAR2(4);
   V_STROPTION  VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID    VARCHAR2 (2000);           -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
   V_F_DATE     DATE;
   V_T_DATE     DATE;
   V_ISSUECODE     varchar2(20);
   v_COUNT      number;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   V_F_DATE := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   V_T_DATE := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   v_COUNT :=0;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    IF  (PV_ISSUECODE <> 'ALL') THEN
        V_ISSUECODE := PV_ISSUECODE;
    ELSE
        V_ISSUECODE  := '%';
    END IF;

OPEN PV_REFCURSOR FOR
        SELECT IH.ISSUECODE SYMBOL, IH.LTVRATE, IR.FULLNAME, IH.HISTDATE
        FROM ISSUES_HIST IH
        JOIN ISSUERS IR ON IH.ISSUERID = IR.ISSUERID
        WHERE IH.ISSUECODE LIKE V_ISSUECODE
              AND IH.HISTDATE >= V_F_DATE
              AND IH.HISTDATE <= V_T_DATE
        ORDER BY IH.HISTDATE;
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('BA6021 ERROR');
   
      RETURN;
END;
/
