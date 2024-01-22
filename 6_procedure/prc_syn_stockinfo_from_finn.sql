SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_syn_stockinfo_from_finn
IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;
    l_ISSUERID varchar2(20);
    l_CODEID varchar2(6);
    l_CODEIDWFT varchar2(6);
    l_BUSINESSTYPE varchar2(6);
    l_count number;
    l_shortname varchar2(1000);
    l_vnnfullname varchar2(1000);
BEGIN
/*
    TruongLD add 12/03/2020
    Dong bo thong tin CK fiin ve CB
*/
    plog.setbeginsection(pkgctx, 'prc_syn_bondinfo_from_finn');
    for rec in
    (
        -- Co phieu
        SELECT  ORGANCODE,ISINCODE,TICKER SYMBOL, 10000 parvalue,
                CASE WHEN UPPER(COMGROUPCODE)='VNINDEX' THEN '001'
                     WHEN UPPER(COMGROUPCODE)='HNXINDEX' THEN '002'
                     WHEN UPPER(COMGROUPCODE)='UPCOMINDEX' THEN '005'
                     ELSE '003' END TRADEPLACE, ISSUESHARE,
                ORGANNAME FULLNAME,TRUNC(LISTINGDATE) LISTINGDATE,
                CASE WHEN UPPER(COMTYPECODE) IN ('CK','CT','NT') THEN '001'
                     WHEN UPPER(COMTYPECODE) = 'QU' THEN '008'
                     ELSE '001' END SECTYPE,
                ICBCODE ECONIMIC, BUSTYPEBEFORELISTCODE BUSINESSTYPE,
                chartercapital legalcaptial, chartercapital sharecapital,
                -- CW
                '' underlyingsymbol, '' issuername, '' coveredwarranttype,'' SETTLEMENTTYPE, null maturitydate,
               null lasttradingdate, 0 exerciseprice, 0 exerciseratio,
               -- TP
               null EXPDATE, '000' BONDTYPE, '' TYPETERM, '' TERM, 0 INTCOUPON ,0 IssuePrice, 0 TermStageCode, 0 ShareIssue,ORGANNAME bondname
        FROM GETORGANIZATION@LINKFIIN
        WHERE TRIM(TICKER) NOT IN (SELECT SYMBOL FROM SBSECURITIES)

        UNION ALL -- TP

        SELECT organcode, bondisincode ISINCODE, bondcode SYMBOL, parvalue,
                CASE WHEN UPPER(A.BONDTYPECODE) IN ('CORPB') AND UPPER(A.comgroupcode) NOT IN ('OTC', 'PCBOND') THEN '002'
                     WHEN UPPER(A.comgroupcode)='VNINDEX' THEN '001'
                     WHEN UPPER(A.comgroupcode)='HNXINDEX' THEN '002'
                     WHEN UPPER(A.comgroupcode)='HNX' THEN '002'
                     WHEN UPPER(A.comgroupcode)='OTC' THEN '003'
                     WHEN UPPER(A.comgroupcode)='BOND' THEN '010'
                     WHEN UPPER(A.comgroupcode)='PCBOND' THEN '099'
                 ELSE '010' END TRADEPLACE,
                outstandingshare ISSUESHARE,
               bondname FULLNAME, TRUNC(issuedate) LISTINGDATE, '006' SECTYPE,'003' ECONIMIC, '008' BUSINESSTYPE,
               0 legalcaptial, 0 sharecapital,
               -- CW
               '' underlyingsymbol, '' issuername,
               '' coveredwarranttype,
               '' settlementtype, -- Kieu thuc hien EU
               NULL maturitydate,
               NULL lasttradingdate, 0 exerciseprice, 0 exerciseratio,
               -- TP
               maturitydate EXPDATE, nvl(A1.BONDTYPE,'001') BONDTYPE, a2.cdval TYPETERM,
               replace(bondtermstagecode,a2.cdval,'') TERM, coupon*100 intcoupon, 0 IssuePrice, 0 TermStageCode, 0 ShareIssue , bondname
        FROM GETBOND@LINKFIIN A,
            (
                Select a1.cdval BONDTYPE, a2.cdcontent bondtypecode, a1.cdcontent
                from allcode a1, allcode a2
                where a1.cdtype='SA' and a1.cdname ='BONDTYPE'
                    and a2.cdtype='SA' and a2.cdname ='BONDTYPECODE'
                    and instr(a2.cdval, a1.cdval) > 0
            ) a1, allcode a2
        WHERE TRIM(bondcode) NOT IN (SELECT SYMBOL FROM SBSECURITIES)
            and trim(a.bondtypecode) = a1.bondtypecode(+)
            and a2.cdtype='SA' and a2.cdname='TYPETERM' and INSTR(bondtermstagecode,a2.cdval) > 0

        UNION ALL -- cw
        SELECT organcode organcode, '' ISINCODE, TICKER SYMBOL, 10000 parvalue,
                '001' TRADEPLACE, shareissue ISSUESHARE,
               coveredwarrantname FULLNAME, TRUNC(issuedate) LISTINGDATE, '011' SECTYPE, '003' ECONIMIC, '008' BUSINESSTYPE,
               0 legalcaptial, 0 sharecapital,
               organcode underlyingsymbol, '' issuername,
               decode(derivativetypecode,'CWC','C','P') coveredwarranttype,
               decode(PayoutMethodCode,'CASH','CWMS','CWTS') settlementtype, -- Kieu thuc hien EU
               TRUNC(maturitydate) maturitydate,
               TRUNC(lasttradingdate) lasttradingdate, a.exerciseprice exerciseprice, executionratecoveredwarrant exerciseratio,
               null EXPDATE, '000' BONDTYPE, '' TYPETERM, '' TERM, 0 INTCOUPON, IssuePrice, to_number(REPLACE(replace(TermStageCode,'M'),'.',',')),  ShareIssue ,COVEREDWARRANTNAME bondname
        FROM COVEREDWARRANT@LINKFIIN A
        WHERE TRIM(TICKER) NOT IN (SELECT SYMBOL FROM SBSECURITIES)

        --start SHBVNEX-1991
        UNION ALL -- phai sinh
        SELECT 'EXCH' organcode, to_char(ISINCODE), to_char(derivativecode) SYMBOL, multiplier parvalue,
                '002' TRADEPLACE, 0 ISSUESHARE,
                to_char(derivativename) FULLNAME, TRUNC(listingdate) LISTINGDATE, '005' SECTYPE, '' ECONIMIC, '008' BUSINESSTYPE,
                0 legalcaptial, 0 sharecapital,
                -- CW
                '' underlyingsymbol, '' issuername, '' coveredwarranttype, '' settlementtype, -- Kieu thuc hien EU
                null maturitydate, null lasttradingdate, 0 exerciseprice, 0 exerciseratio,
                -- TP
                TRUNC(payoutdate) EXPDATE, '000' BONDTYPE, '' TYPETERM, '' TERM, 0 INTCOUPON, 0 IssuePrice, 0 TermStageCode,0 ShareIssue ,'' bondname
        FROM Derivative@LINKFIIN A
        WHERE TRIM(derivativecode) NOT IN (SELECT SYMBOL FROM SBSECURITIES)
        --end SHBVNEX-1991
    )
    loop
        Begin
             select cdval into l_BUSINESSTYPE
             from allcode
             where cdname ='BUSTYPEBEFORELISTCODE' and cdtype='SA' and cdcontent = rec.BUSINESSTYPE;
        EXCEPTION
             WHEN others THEN
                  l_BUSINESSTYPE := '008';
        End;

       --check xem co issuer chua , chua co moi them vao
       begin
            select count(*) into l_count from issuers where shortname = trim(rec.organcode);
            if l_count = 0 then
                select lpad(nvl(max(ISSUERID),0) + 1,10,'0') into l_ISSUERID from issuers;


                  Begin
                   select ORGANNAME FULLNAME,ORGANSHORTNAME SHORTNAME  into l_vnnfullname, l_shortname
                  from GETORGANIZATION_VN@LINKFIIN where organcode = rec.organcode and rownum=1;
                  EXCEPTION
                  WHEN others THEN
                  l_vnnfullname:='';
                  l_shortname:='';
                  End;

                insert into issuers (issuerid,shortname,fullname,en_fullname,officename,econimic,businesstype, operateplace, marketsize,status,
                            legalcaptial, sharecapital
                       )
                select l_issuerid issuerid,
                        trim(rec.organcode) shortname,
                        l_vnnfullname,
                        rec.fullname,
                        l_shortname officename,
                        rec.econimic,
                        l_BUSINESSTYPE,
                        '' operateplace,
                        '001' marketsize,
                        'A' status,
                        rec.legalcaptial, rec.sharecapital
                from dual;


            else
                select issuerid into l_issuerid from issuers where shortname = trim(rec.organcode) and rownum=1;
            end if;
        end;
        Begin
            SELECT lpad((MAX(TO_NUMBER(INVACCT)) + 1),6,'0') into l_CODEID FROM
            (SELECT ROWNUM ODR, INVACCT
            FROM (SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID) DAT
            ) INVTAB;

            l_CODEID := nvl(l_CODEID,lpad(1,6,'0'));
        EXCEPTION
            WHEN OTHERS THEN
                l_CODEID :=  lpad(1,6,'0');
        End;

        select lpad(to_number(l_CODEID) + 1, 6,'0') into l_CODEIDWFT from dual;


        -- Chung khoan thuong

        INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,
                    STATUS,TRADEPLACE,DEPOSITORY,HALT,SBTYPE,REFCODEID,MARKETTYPE,
                    INTPAYMODE,ISBUYSELL, ISINCODE, ISSUEDATE,
                    -- Thong tin lien quan den CW
                    underlyingsymbol, issuername, coveredwarranttype, settlementtype, maturitydate, lasttradingdate,
                    -- Thong tin TP
                    EXPDATE, BONDTYPE, TYPETERM, TERM, INTCOUPON,settlementprice,cwterm,issqtty,exerciseprice, exerciseratio,bondname,MANAGEMENTTYPE
                    )
        Select l_CODEID,l_ISSUERID,trim(rec.symbol),REC.SECTYPE SECTYPE,'002' INVESTMENTTYPE,'001' RISKTYPE,rec.PARVALUE,49 FOREIGNRATE,
                'Y' STATUS,REC.TRADEPLACE,'001' DEPOSITORY, 'N' HALT,'001' SBTYPE,
                NULL REFCODEID,'000' MARKETTYPE,'000' INTPAYMODE,'N' ISBUYSELL, rec.ISINCODE, trunc(rec.LISTINGDATE) ISSUEDATE,
                -- Thong tin lien quan den CW
                rec.underlyingsymbol, rec.issuername, rec.coveredwarranttype, rec.settlementtype,rec.maturitydate, rec.lasttradingdate,
                rec.EXPDATE, rec.BONDTYPE, rec.TYPETERM, rec.TERM, rec.INTCOUPON,rec.IssuePrice,  rec.TermStageCode,  rec.ShareIssue,rec.exerciseprice, rec.exerciseratio,rec.bondname,'LKCK'
        from dual;

        -- Chung khoan cho giao dich WFT
        If REC.SECTYPE NOT IN ('011', '016') then --011: CW

                 INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,
                        STATUS,TRADEPLACE,DEPOSITORY,HALT,SBTYPE,REFCODEID,MARKETTYPE,
                        INTPAYMODE,ISBUYSELL, ISINCODE, ISSUEDATE,
                        EXPDATE, BONDTYPE, TYPETERM, TERM, INTCOUPON,bondname,MANAGEMENTTYPE
                        )
            Select l_CODEIDWFT,l_ISSUERID,trim(rec.symbol) || '_WFT',REC.SECTYPE,'002' INVESTMENTTYPE,'001' RISKTYPE,10000 PARVALUE,49 FOREIGNRATE,
                    'Y' STATUS,
                    '006',
                    '001' DEPOSITORY, 'N' HALT,'001' SBTYPE,
                    l_CODEID REFCODEID,'000' MARKETTYPE,'000' INTPAYMODE,'N' ISBUYSELL, rec.ISINCODE, trunc(rec.LISTINGDATE) ISSUEDATE,
                    rec.EXPDATE, rec.BONDTYPE, rec.TYPETERM, rec.TERM, rec.INTCOUPON, rec.bondname,'LKCK'
            from dual;


        End If;

        INSERT INTO securities_info(AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS, LISTTINGDATE,STATUS,
            TRADELOT,TRADEBUYSELL, CURRENT_ROOM,ISSUED_SHARES_QTTY)
        select SEQ_SECURITIES_INFO.nextval AUTOID, sb.codeid, SB.SYMBOL, trunc(rec.LISTINGDATE) TXDATE, REC.ISSUESHARE LISTINGQTTY,1000 TRADEUNIT,
               'N' LISTINGSTATUS, trunc(rec.LISTINGDATE) LISTINGDATE, '001' STATUS,
               (case when rec.TRADEPLACE='001' then 10 else 100 end) TRADELOT, 'Y' TRADEBUYSELL, 0 CURRENT_ROOM,
               rec.issueshare ISSUED_SHARES_QTTY
       from sbsecurities sb where codeid =l_CODEIDWFT or  codeid =l_CODEID;

       --delete from sbsecurities where issuerid not in (select issuerid from issuers);
       --delete from securities_info where codeid not in (select codeid from sbsecurities);
    end loop;

    for rec in
    (
        -- OTC
        select distinct ORGANCODE from (
        select leftorgancode organcode from getorganizationrole@linkfiin
        union all
        select rightorgancode organcode from getorganizationrole@linkfiin
        ) where organcode NOT IN (select shortname from issuers)
    )
    loop

       --check xem co issuer chua , chua co moi them vao
       begin

                select lpad(nvl(max(ISSUERID),0) + 1,10,'0') into l_ISSUERID from issuers;
                insert into issuers (issuerid,shortname,fullname,en_fullname,officename,econimic,businesstype, operateplace, marketsize,status,
                            legalcaptial, sharecapital
                       )
                select l_issuerid issuerid,
                        trim(rec.organcode) shortname,
                        trim(rec.organcode) fullname,
                        trim(rec.organcode) fullname,
                        '' officename,
                        '' econimic,
                        '' BUSINESSTYPE,
                        '' operateplace,
                        '001' marketsize,
                        'A' status,
                        0, 0
                from dual;
        end;
    END LOOP;

    sp_getindexinfo_from_finn;

    Commit;
    plog.setendsection(pkgctx, 'prc_syn_bondinfo_from_finn');
EXCEPTION
  WHEN others THEN
    rollback;
    dbms_output.put_line('l_CODEID:' || l_CODEID);
    dbms_output.put_line('l_ISSUERID:' || l_ISSUERID);
    dbms_output.put_line('l_CODEIDWFT:' || l_CODEIDWFT);
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'prc_syn_bondinfo_from_finn');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
