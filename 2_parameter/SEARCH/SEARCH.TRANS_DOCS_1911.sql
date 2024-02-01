SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TRANS_DOCS_1911','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TRANS_DOCS_1911', 'Danh sách giao dịch chuyển nhượng', 'Transfer list', 'SELECT BST.TXNUM, BST.TXDATE, BST.BKDATE,
       BST.ACCTNO SACCTNO,          --ACCTNO CUA BEN CHUYEN NHUONG
       BST.ACCTREF RACCTNO,         --ACCTNO CUA BEN NHAN CHUYEN NHUONG
       SBSM.CUSTODYCD SCUSTODYCD,   --TKLK BEN CHUYEN NHUONG
       SCF.FULLNAME SFULLNAME,      --TEN BEN CHUYEN NHUONG
       RBSM.CUSTODYCD RCUSTODYCD,   --TKLK BEN NHAN CHUYEN NHUONG
       RCF.FULLNAME RFULLNAME,      --TEN BEN NHAN CHUYEN NHUONG
       RBSM.BONDCODE,               --MA QUY UOC TP
       SB.SYMBOL,                    --MA TP
       BST.NAMT QTTY                     --SO LUONG CHUYEN NHUONG
FROM BONDSETRAN BST, BONDSEMAST RBSM, BONDSEMAST SBSM, SBSECURITIES SB, CFMAST RCF, CFMAST SCF
WHERE BST.TXCD = ''1903'' AND
      BST.ACCTNO = SBSM.ACCTNO AND
      BST.ACCTREF = RBSM.ACCTNO AND
      RBSM.BONDCODE = SB.CODEID AND
      RBSM.CUSTODYCD = RCF.CUSTODYCD AND
      SBSM.CUSTODYCD = SCF.CUSTODYCD AND
      BST.TLTXCD =''1911''', 'BONDSETRAN', 'frmBONDSETRAN', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;