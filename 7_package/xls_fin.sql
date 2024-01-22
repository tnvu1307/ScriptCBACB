SET DEFINE OFF;
CREATE OR REPLACE package xls_fin is

  -- Author  : APUTIATINAS
  -- Created : 2015.02.09 13:30:54
  -- Purpose : Implemenation of XLS financial functions
  
  -- Date calendar basis (c_us_nasd is default)
  c_us_nasd constant number  := 0;
  c_actual_actual constant number := 1;
  c_actual_360 constant number := 2;
  c_actual_365 constant number := 3;
  c_european_30_360 constant number := 4;

  -- Payments frequency
  c_annual constant number  := 1;
  c_semiannual constant number := 2;
  c_quarterly constant number := 4;


  -- Public type declarations
    function coupdays(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd
    ) return number deterministic result_cache;



    function coupdaybs(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache;


    function coupdaysnc(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache;


    function coupnum(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache;



    function price(
        p_settlement in date
    , p_maturity in date
    , p_rate in number
    , p_yld in number
    , p_redemption in number
    , p_frequency in number
    , p_basis in number := c_us_nasd
  ) return number deterministic result_cache;






end XLS_FIN;
/


CREATE OR REPLACE package body xls_fin is


  procedure default_params(
        p_settlement in out date
    , p_maturity in out date
    , p_frequency in out number
    , p_basis in out number
  ) is
  begin
    p_settlement := trunc(p_settlement);
    p_maturity := trunc(p_maturity);
    p_frequency := trunc(p_frequency);
    p_basis := nvl(trunc(p_basis), c_us_nasd);
  end;

  procedure check_dates(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number
  ) is

  begin

    if p_settlement >= p_maturity then
        raise_application_error(-20001, 'p_settlement ('||p_settlement||') must be < ('||p_maturity||')');
    end if;

    if p_frequency not in (c_annual, c_semiannual, c_quarterly) then
            raise_application_error(-20001, 'p_frequency ('||p_frequency||') must be one of ('||c_annual||', '||c_semiannual||', '||c_quarterly||')');
    end if;

    if p_basis not in (c_us_nasd, c_actual_actual, c_actual_360, c_actual_365, c_european_30_360) then
            raise_application_error(-20001, 'p_basis ('||p_basis||') must be one of ('||c_us_nasd||', '||c_actual_actual||', '||c_actual_360||', '||c_actual_365||', '||c_european_30_360||')');
    end if;


  end;

  procedure check_params(
            p_rate in number
    , p_yld in number
    , p_redemption in number
  ) is

  begin

    if p_rate < 0 then
        raise_application_error(-20001, 'p_rate ('||p_rate||') must be >= 0');
    end if;

    if p_yld < 0 then
        raise_application_error(-20001, 'p_yld ('||p_yld||') must be >= 0');
    end if;

    if p_redemption <= 0 then
        raise_application_error(-20001, 'p_redemption ('||p_redemption||') must be > 0');
    end if;


  end;



    -- find last coupon date before settlement (can be equal to settlement)
    function last_coupon_before_settl(
        p_settlement in tp_xls_date
    , p_maturity in tp_xls_date
    , p_frequency in number
    ) return tp_xls_date is

    l_ret tp_xls_date;

  begin

    l_ret := new tp_xls_date(p_maturity);

    l_ret.set_year(p_settlement.get_year());

    if sys.diutil.int_to_bool(tp_xls_date.less(l_ret, p_settlement)) then
      l_ret.add_years(1);
    end if;

    loop

      if sys.diutil.int_to_bool(tp_xls_date.less(p_settlement, l_ret)) then

        l_ret.add_months( -12 / p_frequency );

      else

        exit;

      end if;

    end loop;

    return l_ret;

  end;



    -- find first coupon date after settlement (is never equal to settlement)
    function first_coupon_after_settl(
        p_settlement in tp_xls_date
    , p_maturity in tp_xls_date
    , p_frequency in number
    ) return tp_xls_date is

    l_ret tp_xls_date;

  begin


      l_ret := new tp_xls_date(p_maturity);

    l_ret.set_year(p_settlement.get_year());


    if sys.diutil.int_to_bool(tp_xls_date.less(p_settlement, l_ret)) then
      l_ret.add_years(-1);
    end if;


    loop

      if not sys.diutil.int_to_bool(tp_xls_date.less(p_settlement, l_ret)) then

        l_ret.add_months( 12 / p_frequency );

      else

        exit;

      end if;

    end loop;

    return l_ret;

  end;




    function coupdays(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache is

    l_ret number;

    l_settlement tp_xls_date;
    l_maturity tp_xls_date;

    l_date tp_xls_date;
    l_next_date tp_xls_date;

    l_p_settlement date;
    l_p_maturity date;
    l_p_frequency number;
    l_p_basis number;



  begin

        l_p_settlement := p_settlement; 
    l_p_maturity := p_maturity;
    l_p_frequency := p_frequency;
    l_p_basis := p_basis;

        default_params(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    check_dates(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);


    if l_p_basis = c_actual_actual then


      l_settlement := new tp_xls_date(l_p_settlement, l_p_basis);
      l_maturity := new tp_xls_date(l_p_maturity, l_p_basis);



        l_date := new tp_xls_date(last_coupon_before_settl(
          l_settlement
        , l_maturity
        , l_p_frequency)
      ) ;

      l_next_date := new tp_xls_date(l_date);


      l_next_date.add_months(12 / l_p_frequency);

      l_ret := tp_xls_date.get_diff(p_dt_from => l_date, p_dt_till => l_next_date);


    elsif l_p_basis = c_actual_365 then
        l_ret := 365/l_p_frequency;
    else
      l_ret := 360/l_p_frequency;
    end if;

    return l_ret;


  end;


    function coupdaybs(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache is

    l_ret number;
    l_date tp_xls_date;

    l_settlement tp_xls_date;
    l_maturity tp_xls_date;

    l_p_settlement date;
    l_p_maturity date;
    l_p_frequency number;
    l_p_basis number;



  begin

        l_p_settlement := p_settlement; 
    l_p_maturity := p_maturity;
    l_p_frequency := p_frequency;
    l_p_basis := p_basis;

        default_params(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    check_dates(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);


      l_settlement := new tp_xls_date(l_p_settlement, l_p_basis);
    l_maturity := new tp_xls_date(l_p_maturity, l_p_basis);


    l_date := new tp_xls_date(last_coupon_before_settl(
        l_settlement
      , l_maturity
      , l_p_frequency)
    ) ;



    l_ret := tp_xls_date.get_diff(p_dt_from => l_date, p_dt_till => l_settlement);

    return l_ret;



  end;


    function coupdaysnc(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache is

    l_ret number;

    l_date tp_xls_date;
    l_settlement tp_xls_date;

    l_p_settlement date;
    l_p_maturity date;
    l_p_frequency number;
    l_p_basis number;



  begin

        l_p_settlement := p_settlement; 
    l_p_maturity := p_maturity;
    l_p_frequency := p_frequency;
    l_p_basis := p_basis;

        default_params(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    check_dates(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);

    if l_p_basis not in (c_us_nasd, c_european_30_360) then

        l_settlement := new tp_xls_date(l_p_settlement, l_p_basis);

      l_date := new tp_xls_date(first_coupon_after_settl(
            p_settlement => l_settlement
        , p_maturity => new tp_xls_date(l_p_maturity, l_p_basis)
        , p_frequency => l_p_frequency
      )
      );

      l_ret := tp_xls_date.get_diff(p_dt_from => l_settlement, p_dt_till => l_date);

    else

            l_ret := coupdays(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis) - coupdaybs(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);        

    end if;

    return l_ret;

    end;  

    function coupnum(
        p_settlement in date
    , p_maturity in date
    , p_frequency in number
    , p_basis in number := c_us_nasd) return number deterministic result_cache is

    l_maturity tp_xls_date;
    l_date tp_xls_date;

    l_months number;
    l_ret number;

    l_p_settlement date;
    l_p_maturity date;
    l_p_frequency number;
    l_p_basis number;



  begin

        l_p_settlement := p_settlement; 
    l_p_maturity := p_maturity;
    l_p_frequency := p_frequency;
    l_p_basis := p_basis;

        default_params(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    check_dates(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);

      l_maturity := new tp_xls_date(l_p_maturity, l_p_basis);

    l_date := new tp_xls_date(
      last_coupon_before_settl(
          p_settlement => new tp_xls_date(l_p_settlement, l_p_basis)
        , p_maturity => l_maturity
        , p_frequency => l_p_frequency
      ) 
    );


    l_months := (l_maturity.get_year() -  l_date.get_year())*12 + l_maturity.get_month() - l_date.get_month();

    l_ret := trunc(l_months * l_p_frequency / 12);

    return l_ret;

  end;    


    function price(
        p_settlement in date
    , p_maturity in date
    , p_rate in number
    , p_yld in number
    , p_redemption in number
    , p_frequency in number
    , p_basis in number := c_us_nasd
  ) return number deterministic result_cache is

    l_e number;
    l_dsc number;
    l_dsc_e number;
    l_n number;
    l_a number;

    l_t1 number;
    l_t2 number;
    l_t3 number;

    l_ret number;

    l_p_settlement date;
    l_p_maturity date;
    l_p_frequency number;
    l_p_basis number;



  begin

        l_p_settlement := p_settlement; 
    l_p_maturity := p_maturity;
    l_p_frequency := p_frequency;
    l_p_basis := p_basis;

        default_params(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    check_dates(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    check_params(p_rate, p_yld, p_redemption);


        l_e := coupdays(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);
    l_a := coupdaybs(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);

    -- Excel calculation logic
    l_dsc := l_e - l_a;

    -- Open Office calculation logic
    --l_dsc := coupdaysnc(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);

    l_dsc_e := l_dsc/l_e;  

    l_n := coupnum(l_p_settlement, l_p_maturity, l_p_frequency, l_p_basis);

    -- XLS has separate logic if number of coupon = 1
    -- OpenOffice use the same logic for any coupon number;


        if l_n > 1 then 

      l_ret := p_redemption/power(1 + p_yld/l_p_frequency, l_n - 1 +  l_dsc_e);

      l_ret := l_ret - 100*p_rate/l_p_frequency*l_a/l_e;

      l_t1 := 100*p_rate/l_p_frequency;
      l_t2 := 1 + p_yld/l_p_frequency;

      for i in 0..l_n - 1 loop
        l_ret := l_ret + l_t1/power(l_t2, i + l_dsc_e);
      end loop;


    else

        l_t1 := 100*p_rate/l_p_frequency + p_redemption;
      l_t2 := p_yld/l_p_frequency*l_dsc/l_e + 1;
      l_t3 := 100*p_rate/l_p_frequency*l_a/l_e;

      l_ret := l_t1/l_t2 - l_t3;


    end if;

        return l_ret;

  end;



end XLS_FIN;
/
