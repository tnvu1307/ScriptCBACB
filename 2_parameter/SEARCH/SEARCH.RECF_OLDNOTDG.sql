SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RECF_OLDNOTDG','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RECF_OLDNOTDG', 'Loại hình môi giới/Không là Chăm sóc hộ', 'Remiser/Not DG', 'SELECT (CF.CUSTID||RF.REACTYPE) REACCT, RF.AUTOID, CFMAST.FULLNAME, TYP.ACTYPE, TYP.TYPENAME, A2.CDCONTENT AFSTATUS,
            typ.rerole,A0.CDCONTENT DESC_REROLE, A1.CDCONTENT DESC_RETYPE, RF.EFFDATE, RF.EXPDATE,RF.ODRNUM, (CFMAST.FULLNAME || ''/''|| TYP.TYPENAME || ''/''||A2.CDCONTENT) DESC_TYPE, CF.CUSTID
            FROM RECFDEF RF, RETYPE TYP, ALLCODE A0, ALLCODE A1, ALLCODE A2, RECFLNK CF, CFMAST
              WHERE A0.CDTYPE=''RE'' AND A0.CDNAME=''REROLE'' AND A0.CDVAL=TYP.REROLE
                    AND A2.CDTYPE = ''RE'' AND A2.CDNAME = ''AFSTATUS'' AND A2.CDVAL = TYP.AFSTATUS
                    AND A1.CDTYPE=''RE'' AND A1.CDNAME=''RETYPE'' AND A1.CDVAL=TYP.RETYPE
                    AND RF.REACTYPE=TYP.ACTYPE 
                      AND (RF.STATUS = ''A'' or RF.STATUS is null) 
                    AND CF.STATUS=''A''
                    AND RF.REFRECFLNKID = CF.AUTOID
                    AND CF.CUSTID = CFMAST.CUSTID AND TYP.REROLE <> ''DG''
                    AND TYP.afstatus IN (''D'',''O'')', 'RE.RECF_NOTDG', 'frmRECF_NOTDG', 'ACTYPE,TYPENAME,FULLNAME', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;