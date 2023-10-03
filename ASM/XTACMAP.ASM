XTACMAP  TITLE 'TARA MODULE - COMMON STORAGE AREA MAP'                  00040000
XTACMAP  CSECT                                                          00050000
         AGO   .COMMON                                                  00060000
.DSECT   ANOP                                                           00070000
XTACMAP  DSECT                                                          00080000
.COMMON  ANOP                                                           00090000
         SPACE 2                                                        00100000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00110000
*                                                                     * 00120000
*     MODULE NAME - XTACMAP                                           * 00130000
*                                                                     * 00140000
*     FUNCTIONAL DESCRIPTION - THIS CODE IS INCLUDED IN EACH TARA     * 00150000
*       MODULE TO MAP THE COMMON STORAGE AREA. SETB SYMBOL &MAP       * 00160000
*       MUST BE SET TO 1 FOR A DSECT TO BE GENERATED. WHEN THIS       * 00170000
*       MODULE IS ASSEMBLED ALONE, A NON-REENTRANT, NON-EXECUTABLE    * 00180000
*       DATA MODULE IS PRODUCED. THIS MODULE IS THEN LINKED WITH      * 00190000
*       ALL THE OTHER TARA MODULES, RESOLVING THE EXTERNAL            * 00200000
*       REFERENCES.                                                   * 00210000
*                                                                     * 00220000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00230000
         SPACE 2                                                        00240000
         PUSH  PRINT                                                    00250000
         PRINT GEN                                                      00260000
         TITLE 'TARA COMMON STORAGE - VTAM ACB AND RELATED DATA'        00270000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00280000
*                                                                     * 00290000
*                    ACCESS-METHOD CONTROL BLOCK                      * 00300000
*                                                                     * 00310000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00320000
         SPACE 1                                                        00330000
CS#ACB   ACB   AM=VTAM,            CREATE A VTAM ACB                   +00340000
               APPLID=CS#APLID,    POINTER TO VTAM APPLICATION ID      +00350000
               EXLST=CS#EXLST,     LIST OF EXIT ROUTINES               +00360000
               MACRF=LOGON         APPLICATION ALLOWS LOGONS            00370000
         EJECT                                                          00380000
         DS    0D                                                       00390000
CS#APLID DC    XL1'8',CL8'TARA'                                         00400000
         TITLE 'TARA COMMON STORAGE - EXIT LISTS'                       00410015
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00420000
*                                                                     * 00430000
*                           ACB EXIT LIST                             * 00440015
*                                                                     * 00450000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00460000
         SPACE 1                                                        00470000
CS#EXLST EXLST AM=VTAM,                                                +00480000
               LERAD=CS#ALRDX,                                         +00490000
               LOGON=CS#ALOGX,                                         +00500000
               LOSTERM=CS#ALSTX,                                       +00510000
               SYNAD=CS#ASYDX,                                         +00520000
               TPEND=CS#ATPNX                                           00530000
         EJECT                                                          00530115
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00531015
*                                                                     * 00532015
*                           NIB EXIT LIST                             * 00533015
*                                                                     * 00534015
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00535015
         SPACE 1                                                        00536015
CS#NIBEX EXLST AM=VTAM,                                                +00537015
               DFASY=CS#ADFAX                                           00538015
         TITLE 'TARA COMMON STORAGE - NON-SESSION-RELATED RPLS'         00540000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00550000
*                                                                     * 00560000
*                RPLS USED BEFORE SESSION ESTABLISHMENT               * 00570000
*                                                                     * 00580000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00590000
         SPACE 1                                                        00600000
CS#STLGN RPL   AM=VTAM,                                                +00610000
               ACB=(CS#ACB),                                           +00620000
               OPTCD=(SYN,START)                                        00630000
         TITLE 'TARA COMMON STORAGE - ADDRESSES OF TARA ROUTINES'       00680000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00690000
*                                                                     * 00700000
*                          MODULE ADDRESSES                           * 00710000
*                                                                     * 00720000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00730000
         SPACE 1                                                        00740000
         DS    0F                                                       00750000
CS#AMAIN DC    V(XTAMAIN)          1.0: MAINLINE ROUTINE                00760000
CS#ALOGX DC    V(XTALOGX)          2.0: LOGON EXIT                      00770000
CS#AOPRX DC    V(XTAOPRX)          3.0: OPNDST PRIMARY RPL EXIT         00780000
CS#AOSRX DC    V(XTAOSRX)          4.0: OPNDST SECONDARY RPL EXIT       00790000
CS#APRRX DC    V(XTAPRRX)          5.0: PRIMARY RECEIVE RPL EXIT        00800000
CS#AACQR DC    V(XTAACQR)          6.0: ACQUIRE ROUTINE                 00810000
CS#ALOGF DC    V(XTALOGF)          7.0: LOGOFF ROUTINE                  00820000
CS#ASRRX DC    V(XTASRRX)          8.0: SECONDARY RECEIVE RPL EXIT      00830000
CS#ADROP DC    V(XTADROP)          9.0: DROP SECONDARY ROUTINE          00840000
CS#APSMR DC    V(XTAPSMR)          10.0: PRIMARY SCREEN MANAGEMENT      00850000
CS#ASNRX DC    V(XTASNRX)          11.0: SEND RPL EXIT                  00860000
CS#AEKOX DC    V(XTAEKOX)          12.0: ECHO SEND RPL EXIT             00870000
CS#ACLDX DC    V(XTACLDX)          13.0: CLSDST RPL EXIT                00880000
CS#ALOGR DC    V(XTALOGR)          14.0: LOGGING ROUTINE                00890000
CS#ALSTX DC    V(XTALSTX)          15.0: LOSTERM EXIT                   00900000
CS#ATPNX DC    V(XTATPNX)          16.0: TPEND EXIT                     00910000
CS#ALRDX DC    V(XTALRDX)          17.0: LERAD EXIT                     00920000
CS#ASYDX DC    V(XTASYDX)          18.0: SYNAD EXIT                     00930000
CS#ACLNP DC    V(XTACLNP)          19.0: SESSION TERMINATION ROUTINE    00940000
CS#ARCVY DC    V(XTARCVY)          20.0: ERROR RECOVERY ROUTINE         00950000
CS#ASCMD DC    V(XTASCMD)          21.0: SYSTEM COMMAND MODULE          00960000
CS#ASAVE DC    V(XTASAVE)          22.0: SAVE COMMAND PROCESSOR         00970008
CS#ACPTR DC    V(XTACPTR)          23.0: CAPTURE DATA ROUTINE           00980010
CS#ACPTT DC    A(0)                24.0: CAPTURE DATA TASK              00990008
CS#ACPTX DC    V(XTACPTX)          25.0: CAPTURE DATA TASK ETXR         01000010
CS#ASCRX DC    V(XTASCRX)          26.0: SESSIONC CLEAR RPL EXIT        01010016
CS#ADFAX DC    V(XTADFAX)          27.0: DFASY EXIT                     01020008
         TITLE 'TARA COMMON STORAGE - EVENT CONTROL BLOCKS'             01050000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01060000
*                                                                     * 01070000
*                        EVENT CONTROL BLOCKS                         * 01080000
*                                                                     * 01090000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01100000
         SPACE 1                                                        01110000
         DS    0F                                                       01120000
CS#ECBTP DC    F'0'                TPEND ECB                            01130000
CS#ECBID DC    F'0'                IDLE ECB                             01140000
         SPACE 1                                                        01150000
CS#ECBL  DS    0CL12               THE ECBLIST                          01160000
CS#ECBL1 DC    A(CS#ECBTP)                                              01170000
CS#ECBL2 DC    A(CS#ECBID)                                              01180000
CS#ECBL3 DC    XL1'80',AL3(0)      COMM TASK ECB AND ECBLIST END        01190000
         TITLE 'TARA COMMON STORAGE - DATA CONTROL BLOCK'               01200000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01210000
*                                                                     * 01220000
*                          LOG DATASET DCB                            * 01230000
*                                                                     * 01240000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01250000
         SPACE 1                                                        01260000
CS#LOGLK DS    F                   SERIALIZATION LOCK                   01271018
CS#LOG   DCB   DDNAME=XTALOGDS,                                        X01280000
               MACRF=(PM),                                             X01290000
               LRECL=512,                                              X01300000
               DEVD=DA,                                                X01310000
               DSORG=PS,                                               X01320000
               EROPT=ACC,                                              X01330000
               RECFM=VB                                                 01340000
         EJECT                                                          01350000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01360000
*                                                                     * 01370000
*                         SNAP DATASET DCB                            * 01380000
*                                                                     * 01390000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01400000
         SPACE 1                                                        01410000
CS#SNPLK DS    F                   SERIALIZATION LOCK                   01411018
CS#SNAP  DCB   DDNAME=XTASNAP,                                         X01430000
               MACRF=(W),                                              X01440000
               LRECL=125,                                              X01450000
               DEVD=DA,                                                X01460000
               DSORG=PS,                                               X01470000
               BLKSIZE=1632,                                           X01480000
               RECFM=VBA                                                01490000
         TITLE 'TARA COMMON STORAGE - PHASE INDICATION'                 01650000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01660000
*                                                                     * 01670000
*                          PHASE TRACE AREA                           * 01680000
*                                                                     * 01690000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01700000
         SPACE 1                                                        01710000
*- - - - - - - - - - - - - - EYECATCHERS - - - - - - - - - - - - - - -* 01740000
         SPACE 1                                                        01750000
         DS    0F                                                       01751002
         DC    CL16'PHASE TRACE AREA'                                   01760000
         DS    0H                                                       01770000
         DC    X'FFFF'             INDICATES FIRST (OLDEST) PHASE       01780000
         SPACE 1                                                        01790000
*- - - - - - - - - - - - - PHASE TRACE AREA  - - - - - - - - - - - - -* 01800000
         SPACE 1                                                        01810000
CS#THEN  DC    XL(127*2)'0'        PREVIOUS 127 PROCESSES               01820002
CS#NOW   DC    X'DEAD'             CURRENT PROCESS                      01830000
         SPACE 1                                                        01840000
*- - - - - - - - - - - - - -  EYECATCHER - - - - - - - - - - - - - - -* 01850000
         SPACE 1                                                        01860000
         DC    X'CCCC'             INDICATES CURRENT PHASE IS ADJACENT  01870000
         TITLE 'TARA COMMON STORAGE - FLAG BYTES'                       01880000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01890000
*                                                                     * 01900000
*                              FLAGS                                  * 01910000
*                                                                     * 01920000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01930000
         SPACE 2                                                        01940000
         DS    0F                                                       01950000
CS#FLAG1 DC    X'00'                                                    01960000
         SPACE 1                                                        01970000
CS#STOPI EQU   B'10000000'         STOPPED FLAG                         01980013
CS#TPNXI EQU   B'01000000'         TPEND EXIT WAS DRIVEN                01990013
CS#F1_3  EQU   B'00100000'         .                                    02000013
CS#F1_4  EQU   B'00010000'         .                                    02010001
CS#F1_5  EQU   B'00001000'         .                                    02020001
CS#F1_6  EQU   B'00000100'         .                                    02030001
CS#F1_7  EQU   B'00000010'         .                                    02040001
CS#F1_8  EQU   B'00000001'         .                                    02050001
         SPACE 3                                                        02060000
CS#FLAG2 DC    X'00'                                                    02070000
         SPACE 1                                                        02080000
CS#F2_1  EQU   B'10000000'         .                                    02090001
CS#F2_2  EQU   B'01000000'         .                                    02100001
CS#F2_3  EQU   B'00100000'         .                                    02110001
CS#F2_4  EQU   B'00010000'         .                                    02120001
CS#F2_5  EQU   B'00001000'         .                                    02130001
CS#F2_6  EQU   B'00000100'         .                                    02140001
CS#F2_7  EQU   B'00000010'         .                                    02150001
CS#F2_8  EQU   B'00000001'         .                                    02160001
         TITLE 'TARA COMMON STORAGE - STATISTICS AREA'                  02170000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02180000
*                                                                     * 02190000
*                            STATISTICS                               * 02200000
*                                                                     * 02210000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02220000
         SPACE 2                                                        02230000
CS#SSNCT DS    F                   SESSION_COUNT                        02240000
         TITLE 'TARA COMMON STORAGE - QUEUE ANCHOR BLOCKS'              02370000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02380000
*                                                                     * 02390000
*                       QUEUE ANCHOR BLOCKS                           * 02400000
*                                                                     * 02410000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02420000
         SPACE 2                                                        02430000
         DS    0F                                                       02440000
CS#SSQAB DS    0FL8                QAB FOR SESSION-STORAGE              02450000
CS#SSFST DC    A(0)                POINTER TO FIRST SSA                 02460001
CS#SSLST DC    A(0)                POINTER TO LAST SSA                  02470001
         TITLE 'TARA COMMON STORAGE - HALT/HADT'                        02471012
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02472012
*                                                                     * 02473012
*                        LU STATUS INFO                               * 02474012
*                                                                     * 02475012
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02476012
         SPACE 2                                                        02476112
CS#HATLK DS    F                   SERIALIZATION LOCK                   02476218
CS#AHALT DS    A                   ADDRESS OF THE HOST ALIAS TABLE      02476312
         SPACE 1                                                        02477012
*               DSECT FOR HOST ALIAS TABLE ENTRY                        02478012
         SPACE 1                                                        02479012
XTAHALT  DSECT                                                          02479112
HT#AHNE  DS    A                   ADDR OF ENTRY FOR THIS HOST IN HNAT  02479212
HT#LALE  DS    YL1                 LENGTH OF ALIAS NAME                 02479312
HT#ALIAS DS    CL11                THE ALIAS NAME                       02479412
HT#NXTAL EQU   *                   START OF NEXT ENTRY                  02479512
         SPACE 1                                                        02479612
*                DSECT FOR HOST NAME TABLE ENTRY                        02479712
         SPACE 1                                                        02479812
XTAHADT  DSECT                                                          02479912
HT#NUMND DS    H                   NUMBER OF NODES FOR THIS HOST        02480012
HT#HNODP DS    CL6                 PREFIX OF NODE NAMES FOR THIS HOST   02480112
HT#STATF DS    XL1                 STATUS FLAGS                         02480212
         SPACE 1                                                        02480312
HT#NOGEN EQU   B'10000000'         NO GENERATED LINE AVAILABLE          02480412
HT#INUSE EQU   B'01000000'         THIS LU IS IN USE                    02480512
HT#SSUPD EQU   B'00100000'         LU OWNED BY A SUSPENDED SESSION      02480612
         TITLE 'TARA COMMON STORAGE - EQUATES'                          02481000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02490000
*                                                                     * 02500000
*                  COMMON EQUATES FOR UNIQUE AREAS                    * 02510012
*                                                                     * 02520000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02530000
         SPACE 2                                                        02540000
WAITING  EQU   B'10000000'         'WAITING TO BE POSTED' BIT IN ECB    02550000
POSTED   EQU   B'01000000'         'POSTED' BIT IN ECB                  02560000
         POP   PRINT                                                    02810000
         AIF   (&MAP EQ 1).NOEND                                        02820000
         END                                                            02830000
         AGO   .NOCSECT                                                 02840000
.NOEND   ANOP                                                           02850000
&SYSECT  CSECT                                                          02860000
.NOCSECT ANOP                                                           02870000