SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE "PRC_SYN_STOCKPRICE_FROM_FINN"
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
    for rec in
    (
        select mst.*, si.newcirculatingqtty, si.oldcirculatingqtty
        from securities_info si,
            (
                -- hose
                select ho1.ticker, ho1.closeprice closeprice,ho1.averageprice,ho1.closeprice pclosed, ho1.ceilingprice, ho1.floorprice, ho1.foreigncurrentroom, ho1.shareissue,
                    '001' tradeplace,ho1.referenceprice,ho2.tradingdate
                from hosestock@linkfiin ho1,
                (
                    select ticker,max(tradingdate) tradingdate
                    from hosestock@linkfiin
                    group by ticker
                ) ho2
                where ho1.ticker = ho2.ticker and ho1.tradingdate=ho2.tradingdate

                union all -- hnx
                select ha1.ticker, ha1.closeprice closeprice,ha1.averageprice,ha1.closeprice pclosed, ha1.ceilingprice, ha1.floorprice, ha1.foreigncurrentroom, ha1.shareissue,
                    '002' tradeplace,ha1.referenceprice,ha2.tradingdate
                from hnxstock@linkfiin ha1,
                (
                    select ticker,max(tradingdate) tradingdate
                    from hnxstock@linkfiin
                    group by ticker
                ) ha2
                where ha1.ticker = ha2.ticker and ha1.tradingdate=ha2.tradingdate

                union all -- upcom
                select up1.ticker, up1.closeprice,up1.averageprice,up1.averageprice pclosed, up1.ceilingprice, up1.floorprice, up1.foreigncurrentroom, up1.shareissue,
                    '005' tradeplace,up1.referenceprice,up2.tradingdate
                from upcomstock@linkfiin up1,
                (
                    select ticker,max(tradingdate) tradingdate
                    from upcomstock@linkfiin
                    group by ticker
                ) up2
                where up1.ticker = up2.ticker and up1.tradingdate=up2.tradingdate

                union all--bond
                SELECT B.BONDCODE TICKER, B.CLOSEPRICE, B.CLOSEPRICE averageprice, B.CLOSEPRICE pclosed, 0 ceilingprice, 0 floorprice, 0 foreigncurrentroom, 0 shareissue,
                    '010' tradeplace, 0 referenceprice, B.TRADINGDATE
                FROM VW_BONDFIIN@LINKFIIN B,
                (
                    select BONDCODE, max(TO_DATE(trunc(TRADINGDATE))) TRADINGDATE
                    from VW_BONDFIIN@LINKFIIN
                    group by BONDCODE
                ) A
                WHERE A.BONDCODE = B.BONDCODE AND TO_DATE(trunc(B.TRADINGDATE)) = A.TRADINGDATE
                --

                union all -- cw
                select up1.ticker, up1.closeprice,up1.closeprice averageprice,up1.closeprice pclosed, up1.ceilingprice, up1.floorprice, 0 foreigncurrentroom, mst.shareissue shareissue,
                    '001' tradeplace,up1.referenceprice,up2.tradingdate
                from coveredwarrant@linkfiin mst, getcwstockprice@linkfiin up1,
                (
                    select ticker,max(tradingdate) tradingdate
                    from getcwstockprice@linkfiin
                    group by ticker
                ) up2
                where up1.ticker = up2.ticker and up1.tradingdate=up2.tradingdate
                and mst.ticker = up1.ticker

                --SHBVNEX-2086
                union all -- phai sinh
                select up1.derivativecode, up1.closeprice, up1.averageprice , up1.closeprice pclosed, up1.ceilingprice, up1.floorprice, 0 foreigncurrentroom, 0 shareissue,
                    '005' tradeplace, up1.referenceprice, up2.tradingdate
                from Derivative@linkfiin mst, GetDerivativePrice@linkfiin up1,
                (
                    select derivativecode, max(tradingdate) tradingdate
                    from GetDerivativePrice@linkfiin
                    group by derivativecode
                ) up2
                where up1.derivativecode = up2.derivativecode
                and up1.tradingdate=up2.tradingdate
                and mst.derivativecode = up1.derivativecode
                --SHBVNEX-2086

            )mst
        where mst.ticker = si.symbol
    )
    loop
        Update securities_info si
            set si.basicprice = rec.referenceprice,
                si.avgprice = rec.averageprice,
                si.closeprice = rec.closeprice,
                si.currprice  = rec.closeprice,
                si.floorprice = rec.floorprice,
                si.txdate = rec.tradingdate,
                si.ceilingprice = rec.ceilingprice,
                si.current_room = rec.foreigncurrentroom,
                si.listingqtty = rec.shareissue,
                si.newcirculatingqtty = rec.newcirculatingqtty,
                si.oldcirculatingqtty = rec.oldcirculatingqtty
        where symbol = rec.ticker and trunc(txdate) <=trunc(rec.tradingdate) ;

    end loop;

    -- Cap nha KL luu hanh
   for rec2 in
    (
        select  up3.TICKER organcode,exchangeoutstandingshare, up2.exchangeoutstandingshareadjusted, up2.tradingdate tradingdate
        from getdrlistedinformationdaily@linkfiin up2,getorganization@linkfiin UP3,
             (select organcode,max(tradingdate) tradingdate
                    from getdrlistedinformationdaily@linkfiin
                    group by organcode) up1
        where up1.organcode = up2.organcode and up1.tradingdate = up2.tradingdate  AND
        UP2.ORGANCODE=UP3.ORGANCODE
    )loop
         Update securities_info si
            set si.newcirculatingqtty = (case when rec2.exchangeoutstandingshareadjusted=0 then rec2.exchangeoutstandingshare else rec2.exchangeoutstandingshareadjusted end),
                si.oldcirculatingqtty = rec2.exchangeoutstandingshare
        where symbol = rec2.organcode and nvl(newcirculatingqtty,0) <> rec2.exchangeoutstandingshare;
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
