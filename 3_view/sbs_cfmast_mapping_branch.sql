SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW SBS_CFMAST_MAPPING_BRANCH
(BRANCH, CUSTODYCD, CUSTID)
AS 
SELECT 'SGD HANOI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C120%'
  OR I.CUSTODYCD LIKE '017C121%'
  OR I.CUSTODYCD LIKE '017C122%'
  OR I.CUSTODYCD LIKE '017C124%')
  UNION
  SELECT 'CN HANOI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C125%'
  OR I.CUSTODYCD LIKE '017C126%'
  OR I.CUSTODYCD LIKE '017C127%'
  OR I.CUSTODYCD LIKE '017C128%'
  OR I.CUSTODYCD LIKE '017C129%')
  UNION
  SELECT 'CN DONGDO' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C130%'
  OR I.CUSTODYCD LIKE '017C131%'
  OR I.CUSTODYCD LIKE '017C132%'
  OR I.CUSTODYCD LIKE '017C134%')
  UNION
  SELECT 'CN 8/3 HN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C135%'
  OR I.CUSTODYCD LIKE '017C136%'
  OR I.CUSTODYCD LIKE '017C137%'
  OR I.CUSTODYCD LIKE '017C138%'
  OR I.CUSTODYCD LIKE '017C139%')
  UNION
  SELECT 'CN THANG LONG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C140%'
  OR I.CUSTODYCD LIKE '017C141%'
  OR I.CUSTODYCD LIKE '017C142%'
  OR I.CUSTODYCD LIKE '017C143%'
  OR I.CUSTODYCD LIKE '017C144%')
  UNION
  SELECT 'CN THANH TRI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C145%'
  OR I.CUSTODYCD LIKE '017C146%'
  OR I.CUSTODYCD LIKE '017C147%'
  OR I.CUSTODYCD LIKE '017C148%'
  OR I.CUSTODYCD LIKE '017C149%')
  UNION
  SELECT 'CN LONG BIEN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C155%'
  OR I.CUSTODYCD LIKE '017C156%'
  OR I.CUSTODYCD LIKE '017C157%'
  OR I.CUSTODYCD LIKE '017C158%'
  OR I.CUSTODYCD LIKE '017C159%')
  UNION
  SELECT 'CN BAC NINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C160%'
  OR I.CUSTODYCD LIKE '017C161%'
  OR I.CUSTODYCD LIKE '017C162%'
  OR I.CUSTODYCD LIKE '017C163%'
  OR I.CUSTODYCD LIKE '017C164%')
  UNION
  SELECT 'CN HUNG YEN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C165%'
  OR I.CUSTODYCD LIKE '017C166%'
  OR I.CUSTODYCD LIKE '017C168%')
  UNION
  SELECT 'CN HAI DUONG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C171%'
  OR I.CUSTODYCD LIKE '017C172%'
  OR I.CUSTODYCD LIKE '017C173%'
  OR I.CUSTODYCD LIKE '017C174%')
  UNION
  SELECT 'CN HAI PHONG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C175%'
  OR I.CUSTODYCD LIKE '017C176%'
  OR I.CUSTODYCD LIKE '017C177%'
  OR I.CUSTODYCD LIKE '017C178%'
  OR I.CUSTODYCD LIKE '017C179%')
  UNION
  SELECT 'CN LANG SON' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C180%'
  OR I.CUSTODYCD LIKE '017C182%'
  OR I.CUSTODYCD LIKE '017C183%'
  OR I.CUSTODYCD LIKE '017C184%')
  UNION
  SELECT 'CN THANH HOA' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C187%')
  UNION
  SELECT 'CN QUANG NINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C190%'
  OR I.CUSTODYCD LIKE '017C192%'
  OR I.CUSTODYCD LIKE '017C193%'
  OR I.CUSTODYCD LIKE '017C194%')
  AND I.CUSTODYCD <> '017C194068'
  -- SBS DA NANG
  UNION
  SELECT 'CN THUA THIEN HUE' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C210%'
  OR I.CUSTODYCD LIKE '017C211%'
  OR I.CUSTODYCD LIKE '017C212%'
  OR I.CUSTODYCD LIKE '017C213%'
  OR I.CUSTODYCD LIKE '017C214%')
  UNION
  SELECT 'CN QUANG TRI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C215%'
  OR I.CUSTODYCD LIKE '017C216%'
  OR I.CUSTODYCD LIKE '017C217%'
  OR I.CUSTODYCD LIKE '017C218%'
  OR I.CUSTODYCD LIKE '017C219%'
  OR I.CUSTODYCD LIKE '017C194068')
  UNION
  SELECT 'CN DA NANG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C220%'
  OR I.CUSTODYCD LIKE '017C221%'
  OR I.CUSTODYCD LIKE '017C222%'
  OR I.CUSTODYCD LIKE '017C223%'
  OR I.CUSTODYCD LIKE '017C224%')
  UNION
  SELECT 'CN QUANG NAM' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C225%'
  OR I.CUSTODYCD LIKE '017C226%'
  OR I.CUSTODYCD LIKE '017C227%'
  OR I.CUSTODYCD LIKE '017C228%'
  OR I.CUSTODYCD LIKE '017C229%')
  UNION
  SELECT 'CN QUANG NGAI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C230%'
  OR I.CUSTODYCD LIKE '017C231%'
  OR I.CUSTODYCD LIKE '017C232%'
  OR I.CUSTODYCD LIKE '017C233%'
  OR I.CUSTODYCD LIKE '017C234%')
  UNION
  SELECT 'CN QUANG BINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C235%'
  OR I.CUSTODYCD LIKE '017C236%'
  OR I.CUSTODYCD LIKE '017C237%'
  OR I.CUSTODYCD LIKE '017C238%'
  OR I.CUSTODYCD LIKE '017C239%')
  UNION
  SELECT 'CN PHU YEN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C240%'
  OR I.CUSTODYCD LIKE '017C241%'
  OR I.CUSTODYCD LIKE '017C242%'
  OR I.CUSTODYCD LIKE '017C243%'
  OR I.CUSTODYCD LIKE '017C244%')
  UNION
  SELECT 'CN GIA LAI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C245%'
  OR I.CUSTODYCD LIKE '017C246%'
  OR I.CUSTODYCD LIKE '017C247%'
  OR I.CUSTODYCD LIKE '017C248%'
  OR I.CUSTODYCD LIKE '017C249%')
  UNION
  SELECT 'CN BINH DINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C255%'
  OR I.CUSTODYCD LIKE '017C256%'
  OR I.CUSTODYCD LIKE '017C257%'
  OR I.CUSTODYCD LIKE '017C258%'
  OR I.CUSTODYCD LIKE '017C259%')
  UNION
  SELECT 'CN NGHE AN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C196%'
  OR I.CUSTODYCD LIKE '017C197%'
  OR I.CUSTODYCD LIKE '017C198%'
  OR I.CUSTODYCD LIKE '017C199%')
  UNION
  SELECT 'CN KON TUM' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C260%'
  OR I.CUSTODYCD LIKE '017C261%'
  OR I.CUSTODYCD LIKE '017C262%')
  -- CHI NHANH SAI GON
  UNION
  SELECT 'CN PHU QUOC' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C310%'
  OR I.CUSTODYCD LIKE '017C311%'
  OR I.CUSTODYCD LIKE '017C312%'
  OR I.CUSTODYCD LIKE '017C313%'
  OR I.CUSTODYCD LIKE '017C314%')
  UNION
  SELECT 'CN HUNG DAO' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C315%'
  OR I.CUSTODYCD LIKE '017C316%'
  OR I.CUSTODYCD LIKE '017C317%'
  OR I.CUSTODYCD LIKE '017C318%'
  OR I.CUSTODYCD LIKE '017C319%')
  UNION
  SELECT 'CN LONG AN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C325%'
  OR I.CUSTODYCD LIKE '017C326%'
  OR I.CUSTODYCD LIKE '017C327%'
  OR I.CUSTODYCD LIKE '017C328%'
  OR I.CUSTODYCD LIKE '017C329%')
  UNION
  SELECT 'CN VINH LONG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C330%'
  OR I.CUSTODYCD LIKE '017C331%'
  Or I.Custodycd Like '017C332%'
 -- OR I.CUSTODYCD LIKE '017C333%'
  OR I.CUSTODYCD LIKE '017C334%')
  UNION
  SELECT 'CN CAN THO' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C335%'
  OR I.CUSTODYCD LIKE '017C336%'
  OR I.CUSTODYCD LIKE '017C337%'
  OR I.CUSTODYCD LIKE '017C338%'
  OR I.CUSTODYCD LIKE '017C339%')
  AND I.CUSTODYCD NOT IN ('017C339999','017C335000','017C338899')
  UNION
  SELECT 'CN HAU GIANG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C340%'
  OR I.CUSTODYCD LIKE '017C341%'
  OR I.CUSTODYCD LIKE '017C342%'
  OR I.CUSTODYCD LIKE '017C343%'
  OR I.CUSTODYCD LIKE '017C344%')
  UNION
  SELECT 'CN CA MAU' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C350%'
  OR I.CUSTODYCD LIKE '017C351%'
  OR I.CUSTODYCD LIKE '017C352%'
  OR I.CUSTODYCD LIKE '017C353%'
  OR I.CUSTODYCD LIKE '017C354%')
  UNION
  SELECT 'CN BAC LIEU' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C355%'
  OR I.CUSTODYCD LIKE '017C356%'
  OR I.CUSTODYCD LIKE '017C357%'
  OR I.CUSTODYCD LIKE '017C358%'
  OR I.CUSTODYCD LIKE '017C359%')
  AND I.CUSTODYCD!='017C325555'
  UNION
  SELECT 'CN SOC TRANG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C435%'
  OR I.CUSTODYCD LIKE '017C436%'
  OR I.CUSTODYCD LIKE '017C437%'
  OR I.CUSTODYCD LIKE '017C438%'
  OR I.CUSTODYCD LIKE '017C439%')
  UNION
  SELECT 'CN CU CHI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C360%'
  OR I.CUSTODYCD LIKE '017C361%'
  OR I.CUSTODYCD LIKE '017C362%')
  UNION
  SELECT 'CN TAY NINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C363%'
  OR I.CUSTODYCD LIKE '017C364%'
  OR I.CUSTODYCD LIKE '017C365%'
  OR I.CUSTODYCD LIKE '017C366%'
  OR I.CUSTODYCD LIKE '017C367%')
  UNION
  SELECT 'CN TRA VINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C368%'
  OR I.CUSTODYCD LIKE '017C369%'
  OR I.CUSTODYCD LIKE '017C370%'
  OR I.CUSTODYCD LIKE '017C371%'
  OR I.CUSTODYCD LIKE '017C372%')
  UNION
  SELECT 'CN HOC MON' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C373%'
  OR I.CUSTODYCD LIKE '017C374%'
  OR I.CUSTODYCD LIKE '017C375%')
  UNION
  SELECT 'CN KIEN GIANG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C376%'
  OR I.CUSTODYCD LIKE '017C377%'
  OR I.CUSTODYCD LIKE '017C378%'
  OR I.CUSTODYCD LIKE '017C379%'
  OR I.CUSTODYCD LIKE '017C380%')
  UNION
  SELECT 'CN DONG NAI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE I.CUSTODYCD!='017C383939'
  AND (I.CUSTODYCD LIKE '017C381%'
  OR I.CUSTODYCD LIKE '017C382%'
  OR I.CUSTODYCD LIKE '017C383%'
  OR I.CUSTODYCD LIKE '017C384%'
  OR I.CUSTODYCD LIKE '017C385%')
  UNION
  SELECT 'CN QUAN 4' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C386%'
  OR I.CUSTODYCD LIKE '017C387%'
  OR I.CUSTODYCD LIKE '017C388%')
  UNION
  SELECT 'CN TAN BINH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C389%')
  UNION
  SELECT 'CN ETOWN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C390%'
  OR I.CUSTODYCD LIKE '017C391%')
  UNION
  SELECT 'CN GO VAP' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C392%'
  OR I.CUSTODYCD LIKE '017C393%'
  OR I.CUSTODYCD LIKE '017C394%')
  UNION
  SELECT 'CN BINH THANH' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C395%'
  OR I.CUSTODYCD LIKE '017C396%'
  OR I.CUSTODYCD LIKE '017C397%')
  UNION
  SELECT 'CN DAKLAK' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C250%'
  OR I.CUSTODYCD LIKE '017C251%'
  OR I.CUSTODYCD LIKE '017C252%'
  OR I.CUSTODYCD LIKE '017C253%'
  OR I.CUSTODYCD LIKE '017C254%')
  UNION
  SELECT 'CN DONG THAP' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C345%'
  OR I.CUSTODYCD LIKE '017C346%'
  OR I.CUSTODYCD LIKE '017C347%'
  OR I.CUSTODYCD LIKE '017C348%'
  OR I.CUSTODYCD LIKE '017C349%')
  UNION
  SELECT 'CN KHANH HOA' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C510%'
  OR I.CUSTODYCD LIKE '017C511%'
  OR I.CUSTODYCD LIKE '017C512%'
  OR I.CUSTODYCD LIKE '017C513%'
  OR I.CUSTODYCD LIKE '017C514%')
  UNION
  SELECT 'CN LAM DONG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C520%'
  OR I.CUSTODYCD LIKE '017C521%'
  OR I.CUSTODYCD LIKE '017C522%'
  OR I.CUSTODYCD LIKE '017C523%'
  OR I.CUSTODYCD LIKE '017C524%')
  UNION
  SELECT 'CN BINH PHUOC' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C525%'
  OR I.CUSTODYCD LIKE '017C526%'
  OR I.CUSTODYCD LIKE '017C527%'
  OR I.CUSTODYCD LIKE '017C528%'
  OR I.CUSTODYCD LIKE '017C529%')
  UNION
  SELECT 'CN BINH THUAN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C545%'
  OR I.CUSTODYCD LIKE '017C546%'
  OR I.CUSTODYCD LIKE '017C547%'
  OR I.CUSTODYCD LIKE '017C548%'
  OR I.CUSTODYCD LIKE '017C549%')
  UNION
  SELECT 'CN NINH THUAN' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C550%'
  OR I.CUSTODYCD LIKE '017C551%'
  OR I.CUSTODYCD LIKE '017C552%'
  OR I.CUSTODYCD LIKE '017C553%'
  OR I.CUSTODYCD LIKE '017C554%')
  UNION
  SELECT 'CN 8/3 SG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C555%'
  OR I.CUSTODYCD LIKE '017C558%'
  OR I.CUSTODYCD LIKE '017C559%')
  UNION
  SELECT 'CN 8/3 SG-PGD NguyenTrai' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C556%'
  OR I.CUSTODYCD LIKE '017C557%')
  /*
  UNION
  SELECT 'CTy Nam Viet' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C560%' OR I.CUSTODYCD LIKE '017C561%' OR I.CUSTODYCD LIKE '017C005859' OR I.CUSTODYCD LIKE '017C335000' OR I.CUSTODYCD LIKE '017C021987')
  */
  -- CN HOA VIET
  UNION
  SELECT 'CN CHO LON' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C410%'
  OR I.CUSTODYCD LIKE '017C411%'
  OR I.CUSTODYCD LIKE '017C412%'
  OR I.CUSTODYCD LIKE '017C413%'
  OR I.CUSTODYCD LIKE '017C414%')
  UNION
  SELECT 'CN HOA VIET' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C415%'
  OR I.CUSTODYCD LIKE '017C416%'
  OR I.CUSTODYCD LIKE '017C417%')
  UNION
  SELECT 'CN BINH TAY' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C418%'
  OR I.CUSTODYCD LIKE '017C419%'
  OR I.CUSTODYCD LIKE '017C420%')
  UNION
  SELECT 'CN BEN TRE' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C320%'
  OR I.CUSTODYCD LIKE '017C321%'
  OR I.CUSTODYCD LIKE '017C322%'
  OR I.CUSTODYCD LIKE '017C323%'
  OR I.CUSTODYCD LIKE '017C324%')
  UNION
  SELECT 'CN TIEN GIANG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C465%'
  OR I.CUSTODYCD LIKE '017C466%'
  OR I.CUSTODYCD LIKE '017C467%'
  OR I.CUSTODYCD LIKE '017C468%'
  OR I.CUSTODYCD LIKE '017C469%')
  UNION
  SELECT 'CN TAN PHU' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C421%'
  OR I.CUSTODYCD LIKE '017C422%'
  OR I.CUSTODYCD LIKE '017C423%'
  OR I.CUSTODYCD LIKE '017C660%'
  OR I.CUSTODYCD LIKE '017C661%'
  OR I.CUSTODYCD LIKE '017C662%'
  OR I.CUSTODYCD LIKE '017C663%')
  UNION
  SELECT 'PGD AN PHU' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C612%')
  UNION
  SELECT 'PGD BINH THAI' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C613%')
  UNION
  SELECT 'PGD KIEN THIET' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C614%')
  UNION
  SELECT 'CN QUAN 8' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C424%'
  OR I.CUSTODYCD LIKE '017C425%'
  OR I.CUSTODYCD LIKE '017C426%')
  UNION
  SELECT 'CN QUAN 10' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C427%'
  OR I.CUSTODYCD LIKE '017C428%'
  OR I.CUSTODYCD LIKE '017C429%')
  UNION
  SELECT 'CN BINH DUONG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C450%'
  OR I.CUSTODYCD LIKE '017C451%'
  OR I.CUSTODYCD LIKE '017C452%'
  OR I.CUSTODYCD LIKE '017C453%'
  OR I.CUSTODYCD LIKE '017C454%')
  -- PHONG ONLINE TRADING
  UNION
  SELECT 'CN THU DUC' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C610%'
  OR I.CUSTODYCD LIKE '017C611%')
  UNION
  SELECT 'CN AN GIANG' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE I.CUSTODYCD <> '017C630114'
  AND (I.CUSTODYCD LIKE '017C630%'
  OR I.CUSTODYCD LIKE '017C631%'
  OR I.CUSTODYCD LIKE '017C632%'
  OR I.CUSTODYCD LIKE '017C633%'
  OR I.CUSTODYCD LIKE '017C634%')
  UNION
  SELECT 'CN TEN GROUP' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C635%'
  OR I.CUSTODYCD LIKE '017C636%'
  OR I.CUSTODYCD LIKE '017C637%'
  OR I.CUSTODYCD LIKE '017C638%'
  OR I.CUSTODYCD LIKE '017C639%'
  OR I.CUSTODYCD='017C626121'
  OR I.CUSTODYCD='017C325555')
  /*
  UNION
  SELECT 'PHO CAFE' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE I.CUSTODYCD LIKE '017C640%'
  */
  /*
  UNION
  SELECT 'TAM DIEM' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C641%' OR I.CUSTODYCD LIKE '017C642%' OR I.CUSTODYCD LIKE '017C643%'OR I.CUSTODYCD LIKE '017C648368')
  */
  /*
  UNION
  SELECT 'DUY THAI' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C651%' OR I.CUSTODYCD LIKE '017C652%' OR I.CUSTODYCD LIKE '017C653%')
  UNION
  SELECT 'QUA CHUONG VANG' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C615%' OR I.CUSTODYCD LIKE '017C616%' OR I.CUSTODYCD LIKE '017C617%')
  UNION
  SELECT 'TIN PHONG' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C621%' OR I.CUSTODYCD LIKE '017C622%')
  */
  -- SBS BA RIA
  UNION
  SELECT 'CN BA RIA' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C710%'
  OR I.CUSTODYCD LIKE '017C711%'
  OR I.CUSTODYCD LIKE '017C712%'
  OR I.CUSTODYCD LIKE '017C713%'
  OR I.CUSTODYCD LIKE '017C714%')
  /*
  UNION
  SELECT 'CN SONG VANG' BRANCH, I.CUSTODYCD, I.CUSTID FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C623%')
  */
  UNION
  SELECT 'AGRIBANK PDP' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C670%'
  OR I.CUSTODYCD LIKE '017C110404'
  OR I.CUSTODYCD LIKE '017C110550')
  UNION
  SELECT 'HONG VIET' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  FROM CFMAST I
  WHERE (I.CUSTODYCD LIKE '017C686%')
  UNION
  SELECT 'SACOMBANK-HOISO' BRANCH,
    I.CUSTODYCD,
    I.CUSTID
  From Cfmast I
  WHERE (I.CUSTODYCD LIKE '017C333%')
/
