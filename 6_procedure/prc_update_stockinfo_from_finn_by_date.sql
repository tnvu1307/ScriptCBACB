SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_update_stockinfo_from_finn_by_date (pv_todate in date)
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
    plog.setbeginsection(pkgctx, 'prc_update_stockinfo_from_finn_by_date');
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
               null EXPDATE, '000' BONDTYPE, '' TYPETERM, '' TERM, 0 INTCOUPON ,0 IssuePrice, 0 TermStageCode, 0 ShareIssue,'' bondname, 'ST' STOCKTYPE
        FROM GETORGANIZATION@LINKFIIN
        WHERE trunc(updatedate) = trunc(pv_todate)

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
               replace(bondtermstagecode,a2.cdval,'') TERM, coupon*100 intcoupon, 0 IssuePrice, 0 TermStageCode, 0 ShareIssue , bondname, 'BD' STOCKTYPE
        FROM GETBOND@LINKFIIN A,
            (
                Select a1.cdval BONDTYPE, a2.cdcontent bondtypecode, a1.cdcontent
                from allcode a1, allcode a2
                where a1.cdtype='SA' and a1.cdname ='BONDTYPE'
                    and a2.cdtype='SA' and a2.cdname ='BONDTYPECODE'
                    and instr(a2.cdval, a1.cdval) > 0
            ) a1, allcode a2
        WHERE trunc(updatedate) = trunc(pv_todate)
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
               null EXPDATE, '000' BONDTYPE, '' TYPETERM, '' TERM, 0 INTCOUPON, IssuePrice, to_number(REPLACE(replace(TermStageCode,'M'),'.',',')),  ShareIssue ,COVEREDWARRANTNAME bondname, 'CW' STOCKTYPE
        FROM COVEREDWARRANT@LINKFIIN A
        WHERE trunc(updatedate) = trunc(pv_todate)

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
                TRUNC(payoutdate) EXPDATE, '000' BONDTYPE, '' TYPETERM, '' TERM, 0 INTCOUPON, 0 IssuePrice, 0 TermStageCode,0 ShareIssue ,'' bondname, 'CW' STOCKTYPE
        FROM Derivative@LINKFIIN A
        WHERE trunc(updatedate) = trunc(pv_todate)
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
        IF REC.STOCKTYPE <> 'CW' THEN
        begin
            Begin
                select ORGANNAME FULLNAME,ORGANSHORTNAME SHORTNAME  into l_vnnfullname, l_shortname
                from GETORGANIZATION_VN@LINKFIIN where organcode = rec.organcode and rownum=1;
            EXCEPTION
            WHEN others THEN
                l_vnnfullname:='';
                l_shortname:='';
            End;

            update issuers set fullname = l_vnnfullname, en_fullname =rec.fullname, officename = l_shortname, econimic= rec.econimic,
            businesstype = l_BUSINESSTYPE, legalcaptial=rec.legalcaptial,sharecapital=rec.sharecapital
            where shortname = trim(rec.organcode) and rownum=1;
        end;
        END IF;
        if REC.SECTYPE = '003' then
            update sbsecurities set SECTYPE = REC.SECTYPE,TRADEPLACE=REC.TRADEPLACE,ISINCODE=rec.ISINCODE,
                             underlyingsymbol=rec.underlyingsymbol, issuername=rec.issuername, coveredwarranttype=rec.coveredwarranttype, settlementtype=rec.settlementtype,
                             maturitydate=rec.maturitydate, lasttradingdate=rec.lasttradingdate,
                    -- Thong tin TP
                             EXPDATE=rec.EXPDATE, BONDTYPE= rec.BONDTYPE, TYPETERM=rec.TYPETERM, TERM=rec.TERM, INTCOUPON=rec.INTCOUPON,settlementprice=rec.IssuePrice,
                             cwterm=rec.TermStageCode,issqtty=rec.ShareIssue,exerciseprice=rec.exerciseprice, exerciseratio=rec.exerciseratio,bondname=rec.bondname
            where symbol = trim(rec.symbol) and rownum=1;
        else
            update sbsecurities set SECTYPE = REC.SECTYPE,PARVALUE=rec.PARVALUE,TRADEPLACE=REC.TRADEPLACE,ISINCODE=rec.ISINCODE,
                             underlyingsymbol=rec.underlyingsymbol, issuername=rec.issuername, coveredwarranttype=rec.coveredwarranttype, settlementtype=rec.settlementtype,
                             maturitydate=rec.maturitydate, lasttradingdate=rec.lasttradingdate,
                    -- Thong tin TP
                             EXPDATE=rec.EXPDATE, BONDTYPE= rec.BONDTYPE, TYPETERM=rec.TYPETERM, TERM=rec.TERM, INTCOUPON=rec.INTCOUPON,settlementprice=rec.IssuePrice,
                             cwterm=rec.TermStageCode,issqtty=rec.ShareIssue,exerciseprice=rec.exerciseprice, exerciseratio=rec.exerciseratio,bondname=rec.bondname
            where symbol = trim(rec.symbol) and rownum=1;
        end if;
    end loop;

    sp_getmarketinfo_from_finn(pv_todate);

    Commit;
    plog.setendsection(pkgctx, 'prc_update_stockinfo_from_finn_by_date');
EXCEPTION
  WHEN others THEN
    rollback;
    dbms_output.put_line('l_CODEID:' || l_CODEID);
    dbms_output.put_line('l_ISSUERID:' || l_ISSUERID);
    dbms_output.put_line('l_CODEIDWFT:' || l_CODEIDWFT);
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'prc_update_stockinfo_from_finn_by_date');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
