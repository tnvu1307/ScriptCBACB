SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_ltvcal(p_templatesid varchar)
  IS
    l_count                     NUMBER(10,0);
    l_valueofissue              NUMBER(20,4); --tong gia tri phat hanh cua dot phat hanh
    l_ltv                       NUMBER(20,4);
    l_price                     NUMBER(20,4);
    l_date                      date;
    l_symbol                    varchar2(100);
    l_actype                    varchar2(10);
    l_sectype                   varchar2(10);
    l_valmethod                 varchar2(10);
    --
    l_next_scheduler_LTV        DATE;
    l_nextdate                  DATE;
    l_months                    NUMBER;
    l_emailSubject              varchar2(2000);
    c_max_ltv_template_EM17     CHAR(4) := 'EM17';
    c_warning_ltv_template_EM16 CHAR(4) := 'EM16';
    c_schd_ltv_template_EM18    CHAR(4) := 'EM18';
    --NAM.LY
    l_check                     NUMBER := 0;
    l_typerate                  VARCHAR2(3);  --loai nguyen tac dinh gia tai san dam bao
    l_type_pledged              VARCHAR2(15); --Loai tai san cam co
    l_sec_val_price             NUMBER(20,4); --Gia tri dinh gia cua chung khoan
    l_t_percent                 NUMBER(20,4); --T% cua tien gui/tien mat
    l_sec_qtty                  NUMBER;       --so luong chung khoan
    l_cash_amt                  NUMBER(20,4); --menh gia cua tien mat
    l_total_sec_amt             NUMBER(20,4); --tong gia tri cua tai sai cam co la chung khoan
    l_total_cashdepo_amt        NUMBER(20,4); --tong gia tri cua tien gui/tien mat
  BEGIN
    l_date:= to_date(getcurrdate);
    l_nextdate := TO_DATE(cspks_system.fn_get_sysvar('SYSTEM','NEXTDATE'), systemnums.C_DATE_FORMAT);

    --NAM.LY: 07/01/2020 THAY DOI RULE TINH LTV DO KHONG CON TINH THEO BONDCODE => TINH THEO ISSUESCODE(MA DOT PHAT HANH)
    /*   for rec in
        (
        SELECT sb.CODEID, sb.SYMBOL, sb.issuerid, sb.valueofissue, iss.fullname,  sb.typerate,
                sb.maxltvrate, sb.warningltvrate, sb.issuedate
        FROM SBSECURITIES sb, ISSUERS iss--, cfmast cf
             WHERE SECTYPE IN ('003', '006', '222')
             AND ROLEOFSHV IN ('002', '003', '004')
             AND sb.CONTRACTNO IS NOT NULL
             AND iss.issuerid = sb.issuerid
             AND sb.typerate IN ('002','003')
             )
    loop
      l_valueofissue := to_number(rec.valueofissue);
      l_amount := 0;
      FOR r in (
          SELECT SE.AFACCTNO afacctno, SE.ACCTNO acctno, CF.FULLNAME CUSTNAME, CF.CUSTODYCD, SB.SYMBOL,
                 SB.PARVALUE, mt.qtty qtty, SB.CODEID,
                 ba.issuerid, iss.Fullname ISSUERNAME, mt.bondcode, ba.symbol bondsymbol
                 from (
                     select se.acctno, se.afacctno, se.bondcode,
                            sum(case when se.tltxcd in ('2232') then se.qtty
                                     when se.tltxcd in ('2253') then -se.qtty else 0 end) qtty
                     from semortage se
                     where se.status IN ('C')
                     and se.bondcode is not null
                     group by se.acctno, se.afacctno,se.bondcode
                     UNION ALL
                     select se.acctno, se.afacctno, se.bondcode,
                            sum(case when se.tltxcd in ('1900') then se.qtty
                                     when se.tltxcd in ('1901') then -se.qtty else 0 end) qtty
                     from semortage se
                     where se.status IN ('C')
                     and se.bondcode is not null
                     group by se.acctno, se.afacctno,se.bondcode) mt,
                 semast se, sbsecurities sb, afmast af, cfmast cf, issuer_member iss, sbsecurities ba
                 WHERE mt.acctno = se.acctno and se.mortage > 0 and se.codeid = sb.codeid
                       and se.afacctno = af.acctno and af.custid = cf.custid and mt.qtty > 0
                       and iss.custid = cf.custid
                       and ba.codeid = mt.bondcode
                       and iss.issuerid = ba.issuerid
                       and mt.bondcode = rec.codeid)
      LOOP
        l_qtty := r.qtty;

        SELECT r.SYMBOL, bo.ACTYPE, bo.SECTYPE, bo.VALMETHOD into l_symbol, l_actype, l_sectype, l_valmethod
        FROM bondtype bo
        WHERE instr(bo.tickerlist, r.SYMBOL) > 0 and bo.BONDCODE = r.BONDCODE;

        l_price := nvl(fn_get_mortage_price(l_symbol, l_actype, l_sectype, l_valmethod),0);

        insert into BONDINFO (BONDCODE, TXDATE, BONDACTYPE, BONDPRICE, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE,PRICETYPE)
        values (r.bondcode, l_date,l_actype, l_price, r.codeid, null, null, null, l_symbol, null,l_valmethod);

        l_amount := l_amount + (l_qtty * l_price);
      END LOOP;
      IF NVL(l_amount, 0) <= 0 THEN
        CONTINUE;
      END IF;
      l_ltv := round(l_valueofissue*100/l_amount,4);

      UPDATE SECURITIES_INFO se set se.LTVRATE = l_ltv
      WHERE se.codeid = rec.codeid;
      */

     --NAM.LY: 07/01/2020 THAY DOI RULE TINH LTV DO KHONG CON TINH THEO BONDCODE => TINH THEO ISSUESCODE(MA DOT PHAT HANH)
     --==============================BEGIN OF [NAM.LY 09/01/2020]--------------------------------------------------------
        --LAY DANH SACH CAC DOT PHAT HANH
        FOR rec IN
        (
            SELECT ISS.AUTOID ISSUESID, ISS.ISSUECODE,ISS.ISSUERID, ISR.FULLNAME, ISS.ISSUEDATE,
               ISS.VALUEOFISSUE, ISS.LTVRATE, ISS.TYPERATE, ISS.MAXLTVRATE, ISS.WARNINGLTVRATE
            FROM ISSUES ISS, ISSUERS ISR
            WHERE ISR.ISSUERID = ISS.ISSUERID
         )
        LOOP
        l_valueofissue       := to_number(rec.VALUEOFISSUE);
        l_total_sec_amt      := 0;
        l_total_cashdepo_amt := 0;
        l_typerate           := rec.TYPERATE;

        --LAY THONG TIN TRAI PHIEU PHAT HANH VA CHUNG KHOAN/TIEN GUI/TIEN MAT CAM CO CUA DOT PHAT HANH
        FOR r IN (
                    SELECT ISS.AUTOID ISSUESID, SB.SYMBOL, SB.PARVALUE,
                           SB.CODEID, SB.SECTYPE, A1.CDCONTENT SECTYPE_NAME,
                           SUM(MT.QTTY) QTTY,
                           (CASE WHEN SB.SECTYPE IN ('014') THEN SUM(MT.AMT)
                                 WHEN SB.SECTYPE IN ('009','013') THEN SUM(MT.QTTY)*SB.PARVALUE
                                 ELSE 0
                            END) AMT,
                           (CASE WHEN SB.SECTYPE IN ('014') THEN 'CASH'
                                 WHEN SB.SECTYPE IN ('013') THEN 'CD'
                                 WHEN SB.SECTYPE IN ('009') THEN 'TERM_DEPOSIT'
                                 WHEN SB.SECTYPE IN ('003','006') THEN 'BOND'
                                 WHEN SB.SECTYPE IN ('001','008','011') THEN 'SHARE'
                            END) TYPE_PLEDGED,
                           ISS.ISSUECODE
                    FROM (
                            SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                                SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                         WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                            FROM SEMORTAGE SE
                            WHERE     SE.STATUS IN ('C')
                                  AND SE.DELTD <> 'Y'
                                  AND SE.ISSUESID IS NOT NULL
                            GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                            UNION ALL
                            SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                                SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                         WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                            FROM SEMORTAGE SE
                            WHERE     SE.STATUS IN ('C')
                                  AND SE.DELTD <> 'Y'
                                  AND SE.ISSUESID IS NOT NULL
                            GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                            UNION ALL
                            SELECT BL.CODEID, BL.ISSUESID, 0 QTTY,
                                SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                         WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                            FROM BLOCKAGE BL
                            WHERE     BL.DELTD <> 'Y'
                                  AND BL.ISSUESID IS NOT NULL
                            GROUP BY BL.CODEID,BL.ISSUESID
                         ) MT
                    JOIN SBSECURITIES SB ON MT.CODEID = SB.CODEID
                    JOIN ISSUES ISS ON MT.ISSUESID = ISS.AUTOID
                    JOIN ALLCODE A1 ON A1.CDVAL = SB.SECTYPE AND CDNAME ='SECTYPE' AND CDTYPE ='SA'
                    JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
                    WHERE NOT (MT.QTTY = 0 AND MT.AMT = 0)
                          AND MT.ISSUESID = REC.ISSUESID
                    GROUP BY ISS.AUTOID, SB.SYMBOL, SB.PARVALUE, SB.CODEID, SB.SECTYPE, A1.CDCONTENT, ISS.ISSUECODE
                )
        LOOP
        l_sec_qtty     := r.QTTY;
        l_cash_amt     := r.AMT;
        l_type_pledged := r.TYPE_PLEDGED;
        --LAY THONG TIN CUA CHUNG KHOAN CAM CO VA TRAI PHIEU PHAT HANH DE TINH DINH GIA TSDB
        BEGIN
            SELECT SYMBOL, ACTYPE, SECTYPE, VALMETHOD, COUNT(1)
            INTO l_symbol, l_actype, l_sectype, l_valmethod, l_check
            FROM (
                    SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD
                    FROM BONDTYPE BO
                    WHERE BO.ISSUESID = r.ISSUESID
                    CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
                 )
            WHERE SYMBOL = r.SYMBOL
            GROUP BY SYMBOL, ACTYPE, SECTYPE, VALMETHOD;
            EXCEPTION
                WHEN OTHERS THEN l_sec_val_price := 0;
                                 l_t_percent     := 0;
        END;
        --TINH GIA TSDB (MH 111701)
        -----------Thoai dong de gui email----------------
        IF l_check <> 0 THEN
            BEGIN
                IF l_sectype <> '555' THEN --co phieu & trai phieu
                    l_sec_val_price := NVL(fn_get_mortage_price(l_symbol, l_actype, l_sectype, l_valmethod),0);

                    -----------Thoai dong de gui email----------------
                    --INSERT INTO BONDINFO (ISSUESID, TXDATE, BONDACTYPE, BONDPRICE, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE, PRICETYPE)
                    --VALUES (r.ISSUESID, l_date, l_actype, l_sec_val_price, r.CODEID, NULL, NULL, NULL, l_symbol, NULL, l_valmethod);
                ELSE --tien
                    l_t_percent     := NVL(fn_get_mortage_price(l_symbol, l_actype, l_sectype, l_valmethod),0);
                    -----------Thoai dong de gui email----------------
                    --INSERT INTO BONDINFO (ISSUESID, TXDATE, BONDACTYPE, TPERCENT, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE, PRICETYPE)
                    --VALUES (r.ISSUESID, l_date, l_actype, l_t_percent, r.CODEID, NULL, NULL, NULL, l_symbol, NULL, l_valmethod);
                END IF;
            END;
            l_check := 0;
        END IF;
        -----------Thoai dong de gui email----------------



        --TINH TONG TS CUA CHUNG KHOAN CAM CO
        IF (l_type_pledged = 'SHARE' OR l_type_pledged = 'BOND') THEN
            l_total_sec_amt := l_total_sec_amt + (l_sec_qtty * l_sec_val_price);
        ELSIF (l_type_pledged = 'CASH' OR l_type_pledged = 'CD' OR l_type_pledged = 'TERM_DEPOSIT') THEN
            l_total_cashdepo_amt := l_total_cashdepo_amt + (l_cash_amt*(l_t_percent/100));
        END IF;
        END LOOP;
        --


   /*     IF (NVL(l_total_sec_amt, 0) <= 0 OR NVL(l_valueofissue - l_total_cashdepo_amt, 0) <= 0) THEN
            DELETE FROM ISSUES_HIST WHERE HISTDATE=l_date AND AUTOID=REC.ISSUESID;

            INSERT INTO ISSUES_HIST (HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE)
            SELECT l_date HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE
            FROM ISSUES
            WHERE AUTOID=REC.ISSUESID;

            CONTINUE;
        END IF;*/

        --TINH LTVRATE
        IF l_typerate ='002' THEN --LTV
            IF l_total_sec_amt = 0 THEN
                CONTINUE;
            ELSE
                l_ltv := ROUND(((l_valueofissue - l_total_cashdepo_amt)/l_total_sec_amt)*100,2);
            END IF;
        ELSIF l_typerate ='003' THEN --CCR
            l_ltv := ROUND((l_total_sec_amt/(l_valueofissue - l_total_cashdepo_amt))*100,2);
        END IF;
        --CAP NHAT LTV VAO BANG ISSUES
        UPDATE ISSUES SET LTVRATE = l_ltv
        WHERE AUTOID = REC.ISSUESID;
        --LUU LOG
        DELETE FROM ISSUES_HIST WHERE HISTDATE=l_date AND AUTOID=REC.ISSUESID;
        INSERT INTO ISSUES_HIST (HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE)
            SELECT l_date HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE
            FROM ISSUES
            WHERE AUTOID=REC.ISSUESID;
        -- check and genTemplateWarningLTV
        l_months := MONTHS_BETWEEN(l_date, rec.ISSUEDATE);

        -- TriBui 31/07/2020 edit time sent email EM18
        IF mod(l_months,3) = 0 AND l_months > 0  THEN
            l_next_scheduler_LTV := l_date;
        ELSE
            l_next_scheduler_LTV := TO_DATE(NULL);
        END IF;
        -- End TriBui 31/07/2020 edit time sent email EM18


        SELECT en_subject INTO l_emailSubject FROM TEMPLATES WHERE CODE=TRIM(p_templatesid);
        IF rec.typerate = '002' AND NVL(l_ltv, 0) > 0 THEN -- LTV
        IF l_ltv > NVL(rec.maxltvrate, -0) and TRIM(p_templatesid) in ('EM17','EM17EN') THEN

          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              rec.maxltvrate,
                                              TRIM(p_templatesid),
                                              l_emailSubject);
        ELSIF l_ltv > NVL(rec.warningltvrate, -0) AND l_ltv <= NVL(rec.maxltvrate, -0) and TRIM(p_templatesid) in ('EM16','EM16EN') THEN

          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              rec.maxltvrate,
                                              TRIM(p_templatesid),
                                              l_emailSubject);
        END IF;
        IF TRIM(p_templatesid) in ('EM18','EM18EN')  THEN

          nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                              l_nextdate,
                                              l_ltv,
                                              rec.maxltvrate,
                                              TRIM(p_templatesid),
                                              l_emailSubject);
        END IF;
      ELSIF rec.typerate = '003' AND NVL(l_ltv, 0) > 0 THEN -- CCR
        IF l_ltv < rec.maxltvrate AND rec.maxltvrate > 0 and TRIM(p_templatesid) in ('EM17','EM17EN') THEN

              nmpks_ems.pr_GenTemplateWarningLtv (rec.ISSUESID,
                                                  l_nextdate,
                                                  l_ltv,
                                                  ROUND(1/rec.maxltvrate, 4),
                                                  TRIM(p_templatesid),
                                                  l_emailSubject);
        END IF;
      END IF;
    --==============================END OF [NAM.LY 09/01/2020]--------------------------------------------------------
    end loop;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
    END ;
/
