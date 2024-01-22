SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_calcppse(pv_PP0 NUMBER,
                     pv_RskMarginRateMax NUMBER, -- Ty le cho vay Max
                     pv_RskMarginRateMin NUMBER, -- Ty le cho vay Min
                     pv_mrseamt NUMBER, -- TS MR
                     pv_dpseamt NUMBER, -- TS TC
                     pv_mrcrlimitmax NUMBER, -- Han muc MR
                     pv_dpcrlimitmax NUMBER, -- Han muc TC
                     pv_MarginPrice NUMBER,  -- Gia cho vay
                     pv_QuotePrice NUMBER,   -- Gia mua
                     pv_DefFeeRate NUMBER,   -- Ty le phi
                     pv_IsMarginRateApply NUMBER, -- Ty le Margin la ty le MAX 1

                     -- pv_RskMargin_IRateMax NUMBER, -- Ty le an toan Max(Rat MR, Rat TC), co' cong do tap trung cp
                     -- pv_RskMargin_IRateMin NUMBER, -- Ty le an toan Min(Rat MR, Rat TC), co' cong do tap trung cp

                     -- pv_MRIRate NUMBER, -- Ty le an toan MR
                     -- pv_DPIRate NUMBER, -- Ty le an toan TC

                     pv_MRLoanRate NUMBER, -- Ty le cho vay MR
                     pv_DPLoanRate NUMBER, -- Ty le cho vay TC
                     pv_TAmr_TC NUMBER,
                     pv_TAmr_OP NUMBER,
                     pv_TAtc_MR NUMBER,
                     pv_TAtc_OP NUMBER
                     )
    RETURN NUMBER IS
    l_Result                NUMBER(20);
    l_buylimitmax           NUMBER(20);
    l_buylimitmin           NUMBER(20);
    l_PPse_Max              NUMBER(20);
    l_PPse_Min              NUMBER(20);
    l_PPse_Over             NUMBER(20);
    l_ppSE                  NUMBER(20);
    l_PP0                   NUMBER(20);

    -- Ty le khong cong do tap trung co phieu
    l_RskMarginRateMax      NUMBER(20,8);
    l_RskMarginRateMin      NUMBER(20,8);

    --Ty le co cong do tap trung CP
    l_RskIMarginRateMax     number(20,8);
    l_RskIMarginRateMin     number(20,8);

    l_mrseamt               NUMBER(20);
    l_dpseamt               NUMBER(20);
    l_mrcrlimitmax          number(20);
    l_dpcrlimitmax          number(20);
    l_MarginPrice           number(20,4);
    l_quoteprice            number(20,4);
    l_DefFeeRate            number(20,4);
    l_IsMarginRateApply     NUMBER(20);

    l_PP0_y                 Number(20);
    l_PP0_x                 Number(20);

    x                       Number(20,8);
    y                       Number(20,8);

    A                       Number(20);
    B                       Number(20);
    C                       Number(20);
    D                       Number(20);
    l_limit_orver           Number(20);  -- Han muc tran
    l_buylimitmax_remain    Number(20);  -- Han muc max con du
    l_buylimitmin_remain    Number(20);  -- Han muc min con du
    l_limit_max             Number(20);  -- Han muc min con du

    l_MRLoanRate            Number(20,8);
    l_DPLoanRate            Number(20,8);
    l_TAmr_TC               Number(20);
    l_TAmr_OP               Number(20);
    l_TAtc_MR               Number(20);
    l_TAtc_OP               Number(20);
    l_TAmax_min             Number(20);
    l_TAmax_OP              Number(20);
    --l_MRIRate               Number(20);
    --l_DPIRate               Number(20);
    --l_SCRIMarginRateMax     Number(20,8);
    --l_SCRIMarginRateMin     Number(20,8);
BEGIN

    l_PP0               := pv_PP0;
    l_RskMarginRateMax  := pv_RskMarginRateMax;
    l_RskMarginRateMin  := pv_RskMarginRateMin;
    l_mrseamt           := pv_mrseamt;
    l_dpseamt           := pv_dpseamt;
    l_mrcrlimitmax      := pv_mrcrlimitmax;
    l_dpcrlimitmax      := pv_dpcrlimitmax;
    l_MarginPrice       := pv_MarginPrice;
    l_quoteprice        := pv_quoteprice;
    l_DefFeeRate        := pv_DefFeeRate;
    l_IsMarginRateApply := pv_IsMarginRateApply;

    l_MRLoanRate        := pv_MRLoanRate;
    l_DPLoanRate        := pv_DPLoanRate;
    l_TAmr_TC           := pv_TAmr_TC;
    l_TAmr_OP           := pv_TAmr_OP;
    l_TAtc_MR           := pv_TAtc_MR;
    l_TAtc_OP           := pv_TAtc_OP;

    --l_SCRIMarginRateMax := pv_RskMargin_IRateMax;
    --l_SCRIMarginRateMin := pv_RskMargin_IRateMin;

    --l_MRIRate           := pv_MRIRate;
    --l_DPIRate           := pv_DPIRate;

    dbms_output.put_line('l_pp0:=' || l_pp0);
    dbms_output.put_line('l_RskMarginRateMax:=' || l_RskMarginRateMax);
    dbms_output.put_line('l_RskMarginRateMin:=' || l_RskMarginRateMin);
    dbms_output.put_line('l_mrseamt:=' || l_mrseamt);
    dbms_output.put_line('l_dpseamt:=' || l_dpseamt);
    dbms_output.put_line('l_mrcrlimitmax:=' || l_mrcrlimitmax);
    dbms_output.put_line('l_dpcrlimitmax:=' || l_dpcrlimitmax);
    dbms_output.put_line('l_MarginPrice:=' || l_MarginPrice);
    dbms_output.put_line('l_quoteprice:=' || l_quoteprice);
    dbms_output.put_line('l_DefFeeRate:=' || l_DefFeeRate);
    dbms_output.put_line('l_IsMarginRateApply:=' || l_IsMarginRateApply);
    dbms_output.put_line('l_MRLoanRate:=' || l_MRLoanRate);
    dbms_output.put_line('l_DPLoanRate:=' || l_DPLoanRate);
    dbms_output.put_line('l_TAmr_TC:=' || l_TAmr_TC);
    dbms_output.put_line('l_TAmr_OP:=' || l_TAmr_OP);
    dbms_output.put_line('l_TAtc_MR:=' || l_TAtc_MR);
    dbms_output.put_line('l_TAtc_OP:=' || l_TAtc_OP);

    l_Result:= 0;
    -- Set han muc mua Min  theo Rmin
    If l_IsMarginRateApply = 1 Then
        -- Truong hop han muc Max theo HM Margin
        l_buylimitmax := GREATEST(0, l_mrcrlimitmax - l_MRSEAMT);
        l_buylimitmin := GREATEST(0, l_dpcrlimitmax - l_DPSEAMT);
        l_TAmax_min   := l_TAmr_TC;
        l_TAmax_OP    := l_TAmr_OP;
        l_limit_max   := l_mrcrlimitmax;
    Else
        -- Truong hop han muc Max theo HN Tra cham
        l_buylimitmin := GREATEST(0, l_mrcrlimitmax - l_MRSEAMT);
        l_buylimitmax := GREATEST(0, l_dpcrlimitmax - l_DPSEAMT);
        l_TAmax_min   := l_TAtc_MR;
        l_TAmax_OP    := l_TAtc_OP;
        l_limit_max   := l_dpcrlimitmax;
    End If;


    dbms_output.put_line('l_pp0:=' || l_pp0);
    dbms_output.put_line('l_RskMarginRateMax:=' || l_RskMarginRateMax);
    dbms_output.put_line('l_RskMarginRateMin:=' || l_RskMarginRateMin);

    dbms_output.put_line('l_mrseamt:=' || l_mrseamt);
    dbms_output.put_line('l_dpseamt:=' || l_dpseamt);
    dbms_output.put_line('l_mrcrlimitmax:=' || l_mrcrlimitmax);
    dbms_output.put_line('l_dpcrlimitmax:=' || l_dpcrlimitmax);
    dbms_output.put_line('l_MarginPrice:=' || l_MarginPrice);
    dbms_output.put_line('l_quoteprice:=' || l_quoteprice);
    dbms_output.put_line('l_DefFeeRate:=' || l_DefFeeRate);
    dbms_output.put_line('l_IsMarginRateApply:=' || l_IsMarginRateApply);
    dbms_output.put_line('l_MRLoanRate:=' || l_MRLoanRate);
    dbms_output.put_line('l_DPLoanRate:=' || l_DPLoanRate);
    dbms_output.put_line('l_TAmr_TC:=' || l_TAmr_TC);
    dbms_output.put_line('l_TAmr_OP:=' || l_TAmr_OP);
    dbms_output.put_line('l_TAtc_MR:=' || l_TAtc_MR);
    dbms_output.put_line('l_TAtc_OP:=' || l_TAtc_OP);

    dbms_output.put_line('l_buylimitmin:=' || l_buylimitmin);
    dbms_output.put_line('l_buylimitmax:=' || l_buylimitmax);
    dbms_output.put_line('l_TAmax_min:=' || l_TAmax_min);
    dbms_output.put_line('l_TAmax_OP:=' || l_TAmax_OP);

    --</Modified 30/01/2015
    -- TH Mua chung khoan ngoai DM
    If l_MRLoanRate + l_DPLoanRate = 0 Then

        l_ppSE := l_pp0;
    ------------------------------------
    -- MUA chung khoan thuoc DM MR
    ------------------------------------
    ElsIf l_MRLoanRate <> 0 and l_DPLoanRate = 0 Then

        y := (l_MRLoanRate * l_MarginPrice ) / (l_quoteprice * (1+ l_DefFeeRate));

        If (1- y) > 0 Then
            l_PP0_y := l_pp0 / (1- y);
        ELse
            l_PP0_y := l_buylimitmax + l_pp0;
        End If;

        l_limit_orver := l_pp0 + l_buylimitmax
                  --+ LEAST( GREATEST( l_PP0_y - l_buylimitmax - l_pp0,0), l_buylimitmin,
                  + LEAST( l_buylimitmin,
                  l_TAmax_min - GREATEST(0, LEAST(l_TAmax_OP - l_limit_max, l_TAmax_min)));
        l_ppSE := LEAST(l_PP0_y, l_limit_orver);

        dbms_output.put_line('1.y:=' || y);
        dbms_output.put_line('1.l_PP0_y:=' || l_PP0_y);
    ------------------------------------
    -- MUA chung khoan thuoc DM TC
    ------------------------------------
    Elsif l_MRLoanRate = 0 and l_DPLoanRate <> 0 Then

        x := (l_DPLoanRate * l_MarginPrice ) / (l_quoteprice * (1+ l_DefFeeRate));

        If (1- x) > 0 Then
            l_PP0_x := l_pp0 / (1- x);
        Else
            l_PP0_x := l_buylimitmax + l_pp0;
        End If;

        l_limit_orver  := l_pp0 + l_buylimitmax
                  + LEAST(l_buylimitmin,
                  l_TAmax_min - GREATEST(0, LEAST(l_TAmax_OP - l_limit_max, l_TAmax_min)));
        l_ppSE := LEAST(l_PP0_x, l_limit_orver);

        dbms_output.put_line('1.x:=' || x);
        dbms_output.put_line('1.l_PP0_x:=' || l_PP0_x);
    ------------------------------------
    -- MUA CK thuoc 2 DM MR
    ------------------------------------
    Elsif l_MRLoanRate <> 0 And l_DPLoanRate <> 0 Then
        --</ Cong thuc moi
        x := l_RskMarginRateMax * l_MarginPrice / (l_quoteprice * (1+ l_DefFeeRate));
        y := l_RskMarginRateMin * l_MarginPrice / (l_quoteprice * (1+ l_DefFeeRate));

        If (1- x) > 0 Then
            l_PP0_x := l_pp0 / (1- x);
        Else
            l_PP0_x := l_buylimitmax;
        End If;

        If (1- y) > 0 Then
            l_PP0_y := l_pp0 / (1- y);
        Else
            l_PP0_y := l_buylimitmin;
        End If;

        If  ((1-x) <= 0) Or ((1- y) <= 0) Then -- MUC CK thuoc 2 DM va co ty le Max >= 100
            /*If (1-y) = 0 Then
                l_ppSE := l_buylimitmax + l_pp0 + l_buylimitmin;
            Else
                l_ppSE := l_buylimitmax + l_pp0 + LEAST(l_PP0_y + l_buylimitmax * y /(1-y) - l_pp0, l_buylimitmin);
            End If;*/
            l_limit_orver := LEAST(l_buylimitmin, GREATEST(0, l_TAmax_min - GREATEST(0, LEAST(l_TAmax_OP - l_limit_max, l_TAmax_min))));
            If (1-y) = 0 Then
                l_ppSE := l_buylimitmax + l_pp0 + l_buylimitmin;
            Else
                l_ppSE := l_buylimitmax + l_pp0 + l_limit_orver
                          + LEAST(((l_pp0 + (l_buylimitmax + l_limit_orver)*y)/(1-y)) - l_pp0, l_buylimitmin - l_limit_orver);
            End If;
        Else
            -- Han muc tran
            l_limit_orver := LEAST(GREATEST(l_PP0_x - l_buylimitmax - l_pp0, 0), l_buylimitmin,
                                        l_TAmax_min - GREATEST(0, LEAST(l_TAmax_OP - l_limit_max, l_TAmax_min)));


            -- 1. Phan topup cua Rmin
            A   := LEAST(l_PP0_y - l_pp0, l_buylimitmin - l_limit_orver) * 1 / y;


            -- 2. Phan quy doi bo sung them sang Rmax cua Rmin
            -- Chu y sua lai  doi voi TH 1-x Or 1-y =0
            B   := LEAST(l_buylimitmax + l_limit_orver,
                                LEAST(l_PP0_y  - l_pp0, l_buylimitmin - l_limit_orver) * (1-y) / y * (1/(1-x) - 1 / (1-y)));

            -- Han muc MUA max con lai
            l_buylimitmax_remain    := GREATEST(l_buylimitmax + l_limit_orver - B, 0);
            -- Han muc MUA min con lai
            l_buylimitmin_remain    := GREATEST(l_buylimitmin - l_limit_orver - A*y, 0);


            -- 3. Phan quy doi Rmax do con du pp0
            C   := LEAST(GREATEST(l_pp0 - A*(1-y), 0) / (1-x),  l_buylimitmax_remain + (l_pp0 - A*(1-y)) );


            -- 4. Phan quy doi Rmin do CK hinh thanh tu muc 02
            D   := LEAST(B * y / (1-y), l_buylimitmin_remain);

            l_ppSE := LEAST(l_PP0_x, A + B + C + D);

        End If;
        dbms_output.put_line('x:=' || x);
        dbms_output.put_line('y:=' || y);
        dbms_output.put_line('l_PP0_x:=' || l_PP0_x);
        dbms_output.put_line('l_PP0_y:=' || l_PP0_y);
        dbms_output.put_line('l_PP0_x:=' || l_PP0_x);
        dbms_output.put_line('l_PP0_y:=' || l_PP0_y);
        dbms_output.put_line('A:=' || A);
        dbms_output.put_line('B:=' || B);
        dbms_output.put_line('C:=' || C);
        dbms_output.put_line('D:=' || D);
        dbms_output.put_line('l_limit_orver:=' || l_limit_orver);
        dbms_output.put_line('l_buylimitmax_remain:=' || l_buylimitmax_remain);
        dbms_output.put_line('l_buylimitmin_remain:=' || l_buylimitmin_remain);
    End If;

    dbms_output.put_line('l_ppSE:=' || l_ppSE);
    l_Result := nvl(l_ppSE,0);
    RETURN l_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
