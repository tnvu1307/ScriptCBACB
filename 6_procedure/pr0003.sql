SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PR0003 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE        IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   ROOMTYPE         IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO CHENH LECH ROOM
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DIEUNDA   10-NOV-14  CREATED
-- ---------   ------  -------------------------------------------
    V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID            VARCHAR2 (4);
    V_ROOMTYPE           VARCHAR2 (5);
    V_SYMBOL           VARCHAR2 (20);


BEGIN
   V_STROPTION := OPT;
   V_SYMBOL:=UPPER(SYMBOL);

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF(UPPER(ROOMTYPE) <> 'ALL')
   THEN
        V_ROOMTYPE := UPPER(ROOMTYPE);
   ELSE
        V_ROOMTYPE := '%';
   END IF;

   IF(UPPER(SYMBOL) <> 'ALL')
   THEN
        V_SYMBOL := UPPER(SYMBOL);
   ELSE
        V_SYMBOL := '%';
   END IF;

OPEN PV_REFCURSOR FOR

SELECT I_DATE IDATE, ROWNUM No, PRCODE,SYMBOL,  ROOMLIMIT, LISTINGQTTY, ROOMTYPE, TYPNAME, LISTINGQTTY-ROOMLIMIT DISPARITY
FROM(
    select * from
        (SELECT '' PRCODE, se.SYMBOL, se.ROOMLIMIT ROOMLIMIT,
            case when se.LISTINGQTTY*sy.varvalue/100<=round(se.LISTINGQTTY*sy.varvalue/100) then round(se.LISTINGQTTY*sy.varvalue/100) else round(se.LISTINGQTTY*sy.varvalue/100)+1 end   LISTINGQTTY,'SCR' ROOMTYPE ,a0.cdcontent TYPNAME
        FROM  securities_info se, allcode a0,(select *  from sysvar where grname='MARGIN' and varname ='MAXDEBTQTTYRATE') sy
        where  a0.cdval='SCR' and cdname='ROOMTYP' and cdtype='SA')
        union all
        (SELECT '' PRCODE, se.SYMBOL, se.SYROOMLIMIT ROOMLIMIT,
            case when se.LISTINGQTTY*sy.varvalue/100<=round(se.LISTINGQTTY*sy.varvalue/100) then round(se.LISTINGQTTY*sy.varvalue/100) else round(se.LISTINGQTTY*sy.varvalue/100)+1 end LISTINGQTTY,'SYR' ROOMTYPE , a0.cdcontent TYPNAME
        FROM  securities_info se, allcode a0,(select *  from sysvar where grname='MARGIN' and varname ='MAXDEBTQTTYRATE') sy
        where  a0.cdval='SYR' and cdname='ROOMTYP' and cdtype='SA')
        union all
        (SELECT MST.PRCODE, SB.SYMBOL, PRSE.ROOMLIMIT,
            case when sb.LISTINGQTTY*5/100<=round(sb.LISTINGQTTY*sy.varvalue/100) then round(sb.LISTINGQTTY*sy.varvalue/100) else round(SB.LISTINGQTTY*sy.varvalue/100)+1 end  LISTINGQTTY , 'SPR' ROOMTYPE, a0.cdcontent TYPNAME
        FROM PRMASTER MST, PRSECMAP PRSE, securities_info SB,  allcode a0,(select *  from sysvar where grname='MARGIN' and varname ='MAXDEBTQTTYRATE') sy
        WHERE MST.PRCODE=PRSE.prcode AND SB.SYMBOL=PRSE.SYMBOL and a0.cdval='SPR' and cdname='ROOMTYP' and cdtype='SA')
    ORDER BY  SYMBOL, PRCODE
)
WHERE ROOMLIMIT > LISTINGQTTY
AND  SYMBOL LIKE V_SYMBOL AND ROOMTYPE LIKE V_ROOMTYPE;

EXCEPTION
   WHEN OTHERS
   THEN
    plog.error('PR0003.' || sqlerrm || '.At:' || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
