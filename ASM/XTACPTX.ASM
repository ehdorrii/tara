XTACPTX  TITLE 'TARA CAPTURE TASK ETXR (25.0)'                          00010005
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020005
*                                                                     * 00030005
*     MODULE NAME - XTACPTX                                           * 00040005
*                                                                     * 00050005
*     FUNCTIONAL DESCRIPTION - XTACPTX CHECKS WHETHER THE CAPTURE     * 00060005
*       TASK COMPLETED SUCCESSFULLY. IF IT DID NOT, THEN A MESSAGE    * 00070005
*       IS SENT TO THE USER, INDICATING WHAT HAPPENED (ADMITTEDLY,    * 00080005
*       IN AN EXTREMELY CRYPTIC FASHION). IF THE CAPTURE TASK DID     * 00090005
*       COMPLETE SUCCESSFULLY, THEN WE EITHER CALL THE CLEANUP        * 00100005
*       ROUTINE (XTACLNP) IF BOTH CLSDST'S ALREADY COMPLETED, OR      * 00101005
*       SIMPLY EXIT IF THEY DIDN'T, KNOWING THAT THE LAST TO FINISH   * 00102005
*       WILL CALL XTACLNP.                                            * 00103005
*                                                                     * 00104005
*     DRIVER - XTACPTX IS INVOKED FROM THE CONTROL PROGRAM WHEN THE   * 00110005
*       CAPTURE TASK (XTACPTT) TERMINATES.                            * 00120005
*                                                                     * 00130005
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTACPTX.              * 00140005
*                                                                     * 00150005
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00160005
*       OF THE EPILOGUE MACRO.                                        * 00170005
*                                                                     * 00180005
*     REGISTERS ON ENTRY -                                            * 00190005
*       BEFORE PROLOGUE:                                              * 00200005
*         R0:  CONTROL PROGRAM INFORMATION                            * 00210011
*         R1:  ADDRESS OF TCB FOR TERMINATED TASK                     * 00220011
*         R2-12: UNPREDICTABLE                                        * 00230011
*         R13: ADDRESS SAVEAREA PROVIDED BY THE CONTROL PROGRAM       * 00280011
*         R14: RETURN ADDRESS                                         * 00290005
*         R15: ENTRY ADDRESS                                          * 00300005
*       AFTER PROLOGUE:                                               * 00310005
*         R0-6: UNPREDICTABLE                                         * 00320012
*         R7:  TASK COMPLETION CODE                                   * 00330012
*         R8-9: UNPREDICTABLE                                         * 00340012
*         R10: POINTER TO COMMON STORAGE AREA                         * 00380005
*         R11: POINTER TO SESSION STORAGE AREA                        * 00390005
*         R12: ENTRY ADDRESS                                          * 00400005
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00410005
*         R14: RETURN ADDRESS                                         * 00420005
*         R15: RETURN CODE FROM FREEMAIN                              * 00430011
*                                                                     * 00440005
*     MACROS USED -                                                   * 00450005
*       IBM MACROS:                                                   * 00460005
*         FREEMAIN, GETMAIN, OPEN, CLOSE, DETACH                      * 00470011
*       NON-IBM MACROS:                                               * 00480005
*         EPILOGUE, PHASE, PROLOGUE                                   * 00490005
*                                                                     * 00500005
*     COPY MEMBERS -                                                  * 00510005
*       XTACMAP, XTASMAP, XTAS99P                                     * 00520005
*                                                                     * 00530005
*     INPUT -                                                         * 00540005
*       THE COMMAND BUFFER AND THE PRIMARY RPL.                       * 00550005
*                                                                     * 00560005
*     OUTPUT -                                                        * 00570005
*       THE CAPTURE DATASET.                                          * 00580005
*                                                                     * 00590005
*     ABENDS -                                                        * 00600005
*       NO ABENDS ARE ISSUED BY THIS MODULE.                          * 00610005
*                                                                     * 00620005
*     MESSAGES ISSUED -                                               * 00630005
*       XTA2301  .                                                    * 00640005
*                                                                     * 00650005
*     RETURN CODES -                                                  * 00660005
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00670005
*                                                                     * 00680005
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00690005
XTACPTX  PROLOGUE ETXR=CAPTURE                                          00850005
         EJECT                                                          00851007
**                                                                      00860005
*                                                                       00870005
    PHASE  25.1 - IF TERMINATION WAS NORMAL ---> 25.4                   00880012
*                                                                       00890005
**                                                                      00900005
         SPACE 1                                                        00910005
         RLSLOCK SS#TLOCK          JUST IN CASE THE LOCK WASN'T FREED.  00910110
         TM    SS#FLAG1,SS#LOGFF   IF THIS HAPPENED AS A RESULT OF A    00910213
         BO    PH25#4                LOGOFF REQUEST, SKIP MESSAGES.     00910313
         MVI   SS#FLAG4,X'00'      NO CAPTURE ACTIVITY AT ALL.          00911009
         LTR   R7,R7               CHECK FOR ABEND CODE FROM TASK.      00931012
         BNZ   PH25#3                                                   00932014
         CLC   =XL4'00',SS#CTFDB   CHECK FOR A NON-ZERO FEEDBACK CODE   00933012
         BE    PH25#4                FROM THE CAPTURE TASK.             00934012
         EJECT                                                          01060012
**                                                                      01061012
*                                                                       01062012
    PHASE  25.2 - ISSUE MESSAGE DESCRIBING CAPTURE TASK FAILURE.        01063020
*                                                                       01064012
**                                                                      01065012
         SPACE 1                                                        01066012
         NI    SS#FLAG4,X'FF'-SS#OPENG  ('SAVE AS' NO LONGER PENDING.)  01066122
         LA    R14,PH25#4          PRE-LOAD R14 AND R15 FOR THE CALL    01066217
         L     R15,CS#APSMR          TO PSMR WITH RETURN AT PHASE 25.2. 01066317
         LA    R3,MSGTABLE         POINT TO THE TABLE OF RETURN CODES   01066417
         LA    R2,#MSGS              WITH ASSOCIATED MESSAGES.          01066517
         SPACE 1                                                        01066616
FINDMSG  EQU   *                   CHECK THE ACTUAL RETURN CODE AGAINST 01066717
         L     R1,0(R3)              THE RETURN CODES IN THE TABLE      01066817
         CLC   SS#CTRC(2),4(R3)      UNTIL A MATCH IS FOUND OR UNTIL    01066920
         BER   R15                   THE LIST IS EXHAUSTED...IF A MATCH 01067017
         LA    R3,8(R3)              IS FOUND, SEND AN APPROPRIATE      01067117
         BCT   R2,FINDMSG            MESSAGE, ELSE...                   01067217
         SPACE 1                                                        01067316
         ICM   R3,B'1111',SS#CTFDB TAKE THE FEEDBACK AND RETURN CODE    01067412
         CVH   R3,FBKCODE,MF=LONG    INFO FROM THE TASK FEEDBACK AREA,  01068012
         ICM   R3,B'1111',SS#CTRC    AND FORMAT THEM INTO A MESSAGE TO  01069012
         CVH   R3,CTRCODE            BE DISPLAYED AT THE TERMINAL.      01069112
         LA    R1,CPTFAIL                                               01069212
         BR    R15                                                      01069316
         EJECT                                                          01069612
**                                                                      01069712
*                                                                       01069812
    PHASE  25.3 - ISSUE MESSAGE GIVING ABEND CODE.                      01069912
*                                                                       01070012
**                                                                      01070112
         SPACE 1                                                        01070212
         CVH   R7,ABCODE           DISPLAY THE ABEND CODE.              01070312
         LA    R1,CPTABND                                               01070412
         L     R15,CS#APSMR                                             01070512
         BALR  R14,R15                                                  01070612
         EJECT                                                          01071005
**                                                                      01080005
*                                                                       01090005
    PHASE  25.4 - DO CLEANUP IF VTAM GOT DONE FIRST.                    01100012
*                                                                       01110005
**                                                                      01120005
         SPACE 1                                                        01130005
         TM    SS#FLAG1,SS#PACT+SS#SACT   IF WE ARE THE LAST REMAINING  01140007
         BNZ   PH25#99               SOUL THEN WE DO THE FINAL CLEANUP. 01150007
         SPACE 1                                                        01160005
         OI    SS#FLAG1,SS#ALLDN   INDICATE NORMAL CLEANUP PROCESSING,  01170007
         L     R15,CS#ACLNP          THEN CALL THE CLEANER-UPPER.       01180007
         BALR  R14,R15                                                  01190005
         EJECT                                                          01200005
**                                                                      01210005
*                                                                       01220005
   PHASE 25.99  -  EXIT.                                                01230005
*                                                                       01240005
**                                                                      01250005
         SPACE 1                                                        01260005
         SR    R15,R15             ZERO RETURN CODE                     01271005
         EPILOGUE                  RETURN                               01272005
*********************************************************************** 01273005
*********************************************************************** 01274005
********                                                       ******** 01275005
********               END OF EXECUTABLE CODE                  ******** 01276005
********                                                       ******** 01277005
*********************************************************************** 01278005
*********************************************************************** 01279005
         EJECT                                                          01279105
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01279205
*                                                                     * 01279305
*        VARIABLE-TEXT MESSAGES                                       * 01279416
*                                                                     * 01279505
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01279605
         SPACE 1                                                        01391012
CPTFAIL  DC    YL1(SYSMSG)                                              01392012
         DC    YL1(L'XTA2502)                                           01393012
XTA2502  DC    C'XTA2502  CAPTURE TASK FAILURE: %%%%%%%%/%%%%%%%%.'     01394012
LCPTFAIL EQU   *-CPTFAIL                                                01395012
FBKCODE  EQU   *-18,8                                                   01396012
CTRCODE  EQU   *-9,8                                                    01397012
         SPACE 1                                                        01398012
CPTABND  DC    YL1(SYSMSG)                                              01399012
         DC    YL1(L'XTA2503)                                           01399112
XTA2503  DC    C'XTA2503  CAPTURE TASK ABEND: %%%%%%%%.'                01399212
LCPTABND EQU   *-CPTABND                                                01399312
ABCODE   EQU   *-9,8                                                    01399412
         EJECT                                                          01399516
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01399616
*                                                                     * 01399716
*        FIXED-TEXT MESSAGES                                          * 01399816
*                                                                     * 01399916
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01400016
         SPACE 1                                                        01401016
MSGTABLE DS    0F                                                       01402018
         DC    A(ALLOC),X'020C0000'                                     01402121
         DC    A(ALLOC),X'02100000'                                     01402221
         DC    A(NOVOL),X'02180000'                                     01402421
         DC    A(ALLOC),X'02200000'                                     01402521
         DC    A(NOVOL),X'02480000'                                     01402621
         DC    A(BADDS),X'035C0002'                                     01402722
         DC    A(UNCAT),X'17080000'                                     01402821
         DC    A(DUPDS),X'47040000'                                     01403016
         DC    A(NOSPC),X'47140000'                                     01405021
         DC    A(UNCAT),X'57080000'                                     01407016
         DC    A(UNCAT),X'57100000'                                     01408016
         DC    A(NOFND),X'67080000'                                     01409021
#MSGS    EQU   (*-MSGTABLE)/8                                           01409516
         SPACE 1                                                        01409616
DUPDS    DC    YL1(SYSMSG),YL1(L'XTA2502A)                              01409716
XTA2502A DC    C'XTA2502  DUPLICATE DATASET NAME ON VOLUME.'            01409816
NOFND    DC    YL1(SYSMSG),YL1(L'XTA2502B)                              01409921
XTA2502B DC    C'XTA2502  DATASET NOT FOUND.'                           01410016
UNCAT    DC    YL1(SYSMSG),YL1(L'XTA2502C)                              01410116
XTA2502C DC    C'XTA2502  DATASET NOT IN CATALOG.'                      01410216
ALLOC    DC    YL1(SYSMSG),YL1(L'XTA2502D)                              01410316
XTA2502D DC    C'XTA2502  DATASET ALLOCATED TO ANOTHER JOB OR USER.'    01410416
NOVOL    DC    YL1(SYSMSG),YL1(L'XTA2502E)                              01411016
XTA2502E DC    C'XTA2502  REQUESTED VOLUME NOT AVAILABLE.'              01412016
NOSPC    DC    YL1(SYSMSG),YL1(L'XTA2502F)                              01413021
XTA2502F DC    C'XTA2502  NOT ENOUGH SPACE ON VOLUME.'                  01414016
BADDS    DC    YL1(SYSMSG),YL1(L'XTA2502G)                              01415022
XTA2502G DC    C'XTA2502  INVALID DATASET NAME.'                        01416022
         END                                                            01420005