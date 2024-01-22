SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2283','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2283', 'Đối chiếu giá Import từ file Excel', 'Import price comparisons from Excel file', 'SELECT FR.txdate, FR.SYMBOL,inf.AVGPRICE TREFPRICE,inf.CEILINGPRICE TCEILINGPRICE,inf.FLOORPRICE TFLOORPRICE,
    FR.REFPRICE FREFPRICE,FR.CEILINGPRICE FCEILINGPRICE,FR.FLOORPRICE FFLOORPRICE,
    (inf.AVGPRICE - FR.REFPRICE) DIFREFPRICE,
    (inf.CEILINGPRICE - FR.CEILINGPRICE)DIFCEILINGPRICE,
    (inf.FLOORPRICE - FR.FLOORPRICE) DIFFLOORPRICE
FROM SECURITIES_FRFILE FR, 
    (
        select inf.symbol, inf.AVGPRICE,               
               greatest(TRUNC(inf.AVGPRICE * (1 + hnx.PRICELIMIT_HNX)/100)*100, 100 + inf.AVGPRICE) CEILINGPRICE,
               least(CEIL(inf.AVGPRICE * (1 - hnx.PRICELIMIT_HNX)/100)*100, inf.AVGPRICE-100)  FLOORPRICE                                                                                
                                
        from SECURITIES_INFO inf, sbsecurities sb,
             (select to_number(varvalue) / 100 PRICELIMIT_HNX from sysvar where varname = ''PRICELIMIT_HNX'') hnx    
        where inf.codeid = sb.codeid 
              and sb.tradeplace = ''002''

        UNION all              
        
        select inf.symbol, inf.AVGPRICE, 
               greatest(TRUNC(inf.AVGPRICE * (1 + hnx.PRICELIMIT_HNX)/100)*100, 100 + inf.AVGPRICE) CEILINGPRICE,
               least(CEIL(inf.AVGPRICE * (1 - hnx.PRICELIMIT_HNX)/100)*100, inf.AVGPRICE-100)  FLOORPRICE                                                                                
                                
        from SECURITIES_INFO inf, sbsecurities sb,
             (select to_number(varvalue) / 100 PRICELIMIT_HNX from sysvar where varname = ''PRICELIMIT_UPCOM'') hnx    
        where inf.codeid = sb.codeid 
              and sb.tradeplace =''005''
              
    ) inf
WHERE FR.SYMBOL = inf.SYMBOL', 'SEMAST', '', 'SYMBOL', '2283', NULL, 5000, 'N', 1, 'NNNNYYNNNN', 'Y', 'T', '', 'N', '');COMMIT;