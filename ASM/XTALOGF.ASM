XTALOGF  TITLE 'TARA LOGOFF ROUTINE (7.0)'                              00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTALOGF                                           * 00040000
*                                                                     * 00050000
*     FUNCTION - INITIATES THE TERMINATION OF A CONVERSATION          * 00060006
*          BY ISSUING A CLSDST FOR THE PRIMARY SESSION.  THE          * 00070006
*          COMPLETION OF THE CLSDST AGAINST THE PRIMARY WILL          * 00080006
*          INITIATE CLEANUP FOR EVERYTHING ELSE.                      * 00081006
*                                                                     * 00083006
*     DRIVER - XTALOGF IS CALLED FROM XTAPRRX VIA BAL(R).             * 00084006
*                                                                     * 00085006
*     ENTRY - ONE ENTRY POINT IS PROVIDED, XTALOGF.                   * 00090006
*                                                                     * 00100000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00110006
*       OF THE EPILOGUE MACRO.                                        * 00120006
*                                                                     * 00121006
*     REGISTERS ON ENTRY -                                            * 00130006
*       BEFORE PROLOGUE:                                              * 00140006
*         R0:  UNPREDICTABLE                                          * 00150006
*         R1:  POINTER TO COMMAND DESCRIPTOR BLOCK                    * 00160006
*         R2-8: UNPREDICTABLE                                         * 00161006
*         R9:  ADDRESS OF PRIMARY RPL                                 * 00162006
*         R10: POINTER TO COMMON STORAGE AREA                         * 00163006
*         R11: POINTER TO SESSION STORAGE AREA                        * 00164006
*         R12: ADDRESS OF XTAPRRX'S ENTRY POINT                       * 00165006
*         R13: ADDRESS OF XTAPRRX'S SAVEAREA                          * 00166006
*         R14: RETURN ADDRESS                                         * 00167006
*         R15: ENTRY ADDRESS                                          * 00168006
*       AFTER PROLOGUE:                                               * 00169006
*         R0:  UNPREDICTABLE                                          * 00169106
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00169206
*         R2-6: UNPREDICTABLE                                         * 00169306
*         R7:  POINTER TO COMMAND DESCRIPTOR BLOCK                    * 00169406
*         R8:  UNPREDICTABLE                                          * 00169506
*         R9:  ADDRESS OF PRIMARY RPL                                 * 00169606
*         R10: POINTER TO COMMON STORAGE AREA                         * 00169706
*         R11: POINTER TO SESSION STORAGE AREA                        * 00169806
*         R12: ENTRY ADDRESS                                          * 00169906
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00170006
*         R14: RETURN ADDRESS                                         * 00170106
*         R15: RETURN CODE FROM GETMAIN                               * 00170206
*                                                                     * 00170306
*     MACROS USED -                                                   * 00170406
*       IBM MACROS:                                                   * 00170506
*         GETMAIN, FREEMAIN, CLSDST, ATTACH                           * 00170606
*       NON-IBM MACROS:                                               * 00170706
*         PROLOGUE, EPILOGUE, PHASE                                   * 00170806
*                                                                     * 00170906
*     COPY MEMBERS -                                                  * 00171006
*       XTACMAP, XTASMAP                                              * 00171106
*                                                                     * 00171206
*     INPUT -                                                         * 00171306
*       A COMMAND DESCRIPTOR BLOCK                                    * 00171406
*                                                                     * 00171506
*     OUTPUT -                                                        * 00171606
*       CLSDST                                                        * 00171706
*                                                                     * 00171806
*     ABENDS -                                                        * 00171906
*       NO USER ABENDS                                                * 00172006
*                                                                     * 00172106
*     MESSAGES ISSUED -                                               * 00172206
*       NONE                                                          * 00172306
*                                                                     * 00172406
*     RETURN CODES -                                                  * 00172506
*       THE RETURN CODE IS ALWAYS ZERO                                * 00172606
*                                                                     * 00173106
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00174000
XTALOGF  PROLOGUE SUBR=LOGOFF                                           00180000
         EJECT                                                          00190000
**                                                                      00200000
*                                                                       00210000
    PHASE  7.1 - LOG THE LOGOFF EVENT                                   00220000
*                                                                       00230000
**                                                                      00240000
         OI    SS#FLAG1,SS#LOGFF                                        00250004
         MVC   SS#LMSG(L'XTA0701T+2),XTA0701                            00260010
         MVC   SS#LMSG+2(L'SS#PNODE),SS#PNODE                           00270010
         SPACE                                                          00280000
         LA    R1,SS#LMSG          POINT TO RECORD                      00290000
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           00300000
         BALR  R14,R15             WRITE THE RECORD                     00310000
         EJECT                                                          00320000
**                                                                      00330000
*                                                                       00340000
    PHASE  7.2 - CLSDST PRIMARY HALF-SESSION                            00350000
*                                                                       00360000
**                                                                      00370000
         L     R8,CS#ACLDX         ADDRESS OF CLSDST EXIT               00380000
         L     R9,SS#ACRPL         GET THE CLSDST RPL ADDRESS           00390000
         L     R5,SS#PCID          GET CID                              00400000
         CLSDST RPL=(R9),          CLOSE THE PRIMARY SESSION           X00410000
               ARG=(R5),                                               X00420000
               EXIT=(R8),                                              X00430000
               OPTCD=(ASY,RELEASE)                                      00440000
         EJECT                                                          00600000
**                                                                      00610000
*                                                                       00620000
    PHASE  7.3 - TERMINATE THE CAPTURE TASK                             00630007
*                                                                       00640000
**                                                                      00650000
         TM    SS#FLAG4,SS#CAPDS   DO THIS ONLY IF THE CAPTURE TASK     00650108
         BZ    PH7#99                IS ACTIVE.                         00650208
         L     R3,SS#ACCBA         GET POINTER TO CAPTURE CB AREA, AND  00650308
         USING XTACCBA,R3            FROM THERE GET POINTER TO THE      00650408
         LA    R3,CC#EECB            END ECB.                           00650508
         DROP  R3                                                       00650608
         POST  (R3)                TELL CAPTURE TASK IT'S ALL OVER.     00650708
         EJECT                                                          00651005
**                                                                      00652005
*                                                                       00653005
    PHASE  7.99 - EXIT                                                  00654005
*                                                                       00655005
**                                                                      00656005
         SR    R15,R15             ZERO RETURN CODE                     00660000
         EPILOGUE                  RETURN                               00670000
*********************************************************************** 00680000
*********************************************************************** 00690000
********                                                       ******** 00700000
********               END OF EXECUTABLE CODE                  ******** 00710000
********                                                       ******** 00720000
*********************************************************************** 00730000
*********************************************************************** 00740000
         EJECT                                                          00750000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00760000
*                                                                     * 00770000
*        CONSTANTS USED IN THIS ROUTINE                               * 00780000
*                                                                     * 00790000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00800000
XTA0701  DC    YL1(USTATUS)        RECORD TYPE                          00810000
         DC    YL1(L'XTA0701T)     LENGTH OF TEXT                       00820000
XTA0701T DC    C'--PLU--- LOGOFF REQUESTED'                             00830010
         SPACE                                                          00840000
         END                                                            00850000