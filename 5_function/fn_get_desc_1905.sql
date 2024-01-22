SET DEFINE OFF;
CREATE OR REPLACE function FN_GET_DESC_1905(P_BONDSYMBOL VARCHAR2, P_PERIODINTEREST VARCHAR2, P_CATYPE VARCHAR2)
return varchar2 is
  v_Result varchar2(500);
begin
  if P_CATYPE = '015' then
      v_Result := 'Lai trai phieu '|| P_BONDSYMBOL || ' dinh ky ' ||P_PERIODINTEREST;
  elsif P_CATYPE = '016' then
           v_Result := 'Dao han trai phieu '|| P_BONDSYMBOL ;
  elsif P_CATYPE = '033' then
           v_Result := 'Buy back trai phieu '|| P_BONDSYMBOL ;
  end if;
  return v_Result;
exception
   when others then
    return P_BONDSYMBOL;
end FN_GET_DESC_1905;

/
