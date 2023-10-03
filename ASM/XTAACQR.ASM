XTAACQR  TITLE 'TARA ACQUIRE-SECONDARY ROUTINE (6.0)'                   00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTAACQR                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTAACQR TRANSLATES A HOST "NAME"       * 00060003
*       (FROM THE CDB), TRANSLATES THAT TO AN LU NAME IN A            * 00070003
*       SWITCHED MAJOR NODE, AND ISSUES AN OPNDST FOR THAT LU.        * 00080003
*                                                                     * 00090000
*     DRIVER - XTAACQR IS CALLED FROM XTAPRRX VIA BAL(R).             * 00100003
*                                                                     * 00110000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAACQR.              * 00120000
*                                                                     * 00130000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00140000
*       OF THE EPILOGUE MACRO.                                        * 00150000
*                                                                     * 00160000
*     REGISTERS ON ENTRY -                                            * 00170000
*       BEFORE PROLOGUE:                                              * 00180000
*         R0:  UNPREDICTABLE                                          * 00190000
*         R1:  POINTER TO COMMAND                                     * 00200000
*         R2-8: UNPREDICTABLE                                         * 00210000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00220000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00230000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00240000
*         R12: ADDRESS OF XTAPRRX ENTRY POINT                         * 00250000
*         R13: ADDRESS OF XTAPRRX'S SAVEAREA                          * 00260000
*         R14: RETURN ADDRESS                                         * 00270000
*         R15: ENTRY ADDRESS                                          * 00280000
*       AFTER PROLOGUE:                                               * 00290000
*         R0:  UNPREDICTABLE                                          * 00300000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00310000
*         R2-6: UNPREDICTABLE                                         * 00320000
*         R7:  POINTER TO COMMAND                                     * 00330000
*         R8:  UNPREDICTABLE                                          * 00340000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00350000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00360000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00370000
*         R12: ENTRY ADDRESS                                          * 00380000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00390000
*         R14: RETURN ADDRESS                                         * 00400000
*         R15: ENTRY ADDRESS                                          * 00410000
*                                                                     * 00420000
*     MACROS USED -                                                   * 00430000
*       IBM MACROS:                                                   * 00440000
*         FREEMAIN, GETMAIN, ISTDNIB, MODCB, OPNDST                   * 00450000
*       NON-IBM MACROS:                                               * 00460000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00470000
*                                                                     * 00480000
*     COPY MEMBERS -                                                  * 00490000
*       XTACMAP, XTASMAP                                              * 00500000
*                                                                     * 00510000
*     INPUT -                                                         * 00520000
*       THE COMMAND BUFFER AND THE PRIMARY RPL.                       * 00530000
*                                                                     * 00540000
*     OUTPUT -                                                        * 00550000
*       OPNDST                                                        * 00560000
*                                                                     * 00570000
*     ABENDS -                                                        * 00580000
*       NO ABENDS ARE ISSUED BY THIS MODULE.                          * 00590000
*                                                                     * 00600000
*     MESSAGES ISSUED -                                               * 00610000
*       XTA0601  A CONNECTION CURRENTLY EXISTS.                       * 00620000
*       XTA0602  A CONNECTION IS ALREADY IN PROGRESS.                 * 00630000
*       XTA0603  ALL LINES TO REQUESTED HOST ARE BUSY, PLEASE TRY     * 00640000
*                AGAIN LATER.                                         * 00650000
*       XTA0604  CALL PROCEEDING.                                     * 00660000
*       XTA0604  HOST NAME TOO LONG.                                  * 00670000
*       XTA0604  INVALID COMMAND ENTERED.                             * 00680000
*       XTA0604  DON'T KNOW A HOST BY THIS NAME.                      * 00690000
*       XTA0605  CALL WHO?                                            * 00700000
*                                                                     * 00710000
*     RETURN CODES -                                                  * 00720000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00730000
*                                                                     * 00740000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00750000
XTAACQR  PROLOGUE SUBR=ACQUIRE                                          00760000
         EJECT                                                          00770000
**                                                                      00780000
*                                                                       00790000
    PHASE  6.1 - IS THERE ALREADY A SECONDARY HALF-SESSION ACTIVE?      00800000
*                                                                       00810000
**                                                                      00820000
         LA    R3,XTA0601          BEFORE GOING AHEAD AND PROCESSING    00830000
         TM    SS#FLAG1,SS#SACT      THE CALL, WE FIRST VERIFY THAT     00840001
         BNZ   ERRMSG                THERE ISN'T ONE ACTIVE...          00850000
         SPACE 1                                                        00860000
         LA    R3,XTA0602                                               00870000
         TM    SS#FLAG1,SS#PCONN     ...OR PENDING.                     00880001
         BNZ   ERRMSG                                                   00890000
         EJECT                                                          00900000
**                                                                      00910000
*                                                                       00920000
    PHASE  6.2 - FIND AN AVAILABLE SECONDARY LU                         00930000
*                                                                       00940000
**                                                                      00950000
         SPACE 1                                                        00960000
         LA    R3,NOOPND           POINT TO ERROR MESSAGE.              00970000
         CLI   SS#WORK2,2          IF THERE WEREN'T AT LEAST 2 WORDS    00980005
         BNH   ERRMSG                IN THE INPUT, SORRY CHARLIE.       00990000
         SPACE 1                                                        01000000
         LA    R5,SS#WORK2+3       GET A POINTER TO THE OPERAND BY      01010002
         SLR   R1,R1                 USING THE COMMAND LENGTH AS        01020000
         IC    R1,0(R5)              AN OFFSET.                         01030000
         LA    R5,1(R5,R1)                                              01040000
         LA    R3,TOOLONG          ALIAS NAMES ARE RESTRICTED TO 11     01050000
         CLI   0(R5),11              CHARACTERS IN LENGTH.              01060005
         BH    ERRMSG                                                   01070000
         SPACE 1                                                        01080000
*   SEARCH FOR ALIAS IN HOST ALIAS TABLE (HALT)                         01090000
         SPACE 1                                                        01100000
         LA    R3,BADALIAS         ASSUME THE WORST...                  01110000
         SLR   R8,R8               GET OPERAND LENGTH INTO R8 FOR       01120000
         IC    R8,0(R5)              SUBSEQUENT EXECUTED COMPARES.      01130000
         L     R7,CS#AHALT         POINT TO THE HOST ALIAS TABLE,       01140000
         SH    R7,=H'16'             THEN BACK UP 16 SINCE...           01150000
         USING XTAHALT,R7                                               01151008
         SPACE 1                                                        01160000
HALTLOOP EQU   *                                                        01170000
         LA    R7,HT#NXTAL           WE BUMP 16 TO THE NEXT ENTRY HERE. 01180005
         ICM   R4,15,HT#AHNE       GET ADDRESS OF HOST ADDRESS ENTRY.   01190005
         USING XTAHADT,R4                                               01191008
         BZ    ERRMSG              ZEROES FLAG END OF TABLE.            01200000
         EX    R8,CLC@HOST         -- CLC 0(0,R5),HT#LALE --            01210005
         BNE   HALTLOOP            IF OPERAND¬=ALIAS, TRY AGAIN.        01220000
         SPACE 1                                                        01230000
*   FIND AN AVAILABLE LU ENTRY.                                         01240000
         SPACE 1                                                        01250000
         SLR   R2,R2               PREPARE TO USE R2 AS INDEX REGISTER. 01260000
         LA    R3,BUSY             POINT TO ERROR MESSAGE.              01270000
         LH    R5,HT#NUMND         GET # ENTRIES IN FOR THIS HOST.      01280005
         DROP  R7                                                       01281005
         LA    R6,HT#STATF         POINT TO ENTRIES FOR THIS HOST.      01290005
         SPACE 1                                                        01300000
HNTLOOP  EQU   *                                                        01310000
         LA    R1,0(R2,R6)         GET ADDRESS OF ENTRY BYTE,           01320000
         USING HT#STATF,R1           AND SEE IF THIS LU IS FREE.        01321005
         TM    HT#STATF,HT#NOGEN+HT#INUSE                               01330005
         BZ    GOTONE              IF SO, GO USE IT.                    01340000
         LA    R2,1(R2)            BUMP THE INDEX, TO THE NEXT ENTRY.   01350000
         BCT   R5,HNTLOOP          GO CHECK THIS ONE.                   01360000
         B     ERRMSG              LIST WAS EXHAUSTED WITHOUT SUCCESS.  01370000
         SPACE 1                                                        01380000
GOTONE   EQU   *                                                        01390000
         OI    HT#STATF,HT#INUSE   SHOW THAT WE NOW OWN THIS LU.        01400005
         ST    R1,SS#AHNAE         KEEP A POINTER TO THIS ENTRY.        01410000
         CVD   R2,SS#WORD1         CONVERT THE INDEX NUMBER TO          01420000
         UNPK  SS#WORD1(4),SS#WORD2+2(2)  EBCDIC, AND APPEND IT TO      01430000
         OI    SS#WORD1+3,X'F0'           THE FIVE-CHARACTER LU-NAME    01440000
         MVC   SS#WORK1(5),HT#HNODP       PREFIX SPECIFIED FOR THIS     01450005
         MVC   SS#WORK1+5(3),SS#WORD1+1   HOST.                         01460000
         DROP  R1,R4                                                    01461008
         PUSH  USING                                                    01470000
         L     R2,SS#ANIB          POINT TO THE NIB SO THAT WE CAN      01480000
         USING ISTDNIB,R2            PUT THE LUNAME THERE.              01490000
         MVC   NIBSYM,SS#WORK1                                          01500000
         MVC   SS#SNODE,SS#WORK1   ALSO PUT LUNAME IN SDB!              01510000
         POP   USING                                                    01520000
         EJECT                                                          01530000
**                                                                      01540000
*                                                                       01550000
    PHASE  6.3 - ISSUE THE OPNDST FOR THE SECONDARY                     01560000
*                                                                       01570000
**                                                                      01580000
         OI    SS#FLAG1,SS#PCONN   INDICATE 2NDARY CONNECT IS PENDING   01590001
         LA    R7,CS#ACB           GET ACB ADDRESS                      01600000
         L     R9,SS#ASRPL         GET THE SECONDARY RPL ADDRESS        01610000
         L     R6,CS#AOSRX         GET ADDRESS OF EXIT ROUTINE          01620000
         SPACE                                                          01630000
         L     R2,SS#ANIB          ADDRESS OF NIB                       01640000
         MODCB AM=VTAM,NIB=(R2),BNDAREA=LUSIMBND,RESPLIM=1              01650000
         SPACE                                                          01660000
         OPNDST RPL=(R9),          OPEN THE SECONDARY SESSION          X01670000
               NIB=(R2),                                               X01680000
               ACB=(R7),                                               X01690000
               OPTCD=(ASY,ACQUIRE,CS),                                 X01700000
               EXIT=(R6)                                                01710000
         EJECT                                                          01720000
**                                                                      01730000
*                                                                       01740000
    PHASE  6.4 - TELL PRIMARY THE CONNECT IS IN PROGRESS                01750000
*                                                                       01760000
**                                                                      01770000
         LA    R3,XTA0604          POINT TO MESSAGE                     01780000
         SPACE 1                                                        01790000
ERRMSG   EQU   *                                                        01800000
         LR    R1,R3                                                    01810000
         L     R15,CS#APSMR        PSM ROUTINE ADDRESS                  01820000
         BALR  R14,R15             SEND THE MESSAGE TO PRIMARY          01830000
         EJECT                                                          01840000
**                                                                      01850000
*                                                                       01860000
    PHASE  6.5 - SET DEFAULT PAD PARAMETERS                             01870006
*                                                                       01880000
**                                                                      01890000
         XC    SS#PAD(128),SS#PAD                                       01890110
         XC    SS#PAD+128(128),SS#PAD+128                               01890210
         MVC   SS#PAD(L'PADEFALT),PADEFALT                              01890310
         EJECT                                                          01891006
**                                                                      01892006
*                                                                       01893006
    PHASE  6.99 - EXIT                                                  01894006
*                                                                       01895006
**                                                                      01896006
         SR    R15,R15             ZERO RETURN CODE                     01900000
         EPILOGUE                  RETURN                               01910000
*********************************************************************** 01920000
*********************************************************************** 01930000
********                                                       ******** 01940000
********               END OF EXECUTABLE CODE                  ******** 01950000
********                                                       ******** 01960000
*********************************************************************** 01970000
*********************************************************************** 01980000
         EJECT                                                          01990000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02000000
*                                                                     * 02010000
*        BIND IMAGE FOR THE X.25 NPSI LU SIMULATOR                    * 02020000
*                                                                     * 02030000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02040000
         SPACE                                                          02050000
*                                                                       02060000
*              VALUE         BYTE   MEANING                             02070000
*                                                                       02080000
LUSIMBND EQU   *                                                        02090000
*        DC    X'31'           0    BIND                                02100000
         DC    B'00000001'     1    NONNEGOTIABLE BIND                  02110000
         DC    X'03'           2    FM PROFILE                          02120000
         DC    X'03'           3    TS PROFILE                          02130000
         DC    B'10010000'     4    EXCEPTION RESP; PRI'Y WON'T SEND EB 02140004
         DC    B'10010000'     5    EXCEPTION RESP; SEC'Y WON'T SEND EB 02150000
         DC    B'00010000'     6    BRACKETS NOT USED; EBCDIC CODE      02160004
         DC    B'01000000'     7    HDX CONTENTION                      02170000
         DC    X'00'           8    SECY SEND WINDOW SIZE               02180000
         DC    X'00'           9    SECY RECEIVE WINDOW SIZE            02190000
         DC    X'84'          10    MAX INBOUND RU SIZE = 128           02200012
         DC    X'85'          11    MAX OUTBOUND RU SIZE = 256          02210000
         DC    X'00'          12    PRI SEND WINDOW SIZE                02220000
         DC    X'00'          13    PRI RECEIVE WINDOW SIZE             02230000
         DC    X'00'          14    LU-LU SESSION TYPE                  02240000
         DC    11X'00'     15-25    PS CHARACTERISTICS                  02250000
         DC    X'00'          26    NO CRYPTOGRAPHY                     02260000
*        DC    X'04'          27    LENGTH OF PLU NAME                  02270000
*        DC    C'TARA'     28-31    PLU NAME                            02280000
*        DC    X'00'          32    LENGTH OF USER DATA                 02290000
         DC    XL16'00'             BUFFER                              02300000
         EJECT                                                          02310000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02320000
*                                                                     * 02330000
*        DEFAULT PAD PARAMETERS                                       * 02340006
*                                                                     * 02350000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02360000
         SPACE 1                                                        02370007
*                   -1  -3  -5  -7  -9  11  13  15  17                  02370207
PADEFALT DC    XL18'01017E000101020000000301000000001800'               02370307
*                     -2  -4  -6  -8  10  12  14  16  18                02370407
         EJECT                                                          02371006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02372006
*                                                                     * 02373006
*        EXECUTE OBJECTS                                              * 02374006
*                                                                     * 02375006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02376006
         SPACE 1                                                        02377006
         USING XTAHALT,R7                                               02378009
CLC@HOST CLC   0(0,R5),HT#LALE                                          02380005
         DROP  R7                                                       02381009
         EJECT                                                          02390000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02400000
*                                                                     * 02410000
*        MESSAGES USED IN THIS ROUTINE                                * 02420000
*                                                                     * 02430000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02440000
         SPACE 1                                                        02450000
XTA0601  DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      02460000
         DC    YL1(L'XTA0601T)     LENGTH OF MESSAGE                    02470000
XTA0601T DC    C'XTA0601 A CONNECTION CURRENTLY EXISTS.'                02480000
         SPACE                                                          02490000
XTA0602  DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      02500000
         DC    YL1(L'XTA0602T)     LENGTH OF MESSAGE                    02510000
XTA0602T DC    C'XTA0601 A CALL IS ALREADY IN PROGRESS.'                02520000
         SPACE                                                          02530000
BUSY     DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      02540000
         DC    YL1(L'XTA0603T)     LENGTH OF MESSAGE                    02550000
XTA0603T DC    C'XTA0602 ALL LINES TO REQUESTED HOST ARE BUSY, PLEASE T-02560000
               RY AGAIN LATER.'                                         02570000
         SPACE                                                          02580000
XTA0604  DC    YL1(SYSMSG+CLEARIPT-AALARM)  MESSAGE FLAGS               02590000
         DC    YL1(L'XTA0604T)     LENGTH OF MESSAGE                    02600000
XTA0604T DC    C'XTA0604 CALL PROCEEDING.'                              02610000
         SPACE                                                          02620000
NOOPND   DC    YL1(SYSMSG)           MESSAGE FLAGS                      02630000
         DC    YL1(L'XTA0605T)     LENGTH OF MESSAGE                    02640000
XTA0605T DC    C'XTA0602 CALL WHO?'                                     02650000
         SPACE                                                          02660000
TOOLONG  DC    YL1(SYSMSG)           MESSAGE FLAGS                      02670000
         DC    YL1(L'XTA0606T)     LENGTH OF MESSAGE                    02680000
XTA0606T DC    C'XTA0604 HOST NAME TOO LONG.'                           02690000
         SPACE                                                          02700000
BADALIAS DC    YL1(SYSMSG)           MESSAGE FLAGS                      02710000
         DC    YL1(L'XTA0608T)     LENGTH OF MESSAGE                    02720000
XTA0608T DC    C'XTA0604 DON''T KNOW A HOST BY THIS NAME.'              02730000
         EJECT                                                          02740000
         ISTDNIB                                                        02750000
         SPACE 3                                                        02760000
         END                                                            02770000