SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_updatepricefromgw(p_symbol        in varchar2,
                                                 p_basic_price   in number,
                                                 p_floor_price   in number,
                                                 p_ceiling_price in number,
                                                 p_update_mode   in varchar2,
                                                 p_err_code      out varchar2,
                                                 p_err_message   out varchar2) is
  l_code_id     varchar2(6);
  l_update_mode varchar2(12);
  v_basicprice number;
  v_ticksize number;

begin
  -- Create : hai.letran
  -- Modify : quyet.kieu
  -- DN : Dau ngay
  -- CN : Cuoi ngay
  -- ELSE : Hien tai dang de bang DN , cho nay tuy cac bac xu ly
  pr_error('pr_updatepricefromgw','p_update_mode:' || p_update_mode ||' symbol: '||p_symbol ||'p_basic_price: ' || p_basic_price || ' p_floor_price:'|| p_floor_price || ' p_ceiling_price:'|| p_ceiling_price);
  v_basicprice:=p_basic_price;
  BEGIN
     SELECT   ticksize
       INTO   v_ticksize
       FROM   securities_ticksize
      WHERE       symbol = p_symbol
              AND (p_ceiling_price + p_floor_price) / 2 >= fromprice
              AND (p_ceiling_price + p_floor_price) / 2 <= toprice;
  EXCEPTION
     WHEN OTHERS
     THEN
         v_ticksize  := 1;
  END;
 --Neu chech lech 2 lan ticksize la thuc hien quyen -> lay trung binh tran va san
  IF ABS((p_ceiling_price + p_floor_price)/2 - p_basic_price) > 2* v_ticksize THEN
     v_basicprice:= (p_ceiling_price + p_floor_price)/2;
  END IF;



  l_update_mode := p_update_mode;
  select codeid into l_code_id from securities_info where SYMBOL = p_symbol;

  case
    when l_update_mode = 'DN' then
      -- DN : Dau ngay
      update securities_info
         set FLOORPRICE         = p_floor_price,
             CEILINGPRICE       = p_ceiling_price,
             BASICPRICE         = p_basic_price,
             avgprice           = v_basicprice
             --14/07/2015 TruongLD Fix, PHS khong can cap nhat gia vay dau ngay --> comment doan nay lai
             /*,
             dfrlsprice         = v_basicprice,
             dfrefprice         = v_basicprice,
             marginprice        = v_basicprice,
             margincallprice    = v_basicprice,
             marginrefprice     = v_basicprice,
             marginrefcallprice = v_basicprice*/
       where (CODEID = l_code_id or
             CODEID in (select CODEID from SBSECURITIES where REFCODEID = l_code_id));

    when l_update_mode = 'CN' then
      -- CN : Cuoi ngay

     /* update securities_info
         set dfrefprice         = p_basic_price,
             margincallprice    = p_basic_price,
             marginrefcallprice = p_basic_price,
             avgprice       = p_basic_price*/
     update securities_info
        set avgprice       = p_basic_price
       where (CODEID = l_code_id or
             CODEID in (select CODEID from SBSECURITIES where REFCODEID = l_code_id)); -- Cap nhat cho CK va CK cho giao dich
            /*
            [6:09:31 PM] FSS Quynh Chi: 3 tru?ng n?em oi:
            [6:09:40 PM] FSS Quynh Chi: 1. margincallprice
            [6:09:48 PM] FSS Quynh Chi: 2. marginrefcallprice
            [6:10:04 PM] FSS Quynh Chi: 3. dfrefprice
            [6:10:17 PM] FSS Quynh Chi: trong gi? giao d?ch: l?y gi?h?p g?n nh?t d? update.
            [6:10:33 PM] FSS Quynh Chi: ngay khi nh?n du?c SU: d? t? l?y gi?ham chi?u h?m sau d? update.
            */
    else
      -- Goi khac
      -- DN : Dau ngay

      update securities_info
         set FLOORPRICE         = p_floor_price,
             CEILINGPRICE       = p_ceiling_price,
             BASICPRICE         = p_basic_price,
             avgprice           = v_basicprice
             --14/07/2015 TruongLD Fix, PHS khong can cap nhat gia vay dau ngay --> comment doan nay lai
             /*,
             dfrlsprice         = v_basicprice,
             dfrefprice         = v_basicprice,
             marginprice        = v_basicprice,
             margincallprice    = v_basicprice,
             marginrefcallprice = v_basicprice,
             marginrefprice     = v_basicprice*/
       where (CODEID = l_code_id or
             CODEID in (select CODEID from SBSECURITIES where REFCODEID = l_code_id));

  /*   thu tuc cu cua anh Hai.Letran
                select codeid into v_CODEID from securities_info where SYMBOL = pv_SYMBOL;
                update securities_info set CEILINGPRICE= pv_CeilPrice,
                            FLOORPRICE= pv_FloorPrice,
                            DFREFPRICE = pv_BasicPrice,
                            DFRLSPRICE = pv_BasicPrice,
                            BASICPRICE = pv_BasicPrice
                where CODEID=v_CODEID;
                 UPDATE SECURITIES_INFO SET (CEILINGPRICE, FLOORPRICE, DFREFPRICE, DFRLSPRICE, BASICPRICE) =
                 (SELECT CEILINGPRICE, FLOORPRICE, BASICPRICE, BASICPRICE, BASICPRICE FROM SECURITIES_INFO WHERE CODEID = v_CODEID
                 )
                WHERE SECURITIES_INFO.CODEID=(SELECT CODEID FROM SBSECURITIES WHERE REFCODEID=v_CODEID);
                */

  end case;

  commit;
  p_err_code    := '0';
  p_err_message := 'Cap nhat gia thanh cong';
exception
  when NO_DATA_FOUND then
    p_err_code    := '-100010';
    p_err_message := 'Khong tim thay ma chung khoan';
    rollback;
  when others then
    p_err_code    := '-100011';
    p_err_message := 'Cap nhat gia chung khoan khong thanh cong';
    rollback;
end;
 
 
/
