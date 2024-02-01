SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1711','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'CATYPE', 'C', '$03', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
            when instr(''011'',catype) >0 then ''DVSE''
            when instr(''014'',catype) >0 then ''RHTS''
            when instr(''021'',catype) >0 then ''BONU''
            when instr(''005'',catype) >0 then ''MEET''
            when instr(''028,006'',catype) >0 then ''XMET''
            when instr(''015'',catype) >0 then ''INTR''
            when instr(''027'',catype) >0 then ''LIQU''
            when instr(''017,020,023'',catype) >0 then ''CONV''
            when instr(''019'',catype) >0 then ''CHAN''
            when instr(''030'',catype) >0 and instr(''001,003'',CASUBTYPE) >0 then ''TEND''
            when instr(''030'',catype) >0 and CASUBTYPE=''002'' then ''OTHR''
            when instr(''031,032'',catype) >0 then ''OTHR''
            when instr(''003'',catype) >0 then ''DLST''
            when instr(''016'',catype) >0 then ''REDM''
            when instr(''029'',catype) >0 then ''INFO''    END
from camast where camastid = ''<$FILTERID>''', 'CA Type', 'CA Type', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'CICCODE', 'C', '$88', 'select swiftcode from cfmast where custodycd = ''<$FILTERID>''', 'CLIENT BICCODE', 'CLIENT BICCODE', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'CIFID', 'C', '$88', 'select cifid from cfmast where custodycd = ''<$FILTERID>''', 'CIF id', 'Cif id', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'ISINCODE', 'C', '$03', 'select sb.isincode
from camast ca, sbsecurities sb
where ca.codeid = sb.codeid and ca.camastid = ''<$FILTERID>''', 'ISIN code', 'ISIN code', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'NOTE', 'C', '$30', NULL, 'Nội dung', 'Content', 'C', 'Y', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'PREDATE', 'C', '<$BUSDATE>', NULL, 'Preparation date', 'Preparation date', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'REFID', 'C', '$04', 'select case when ''<$FILTERID>''=''0'' then ''<$REQID>'' else ''<$FILTERID>'' end from dual', 'RefID', 'RefID', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '599.FREE', 'CICCODE', 'C', '$88', 'select swiftcode from cfmast where custodycd = ''<$FILTERID>''', 'CLIENT BICCODE', 'CLIENT BICCODE', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '599.FREE', 'NOTE', 'C', '$31', NULL, 'Nội dung', 'Content', 'C', 'Y', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '599.FREE', 'REFID', 'C', '$04', 'select case when ''<$FILTERID>''=''0'' then ''<$REQID>'' else ''<$FILTERID>'' end from dual', 'RefID', 'RefID', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1711', '568.FREE', 'CAID', 'C', '$03', NULL, 'CA ID', 'CA ID', 'C', 'N', 12);COMMIT;