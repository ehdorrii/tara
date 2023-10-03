XTARCVY  TITLE 'TARA SESSION RECOVERY ROUTINE (20.0)'                   00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTARCVY                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTARCVY ATTEMPTS TO RESET              * 00060000
*       COMMUNICATIONS STATUS ON THE PRIMARY SESSION BY SENDING       * 00070000
*       AN 'INITIAL SCREEN' TO THE PRIMARY; THIS CAUSES THE           * 00080000
*       PRIMARY SCREEN MANAGER TO PURGE ANY OUTSTANDING I/O TO        * 00090000
*       THE PRIMARY, AND SET THE DEVICE TO A KNOWN STATE.             * 00100000
*                                                                     * 00110000
*     DRIVER - CALLED VIA BALR.                                       * 00120000
*                                                                     * 00130000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTARCVY.              * 00140000
*                                                                     * 00150000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00160000
*       OF THE EPILOGUE MACRO.                                        * 00170000
*                                                                     * 00180000
*     REGISTERS ON ENTRY -                                            * 00190000
*       BEFORE PROLOGUE:                                              * 00200000
*         R0-R13:  UNPREDICTABLE                                      * 00210000
*         R14: RETURN ADDRESS                                         * 00220000
*         R15: ENTRY ADDRESS                                          * 00230000
*       AFTER PROLOGUE:                                               * 00240000
*         R0:  UNPREDICTABLE                                          * 00250000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00260000
*         R2-R9: UNPREDICTABLE                                        * 00270000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00280000
*         R11: POINTER TO SESSION STORAGE AREA.                       * 00290000
*         R12: ENTRY ADDRESS                                          * 00300000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00310000
*         R14: RETURN ADDRESS                                         * 00320000
*         R15: ENTRY ADDRESS                                          * 00330000
*                                                                     * 00340000
*     MACROS USED -                                                   * 00350000
*       IBM MACROS:                                                   * 00360000
*                                                                     * 00370000
*       NON-IBM MACROS:                                               * 00380000
*                                                                     * 00390000
*                                                                     * 00400000
*     COPY MEMBERS:                                                   * 00410000
*       XTACMAP                                                       * 00420000
*                                                                     * 00430000
*     INPUT:                                                          * 00440000
*       THE FAILING RPL.                                              * 00450000
*                                                                     * 00460000
*     OUTPUT:                                                         * 00470000
*       NONE.                                                         * 00480000
*                                                                     * 00490000
*     ABENDS:                                                         * 00500000
*       NO USER ABENDS ARE ISSUED.                                    * 00510002
*                                                                     * 00520000
*     MESSAGES ISSUED:                                                * 00530000
*       XTA2001  RECOVERY IN PROGRESS.                                * 00540002
*                                                                     * 00550000
*     RETURN CODES:                                                   * 00560000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00570000
*                                                                     * 00580000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00590000
         SPACE 1                                                        00600000
XTARCVY  PROLOGUE SUBR=RECOVERY                                         00610002
         EJECT                                                          00620000
**                                                                      00630000
*                                                                       00640000
    PHASE  20.1 - CLEAR PSM QUEUE                                       00650001
*                                                                       00660000
**                                                                      00670000
         SPACE 1                                                        00680007
         L     R2,SS#SBFST         WE FIRST CHECK FOR THE PRESENCE OF   00690007
         LTR   R2,R2                 REQUESTS ON THE PSM QUEUE - IF     00691007
         BZ    PH20#2                THERE ARE NONE, SKIP THIS STEP.    00700007
         ST    R2,SS#SBLST         OTHERWISE, DELETE ALL REQUESTS       00701007
         XC    4(4,R2),4(R2)         EXCEPT THE ONE CURRENTLY IN        00710007
         LA    R2,SS#SBPL            PROGRESS BY:                       00711007
         LA    R3,SS#SBCNT                                              00712007
         SPACE 1                                                        00720007
CLRSBPL  EQU   *                     1. SETTING LAST-ON-Q = FIRST-ON-Q  00730007
         C     R2,SS#SBFST           2. SETTING NEXT-ON-Q = 0           00740007
         BE    LEAVEIT               3. MARKING ALL BUFFERS EXCEPT THE  00750007
         NI    0(R2),X'FF'-SS#SBIU       CURRENT ONE NOT-IN-USE.        00760007
         SPACE 1                                                        00770007
LEAVEIT  EQU   *                                                        00780007
         LA    R2,256(R2)                                               00790007
         BCT   R3,CLRSBPL                                               00800007
         EJECT                                                          00890000
**                                                                      00900000
*                                                                       00910000
    PHASE  20.2 - ISSUE SESSIONC CLEAR                                  00920001
*                                                                       00930000
**                                                                      00940000
         SPACE 1                                                        00940101
         L     R9,SS#ACRPL         BEFORE CONTINUING, WE MUST ENSURE    00940205
         USING IFGRPL,R9             THAT THE CLSDST RPL IS NOT IN USE; 00940307
         CLI   RPLACTIV,0            IF IT IS, THEN WE JUST LEAVE, AND  00940407
         DROP  R9                    HOPE THE PROBLEM GOES AWAY.        00940507
         BNE   PH20#99                                                  00940607
         L     R2,SS#PCID          NOW WE RESET THE PRIMARY SESSION BY  00940707
         L     R3,CS#ASCRX           SENDING SESSIONC CLEAR.            00940807
         SESSIONC RPL=(R9),                                            X00940901
               ARG=(R2),                                               X00941001
               CONTROL=CLEAR,                                          X00941101
               STYPE=REQ,                                              X00941201
               OPTCD=ASY,                                              X00941301
               EXIT=(R3)                                                00941401
         EJECT                                                          01010000
**                                                                      01020000
*                                                                       01030000
    PHASE  20.99 - EXIT                                                 01040000
*                                                                       01050000
**                                                                      01060000
         SPACE 1                                                        01061007
         SLR   R15,R15             SET RETURN CODE TO ZERO.             01070000
         EPILOGUE                                                       01080000
*********************************************************************** 01090000
*********************************************************************** 01100000
********                                                       ******** 01110000
********               END OF EXECUTABLE CODE                  ******** 01120000
********                                                       ******** 01130000
*********************************************************************** 01140000
*********************************************************************** 01150000
         SPACE 1                                                        01151002
RCVYSCRN EQU   *                                                        01160000
         DC    YL1(INITSCRN)                                            01170000
         DC    YL1(L'TEXT)                                              01180000
TEXT     DC    C'XTA2001  ERROR RECOVERY IN PROGRESS...'                01190007
         END   XTARCVY                                                  01210000