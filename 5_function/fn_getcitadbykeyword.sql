SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcitadbykeyword(pv_Desc IN VARCHAR2) RETURN VARCHAR2 IS
    /*
        fn_getcitadbykeyword: Dua vao dien giai lay ra citad cua ngan hang
        pv_Desc : Dien giai cua giao dich
    */
    v_Result  VARCHAR2(200);
    v_Desc    VARCHAR2(4000);
    v_keyword    VARCHAR2(4000);
BEGIN
    v_Result := '';
    v_Desc := fn_cutoffutf8(trim(pv_Desc));
    v_Desc := upper(REPLACE(v_Desc,' ', ''));

    Begin
        for rec in
        (
            /*
            Select mst.citad,  LISTAGG(keyword, '') WITHIN GROUP (ORDER BY mst.citad) keyword
            from crbbanklist mst, crbbankmapkword ma
            where mst.citad = ma.citad
            group by mst.citad
            */
            select citad, replace(fn_cutoffutf8(upper(trim(keyword))),' ','') keyword
            from
            (
                Select mst.citad,  ma.keyword, ma.prioritize
                from crbbanklist mst, crbbankmapkword ma
                where mst.citad = ma.citad
            ) order by prioritize
        )loop
            v_keyword := fn_cutoffutf8(trim(rec.keyword));
            v_keyword := upper(REPLACE(v_keyword,' ', ''));
            -- Dien giai trong keyword
            If INSTR(v_keyword,v_Desc) > 0 then
                v_Result := rec.citad;
                return v_Result;
            End if;

            -- Key word trong dien giai.
            If INSTR(v_Desc, v_keyword) > 0 then
                v_Result := rec.citad;
                return v_Result;
            End if;
        End Loop;
    End;

    return v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
