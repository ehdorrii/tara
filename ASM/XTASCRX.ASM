XTASCRX  TITLE 'TARA SESSIONC RPL EXIT (26.0)'                          00010003
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTASCRX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTASCRX CONTINUES THE RECOVERY         * 00060000
*       ACTIVITY INITIATED BY XTARCVY.                                * 00070000
*                                                                     * 00091000
*     DRIVER - XTASCRX IS DRIVEN BY THE COMPLETION OF THE SESSIONC    * 00100000
*       CONTROL=CLEAR ISSUED BY XTARCVY.                              * 00110000
*                                                                     * 00112000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTASCRX.              * 00120000
*                                                                     * 00130000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00140000
*       OF THE EPILOGUE MACRO.                                        * 00150000
*                                                                     * 00160000
*     REGISTERS ON ENTRY -                                            * 00170000
*       BEFORE PROLOGUE:                                              * 00180000
*         R0:  UNPREDICTABLE                                          * 00190000
*         R1:  ADDRESS OF THE RPL USED FOR THE SESSIONC REQUEST       * 00200000
*         R2-13: UNPREDICTABLE                                        * 00210000
*         R14: RETURN ADDRESS                                         * 00270000
*         R15: ENTRY ADDRESS                                          * 00280000
*       AFTER PROLOGUE:                                               * 00290000
*         R0:  UNPREDICTABLE                                          * 00300000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00310000
*         R2-8: UNPREDICTABLE                                         * 00320000
*         R9:  ADDRESS OF THE RPL USED FOR THE SESSIONC REQUEST       * 00350000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00360000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00370000
*         R12: ENTRY ADDRESS                                          * 00380000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00390000
*         R14: RETURN ADDRESS                                         * 00400000
*         R15: ENTRY ADDRESS                                          * 00410000
*                                                                     * 00420000
*     MACROS USED -                                                   * 00430000
*       IBM MACROS:                                                   * 00440000
*         FREEMAIN, GETMAIN, CHECK, RECEIVE, SESSIONC                 * 00450000
*       NON-IBM MACROS:                                               * 00460000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00470000
*                                                                     * 00480000
*     COPY MEMBERS -                                                  * 00490000
*       XTACMAP, XTASMAP                                              * 00500000
*                                                                     * 00510000
*     INPUT -                                                         * 00520000
*       THE RPL USED FOR THE SESSIONC REQUEST.                        * 00540000
*                                                                     * 00541000
*     OUTPUT -                                                        * 00550000
*       NONE.                                                         * 00570000
*                                                                     * 00571000
*     ABENDS -                                                        * 00580000
*       NO ABENDS ARE ISSUED BY THIS MODULE.                          * 00590000
*                                                                     * 00600000
*     MESSAGES ISSUED -                                               * 00610000
*       NONE.                                                         * 00710000
*                                                                     * 00711000
*     RETURN CODES -                                                  * 00720000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00730000
*                                                                     * 00740000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00750000
XTASCRX  PROLOGUE EXIT=RPL                                              00760000
         EJECT                                                          00770000
**                                                                      00780000
*                                                                       00790000
    PHASE  26.1 - CHECK THE RPL.                                        00800000
*                                                                       00810000
**                                                                      00820000
         SPACE 1                                                        00821000
         CHECK RPL=(R9)            CHECK THE STATUS OF THE REQUEST,     00822002
         LTR   R15,R15               GIVE UP IF IT DIDN'T WORK.         00823002
         BNZ   PH26#99                                                  00823100
         CLI   RPLCNTSC,RPLCLEAR   IF THE SDT COMPLETED, THEN DO THE    00823202
         BNE   PH26#3                RECEIVE.                           00823302
         EJECT                                                          00900000
**                                                                      00910000
*                                                                       00920000
    PHASE  26.2 - SEND SDT TO GET GET DATA FLOW GOING AGAIN             00930000
*                                                                       00940000
**                                                                      00950000
         SPACE 1                                                        00960000
         L     R2,SS#PCID          CLEAR REQUEST COMPLETED: RESTART     00961002
         SESSIONC RPL=(R9),          DATA TRAFFIC.                     +00962002
               ARG=(R2),                                               +00963000
               CONTROL=SDT,                                            +00964000
               STYPE=REQ,                                              +00965000
               OPTCD=ASY                                                00966000
         B     PH26#99                                                  00967001
         EJECT                                                          00970000
**                                                                      00971000
*                                                                       00972000
    PHASE  26.3 - REFORMAT THE SCREEN.                                  00973000
*                                                                       00974000
**                                                                      00975000
         SPACE 1                                                        00976000
         LA    R1,INITSC           RE-FORMAT THE SCREEN.                00980002
         L     R15,CS#APSMR                                             00981000
         BALR  R14,R15                                                  00990000
         EJECT                                                          01000000
**                                                                      01010000
*                                                                       01020000
    PHASE  26.4 - REISSUE A RECEIVE TO THE PRIMARY.                     01030000
*                                                                       01040000
**                                                                      01050000
         SPACE 1                                                        01060000
         L     R2,SS#APRPL         SINCE ALL OUTSTANDING RPL REQUESTS   01061002
         L     R3,SS#PCID            TO THE PRIMARY HAVE BEEN           01070002
         LA    R4,SS#PIBUF           TERMINATED, AND THE PSM REQUEST    01080002
         LA    R5,L'SS#PIBUF         ISSUED IN 26.3 WILL EVENTUALLY     01090002
         L     R6,CS#APRRX           DRIVE XTAEKOX, WE MUST ISSUE A     01100002
         RECEIVE RPL=(R2),           RECEIVE TO THE PRIMARY.           +01110002
               ARG=(R3),                                               +01120000
               AREA=(R4),                                              +01130000
               AREALEN=(R5),                                           +01140000
               OPTCD=(SPEC,ASY,CS),                                    +01150000
               EXIT=(R6)                                                01160000
         EJECT                                                          01680000
**                                                                      01810000
*                                                                       01820000
    PHASE  26.99 - EXIT                                                 01830000
*                                                                       01840000
**                                                                      01850000
         SR    R15,R15             ZERO RETURN CODE                     01860000
         EPILOGUE                  RETURN                               01870000
*********************************************************************** 01880000
*********************************************************************** 01890000
********                                                       ******** 01900000
********               END OF EXECUTABLE CODE                  ******** 01910000
********                                                       ******** 01920000
*********************************************************************** 01930000
*********************************************************************** 01940000
         EJECT                                                          02270000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02280000
*                                                                     * 02290000
*        DATA OBJECTS                                                 * 02300000
*                                                                     * 02310000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02320000
         SPACE 1                                                        02330000
INITSC   DC    YL1(INITSCRN)                                            02331000
         DC    YL1(L'XTA2602T)                                          02332000
XTA2602T DC    C'XTA2602  SCREEN CLEARED DUE TO ERROR RECOVERY.'        02333000
         END                                                            02860000
         AIF   ('&SYSPARM' NE 'COMMON').NODECLR                         00010000
         GBLB  &MAP                                                     00020000
.NODECLR AIF   (&MAP EQ 1).DSECT                                        00030000