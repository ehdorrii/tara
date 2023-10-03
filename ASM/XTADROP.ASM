XTADROP  TITLE 'TARA DROP-SECONDARY ROUTINE (9.0)'                      00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTADROP                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTADROP ISSUES A CLSDST AGAINST        * 00060002
*       THE SECONDARY SESSION, IF ONE EXISTS.                         * 00070002
*                                                                     * 00100002
*     DRIVER - XTADROP IS CALLED FROM XTAPRRX VIA BAL(R).             * 00109102
*                                                                     * 00109202
*     ENTRY - ONE ENTRY POINT IS PROVIDED, XTADROP.                   * 00109302
*                                                                     * 00109402
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00109502
*       OF THE EPILOGUE MACRO.                                        * 00109602
*                                                                     * 00109702
*     REGISTERS ON ENTRY -                                            * 00109802
*       BEFORE PROLOGUE:                                              * 00109902
*         R0:  UNPREDICTABLE                                          * 00110002
*         R1:  POINTER TO COMMAND DESCRIPTOR BLOCK                    * 00110102
*         R2-8: UNPREDICTABLE                                         * 00110202
*         R9:  ADDRESS OF PRIMARY RPL                                 * 00110302
*         R10: POINTER TO COMMON STORAGE AREA                         * 00110402
*         R11: POINTER TO SESSION STORAGE AREA                        * 00110502
*         R12: ADDRESS OF XTAPRRX'S ENTRY POINT                       * 00110602
*         R13: ADDRESS OF XTAPRRX'S SAVEAREA                          * 00110702
*         R14: RETURN ADDRESS                                         * 00110802
*         R15: ENTRY ADDRESS                                          * 00110902
*       AFTER PROLOGUE:                                               * 00111002
*         R0:  UNPREDICTABLE                                          * 00111102
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00111202
*         R2-6: UNPREDICTABLE                                         * 00111302
*         R7:  POINTER TO COMMAND DESCRIPTOR BLOCK                    * 00111402
*         R8:  UNPREDICTABLE                                          * 00111502
*         R9:  ADDRESS OF PRIMARY RPL                                 * 00111602
*         R10: POINTER TO COMMON STORAGE AREA                         * 00111702
*         R11: POINTER TO SESSION STORAGE AREA                        * 00111802
*         R12: ENTRY ADDRESS                                          * 00111902
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00112002
*         R14: RETURN ADDRESS                                         * 00112102
*         R15: RETURN CODE FROM GETMAIN                               * 00112202
*                                                                     * 00112302
*     MACROS USED -                                                   * 00112402
*       IBM MACROS:                                                   * 00112502
*         GETMAIN, FREEMAIN, CLSDST                                   * 00112602
*       NON-IBM MACROS:                                               * 00112702
*         PROLOGUE, EPILOGUE, PHASE                                   * 00112802
*                                                                     * 00112902
*     COPY MEMBERS -                                                  * 00113002
*       XTACMAP, XTASMAP                                              * 00113102
*                                                                     * 00113202
*     INPUT -                                                         * 00113302
*       A COMMAND DESCRIPTOR BLOCK                                    * 00113402
*                                                                     * 00113502
*     OUTPUT -                                                        * 00113602
*       CLSDST                                                        * 00113702
*                                                                     * 00113802
*     ABENDS -                                                        * 00113902
*       NO USER ABENDS                                                * 00114002
*                                                                     * 00114102
*     MESSAGES ISSUED -                                               * 00114202
*       NONE                                                          * 00114302
*                                                                     * 00114402
*     RETURN CODES -                                                  * 00114502
*       THE RETURN CODE IS ALWAYS ZERO                                * 00114602
*                                                                     * 00115000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00120000
XTADROP  PROLOGUE SUBR=DROP                                             00130000
         EJECT                                                          00140000
**                                                                      00150000
*                                                                       00160000
    PHASE  9.1 - IF THERE IS NO SECONDARY, NOTIFY THE USER              00170000
*                                                                       00180000
**                                                                      00190000
         TM    SS#FLAG1,SS#SACT    IS A SECONDARY ACTIVE?               00200001
         BO    PH9#2               YES, THEN GO AHEAD                   00210000
         SPACE                                                          00220000
         LA    R1,XTA0901          NO, POINT TO MESSAGE                 00230000
         L     R15,CS#APSMR        PSM ROUTINE ADDRESS                  00240000
         BALR  R14,R15             SEND THE MESSAGE TO PRIMARY          00250000
         B     PH9#99              GO TO EXIT                           00260000
         EJECT                                                          00270000
**                                                                      00280000
*                                                                       00290000
    PHASE  9.2 - LOG THE TERMINATION OF THE SECONDARY HALF-SESSION      00300000
*                                                                       00310000
**                                                                      00320000
         MVC   SS#LMSG(L'XTA0902T+2),XTA0902                            00330004
         MVC   SS#LMSG+2(L'SS#PNODE),SS#PNODE                           00340004
         MVC   SS#LMSG+10(L'SS#SNODE),SS#SNODE                          00350004
         SPACE                                                          00360000
         LA    R1,SS#LMSG          POINT TO RECORD                      00370000
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           00380000
         BALR  R14,R15             WRITE THE RECORD                     00390000
         EJECT                                                          00400000
**                                                                      00410000
*                                                                       00420000
    PHASE  9.3 - ISSUE THE CLSDST FOR THE SECONDARY                     00430000
*                                                                       00440000
**                                                                      00450000
         L     R4,SS#ACRPL         GET THE CLSDST RPL ADDRESS           00460000
         L     R8,SS#SCID          GET CID                              00470000
         L     R6,CS#ACLDX         ADDRESS OF CLSDST EXIT               00480000
         CLSDST RPL=(R4),                                              X00490000
               ARG=(R8),                                               X00500000
               EXIT=(R6),                                              X00510000
               OPTCD=(ASY,RELEASE)                                      00520000
         EJECT                                                          00530000
**                                                                      00540000
*                                                                       00550000
    PHASE  9.4 - TELL PRIMARY 'DISCONNECT IN PROGRESS'                  00560000
*                                                                       00570000
**                                                                      00580000
         SPACE                                                          00590000
         LA    R1,XTA0903          POINT TO MESSAGE                     00600000
         L     R15,CS#APSMR        PSM ROUTINE ADDRESS                  00610000
         BALR  R14,R15             SEND THE MESSAGE TO PRIMARY          00620000
         EJECT                                                          00630000
**                                                                      00640000
*                                                                       00650000
    PHASE  9.99 - EXIT                                                  00660000
*                                                                       00670000
**                                                                      00680000
         SR    R15,R15             ZERO RETURN CODE                     00690000
         EPILOGUE                  RETURN                               00700000
*********************************************************************** 00710000
*********************************************************************** 00720000
********                                                       ******** 00730000
********               END OF EXECUTABLE CODE                  ******** 00740000
********                                                       ******** 00750000
*********************************************************************** 00760000
*********************************************************************** 00770000
         EJECT                                                          00780000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00790000
*                                                                     * 00800000
*        CONSTANTS USED IN THIS ROUTINE                               * 00810000
*                                                                     * 00820000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00830000
XTA0901  DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      00840000
         DC    YL1(L'XTA0901T)     LENGTH OF MESSAGE                    00850000
XTA0901T DC    C'XTA0901 NO CONNECTION CURRENTLY EXISTS.'               00860000
         SPACE                                                          00870000
XTA0902  DC    YL1(FSTATUS)        RECORD TYPE                          00880000
         DC    YL1(L'XTA0902T)     LENGTH OF TEXT                       00890000
XTA0902T DC    C'--PLU---__SLU___ DROP REQUESTED'                       00900004
         SPACE                                                          00910000
XTA0903  DC    YL1(SYSMSG+CLEARIPT-AALARM)  MESSAGE FLAGS               00920000
         DC    YL1(L'XTA0903T)     LENGTH OF MESSAGE                    00930000
XTA0903T DC    C'XTA0903 DISCONNECT IN PROGRESS.'                       00940000
         SPACE                                                          00950000
         END                                                            00960000