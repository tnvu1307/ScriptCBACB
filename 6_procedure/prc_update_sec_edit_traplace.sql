SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_update_sec_edit_traplace (
           pl_CODEID IN VARCHAR2,
           pl_SYMBOL IN VARCHAR2,
           pv_TRADEPLACE IN VARCHAR2,
           pv_SECTYPE   IN VARCHAR2,
           pv_PARVALUE  IN NUMBER,
           pv_INTRATE   IN NUMBER,
           pv_STATUS    IN VARCHAR2,
           pv_CAREBY    IN VARCHAR2,
           pv_EXPDATE   IN VARCHAR2,
           pv_DEPOSITORY   IN VARCHAR2,
           pv_CHKRATE      IN NUMBER,
           pv_INTPERIOD    IN NUMBER,
           pv_ISSUEDATE    IN VARCHAR2,
           pv_ISSUERID     IN VARCHAR2,
           pv_FOREIGNRATE  IN NUMBER,
           pv_ISSEDEPOFEE  IN VARCHAR2,
           pv_TLID         IN VARCHAR2

       )
IS
          l_CODEID           VARCHAR2(10);
          l_SYMBOL           VARCHAR2(80);
          l_TRADEPLACE       VARCHAR2(3);
          l_old_tradeplace   VARCHAR2(3);
          l_strCurrdate         DATE;
          V_TRADENAME           VARCHAR2(10);
          v_strISSEDEPOFEE      VARCHAR2(1);
          v_CountSEINF           Number;

BEGIN

          l_CODEID           := pl_CODEID;
          l_SYMBOL           := pl_SYMBOL;

          l_TRADEPLACE       := pv_TRADEPLACE;
          SELECT varvalue INTO l_strCurrdate
          FROM sysvar WHERE varname='CURRDATE' ;

         /* TRADEPLACE  000 T?t c?
          TRADEPLACE    002 HNX
          TRADEPLACE    003 OTC
          TRADEPLACE    005 UPCOM
          TRADEPLACE    006 WFT
          TRADEPLACE    001 HOSE*/
          --


          SELECT A.CDCONTENT
          INTO V_TRADENAME
          FROM ALLCODE A
          WHERE        A.CDTYPE = 'SE'
          AND          CDNAME   = 'TRADEPLACE'
          AND          CDVAL    = pv_TRADEPLACE;

          SELECT COUNT(*) INTO v_CountSEINF
          FROM SECURITIES_INFO
          WHERE CODEID = l_CODEID;

           IF (V_TRADENAME = 'HOSE') THEN

             DELETE FROM SECURITIES_TICKSIZE WHERE CODEID=l_CODEID;

             IF(pv_SECTYPE IN ('001','008')) THEN-- CP thuong, chung chi quy
             ---- INSERT SECURITIES_TICKSIZE (BUOC GIA)
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 10, 0, 9990, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 50, 10000, 49950, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 100, 50000, 100000000, 'Y');

                 IF v_CountSEINF > 0 THEN
                    UPDATE securities_info SET tradelot=10 WHERE  codeid=l_CODEID;
                 ELSE
                    INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                    VALUES (
                            SEQ_SECURITIES_INFO.NEXTVAL, L_CODEID, L_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                            1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                            TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                            0, 0, 1, 1, 1, 1, 1, 10, 'Y', 0, 1000000000, 0,
                            1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                        );
                 END IF;
             ELSIF  (pv_SECTYPE IN ('011')) THEN --  --Ngay 23/03/2017 CW NamTv chinh sua them sectype 011
                INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 10, 0, 100000000, 'Y');

                 IF v_CountSEINF > 0 THEN
                    UPDATE securities_info SET tradelot=10 WHERE  codeid=l_CODEID;
                 ELSE
                    INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                    VALUES (
                            SEQ_SECURITIES_INFO.NEXTVAL, L_CODEID, L_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                            1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                            TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                            0, 0, 1, 1, 1, 1, 1, 10, 'Y', 0, 1000000000, 0,
                            1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                        );
                 END IF;
             ELSIF  (pv_SECTYPE IN ('003','006')) THEN -- trai phieu, trai phieu chuyen doi
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 1, 0, 100000000, 'Y');


                 IF v_CountSEINF > 0 THEN
                    UPDATE securities_info SET tradelot=1 WHERE  codeid=l_CODEID;
                 ELSE
                    INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                    VALUES (
                            SEQ_SECURITIES_INFO.NEXTVAL, L_CODEID, L_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                            1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                            TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                            0, 0, 1, 1, 1, 1, 1, 1, 'Y', 0, 1000000000, 0,
                            1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                        );
                 END IF;

             ELSE

                IF v_CountSEINF > 0 THEN
                    UPDATE securities_info SET tradelot=0 WHERE  codeid=l_CODEID;
                 ELSE
                    INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                    VALUES (
                            SEQ_SECURITIES_INFO.NEXTVAL, L_CODEID, L_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                            1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                            TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '001',
                            0, 0, 1, 1, 1, 1, 1, 0, 'Y', 0, 1000000000, 0,
                            1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                        );
                 END IF;

             END IF;

           ELSIF (V_TRADENAME IN ( 'HNX','UPCOM') )THEN
               IF(pv_SECTYPE IN ('001','008','011')) THEN-- CP thuong, chung chi quy
                  ---- INSERT SECURITIES_TICKSIZE (BUOC GIA)
                   --select count(1) into v_Count from SECURITIES_TICKSIZE where  CODEID = l_CODEID;
                   --If v_Count <> 1 then
                     DELETE FROM SECURITIES_TICKSIZE WHERE CODEID=l_CODEID;
                     INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                     VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 100, 0, 10000000, 'Y');
                   --End If;

                 IF v_CountSEINF > 0 THEN
                    UPDATE securities_info SET tradelot=100 WHERE  codeid=l_CODEID;
                 ELSE
                    INSERT INTO SECURITIES_INFO (
                        AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                        ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                        AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                        DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                        REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                        SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                        CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                    VALUES (
                              SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                              1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                              TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                              0, 1, 1, 1, 1, 1, 100, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                              1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                          );
                 END IF;

               ELSIF (pv_SECTYPE IN ('003','006')) THEN -- trai phieu, trai phieu chuyen doi
                   ---- INSERT SECURITIES_TICKSIZE (BUOC GIA)
                   DELETE FROM SECURITIES_TICKSIZE WHERE CODEID=l_CODEID;
                   INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                   VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 1, 0, 10000000, 'Y');


                    IF v_CountSEINF > 0 THEN
                        UPDATE securities_info SET tradelot=1 WHERE  codeid=l_CODEID;
                    ELSE
                        INSERT INTO SECURITIES_INFO (
                            AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                            ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                            AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                            DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                            REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                            SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                            CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                        VALUES (
                                  SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                                  1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                                  TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                                  0, 1, 1, 1, 1, 1, 100, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                                  1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                              );
                    END IF;
               ELSE
                         ---- INSERT SECURITIES_INFO (TT CHI TIET MA CK)
                   IF v_CountSEINF > 0 THEN
                        UPDATE securities_info SET tradelot=0 WHERE  codeid=l_CODEID;
                    ELSE
                        INSERT INTO SECURITIES_INFO (
                            AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                            ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                            AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                            DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                            REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                            SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                            CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                        VALUES (
                                  SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                                  1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                                  TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                                  0, 1, 1, 1, 1, 1, 0, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                                  1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                              );
                    END IF;

               END IF;
           ELSIF (V_TRADENAME IN ( 'BOND', 'TPRL') )THEN
                  DELETE FROM SECURITIES_TICKSIZE WHERE CODEID=l_CODEID;
                  INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                  VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, l_SYMBOL, 1, 0, 10000000, 'Y');

                  IF v_CountSEINF > 0 THEN
                        UPDATE securities_info SET tradelot=1 WHERE  codeid=l_CODEID;
                    ELSE
                        INSERT INTO SECURITIES_INFO (
                            AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                            ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                            AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                            DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                            REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                            SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                            CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                        VALUES (
                              SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                              1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                              TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                              0, 1, 1, 1, 1, 1, 1, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                              1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                          );
                    END IF;
            ELSE

                  IF v_CountSEINF > 0 THEN
                        UPDATE securities_info SET tradelot=0 WHERE  codeid=l_CODEID;
                    ELSE
                        INSERT INTO SECURITIES_INFO (
                            AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, REFERENCESTATUS,
                            ADJUSTRATE, REFERENCERATE, REFERENCEDATE, STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, CLOSEPRICE,
                            AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE, EPS, DIVYEILD,
                            DAYRANGE, YEARRANGE, TRADELOT, TRADEBUYSELL, TELELIMITMIN, TELELIMITMAX, ONLINELIMITMIN, ONLINELIMITMAX,
                            REPOLIMITMIN, REPOLIMITMAX, ADVANCEDLIMITMIN, ADVANCEDLIMITMAX, MARGINLIMITMIN, MARGINLIMITMAX, SECURERATIOTMIN,
                            SECURERATIOMAX, DEPOFEEUNIT, DEPOFEELOT, MORTAGERATIOMIN, MORTAGERATIOMAX, SECUREDRATIOMIN, SECUREDRATIOMAX,
                            CURRENT_ROOM, BMINAMT, SMINAMT, MARGINPRICE)
                        VALUES (
                                  SEQ_SECURITIES_INFO.NEXTVAL, l_CODEID, l_SYMBOL, TO_DATE (l_strCurrdate, systemnums.c_date_format),
                                  1, 1000, 'N', 1, TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 1, 1,
                                  TO_DATE (l_strCurrdate, systemnums.c_date_format), '001', 0, 0, 0, 0, 0, 0, 1, 1, 0, '002', 0,
                                  0, 1, 1, 1, 1, 1, 0, 'Y', 0, 1000000000, 0, 1000000000, 0, 1000000000, 0, 1000000000, 0,
                                  1000000000, 0, 0, 1, 1, 0, 1000000000, 1, 102, 0, 0, 0, 0
                               );
                    END IF;

           END IF;

          -- log thong tin chuyen san
          SELECT tradeplace,ISSEDEPOFEE
          INTO l_old_tradeplace,v_strISSEDEPOFEE
          FROM sbsecurities WHERE codeid=l_CODEID;
          if(l_old_tradeplace <> l_TRADEPLACE) THEN
             INSERT INTO SETRADEPLACE (AUTOID,TXDATE,CODEID,CTYPE,FRTRADEPLACE,TOTRADEPLACE)
             VALUES (SEQ_SETRADEPLACE.NEXTVAL,TO_DATE (l_strCurrdate, 'DD/MM/RRRR'),l_CODEID,'MA',l_old_tradeplace,l_TRADEPLACE);

          END IF;
          if(v_strISSEDEPOFEE <> pv_ISSEDEPOFEE) THEN
             INSERT INTO SEDEPOFEELOG (AUTOID,TXDATE,TLID,CODEID,ISSEDEPOFEE)
             VALUES (SEQ_SEDEPOFEELOG.NEXTVAL,TO_DATE (l_strCurrdate, 'DD/MM/RRRR'),pv_tlid,l_CODEID,pv_ISSEDEPOFEE);

          END IF;

EXCEPTION
   WHEN OTHERS
   THEN
     -- plog.error ('PRC_UPDATE_SEC_EDIT_TRAPLACE', SQLERRM);
      RETURN;
END;
/
