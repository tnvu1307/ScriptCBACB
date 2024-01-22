SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_RM0010
(TXDATE, CIFID, FULLNAME, CUSTODYCD, BROKER, 
 SYMBOL, HOLDBROKER, HOLDMATCHBROKER, HOLDMISS)
AS 
SELECT VSE.TXDATE,CF.CIFID,CF.FULLNAME,VSE.CUSTODYCD,VOD.CTCK BROKER,VSE.SYMBOL,nvl(VSE.HOLDBROKER,0) - nvl(vseun.UNHOLDBROKER,0),nvl(VOD.HOLDMATCHBROKER,0),(nvl(VOD.HOLDMATCHBROKER,0) - nvl(VSE.HOLDBROKER,0) + nvl(vseun.UNHOLDBROKER,0) )HOLDMISS
from
    (
        select vw.txdate,vw.custodycd,vw.symbol,fa.shortname ctck,
                (case when vw.txtype = 'C' then sum(vw.namt) else 0 end) HOLDBROKER
            from vw_setran_gen vw, vw_tllogfld_all tl,famembers fa
            where   vw.tltxcd in ('2212') 
                and vw.field in('HOLD')
                and vw.txnum = tl.txnum(+)
                and vw.txdate = tl.txdate
                and tl.fldcd = '05'
                and fa.autoid = tl.cvalue
            group by vw.txdate,vw.custodycd,vw.symbol,vw.txtype,fa.shortname
    )vse,
    (select vw.txdate,vw.custodycd,vw.symbol,
                (case when vw.txtype = 'D' then sum(vw.namt) else 0 end) UNHOLDBROKER
            from vw_setran_gen vw
            where   vw.tltxcd in ('2213') 
                and vw.field in('HOLD')
            group by vw.txdate,vw.custodycd,vw.symbol,vw.txtype
    )vseun,
    (
        select vw.txdate,vw.custodycd,vw.symbol,(sum(vw.qtty))HOLDMATCHBROKER,ctck
            from vw_odmast_import vw 
            group by vw.txdate,vw.custodycd,vw.symbol ,ctck
    )vod,cfmast cf
where   vse.txdate = vod.txdate
    and vse.custodycd = vod.custodycd
    and vse.symbol = vod.symbol
    and vse.custodycd = cf.custodycd
    and vse.txdate= vseun.txdate(+)
    and vse.custodycd = vseun.custodycd(+)
    and vse.ctck = vod.ctck(+)
/
