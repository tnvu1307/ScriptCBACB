SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('FEECODE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Account opening (sub)', 'CSTD011', 1, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Ad - hoc fee (sub)', 'CSTD011', 2, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Balance confirmation fee (sub)', 'CSTD011', 3, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Domestic transfer', 'CSTD011', 4, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Information change support (sub)', 'CSTD009', 5, 'Y', 'CSTD009');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Minimum charge (sub)', 'CSTD011', 7, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Overseas outward remittance (sub)', 'CSTD011', 8, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Overseas inward remittance (sub)', 'CSTD011', 8.1, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Proxy voting charge', 'CSTD008', 9, 'Y', 'CSTD008');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Repair charge (sub)', 'CSTD006', 10, 'Y', 'CSTD006');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'STC application fee (sub)', 'CSTD009', 11, 'Y', 'CSTD009');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Safe custodycd Fee (sub)', 'CSTD007', 12, 'Y', 'CSTD007');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Standard STC application fee (sub)', 'CSTD009', 13, 'Y', 'CSTD009');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Transaction charge (sub)', 'CSTD005', 14, 'Y', 'CSTD005');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Information change USD (sub)', 'CSTD011', 15, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Account closing USD (sub)', 'CSTD011', 16, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Securities ownership transfer fee', 'CSTD011', 17, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Other bond agent charge', 'CSTD011', 18, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Custody & bondholder management fee', 'CSTD007', 19, 'Y', 'CSTD007');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Pledged assets management fee', 'CSTD013', 20, 'Y', 'CSTD013');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Paying agency fee', 'CSTD013', 21, 'Y', 'CSTD013');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Domestic remittance (sub)', 'CSTD011', 22, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Escrow fee (sub)', 'CSTD011', 23, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Major Shareholder report - Appendix 6 (sub)', 'CSTD011', 24, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Major Shareholder report - Appendix 7 (sub)', 'CSTD011', 25, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Major Shareholder report - Appendix 18 (sub)', 'CSTD011', 26, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Major Shareholder report - Appendix 19 (sub)', 'CSTD011', 27, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Meeting charge (sub)', 'CSTD008', 28, 'Y', 'CSTD008');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Out of pocket charge (sub)', 'CSTD008', 29, 'Y', 'CSTD008');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Postal ballot charge (sub)', 'CSTD008', 30, 'Y', 'CSTD008');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Physical securities withdrawn/deposit (sub)', 'CSTD011', 31, 'Y', 'CSTD011');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'FEECODE', 'Bank charge for Citad', 'CSTD011', 32, 'Y', 'CSTD011');COMMIT;