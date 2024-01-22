SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendsms_fromsystem (
   p_err_code   out VARCHAR2 ,
   FRMDATE          IN       VARCHAR2,
   TODATE           IN       VARCHAR2,
   RETURNTRADE      IN       VARCHAR2,
   SMSCUSTOM        IN       VARCHAR2,
   TYPESMS          IN       VARCHAR2
      )
IS
v_strTemplate VARCHAR2(10);
v_strFrmDate VARCHAR2(20);
v_strToDate VARCHAR2(20);
v_strReturnTrade VARCHAR2(20);
v_strSmsCustom VARCHAR2(1000);
l_datasource VARCHAR2(1000);
BEGIN

v_strTemplate :=TYPESMS;
v_strFrmDate :=FRMDATE;
v_strToDate :=TODATE ;
v_strReturnTrade :=RETURNTRADE;
v_strSmsCustom :=SMSCUSTOM;

INSERT INTO SMSLISTLOG(AUTOID,FRMDATE,TODATE,RETURNTRADE,CREATEDATE,TYPESMS)
VALUES(smslistlog_seq.NEXTVAL,v_strFrmDate,v_strToDate,v_strReturnTrade,SYSDATE,v_strTemplate);

FOR rec IN
    (
        SELECT cf.fullname, cf.custodycd, cf.mobilesms, max(af.acctno) afacctno
            FROM  vw_cfmast_sms cf, afmast af
        WHERE cf.custid = af.custid
            and cf.mobilesms is not null
        group by cf.fullname, cf.custodycd, cf.mobilesms
    )
LOOP
        If v_strTemplate  = '336A' THEN
            l_datasource := /*'PHS-TB: Ngay le Giai Phong Mien Nam va Quoc Te Lao Dong, PHS nghi G.dich tu ' || v_strFrmDate || ' den ' ||
                        v_strToDate || ', G.dich lai vao ' ||
                        v_strReturnTrade || '. Tran trong thong bao!';*/
                        'PHS-TB: Ngay le Giai Phong Mien Nam va QTLD, PHS nghi GD tu ' || v_strFrmDate || ' den ' || v_strToDate || ' va GD tro lai vao ngay ' || v_strReturnTrade || '. Chuc Quy nha dau tu nghi le vui ve.';
        ELSIF v_strTemplate  = '336B' THEN
            l_datasource := 'PHS-TB: PHS nghi tet Am lich tu ' || v_strFrmDate || ' den het ' || v_strToDate || '. Giao dich tro lai vao ' || v_strReturnTrade || '. Chuc Quy nha dau tu Nam moi nhieu May man va Thanh cong.' ;
        ELSIF v_strTemplate  = '336C' THEN
            l_datasource := 'PHS-TB: PHS nghi G.dich Tet Duong Lich tu ' || v_strFrmDate || ' den ' || v_strToDate || '. G.dich tro lai vao ' || v_strReturnTrade || '. Chuc Quy nha dau tu Nam moi nhieu May man va Thanh cong.';
        ELSIF v_strTemplate  = '336D' THEN
            l_datasource := 'PHS-TB: Ngay Quoc Khanh 2/9, PHS nghi giao dich tu ' || v_strFrmDate || ' den ' || v_strToDate || ' va giao dich tro lai vao ngay ' || v_strReturnTrade || '. Chuc Quy nha dau tu nghi le vui ve.';
        Else
            l_datasource := v_strSmsCustom;
        End If;

        --INSERT INTO EMAILLOG(autoid,email,templateid,datasource,status,createtime, txdate)
        --VALUES(seq_emaillog.nextval,rec.mobilesms,v_strTemplate,l_datasource,'A',SYSDATE, getcurrdate);
        nmpks_ems.InsertEmailLog(rec.mobilesms, v_strTemplate, l_datasource, rec.afacctno);

    END LOOP;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
 
 
/
