XTAOSRX  TITLE 'TARA OPNDST - SECONDARY - RPL EXIT (4.0)'               00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTAOSRX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTAOSRX SENDS THE CONFIRMATION OF      * 00060000
*       SECONDARY ACQUISITION TO THE PRIMARY, AND ISSUES THE          * 00070000
*       INITIAL RECEIVE TO THE SECONDARY.                             * 00080000
*                                                                     * 00090000
*     DRIVER - XTAOSRX THIS RPL EXIT IS DRIVEN BY THE COMPLETION      * 00100000
*       OF THE OPNDST ISSUED BY THE ACQUIRE ROUTINE.                  * 00110000
*                                                                     * 00120000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAOSRX.              * 00130000
*                                                                     * 00140000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00150000
*       OF THE EPILOGUE MACRO.                                        * 00160000
*                                                                     * 00170000
*     REGISTERS ON ENTRY -                                            * 00180000
*       BEFORE PROLOGUE:                                              * 00190000
*         R0:  UNPREDICTABLE                                          * 00200003
*         R1:  ADDRESS OF THE RPL WHOSE COMPLETION DROVE THIS EXIT    * 00210000
*         R2-R13:  UNPREDICTABLE                                      * 00220000
*         R14: RETURN ADDRESS                                         * 00230000
*         R15: ENTRY ADDRESS                                          * 00240000
*       AFTER PROLOGUE:                                               * 00250000
*         R0:  UNPREDICTABLE                                          * 00260000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00270000
*         R2-R8: UNPREDICTABLE                                        * 00280000
*         R9:  ADDRESS OF THE RPL WHOSE COMPLETION DROVE THIS EXIT    * 00290000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00300000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00310000
*         R12: ENTRY ADDRESS                                          * 00320000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00330000
*         R14: RETURN ADDRESS                                         * 00340000
*         R15: RETURN CODE FROM GETMAIN                               * 00350003
*                                                                     * 00360000
*     MACROS USED -                                                   * 00370000
*       IBM MACROS:                                                   * 00380000
*         FREEMAIN, GETMAIN, CHECK, RECEIVE, TESTCB                   * 00390000
*       NON-IBM MACROS:                                               * 00400000
*         EPILOGUE, PHASE, PROLOGUE, CVH                              * 00410000
*                                                                     * 00420000
*     COPY MEMBERS:                                                   * 00430000
*       XTACMAP, XTASMAP                                              * 00440000
*                                                                     * 00450000
*     INPUT:                                                          * 00460000
*       THE SECONDARY RPL.                                            * 00470000
*                                                                     * 00480000
*     OUTPUT:                                                         * 00490000
*       A STATUS MESSAGE IS SENT TO THE TERMINAL.                     * 00500003
*                                                                     * 00510000
*     ABENDS:                                                         * 00520000
*       NO USER ABENDS.                                               * 00530003
*                                                                     * 00540000
*     MESSAGES ISSUED:                                                * 00550000
*       'XTA0402 REQUESTED CONNECTION ESTABLISHED' IS SENT TO THE     * 00560000
*       USERS TERMINAL ON SUCCESSFUL COMPLETION.                      * 00570000
*                                                                     * 00580000
*     RETURN CODES:                                                   * 00590000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00600000
*                                                                     * 00610000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00620000
XTAOSRX  PROLOGUE EXIT=RPL                                              00630000
         EJECT                                                          00640000
**                                                                      00650000
*                                                                       00660000
    PHASE  4.1 - CHECK THE RPL                                          00670000
*                                                                       00680000
**                                                                      00690000
         SPACE 1                                                        00691003
         NI    SS#FLAG1,X'FF'-SS#PCONN CONNECTION NO LONGER PENDING.    00700003
         CHECK RPL=(R9)                                                 00710000
         LTR   R15,R15             VERIFY SUCCESSFUL CHECK.             00720000
         BNZ   HOWFAIL             IF IT FAILED, FIND OUT WHY.          00730005
         L     R6,SS#ANIB          DID THE OPNDST REALLY OPNDST??       00740005
         TESTCB AM=VTAM,NIB=(R6),CON=YES                                00750000
         BE    PH4#2               IF SO, ALL IS WELL; CONTINUE.        00760000
         SPACE 1                                                        00810000
HOWFAIL  EQU   *                                                        00811005
         LA    R2,MSGTAB           POINT TO ASSOCIATION TABLE, AND      00820005
         LA    R3,#MSGS            GET NUMBER OF ENTRIES IN IT.         00830006
         SPACE 1                                                        00840005
FAILLOOP EQU   *                   LOOP UNTIL WE FIND A MESSAGE TO      00850005
         L     R1,4(R2)              MATCH THE RTNCD/FDBK2, THEN        00860005
         CLC   RPLRTNCD(2),0(R2)     ISSUE THAT MESSAGE.                00870005
         BE    FAILMSG                                                  00880004
         LA    R2,8(R2)                                                 00881005
         BCT   R3,FAILLOOP                                              00890004
         SPACE 1                                                        00900005
         MVC   SS#WORK1(L'XTA41ZT+2),XTA41Z                             00901005
         LA    R2,SS#WORK1         IF WE DON'T HAVE A MESSAGE IN THE    00902005
         USING XTA41Z,R2             TABLE CORRESPONDING TO THE         00903008
         ICM   R4,B'1100',RPLRTNCD   SPECIFIC RTNCD/FDBK2, THEN ISSUE   00904005
         CVH   R4,SS#WORK2           A GENERAL ERROR MESSAGE WHICH      00906005
         MVC   XTA41ZRF,SS#WORK2     REPORTS THE RTNCD/FDBK2 AND THE    00907005
         ICM   R4,B'1100',RPLSSNSI   SSENSEI.                           00908005
         CVH   R4,SS#WORK2                                              00909005
         MVC   XTA41ZSS,SS#WORK2                                        00909105
         DROP  R2                                                       00909205
         LR    R1,R2                                                    00910005
         SPACE 1                                                        00920004
FAILMSG  EQU   *                                                        00930004
         L     R15,CS#APSMR        DISPLAY THE ERROR MESSAGE FOR THE    00940005
         BALR  R14,R15               USER.                              00950005
         L     R2,SS#AHNAE         FREE THE LU WE WERE USING.           01120005
         NI    0(R2),X'FF'-HT#INUSE                                     01130002
         B     PH4#99              EXIT.                                01170005
         EJECT                                                          01180000
**                                                                      01190000
*                                                                       01200000
    PHASE  4.2 - UPDATE SESSION CONTROL BLOCKS                          01210000
*                                                                       01220000
**                                                                      01230000
         SPACE 1                                                        01231004
         MVC   SS#SCID,SS#CBS+4    GET THE CID FOR THE SESSION;         01250005
         OI    SS#FLAG1,SS#SACT      AND SHOW AN ACTIVE SECONDARY.      01260005
         EJECT                                                          01270000
**                                                                      01280000
*                                                                       01290000
    PHASE  4.3 - CALL PSM(SESSION ESTABLISHED)                          01300000
*                                                                       01310000
**                                                                      01320000
         SPACE 1                                                        01321004
         LA    R1,XTA0402                                               01330000
         L     R15,CS#APSMR                                             01340000
         BALR  R14,R15                                                  01350000
         EJECT                                                          01360000
**                                                                      01370000
*                                                                       01380000
    PHASE  4.4 - ISSUE RECEIVE SPEC,ASY,EXIT=                           01390000
*                                                                       01400000
**                                                                      01410000
         SPACE 1                                                        01411004
         L     R3,SS#SCID                                               01420000
         LA    R4,SS#SIBUF                                              01430000
         LA    R5,L'SS#SIBUF                                            01440000
         L     R8,CS#ASRRX                                              01450000
         RECEIVE RPL=(R9),                                             X01460000
               ARG=(R3),                                               X01470000
               AREA=(R4),                                              X01480000
               AREALEN=(R5),                                           X01490000
               OPTCD=(SPEC,ASY,CS),                                    X01500000
               EXIT=(R8)                                                01510000
         EJECT                                                          01520000
**                                                                      01530000
*                                                                       01540000
    PHASE  4.99 - EXIT                                                  01550000
*                                                                       01560000
**                                                                      01570000
         SPACE 1                                                        01571005
         SLR   R15,R15             SET RETURN CODE TO ZERO.             01580000
         EPILOGUE                  EXIT.                                01590000
*********************************************************************** 01600000
*********************************************************************** 01610000
********                                                       ******** 01620000
********               END OF EXECUTABLE CODE                  ******** 01630000
********                                                       ******** 01640000
*********************************************************************** 01650000
*********************************************************************** 01660000
         TITLE 'DATA AREA'                                              01670000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01680000
*                                                                     * 01690000
*  RTNCD/FDBK2 -> MESSAGE ASSOCIATION TABLE                           * 01700004
*                                                                     * 01710000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01720000
         SPACE 2                                                        01730000
         CNOP  0,4                                                      01730104
MSGTAB   EQU   *                                                        01730204
         DC    XL4'0000',A(XTA41A)                                      01730304
         DC    XL4'1000',A(XTA41B)                                      01730404
         DC    XL4'1453',A(XTA41C)                                      01730504
#MSGS    EQU   (*-MSGTAB)/8                                             01730606
         SPACE 2                                                        01730704
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01731004
*                                                                     * 01732004
*  MESSAGE TEXTS                                                      * 01733004
*                                                                     * 01734004
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01735004
         SPACE 2                                                        01736004
XTA41A   EQU   *                                                        01740000
         DC    YL1(SYSMSG)                                              01750000
         DC    YL1(L'XTA41AT)                                           01760000
XTA41AT  DC    C'XTA0401 CALL WAS NOT PROCESSED.'                       01770000
         SPACE 2                                                        01830000
XTA41B   EQU   *                                                        01840004
         DC    YL1(SYSMSG)                                              01850000
         DC    YL1(L'XTA41BT)                                           01860004
XTA41BT  DC    C'XTA0401 REMOTE HOST IS NOT ACCEPTING CALLS.'           01870004
         SPACE 2                                                        01871004
XTA41C   EQU   *                                                        01872004
         DC    YL1(SYSMSG)                                              01873004
         DC    YL1(L'XTA41CT)                                           01874004
XTA41CT  DC    C'XTA0401 UNABLE TO COMPLETE CALL - LU IS UNKNOWN.'      01875004
         SPACE 2                                                        01880000
XTA41Z   EQU   *                                                        01890007
         DC    YL1(SYSMSG)                                              01900000
         DC    YL1(L'XTA41ZT)                                           01910007
XTA41ZT  DC    C'XTA0401 UNABLE TO CONNECT - RTNCD/FDBK2=...., SSENSEI=-01920004
               .....'                                                   01930000
XTA41ZRF EQU   *-19,4                                                   01940004
XTA41ZSS EQU   *-5,4                                                    01941004
         SPACE 2                                                        01950000
XTA0402  EQU   *                                                        01960000
         DC    YL1(SYSMSG-AALARM)                                       01970000
         DC    YL1(L'XTA0402T)                                          01980000
XTA0402T DC    C'XTA0402 REQUESTED CONNECTION ESTABLISHED.'             01990000
         END   XTAOSRX                                                  02000000