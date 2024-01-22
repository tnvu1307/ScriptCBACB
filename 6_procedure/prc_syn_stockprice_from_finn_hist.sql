SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PRC_SYN_STOCKPRICE_FROM_FINN_HIST
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
    for recdate in (select distinct tradingdate from hosestock@linkfiin)
    loop
    for rec in
    (
        select mst.*, nvl(si.newcirculatingqtty, mst.shareissue) oldcirculatingqtty
        from securities_info si,
            (
                -- hose
                select ho1.ticker, ho1.closeprice,ho1.averageprice,ho1.closeprice pclosed, ho1.ceilingprice, ho1.floorprice, ho1.foreigncurrentroom, ho1.shareissue,
                    '001' tradeplace,ho1.tradingdate,ho1.referenceprice

                from hosestock@linkfiin ho1
                where  ho1.tradingdate=recdate.tradingdate

                union all -- hnx
                select ha1.ticker, ha1.closeprice,ha1.averageprice,ha1.closeprice pclosed, ha1.ceilingprice, ha1.floorprice, ha1.foreigncurrentroom, ha1.shareissue,
                    '002' tradeplace,ha1.tradingdate,ha1.referenceprice
                from hnxstock@linkfiin ha1

                where  ha1.tradingdate=recdate.tradingdate

                  union all -- upcom
                select ha1.ticker, ha1.closeprice,ha1.averageprice,ha1.closeprice pclosed, ha1.ceilingprice, ha1.floorprice, ha1.foreigncurrentroom, ha1.shareissue,
                    '005' tradeplace,ha1.tradingdate,ha1.referenceprice
                from upcomstock@linkfiin ha1

                where  ha1.tradingdate=recdate.tradingdate
                 union all -- cw
                select up1.ticker, up1.closeprice,up1.closeprice averageprice,up1.closeprice pclosed, up1.ceilingprice, up1.floorprice, 0 foreigncurrentroom, mst.shareissue shareissue,
                    '001' tradeplace,up1.tradingdate,up1.referenceprice
                from coveredwarrant@linkfiin mst, getcwstockprice@linkfiin up1

                where  up1.tradingdate=recdate.tradingdate
                and mst.coveredwarrantcode = up1.ticker
            )mst
        where mst.ticker = si.symbol
    )
    loop
     --insert into securities_info_hist select * from securities_info where symbol = rec.ticker;
        insert into securities_info_hist
    (AUTOID,CODEID,SYMBOL, HISTDATE,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,
        ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,
        CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,
        TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,
        ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,
        MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,
        ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,
        ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30,ISSUED_SHARES_QTTY,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY,FOREIGNROOM,LTVRATE)
    select AUTOID,CODEID,SYMBOL,to_date(to_char(rec.tradingdate,'DD/MM/RRRR'),'DD/MM/RRRR') HISTDATE,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,
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
                si.newcirculatingqtty = rec.shareissue,
                si.oldcirculatingqtty = rec.oldcirculatingqtty
        where symbol = rec.ticker and histdate = recdate.tradingdate;

    end loop;

    -- Cap nha KL luu hanh
     for rec2 in
    (
        select up2.ticker organcode,up1.exchangeoutstandingshare, up1.exchangeoutstandingshareadjusted, up1.tradingdate
        from getdrlistedinformationdaily@linkfiin up1,getorganization@linkfiin UP2
        where  trunc(up1.tradingdate) = recdate.tradingdate AND UP1.ORGANCODE=UP2.ORGANCODE 
        order by up1.tradingdate
    )loop
         Update securities_info_hist si
            set si.newcirculatingqtty = (case when rec2.exchangeoutstandingshareadjusted=0 then rec2.exchangeoutstandingshare else rec2.exchangeoutstandingshareadjusted end),
                si.oldcirculatingqtty = rec2.exchangeoutstandingshare
        where symbol = rec2.organcode and trunc(histdate) = trunc(rec2.tradingdate);
    end loop;

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
