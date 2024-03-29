SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_no_transaction(
  PV_SYMBOL    IN VARCHAR2,
  PV_ACTYPE    IN VARCHAR2,
  PV_SECTYPE   IN VARCHAR2,
  PV_VALMETHOD IN VARCHAR2,
  PV_YPARAM    IN OUT NUMBER)
  RETURN BOOLEAN IS
    V_RESULT         BOOLEAN;
    V_XPARAM         NUMBER;
    V_YPARAM         NUMBER;
    V_FROMDATE       DATE;
    V_CURRDATE       DATE;
    V_COUNT          NUMBER;
BEGIN
    SELECT BO.XPARAM, BO.YPARAM INTO V_XPARAM, V_YPARAM FROM BONDTYPE BO WHERE BO.ACTYPE = PV_ACTYPE;

    PV_YPARAM := V_YPARAM;
    V_CURRDATE := GETCURRDATE;
    V_COUNT := 0;

    SELECT GETPREVDATE(V_CURRDATE, V_YPARAM) INTO V_FROMDATE FROM DUAL;

    SELECT COUNT(1) INTO V_COUNT
    FROM SBREFMRKDATA
    WHERE TRADINGDT > V_FROMDATE
    AND SRCMRKDATA = 'STX'
    AND PCLOSED > 0
    AND SYMBOL = PV_SYMBOL;

    IF V_COUNT = 0 THEN
        V_RESULT := TRUE;
    ELSE
        V_RESULT := FALSE;
    END IF;

    RETURN V_RESULT;
EXCEPTION WHEN OTHERS THEN
    V_RESULT := FALSE;
    plog.error ('FN_CHECK_NO_TRANSACTION: ' || SQLERRM || dbms_utility.format_error_backtrace);
END;
/
