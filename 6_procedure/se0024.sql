SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0024(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   TYPEDATE         IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   CUSTODYCD        IN       VARCHAR2,
   AFACCTNO         IN       VARCHAR2,
   TLTXCD           IN       VARCHAR2,
   SYMBOL           IN       VARCHAR2,
   AFTYPE           IN       VARCHAR2,
   BAL_TYPE           IN       VARCHAR2
        )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
-- BAO CAO DANH SACH GIAO DICH LUU KY
-- Purpose: Briefly explain the functionality of the procedure
-- DANH SACH GIAO DICH LUU KY
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- DUNGNH   14-SEP-09  MODIFIED
-- NAM.LY   16-DEC-09  MODIFIED
-- ---------   ------  -------------------------------------------

    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
    V_STRTLTXCD         VARCHAR (900);
    V_STRTLTXCD_1       VARCHAR (900);
    V_STRTLTXCD_2       VARCHAR (900);
    V_STRTLTXCD_3       VARCHAR (900);
    V_STRSYMBOL         VARCHAR (20);
    V_STRTYPEDATE       VARCHAR(5);
    V_STRCUSTODYCD      VARCHAR(20);
    V_STRAFACCTNO       VARCHAR(20);
    V_AFTYPE            VARCHAR(20);
    V_CMD               VARCHAR (2000);
    V_CMD_1             VARCHAR (2000);
    V_CMD_2             VARCHAR (2000);
    V_CMD_3             VARCHAR (2000);
    V_WHERE             VARCHAR (2000);
    V_WHERE_1           VARCHAR (2000);
    V_WHERE_2           VARCHAR (2000);
    V_WHERE_3           VARCHAR (2000);
    v_FromDate          DATE;
    v_ToDate            DATE;
    v_List_tltxcd       VARCHAR (2000);
    v_List_tltxcd_Trade VARCHAR (2000);
   -- Declare program variables as shown above
BEGIN
    -- GET REPORT'S PARAMETERS
    v_FromDate               :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate                 :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_STROPTION := upper(OPT);
    V_STRBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            --select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
            V_STRBRID := substr(BRID,1,2) || '__' ;
        else
            V_STRBRID := BRID;
        end if;
    end if;
--
   IF(TYPEDATE <> 'ALL') THEN
        V_STRTYPEDATE := TYPEDATE;
   ELSE
        V_STRTYPEDATE := '003';
   END IF;
-- GET LIST tltxcd
   SELECT  LISTAGG(' '||TLTXCD) WITHIN GROUP(ORDER BY TLTXCD) INTO v_List_tltxcd
   FROM (
           SELECT RS.*
            FROM (
                    SELECT TMP.*, (
                                    DECODE(BLOCKWITHDRAW,NULL,0,1) +
                                    DECODE(BLOCKDTOCLOSE,NULL,0,1) +
                                    DECODE(RECEIVINGOD,NULL,0,1) +
                                    DECODE(EXTRANFER,NULL,0,1) +
                                    DECODE(BLOCKTRANFER,NULL,0,1) +
                                    DECODE(HOLD,NULL,0,1) +
                                    DECODE(COSTPRICE,NULL,0,1) +
                                    DECODE(TRADE,NULL,0,1) +
                                    DECODE(MORTAGE,NULL,0,1) +
                                    DECODE(MARGIN,NULL,0,1) +
                                    DECODE(NETTING,NULL,0,1) +
                                    DECODE(STANDING,NULL,0,1) +
                                    DECODE(WITHDRAW,NULL,0,1) +
                                    DECODE(DEPOSIT,NULL,0,1) +
                                    DECODE(LOAN,NULL,0,1) +
                                    DECODE(BLOCKED,NULL,0,1) +
                                    DECODE(RECEIVING,NULL,0,1) +
                                    DECODE(TRANSFER,NULL,0,1) +
                                    DECODE(PREVQTTY,NULL,0,1) +
                                    DECODE(DCRQTTY,NULL,0,1) +
                                    DECODE(DCRAMT,NULL,0,1) +
                                    DECODE(DEPOFEEACR,NULL,0,1) +
                                    DECODE(REPO,NULL,0,1) +
                                    DECODE(PENDING,NULL,0,1) +
                                    DECODE(TBALDEPO,NULL,0,1) +
                                    DECODE(SECURED,NULL,0,1) +
                                    DECODE(SENDDEPOSIT,NULL,0,1) +
                                    DECODE(SENDPENDING,NULL,0,1) +
                                    DECODE(DDROUTQTTY,NULL,0,1) +
                                    DECODE(DDROUTAMT,NULL,0,1) +
                                    DECODE(DTOCLOSE,NULL,0,1) +
                                    DECODE(SDTOCLOSE,NULL,0,1) +
                                    DECODE(QTTY_TRANSFER,NULL,0,1) +
                                    DECODE(DEALINTPAID,NULL,0,1) +
                                    DECODE(WTRADE,NULL,0,1) +
                                    DECODE(GRPORDAMT,NULL,0,1) +
                                    DECODE(EMKQTTY,NULL,0,1)
                                    ) TOTAL
                    FROM (
                            SELECT DISTINCT TLTXCD, TXTYPE, FIELD
                            FROM VW_SETRAN_GEN
                            WHERE FIELD IN (
                                            'BLOCKWITHDRAW',
                                            'BLOCKDTOCLOSE',
                                            'RECEIVINGOD',
                                            'EXTRANFER',
                                            'BLOCKTRANFER',
                                            'HOLD',
                                            'COSTPRICE',
                                            'TRADE',
                                            'MORTAGE',
                                            'MARGIN',
                                            'NETTING',
                                            'STANDING',
                                            'WITHDRAW',
                                            'DEPOSIT',
                                            'LOAN',
                                            'BLOCKED',
                                            'RECEIVING',
                                            'TRANSFER',
                                            'PREVQTTY',
                                            'DCRQTTY',
                                            'DCRAMT',
                                            'DEPOFEEACR',
                                            'REPO',
                                            'PENDING',
                                            'TBALDEPO',
                                            'SECURED',
                                            'SENDDEPOSIT',
                                            'SENDPENDING',
                                            'DDROUTQTTY',
                                            'DDROUTAMT',
                                            'DTOCLOSE',
                                            'SDTOCLOSE',
                                            'QTTY_TRANSFER',
                                            'DEALINTPAID',
                                            'WTRADE',
                                            'GRPORDAMT',
                                            'EMKQTTY'
                                            )
                            GROUP BY TLTXCD, TXTYPE, FIELD
                            ORDER BY TLTXCD, TXTYPE, FIELD
                          )
                   PIVOT (
                          MAX(TXTYPE)
                          FOR FIELD IN (
                                        'BLOCKWITHDRAW' BLOCKWITHDRAW,
                                        'BLOCKDTOCLOSE' BLOCKDTOCLOSE,
                                        'RECEIVINGOD' RECEIVINGOD,
                                        'EXTRANFER' EXTRANFER,
                                        'BLOCKTRANFER' BLOCKTRANFER,
                                        'HOLD' HOLD,
                                        'COSTPRICE' COSTPRICE,
                                        'TRADE' TRADE,
                                        'MORTAGE' MORTAGE,
                                        'MARGIN' MARGIN,
                                        'NETTING' NETTING,
                                        'STANDING' STANDING,
                                        'WITHDRAW' WITHDRAW,
                                        'DEPOSIT' DEPOSIT,
                                        'LOAN' LOAN,
                                        'BLOCKED' BLOCKED,
                                        'RECEIVING' RECEIVING,
                                        'TRANSFER' TRANSFER,
                                        'PREVQTTY' PREVQTTY,
                                        'DCRQTTY' DCRQTTY,
                                        'DCRAMT' DCRAMT,
                                        'DEPOFEEACR' DEPOFEEACR,
                                        'REPO' REPO,
                                        'PENDING' PENDING,
                                        'TBALDEPO' TBALDEPO,
                                        'SECURED' SECURED,
                                        'SENDDEPOSIT' SENDDEPOSIT,
                                        'SENDPENDING' SENDPENDING,
                                        'DDROUTQTTY' DDROUTQTTY,
                                        'DDROUTAMT' DDROUTAMT,
                                        'DTOCLOSE' DTOCLOSE,
                                        'SDTOCLOSE' SDTOCLOSE,
                                        'QTTY_TRANSFER' QTTY_TRANSFER,
                                        'DEALINTPAID' DEALINTPAID,
                                        'WTRADE' WTRADE,
                                        'GRPORDAMT' GRPORDAMT,
                                        'EMKQTTY' EMKQTTY
                                       )
                         ) TMP
                 ORDER BY TLTXCD
                ) RS
            WHERE (RS.TRADE = 'C' OR RS.BLOCKED = 'C')
                  OR
                  (RS.TOTAL = 1 AND (RS.TRADE = 'D' OR RS.BLOCKED = 'D' OR RS.WITHDRAW = 'D' OR RS.BLOCKWITHDRAW = 'D' OR RS.NETTING = 'D' OR RS.DTOCLOSE = 'D'))
        );
-- GET LIST tltxcd RELATE TO TRADE
   SELECT  LISTAGG(' '||TLTXCD) WITHIN GROUP(ORDER BY TLTXCD) INTO v_List_tltxcd_Trade
   FROM (
            SELECT RS.*
            FROM (
                    SELECT TMP.*, DECODE(TRADE,NULL,0,1) + DECODE(BLOCKED,NULL,0,1) + DECODE(WITHDRAW,NULL,0,1) + DECODE(BLOCKWITHDRAW,NULL,0,1) + DECODE(NETTING,NULL,0,1)
                                 +DECODE(DTOCLOSE,NULL,0,1) + DECODE(RECEIVING,NULL,0,1) + DECODE(DEPOSIT,NULL,0,1) TOTAL
                    FROM (
                            SELECT DISTINCT TLTXCD, TXTYPE, FIELD
                            FROM VW_SETRAN_GEN
                            WHERE FIELD IN ('TRADE','BLOCKED','WITHDRAW','BLOCKWITHDRAW','NETTING','DTOCLOSE','RECEIVING','DEPOSIT')
                            GROUP BY TLTXCD, TXTYPE, FIELD
                            ORDER BY TLTXCD, TXTYPE, FIELD
                          )
                   PIVOT (
                          MAX(TXTYPE)
                          FOR FIELD IN (
                                        'TRADE' TRADE,
                                        'BLOCKED' BLOCKED,
                                        'WITHDRAW' WITHDRAW,
                                        'BLOCKWITHDRAW' BLOCKWITHDRAW,
                                        'NETTING' NETTING,
                                        'DTOCLOSE' DTOCLOSE,
                                        'RECEIVING' RECEIVING,
                                        'DEPOSIT' DEPOSIT
                                       )
                         ) TMP
                 ORDER BY TLTXCD
                ) RS
            WHERE (RS.TOTAL = 2 AND ((RS.TRADE = 'C' AND RS.RECEIVING = 'D') OR (RS.TRADE = 'C' AND RS.DEPOSIT = 'D')))
        );
--
   V_CMD := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol,
                --TLG.txdesc,
                decode(substr(TLG.txnum,1,2),''68'', TLG.txdesc || '' (Online)'',
                                                         ''69'',TLG.txdesc || '' (Home)'',
                                                         ''70'',TLG.txdesc || '' (Mobile)'',TLG.txdesc) txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.tltxcd = ''2248'' AND TLG.ref = ''002'' AND TLG.field = ''BLOCKED'' THEN ''HCCN''
                WHEN TLG.tltxcd = ''2248'' AND TLG.ref <> ''002'' AND TLG.field = ''BLOCKED'' THEN ''TU DO''
                WHEN TLG.tltxcd = ''2266'' AND TLG.ref = ''002'' AND TLG.field = ''WITHDRAW'' THEN ''HCCN''
                WHEN TLG.field = ''BLOCKED'' THEN ''HCCN''
                ELSE ''TU DO''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_CMD_1 := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol,
                --TLG.txdesc,
                decode(substr(TLG.txnum,1,2),''68'', TLG.txdesc || '' (Online)'',
                                                         ''69'',TLG.txdesc || '' (Home)'',
                                                         ''70'',TLG.txdesc || '' (Mobile)'',TLG.txdesc) txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.field = ''BLOCKED'' THEN ''HCCN''
                ELSE ''TU DO''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_CMD_2 := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol,
                --TLG.txdesc,
                decode(substr(TLG.txnum,1,2),''68'', TLG.txdesc || '' (Online)'',
                                                         ''69'',TLG.txdesc || '' (Home)'',
                                                         ''70'',TLG.txdesc || '' (Mobile)'',TLG.txdesc) txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.field = ''STANDING'' THEN ''CC''
                ELSE ''TU DO''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_CMD_3 := 'SELECT TLG.busdate, TLG.custodycd, SUBSTR(TLG.acctno, 1, 10) acctno, TLG.symbol,
                --TLG.txdesc,
                decode(substr(TLG.txnum,1,2),''68'', TLG.txdesc || '' (Online)'',
                                                         ''69'',TLG.txdesc || '' (Home)'',
                                                         ''70'',TLG.txdesc || '' (Mobile)'',TLG.txdesc) txdesc,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''D'', TLG.NAMT, 0), DECODE(TLG.txtype, ''C'', TLG.NAMT, 0)) PS_TANG,
            DECODE(TLG.field, ''STANDING'', DECODE(TLG.txtype, ''C'', TLG.NAMT, 0), DECODE(TLG.txtype, ''D'', TLG.NAMT, 0)) PS_GIAM,
            (CASE WHEN TLG.field = ''BLOCKED'' THEN ''CC''
                ELSE ''TU DO''
             END) field,
            TLG.tltxcd, SB.parvalue
        FROM vw_setran_gen TLG
        LEFT OUTER JOIN sbsecurities SB ON Sb.codeid = TLG.codeid';
   V_WHERE := ' where TLG.tltxcd <> ''2213'' AND TLG.busdate >= TO_DATE (''' || F_DATE || '''  ,''DD/MM/YYYY'')
            AND TLG.busdate <= TO_DATE (''' || T_DATE  || ''',''DD/MM/YYYY'')
            AND substr(TLG.acctno,1, 4) LIKE ''' || V_STRBRID || '''';
--
   IF(CUSTODYCD <> 'ALL') THEN
        V_WHERE := V_WHERE || ' AND TLG.CUSTODYCD = ''' || CUSTODYCD || '''' ;
   END IF;
--
   IF(AFACCTNO <> 'ALL') THEN
        V_WHERE := V_WHERE || ' AND TLG.ACCTNO = ''' || AFACCTNO || '''' ;
   END IF;
--
   IF  (SYMBOL <> 'ALL') THEN
      V_WHERE := V_WHERE || ' AND TLG.SYMBOL = ''' || replace (trim(SYMBOL),' ','_') || '''' ;
   END IF;
--
   IF(AFTYPE <> 'ALL') THEN
        V_AFTYPE  := AFTYPE;
   ELSE
        V_AFTYPE  := 'B F A';
   END IF;
--

   V_WHERE := V_WHERE || ' AND INSTR(''' || V_AFTYPE || '''' || ', substr(TLG.custodycd, 4, 1)) > 0' ;
   V_WHERE_1 := V_WHERE;
   V_WHERE_2 := V_WHERE;
   V_WHERE_3 := V_WHERE;
--
   V_WHERE := V_WHERE || ' AND TLG.FIELD IN(''TRADE'',''MORTAGE'',''BLOCKED'',''NETTING'',''STANDING'',''WITHDRAW'',''DTOCLOSE'')' ;
   V_WHERE_1 := V_WHERE;
   V_WHERE_2 := V_WHERE_2 || ' AND TLG.FIELD IN(''BLOCKED'',''STANDING'')' ;
   V_WHERE_3 := V_WHERE_3 || ' AND TLG.FIELD IN(''BLOCKED'',''TRADE'')' ;
--
   IF BAL_TYPE = 'ALL' THEN

       IF (TLTXCD <> 'ALL') THEN
            --if instr('8866 8868 2246 2245 2266 3351 2248 8879 2201 2205'||v_List_tltxcd, tltxcd) > 0 THEN
            if instr('8866 8868 2246 2266 2248 8879 2201 2205'||v_List_tltxcd, tltxcd) > 0 then
               V_WHERE := V_WHERE || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD || V_WHERE || ') B, AFMAST A WHERE A.ACCTNO = B.ACCTNO  ORDER BY B.busdate';
            elsif instr('2202 2203',tltxcd ) >0 then
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.REF = ''002''';
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD_1 || V_WHERE_1 || ') B, AFMAST A WHERE A.ACCTNO = B.ACCTNO   ORDER BY B.busdate';
            elsif instr('2251',tltxcd ) >0 then
               V_WHERE_2 := V_WHERE_2 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD_2 || V_WHERE_2 || ') B, AFMAST A WHERE A.ACCTNO = B.ACCTNO   ORDER BY B.busdate';
            elsif instr('2253',tltxcd ) >0 then
               V_WHERE_3 := V_WHERE_3 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD_3 || V_WHERE_3 || ') B, AFMAST A WHERE A.ACCTNO = B.ACCTNO   ORDER BY B.busdate';
            end if;
       ELSE
            --V_STRTLTXCD := '8866 8868 2246 2245 2266 3351 2248 8879 2201 2205'||v_List_tltxcd;
            V_STRTLTXCD := '8866 8868 2246 2266 2248 8879 2201 2205'||v_List_tltxcd;
            V_STRTLTXCD_1:= '2202 2203';
            V_STRTLTXCD_2:= '2251';
            V_STRTLTXCD_3:= '2253';
--
           V_WHERE := V_WHERE || ' AND INSTR(''' || V_STRTLTXCD || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_1 := V_WHERE_1 || ' AND INSTR(''' || V_STRTLTXCD_1 || '''' || ', TLG.TLTXCD) > 0' || ' AND TLG.REF = ''002''';
           V_WHERE_2 := V_WHERE_2 || ' AND INSTR(''' || V_STRTLTXCD_2 || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_3 := V_WHERE_3 || ' AND INSTR(''' || V_STRTLTXCD_3 || '''' || ', TLG.TLTXCD) > 0' ;

           OPEN PV_REFCURSOR FOR 'SELECT B.* FROM ( ' || V_CMD || V_WHERE
                || ' UNION ALL ' || V_CMD_1 || V_WHERE_1
                || ' UNION ALL ' || V_CMD_2 || V_WHERE_2
                || ' UNION ALL ' || V_CMD_3 || V_WHERE_3 || ') B, AFMAST A WHERE A.ACCTNO = B.ACCTNO   ORDER BY B.busdate';
              
       END IF;
   ELSE
       IF (TLTXCD <> 'ALL')
       THEN
            --if instr('8866 8868 2246 2245 2266 3351 2248 8879 2201 2205'||v_List_tltxcd, tltxcd) > 0 then
            if instr('8866 8868 2246 2266 2248 8879 2201 2205'||v_List_tltxcd, tltxcd) > 0 then
               V_WHERE := V_WHERE || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD || V_WHERE || ') B ) C,
                    AFMAST A WHERE A.ACCTNO = C.ACCTNO  AND C.field = ''' || BAL_TYPE || ''' ORDER BY C.busdate';
            elsif instr('2202 2203',tltxcd ) >0 then
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               V_WHERE_1 := V_WHERE_1 || ' AND TLG.REF = ''002''';
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD_1 || V_WHERE_1 || ') B ) C
                    ,AFMAST A WHERE A.ACCTNO = C.ACCTNO  AND C.field = ''' || BAL_TYPE || ''' ORDER BY C.busdate';
            elsif instr('2251',tltxcd ) >0 then
               V_WHERE_2 := V_WHERE_2 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD_2 || V_WHERE_2 || ') B ) C
                     ,AFMAST A WHERE A.ACCTNO = C.ACCTNO  AND C.field = ''' || BAL_TYPE || ''' ORDER BY C.busdate';
            elsif instr('2253',tltxcd ) >0 then
               V_WHERE_3 := V_WHERE_3 || ' AND TLG.TLTXCD = ''' || TLTXCD || '''' ;
               OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD_3 || V_WHERE_3 || ') B ) C
                     ,AFMAST A WHERE A.ACCTNO = C.ACCTNO  AND C.field = ''' || BAL_TYPE || ''' ORDER BY C.busdate';
            end if;
       ELSE
            --V_STRTLTXCD := '8866 8868 2246 2245 2266 3351 2248 8879 2201 2205'||v_List_tltxcd;
            V_STRTLTXCD := '8866 8868 2246 2266 2248 8879 2201 2205'||v_List_tltxcd;
            V_STRTLTXCD_1:= '2202 2203';
            V_STRTLTXCD_2:= '2251';
            V_STRTLTXCD_3:= '2253';
--
           V_WHERE := V_WHERE || ' AND INSTR(''' || V_STRTLTXCD || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_1 := V_WHERE_1 || ' AND INSTR(''' || V_STRTLTXCD_1 || '''' || ', TLG.TLTXCD) > 0' || ' AND TLG.REF = ''002''';
           V_WHERE_2 := V_WHERE_2 || ' AND INSTR(''' || V_STRTLTXCD_2 || '''' || ', TLG.TLTXCD) > 0' ;
           V_WHERE_3 := V_WHERE_3 || ' AND INSTR(''' || V_STRTLTXCD_3 || '''' || ', TLG.TLTXCD) > 0' ;
--
           dbms_output.put_line('V_CMD_1:' || V_CMD_1);
           dbms_output.put_line('V_CMD_2:' || V_CMD_2);
           dbms_output.put_line('V_CMD_3:' || V_CMD_3);
--
           OPEN PV_REFCURSOR FOR 'SELECT C.* FROM (SELECT B.* FROM ( ' || V_CMD || V_WHERE
                || ' UNION ALL ' || V_CMD_1 || V_WHERE_1
                || ' UNION ALL ' || V_CMD_2 || V_WHERE_2
                || ' UNION ALL ' || V_CMD_3 || V_WHERE_3 || ') B ) C
                     ,AFMAST A WHERE A.ACCTNO = C.ACCTNO  AND C.field = ''' || BAL_TYPE || ''' ORDER BY C.busdate';
       END IF;
   END IF;

EXCEPTION
    WHEN OTHERS
   THEN
        dbms_output.put_line('Err V_CMD_1:' || V_CMD_1);
        dbms_output.put_line('Err V_CMD_2:' || V_CMD_2);
        dbms_output.put_line('Err V_CMD_3:' || V_CMD_3);
      RETURN;
END; -- Procedure
/
