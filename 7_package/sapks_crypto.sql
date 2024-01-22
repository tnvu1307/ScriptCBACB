SET DEFINE OFF;
CREATE OR REPLACE PACKAGE SAPKS_CRYPTO
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
    FUNCTION fn_encrypt( p_val IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION fn_decrypt( p_val IN VARCHAR2) RETURN VARCHAR2;
END;
 
 
/


CREATE OR REPLACE PACKAGE BODY sapks_crypto
AS
  G_CHARACTER_SET VARCHAR2(10) := 'AL32UTF8';

  G_STRING VARCHAR2(32) := '12345678901234567890123456789012';

  G_KEY RAW(250) := utl_i18n.string_to_raw
                      ( data => G_STRING,
                        dst_charset => G_CHARACTER_SET );

  G_ENCRYPTION_TYPE PLS_INTEGER := dbms_crypto.encrypt_aes256
                                    + dbms_crypto.chain_cbc
                                    + dbms_crypto.pad_pkcs5;
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

  ------------------------------------------------------------------------
  --Encrypt a password
  ------------------------------------------------------------------------
  FUNCTION fn_encrypt(p_val IN VARCHAR2 ) RETURN VARCHAR2
  IS
    l_val RAW(32) := UTL_I18N.STRING_TO_RAW(p_val, G_CHARACTER_SET );
    l_encrypted RAW(32);
    l_str_encrypted VARCHAR2(1000);
  BEGIN

    plog.setbeginsection(pkgctx, 'fn_encrypt');
    l_encrypted := dbms_crypto.encrypt
                   ( src => l_val,
                     typ => G_ENCRYPTION_TYPE,
                     key => G_KEY );

    l_str_encrypted := utl_i18n.raw_to_char
                    ( data => l_encrypted,
                      src_charset => G_CHARACTER_SET );

    plog.setendsection(pkgctx, 'fn_encrypt');
    RETURN l_encrypted;
   Exception when others then
        plog.debug(pkgctx,'fn_encrypt: ' || dbms_utility.format_error_backtrace);
        plog.debug(pkgctx,'Error: ' || SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'fn_encrypt');
        RETURN '';
  END fn_encrypt;

  ------------------------------------------------------------------------
  --Encrypt a password
  ------------------------------------------------------------------------
  FUNCTION fn_decrypt(p_val IN VARCHAR2) RETURN VARCHAR2
  IS
    l_val raw(32) := UTL_I18N.STRING_TO_RAW(p_val, G_CHARACTER_SET );
    l_decrypted raw(32);
    l_decrypted_string VARCHAR2(1000);
  BEGIN
        plog.setbeginsection(pkgctx, 'fn_decrypt');
        l_decrypted := dbms_crypto.decrypt
                ( src => p_val,
                  typ => G_ENCRYPTION_TYPE,
                  key => G_KEY );

        l_decrypted_string := utl_i18n.raw_to_char
                    ( data => l_decrypted,
                      src_charset => G_CHARACTER_SET );

        plog.setendsection(pkgctx, 'fn_decrypt');
        RETURN l_decrypted_string;
    Exception when others then
        plog.debug(pkgctx,'fn_encrypt: ' || dbms_utility.format_error_backtrace);
        plog.debug(pkgctx,'Error: ' || SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'fn_encrypt');
        RETURN '';
  END fn_decrypt;

END sapks_crypto;
/
