XTAEKOX  TITLE 'TARA ECHO SEND RPL EXIT (12.0)'                         00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTAEKOK                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTAEKOX CHECKS THE ECHO SEND RPL.      * 00060000
*                                                                     * 00070000
*     DRIVER - THIS EXIT IS DRIVEN WHEN THE SEND WHICH ECHOS INPUT    * 00080000
*       FROM THE PRIMARY SLU COMPLETES.                               * 00090000
*                                                                     * 00100000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAEKOX.              * 00110000
*                                                                     * 00120000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130000
*       OF THE EPILOGUE MACRO.                                        * 00140000
*                                                                     * 00150000
*     REGISTERS ON ENTRY -                                            * 00160000
*       BEFORE PROLOGUE:                                              * 00170000
*         R0:                                                         * 00180000
*         R1:  ADDRESS OF THE ECHO RPL.                               * 00190000
*         R2-R13:  UNPREDICTABLE                                      * 00200000
*         R14: RETURN ADDRESS                                         * 00210000
*         R15: ENTRY ADDRESS                                          * 00220000
*       AFTER PROLOGUE:                                               * 00230000
*         R0:  UNPREDICTABLE                                          * 00240000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00250000
*         R2-R8: UNPREDICTABLE                                        * 00260000
*         R9:  ADDRESS OF THE ECHO RPL.                               * 00270000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00280000
*         R11: POINTER TO SESSION STORAGE AREA.                       * 00290000
*         R12: ENTRY ADDRESS                                          * 00300000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00310000
*         R14: RETURN ADDRESS                                         * 00320000
*         R15: ENTRY ADDRESS                                          * 00330000
*                                                                     * 00340000
*     MACROS USED -                                                   * 00350000
*       IBM MACROS:                                                   * 00360000
*         IFGRPL, FREEMAIN, GETMAIN, CHECK                            * 00370000
*       NON-IBM MACROS:                                               * 00380000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00390000
*                                                                     * 00400000
*     COPY MEMBERS:                                                   * 00410000
*       XTACMAP                                                       * 00420000
*                                                                     * 00430000
*     INPUT:                                                          * 00440000
*       THE ECHO RPL.                                                 * 00450000
*                                                                     * 00460000
*                                                                     * 00470000
*     OUTPUT:                                                         * 00480000
*       NONE.                                                         * 00490000
*                                                                     * 00500000
*     ABENDS:                                                         * 00510000
*       NONE.                                                         * 00520000
*                                                                     * 00530000
*     MESSAGES ISSUED:                                                * 00540000
*       NO SYSTEM MESSAGES ARE ISSUED BY THIS MODULE.                 * 00550000
*                                                                     * 00560000
*     RETURN CODES:                                                   * 00570000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00580000
*                                                                     * 00590000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00600000
         SPACE 1                                                        00610000
XTAEKOX  PROLOGUE EXIT=RPL                                              00620000
         EJECT                                                          00630000
**                                                                      00640000
*                                                                       00650000
    PHASE  12.1 - CHECK THE RPL                                         00660000
*                                                                       00670000
**                                                                      00680000
         CHECK RPL=(R9)                                                 00690000
         LTR   R15,R15             VERIFY SUCCESSFUL CHECK.             00700000
         BZ    PH12#3              IF IT WAS OK, CONTINUE.              00710000
         CLC   =X'081B',RPLSSNSI   RCVR IN TRANSMIT MODE.               00720000
         BE    PH12#99                                                  00730000
         CLC   =X'0C0B',RPLRTNCD   SESSION WAS TERMINATED.              00740000
         BE    PH12#99                                                  00750000
         CLC   =X'0C0C',RPLRTNCD   SESSIONC CLEAR SENT.                 00751003
         BE    PH12#99                                                  00752003
         CLC   =X'0813',RPLSSNSI   BRACKET BID REJECT.                  00760000
         BE    PH12#2                                                   00770000
         CLC   =X'2003',RPLSSNSI   BRACKET PROTOCOL ERROR.              00780000
         BE    PH12#2                                                   00790000
         L     R15,CS#ACLNP                                             00800000
         LA    R14,PH12#99                                              00810000
         BR    R15                                                      00820000
         EJECT                                                          00830000
**                                                                      00840000
*                                                                       00850000
    PHASE  12.2 - TRY SEND AGAIN WITH BBI INVERTED                      00860000
*                                                                       00870000
**                                                                      00880000
         XI    RPLRH3,RPLBB        FLIP BBI.                            00890000
         SEND  RPL=(R9),RESPOND=(NEX,FME,NRRN)                          00900000
         B     PH12#99                                                  00910000
         EJECT                                                          00920000
**                                                                      00930000
*                                                                       00940000
    PHASE  12.3 - DEQUEUE THE BUFFER                                    00950000
*                                                                       00960000
**                                                                      00970000
         NI    SS#FLAG2,X'FF'-SS#INBKT    WE ARE NOW BETB.              00980001
         L     R4,RPLAREA          GET POINTER TO DATA AREA.            00990000
         S     R4,=F'8'            BACK UP TO START OF SEND BUFFER.     01000000
         LA    R5,1      LOAD ODD ADDRESS, THEN BRANCH ON IT IF         01010000
         C     R4,4(R4)  BUFFER IS QUEUED TO ITSELF, CAUSING 0C6 ABEND. 01020000
         BER   R5                                                       01030000
         TM    0(R4),SS#PACNG      CHECK FOR PACING BIT...IF IT'S ON,   01040000
         BZ    NOPACE                WE WILL INDICATE THAT DATA MUST    01050000
         OI    SS#FLAG2,SS#HOLDD     BE HELD UNTIL FURTHER NOTICE.      01060001
         SPACE 1                                                        01070000
NOPACE   EQU   *                                                        01080000
         NI    0(R4),X'FF'-(SS#SBIU+SS#PACNG) BUFFER NO LONGER IN USE.  01090000
         ICM   R5,15,4(R4)         GET PNTR TO NEXT WAITER (OR 0).      01100000
         ST    R5,SS#SBFST         UPDATE SB QUEUE ANCHOR.              01110000
         BNZ   PH12#4              AND IF THIS SB WAS LAST ON QUEUE,    01120000
         ST    R5,SS#SBLST           UPDATE THAT POINTER, TOO.          01130000
         B     PH12#99             SKIP THE SEND, NOTHING TO SEND.      01140000
         EJECT                                                          01150000
**                                                                      01160000
*                                                                       01170000
    PHASE  12.4 - CALL PSM(NULL) TO DISPATCH NEXT WAITER                01180000
*                                                                       01190000
**                                                                      01200000
         SLR   R1,R1               INDICATE DISPATCHER REQUEST.         01210000
         L     R15,CS#APSMR        LOAD ADDRESS OF PSM.                 01220000
         BALR  R14,R15             CALL PSM TO DISPATCH NEXT WAITER.    01230000
         EJECT                                                          01240000
**                                                                      01250000
*                                                                       01260000
    PHASE  12.99 - EXIT                                                 01270000
*                                                                       01280000
**                                                                      01290000
         SLR   R15,R15             SET RETURN CODE TO ZERO.             01300000
         EPILOGUE                                                       01310000
*********************************************************************** 01320000
*********************************************************************** 01330000
********                                                       ******** 01340000
********               END OF EXECUTABLE CODE                  ******** 01350000
********                                                       ******** 01360000
*********************************************************************** 01370000
*********************************************************************** 01380000
         END   XTAEKOX                                                  01390000