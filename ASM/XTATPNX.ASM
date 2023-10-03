XTATPNX  TITLE 'TARA TPEND EXIT ROUTINE (16.0)'                         00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTATPNX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTATPNX POSTS THE TPEND ECB, WHICH     * 00060000
*       IS ONE OF THE ECBS WAITED ON BY THE MAINLINE CODE. WHEN       * 00070000
*       THE MAINLINE DETECTS THAT THIS ECB HAS BEEN POSTED, IT        * 00080000
*       INITIATES SHUTDOWN PROCESSING.                                * 00090000
*                                                                     * 00100000
*     DRIVER - XTATPNX IS DRIVEN BY VTAM'S TPEND PROCESSING.          * 00110000
*                                                                     * 00120000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTATPNX.              * 00130000
*                                                                     * 00140000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00150000
*       OF THE EPILOGUE MACRO.                                        * 00160000
*                                                                     * 00170000
*     REGISTERS ON ENTRY -                                            * 00180000
*       BEFORE PROLOGUE:                                              * 00190000
*         R0:  UNPREDICTABLE                                          * 00200000
*         R1:  ADDRESS OF TPEND PARAMETER LIST (DESCRIBED BELOW)      * 00210000
*         R2-R13:  UNPREDICTABLE                                      * 00220000
*         R14: RETURN ADDRESS                                         * 00230000
*         R15: ENTRY ADDRESS                                          * 00240000
*       AFTER PROLOGUE:                                               * 00250000
*         R0:  UNPREDICTABLE                                          * 00260000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00270000
*         R2-R8: UNPREDICTABLE                                        * 00280000
*         R9:  ADDRESS OF TPEND PARAMETER LIST                        * 00290000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00300000
*         R11: UNPREDICTABLE                                          * 00310000
*         R12: ENTRY ADDRESS                                          * 00320000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00330000
*         R14: RETURN ADDRESS                                         * 00340000
*         R15: ENTRY ADDRESS                                          * 00350000
*                                                                     * 00360000
*     MACROS USED -                                                   * 00370000
*       IBM MACROS:                                                   * 00380000
*         POST, FREEMAIN, GETMAIN, WTO                                * 00390000
*       NON-IBM MACROS:                                               * 00400000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00410000
*                                                                     * 00420000
*     COPY MEMBERS:                                                   * 00430000
*       XTACMAP                                                       * 00440000
*                                                                     * 00450000
*     INPUT:                                                          * 00460000
*       ON ENTRY, R1 POINTS TO THE FOLLOWING PARAMETER LIST:          * 00470000
*         +0  ADDRESS OF ACB                                          * 00480000
*         +4  REASON FOR TPEND, AS FOLLOWS:                           * 00490000
*             0 = HALT NET                                            * 00500000
*             4 = HALT NET,QUICK OR                                   * 00510000
*                 VARY NET,INACT,I|F,ID=TARA                          * 00520000
*             8 = HALT NET,CANCEL OR                                  * 00530000
*                 VTAM HAS ABENDED                                    * 00540000
*                                                                     * 00550000
*     OUTPUT:                                                         * 00560000
*       THE TPEND FLAG IN COMMON STORAGE (CS#TPEND) IS SET, AND THE   * 00570000
*       TPEND ECB (CS#ECBTP) IS POSTED.                               * 00580000
*                                                                     * 00590000
*     ABENDS:                                                         * 00600000
*       NONE                                                          * 00610000
*                                                                     * 00620000
*     MESSAGES ISSUED:                                                * 00630000
*       MESSAGE XTA1601 (WITH VARIABLE TEXT) IS ISSUED TO THE         * 00640000
*       CONSOLE, INDICATING THAT TPEND PROCESSING HAS BEGUN.          * 00650000
*                                                                     * 00660000
*     RETURN CODES:                                                   * 00670000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00680000
*                                                                     * 00690000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00700000
         SPACE 1                                                        00710000
XTATPNX  PROLOGUE EXIT=TPEND                                            00720000
         EJECT                                                          00730000
**                                                                      00740000
*                                                                       00750000
    PHASE  16.1 - SHOW ENTRY INTO TPEND                                 00760000
*                                                                       00770000
**                                                                      00780000
         LA    R4,XTA1601          POINT TO APPROPRIATE WTO TEXT        00790000
         WTO   MF=(E,(R4))         ISSUE THE MESSAGE                    00800000
         OI    CS#FLAG1,CS#TPNXI                                        00810001
         L     R4,4(R9)                                                 00820000
         POST  CS#ECBTP,(R4)                                            00830000
         EJECT                                                          00840000
**                                                                      00850000
*                                                                       00860000
    PHASE  16.99 - EXIT                                                 00870000
*                                                                       00880000
**                                                                      00890000
         SLR   R15,R15             SET RETURN CODE TO ZERO.             00900000
         EPILOGUE                  EXIT.                                00910000
*********************************************************************** 00920000
*********************************************************************** 00930000
********                                                       ******** 00940000
********               END OF EXECUTABLE CODE                  ******** 00950000
********                                                       ******** 00960000
*********************************************************************** 00970000
*********************************************************************** 00980000
         TITLE 'DATA AREA'                                              00990000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01000000
*                                                                     * 01010000
*  OPERATOR MESSAGE                                                   * 01020000
*                                                                     * 01030000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01040000
         SPACE 2                                                        01050000
XTA1601  WTO   'XTA1601 TARA SHUTDOWN INITIATED BY TPEND.',            X01060000
               ROUTCDE=(2,11),DESC=(6),MF=L                             01070000
         END   XTATPNX                                                  01080000