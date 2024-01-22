SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AP0004','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AP0004', 'Tra Cứu Lịch Sử Tất Cả Giao Dịch Giữ Hộ Tài Sản', 'View All Transactions of Asset Protection', 'SELECT cra.tltxcd,cra.txdate,cra.txnum, 
        (case when cra.tltxcd in( ''1401'',''1400'',''1402'',''1407'',''1408'') then A2.<@CDCONTENT> else '''' end ) TXTYPE,
        nvl(cra.CRPHYSAGREEID,cra.appendixid) CRPHYSAGREEID,cf.cifid,cf.custodycd,cf.fullname,cra.symbol,cra.citad,
        (case when cra.tltxcd in (''1401'') then cra.BANKACCNAME else '''' end) CUSTODYCDBUY,
        (case when cra.tltxcd in(''1401'',''1408'',''1400'',''1402'',''1407'') then cra.amt else 0 end) amt,
        (case when cra.tltxcd in (''1401'') then 0 else cra.qtty end) qtty,
        (case when cra.tltxcd in( ''1401'',''1408'') then A1.<@CDCONTENT> else '''' end) feetype,
        (case when cra.tltxcd in(''1405'',''1406'') then cra.refno else '''' end) TXCODE,
        (case when cra.tltxcd in(''1405'',''1406'') then cra.sender else '''' end) SENDER,
        (case when cra.tltxcd in(''1405'',''1406'') then cra.receiver else '''' end) RECEIVER,
        (case when cra.tltxcd in (''1406'') then cra.receiverdate else '''' end) RECEIVERDATE,
        cra.BENEFICIARY_ACCOUNT,cra.BENEFICIARY_NAME,cra.VAT,A4.<@CDCONTENT> DEDUCTIONPLACE,A3.<@CDCONTENT> TAXABLEPARTY,
        cra.txdesc DESCRIPTION,cra.ORIGIONAL_NO,cra.ROLLOVER_NO,tl.txdesc TYPE,ad.<@CDCONTENT> DELTD,ad.cdval DELTDVAL
    from CRPHYSAGREE_LOG_ALL cra,cfmast cf, (select *from allcode where cdname = ''IOROFEE'' and cdtype = ''SA'') A1,
            (select *from allcode where cdname = ''REFTYPE'' and cdtype = ''AP'') A2,
            (SELECT * FROM ALLCODE WHERE CDTYPE = ''AP'' AND CDNAME = ''TAXABLEPARTY'' ORDER BY LSTODR)A3,
            (SELECT * FROM ALLCODE WHERE CDTYPE = ''AP'' AND CDNAME = ''DEDUCTIONPLACE'' ORDER BY LSTODR) A4,
            (select txdesc,tltxcd from tltx) tl,
            (select *From allcode where cdname = ''DELTDTEXT'') ad
    where   cra.custid = cf.custid
        and cra.feetype = A1.cdval(+)
        and cra.typedoc = A2.cdval(+)
        and cra.TAXABLEPARTY = A3.cdval(+)
        and cra.DEDUCTIONPLACE = A4.cdval(+)
        and cra.tltxcd = tl.tltxcd
        and cra.deltd = ad.cdval', 'AP0004', '', '', '', 0, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;