SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3357','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'IDCODE', 'C', '$88', 'select (case when idtype = ''009'' then tradingcode
            else idcode end) idcode
from cfmast where custodycd IN (SELECT CUSTODYCD FROM VW_CFMAST_M WHERE CUSTODYCD_ORG = ''<$FILTERID>'')', 'Loại giấy tờ', 'ID number', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'IDDATE', 'D', '$88', 'select (case when idtype = ''009'' then to_char(TRADINGCODEDT,''DD/MM/RRRR'')
            else to_char(IDDATE,''DD/MM/RRRR'') end) idcode
from cfmast where custodycd IN (SELECT CUSTODYCD FROM VW_CFMAST_M WHERE CUSTODYCD_ORG = ''<$FILTERID>'')', 'Ngày cấp', 'Issue date', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'AFACCTNO', 'C', '$03', '', 'Tiểu khoản', 'Sub-account', '', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'ALTERNATEID', 'C', '$88', 'select ( case when cf.idtype = ''001'' then ''IDNO''
         when cf.idtype = ''002'' then ''CCPT''
         when cf.idtype = ''005'' then ''CORP''
         when cf.idtype = ''009'' and cf.custtype = ''B'' then ''FIIN''
         when cf.idtype = ''009'' and cf.custtype = ''I'' then ''ARNU''
         else ''OTHR''
    end) ALTERNATEID
from cfmast cf
where cf.custodycd IN (SELECT CUSTODYCD FROM VW_CFMAST_M WHERE CUSTODYCD_ORG = ''<$FILTERID>'')', 'Loại hình cổ đông', 'Type of investor', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'AUTONUMBER', 'C', '$01', 'SELECT LPAD(SEQ_VSDREQAUTOID.NEXTVAL,6,''0'') AUTONUMBER FROM DUAL', 'Số thứ tự của điện gửi trong phiên', 'EN:Số thứ tự của điện gửi trong phiên', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'CUSTODYCD', 'C', '$88', 'SELECT CUSTODYCD FROM VW_CFMAST_M WHERE CUSTODYCD_ORG = ''<$FILTERID>''', 'Tài khoản lưu ký', 'Custody code', '', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'ORDERNUMBER', 'C', '$08', '', 'STT thông tin phụ', 'Number Identification', '', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'QTTY', 'C', '$92', '', 'Số lượng', 'Quantity', '', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'REFERENCEID', 'C', '$07', '', 'Mã đợt thực hiện quyền', 'Corporate action code', '', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'STOCKTYPE', 'C', '$01', 'SELECT (CASE WHEN SECTYPE = ''006'' or SECTYPE = ''003'' THEN ''FAMT'' ELSE ''UNIT'' END) UNIT FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Cổ phiếu/ Trái phiếu', 'Shares/ Bonds', '', 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'SYMBOL_ORG', 'C', '$01', 'SELECT SYMBOL FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Mã chứng khoán chốt', 'Fixing securities', '', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'TXDATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu', 'Preparation Date', '', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'VSDCODE', 'C', '$01', 'select b.vsdbiccode
from sbsecurities sb, issuers i , vsdbiccode b
where sb.issuerid = i.issuerid
and i.vsdplace = b.vsdplace
and sb.codeid = ''<$FILTERID>''', 'VSD BICCODE', 'VSD BICCODE', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3357', '565.CAEV//RHTS', 'VSDSTOCKTYPE', 'C', '$51', 'select (case when ''<$FILTERID>'' > 0 then 1 else 2 end) VSDSTOCKTYPE from dual', 'Loại chứng khoán', 'Type of securities', '', 'N', 7);COMMIT;