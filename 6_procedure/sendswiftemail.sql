SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendswiftemail( p_date_from date, p_date_to date)
IS
    --NAM.LY 29-11-2019
    l_data_source varchar2(3000);
BEGIN

    FOR REC IN(
                SELECT ROWNUM STT, A1.CDCONTENT IO, 'SHBKVNVXCUS' OUTBIC, CF.SWIFTCODE THEIRBIC,
                   CRB.MSGCODE MTTYPE, CRB.REFTXNUM REF, CRB.CBREQKEY RLREF, CRB.CREATEDATE CREATEDATE,
                   '' RLCONTENT, '' REMARK
                FROM CRBLOG CRB,CFMAST CF, ALLCODE A1
                    WHERE   CRB.MSGTYPE = 'ST'
                        AND CF.CIFID = CRB.CIFID (+)
                        AND A1.CDNAME = 'MTTYPE' AND A1.CDTYPE = 'CF' AND A1.CDVAL  = CRB.IORO
                        AND CRB.TXDATE BETWEEN TO_CHAR(p_date_from,'YYYYMMDD') AND TO_CHAR(p_date_to,'YYYYMMDD')
                ORDER BY STT

    ) LOOP
            l_data_source:='select '''||rec.STT||''' p_stt, '''||rec.IO||''' p_io, '''||rec.OUTBIC||''' p_outbic, '''||rec.THEIRBIC||''' p_theirbic, '''
                            ||rec.MTTYPE||''' p_mttype, '''|| rec.REF ||''' p_ref, '''|| rec.RLREF||''' p_rlref, '''
                            ||TO_DATE(rec.CREATEDATE,'DD/MM/RRRR')||' p_createdate, '''||rec.RLCONTENT||''' p_rlcontent, '''
                            ||rec.REMARK||''' p_remark from dual ';
            NMPKS_EMS.PR_SENDINTERNALEMAIL(L_DATA_SOURCE, '202E', '','N');
    END LOOP;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
