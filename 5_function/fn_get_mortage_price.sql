SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_mortage_price(
  pv_symbol    IN varchar2,
  pv_actype    IN varchar2,
  pv_sectype   IN varchar2,
  pv_valmethod IN varchar2)
  RETURN number IS
    v_Result         number(18,5);
    v_Xparam         number;
    v_Yparam         number;
    v_Tparam         NUMBER;
    v_fromDate       Date;
    v_count          number;
    v_vbma           number;
    v_reuters        number;
    v_formula        number;
    v_manual         number;
    v_average        number;
    v_volume         number;
    v_value          number;
    V_CURRDATE       date;
    V_X              NUMBER:=0;
    V_Y              NUMBER:=0;
    V_X1             NUMBER:=0;
    V_X2             NUMBER:=0;
    V_Y1             NUMBER:=0;
    V_Y2             NUMBER:=0;
    V_COUNT_BI       NUMBER;
    v_closepirce    number;
BEGIN
    select bo.xparam, bo.yparam into v_Xparam, v_Yparam from bondtype bo where bo.actype = pv_actype;
    v_currdate := getcurrdate;
    v_count := 0;
    IF pv_sectype = '111' THEN --Co phieu
        select getprevdate(v_currdate, v_Xparam) into v_fromDate from dual;

        IF PV_VALMETHOD = '001' THEN --E1
            SELECT COUNT(*), AVG(PCLOSED) INTO V_COUNT, V_AVERAGE
            FROM
            (
                SELECT *
                FROM SBREFMRKDATA
                WHERE TRADINGDT <= V_CURRDATE
                AND SRCMRKDATA = 'STX'
                AND SYMBOL = PV_SYMBOL
                ORDER BY TRADINGDT DESC
            )
            WHERE ROWNUM <= V_XPARAM;

            IF V_COUNT < V_YPARAM
                THEN V_RESULT := NULL;
            ELSE
                V_RESULT := V_AVERAGE;
            END IF;
        ELSIF PV_VALMETHOD = '002' THEN --E2
           SELECT COUNT(*), SUM(VOLUME), SUM(TRANVALUE), SUM(PCLOSED) INTO V_COUNT, V_VOLUME, V_VALUE, V_CLOSEPIRCE
            FROM
            (
                SELECT *
                FROM SBREFMRKDATA
                WHERE TRADINGDT <= V_CURRDATE
                AND SRCMRKDATA = 'STX'
                AND SYMBOL = PV_SYMBOL
                ORDER BY TRADINGDT DESC
            )
            WHERE ROWNUM <= V_XPARAM;

            IF V_COUNT < V_YPARAM THEN
                V_RESULT  := NULL;
            ELSE
                V_RESULT := CASE WHEN V_VOLUME = 0 THEN 0 ELSE V_VALUE/V_VOLUME END;
            END IF;
        ELSE --MANUAL
            V_RESULT  := NULL;
        END IF;
    ---------------------------------------------------------
    ELSE IF pv_sectype = '222' THEN --Trai phieu

    if pv_valmethod = '001' then -- vbma
       v_Result := 0;
    elsif pv_valmethod = '002' then--reuter
       v_Result := 0;
    elsif pv_valmethod = '003' then
       v_Result := FN_GET_INTPRICE(pv_symbol,v_currdate,V_X,V_X1,V_X2,V_Y,V_Y1,V_Y2);

       SELECT COUNT(1) INTO V_COUNT_BI FROM BONDINTERPOLATE WHERE SYMBOL = pv_symbol AND TXDATE = v_currdate;
       IF (V_COUNT_BI = 0) THEN
           INSERT INTO BONDINTERPOLATE (AUTOID,SYMBOL,TXDATE,TTM,TTM_LOWER,TTM_UPPER,YIELD,YTM_LOWER,YTM_UPPER,PRICE,SETTLEDATE,LASTCHANGE)
            VALUES (
                     SEQ_BONDINTERPOLATE.NEXTVAL,--AUTOID -------NUMBER
                     pv_symbol,--SYMBOL -------VARCHAR2(100)
                     v_currdate,--TXDATE -------DATE(7)
                     V_X,--TTM -------NUMBER(22)
                     V_X1,--TTM_LOWER -------NUMBER(22)
                     V_X2,--TTM_UPPER -------NUMBER(22)
                     V_Y,--YIELD -------NUMBER(22)
                     V_Y1,--YTM_LOWER -------NUMBER(22)
                     V_Y2,--YTM_UPPER -------NUMBER(22)
                     v_Result,--PRICE -------NUMBER(22)
                     getnextworkingdate(v_currdate),--SETTLEDATE -------DATE(7)
                     SYSDATE--LASTCHANGE -------DATE(7)
                   );
        END IF;
    else
      v_Result := null;
    end if;
    --------------------------------------------------------
    ELSE IF pv_sectype = '555' THEN --Tien mat
        v_Tparam := v_Xparam;
        if pv_valmethod = '001' then --C1
             v_Result := v_Tparam;
        elsif pv_valmethod = '002' then --Manual
            v_Result  := null;
        end if;
    END IF; END IF; END IF;
  RETURN v_Result;
END;
/
