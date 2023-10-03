XTALRDX  TITLE 'TARA LERAD EXIT (17.0)'                                 00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTALRDX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTALRDX IS THE LERAD EXIT.             * 00060000
*                                                                     * 00070000
*     DRIVER - XTALRDX IS DISPATCHED BY VTAM WHEN A LOGIC ERROR       * 00080000
*       OCCURS                                                        * 00090000
*                                                                     * 00100000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTALRDX.              * 00110000
*                                                                     * 00120000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130000
*       OF THE EPILOGUE MACRO.                                        * 00140000
*                                                                     * 00150000
*     REGISTERS ON ENTRY -                                            * 00160000
*       BEFORE PROLOGUE:                                              * 00170000
*         R0: RECOVERY ACTION RETURN CODE                             * 00180000
*         R1: ADDRESS OF FAILED OPERATION'S RPL                       * 00190000
*         R2-R12: UNPREDICTABLE                                       * 00200000
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
*           X'14'  LOGIC ERROR                                        * 00380000
*           X'18'  LOGIC ERROR - RPL INVALID                          * 00390000
*           OTHER VALUES - RPL OVERWRITTEN                            * 00400000
*                                                                     * 00410000
*     MACROS USED -                                                   * 00420000
*       IBM MACROS:                                                   * 00430000
*         TESTCB, FREEMAIN, GETMAIN, SHOWCB, WTO,                     * 00440001
*       NON-IBM MACROS:                                               * 00450000
*         EPILOGUE, PHASE, PROLOGUE, CVH                              * 00460000
*                                                                     * 00470000
*     COPY MEMBERS:                                                   * 00480000
*       XTACMAP                                                       * 00490000
*                                                                     * 00500000
*     INPUT:                                                          * 00510000
*       R1 POINTS TO THE RPL OF THE OPERATION WHOSE FAILURE DROVE     * 00520000
*       THE LERAD EXIT.                                               * 00530000
*                                                                     * 00540000
*     OUTPUT:                                                         * 00550000
*       UNLESS THE ERROR OCCURRED DURING CLSDST PROCESSING, TARA      * 00560000
*       ABENDS. IF THE ERROR WAS DURING CLSDST PROCESSING, CONTROL    * 00570000
*       IS RETURNED TO VTAM WITH RC=0, MEANING IGNORE THE ERROR.      * 00580000
*                                                                     * 00590000
*     ABENDS:                                                         * 00600000
*       NO USER ABENDS ISSUED.                                        * 00610000
*                                                                     * 00620000
*     MESSAGES ISSUED:                                                * 00630000
*       NORMALLY, THIS MESSAGE IS SENT TO THE CONSOLE:                * 00640000
*         XTA1706 LERAD ENTERED WITH RTNCD/FDBK2=XXXX                 * 00650000
*       HOWEVER, IF THE RPL WAS BAD, THIS MESSAGE IS ISSUED:          * 00660000
*         XTA1706 LERAD ENTERED WITH R0=XXXXXXXX                      * 00670000
*                                                                     * 00680000
*     RETURN CODES:                                                   * 00690000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00700000
*                                                                     * 00710000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00720000
         SPACE 1                                                        00730000
XTALRDX  PROLOGUE EXIT=LERAD                                            00740000
         EJECT                                                          00820000
**                                                                      00830000
*                                                                       00840000
    PHASE 17.1 - IF RPL WAS BAD --> 17.4                                00850002
*                                                                       00860000
**                                                                      00870000
         SPACE 1                                                        00870105
         SLR   R15,R15             ZERO RC REG IN ANTICIPATION OF       00870205
         LTR   R9,R9                 RECURSION CHECK, WHICH WE DON'T    00871005
         BM    PH17#99               ATTEMPT TO HANDLE.                 00872005
         C     R8,=F'20'           ALL CODES EXCEPT 20 (X'14') INDICATE 00880005
         BE    PH17#2                A CORRUPTED RPL.  UNDER SUCH       00890005
         CVH   R8,REG0,MF=LONG       CONDITIONS, THE ONLY AVAILABLE     00900005
         WTO   MF=(E,WTOREG0)        DATA IS IN R0 - SHOW IT VIA WTO,   00910005
         B     PH17#5                AND DELETE THE SESSION.            00920005
         EJECT                                                          00930000
**                                                                      00940000
*                                                                       00950000
    PHASE 17.2 - IF ERROR WAS IN CLSDST, IGNORE IT                      00960002
*                                                                       00970000
**                                                                      00980000
         SPACE 1                                                        00981005
         CLI   RPLREQ,X'1F'        ERRORS OCCURRING DURING CLSDST ARE   00990005
         BNE   PH17#3                IGNORED; TREAT AS NO ERROR (RC=0)  01000005
         SLR   R15,R15               AND RETURN TO ISSUER, PRETENDING   01010005
         B     PH17#99               ALL IS WELL...                     01020005
         EJECT                                                          01030000
**                                                                      01040000
*                                                                       01050000
    PHASE 17.3 - CHECK FOR ALLOWABLE FDBK2 CODES                        01060002
*                                                                       01070000
**                                                                      01080000
         SPACE 1                                                        01081005
         LA    R15,X'14'           14/53 LU NOT FOUND, CAN OCCUR IF     01090000
         CLI   RPLFDB2,X'53'         LU IS IN INACTIVE MAJOR NODE;      01100005
         BE    PH17#99               XTAACQR CAN HANDLE THIS.           01110005
         EJECT                                                          01120000
**                                                                      01130000
*                                                                       01140000
    PHASE 17.4 - DISPLAY ERROR CAUSING LERAD TO BE DISPATCHED           01150002
*                                                                       01160000
**                                                                      01170000
         SPACE 1                                                        01171005
         ICM   R6,B'1100',RPLRTNCD GET THE RTND/FDBK2 FIELDS, CONVERT   01180000
         CVH   R6,RTNCD              THEM TO EBCDIC, AND INSERT THEM    01190000
         MVC   WTORC,RTNCD           INTO A WTO MESSAGE.                01200005
         WTO   MF=(E,WTORCFB)                                           01210000
         EJECT                                                          01220000
**                                                                      01230000
*                                                                       01240000
    PHASE 17.5 - DELETE ERRING SESSION                                  01250002
*                                                                       01260000
**                                                                      01270000
         SPACE 1                                                        01271005
         OI    SS#FLAG1,SS#LOGFF                                        01272006
         L     R15,CS#ACLNP          PREPARE FOR NORMAL TERMINATION,    01280005
         BALR  R14,R15                 CALL XTACLNP TO INITIATE SAME.   01290005
         SLR   R15,R15               IGNORE THE ERROR.                  01291005
         EJECT                                                          01300000
**                                                                      01310000
*                                                                       01320000
    PHASE 17.99 - EXIT                                                  01330000
*                                                                       01340000
**                                                                      01350000
         SPACE 1                                                        01351005
         EPILOGUE                    RETURN R15 TO ISSUER OF REQUEST.   01360005
*********************************************************************** 01370000
*********************************************************************** 01380000
********                                                       ******** 01390000
********               END OF EXECUTABLE CODE                  ******** 01400000
********                                                       ******** 01410000
*********************************************************************** 01420000
*********************************************************************** 01430000
         TITLE 'DATA AREA'                                              01440000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01450000
*                                                                     * 01460000
*  WORKAREA AND EXECUTE FORM WTO'S                                    * 01470000
*                                                                     * 01480000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01490000
         SPACE 2                                                        01500000
ERRINFO  DS    D                                                        01510000
RTNCD    DS    D                                                        01520000
         SPACE 2                                                        01530000
         PRINT GEN                                                      01540000
WTORCFB  WTO   'XTA1705 LERAD ENTERED WITH RTNCD/FDBK2=....',MF=L       01550002
WTORC    EQU   *-4,4                                                    01560000
         SPACE 2                                                        01570000
WTOREG0  WTO   'XTA1701 LERAD ENTERED WITH R0=........',MF=L            01580002
REG0     EQU   *-8,8                                                    01590000
         END                                                            01600000