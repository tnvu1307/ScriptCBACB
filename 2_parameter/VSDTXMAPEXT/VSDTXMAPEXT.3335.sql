SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3335','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'AUTONUMBER', 'C', '$03', 'SELECT LPAD(SEQ_VSDREQAUTOID.NEXTVAL,6,''0'') AUTONUMBER FROM DUAL', 'Số thứ tự của điện gửi trong phiên', 'EN:Số thứ tự của điện gửi trong phiên', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'BRID', 'C', '$04', 'select b.cdval
from sbsecurities sb, (select cdcontent, cdval from allcode where cdname = ''TRADEPLACE'' and cdtype = ''SE'') A,
(SELECT CDVAL ,  CDCONTENT
 FROM ALLCODE WHERE CDNAME = ''TRADEPLACE'' AND CDTYPE=''ST'' AND CDUSER=''Y'') B
where sb.tradeplace = a.cdval
and b.CDCONTENT = a.CDCONTENT
and sb.codeid = ''<$FILTERID>''', 'Sàn giao dịch', 'Trading venue', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'NAMEFILE', 'C', '$03', 'SELECT FILENAME FROM
(
    SELECT CSVFILENAME FILENAME
    FROM (
        select autoid, filename, partner, vsdid, csvfilename, txdate from vsd_parcontent_log
            union all
        select autoid, filename, partner, vsdid, csvfilename, txdate from vsd_parcontent_log_hist
    ) LOG,
    (SELECT VSDID FROM CAMAST WHERE CAMASTID = ''<$FILTERID>'') VID
    WHERE LOG.VSDID = VID.VSDID
    ORDER BY LOG.AUTOID DESC
) WHERE ROWNUM <=1', 'Số hiệu tham chiếu báo cáo', 'Report reference', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'RPTID', 'C', '$03', 'SELECT SUBSTR(LOG.CSVFILENAME,INSTR(LOG.CSVFILENAME,''CA''),5)
FROM (
    select autoid, filename, partner, vsdid, csvfilename, txdate from vsd_parcontent_log
        union all
    select autoid, filename, partner, vsdid, csvfilename, txdate from vsd_parcontent_log_hist
) LOG,
(SELECT VSDID FROM CAMAST WHERE CAMASTID = ''<$FILTERID>'') VID
WHERE LOG.VSDID = VID.VSDID
    AND ROWNUM <=1', 'Mã báo cáo', 'Report id', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'TRANDATE', 'D', '<$BUSDATE>', NULL, 'Ngày giao dịch', 'Transaction Date', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'TRANNUM', 'C', '$07', NULL, 'Mã đợt thực hiện quyền', 'Corporate action code', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'TXDATE', 'D', '<$BUSDATE>', NULL, 'Ngày tạo yêu cầu', 'Preparation Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'CONFIRMSTATUS', 'C', '$15', NULL, 'Trạng thái xác nhận', 'Comfirmation status', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '3335', '598.005.CAINFO', 'DESC', 'C', '$30', NULL, 'Diễn giải', 'Description', 'C', 'N', 10);COMMIT;