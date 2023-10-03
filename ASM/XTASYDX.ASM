XTASYDX  TITLE 'TARA SYNAD EXIT (18.0)'                                 00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTASYDX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTASYDX IS THE SYNAD EXIT.             * 00060000
*                                                                     * 00070000
*     DRIVER - XTASYDX IS DISPATCHED BY VTAM WHEN AN EXCEPTION        * 00080000
*       CONDITION OCCURS.                                             * 00090000
*                                                                     * 00100000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTASYDX.              * 00110000
*                                                                     * 00120000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130000
*       OF THE EPILOGUE MACRO.                                        * 00140000
*                                                                     * 00150000
*     REGISTERS ON ENTRY -                                            * 00160000
*       BEFORE PROLOGUE:                                              * 00170000
*         R0: RECOVERY ACTION RETURN CODE                             * 00180000
*         R1: ADDRESS OF FAILED OPERATION'S RPL                       * 00190000
*         R2-R12: CONTENTS AS THEY WERE WHEN REQUEST WAS ISSUED       * 00200000
*         R13: ADDRESS OF SAVEAREA USED BY FAILED MACRO               * 00210000
*         R14: RETURN ADDRESS                                         * 00220000
*         R15: ENTRY ADDRESS                                          * 00230000
*       AFTER PROLOGUE:                                               * 00240000
*         R0:  UNPREDICTABLE                                          * 00250000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00260000
*         R2-R7: UNPREDICTABLE                                        * 00270000
*         R8:  RECOVERY ACTION RETURN CODE                            * 00280000
*         R9:  ADDRESS OF FAILED OPERATION'S RPL                      * 00290000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00300000
*         R11: POINTER TO SESSION STORAGE                             * 00310000
*         R12: ENTRY ADDRESS                                          * 00320000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00330000
*         R14: RETURN ADDRESS                                         * 00340000
*         R15: ENTRY ADDRESS                                          * 00350000
*                                                                     * 00360000
*     RECOVERY ACTION RETURN CODE VALUES:                             * 00370000
*         X'04'  EXCEPTION CONDITION                                  * 00380000
*         X'08'  RETRIABLE COMPLETION                                 * 00390000
*         X'0C'  DATA INTEGRITY DAMAGE                                * 00400000
*         X'10'  ENVIRONMENT ERROR                                    * 00410000
*                                                                     * 00420000
*     MACROS USED -                                                   * 00430000
*       IBM MACROS:                                                   * 00440000
*         CLSDST, EXECRPL, FREEMAIN, GETMAIN, WTO,                    * 00450001
*       NON-IBM MACROS:                                               * 00460000
*         EPILOGUE, PHASE, PROLOGUE, CVH                              * 00470000
*                                                                     * 00480000
*     COPY MEMBERS:                                                   * 00490000
*       XTACMAP                                                       * 00500000
*                                                                     * 00510000
*     INPUT:                                                          * 00520000
*       R1 POINTS TO THE RPL OF THE OPERATION WHOSE FAILURE DROVE     * 00530000
*       THE LERAD EXIT.                                               * 00540000
*                                                                     * 00550000
*     OUTPUT:                                                         * 00560000
*                                                                     * 00570000
*     ABENDS:                                                         * 00580000
*       NONE.                                                         * 00590001
*                                                                     * 00600000
*     MESSAGES ISSUED:                                                * 00610000
*                                                                     * 00620000
*     RETURN CODES:                                                   * 00630000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00640000
*                                                                     * 00650000
*     RESTRICTIONS - CANNOT CALL PRIMARY SCREEN MANAGER (PSM)         * 00660000
*                                                                     * 00670000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00680000
XTASYDX  PROLOGUE EXIT=SYNAD                                            00690000
         EJECT                                                          00700000
**                                                                      00710000
*                                                                       00720000
    PHASE  18.1 - GATHER SOME DIAGNOSTIC DATA                           00730000
*                                                                       00740000
**                                                                      00750000
         SPACE 1                                                        00750107
         SLR   R15,R15           ZERO RC REGISTER IN ANTICIPATION OF    00750207
         LTR   R9,R9               CHECKING FOR RECURSION, WHICH WE     00750307
         BM    PH18#99             DON'T TRY TO HANDLE.                 00750407
         LPR   R8,R8             THEN WE VALIDATE THE RECOVERY ACTION   00751007
         LR    R15,R8              CODE, PUT IT INTO R15 TO PROVIDE A   00760007
         CH    R8,=H'20'           NON-ZERO RETURN CODE TO RPL EXITS    00770007
         BNL   PH18#8              IN DEFAULT OF OTHER ACTION.          00780007
         SPACE 1                                                        00780107
         CLI   RPLREQ,RPLOPNDS   THE OPNDST EXITS ARE CODED TO HANDLE   00781007
         BE    PH18#99             ERRORS, SO LET THEM.                 00782007
         SPACE                                                          00790000
         EJECT                                                          00800000
**                                                                      00810000
*                                                                       00820000
    PHASE  18.2 - DISPATCH APPROPRIATE HANDLER FOR TYPE OF ERROR        00830007
*                                                                       00840000
**                                                                      00850000
         SPACE 1                                                        00880000
         N     R8,NOLOBITS       ZERO OUT ANY SPURIOUS LOW BITS, AND    00890000
         B     *(R8)               BRANCH TO THE APPROPRIATE HANDLER.   00900000
         SPACE 1                                                        00910000
         B     PH18#3            EXCEPTION REQUEST/RESPONSE     X'04'   00920000
         B     PH18#4            RETRIABLE CONDITION            X'08'   00930000
         B     PH18#5            DATA INTEGRITY ERROR           X'0C'   00940000
         B     PH18#6            ENVIRONMENT ERROR              X'10'   00950000
         EJECT                                                          00960000
**                                                                      00970000
*                                                                       00980000
    PHASE  18.3 - EXCEPTION (X'04') - CHECK FDBK2 AND SENSE CODES       00990000
*                                                                       01000000
**                                                                      01010000
         SPACE 1                                                        01011007
         CLC   =X'0813',RPLSSEI  THE SEND ROUTINES ARE CODED TO RECOVER 01020007
         BE    PH18#99             FROM THESE ERRORS:                   01030007
         CLC   =X'081B',RPLSSEI                                         01040007
         BE    PH18#99           0813 = BRACKET BID REJECT              01050007
         CLC   =X'2003',RPLSSEI  081B = RECEIVER IN TRANSMIT MODE       01060007
         BE    PH18#99           2003 = BRACKET PROTOCOL ERROR          01070007
         SPACE 1                                                        01071007
         B     PH18#7            FOR OTHER ERRORS, TRY RECOVERY.        01080007
         EJECT                                                          01090000
**                                                                      01100000
*                                                                       01110000
    PHASE  18.4 - RETRIABLE (X'08') - RETRY THE OPERATION (EXECRPL)     01120000
*                                                                       01130000
**                                                                      01140000
         SPACE 1                                                        01150007
         O     R9,RECUR          INDICATE THAT WE ARE RETRYING THE      01170004
         EXECRPL RPL=(9)           REQUEST, THEN REISSUE IT.            01180004
         LTR   R15,R15           IF THE RETRY WAS NOT ACCEPTED, ATTEMPT 01190000
         BNZ   PH18#8              TO DELETE THE ERRING SESSION;        01200000
         B     PH18#99             IF GOOD, RETURN.                     01210007
         EJECT                                                          01220000
**                                                                      01230000
*                                                                       01240000
    PHASE  18.5 - DATA INTEGRITY (X'0C') - DATA OR SESSION LOST         01250000
*                                                                       01260000
**                                                                      01270000
         SPACE 1                                                        01271007
         CLI   RPLFDB2,X'0B'       0C0B = SESSION LOST                  01280009
         BE    SESSLOSS                                                 01290007
         CLI   RPLFDB2,X'0C'       0C0C = CLEAR REQUEST SENT            01291009
         BE    PH18#99                                                  01291107
         SLR   R15,R15             OTHER DATA INTEGRITY ERRORS ARE      01291207
         B     PH18#99               ALLOWED TO PASS.                   01292007
         SPACE 1                                                        01293005
SESSLOSS EQU   *                                                        01294005
         CLC   SS#PCID,RPLSAF      IF IT'S THE PRIMARY, DELETE THE      01300007
         BE    PH18#8                ENTIRE SESSION.                    01310007
         SPACE 1                                                        01310107
         SLR   R15,R15             ON LOSS OF SECONDARY, ALLOW REQ TO   01311007
         B     PH18#99               EXPIRE: LOSTERM WILL INFORM USER.  01320007
         EJECT                                                          01400000
**                                                                      01410000
*                                                                       01420000
    PHASE  18.6 - ENVIRONMENT (X'10') - LU/VTAM/NET DIFFICULTIES        01430000
*                                                                       01440000
**                                                                      01450000
         SPACE 1                                                        01451007
         CLI   RPLFDBK2,X'09'    FOR V NET,TERM OR SSCP LOGOFF,         01460007
         BNE   PH18#8              INITIATE NORMAL SESSION DELETION.    01470007
         SLR   R15,R15           FOR VTAM ERRORS, BYPASS ERROR RECOVERY 01471007
         B     PH18#99             AND LEAVE ASAP.                      01480007
         EJECT                                                          01490000
**                                                                      01500000
*                                                                       01510000
    PHASE  18.7 - TRY RECOVERY IF THE PROBLEM IS WITH THE PRIMARY       01520000
*                                                                       01530000
**                                                                      01540000
         SPACE 1                                                        01541007
         L     R15,CS#ARCVY      XTARCVY WILL ISSUE SESSIONC CLEAR      01550007
         BALR  R14,R15             WHICH SHOULD RESET EVERYTHING ON     01560007
         SLR   R15,R15             THE PRIMARY SESSION TO A KNOWN       01561007
         B     PH18#99             STATE.                               01570007
         EJECT                                                          01580000
**                                                                      01590000
*                                                                       01600000
    PHASE  18.8 - DELETE THE SESSION CAUSING THE ERROR                  01610000
*                                                                       01620000
**                                                                      01630000
         SPACE 1                                                        01631007
         OI    SS#FLAG1,SS#LOGFF                                        01632008
         L     R15,CS#ACLNP      PREPARE FOR NORMAL SESSION TERMINATION 01640007
         BALR  R14,R15             AND CALL XTACLNP TO INITIATE IT.     01650007
         SLR   R15,R15                                                  01651005
         EJECT                                                          01660000
**                                                                      01670000
*                                                                       01680000
    PHASE  18.99 - EXIT                                                 01690000
*                                                                       01700000
**                                                                      01710000
         SPACE 1                                                        01711007
         EPILOGUE                R15 IS GIVEN TO ISSUER OF CHECK MACRO. 01720007
*********************************************************************** 01730000
*********************************************************************** 01740000
********                                                       ******** 01750000
********               END OF EXECUTABLE CODE                  ******** 01760000
********                                                       ******** 01770000
*********************************************************************** 01780000
*********************************************************************** 01790000
         EJECT                                                          01800000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01810000
*                                                                     * 01820000
*        CONSTANTS USED IN THIS ROUTINE                               * 01830000
*                                                                     * 01840000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01850000
         DS    0F                                                       01860000
RECUR    DC    X'80000000'                                              01870000
NOLOBITS DC    X'FFFFFFFC'                                              01880000
         END                                                            01890000