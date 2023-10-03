XTALSTX  TITLE 'TARA LOSTERM EXIT (15.0)'                               00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTALSTX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTALSTX IS THE LOSTERM EXIT FOR TARA.  * 00060008
*                                                                     * 00071008
*     DRIVER - THIS EXIT IS DRIVEN BY VTAM WHEN A SESSION             * 00072008
*       TERMINATION OCCURS (OTHER THAN AS THE RESULT OF A CLSDST).    * 00073008
*       VTAM KNOWS ABOUT IT BECAUSE OF IT'S APPEARANCE IN THE         * 00074008
*       ACB EXIT LIST.                                                * 00075008
*                                                                     * 00076008
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTALSTX.              * 00090208
*                                                                     * 00090308
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00090408
*       OF THE EPILOGUE MACRO.                                        * 00090508
*                                                                     * 00090608
*     REGISTERS ON ENTRY -                                            * 00090708
*       BEFORE PROLOGUE:                                              * 00090808
*         R0:  UNPREDICTABLE                                          * 00090908
*         R1:  ADDRESS OF THE LOSTERM PARAMETER LIST (SEE BELOW).     * 00091008
*         R2-R13:  UNPREDICTABLE                                      * 00091108
*         R14: RETURN ADDRESS                                         * 00091208
*         R15: ENTRY ADDRESS                                          * 00091308
*       AFTER PROLOGUE:                                               * 00091408
*         R0:  UNPREDICTABLE                                          * 00091508
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00091608
*         R2-R8: UNPREDICTABLE                                        * 00091708
*         R9:  ADDRESS OF THE LOSTERM PARAMETER LIST (SEE BELOW).     * 00091808
*         R10: POINTER TO COMMON STORAGE AREA                         * 00091908
*         R11: UNPREDICTABLE.                                         * 00092008
*         R12: ENTRY ADDRESS                                          * 00092108
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00092208
*         R14: RETURN ADDRESS                                         * 00092308
*         R15: RETURN CODE FROM GETMAIN.                              * 00092408
*                                                                     * 00092508
*     MACROS USED -                                                   * 00092608
*       IBM MACROS:                                                   * 00092708
*         CLSDST, WTO, GETMAIN, FREEMAIN.                             * 00092808
*       NON-IBM MACROS:                                               * 00092908
*         EPILOGUE, PHASE, PROLOGUE                                   * 00093008
*                                                                     * 00093108
*     COPY MEMBERS -                                                  * 00093208
*       XTACMAP                                                       * 00093308
*                                                                     * 00094008
*     INPUT -                                                         * 00100000
*       THE LOSTERM PARAMETER LIST:                                   * 00110008
*           +0  ADDRESS OF ACB                                        * 00140000
*           +4  CID OF FAILING LOGICAL UNIT                           * 00150000
*           +8  USERFLD FROM NIB                                      * 00160000
*           +C  LOSTERM REASON CODE                                   * 00170000
*                                                                     * 00170108
*     OUTPUT:                                                         * 00171008
*       A LOG RECORD IS RECORDED WITH THE LUNAME AND REASON CODE.     * 00172008
*                                                                     * 00173008
*     ABENDS:                                                         * 00174008
*       NONE.                                                         * 00175008
*                                                                     * 00176008
*     MESSAGES ISSUED:                                                * 00177008
*       IF THE LOST SESSION WAS THE SECONDARY, THE FOLLOWING          * 00178008
*       MESSAGE IS SENT TO THE PRIMARY:                               * 00179008
*        XTA1504  CONNECTION LOST. RE-CONNECT MAY BE POSSIBLE.'       * 00179108
*                                                                     * 00179208
*     RETURN CODES:                                                   * 00179308
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00179408
*                                                                     * 00179508
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00305000
XTALSTX  PROLOGUE EXIT=LOSTERM                                          00310000
         EJECT                                                          00320000
**                                                                      00330000
*                                                                       00340000
    PHASE  15.1 - LOG THE EVENT                                         00350000
*                                                                       00360000
**                                                                      00370000
         LR    R3,R9               FIRST SAVE THE PARAMETERS            00380000
         L     R4,0(R3)            SAVE ACB ADDRESS                     00390000
         L     R5,4(R3)            SAVE CID OF THIS SESSION             00400000
         L     R11,8(R3)           SAVE POINTER TO SESSION STORAGE      00410000
         USING XTASMAP,R11         USE IT TO POINT TO SESSION STORAGE   00420000
         L     R6,12(R3)           SAVE REASON CODE                     00430000
         SPACE                                                          00440000
         MVC   SS#LMSG(L'XTA1501T+2),XTA1501              TEMPLATE      00450000
         STCM  R6,B'1111',SS#LMSG+10                      REASON CODE   00460007
         CL    R5,SS#PCID          IS THIS THE PRIMARY SESSION?         00470000
         BNE   PH15#1A             NO, MUST BE SECONDARY                00480000
         MVC   SS#LMSG+2(L'SS#PNODE),SS#PNODE                           00490004
         LA    R7,PH15#2           PREPARE TO GO HANDLE PRIMARY         00500000
         B     PH15#1B             CONTINUE...                          00510000
         SPACE                                                          00520000
PH15#1A  CL    R5,SS#SCID          IS THIS THE SECONDARY SESSION?       00530000
         BNE   PH15#5              NO, GO ABEND                         00540000
         MVC   SS#LMSG+2(L'SS#SNODE),SS#SNODE                           00550004
         LA    R7,PH15#3           PREPARE TO GO HANDLE SECONDARY       00560000
         SPACE                                                          00570000
PH15#1B  LA    R1,SS#LMSG          POINT TO RECORD                      00580000
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           00590000
         BALR  R14,R15             WRITE THE RECORD                     00600000
         SPACE                                                          00620000
PH15#1D  C     R6,=F'24'  (X'18')  DOES THIS INDICATE RECOVERY ONGOING  00630000
         BE    PH15#99             YES - EXIT                           00640000
         BR    R7                  NO  - CLSDST THE APPROPRIATE SESS(S) 00650000
*                                  BRANCHING TO PH15#2 OR PH15#3        00660000
         EJECT                                                          00670000
**                                                                      00680000
*                                                                       00690000
    PHASE  15.2 - IF PRIMARY LOST, CLSDST BOTH HALF-SESSIONS            00700000
*                                                                       00710000
**                                                                      00720000
         SPACE                                                          00760000
         L     R9,SS#ACRPL         GET CLSDST RPL ADDRESS               00770000
         L     R8,CS#ACLDX         ADDRESS OF CLSDST EXIT               00780000
         CLSDST RPL=(R9),          CLOSE THE PRIMARY                   X00790000
               ARG=(R5),                                               X00800000
               EXIT=(R8),                                              X00810000
               OPTCD=(ASY,RELEASE)                                      00820000
         SPACE                                                          00830000
         B     PH15#99             EXIT                                 00840000
         EJECT                                                          00850000
**                                                                      00860000
*                                                                       00870000
    PHASE  15.3 - IF SECONDARY LOST, CLSDST THE 2ND'RY HALF-SESSION     00880000
*                                                                       00890000
**                                                                      00900000
         L     R9,SS#ACRPL         GET THE CLSDST RPL ADDRESS           00910000
         L     R8,CS#ACLDX         ADDRESS OF CLSDST EXIT               00920000
         SPACE                                                          00930000
         L     R8,CS#ACLDX         ADDRESS OF CLSDST EXIT               00940000
         CLSDST RPL=(R9),                                              X00950000
               ARG=(R5),                                               X00960000
               EXIT=(R8),                                              X00970000
               OPTCD=(ASY,RELEASE)                                      00980000
         SPACE                                                          00990000
**                                                                      01000000
*                                                                       01010000
    PHASE  15.4 - INFORM PRIMARY SECONDARY IS GOING                     01020000
*                                                                       01030000
**                                                                      01040000
         LA    R1,XTA1504          POINT TO MESSAGE                     01050000
         L     R15,CS#APSMR        PSM ROUTINE ADDRESS                  01060000
         BALR  R14,R15             SEND THE MESSAGE TO PRIMARY          01070000
         B     PH15#99             EXIT                                 01080000
         EJECT                                                          01090000
**                                                                      01100000
*                                                                       01110000
    PHASE  15.5 - INVALID CID - SESSION IS UNKNOWN TO ME                01120000
*                                                                       01130000
**                                                                      01140000
         WTO   'XTA1505  LOSTERM EXIT INVOKED FOR UNKNOWN LU.',        X01150000
               ROUTCDE=(2,11),DESC=(6)                                  01160000
         EJECT                                                          01170000
**                                                                      01180000
*                                                                       01190000
    PHASE  15.99 - EXIT                                                 01200000
*                                                                       01210000
**                                                                      01220000
         SR    R15,R15             ZERO RETURN CODE                     01230000
         EPILOGUE                  RETURN                               01240000
*********************************************************************** 01250000
*********************************************************************** 01260000
********                                                       ******** 01270000
********               END OF EXECUTABLE CODE                  ******** 01280000
********                                                       ******** 01290000
*********************************************************************** 01300000
*********************************************************************** 01310000
         EJECT                                                          01320000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01330000
*                                                                     * 01340000
*        CONSTANTS USED IN THIS ROUTINE                               * 01350000
*                                                                     * 01360000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01370000
XTA1501  DC    YL1(FERROR)         FORMATTED ERROR RECORD               01380000
         DC    YL1(L'XTA1501T)     LENGTH OF TEXT                       01390000
XTA1501T DC    C'-LUNAME-.RC.'                                          01400005
         SPACE                                                          01410000
XTA1504  DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      01420000
         DC    YL1(L'XTA1504T)     LENGTH OF MESSAGE                    01430000
XTA1504T DC    C'XTA1504 CONNECTION LOST. RE-CONNECT MAY BE POSSIBLE.'  01440000
         SPACE                                                          01450000
         END                                                            01460000