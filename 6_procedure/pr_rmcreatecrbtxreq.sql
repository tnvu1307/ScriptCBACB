SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_rmcreatecrbtxreq (p_err_code OUT VARCHAR2)
/* Formatted on 20/12/2019 20:31:40 (QP5 v5.160) */
IS
    TYPE v_curtyp IS REF CURSOR;

    v_objtype         VARCHAR2 (50);
/*ADVICE(6): Unreferenced variable [553] */
    v_objname         VARCHAR2 (50);
/*ADVICE(8): Unreferenced variable [553] */
    v_fldtrfcode      VARCHAR2 (50);
/*ADVICE(10): Unreferenced variable [553] */
    v_fldaffectdate   VARCHAR2 (100);
/*ADVICE(12): Unreferenced variable [553] */
    v_fldbank         VARCHAR2 (50);
/*ADVICE(14): Unreferenced variable [553] */
    v_fldacctno       VARCHAR2 (50);
/*ADVICE(16): Unreferenced variable [553] */
    v_fldbankacct     VARCHAR2 (50);
    v_fldrefcode      VARCHAR2 (50);
/*ADVICE(19): Unreferenced variable [553] */
    v_fldnotes        VARCHAR2 (50);
/*ADVICE(21): Unreferenced variable [553] */
    v_fldamtexp       VARCHAR2 (50);
/*ADVICE(23): Unreferenced variable [553] */
    v_amtexp          VARCHAR2 (50);
/*ADVICE(25): Unreferenced variable [553] */
    v_txnum           VARCHAR2 (20);
/*ADVICE(27): Unreferenced variable [553] */
    v_txdate          DATE;
/*ADVICE(29): Unreferenced variable [553] */
    v_chartxdate      VARCHAR2 (20);
    v_trfcode         VARCHAR2 (50);
    v_refcode         VARCHAR2 (50);
    v_bank            VARCHAR2 (50);
    v_affectdate      VARCHAR2 (100);
    v_bankacct        VARCHAR2 (50);
    v_afacctno        VARCHAR2 (10);
    v_notes           VARCHAR2 (3000);
/*ADVICE(38): VARCHAR2 declaration with length greater than 500
                  characters [307] */
    v_value           VARCHAR2 (300);
    v_refautoid       NUMBER;
/*ADVICE(42): NUMBER has no precision [315] */
    v_currdate        VARCHAR2 (250);
    v_extcmdsql       VARCHAR2 (5000);
/*ADVICE(45): VARCHAR2 declaration with length greater than 500
                  characters [307] */
    c0                v_curtyp;
BEGIN
    p_err_code := '0';

    SELECT varvalue
      INTO v_currdate
      FROM sysvar
     WHERE varname = 'CURRDATE';

    --Lap lay ra cac tltx co khai bao ma phat sinh giao dich
    FOR rec
        IN (SELECT lg.tltxcd,
                   lg.txnum,
                   lg.txdate,
                   crm.objtype,
                   crm.objname,
                   crm.trfcode,
                   crm.affectdate,
                   crm.fldbank,
                   crm.fldacctno,
                   crm.fldbankacct,
                   crm.fldrefcode,
                   crm.fldnotes,
                   crm.amtexp
              FROM tllog lg, crbtxmap crm
             WHERE     lg.tltxcd = crm.objname
                   AND crm.objtype = 'T'
                   AND lg.txstatus = '1'
                   AND lg.deltd <> 'Y'
                   AND lg.tltxcd NOT IN ('6600', '6640')
                   AND lg.tltxcd IN ('6641', '6643')
                   AND NOT EXISTS
                               (SELECT *
                                  FROM crbtxreq req
                                 WHERE req.objkey = lg.txnum
                                       AND req.txdate = lg.txdate
                                       AND (req.trfcode = crm.trfcode
                                            OR SUBSTR (crm.trfcode, 1, 1) =
                                                   '$')))
    LOOP
        BEGIN
            v_chartxdate := TO_CHAR (rec.txdate, 'DD/MM/YYYY');

            IF rec.fldrefcode IS NULL
            THEN
                v_refcode := v_chartxdate || rec.txnum;
            ELSE
                v_refcode :=
                    fn_eval_amtexp (rec.txnum, v_chartxdate, rec.fldrefcode);
/*ADVICE(96): This item has not been declared, or it refers to a label [131] */
            END IF;

            --TAO YEU CAU LAP BANG KE: GHI VAO BANG CRBTXREQ/CRBTXREQDTL
            v_trfcode := rec.trfcode;

            IF SUBSTR (v_trfcode, 1, 1) = '$'
            THEN
                --LAY  TRFCODE THEO GIAO DICH
                v_trfcode :=
                    fn_eval_amtexp (rec.txnum, v_chartxdate, v_trfcode);
/*ADVICE(107): This item has not been declared, or it refers to a label [131] */
            END IF;

            IF rec.affectdate = '<$TXDATE>'
            THEN
                v_affectdate := v_currdate;
            ELSE
                v_affectdate :=
                    fn_eval_amtexp (rec.txnum, v_chartxdate, rec.affectdate);
/*ADVICE(116): This item has not been declared, or it refers to a label [131] */
            END IF;

            v_afacctno :=
                fn_eval_amtexp (rec.txnum, v_chartxdate, rec.fldacctno);
/*ADVICE(121): This item has not been declared, or it refers to a label [131] */
            v_notes := fn_eval_amtexp (rec.txnum, v_chartxdate, rec.fldnotes);
/*ADVICE(123): This item has not been declared, or it refers to a label [131] */
            v_value := fn_eval_amtexp (rec.txnum, v_chartxdate, rec.amtexp);
/*ADVICE(125): This item has not been declared, or it refers to a label [131] */
            v_bankacct :=
                fn_eval_amtexp (rec.txnum, v_chartxdate, rec.fldbankacct);
/*ADVICE(128): This item has not been declared, or it refers to a label [131] */

            IF v_bankacct = '0'
            THEN
                v_bankacct := NULL;
            END IF;

            IF SUBSTR (v_fldbankacct, 1, 1) = '#'
            THEN
                --XAC DINH THONG TIN BO XUNG
                IF v_bankacct IS NOT NULL
                THEN
                    v_bankacct :=
                        fn_crb_getcfacctbytrfcode (v_trfcode, v_bankacct);
/*ADVICE(142): This item has not been declared, or it refers to a label [131] */
                END IF;
            END IF;

            v_bank := fn_eval_amtexp (rec.txnum, v_chartxdate, rec.fldbank);
/*ADVICE(147): This item has not been declared, or it refers to a label [131] */

            IF v_bank = '0'
            THEN
                v_bank := NULL;
            END IF;

            IF SUBSTR (rec.fldbank, 1, 1) = '#'
            THEN
                --XAC DINH THONG TIN BO XUNG
                IF v_bank IS NOT NULL
                THEN
                    v_bank := fn_crb_getbankcodebytrfcode (v_trfcode, v_bank);
/*ADVICE(160): This item has not been declared, or it refers to a label [131] */
                END IF;
            END IF;

            --Neu lay ra truong ko tim thay thi phai de null de khong sinh bang ke
            IF v_bank = '0'
            THEN
                v_bank := NULL;
            END IF;

            IF     (NOT v_bank IS NULL)
               AND (NOT v_bankacct IS NULL)
               AND (TO_NUMBER (v_value) > 0)
            THEN
                BEGIN
/*ADVICE(175): Nested blocks should all be labeled [407] */
                    v_refautoid := seq_crbtxreq.NEXTVAL;
/*ADVICE(177): This item has not been declared, or it refers to a label [131] */

                    INSERT INTO crbtxreq (reqid,
                                          objtype,
                                          objname,
                                          objkey,
                                          trfcode,
                                          REQCODE,
                                          txdate,
                                          affectdate,
                                          afacctno,
                                          txamt,
                                          bankcode,
                                          bankacct,
                                          status,
                                          refval,
                                          notes)
                    VALUES (v_refautoid,
                            'T',
                            rec.tltxcd,
                            rec.txnum,
                            v_trfcode,
                            v_refcode,
                            rec.txdate,
                            TO_DATE (v_affectdate, 'DD/MM/RRRR'),
                            v_afacctno,
                            v_value,
                            v_bank,
                            v_bankacct,
                            'P',
                            NULL,
                            v_notes);

                    FOR rc
                        IN (SELECT fldname,
                                   fldtype,
                                   amtexp,
                                   cmdsql
                              FROM crbtxmapext mst
                             WHERE     mst.objtype = 'T'
                                   AND mst.objname = rec.tltxcd
                                   AND trfcode = rec.trfcode)
                    LOOP
/*ADVICE(220): Nested LOOPs should all be labeled [406] */
                        BEGIN
/*ADVICE(222): Nested blocks should all be labeled [407] */
                            IF NOT rc.amtexp IS NULL
                            THEN
                                v_value :=
                                    fn_eval_amtexp (rec.txnum,
/*ADVICE(227): This item has not been declared, or it refers to a label [131] */
                                                    v_chartxdate,
                                                    rc.amtexp);
                            END IF;

                            IF NOT rc.cmdsql IS NULL
                            THEN
                                BEGIN
/*ADVICE(235): Nested blocks should all be labeled [407] */
                                    v_extcmdsql :=
                                        REPLACE (rc.cmdsql,
                                                 '<$FILTERID>',
                                                 v_value);

                                    BEGIN
/*ADVICE(242): Nested blocks should all be labeled [407] */
                                        OPEN c0 FOR v_extcmdsql;

                                        FETCH c0 INTO v_value;

                                        CLOSE c0;
                                    EXCEPTION
                                        WHEN OTHERS
/*ADVICE(250): A WHEN OTHERS clause is used in the exception section
                  without any other specific handlers [201] */
                                        THEN
                                            v_value := '0';
                                    END;
                                END;
                            END IF;

                            INSERT INTO crbtxreqdtl (autoid,
                                                     reqid,
                                                     fldname,
                                                     cval,
                                                     nval)
                                SELECT seq_crbtxreqdtl.NEXTVAL,
                                       v_refautoid,
                                       rc.fldname,
                                       DECODE (rc.fldtype,
                                               'N', NULL,
                                               TO_CHAR (v_value)),
                                       DECODE (rc.fldtype, 'N', v_value, 0)
                                  FROM DUAL;
                        END;
                    END LOOP;
                END;
            END IF;
        END;
    END LOOP;

    p_err_code := '0';
EXCEPTION
    WHEN OTHERS
/*ADVICE(281): A WHEN OTHERS clause is used in the exception section
                  without any other specific handlers [201] */
    THEN
        p_err_code := errnums.c_system_error;
/*ADVICE(285): This item has not been declared, or it refers to a label [131] */
END;
/*ADVICE(287): END of program unit, package or type is not labeled [408] */
/
