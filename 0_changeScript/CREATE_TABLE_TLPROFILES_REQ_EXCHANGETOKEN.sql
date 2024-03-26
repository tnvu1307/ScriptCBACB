--DROP TABLE tlprofiles_req_exchangetoken;

CREATE TABLE tlprofiles_req_exchangetoken
    (autoid                         NUMBER NOT NULL,
    clientid                       VARCHAR2(50 BYTE),
    tlid                           VARCHAR2(10 BYTE),
    userid                         VARCHAR2(50 BYTE),
    accesstoken                    VARCHAR2(1200 BYTE),
    status                         VARCHAR2(10 BYTE) DEFAULT 'P',
    error_msg                      VARCHAR2(1000 BYTE)
    );
