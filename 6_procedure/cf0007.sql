SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0007(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_DATE       IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   PV_CUSTODYCD IN VARCHAR2,
                                   PV_AFACCTNO  IN VARCHAR2,
                                   AAUTHID      IN VARCHAR2,
                                   TLID         IN VARCHAR2) IS
  --
  -- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
  --
  -- MODIFICATION HISTORY
  -- PERSON      DATE       COMMENTS
  -- Diennt      30/09/2011 Create
  -- ---------   ------     -------------------------------------------
  V_STROPTION VARCHAR2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH

  -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
  V_STRPV_CUSTODYCD VARCHAR2(20);
  V_STRPV_AFACCTNO  VARCHAR2(20);
  V_INBRID          VARCHAR2(4);
  V_STRBRID         VARCHAR2(50);
  V_STRTLID         VARCHAR2(6);
  V_AAUTHID         VARCHAR2(20);
BEGIN

  V_STROPTION := OPT;

  IF (V_STROPTION <> 'A') AND (BRID <> 'ALL') THEN
    V_STRBRID := BRID;
  ELSE
    V_STRBRID := '%%';
  END IF;

  --   V_STRTLID:=TLID;
  IF (TLID <> 'ALL' AND TLID IS NOT NULL) THEN
    V_STRTLID := TLID;
  ELSE
    V_STRTLID := 'ZZZZZZZZZ';
  END IF;

  V_STROPTION := UPPER(OPT);
  V_INBRID    := BRID;
  /*  if(V_STROPTION = 'A') then
      V_STRBRID := '%%';
  else
      if(V_STROPTION = 'B') then
          select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
      else
          V_STRBRID := V_INBRID;
      end if;
  end if;*/

  /* IF (V_INBRID  <> 'ALL')
  THEN
     V_STRBRID  := V_INBRID;
  ELSE
     V_STRBRID := '%%';
  END IF;*/

  IF (UPPER(PV_CUSTODYCD) <> 'ALL') THEN
    V_STRPV_CUSTODYCD := UPPER(PV_CUSTODYCD);
  ELSE
    V_STRPV_CUSTODYCD := '%%';
  END IF;

  IF (UPPER(PV_AFACCTNO) <> 'ALL') THEN
    V_STRPV_AFACCTNO := UPPER(PV_AFACCTNO);
  ELSE
    V_STRPV_AFACCTNO := '%%';
  END IF;
  --- AAUTHID User excute ---
  IF (UPPER(AAUTHID) <> 'ALL') THEN
    V_AAUTHID := UPPER(AAUTHID);
  ELSE
    V_AAUTHID := '%%';
  END IF;
  OPEN PV_REFCURSOR FOR

    SELECT *
      FROM ( /*SELECT  action_flag, cf.custodycd, af.acctno ,'AFMAST' ID,tl1.tlfullname maker_id, to_date(ma.maker_dt,'dd/mm/yyyy') maker_dt,
                                 tl2.tlfullname approve_id,ma.approve_dt, caption column_name, from_value, to_value
                          FROM maintain_log ma, afmast af,tlprofiles tl1,tlprofiles tl2,fldmaster FLD ,cfmast cf
                          WHERE
                                ma.table_name='AFMAST'
                            and ma.action_flag='EDIT'
                            and af.acctno=substr(trim(ma.record_key),11,10)
                            and tl1.tlid(+)=ma.maker_id
                            and tl2.tlid(+)=ma.approve_id
                            AND FLD.fldname = ma.column_name
                            AND FLD.objname ='CF.AFMAST'
                            and af.custid = cf.custid
                            AND ma.maker_dt <= to_date(T_DATE,'DD/MM/YYYY' )
                            AND ma.maker_dt >= to_date(F_DATE,'DD/MM/YYYY' )
                            AND AF.ACCTNO LIKE V_STRPV_AFACCTNO
                            and cf.custodycd like V_STRPV_CUSTODYCD
                            AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
                            and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
                        --  ORDER BY ma.approve_dt
                        --  )
                            --order by af.acctno
                          UNION ALL*/
            --  SELECT * FROM
            --  (
            SELECT DISTINCT ACTION_FLAG,
                             CF.CUSTODYCD,
                             'CFMAST' ID,
                             TL1.TLNAME MAKER_ID,
                             TO_CHAR(MA.MAKER_DT, 'DD/MM/YYYY') MAKER_DT,
                             TL2.TLNAME APPROVE_ID,
                             MA.APPROVE_DT,
                             CAPTION COLUMN_NAME,
                             FROM_VALUE,
                             TO_VALUE
              FROM MAINTAIN_LOG MA,
                    CFMAST       CF,
                    TLPROFILES   TL1,
                    TLPROFILES   TL2,
                    FLDMASTER    FLD,
                    AFMAST       AF
             WHERE MA.TABLE_NAME = 'CFMAST'
               AND MA.ACTION_FLAG = 'EDIT'
               AND CF.CUSTID = SUBSTR(TRIM(MA.RECORD_KEY), 11, 10)
               AND TL1.TLID(+) = MA.MAKER_ID
               AND TL2.TLID(+) = MA.APPROVE_ID
               AND FLD.FLDNAME = MA.COLUMN_NAME
                  ---    AND FLD.objname ='CF.CFMAST'
               AND FLD.OBJNAME LIKE CASE
                     WHEN LENGTH(CHILD_TABLE_NAME) > 0 THEN
                      '%' || CHILD_TABLE_NAME || '%'
                     ELSE
                      '%CFMAST%'
                   END
               AND MA.MAKER_DT <= TO_DATE(T_DATE, 'DD/MM/YYYY')
               AND MA.MAKER_DT >= TO_DATE(F_DATE, 'DD/MM/YYYY')
               AND AF.CUSTID = CF.CUSTID
               AND NOT (FLD.FLDNAME = 'EXPERIENCECD' AND
                    FLD.OBJNAME = 'CF.CFMAST')
               AND MA.COLUMN_NAME not in ('MRSRATIO')  --20170222 DieuNDA: An di truong nay vi trong HT k su dung
               AND AF.ACCTNO LIKE V_STRPV_AFACCTNO
               AND CF.CUSTODYCD LIKE V_STRPV_CUSTODYCD
               AND (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID, AF.BRID) <> 0)
                  -- Them tieu chi tim kiem nguoi thuc hien 26/04/2015 --
               AND TL1.TLID LIKE V_AAUTHID
               AND EXISTS (SELECT GU.GRPID
                      FROM TLGRPUSERS GU
                     WHERE AF.CAREBY = GU.GRPID
                       AND GU.TLID = V_STRTLID)
            --    ORDER BY ma.approve_dt
            )
     ORDER BY ID, APPROVE_DT
    --order by cf.custid
    ;

EXCEPTION
  WHEN OTHERS THEN

    RETURN;
END;
 
 
/
