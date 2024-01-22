SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE "PRC_SYN_STOCKPRICE_FROM_FINN_HIST_BYDATE" (pv_todate in date)
IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;
    l_ISSUERID varchar2(20);
    l_CODEID varchar2(6);
    l_CODEIDWFT varchar2(6);

BEGIN
/*
    TruongLD add 12/03/2020
    Dong bo gia cuoi ngay tu fiin ve CB
*/

    plog.setbeginsection(pkgctx, 'prc_syn_stockprice_from_finn');
    for rec in (
        select mst.*, si.newcirculatingqtty,si.oldcirculatingqtty
        from securities_info si,
            (
                -- hose
                select ho1.ticker, ho1.closeprice closeprice,ho1.averageprice,ho1.closeprice pclosed, ho1.ceilingprice, ho1.floorprice, ho1.foreigncurrentroom, ho1.shareissue,
                    '001' tradeplace,ho1.tradingdate,ho1.referenceprice
                from hosestock@linkfiin ho1
                where TO_DATE(trunc(ho1.tradingdate)) = pv_todate
                --where TO_DATE(trunc(ho1.UpdateDate)) = pv_todate

                union all -- hnx

                select ha1.ticker, ha1.closeprice closeprice,ha1.averageprice,ha1.closeprice pclosed, ha1.ceilingprice, ha1.floorprice, ha1.foreigncurrentroom, ha1.shareissue,
                    '002' tradeplace,ha1.tradingdate,ha1.referenceprice
                from hnxstock@linkfiin ha1
                where TO_DATE(trunc(ha1.tradingdate)) = pv_todate
                --where TO_DATE(trunc(ho1.UpdateDate)) = pv_todate

                union all -- upcom

                select ha1.ticker, ha1.closeprice,ha1.averageprice,ha1.closeprice pclosed, ha1.ceilingprice, ha1.floorprice, ha1.foreigncurrentroom, ha1.shareissue,
                    '005' tradeplace,ha1.tradingdate,ha1.referenceprice
                from upcomstock@linkfiin ha1
                where TO_DATE(trunc(ha1.tradingdate)) = pv_todate
                --where TO_DATE(trunc(ho1.UpdateDate)) = pv_todate

                union all--bond
                SELECT B.BONDCODE TICKER, B.CLOSEPRICE, B.CLOSEPRICE averageprice, B.CLOSEPRICE pclosed, 0 ceilingprice, 0 floorprice, 0 foreigncurrentroom, 0 shareissue,
                    '010' tradeplace, B.TRADINGDATE, 0 referenceprice
                FROM VW_BONDFIIN@LINKFIIN B
                WHERE TO_DATE(trunc(B.TRADINGDATE)) = pv_todate
                --

                union all -- cw

                select up1.ticker, up1.closeprice,up1.closeprice averageprice,up1.closeprice pclosed, up1.ceilingprice, up1.floorprice, 0 foreigncurrentroom, mst.shareissue shareissue,
                    '001' tradeplace,up1.tradingdate,up1.referenceprice
                from coveredwarrant@linkfiin mst, getcwstockprice@linkfiin up1
                where TO_DATE(trunc(up1.tradingdate)) = pv_todate
                --where TO_DATE(trunc(ho1.UpdateDate)) = pv_todate
                and mst.ticker = up1.ticker

                --SHBVNEX-2086
                union all -- phai sinh
                select up1.derivativecode, up1.closeprice, up1.averageprice , up1.closeprice pclosed, up1.ceilingprice, up1.floorprice, 0 foreigncurrentroom, 0 shareissue,
                    '005' tradeplace, up1.tradingdate, up1.referenceprice
                from Derivative@linkfiin mst, GetDerivativePrice@linkfiin up1
                where mst.derivativecode = up1.derivativecode
                and TO_DATE(trunc(up1.tradingdate)) = pv_todate
                --SHBVNEX-2086

            )mst
        where mst.ticker = si.symbol
    )
    loop
         delete securities_info_hist where histdate = to_date(trunc(rec.tradingdate)) and symbol = rec.ticker;
        insert into securities_info_hist
    (AUTOID,CODEID,SYMBOL, HISTDATE,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,
        ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,
        CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,
        TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,
        ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,
        MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,
        ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,
        ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30,ISSUED_SHARES_QTTY,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY,FOREIGNROOM,LTVRATE)
    select AUTOID,CODEID,SYMBOL, to_date(trunc(rec.tradingdate)) HISTDATE, to_date(trunc(rec.tradingdate)) TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,
        ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,
        CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,
        TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,
        ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,
        MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,
        ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,
        ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30,ISSUED_SHARES_QTTY,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY,FOREIGNROOM,LTVRATE
    From securities_info WHERE  symbol = rec.ticker;
        Update securities_info_hist si
            set si.basicprice = rec.referenceprice,
                si.avgprice = rec.averageprice,
                si.closeprice = rec.closeprice,
                si.currprice  = rec.closeprice,
                si.floorprice = rec.floorprice,
                si.ceilingprice = rec.ceilingprice,
                si.current_room = rec.foreigncurrentroom,
                si.listingqtty = rec.shareissue,
                si.newcirculatingqtty = rec.newcirculatingqtty,
                si.oldcirculatingqtty = rec.oldcirculatingqtty
        where symbol = rec.ticker and histdate = to_date(trunc(rec.tradingdate));

    end loop;

    -- Cap nha KL luu hanh
     for rec2 in
    (
        select up2.ticker organcode,up1.exchangeoutstandingshare, up1.exchangeoutstandingshareadjusted, up1.tradingdate
        from getdrlistedinformationdaily@linkfiin up1,getorganization@linkfiin UP2
        where  trunc(up1.tradingdate) = pv_todate AND UP1.ORGANCODE=UP2.ORGANCODE
        order by up1.tradingdate
    )loop
         Update securities_info_hist si
            set si.newcirculatingqtty = (case when rec2.exchangeoutstandingshareadjusted=0 then rec2.exchangeoutstandingshare else rec2.exchangeoutstandingshareadjusted end),
                si.oldcirculatingqtty = rec2.exchangeoutstandingshare
        where symbol = rec2.organcode and trunc(histdate) = trunc(rec2.tradingdate);
    end loop;

    commit;
    plog.setendsection(pkgctx, 'prc_syn_stockprice_from_finn');
EXCEPTION
  WHEN others THEN
    rollback;
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'prc_syn_stockprice_from_finn');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
