XTADFAX  TITLE 'TARA DFASY EXIT (27.0)'                                 00020000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00090001
*                                                                     * 00100001
*     MODULE NAME - XTADFAX                                           * 00110001
*                                                                     * 00120001
*     FUNCTIONAL DESCRIPTION - XTADFAX WILL PROCESS SNA 'SIGNAL'      * 00130001
*       PIUS BY CALLING XTARCVY.  THE PURPOSE OF THIS IS TO ALLOW     * 00140001
*       THE USER TO SIGNAL TARA (BY PRESSING THE 'ATTN' KEY) THAT     * 00150001
*       SOMETHING IS AWRY, AND TO CLEAN UP ITS ACT.                   * 00151001
*                                                                     * 00152001
*     DRIVER - XTADFAX IS DRIVEN BY THE RECEIPT OF AN EXPEDITED-FLOW  * 00160001
*       PIU FROM ANY PRIMARY (3270) SESISON.                          * 00170001
*                                                                     * 00180001
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTADFAX.              * 00190001
*                                                                     * 00200001
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00210001
*       OF THE EPILOGUE MACRO.                                        * 00220001
*                                                                     * 00230001
*     REGISTERS ON ENTRY -                                            * 00240001
*       BEFORE PROLOGUE:                                              * 00250001
*         R0:  UNPREDICTABLE                                          * 00260006
*         R1:  POINTER TO DFASY PARAMETER LIST (SEE BELOW)            * 00270006
*         R2-13: UNPREDICTABLE                                        * 00280006
*         R14: RETURN ADDRESS                                         * 00300001
*         R15: ENTRY ADDRESS                                          * 00310001
*       AFTER PROLOGUE:                                               * 00320001
*         R0:  UNPREDICTABLE                                          * 00330001
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00340001
*         R2-8: UNPREDICTABLE                                         * 00350006
*         R9:  POINTER TO DFASY PARAMETER LIST (SEE BELOW)            * 00380006
*         R10: POINTER TO COMMON STORAGE AREA                         * 00390001
*         R11: UNPREDICTABLE                                          * 00400006
*         R12: ENTRY ADDRESS                                          * 00410001
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00420001
*         R14: RETURN ADDRESS                                         * 00430001
*         R15: ENTRY ADDRESS                                          * 00440001
*                                                                     * 00450001
*     MACROS USED -                                                   * 00460001
*       IBM MACROS:                                                   * 00470001
*         FREEMAIN, GETMAIN, CHECK, TESTCB                            * 00480006
*       NON-IBM MACROS:                                               * 00490001
*         EPILOGUE, PHASE, PROLOGUE                                   * 00500001
*                                                                     * 00510001
*     COPY MEMBERS -                                                  * 00520001
*       XTACMAP, XTASMAP                                              * 00530001
*                                                                     * 00540001
*     INPUT -                                                         * 00550001
*       ON ENTRY, R1 POINTS TO A PARAMETER LIST CONTAINING:           * 00560006
*         +0  POINTER TO ACB                                          * 00561006
*         +4  SESSION CID                                             * 00562006
*         +8  USERFLD OF NIB USED FOR OPNDST                          * 00563006
*         +C  RESERVED                                                * 00564006
*         +10 POINTER TO READ-ONLY RPL                                * 00565006
*                                                                     * 00570001
*     OUTPUT -                                                        * 00580001
*       NONE                                                          * 00590006
*                                                                     * 00600001
*     ABENDS -                                                        * 00610001
*       NO ABENDS ARE ISSUED BY THIS MODULE.                          * 00620001
*                                                                     * 00630001
*     MESSAGES ISSUED -                                               * 00640001
*       THE 3270 SCREEN IS REDISPLAYED, BUT NO MESSAGE IS ISSUED.     * 00650006
*                                                                     * 00660001
*     RETURN CODES -                                                  * 00670001
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00680001
*                                                                     * 00690001
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00700001
XTADFAX  PROLOGUE EXIT=DFASY                                            00710006
         EJECT                                                          00720001
**                                                                      00830001
*                                                                       00840001
    PHASE  27.1 - FOR ¬(CONTROL=SIGNAL), EXIT.                          00850006
*                                                                       00860001
**                                                                      00870001
         SPACE 1                                                        00880001
         LR    R7,R9               GET PARM LIST POINTER INTO R7, SO    00880106
         L     R11,8(R7)             THAT WE CAN LOAD OUR SDB POINTER   00880206
         USING XTASMAP,R11           AND RPL POINTER INTO STANDARD      00880306
         L     R9,16(R7)             REGISTERS.                         00880406
         TESTCB AM=VTAM,RPL=(R9),CONTROL=SIGNAL                         00880502
         BNE   PH27#99                                                  00880602
         EJECT                                                          00881001
**                                                                      00882001
*                                                                       00883001
    PHASE  27.2 - CALL XTARCVY FOR THE SESSION.                         00884006
*                                                                       00885001
**                                                                      00886001
         SPACE 1                                                        00887001
         L     R15,CS#ARCVY        WHEN CONTROL=SIGNAL (I.E. ATTN WAS   00900006
         BALR  R14,R15               PRESSED), INITIATE RECOVERY.       00910006
         EJECT                                                          00930001
**                                                                      00940001
*                                                                       00950001
    PHASE  27.99 - EXIT                                                 00960001
*                                                                       00970001
**                                                                      00980001
         SR    R15,R15             ZERO RETURN CODE                     01000001
         EPILOGUE                  RETURN                               01010001
*********************************************************************** 01020001
*********************************************************************** 01030001
********                                                       ******** 01040001
********               END OF EXECUTABLE CODE                  ******** 01050001
********                                                       ******** 01060001
*********************************************************************** 01070001
*********************************************************************** 01080001
         END                                                            01190001