XTACLDX  TITLE 'TARA CLOSE-DEST EXIT (13.0)'                            00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTACLDX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTACLDX DOES THE NECESSARY CLEANUP     * 00060000
*       REQUIRED AFTER A CLSDST COMPLETES: IF THE CLSDST WAS FOR      * 00070000
*       THE PRIMARY, ANY SECONDARY SESSION IS CLSDST'D. IF NO         * 00080000
*       PRIMARY OR SECONDARY SESSION REMAINS, SESSION STORAGE IS      * 00090000
*       FREED.                                                        * 00100000
*                                                                     * 00110000
*     DRIVER - THIS EXIT IS DRIVEN BY VTAM WHEN A CLSDST COMPLETES.   * 00120000
*                                                                     * 00130000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTACLDX.              * 00140000
*                                                                     * 00150000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00160000
*       OF THE EPILOGUE MACRO.                                        * 00170000
*                                                                     * 00180000
*     REGISTERS ON ENTRY -                                            * 00190000
*       BEFORE PROLOGUE:                                              * 00200000
*         R0:  UNPREDICTABLE                                          * 00210000
*         R1:  ADDRESS OF RPL WHOSE COMPLETION DROVE THIS EXIT        * 00220000
*         R2-R13:  UNPREDICTABLE                                      * 00230000
*         R14: RETURN ADDRESS                                         * 00240000
*         R15: ENTRY ADDRESS                                          * 00250000
*       AFTER PROLOGUE:                                               * 00260000
*         R0:  UNPREDICTABLE                                          * 00270000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00280000
*         R2-R8: UNPREDICTABLE                                        * 00290000
*         R9:  ADDRESS OF RPL WHOSE COMPLETION DROVE THIS EXIT        * 00300000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00310000
*         R11: UNPREDICTABLE                                          * 00320000
*         R12: ENTRY ADDRESS                                          * 00330000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00340000
*         R14: RETURN ADDRESS                                         * 00350000
*         R15: ENTRY ADDRESS                                          * 00360000
*                                                                     * 00370000
*     MACROS USED -                                                   * 00380000
*       IBM MACROS:                                                   * 00390000
*         CHECK, CLSDST, FREEMAIN, GETMAIN                            * 00400001
*       NON-IBM MACROS:                                               * 00410000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00420000
*                                                                     * 00430000
*     COPY MEMBERS -                                                  * 00440000
*       XTACMAP                                                       * 00450000
*                                                                     * 00460000
*     INPUT -                                                         * 00470000
*       THE CLSDST RPL                                                * 00480000
*                                                                     * 00490000
*     OUTPUT -                                                        * 00500000
*       WHEN THIS EXIT IS INVOKED FOR THE CLSDST ON THE PRIMARY,      * 00510000
*       STATISTICAL RECORDS ARE WRITTEN TO THE LOG.                   * 00520000
*                                                                     * 00530000
*     ABENDS -                                                        * 00540000
*       NONE.                                                         * 00550001
*                                                                     * 00570000
*     MESSAGES ISSUED -                                               * 00580000
*       NO MESSAGES ARE ISSUED BY THIS MODULE.                        * 00590000
*                                                                     * 00600000
*     RETURN CODES -                                                  * 00610000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00620000
*                                                                     * 00630000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00640000
XTACLDX  PROLOGUE EXIT=RPL                                              00650000
         EJECT                                                          00660000
**                                                                      00670000
*                                                                       00680000
    PHASE  13.1 - CHECK THE RPL                                         00690000
*                                                                       00700000
**                                                                      00710000
         CHECK RPL=(R9)            ANY ERRORS?                          00720000
         EJECT                                                          00730000
**                                                                      00740000
*                                                                       00750000
    PHASE  13.2 - WHICH SESSION ENDED?                                  00760000
*                                                                       00770000
**                                                                      00780000
         CLC   RPLARG,SS#PCID      IS THIS A CLSDST FOR THE PRIMARY?    00790000
         BE    PH13#3              GO HANDLE END-OF-PRIMARY SESSION     00800000
         CLC   RPLARG,SS#SCID      IS THIS A CLSDST FOR THE SECONDARY?  00810000
         BE    PH13#4              GO HANDLE END-OF-SECONDARY SESSION   00820000
         L     R15,CS#ACLNP        UNKNOWN CID                          00830011
         BALR  R14,R15                                                  00840000
         B     PH13#99                                                  00850000
         EJECT                                                          00860000
**                                                                      00870000
*                                                                       00880000
    PHASE  13.3 - DEAL WITH END-OF-PRIMARY SESSION                      00890000
*                                                                       00900000
**                                                                      00910000
         NI    SS#FLAG1,X'FF'-SS#PACT    FLAG PRIMARY AS GONE           00920002
         SPACE                                                          00930000
         MVC   SS#LMSG(L'XTA1303T+2),XTA1303              TEMPLATE      00940000
         MVC   SS#LMSG+2(L'SS#PNODE),SS#PNODE             LUNAME        00950010
         SPACE                                                          00960000
         LA    R1,SS#LMSG          POINT TO RECORD                      00970000
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           00980000
         BALR  R14,R15             WRITE THE RECORD                     00990000
         SPACE                                                          01000000
         TM    SS#FLAG1,SS#SACT    IS THERE A SECONDARY SESSION?        01010002
         BZ    PH13#5              NO, THEN CLEAN THINGS UP             01020000
         L     R9,SS#ACRPL         POINT TO CLSDST RPL                  01060000
         L     R5,SS#SCID          GET 2NDARY CID                       01070000
         L     R8,CS#ACLDX         ADDRESS OF CLSDST EXIT               01080000
         CLSDST RPL=(R9),          CLOSE THE SECONDARY                 X01090000
               ARG=(R5),                                               X01100000
               EXIT=(R8),                                              X01110000
               OPTCD=(ASY,RELEASE)                                      01120000
         B     PH13#99             EXIT - I SHALL RETURN                01130000
         SPACE                                                          01140000
         EJECT                                                          01150000
**                                                                      01160000
*                                                                       01170000
    PHASE  13.4 - DEAL WITH END-OF-SECONDARY SESSION                    01180000
*                                                                       01190000
**                                                                      01200000
         L     R2,SS#AHNAE               FREE THE LU WE WERE USING.     01210000
         USING HT#STATF,R2                                              01211008
         NI    HT#STATF,X'FF'-HT#INUSE   FLAG IT AS AVAILABLE.          01220008
         DROP  R2                                                       01221008
         SPACE 1                                                        01230000
ENDIT    EQU   *                                                        01240000
         NI    SS#FLAG1,X'FF'-SS#SACT                                   01250002
         SPACE                                                          01260000
         MVC   SS#LMSG(L'XTA1304T+2),XTA1304              TEMPLATE      01270000
         MVC   SS#LMSG+02(L'SS#SNODE),SS#PNODE            P LUNAME      01280010
         MVC   SS#LMSG+10(L'SS#SNODE),SS#SNODE            S LUNAME      01290010
         MVC   SS#LMSG+18(L'SS#SNDCT),SS#SNDCT            MSGS SENT     01300010
         MVC   SS#LMSG+22(L'SS#RCVCT),SS#RCVCT            MSGS RECEIVED 01310010
         SPACE                                                          01320000
         MVI   SS#SNODE,C' '       CLEAR NODE NAME                      01330000
         MVC   SS#SNODE+1(L'SS#SNODE-1),SS#SNODE                        01340000
         LA    R1,SS#LMSG          POINT TO RECORD                      01350000
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           01360000
         BALR  R14,R15             WRITE THE RECORD                     01370000
         SPACE                                                          01380000
         SR    R2,R2               PROVIDE A ZERO                       01390000
         ST    R2,SS#SNDCT         RESET SEND COUNT                     01400000
         ST    R2,SS#RCVCT         RESET RECEIVE COUNT                  01410000
         SPACE                                                          01420000
         TM    SS#FLAG1,SS#PACT    IS THERE A PRIMARY SESSION?          01430002
         BZ    PH13#5              IF NOT, GO CLEANUP.                  01440000
         SPACE 1                                                        01450000
         LA    R1,XTA1305          OTHERWISE, INFORM PRIMARY            01460000
         L     R15,CS#APSMR          THAT THE SESSION WAS TERMINATED.   01470000
         BALR  R14,R15                                                  01480000
         B     PH13#99             THEN EXIT.                           01490000
         EJECT                                                          01500000
**                                                                      01510000
*                                                                       01520000
    PHASE  13.5 - DO CLEANUP WHEN BOTH SESSION HALFS ARE GONE           01530006
*                                                                       01540000
**                                                                      01550000
         TM    SS#FLAG4,SS#CAPDS   ...BUT FIRST, CHECK THAT WE AREN'T   01551007
         BO    PH13#99               STILL CLOSING/DEALLOCATING.        01552007
         SPACE 1                                                        01553007
         OI    SS#FLAG1,SS#ALLDN   INDICATE THAT NORMAL CLEANUP         01560006
         L     R15,CS#ACLNP          IS BEING REQUESTED, AND FINISH     01570006
         BALR  R14,R15               UP THIS SESSION. BYE!              01580006
         EJECT                                                          01990000
**                                                                      02000000
*                                                                       02010000
    PHASE  13.99 - EXIT                                                 02020000
*                                                                       02030000
**                                                                      02040000
         SR    R15,R15             ZERO RETURN CODE                     02050000
         EPILOGUE                  RETURN                               02060000
*********************************************************************** 02070000
*********************************************************************** 02080000
********                                                       ******** 02090000
********               END OF EXECUTABLE CODE                  ******** 02100000
********                                                       ******** 02110000
*********************************************************************** 02120000
*********************************************************************** 02130000
         EJECT                                                          02140000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02150000
*                                                                     * 02160000
*        CONSTANTS USED IN THIS ROUTINE                               * 02170000
*                                                                     * 02180000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02190000
XTA1303  DC    YL1(USTATUS)        RECORD TYPE                          02200000
         DC    YL1(L'XTA1303T)     LENGTH OF TEXT                       02210000
XTA1303T DC    C'__PLU___ CLOSE COMPLETE'                               02220010
         SPACE                                                          02230000
XTA1304  DC    YL1(FSTATS)         RECORD TYPE                          02240000
         DC    YL1(L'XTA1304T)     LENGTH OF TEXT                       02250000
XTA1304T DC    C'__PLU___--SLU---#SND#RCV'                              02260010
         SPACE , 234567890123456789012345                               02270010
XTA1305  DC    YL1(SYSMSG-AALARM)                                       02280000
         DC    YL1(L'XTA1305T)                                          02290000
XTA1305T DC    C'XTA1304 REMOTE SESSION ENDED.'                         02300000
         EJECT                                                          02310000
         LTORG                                                          02320000
         END                                                            02330000