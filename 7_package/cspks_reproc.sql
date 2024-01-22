SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_reproc
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
 PROCEDURE pr_reCALREVENUE(p_bchmdl varchar,p_err_code  OUT varchar2);
 PROCEDURE re_change_cfstatus_af;
 PROCEDURE re_change_cfstatus_bf;
 PROCEDURE re_changerev(acclist in  varchar2,rate in varchar2,gor in varchar2,ip in varchar2, tlid in varchar2, brid varchar2);
 FUNCTION fn_re_getcommision(strACCTNO IN varchar2, p_BASEDACR number, P_REVENUE NUMBER)  RETURN  number;
 FUNCTION fn_re_gettax(strcustid IN varchar2, p_BASEDACR number)  RETURN  number;
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_reproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_OpenLoanAccount------------------------------------------------
FUNCTION fn_re_icrate(strACCTNO IN varchar2, p_BASEDACR number, P_REVENUE NUMBER)
  RETURN  number
  IS
  l_COMMISION  number(20,4);
  l_BASEDACR  number(20,4);
  l_AUTOID    number(20,0);
  l_ACTYPE    VARCHAR2(4);
  l_RULETYPE  VARCHAR2(10);
  l_PERIOD    VARCHAR2(10);
  l_ICTYPE    VARCHAR2(10);
  l_DELTA    number(20,4);
  l_FLAT    number(20,4);
  l_ICRATE    number(20,4);
  l_MINVAL    number(20,4);
  l_MAXVAL    number(20,4);
  l_FLRATE    number(20,4);
  l_CERATE    number(20,4);
  v_baseacr number(20,4);
  v_revenue number(20,4);
  l_result number(20,4);
BEGIN
  l_result :=0;
  l_BASEDACR:=p_BASEDACR;
    --GET REMAST ATRIBUTES
    SELECT  TYP.ACTYPE,
    IC.AUTOID, IC.RULETYPE, IC.PERIOD, IC.ICTYPE, IC.ICFLAT, IC.ICRATE, IC.MINVAL, IC.MAXVAL, IC.FLRATE, IC.CERATE
    into  l_ACTYPE, l_AUTOID, l_RULETYPE, l_PERIOD, l_ICTYPE, l_FLAT, l_ICRATE, l_MINVAL, l_MAXVAL, l_FLRATE, l_CERATE
    FROM REMAST MST, RETYPE TYP, ICCFTYPEDEF IC
  WHERE MST.ACCTNO = strACCTNO AND MST.ACTYPE=TYP.ACTYPE
    AND IC.MODCODE='RE' AND IC.EVENTCODE='CALFEECOMM' AND IC.ICCFSTATUS='A' AND IC.ACTYPE=MST.ACTYPE;

  if l_RULETYPE='S' OR l_RULETYPE='F' then
            if l_ICTYPE='F' then
              l_result := l_FLAT;
            elsif l_ICTYPE='P' then
              l_result := l_ICRATE;
            end if;
  elsif l_RULETYPE='T' then
      l_DELTA:=0;
       Begin
        SELECT DELTA INTO l_DELTA
        FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
          AND ACTYPE=l_ACTYPE AND l_BASEDACR>=FRAMT AND l_BASEDACR<=TOAMT;
       EXCEPTION
       when OTHERS then
           l_DELTA:=0;
       End;

        l_result := (l_ICRATE+l_DELTA);


  elsif l_RULETYPE='C' then
         v_baseacr:=p_BASEDACR;
         v_revenue:=P_REVENUE;
         l_COMMISION:=0;
         l_DELTA:=0;
         Begin
             SELECT count(1) into  l_DELTA
             FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
             AND ACTYPE=l_ACTYPE;
         EXCEPTION
         when OTHERS then
           l_DELTA:=0;
         End;

         IF l_DELTA=0 then -- khong khai bao tier
             l_result:= l_ICRATE;
         Else
             For vc in(SELECT framt, toamt,delta
                       FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
                       AND ACTYPE=l_ACTYPE
                       --and framt >=p_BASEDACR
                       ORDER BY framt ) loop
                 If v_baseacr >0  then
                    l_result:=(l_ICRATE+vc.DELTA);
                    v_baseacr:=v_baseacr-least(v_baseacr,vc.toamt  - vc.framt);
                 End if;
             End loop;
         end if;
  end if;

    RETURN l_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;

  PROCEDURE pr_reCALREVENUE(p_bchmdl varchar,p_err_code  OUT varchar2)
  IS
    v_currdate date;
    v_err VARCHAR2(10);
    v_rfmatchamt number(20,4);
    v_rffeeacr number(20,4);
    v_rffeecomm number(20,4);
    v_matchamt number(20,4);
    v_feeacr number(20,4);
    v_lmn number(20,4);
    v_DISPOSAL number(20,4);
    v_FEEDISPOSAL number(20,4);
    v_RCALLCENTER number(20,4);
    v_RFEECALLCENTER number(20,4);
    v_autoid number;
    v_RFEEBONDTYPETP number(20,4);
    v_RBONDTYPETP number(20,4);
    V_FIRSTDAY DATE;
    v_ICRATE number;
    v_careby varchar2(4);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_reCALREVENUE');
     -- Tinh Doanh so hang ngay cho moi gioi
    Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
    From sysvar
    Where varname='CURRDATE';

    RE_change_cfstatus_BF;



--- chuyen cham soc ho va chuyen care by tu dong duoc thuc hien cuoi cung o buoc xu ly hang ngay
 --Cap nhat lai tk khach hang cu khi het han cua csh
   /* for rec in
    (
        SELECT afacctno,todate   ---TK KHACH HANG DANG DC CHAM SOC HO
        from reaflnk rl,RETYPE TYP
        where substr(reacctno,11,4)=typ.actype AND TYP.REROLE='DG' and todate=getcurrdate and rl.status='A'
    )
    loop
        begin
            -- UPDATE TRANG THAI moi gioi cu --> A
            UPDATE reaflnk set STATUS ='A'
            where todate > rec.todate and frdate <= rec.todate
                AND  status='C' AND afacctno =rec.afacctno AND clstxdate IS NULL
                  and substr(reacctno,11,4) in (select actype from RETYPE where REROLE<>'DG') and rownum=1;
        end;
    end loop;*/



/*---locpt --> move doan xuong cuoi ham vi se chuyen mgtl vao cuoi ngay de co the careby KH vao dau ngay hsau
 --Cap nhat  lai REAFLNK khi den ngay chuyen tk mg tuong lai
    UPDATE REAFLNK SET PSTATUS=PSTATUS||STATUS,CLSTXDATE=getcurrdate,STATUS='A'--,CLSTXNUM= p_txmsg.txnum
    WHERE getbusinessdate(FRDATE) = getcurrdate AND STATUS='C' and clstxdate is null and clstxnum is null;
    UPDATE REAFLNK SET PSTATUS=PSTATUS||STATUS,CLSTXDATE=getcurrdate,STATUS='C'--,CLSTXNUM= p_txmsg.txnum
    WHERE getbusinessdate(TODATE) = getcurrdate AND STATUS='A';

    --Log lai thong tin Moi gioi gan vao phong
    delete from recfingrp_log where txdate=TO_DATE(v_currdate,'DD/MM/RRRR');
    insert into recfingrp_log(txdate,reacctno,recustid,grpid,grpcode,leadercustid,qlmg)
    SELECT txdate,reacctno,recustid,grpid,grpcode,leadercustid,qlmg
    FROM vw_recfingrp;


     for rec1 in
    (
        select CF.custid,  nvl(RE.fcareby,'0') careby
        from REAFLNK RE, AFMAST AF, CFMAST CF
         WHERE getbusinessdate(RE.FRDATE) = getcurrdate AND RE.STATUS='A' and  RE.clstxnum is null
          and RE.AFACCTNO = AF.ACCTNO
          and AF.CUSTID = CF.CUSTID
    )
    loop
    begin
        --locpt cap nhat thong tin careby tu dong
        if(rec1.careby <> '0') then
        begin
                -- Lay thong tin cu truoc khi cap nhat de so sanh
                SELECT cf.careby
                 INTO v_careby
                 FROM cfmast cf
                WHERE custid = rec1.custid;

                 -- GHI NHAN BANG LOG THAY DOI
                IF v_careby <> rec1.careby THEN
                    INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,
                        COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
                    VALUES('CFMAST','CUSTID = ''' || rec1.custid || '''','0000' ,v_currdate,'Y','0000',
                    v_currdate,1,'careby',v_careby,rec1.careby,'EDIT',NULL,NULL,to_char(sysdate,'hh24:mm:ss'));
                END IF;

               --cap nhat care by
               UPDATE CFMAST SET CAREBY = rec1.careby where CUSTID=rec1.custid;
       end;
       end if;

       --end locpt---------------------------------
    end;
    end loop;
-----end remove-------*/



    --Backup reinttran sang reinttrana
    INSERT INTO REINTTRANA
    SELECT * FROM REINTTRAN
    WHERE TODATE<=TO_DATE(v_currdate,'DD/MM/RRRR');
    DELETE FROM REINTTRAN
    WHERE TODATE<=TO_DATE(v_currdate,'DD/MM/RRRR');
    --Cap nhat lai REMAST

  insert into remast_hist
    select TO_DATE(v_currdate,'DD/MM/RRRR'),h.* from remast h where status = 'A';

  UPDATE REMAST SET DAMTACR=0, IAMTACR=0, DFEEACR=0, IFEEACR=0, drfmatchamt=0, drffeeacr=0, dlmn=0, ddisposal=0,drcallcenter=0,drfeecallcenter=0,DRFFEECOMM=0,
              DRBONDTYPETP=0,DRFEEBONDTYPETP=0, DFEEDISPOSAL = 0
    WHERE STATUS='A';




    --- Tinh doanh so, doanh thu truc tiep: gop theo custid thay vi afacctno
     Delete reinttrantemp;
     -- Tinh cong don doanh so, doanh thu truc tiep vao bang tam
     For vc in
            (Select ret.RCALLCENTER,od.VIA,ret.actype,sb.sectype,sb.tradeplace, re.refrecflnkid, re.reacctno,
                    sum(od.execamt) matchamt,
                    sum(od.feeacr) feeacr,
                    sum(od.feeacr) feeOD,
                    max(rem.DAMTLASTDT) DAMTLASTDT,
                    max(ret.odfeetype) odfeetype,
                    max(ret.odfeerate) odfeerate
            From reaflnk re, afmast af, vw_odmast_all od, recfdef red, retype ret, remast rem, sbsecurities sb
            Where re.status='A' and re.deltd<>'Y'
                and re.frdate<= v_currdate and v_currdate <= re.todate
                and od.deltd<>'Y' and od.txdate = v_currdate and od.execamt >0
                and re.afacctno=af.custid and af.acctno=od.afacctno
                and re.refrecflnkid = red.refrecflnkid
                and substr(re.reacctno,11,4)=red.reactype
                and red.effdate<= v_currdate and  v_currdate < red.expdate
                and red.reactype=ret.actype
                and ret.retype='D'
                and re.reacctno=rem.acctno
                and sb.codeid=od.codeid
                AND rem.status = 'A'
                and (red.status<>'C' OR red.status IS NULL)
            Group by ret.actype, sb.sectype, sb.tradeplace, re.refrecflnkid, re.reacctno,ret.RCALLCENTER,od.VIA
            order by re.refrecflnkid,ret.actype,re.reacctno,sb.tradeplace,sb.sectype)
     LOOP
        v_ICRATE :=fn_re_icrate(vc.reacctno,vc.feeacr,vc.feeacr);

     ---locpt chinh theo PHS dua het tat ca   vc.matchamt,      VC.FEEACR --> t? toan o ben tren de dong nhat 1 cho
       Select  nvl(SUM( DECODE(RF.CALTYPE,'0001',RF.RERFRATE,0)* vc.matchamt /100),0),  --  GIAM TRU DOANH SO
                nvl(SUM( DECODE(RF.CALTYPE,'0002',RF.RERFRATE,0)
                          *  VC.feeOD /100),0), --  GIAM TRU DOANH thu
               0 --  GIAM TRU HOA HONG
                INTO v_rfmatchamt, v_rffeeacr, v_rffeecomm

        From
            --phan loai chung khoan: SUA THEO PHAN LOAI MOI BSC: CP/CCQ, TRAI PHIEU, ALL, OTHER
            (Select rerftype, caltype, min(stt) stt
            From(
                    Select rf.*,
                            (CASE
                                WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                                WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                                WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                                WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3 END) STT
                    From rerfee rf
                    Where rf.refobjid=VC.ACTYPE
                        and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000')
                        AND (RF.SYMTYPE='000' OR
                            (CASE
                                WHEN vc.sectype='001' OR vc.sectype='002' OR vc.sectype='111' THEN 'EQT'
                                WHEN vc.sectype='003' OR vc.sectype='006' OR vc.sectype='222' THEN 'DEB'
                                WHEN vc.sectype='000' THEN '000' ELSE 'OTH' END) = RF.SYMTYPE
                            )
                )
            Group by rerftype,caltype) A, Rerfee rf,ICCFTYPEDEF icc
            Where A.rerftype=rf.rerftype and A.caltype=rf.caltype
            AND ICC.MODCODE='RE' AND ICC.EVENTCODE='CALFEECOMM' AND ICC.ICCFSTATUS='A' AND ICC.ACTYPE=RF.REFOBJID
            and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000' )
            AND (RF.SYMTYPE='000' OR
                (CASE
                    WHEN vc.sectype='001' OR vc.sectype='002' OR vc.sectype='111' THEN 'EQT'
                    WHEN vc.sectype='003' OR vc.sectype='006' OR vc.sectype='222' THEN 'DEB'
                    WHEN vc.sectype='000' THEN '000' ELSE 'OTH' END) = RF.SYMTYPE
                )
            and rf.refobjid=vc.actype
            and (CASE
                    WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                    WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                    WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                    WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3 END) = A.stt
             and rf.affectdate <= v_currdate
          --  AND VC.SECTYPE not IN ('003','006')
            ;

            Insert into reinttrantemp(actype, tradeplace, sectype, acctno, matchamt, feeacr, rfmatchamt, rffeeacr, DAMTLASTDT,rffeecomm)
            values(vc.actype, vc.tradeplace, vc.sectype, vc.reacctno, vc.matchamt, vc.feeacr, v_rfmatchamt, v_rffeeacr, vc.DAMTLASTDT,v_rffeecomm);

            Insert into reinttrantemp_LOG(actype, tradeplace, sectype, acctno, matchamt, feeacr, rfmatchamt, rffeeacr, DAMTLASTDT,rffeecomm)
            values(vc.actype, vc.tradeplace, vc.sectype, vc.reacctno, vc.matchamt, vc.feeacr, v_rfmatchamt, v_rffeeacr, vc.DAMTLASTDT,v_rffeecomm);
    End loop;


    -- Cap nhat vao REMAST: doanh so/doanh thu truc tiep
    For vc in
         (Select acctno,
            sum(matchamt) matchamt,
            sum(feeacr) feeacr,
            sum(rfmatchamt) rfmatchamt,
            sum(rffeeacr) rffeeacr,
            max(damtlastdt) damtlastdt,
            sum(RFFEECOMM) RFFEECOMM
        From reinttrantemp
        Group by acctno)
    Loop
        -- Tinh tong gia tri phat vay bao lanh
        v_lmn:= 0;

        -- Tinh tong gia tri lenh giai chap
        v_DISPOSAL:= 0;
        v_FEEDISPOSAL:=0;

        -- Tinh tong gia tri lenh dat qua callcenter
        v_RCALLCENTER := 0;
        v_RFEECALLCENTER := 0;
        Select  nvl(sum(od.execamt),0),nvl(sum(od.feeacr),0) into v_RCALLCENTER,v_RFEECALLCENTER
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af
        Where  od.txdate = v_currdate
        and od.deltd <>'Y'
        and od.VIA = 'T'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and typ.RCALLCENTER='Y'
        and rl.reacctno=vc.acctno
        and od.orderid not in
            (
                    Select  od.orderid
                    From vw_odmast_all od, reaflnk rl, retype typ, afmast af,sbsecurities SB
                    Where  od.txdate = v_currdate
                    AND OD.codeid=SB.CODEID
                    AND SB.TRADEPLACE='010'
                    and od.deltd <>'Y'
                    and od.afacctno = af.acctno and af.custid = rl.afacctno
                    and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
                    and substr(rl.reacctno,11,4) = typ.actype
                    and rl.reacctno=vc.acctno
            );

       /* -- Tinh tong phi lenh dat qua callcenter
        v_RFEECALLCENTER := 0;
        Select  nvl(sum(od.feeacr),0) into v_RFEECALLCENTER
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af
        Where  od.txdate = v_currdate
        and od.deltd <>'Y'
        and od.VIA = 'T'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and typ.RCALLCENTER='Y'
        and rl.reacctno=vc.acctno;*/

        -- Tinh tong gia tri dat lenh trai phieu chinh phu
        v_RBONDTYPETP := 0;
        Select  nvl(sum(od.execamt),0) into v_RBONDTYPETP
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af,sbsecurities SB
        Where  od.txdate = v_currdate
        AND OD.codeid=SB.CODEID
        AND typ.rbond = 'Y'   -- cau hinh trong loai hinh
        AND SB.TRADEPLACE='010'
        and od.deltd <>'Y'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and rl.reacctno=vc.acctno;

        -- Tinh tong gia tri PHI dat lenh trai phieu chinh phu
        v_RFEEBONDTYPETP := 0;
        Select  nvl(sum(od.feeacr),0) into v_RFEEBONDTYPETP
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af,sbsecurities SB
        Where  od.txdate = v_currdate
        AND OD.codeid=SB.CODEID
        AND typ.rbond = 'Y'    -- cau hinh trong loai hinh
        AND SB.TRADEPLACE='010'
        and od.deltd <>'Y'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and rl.reacctno=vc.acctno;



        Insert into reinttran(autoid, acctno, inttype, frdate, todate, icrule,irrate, intbal, intamt,rfmatchamt,rffeeacr,lmn,disposal,RCALLCENTER,RFEECALLCENTER,RFFEECOMM,RBONDTYPETP,RFEEBONDTYPETP)
        values(SEQ_REINTTRAN.NEXTVAL,vc.acctno,'DBR',vc.DAMTLASTDT,v_currdate, 'S',1,vc.matchamt-v_RCALLCENTER-v_RBONDTYPETP,vc.feeacr-v_RFEECALLCENTER-v_RFEEBONDTYPETP,vc.rfmatchamt,vc.rffeeacr,v_lmn,v_disposal,v_RCALLCENTER,v_RFEECALLCENTER,vc.RFFEECOMM,v_RBONDTYPETP,v_RFEEBONDTYPETP);


        Update remast
        Set damtacr = vc.matchamt-v_RCALLCENTER-v_RBONDTYPETP -v_DISPOSAL, -- Doanh so trong ngay
            dfeeacr = vc.feeacr-v_RFEECALLCENTER-v_RFEEBONDTYPETP- v_FEEDISPOSAL ,   -- Doanh thu trong ngay
            directacr = nvl(directacr,0) + vc.matchamt-v_RCALLCENTER-v_RBONDTYPETP- v_DISPOSAL , -- Doanh so luy ke
            directfeeacr = nvl(directfeeacr,0) + vc.feeacr-v_RFEECALLCENTER-v_RFEEBONDTYPETP-v_FEEDISPOSAL , -- Doanh thu luy ke
            damtlastdt = v_currdate,
            drfmatchamt = vc.rfmatchamt, -- Giam tru doanh so trong ngay
            drffeeacr   = vc.rffeeacr,   -- Giam tru doanh thu trong ngay
            rfmatchamt = nvl(rfmatchamt,0) + vc.rfmatchamt, -- Giam tru doanh so luy ke
            rffeeacr   = nvl(rffeeacr,0) +  vc.rffeeacr ,    -- Giam tru doanh thu luy ke
            dlmn = v_lmn, -- Gia tri phat vay bao lanh trong ngay
            lmn = nvl(lmn,0) + v_lmn , -- Gia tri phat vay bao lanh luy ke
            ddisposal = v_DISPOSAL , -- Tong gia tri lenh giai chap trong ngay
            disposal = nvl(disposal,0) + v_DISPOSAL, -- Tong gia tri lenh giai chap luy ke
            FEEDISPOSAL = nvl(FEEDISPOSAL,0) + v_FEEDISPOSAL, -- Tong gia tri phi lenh giai chap luy ke
            DFEEDISPOSAL =  v_FEEDISPOSAL, -- Tong gia tri phi lenh giai chap trong ngau
            DRCALLCENTER = v_RCALLCENTER , -- Tong gia tri lenh callcenter trong ngay
            RCALLCENTER = nvl(RCALLCENTER,0) + v_RCALLCENTER, -- Tong gia tri lenh callcenter luy ke
            DRFEECALLCENTER =  v_RFEECALLCENTER,-- Tong gia tri PHI callcenter trong ngay
            RFEECALLCENTER = nvl(RFEECALLCENTER,0) + v_RFEECALLCENTER, -- Tong gia tri PHI callcenter luy ke
           -- DRFFEECOMM =  vc.RFFEECOMM,-- Giam tru HH trong ngay
          --  RFFEECOMM = nvl(RFFEECOMM,0) +  vc.RFFEECOMM, -- Giam tru HH luy ke
            DRBONDTYPETP = v_RBONDTYPETP,--Tong gia tri trai phieu trong ngay
            DRFEEBONDTYPETP = v_RFEEBONDTYPETP,--Tong gia tri PHI trai phieu trong ngay
            RBONDTYPETP = NVL(RBONDTYPETP,0)+v_RBONDTYPETP,--Tong gia tri trai phieu LUY KE
            RFEEBONDTYPETP = NVL(RFEEBONDTYPETP,0)+v_RFEEBONDTYPETP--Tong gia tri PHI trai phieu LUY KE

        where acctno=vc.acctno AND status = 'A';


    End loop;
    --ket thuc tinh doanh so truc tiep

    --Tinh doanh so, doanh thu gian tiep
    For VC in (
        Select rg.custid||rg.actype reacctno,
            rgl.DAMTACR,
            rgl.dfeeacr,
            rgl.drfmatchamt,
            rgl.drffeeacr,
            rgl.dlmn,
            rgl.ddisposal,
            rgl.dfeedisposal ,
            rgl.drffeecomm,
            v_currdate IAMTLASTDT,
            rgl.DRCALLCENTER , -- Tong gia tri lenh callcenter trong ngay
            rgl.RCALLCENTER, -- Tong gia tri lenh callcenter luy ke
            rgl.DRFEECALLCENTER,-- Tong gia tri PHI callcenter trong ngay
            rgl.RFEECALLCENTER , -- Tong gia tri PHI callcenter luy ke
            rgl.RFFEECOMM, -- Giam tru HH luy ke
            rgl.DRBONDTYPETP,--Tong gia tri trai phieu trong ngay
            rgl.DRFEEBONDTYPETP,--Tong gia tri PHI trai phieu trong ngay
            rgl.RBONDTYPETP,--Tong gia tri trai phieu LUY KE
            rgl.RFEEBONDTYPETP--Tong gia tri PHI trai phieu LUY KE
        From REGRP rg,
            (Select rgl.refrecflnkid,
            sum(rm.DAMTACR) DAMTACR,
            sum(rm.dfeeacr)dfeeacr,
                    sum(rm.drfmatchamt) drfmatchamt,
                    sum(rm.drffeeacr) drffeeacr,
                    sum(rm.dlmn) dlmn,
                    sum(rm.ddisposal)  ddisposal,
                    sum(rm.dfeedisposal)  dfeedisposal,
                    sum(rm.drffeecomm) drffeecomm,
                    sum(DRCALLCENTER) DRCALLCENTER , -- Tong gia tri lenh callcenter trong ngay
            sum(rm.RCALLCENTER) RCALLCENTER, -- Tong gia tri lenh callcenter luy ke
            sum(DRFEECALLCENTER) DRFEECALLCENTER,-- Tong gia tri PHI callcenter trong ngay
            sum(RFEECALLCENTER) RFEECALLCENTER , -- Tong gia tri PHI callcenter luy ke
            sum(RFFEECOMM) RFFEECOMM, -- Giam tru HH luy ke
            sum(DRBONDTYPETP) DRBONDTYPETP,--Tong gia tri trai phieu trong ngay
            sum(DRFEEBONDTYPETP) DRFEEBONDTYPETP,--Tong gia tri PHI trai phieu trong ngay
            sum(RBONDTYPETP) RBONDTYPETP,--Tong gia tri trai phieu LUY KE
            sum(RFEEBONDTYPETP) RFEEBONDTYPETP--Tong gia tri PHI trai phieu LUY KE
            From REGRPLNK rgl, remast rm, retype ret
            where rgl.reacctno=rm.acctno
                and rgl.frdate<=v_currdate and v_currdate<=rgl.todate
                and rgl.deltd<>'Y'
                and rgl.status='A'
                and rm.status='A'
                and rm.actype=ret.actype
                and ret.retype='D' and ret.rerole in ('TR','RM','BM','RD','DG')

            Group by  rgl.refrecflnkid) rgl
            Where SP_FORMAT_REGRP_MAPCODE( rgl.refrecflnkid) like SP_FORMAT_REGRP_MAPCODE(rg.autoid)||'%'
                AND rgl.DAMTACR + rgl.dfeeacr + rgl.drfmatchamt + rgl.drffeeacr + rgl.dlmn + rgl.ddisposal+rgl.drffeecomm > 0
                and rg.grptype='M'
     )
     Loop

        Insert into reinttran(autoid, acctno, inttype, frdate, todate,
                    icrule,irrate, intbal, intamt,rfmatchamt,rffeeacr,lmn,disposal,rffeecomm)
        values(SEQ_REINTTRAN.NEXTVAL,vc.reacctno,'IBR',vc.IAMTLASTDT,v_currdate,
                    'S',1,vc.DAMTACR,vc.dfeeacr,vc.drfmatchamt,vc.drffeeacr, vc.dlmn, vc.ddisposal,vc.drffeecomm);
        Update remast
        Set iamtacr = nvl(iamtacr,0) + vc.DAMTACR,
            ifeeacr = nvl(ifeeacr,0) + vc.dfeeacr,
            indirectacr = nvl(indirectacr,0) + vc.DAMTACR,
            indirectfeeacr = nvl(indirectfeeacr,0) + vc.dfeeacr,
            IAMTLASTDT = v_currdate,
            inrfmatchamt = nvl(inrfmatchamt,0) + vc.drfmatchamt,
            inrffeeacr = nvl(inrffeeacr,0) + vc.drffeeacr,
            inlmn = nvl(inlmn,0) + vc.dlmn,
            indisposal = nvl(indisposal,0) + vc.ddisposal,
            ifeedisposal = nvl(ifeedisposal,0) + vc.dfeedisposal,
            --INRFFEECOMM = nvl(inrffeecomm,0) + vc.drffeecomm, --giam tru HH,
            DRCALLCENTER = vc.DRCALLCENTER, -- Tong gia tri lenh callcenter trong ngay
            RCALLCENTER = nvl(RCALLCENTER,0) + vc.RCALLCENTER, -- Tong gia tri lenh callcenter luy ke
            DRFEECALLCENTER =  vc.DRFEECALLCENTER,-- Tong gia tri PHI callcenter trong ngay
            RFEECALLCENTER = nvl(RFEECALLCENTER,0) + vc.RFEECALLCENTER, -- Tong gia tri PHI callcenter luy ke
           -- RFFEECOMM = nvl(RFFEECOMM,0) +  vc.RFFEECOMM, -- Giam tru HH luy ke
            DRBONDTYPETP = vc.RBONDTYPETP,--Tong gia tri trai phieu trong ngay
            DRFEEBONDTYPETP =  vc.RFEEBONDTYPETP,--Tong gia tri PHI trai phieu trong ngay
            RBONDTYPETP = NVL(RBONDTYPETP,0)+vc.RBONDTYPETP,--Tong gia tri trai phieu LUY KE
            RFEEBONDTYPETP = NVL(RFEEBONDTYPETP,0)+vc.RFEEBONDTYPETP--Tong gia tri PHI trai phieu LUY KE

        where acctno=vc.reacctno AND status = 'A';
    End loop;

    --Tinh doanh so, doanh thu nguoi gioi thieu
    For VC in (
        Select rg.custid||rg.actype reacctno,
            rgl.DAMTACR,
            rgl.dfeeacr,
            rgl.drfmatchamt,
            rgl.drffeeacr,
            rgl.dlmn,
            rgl.ddisposal,
            rgl.dfeedisposal,
            rgl.drffeecomm,
            v_currdate IAMTLASTDT
        From REGRP rg,
            (Select rgl.refrecflnkid,
            sum(rm.DAMTACR) DAMTACR,
            sum(rm.dfeeacr)dfeeacr,
                    sum(rm.drfmatchamt) drfmatchamt,
                    sum(rm.drffeeacr) drffeeacr,
                    sum(rm.dlmn) dlmn,
                    sum(rm.ddisposal)  ddisposal,
                     sum(rm.dfeedisposal)  dfeedisposal,
                    sum(rm.drffeecomm) drffeecomm
            From REGRPLNK rgl, remast rm, retype ret
            where rgl.reacctno=rm.acctno
                and rgl.frdate<=v_currdate and v_currdate<=rgl.todate
                and rgl.deltd<>'Y'
                and rgl.status='A'
                and rm.status='A'
                and rm.actype=ret.actype
                and ret.retype='D' and ret.rerole in ('RD')
            Group by  rgl.refrecflnkid) rgl
            Where SP_FORMAT_REGRP_MAPCODE( rgl.refrecflnkid) like SP_FORMAT_REGRP_MAPCODE(rg.autoid)||'%'
                AND rgl.DAMTACR + rgl.dfeeacr + rgl.drfmatchamt + rgl.drffeeacr + rgl.dlmn + rgl.ddisposal +rgl.drffeecomm > 0
                and rg.grptype='R'
     )
     Loop

        Insert into reinttran(autoid, acctno, inttype, frdate, todate,
                    icrule,irrate, intbal, intamt,rfmatchamt,rffeeacr,lmn,disposal,rffeecomm)
        values(SEQ_REINTTRAN.NEXTVAL,vc.reacctno,'IBR',vc.IAMTLASTDT,v_currdate,
                    'S',1,vc.DAMTACR,vc.dfeeacr,vc.drfmatchamt,vc.drffeeacr, vc.dlmn, vc.ddisposal,vc.drffeecomm);
        Update remast
        Set iamtacr = nvl(iamtacr,0) + vc.DAMTACR,
            ifeeacr = nvl(ifeeacr,0) + vc.dfeeacr,
            indirectacr = nvl(indirectacr,0) + vc.DAMTACR,
            indirectfeeacr = nvl(indirectfeeacr,0) + vc.dfeeacr,
            IAMTLASTDT = v_currdate,
            inrfmatchamt = nvl(inrfmatchamt,0) + vc.drfmatchamt,
            inrffeeacr = nvl(inrffeeacr,0) + vc.drffeeacr,
            inlmn = nvl(inlmn,0) + vc.dlmn,
            indisposal = nvl(indisposal,0) + vc.ddisposal,
            ifeedisposal=nvl(ifeedisposal,0) + vc.dfeedisposal
--            ,INRFFEECOMM = nvl(inrffeecomm,0) + vc.drffeecomm --giam tru HH
        where acctno=vc.reacctno AND status = 'A';
    End loop;

   /* ---- Tinh Doanh so cho MG cham so ho
    For vc in(
        Select  re.refrecflnkid, re.reacctno,re.orgreacctno,
                sum(od.execamt) matchamt, sum(od.feeacr) feeacr,
                max(rem.DAMTLASTDT) DAMTLASTDT
        From reaflnk re, vw_odmast_all od, afmast af, recfdef red, retype ret, remast rem
        Where re.status='A' and re.deltd<>'Y'
            and re.frdate<=v_currdate and v_currdate <= re.todate
            and od.deltd<>'Y'
            and od.txdate = v_currdate
            and re.afacctno=af.custid and af.acctno=od.afacctno
            and od.execamt >0
            and re.refrecflnkid = red.refrecflnkid
            and substr(re.reacctno,11,4)=red.reactype
            and red.effdate<= v_currdate and  v_currdate < red.expdate
            and red.reactype=ret.actype
            and ret.retype='D'
            and re.reacctno=rem.acctno
            AND rem.status = 'A' --AND red.status = 'A'
           -- and ((ret.rdisposal = 'N') or
           --     (ret.rdisposal = 'Y' and   od.ISDISPOSAL = 'N')
            --    )  -- khong tinh doanh so lenh xu ly
            --and (ret.RCALLCENTER='Y' AND od.VIA='T') --DINHNB khong tinh doanh so lenh call center
        and ret.rerole = 'DG'
        Group by re.refrecflnkid, re.reacctno,re.orgreacctno
        order by re.refrecflnkid,re.reacctno,re.orgreacctno)
    Loop
        -- Tinh tong gia tri phat vay bao lanh
        v_lmn:= 0;
        Select  nvl(sum(l.nml + l.ovd),0) into v_lmn
        From lnschd l, lnmast m, reaflnk rl, retype typ, afmast af
        Where l.reftype='GP'
        and l.rlsdate = v_currdate --(Select TO_DATE (varvalue, 'dd/mm/yyyy')    From sysvar    Where varname='CURRDATE')
        and l.acctno = m.acctno
        and m.trfacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and typ.rlmn='Y'
        and rl.reacctno=vc.reacctno
        and rl.orgreacctno = vc.orgreacctno;

        -- Tinh tong gia tri lenh giai chap
        v_DISPOSAL:= 0;
         v_FEEDISPOSAL:= 0;
        Select  nvl(sum(od.execamt),0),nvl(sum(od.feeamt),0) into v_DISPOSAL,v_FEEDISPOSAL
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af
        Where  od.txdate = v_currdate --(Select TO_DATE (varvalue, 'dd/mm/yyyy')    From sysvar    Where varname='CURRDATE')
        and od.deltd <>'Y'
        and od.isdisposal = 'Y'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and typ.rdisposal='Y'
        and rl.reacctno=vc.reacctno
        and rl.orgreacctno = vc.orgreacctno;

        -- Tinh tong gia tri lenh dat qua callcenter
        v_RCALLCENTER := 0;
        Select  nvl(sum(od.execamt),0) into v_RCALLCENTER
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af
        Where  od.txdate = v_currdate
        and od.deltd <>'Y'
        and od.VIA = 'T'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and typ.RCALLCENTER='Y'
        and rl.reacctno=vc.reacctno
        and rl.orgreacctno = vc.orgreacctno;

        -- Tinh tong gia tri PHI dat qua callcenter
        v_RFEECALLCENTER := 0;
        Select  nvl(sum(od.feeacr),0) into v_RFEECALLCENTER
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af
        Where  od.txdate = v_currdate
        and od.deltd <>'Y'
        and od.VIA = 'T'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and typ.RCALLCENTER='Y'
        and rl.reacctno=vc.reacctno
        and rl.orgreacctno = vc.orgreacctno;

                -- Tinh tong gia tri dat lenh trai phieu chinh phu
        v_RBONDTYPETP := 0;
        Select  nvl(sum(od.execamt),0) into v_RBONDTYPETP
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af,sbsecurities SB
        Where  od.txdate = v_currdate
        AND OD.codeid=SB.CODEID
        AND SB.TRADEPLACE='010'
        and od.deltd <>'Y'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and rl.reacctno=vc.reacctno
        and typ.rbond='Y'
        and rl.orgreacctno = vc.orgreacctno;

        -- Tinh tong gia tri PHI dat lenh trai phieu chinh phu
        v_RFEEBONDTYPETP := 0;
        Select  nvl(sum(od.feeacr),0) into v_RFEEBONDTYPETP
        From vw_odmast_all od, reaflnk rl, retype typ, afmast af,sbsecurities SB
        Where  od.txdate = v_currdate
        AND OD.codeid=SB.CODEID
        AND SB.TRADEPLACE='010'
        and od.deltd <>'Y'
        and od.afacctno = af.acctno and af.custid = rl.afacctno
        and rl.status='A' and rl.deltd<>'Y' and rl.frdate<= v_currdate and v_currdate <= rl.todate
        and substr(rl.reacctno,11,4) = typ.actype
        and rl.reacctno=vc.reacctno
        and typ.rbond='Y'
        and rl.orgreacctno = vc.orgreacctno;

        v_autoid:=0;

        For rec in (
            Select autoid
            From rerevdg r
            Where r.reacctno = vc.reacctno
                and r.orgreacctno = vc.orgreacctno
                and status = 'A'
                and commdate is null)
        Loop
            v_autoid:= rec.autoid;
        End loop;

        IF v_autoid = 0 THEN
            Insert into REREVDG(autoid , reacctno,orgreacctno, matchamt,feeacr, lmn,
                                disposal ,frdate, todate,commision , salary , commdate ,status,RCALLCENTER,RFEECALLCENTER,RBONDTYPETP,RFEEBONDTYPETP)
            values(seq_rerevdg.nextval,vc.reacctno,vc.orgreacctno,vc.matchamt-v_RCALLCENTER-v_RBONDTYPETP,vc.feeacr-v_RFEECALLCENTER-v_RFEEBONDTYPETP,v_lmn,
                                v_DISPOSAL,v_currdate,v_currdate,0,0,null,'A',v_RCALLCENTER,v_RFEECALLCENTER,v_RBONDTYPETP,v_RFEEBONDTYPETP);
        Else
            Update rerevdg
            Set matchamt = nvl(matchamt,0) + vc.matchamt-v_RCALLCENTER-v_RBONDTYPETP,
               feeacr = nvl(feeacr,0) + vc.feeacr-v_RFEECALLCENTER-v_RFEEBONDTYPETP,
               lmn = nvl(lmn,0) + v_lmn,
               disposal = nvl(disposal,0) + v_DISPOSAL,
               RCALLCENTER = nvl(RCALLCENTER,0) + v_RCALLCENTER,
               RFEECALLCENTER = nvl(RFEECALLCENTER,0) + v_RFEECALLCENTER,
               RBONDTYPETP = nvl(RBONDTYPETP,0) + v_RBONDTYPETP,
               RFEEBONDTYPETP = nvl(RFEEBONDTYPETP,0) + RFEEBONDTYPETP,
             --  feedisposal = nvl(feedisposal,0) + v_FEEDISPOSAL,
               todate = v_currdate
            Where autoid=v_autoid;
        End if;
     End loop;--Tinh Doanh so cho MG cham so ho*/
    ----tinh hoa hong du kien
    DELETE FROM reaf_log WHERE txdate = v_currdate;
    insert into reaf_log
    select substr(kh.reacctno,1,10) reacctno, substr(kh.reacctno,11,4) reactype,
    kh.afacctno afacctno, od.txdate, sum(od.EXECAMT) EXECAMT, sum(od.feeacr) feeacr
    FROM reaflnk kh, afmast af,
        (
            SELECT afacctno, txdate, execamt EXECAMT, feeacr FROM vw_odmast_all WHERE deltd <> 'Y' AND TXDATE = v_currdate
        ) OD
    WHERE OD.afacctno = af.acctno
        AND kh.frdate  <= OD.txdate
        AND kh.todate  >= OD.txdate
        AND kh.deltd <> 'Y'
        and kh.status = 'A'
        AND OD.txdate < nvl(kh.clstxdate ,'01-Jan-2222')
        AND af.custid = kh.afacctno
    group by substr(kh.reacctno,1,10) , substr(kh.reacctno,11,4) , kh.reacctno,
    kh.afacctno , od.txdate  ;




    pr_re_commision;


    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_reCALREVENUE');
EXCEPTION
WHEN OTHERS
THEN
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error (pkgctx, SQLERRM);
    plog.error (pkgctx, dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_reCALREVENUE');
    RAISE errnums.E_SYSTEM_ERROR;

  END pr_reCALREVENUE;

PROCEDURE re_change_cfstatus_af is
     v_currdate date;
     v_dmday number(10);
     v_check number(10);
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';
    Begin
        Select to_NUMBER(varvalue) into v_dmday
        From sysvar
        Where varname='DMDAY' and grname='SYSTEM';
    EXCEPTION
    when OTHERS then
        v_dmday:=360;
    End;
    /*
       -- Chuyen tu moi -> cu
          For vc in (Select cf.custodycd,cf.lastdate,cf.activedate,cf.dmsts,cf.afstatus
                From  CFmast cf
                Where  dmsts='N' and afstatus='N' and activedate + v_dmday + 1 <= v_currdate) loop

         Update Cfmast
         Set afstatus = 'O'
         where custodycd = vc.custodycd;
         insert into changecfstslog(txdate,custodycd,olddmsts,oldafstatus,oldlastdate,oldactivedate,
               newdmsts,newafstatus,newlastdate,newactivedate)
         values(v_currdate,vc.custodycd,vc.dmsts,vc.afstatus,vc.lastdate,vc.activedate,
               vc.dmsts,'O',vc.lastdate,vc.activedate);

          --Chuyen doi tk moi gioi cu/moi
          For rec in(SELECT r.autoid, r.txdate, r.txnum, r.refrecflnkid, r.reacctno,
                      r.afacctno, r.frdate, r.todate, r.deltd, r.clstxdate, r.clstxnum,
                      r.pstatus, r.status, r.furefrecflnkid, r.fureacctno
                      From reaflnk r,afmast af, cfmast cf, retype rty
                      WHERE r.status='A'
                      And r.afacctno= af.acctno
                      and af.custid=cf.custid
                      and substr(reacctno,11,4)=rty.actype
                      and rty.rerole in ('BM')
                      And cf.custodycd =  vc.custodycd)
         Loop
                   insert into reaflnk(autoid, txdate, txnum, refrecflnkid, reacctno,
                   afacctno, frdate, todate, deltd, clstxdate, clstxnum,
                   pstatus, status, furefrecflnkid, fureacctno)
                          values (seq_reaflnk.nextval,rec.txdate,rec.txnum,rec.furefrecflnkid,rec.fureacctno,
                   rec.afacctno,v_currdate,rec.todate,rec.deltd,null,null,
                   rec.pstatus,rec.status,rec.refrecflnkid,rec.reacctno);

                Update reaflnk
                Set  status='C',
                    clstxdate=v_currdate
                Where autoid = rec.autoid
                    and  reacctno=rec.reacctno
                    and  afacctno=rec.afacctno
                    and   status='A';

                --Kiem tra da ton tai tk moi gioi tuong lai chua
                v_check:=0;
                Begin
                    Select count(custid) into v_check
                    From remast
                    Where status='A' and ACCTNO=rec.fureacctno;
                EXCEPTION when OTHERS then
                     v_check:=0;
                End;
                If v_check=0 then
                     INSERT INTO REMAST (ACCTNO,CUSTID,ACTYPE,STATUS,PSTATUS,
                                        LAST_CHANGE,RATECOMM,BALANCE,DAMTACR,DAMTLASTDT,
                                          IAMTACR, IAMTLASTDT,DIRECTACR,INDIRECTACR,ODFEETYPE,ODFEERATE,COMMTYPE,LASTCOMMDATE)
                     SELECT  rec.fureacctno ACCTNO ,substr(rec.fureacctno,1,10) CUSTID,substr(rec.fureacctno,11,4) ACTYPE, 'A' STATUS,'' PSTATUS,
                                        sysdate LAST_CHANGE, RATECOMM, 0 BALANCE, 0 DAMTACR, v_currdate DAMTLASTDT,
                                          0 IAMTACR , v_currdate IAMTLASTDT , 0 DIRECTACR, 0 INDIRECTACR, ODFEETYPE,ODFEERATE,COMMTYPE,v_currdate  LASTCOMMDATE
                     FROM RETYPE WHERE ACTYPE=substr(rec.fureacctno,11,4);
                End if;
                ----------------

         End loop;
     End loop;
     */
     -- Rut tieu khoan khoi moi gioi khi het han
     update reaflnk
        set status='C',
            clstxdate=v_currdate
        where status='A' and todate<v_currdate;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        return ;
END; -- Procedure
PROCEDURE re_change_cfstatus_bf is
     v_currdate date;
     v_dmday number(10);
     v_olddmsts VARCHAR2(1);
     v_oldafstatus varchar2(1);
     v_oldlastdate date;
     v_oldactivedate date;
     v_newdmsts VARCHAR2(1);
     v_newafstatus varchar2(1);
     v_newlastdate date;
     v_newactivedate date;
     v_check number(10);
      v_close BOOLEAN;
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';
    Begin
        Select to_NUMBER(varvalue) into v_dmday
        From sysvar
        Where varname='DMDAY' and grname='SYSTEM';
    EXCEPTION
    when OTHERS then
        v_dmday:=360;
    End;
    -- Cac tk co gd trong ngay
    For vc in (Select distinct cf.custodycd, cf.lastdate,cf.activedate,cf.dmsts,cf.afstatus
            From iod i, cfmast cf
            where i.deltd<>'Y'
            and i.custodycd=cf.custodycd)
    Loop
      v_olddmsts:=vc.dmsts;
      v_oldafstatus:=vc.afstatus;
      v_oldlastdate:=vc.lastdate;
      v_oldactivedate:=vc.activedate;
      v_newdmsts:=vc.dmsts;
      v_newafstatus:=vc.afstatus;
      v_newlastdate:=v_currdate;
      v_newactivedate:=vc.activedate;
      If vc.dmsts='Y' then
         -- Danh dau thuc
         Update cfmast cf
         Set dmsts='N',
             activedate =  v_currdate
         Where cf.custodycd=vc.custodycd;
         v_newdmsts:='N';
         v_newactivedate:=v_currdate;
         -- Chuyen tu khach hang cu ->kh moi
         If vc.afstatus='O' then
             Update Cfmast
             Set afstatus = 'N'
             where custodycd = vc.custodycd;
             v_newafstatus:='N';
             For rec in(SELECT r.autoid, r.txdate, r.txnum, r.refrecflnkid, r.reacctno,
                       r.afacctno, r.frdate, r.todate, r.deltd, r.clstxdate, r.clstxnum,
                       r.pstatus, r.status, r.furefrecflnkid, r.fureacctno
                     From reaflnk r,afmast af, cfmast cf, retype rty
                     WHERE r.status='A'
                      And r.afacctno= af.acctno
                      and af.custid=cf.custid
                      and substr(reacctno,11,4)=rty.actype
                      and rty.rerole in ('BM')
                      And cf.custodycd =  vc.custodycd)
              Loop
                   Insert into reaflnk(autoid, txdate, txnum, refrecflnkid, reacctno,
                   afacctno, frdate, todate, deltd, clstxdate, clstxnum,
                   pstatus, status, furefrecflnkid, fureacctno, RECFCUSTID)
                          values (seq_reaflnk.nextval,rec.txdate,rec.txnum,rec.furefrecflnkid,rec.fureacctno,
                   rec.afacctno,v_currdate,rec.todate,rec.deltd,null,null,
                   rec.pstatus,rec.status,rec.refrecflnkid,rec.reacctno, SUBSTR(rec.fureacctno,0,10));

                   Update reaflnk
                   Set  status='C',
                        clstxdate=v_currdate
                   Where autoid = rec.autoid
                        and  reacctno=rec.reacctno
                        and  afacctno=rec.afacctno
                        and   status='A';
                  --Kiem tra da ton tai tk moi gioi tuong lai chua
                    v_check:=0;
                    Begin
                        Select count(custid) into v_check
                        From remast
                        Where status='A' and ACCTNO=rec.fureacctno;
                    EXCEPTION when OTHERS then
                         v_check:=0;
                    End;
                    If v_check=0 then
                         INSERT INTO REMAST (ACCTNO,CUSTID,ACTYPE,STATUS,PSTATUS,
                                            LAST_CHANGE,RATECOMM,BALANCE,DAMTACR,DAMTLASTDT,
                                             IAMTACR, IAMTLASTDT,DIRECTACR,INDIRECTACR,ODFEETYPE,ODFEERATE,COMMTYPE,LASTCOMMDATE)
                         SELECT  rec.fureacctno ACCTNO ,substr(rec.fureacctno,1,10) CUSTID,substr(rec.fureacctno,11,4) ACTYPE, 'A' STATUS,'' PSTATUS,
                                             sysdate LAST_CHANGE, RATECOMM, 0 BALANCE, 0 DAMTACR, v_currdate DAMTLASTDT,
                                             0 IAMTACR , v_currdate IAMTLASTDT , 0 DIRECTACR, 0 INDIRECTACR, ODFEETYPE,ODFEERATE,COMMTYPE,v_currdate  LASTCOMMDATE
                         FROM RETYPE WHERE ACTYPE=substr(rec.fureacctno,11,4);
                    End if;
                    ----------------
               End loop;
         End if;--vc.afstatus='O'
        insert into changecfstslog(txdate,custodycd,olddmsts,oldafstatus,oldlastdate,oldactivedate,
               newdmsts,newafstatus,newlastdate,newactivedate)
        values(v_currdate,vc.custodycd,v_olddmsts,v_oldafstatus,v_oldlastdate,v_oldactivedate,
               v_newdmsts,v_newafstatus,v_newlastdate,v_newactivedate);
      End if; --   vc.dmsts='Y'

     -- Cap nhat ngay gd cuoi cung
     Update CFMAST cf
     Set lastdate = v_currdate
     where cf.custodycd = vc.custodycd;
    End loop;

    -- Danh dau ngu
    insert into changecfstslog(txdate,custodycd,olddmsts,oldafstatus,oldlastdate,oldactivedate,
               newdmsts,newafstatus,newlastdate,newactivedate)
    select v_currdate txdate , custodycd,dmsts,afstatus,lastdate,activedate,
           'Y',afstatus,lastdate,activedate
    from cfmast cf
    where cf.lastdate + v_dmday <= v_currdate
         and dmsts='N';
    Update cfmast cf
    Set dmsts='Y'
    Where  cf.lastdate + v_dmday <= v_currdate
         and dmsts='N';

    -- Rut tieu khoan khoi MG CSH  khi  MG ko care tieu khoan do nua
   /* For vc in(Select * from reaflnk where status='A' and orgreacctno is not null)
    Loop
         v_close:=true;
         For rec in(select * from reaflnk
                   where reacctno=vc.orgreacctno
                           and afacctno=vc.afacctno
                           and  status='A')
         Loop
                v_close:=false;
         End loop;
         if v_close then
            update reaflnk
            set status='C',
            clstxdate = v_currdate
            where autoid=vc.autoid;
         end if;
    End loop;*/

   COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        return ;
END; -- Procedure
PROCEDURE re_changerev(acclist in  varchar2,rate in varchar2,gor in varchar2,ip in varchar2, tlid in varchar2, brid varchar2) is
 v_currdate date;
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';

    If gor = 'REMISER' THEN
        Update REREVLOG
        Set status = 'C'
        where instr(acclist,'|'||AUTOID||'|')>0 and gor='R';
        insert into rerevlog(
                             txdate,
                             tlid,
                             status,
                             Custid ,
                             rate,
                             gor,
                             ip,brid,
                             AUTOID
                            )
         Select  v_currdate txdate,
                  tlid,
                 'A' status,
                 custid,
                to_number(rate) rate,
                'R' gor,
                ip,brid,
                AUTOID
         From recflnk
         Where instr(acclist,'|'||AUTOID||'|')>0;
    ELSE
        Update REREVLOG
        Set status = 'C'
        where instr(acclist,'|'||AUTOID||'|')>0 and gor='G';
        insert into rerevlog(
                             txdate,
                             tlid,
                             status,
                             Custid ,
                             rate,
                             gor ,ip,brid,
                             AUTOID
                            )
         Select  v_currdate txdate,
                  tlid,
                 'A' status,
                 custid,
                to_number(rate) rate,
                'G' gor,
                ip,brid,AUTOID
         From regrp
         Where instr(acclist,'|'||AUTOID||'|')>0;
    END IF;
    COMMIT;

END; -- Procedure
FUNCTION fn_re_getcommision(strACCTNO IN varchar2, p_BASEDACR number, P_REVENUE NUMBER)
  RETURN  number
  IS
  l_COMMISION  number(20,4);
  l_BASEDACR  number(20,4);
  l_AUTOID    number(20,0);
  l_ACTYPE    VARCHAR2(4);
  l_RULETYPE  VARCHAR2(10);
  l_PERIOD    VARCHAR2(10);
  l_ICTYPE    VARCHAR2(10);
  l_DELTA    number(20,4);
  l_FLAT    number(20,4);
  l_ICRATE    number(20,4);
  l_MINVAL    number(20,4);
  l_MAXVAL    number(20,4);
  l_FLRATE    number(20,4);
  l_CERATE    number(20,4);
  v_baseacr number(20,4);
  v_revenue number(20,4);
BEGIN
  l_COMMISION :=0;
  l_BASEDACR:=p_BASEDACR;
    --GET REMAST ATRIBUTES
    SELECT  TYP.ACTYPE,
    IC.AUTOID, IC.RULETYPE, IC.PERIOD, IC.ICTYPE, IC.ICFLAT, IC.ICRATE, IC.MINVAL, IC.MAXVAL, IC.FLRATE, IC.CERATE
    into  l_ACTYPE, l_AUTOID, l_RULETYPE, l_PERIOD, l_ICTYPE, l_FLAT, l_ICRATE, l_MINVAL, l_MAXVAL, l_FLRATE, l_CERATE
    FROM REMAST MST, RETYPE TYP, ICCFTYPEDEF IC
  WHERE MST.ACCTNO = strACCTNO AND MST.ACTYPE=TYP.ACTYPE
    AND IC.MODCODE='RE' AND IC.EVENTCODE='CALFEECOMM' AND IC.ICCFSTATUS='A' AND IC.ACTYPE=MST.ACTYPE;

  if l_RULETYPE='S' OR l_RULETYPE='F' then
    if l_ICTYPE='F' then
      l_COMMISION := l_FLAT;
    elsif l_ICTYPE='P' then
      l_COMMISION := l_ICRATE/100*P_REVENUE;
      if l_COMMISION < l_MINVAL and l_MINVAL>0 then
        l_COMMISION := l_MINVAL;
      end if;
      if l_COMMISION > l_MAXVAL and l_MAXVAL>0 then
        l_COMMISION := l_MAXVAL;
      end if;
    end if;
  elsif l_RULETYPE='T' then
  l_DELTA:=0;
   Begin
    SELECT DELTA INTO l_DELTA
    FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
      AND ACTYPE=l_ACTYPE AND l_BASEDACR>=FRAMT AND l_BASEDACR<=TOAMT;
   EXCEPTION
   when OTHERS then
       l_DELTA:=0;
   End;
    l_COMMISION := (l_ICRATE+l_DELTA)/100*P_REVENUE;
    if l_COMMISION < l_MINVAL and l_MINVAL>0 then
      l_COMMISION := l_MINVAL;
    end if;
    if l_COMMISION > l_MAXVAL and l_MAXVAL>0 then
      l_COMMISION := l_MAXVAL;
    end if;
  elsif l_RULETYPE='C' then
     v_baseacr:=p_BASEDACR;
     v_revenue:=P_REVENUE;
     l_COMMISION:=0;
     l_DELTA:=0;
     Begin
         SELECT count(1) into  l_DELTA
         FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
         AND ACTYPE=l_ACTYPE;
     EXCEPTION
     when OTHERS then
       l_DELTA:=0;
     End;

     IF l_DELTA=0 then -- khong khai bao tier
         l_COMMISION:= (l_ICRATE/100)* P_REVENUE;
     Else
         For vc in(SELECT framt, toamt,delta
                   FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='CALFEECOMM' AND ICCFSTATUS='A'
                   AND ACTYPE=l_ACTYPE
                   --and framt >=p_BASEDACR
                   ORDER BY framt ) loop
             If v_baseacr >0  then
                l_COMMISION:=l_COMMISION + ((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) / p_BASEDACR)*P_REVENUE;

                /*dbms_output.put_line(' framt = '||vc.framt);
                dbms_output.put_line(' toamt = '||vc.toamt);
                dbms_output.put_line(' l_ICRATE = '||l_ICRATE);
                 dbms_output.put_line(' DELTA = '||vc.DELTA);
                dbms_output.put_line(' reate = '||(l_ICRATE+vc.DELTA)/100);
                dbms_output.put_line(' DS = '||least(v_baseacr,vc.toamt  - vc.framt));
                dbms_output.put_line(' COMM = '||((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) / p_BASEDACR)*P_REVENUE);
                */
                v_baseacr:=v_baseacr-least(v_baseacr,vc.toamt  - vc.framt);
             End if;
         End loop;
     end if;
  end if;

    RETURN l_COMMISION;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;



FUNCTION fn_re_gettax(strcustid IN varchar2, p_BASEDACR number)
  RETURN  number
  IS
  l_TAX  number(20,4);
  l_BASEDACR  number(20,4);
  l_AUTOID    number(20,0);
  l_ACTYPE    VARCHAR2(4);
  l_RULETYPE  VARCHAR2(10);
  l_PERIOD    VARCHAR2(10);
  l_ICTYPE    VARCHAR2(10);
  l_DELTA    number(20,4);
  l_FLAT    number(20,4);
  l_ICRATE    number(20,4);
  l_MINVAL    number(20,4);
  l_MAXVAL    number(20,4);
  l_FLRATE    number(20,4);
  l_CERATE    number(20,4);
  v_baseacr number(20,4);

BEGIN
  l_TAX :=0;
  l_BASEDACR:=p_BASEDACR;
    --GET  ATRIBUTES
    SELECT  ic.ACTYPE,
    IC.AUTOID, IC.RULETYPE, IC.PERIOD, IC.ICTYPE, IC.ICFLAT, IC.ICRATE, IC.MINVAL, IC.MAXVAL, IC.FLRATE, IC.CERATE
    into  l_ACTYPE, l_AUTOID, l_RULETYPE, l_PERIOD, l_ICTYPE, l_FLAT, l_ICRATE, l_MINVAL, l_MAXVAL, l_FLRATE, l_CERATE
    FROM recflnk MST, RETAX  IC
  WHERE MST.custid= strcustid
       AND MST.taxTYPE=IC.ACTYPE
       AND IC.MODCODE='RE' AND IC.EVENTCODE='RETAX' AND IC.ICCFSTATUS='A' ;

  if l_RULETYPE='S' OR l_RULETYPE='F' then
    if l_ICTYPE='F' then
      l_TAX := l_FLAT;
    elsif l_ICTYPE='P' then
      l_TAX := l_ICRATE/100*l_BASEDACR;
      if l_TAX < l_MINVAL and l_MINVAL>0 then
        l_TAX := l_MINVAL;
      end if;
      if l_TAX > l_MAXVAL and l_MAXVAL>0 then
        l_TAX := l_MAXVAL;
      end if;
    end if;
  elsif l_RULETYPE='T' then
  l_DELTA:=0;
   Begin
    SELECT DELTA INTO l_DELTA
    FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='RETAX' AND ICCFSTATUS='A'
      AND ACTYPE=l_ACTYPE AND l_BASEDACR>=FRAMT AND l_BASEDACR<=TOAMT;
   EXCEPTION
   when OTHERS then
       l_DELTA:=0;
   End;
    l_TAX := (l_ICRATE+l_DELTA)/100*l_BASEDACR;
    if l_TAX < l_MINVAL and l_MINVAL>0 then
      l_TAX := l_MINVAL;
    end if;
    if l_TAX > l_MAXVAL and l_MAXVAL>0 then
      l_TAX := l_MAXVAL;
    end if;
  elsif l_RULETYPE='C' then
     v_baseacr:=p_BASEDACR;

     l_TAX:=0;
     l_DELTA:=0;
     Begin
         SELECT count(1) into  l_DELTA
         FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='RETAX' AND ICCFSTATUS='A'
         AND ACTYPE=l_ACTYPE;
     EXCEPTION
     when OTHERS then
       l_DELTA:=0;
     End;

     IF l_DELTA=0 then -- khong khai bao tier
         l_TAX:= (l_ICRATE/100)* l_BASEDACR;
     Else
         For vc in(SELECT framt, toamt,delta
                   FROM ICCFTIER WHERE MODCODE='RE' AND EVENTCODE='RETAX' AND ICCFSTATUS='A'
                   AND ACTYPE=l_ACTYPE
                   --and framt >=p_BASEDACR
                   ORDER BY framt ) loop
             If v_baseacr >0  then
                l_TAX:=l_TAX + ((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) );

                /*dbms_output.put_line(' framt = '||vc.framt);
                dbms_output.put_line(' toamt = '||vc.toamt);
                dbms_output.put_line(' l_ICRATE = '||l_ICRATE);
                 dbms_output.put_line(' DELTA = '||vc.DELTA);
                dbms_output.put_line(' reate = '||(l_ICRATE+vc.DELTA)/100);
                dbms_output.put_line(' DS = '||least(v_baseacr,vc.toamt  - vc.framt));
                dbms_output.put_line(' COMM = '||((l_ICRATE+vc.DELTA)/100 ) *  (least(v_baseacr,vc.toamt  - vc.framt) / p_BASEDACR)*P_REVENUE);
                */
                v_baseacr:=v_baseacr-least(v_baseacr,vc.toamt  - vc.framt);
             End if;
         End loop;
     end if;
  end if;

    RETURN l_TAX;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
-- initial LOG

BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_reproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
