XTAOPRX  TITLE 'TARA OPNDST - PRIMARY - RPL EXIT (3.0)'                 00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTAOPRX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTAOPRX SENDS THE INITIAL SCREEN TO    * 00060000
*       THE USERS TERMINAL, AND ISSUES THE INITIAL RECEIVE.           * 00070002
*                                                                     * 00080000
*     DRIVER - XTAOPRX THIS RPL EXIT IS DRIVEN BY THE COMPLETION      * 00090000
*       OF THE OPNDST ISSUED IN THE LOGON EXIT.                       * 00100000
*                                                                     * 00110000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAOPRX.              * 00120000
*                                                                     * 00130000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00140000
*       OF THE EPILOGUE MACRO.                                        * 00150000
*                                                                     * 00160000
*     REGISTERS ON ENTRY -                                            * 00170000
*       BEFORE PROLOGUE:                                              * 00180000
*         R0:  UNPREDICTABLE                                          * 00190000
*         R1:  ADDRESS OF RPL WHOSE COMPLETION DROVE THIS EXIT        * 00200000
*         R2-R13:  UNPREDICTABLE                                      * 00210000
*         R14: RETURN ADDRESS                                         * 00220000
*         R15: ENTRY ADDRESS                                          * 00230000
*       AFTER PROLOGUE:                                               * 00240000
*         R0:  UNPREDICTABLE                                          * 00250000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00260000
*         R2-R8: UNPREDICTABLE                                        * 00270000
*         R9:  ADDRESS OF RPL WHOSE COMPLETION DROVE THIS EXIT        * 00280000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00290000
*         R11: UNPREDICTABLE                                          * 00300000
*         R12: ENTRY ADDRESS                                          * 00310000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00320000
*         R14: RETURN ADDRESS                                         * 00330000
*         R15: RETURN CODE FROM GETMAIN                               * 00340002
*                                                                     * 00350000
*     MACROS USED -                                                   * 00360000
*       IBM MACROS:                                                   * 00370000
*         CHECK, FREEMAIN, GETMAIN, IFGRPL, RECEIVE, WTO              * 00380000
*       NON-IBM MACROS:                                               * 00390000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00400000
*                                                                     * 00410000
*     COPY MEMBERS:                                                   * 00420000
*       XTACMAP, XTASMAP                                              * 00430000
*                                                                     * 00440000
*     INPUT:                                                          * 00450000
*       THE PRIMARY RPL.                                              * 00460000
*                                                                     * 00470000
*     OUTPUT:                                                         * 00480000
*       THE INITIAL SCREEN.                                           * 00490002
*                                                                     * 00500000
*     ABENDS:                                                         * 00510000
*       NO USER ABENDS.                                               * 00520002
*                                                                     * 00530000
*     MESSAGES ISSUED:                                                * 00540000
*       'XTA0302 LOGON COMPLETE'                                      * 00550002
*       'XTA0303 INITIAL RECEIVE TO PRIMARY FAILED.'                  * 00551002
*                                                                     * 00560000
*     RETURN CODES:                                                   * 00570000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00580000
*                                                                     * 00590000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00600000
XTAOPRX  PROLOGUE EXIT=RPL                                              00610000
         EJECT                                                          00630000
**                                                                      00640000
*                                                                       00650000
    PHASE  3.1 - CHECK THE RPL                                          00660000
*                                                                       00670000
**                                                                      00680000
         SPACE 1                                                        00681002
         L     R11,32(R9)          POINT TO THE NIB AND GET POINTER TO  00690000
         L     R11,8(R11)            SESSION STORAGE (USRFLD) FROM IT.  00700000
         CHECK RPL=(R9)                                                 00710000
         LTR   R15,R15             VERIFY SUCCESSFUL CHECK.             00720000
         BNZ   NOGO                IF CHECK WAS OK, CONTINUE.           00730000
         SPACE 1                                                        00731002
         TESTCB AM=VTAM,NIB=(R6),CON=YES                                00740000
         BE    PH3#2               VERIFY WE ACTUALLY CONNECTED.        00750000
         SPACE 1                                                        00760000
NOGO     EQU   *                                                        00770000
         L     R15,CS#ACLNP        IF OPNDST DIDN'T RESULT IN A         00780000
         BALR  R14,R15               SUCCESSFUL CONNECTION, GET RID     00790000
         B     PH3#99                OF SESSION STORAGE.                00800000
         EJECT                                                          00810000
**                                                                      00820000
*                                                                       00830000
    PHASE  3.2 - CALL PSM TO WRITE INITIAL SCREEN                       00840000
*                                                                       00850000
**                                                                      00860000
         SPACE 1                                                        00861002
         LA    R1,XTA0302          POINT TO THE INITIAL MESSAGE,        00870000
         L     R15,CS#APSMR          AND GIVE TO PSM TO HANDLE.         00880000
         BALR  R14,R15                                                  00890000
         EJECT                                                          00900000
**                                                                      00910000
*                                                                       00920000
    PHASE  3.3 - ISSUE INITIAL RECEIVE TO PRIMARY                       00930000
*                                                                       00940000
**                                                                      00950000
         SPACE 1                                                        00951002
         L     R3,SS#PCID          SET UP TO ISSUE THE FIRST RECEIVE    00960000
         LA    R4,SS#PIBUF           TO THE PRIMARY, THEN DO IT.        00970000
         LA    R5,L'SS#PIBUF                                            00980000
         L     R8,CS#APRRX                                              00990000
         RECEIVE RPL=(R9),                                             X01000000
               ARG=(R3),                                               X01010000
               AREA=(R4),                                              X01020000
               AREALEN=(R5),                                           X01030000
               OPTCD=(SPEC,ASY,CS),                                    X01040000
               EXIT=(R8)                                                01050000
         LTR   R15,R15             VERIFY RECEIVE WAS ACCEPTED.         01060000
         BZ    PH3#4               IF IT WAS, CONTINUE.                 01070000
         WTO   'XTA0303 INITIAL RECEIVE TO PRIMARY FAILED.',           X01080000
               ROUTCDE=(2,11),DESC=(6)                                  01090000
         L     R15,CS#ACLNP                                             01100004
         BALR  R14,R15                                                  01110000
         B     PH3#99                                                   01120000
         EJECT                                                          01130000
**                                                                      01140000
*                                                                       01150000
    PHASE  3.4 - INCREMENT SESSION COUNT                                01160000
*                                                                       01170000
**                                                                      01180000
         SPACE 1                                                        01181002
         L     R1,CS#SSNCT         UP THE SESSION COUNT BY ONE (THIS IS 01190000
         LA    R1,1(R1)              A COUNT OF PRIMARY SESSIONS ONLY). 01200002
         ST    R1,CS#SSNCT                                              01210000
         OI    SS#FLAG1,SS#PACT    SHOW THAT THE PRIMARY IS ACTIVE.     01220001
         EJECT                                                          01230000
**                                                                      01240000
*                                                                       01250000
    PHASE  3.99 - EXIT                                                  01260000
*                                                                       01270000
**                                                                      01280000
         SPACE 1                                                        01281002
         SLR   R15,R15             SET RETURN CODE TO ZERO.             01290000
         EPILOGUE                  EXIT.                                01300000
*********************************************************************** 01310000
*********************************************************************** 01320000
********                                                       ******** 01330000
********               END OF EXECUTABLE CODE                  ******** 01340000
********                                                       ******** 01350000
*********************************************************************** 01360000
*********************************************************************** 01370000
         TITLE 'DATA AREA'                                              01380000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01390000
*                                                                     * 01400000
*  MESSAGE TO BE SENT TO TERMINAL                                     * 01410002
*                                                                     * 01420000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01430000
         SPACE 2                                                        01440000
XTA0302  EQU   *                                                        01450000
         DC    YL1(INITSCRN)                                            01460000
         DC    YL1(L'XTA0302T)                                          01470000
XTA0302T DC    C'XTA0302 LOGON COMPLETE.'                               01480000
         END   XTAOPRX                                                  01490000