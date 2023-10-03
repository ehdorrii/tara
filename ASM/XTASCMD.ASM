XTASCMD  TITLE 'TARA SYSTEM COMMAND PROCESSOR (21.0)'                   00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTASCMD                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTASCMD HANDLES COMMANDS FROM THE      * 00060000
*       TERMINAL USER WHICH DON'T INVOLVE ISSUING VTAM MACRO CALLS.   * 00070000
*                                                                     * 00080000
*     DRIVER - CALLED VIA BAL(R) FROM XTAPRRX.                        * 00090002
*                                                                     * 00100000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTASCMD.              * 00110000
*                                                                     * 00120000
*     REGISTERS ON ENTRY -                                            * 00130000
*       BEFORE PROLOGUE:                                              * 00140000
*         R0-R12: TREATED AS UNPREDICTABLE.                           * 00150019
*         R13: POINTER TO SAVEAREA.                                   * 00151019
*         R14: RETURN ADDRESS.                                        * 00152019
*         R15: ENTRY ADDRESS.                                         * 00153019
*       AFTER PROLOGUE:                                               * 00160000
*         R0:  UNPREDICTABLE.                                         * 00170019
*         R1:  ADDRESS OF GETMAINED SAVEAREA.                         * 00171019
*         R2-R9: UNPREDICTABLE.                                       * 00172019
*         R10: POINTER TO COMMON STORAGE AREA.                        * 00173019
*         R11: POINTER TO SESSION STORAGE AREA.                       * 00174019
*         R12: ENTRY ADDRESS.                                         * 00175019
*         R13: POINTER TO GETMAINED SAVEAREA.                         * 00176019
*         R14: RETURN ADDRESS.                                        * 00177019
*         R15:  RETURN CODE FROM GETMAIN.                             * 00178019
*                                                                     * 00180000
*     MACROS USED -                                                   * 00190000
*       IBM MACROS:                                                   * 00200000
*         GETMAIN, FREEMAIN, ABEND                                    * 00210002
*       NON-IBM MACROS:                                               * 00220000
*         PROLOGUE, EPILOGUE, PHASE, CVH                              * 00230002
*                                                                     * 00240000
*     COPY MEMBERS:                                                   * 00250000
*       XTACMAP, XTASMAP, XTAHELP.                                    * 00260009
*                                                                     * 00270000
*     INPUT:                                                          * 00280000
*       A COMMAND AS DESCRIBED BY A CDB LIVING IN SS#WORK2.           * 00290019
*                                                                     * 00291002
*     OUTPUT:                                                         * 00300000
*       VARIES DEPENDING UPON THE COMMAND BEING PROCESSED.            * 00310002
*                                                                     * 00311002
*     ABENDS:                                                         * 00320000
*       USER 2100 IS ISSUED UPON REQUEST (!!ABEND.).                  * 00330002
*                                                                     * 00331002
*     MESSAGES ISSUED:                                                * 00340000
*       LOTS! REFER TO THE CODE FOR THE MESSAGE TEXTS.                * 00350002
*                                                                     * 00351002
*     RETURN CODES:                                                   * 00360000
*       ALWAYS ZERO.                                                  * 00370002
*                                                                     * 00371002
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00380000
         SPACE 1                                                        00390000
XTASCMD  PROLOGUE SUBR=SYSCMD                                           00400000
         EJECT                                                          00410000
**                                                                      00420000
*                                                                       00430000
    PHASE 21.0  -  DISPATCH COMMAND PROCESSOR OR WRITE ERROR MESSAGE    00440020
*                                                                       00450000
*   (NOTE THAT PHASE ISSUED ONLY ON ENTRY AND EXIT IN THIS ROUTINE.)    00451020
**                                                                      00460000
         SPACE 1                                                        00470000
*--------------  FIND A MATCH FOR THE ENTERED COMMAND  ---------------* 00480000
         SPACE 1                                                        00490000
         LA    R3,CMDTABLE          PREPARE TO SEARCH FOR A VALID       00500000
         LA    R4,#CMDS               COMMAND.                          00510000
         SPACE 1                                                        00520000
CMDLOOP  EQU   *                                                        00530000
         L     R15,0(R3)            GET ADDRESS OF COMMAND PROCESSOR,   00540000
         LH    R5,4(R3)               THEN, IF THE INPUT MATCHES, GO    00550000
         EX    R5,CLC@CMD             TO THAT MODULE.                   00560000
         BER   R15                                                      00570000
         SPACE 1                                                        00580000
         LA    R3,16(R3)            BUMP TO NEXT ENTRY, AND LOOP UNTIL  00590000
         BCT   R4,CMDLOOP             TABLE EXHAUSTED.                  00600000
         SPACE 1                                                        00610000
*--------  COMMAND NOT FOUND - WRITE ERROR MESSAGE AND EXIT  ---------* 00620000
         SPACE 1                                                        00630000
         LA    R1,XBADMSG           ISSUE AN INSULTING ERROR MESSAGE    00640000
         B     EXITMSG               AND EXIT.                          00650000
         SPACE 1                                                        00660000
*---------  INVALID OPERAND - WRITE ERROR MESSAGE AND EXIT  ----------* 00670000
         SPACE 1                                                        00680000
HUH      EQU   *                                                        00690000
         LA    R1,XBOPMSG           ISSUE AN INSULTING ERROR MESSAGE    00700000
         B     EXITMSG               AND EXIT.                          00710000
         SPACE 1                                                        00711007
*----- CONFLICTING OPTIONS REQUESTED - SEND AN ERROR MESSAGE ---------* 00712007
         SPACE 1                                                        00713007
CONFLICT EQU   *                                                        00714007
         LA    R1,XCONMSG           ISSUE ERROR MESSAGE AND LEAVE.      00715007
         B     EXITMSG                                                  00716007
         EJECT                                                          00720000
*-------------------- THE HELP COMMAND PROCESSOR ---------------------* 00730016
         SPACE 1                                                        00740000
HELP     EQU   *                   TWO OPTION SETTINGS MUST BE FORCED   00750015
         OI    SS#FLAG2,SS#AWRAP     TO PROPERLY PROCESS HELP PANELS.   00750115
         NI    SS#FLAG2,X'FF'-SS#ERASE                                  00750215
         LA    R1,XHLPHLP          POINT TO THE 'HELP HELP' PANEL,      00750313
         CLI   SS#WORK2,X'03'        AND SEND IT IF THE NUMBER OF       00750413
         BNE   EXITMSG               OPERANDS WAS OTHER THAN 1.         00750513
         SPACE 1                                                        00750608
MULTIOP  EQU   *                   GENERATE A POINTER TO THE OPERAND    00750713
         LA    R3,SS#WORK2+3         WHICH WAS ENTERED WITH THE HELP    00750813
         SLR   R4,R4                 COMMAND, AND TRY TO MATCH IT       00750913
         IC    R4,SS#WORK2+3         WITH AN ENTRY IN THE HELP TABLE.   00751013
         LA    R3,1(R3,R4)           IF A MATCH IS FOUND, SEND THE      00751113
         SLR   R4,R4                 ASSOCIATED PANEL; ELSE SEND THE    00751213
         IC    R4,0(R3)              'HELP HELP' PANEL.                 00751313
         LA    R5,HELPTAB                                               00751413
         L     R6,#HELPS                                                00751513
         SPACE 1                                                        00751713
HELPLOOP EQU   *                                                        00751813
         L     R1,0(R5)                                                 00751913
         EX    R4,CLC@HLP          -- CLC 0(0,R3),4(R5) --              00752013
         BE    EXITMSG                                                  00752113
         LA    R5,16(R5)                                                00752213
         BCT   R6,HELPLOOP                                              00752313
         SPACE 1                                                        00752413
         LA    R1,XHLPHLP                                               00752513
         B     EXITMSG                                                  00752609
         EJECT                                                          00752708
*------------------ THE DELIMIT COMMAND PROCESSOR --------------------* 00752808
         SPACE 1                                                        00753008
DELIMIT  EQU   *                                                        00754008
         LA    R1,XNOPMSG                                               00760000
         CLI   SS#WORK2,X'03'                                           00770000
         BL    EXITMSG                                                  00780000
         SPACE 1                                                        00790000
         LA    R1,XBOPMSG                                               00800000
         LA    R4,SS#WORK2+3                                            00810000
         SLR   R5,R5                                                    00820000
         IC    R5,0(R4)                                                 00830000
         LA    R4,1(R4,R5)                                              00840000
         CLI   0(R4),X'01'                                              00850000
         BL    EXITMSG                                                  00860000
         SPACE 1                                                        00870000
         MVC   SS#SEPCH,1(R4)          FETCH THE NEW DELIMITER AND      00880000
         TR    SS#SEPCH,OK3270     MAKE SURE IT'S SOCIALLY ACCEPTABLE.  00890000
         MVC   SS#WORK1(L'XDLMMSGT+2),XDLMMSG    BUILD A MESSAGE TO     00900000
         MVC   SS#WORK1+29(1),SS#SEPCH           NOTIFY THE USER WHAT   00910000
         LA    R1,SS#WORK1         THE NEW DELIMITER CHARACTER IS.      00920000
         B     EXITMSG                                                  00930000
         SPACE 1                                                        00940000
*------------------- THE ALARM COMMAND PROCESSOR ---------------------* 00950000
         SPACE 1                                                        00960000
ALARM    EQU   *                                                        00970000
         MVC   SS#WORK1(L'XALMMSGT+2),XALMMSG                           00980000
         LA    R1,SS#WORK1         GET READY TO SEND A MESSAGE.         00990000
         CLC   SS#WORK2+9(4),OFF   OK, SHORT AND SWEET: ALL WE WANT IS  01000000
         BE    ALARMOFF              A SIMPLE YES OR NO.                01010000
         CLC   SS#WORK2+9(3),ON                                         01020000
         BNE   HUH                                                      01030000
         SPACE 1                                                        01040000
ALARMON  EQU   *                                                        01050000
         NI    SS#FLAG2,X'FF'-SS#NOALM                                  01060001
         MVC   SS#WORK1+28(4),=C'ON. '   FINISH THE MESSAGE WE STARTED, 01070000
         B     EXITMSG               AND SEND IT.                       01080000
         SPACE 1                                                        01090000
ALARMOFF EQU   *                                                        01100000
         OI    SS#FLAG2,SS#NOALM   INDICATE ALARM NOT WANTED.           01110001
         MVC   SS#WORK1+28(4),=C'OFF.'   COMPLETE THE MESSAGE STARTED   01120000
         B     EXITMSG               ABOVE, AND SEND IT.                01130000
         EJECT                                                          01131020
*------------------- THE ERASE COMMAND PROCESSOR ---------------------* 01132004
         SPACE 1                                                        01133004
ERASE    EQU   *                                                        01134004
         MVC   SS#WORK1(L'XERSMSGT+2),XERSMSG                           01135004
         LA    R1,SS#WORK1         GET READY TO SEND A MESSAGE.         01136004
         CLC   SS#WORK2+9(3),ON    OK, SHORT AND SWEET: ALL WE WANT IS  01137006
         BE    ERASEON               A SIMPLE YES OR NO.                01138005
         CLC   SS#WORK2+9(4),OFF                                        01139006
         BNE   HUH                                                      01139104
         SPACE 1                                                        01139204
ERASEOFF EQU   *                                                        01139304
         NI    SS#FLAG2,X'FF'-SS#ERASE                                  01139404
         MVC   SS#WORK1+35(4),=C'OFF.'   FINISH THE MESSAGE WE STARTED, 01139504
         B     EXITMSG               AND SEND IT.                       01139604
         SPACE 1                                                        01139704
ERASEON  EQU   *                                                        01139804
         TM    SS#FLAG2,SS#AWRAP                                        01139907
         BO    CONFLICT                                                 01140007
         OI    SS#FLAG2,SS#ERASE   INDICATE ERASE OPTION CHOSEN.        01140104
         MVC   SS#WORK1+35(4),=C'ON. '   COMPLETE THE MESSAGE STARTED   01140204
         B     EXITMSG               ABOVE, AND SEND IT.                01140304
         SPACE 1                                                        01141000
*------------------- THE WRAP COMMAND PROCESSOR ----------------------* 01150000
         SPACE 1                                                        01160000
WRAP     EQU   *                                                        01170000
         MVC   SS#WORK1(L'XWRPMSGT+2),XWRPMSG  BEGIN A MESSAGE TO       01180000
         LA    R1,SS#WORK1         ACKNOWLEDGE THE COMMAND.             01190000
         CLC   SS#WORK2+8(4),OFF   AGAIN, NOTHING FANCY: WE TAKE CASH.  01200000
         BE    WRAPOFF                                                  01210000
         CLC   SS#WORK2+8(3),ON                                         01220000
         BNE   HUH                                                      01230000
         SPACE 1                                                        01240000
WRAPON   EQU   *                                                        01250000
         TM    SS#FLAG2,SS#ERASE                                        01251007
         BO    CONFLICT                                                 01252007
         OI    SS#FLAG2,SS#AWRAP   AND IT WAS ALL FOR THIS...           01260001
         MVC   SS#WORK1+34(4),=C'ON. '                                  01270000
         B     EXITMSG                                                  01280000
         SPACE 1                                                        01290000
WRAPOFF  EQU   *                                                        01300000
         NI    SS#FLAG2,X'FF'-SS#AWRAP                                  01310001
         MVC   SS#WORK1+34(4),=C'OFF.'                                  01320000
         B     EXITMSG                                                  01330000
         EJECT                                                          01340000
*--------------  CLOSE AND UNCLOSE COMMAND PROCESSORS  ---------------* 01350000
         SPACE 1                                                        01360000
CLOSE    EQU   *                   CLOSE WILL CAUSE TARA TO SHUTDOWN    01370000
         OI    CS#FLAG1,CS#STOPI     GRACEFULLY WHEN THE SESSION        01380011
         LA    R1,XCLSMSG            COUNT GOES TO ZERO (I.E. THE LAST  01390000
         B     EXITMSG               USER LOGS OFF).                    01400000
         SPACE 3                                                        01410000
UNCLOSE  EQU   *                   UNCLOSE WILL REVERSE THE EFFECT OF   01420000
         NI    CS#FLAG1,X'FF'-CS#STOPI  A CLOSE COMMAND (DOESN'T WORK   01430011
         LA    R1,XUNCMSG            FOR OPERATOR STOP THOUGH: XTAMAIN  01440000
         B     EXITMSG               ISSUES SETLOGON QUIESCE).          01450000
         SPACE 1                                                        01460020
*--------------------  ABEND COMMAND PROCESSOR  ----------------------* 01470000
         SPACE 1                                                        01480000
ABEND    EQU   *                   ABEND WILL GENERATE A DUMP FOR       01490000
         ABEND 0,DUMP,,USER          DIAGNOSTIC PURPOSES.               01500000
         SPACE 1                                                        01510020
*---------------------  NAME COMMAND PROCESSOR  ----------------------* 01520000
         SPACE 1                                                        01530000
NAME     EQU   *                   NAME DISPLAYS NODE NAME OF PRIMARY   01540000
         MVI   SS#WORK1,SYSMSG-AALARM+CLEARIPT                          01550000
         MVI   SS#WORK1+1,16                                            01560000
         MVC   SS#WORK1+2(16),=C'XTA0000 ........'                      01570000
         MVC   SS#WORK1+10(8),SS#PNODE                                  01580000
         LA    R1,SS#WORK1                                              01590000
         B     EXITMSG                                                  01600000
         EJECT                                                          01610000
*---------------------  BASE COMMAND PROCESSOR  ----------------------* 01620020
         SPACE 1                                                        01630000
BASE     EQU   *                   THE BASE COMMAND INDICATES FROM      01640000
         CLC   SS#WORK2+11(7),COMMON WHAT LOCATION SUBSEQUENT SHOW      01650010
         BNE   NOTCS                 COMMANDS WILL BE BASED.            01660000
         ST    R10,SS#BASE         !!BASE. COMMON BASES DISPLAYS IN     01670000
         LA    R1,XBSCMSG            COMMON STORAGE.                    01680000
         B     EXITMSG                                                  01690000
         SPACE 1                                                        01700000
NOTCS    EQU   *                                                        01710000
         CLC   SS#WORK2+11(8),SESSION  !!BASE. SESSION BASES DISPLAYS   01720010
         BNE   NOTSS                 IN THE ISSUING USERS SESSION       01730000
         ST    R11,SS#BASE           STORAGE.                           01740000
         LA    R1,XBSSMSG                                               01750000
         B     EXITMSG                                                  01760000
         SPACE 1                                                        01770000
NOTSS    EQU   *                                                        01780000
         BAL   R8,HEXIN            !!BASE.,XXXX BASES DISPLAYS FROM     01790000
         ST    R5,SS#BASE            AN ABSOLUTE HEX ADDRESS.           01800000
         MVI   SS#WORK1,SYSMSG+CLEARIPT-AALARM                          01810000
         MVI   SS#WORK1+1,29                                            01820000
         MVC   SS#WORK1+2(29),=C'XTA0000  X''........'' IS BASE.'       01830000
         CVH   R5,SS#WORK1+13                                           01840000
         LA    R1,SS#WORK1                                              01850000
         B     EXITMSG                                                  01860000
         EJECT                                                          01870020
*---------------------  SHOW COMMAND PROCESSOR  ----------------------* 01871020
         SPACE 1                                                        01890020
SHOW     EQU   *                                                        01900000
         MVI   SS#WORK1,(ECHO-CLEARIPT)+NEWLINE BEGIN THE BUFFER        01910003
         MVI   SS#WORK1+1,L'XTMPLT+1   THAT WE WILL BE SENDING.         01920000
         MVI   SS#WORK1+2,X'08'    CARRIAGE RETURN (SEE SRRX AND PSMR). 01930000
         MVC   SS#WORK1+3(L'XTMPLT),XTMPLT                              01940000
         BAL   R8,HEXIN            GET THE OFFSET FROM THE COMMAND.     01950000
         L     R7,SS#BASE                                               01960000
         LA    R6,0(R5,R7)         CALCULATE THE STARTING ADDRESS FOR   01970000
         CVH   R6,SS#WORK1+3         THE DISPLAY, AND INSERT INTO MSG.  01980000
         ESPIE SET,TRAP0C4,(4)     TRAP 0C4'S                           01981020
         MVC   SS#WORK1+50(16),0(R6)    MOVE 16 BYTES INTO THE DISPLAY  01990000
         TR    SS#WORK1+50(16),OK3270    MESSAGE AND VALIDATE FOR 3270. 02000000
         LA    R8,4                                                     02002020
         LA    R7,SS#WORK1+13                                           02003020
         SPACE 1                                                        02004020
SHOWLOOP EQU   *                                                        02005020
         L     R5,0(R6)                                                 02010000
         STCM  R5,15,0(R7)                                              02020020
         UNPK  0(7,R7),0(4,R7)                                          02030020
         UNPK  7(1,R7),6(1,R7)                                          02040020
         OC    6(2,R7),CVH0007O                                         02050020
         TR    0(8,R7),CVH0007T                                         02051020
         LA    R7,9(R7)                                                 02060020
         LA    R6,4(R6)                                                 02070020
         BCT   R8,SHOWLOOP                                              02080020
         B     SHOWDONE                                                 02080120
         SPACE 1                                                        02080220
TRAP0C4  EQU   *                                                        02080320
         MVC   SS#WORK1+13(L'XFTCHPRT),XFTCHPRT                         02080420
         SPACE 1                                                        02080520
SHOWDONE EQU   *                                                        02080620
         ESPIE RESET,NOTRAP        CANCEL SPIE ENVIRONMENT              02081022
         LA    R1,SS#WORK1                                              02090000
         B     EXITMSG                                                  02100000
         EJECT                                                          02110000
*------  SUBROUTINE TO CONVERT AN EBCDIC OPERAND TO HEXADECIMAL  -----* 02111020
         SPACE 1                                                        02112020
HEXIN    EQU   *                   HEX INPUT SUBROUTINE                 02120000
         LA    R1,XNOPMSG          _SOME_ OPERAND IS REQUIRED...        02130000
         CLI   SS#WORK2,X'02'                                           02140000
         BNH   EXITMSG                                                  02150000
         LA    R1,XBOPMSG          ...BUT IT CAN'T BE LONGER THAN       02160000
         CLI   SS#WORK2+11,X'08'     8 CHARACTERS.                      02170000
         BH    EXITMSG                                                  02180000
         SLR   R3,R3                                                    02190000
         IC    R3,SS#WORK2+11      NUMBER OF HEX DIGITS                 02200000
         LA    R4,SS#WORK2+12      POINT TO FIRST DIGIT                 02210000
         SLR   R5,R5               ZERO OUT WORK REGISTER               02220000
         SPACE 1                                                        02230000
HEXLOOP  EQU   *                                                        02240000
         TR    0(1,R4),HEXTRAN     TRANSLATE FROM EBCDIC.               02250000
         CLI   0(R4),X'FF'         INVALID HEX DIGIT                    02260000
         BE    EXITMSG               IS TRANSLATED TO X'FF'.            02270000
         SLL   R5,8                APPEND THE HI NYBBLE TO THE END      02280000
         IC    R5,0(R4)              OF THE NUMBER IN THE WORK          02290000
         SRL   R5,4                  REGISTER.                          02300000
         LA    R4,1(R4)            POINT TO NEXT INPUT CHARACTER.       02310000
         BCT   R3,HEXLOOP          LOOP UP TO 8 TIMES.                  02320000
         SPACE 1                                                        02330000
ENDHEX   EQU   *                                                        02340000
         BR    R8                  RETURN TO CALLER                     02350000
         EJECT                                                          02360000
EXITMSG  EQU   *                                                        02370000
         L     R15,CS#APSMR                                             02380000
         BALR  R14,R15                                                  02390000
**                                                                      02400000
*                                                                       02410000
    PHASE 21.99  -  NOW WE SHOW THAT WE'VE LEFT THIS MODULE.            02420000
*                                                                       02430000
**                                                                      02440000
         SLR   R15,R15             SET RETURN CODE TO ZERO.             02450000
         EPILOGUE                                                       02460000
*********************************************************************** 02470000
*********************************************************************** 02480000
********                                                       ******** 02490000
********               END OF EXECUTABLE CODE                  ******** 02500000
********                                                       ******** 02510000
*********************************************************************** 02520000
*********************************************************************** 02530000
         EJECT                                                          02540000
*------------  TABLE OF COMMANDS HANDLED IN THIS MODULE  -------------* 02541020
         SPACE 1                                                        02542020
         DS    0D                                                       02550000
CMDTABLE EQU   *                                                        02560000
         DC    A(HELP),H'4',CL10'HELP'                                  02570008
         DC    A(WRAP),H'4',CL10'WRAP'                                  02571008
         DC    A(NAME),H'4',CL10'NAME'                                  02580000
         DC    A(ALARM),H'5',CL10'ALARM'                                02590000
         DC    A(ERASE),H'5',CL10'ERASE'                                02591004
         DC    A(DELIMIT),H'7',CL10'DELIMIT'                            02600000
         DC    A(DELIMIT),H'7',CL10'SEPCHAR'                            02610000
         DC    A(BASE),H'7',CL10'!!BASE.'                               02620000
         DC    A(SHOW),H'7',CL10'!!SHOW.'                               02630000
         DC    A(ABEND),H'8',CL10'!!ABEND.'                             02640000
         DC    A(CLOSE),H'8',CL10'!!CLOSE.'                             02650000
         DC    A(UNCLOSE),H'10',CL10'!!UNCLOSE.'                        02660000
#CMDS    EQU   (*-CMDTABLE)/16                                          02670000
         SPACE 1                                                        02700000
*------------------------- FIXED OPERANDS ----------------------------* 02710000
         SPACE 1                                                        02711009
ON       DC    X'02',C'ON'                                              02720000
OFF      DC    X'03',C'OFF'                                             02730000
COMMON   DC    X'06',C'COMMON'                                          02740000
SESSION  DC    X'07',C'SESSION'                                         02750000
         EJECT                                                          02760000
*------------------------- MESSAGE TEXTS -----------------------------* 02762009
         SPACE 1                                                        02763009
XBADMSG  DC    YL1(SYSMSG),YL1(L'XBADMSGT)                              02770000
XBADMSGT DC    C'XTA2100  INVALID COMMAND ENTERED.'                     02780007
         SPACE 1                                                        02790000
XNOPMSG  DC    YL1(SYSMSG),YL1(L'XNOPMSGT)                              02800000
XNOPMSGT DC    C'XTA2100  THIS COMMAND REQUIRES AN OPERAND.'            02810000
         SPACE 1                                                        02820000
XBOPMSG  DC    YL1(SYSMSG),YL1(L'XBOPMSGT)                              02830000
XBOPMSGT DC    C'XTA2100  THIS OPERAND IS INVALID.'                     02840000
         SPACE 1                                                        02850000
XCONMSG  DC    YL1(SYSMSG),YL1(L'XCONMSGT)                              02851007
XCONMSGT DC    C'XTA2100  CONFLICTING OPTIONS SELECTED.'                02852007
         SPACE 1                                                        02853007
XDLMMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XDLMMSGT)              02860000
XDLMMSGT DC    C'XTA2100  DELIMITER SET TO ''-''.'                      02870000
         SPACE 1                                                        02880000
XWRPMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XWRPMSGT)              02890000
XWRPMSGT DC    C'XTA2100  WRAP OPTION NOW TURNED     '                  02900000
         SPACE 1                                                        02910000
XALMMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XALMMSGT)              02920000
XALMMSGT DC    C'XTA2100  ALARM NOW TURNED     '                        02930000
         SPACE 1                                                        02931004
XERSMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XERSMSGT)              02932004
XERSMSGT DC    C'XTA2100  SCREEN ERASE NOW TURNED     '                 02933004
         SPACE 1                                                        02940000
XCLSMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XCLSMSGT)              02950000
XCLSMSGT DC    C'XTA2100  CLOSE ACCEPTED. SHUTDOWN MODE ENTERED.'       02960000
         SPACE 1                                                        02970000
XUNCMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XUNCMSGT)              02980000
XUNCMSGT DC    C'XTA2100  UNCLOSE ACCEPTED. SHUTDOWN MODE CANCELLED.'   02990000
         SPACE 1                                                        03000000
XBSCMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XBSCMSGT)              03010000
XBSCMSGT DC    C'XTA2100  COMMON BASE SET.'                             03020000
         SPACE 1                                                        03030000
XBSSMSG  DC    YL1(SYSMSG+CLEARIPT-AALARM),YL1(L'XBSSMSGT)              03040000
XBSSMSGT DC    C'XTA2100  SESSION BASE SET.'                            03050000
         SPACE 1                                                        03060000
*                000000001111111111222222222233333333334444444444       03070000
*                234567890123456789012345678901234567890123456789       03080000
XTMPLT   DC    C'........: ........ ........ ........ ........  .......-03090000
               .........'                                               03100000
         SPACE 1                                                        03100120
XFTCHPRT DC    CL(L'XTMPLT-10)'** FETCH-PROTECTED STORAGE **'           03100220
         EJECT                                                          03100320
*------------------------- EXECUTE OBJECTS ---------------------------* 03100420
         SPACE 1                                                        03100520
CLC@CMD  CLC   SS#WORK2+3(0),5(R3)                                      03100620
CLC@HLP  CLC   0(0,R3),4(R5)                                            03100720
         SPACE 1                                                        03100820
*----------------------- MISCELLANEOUS VALUES ------------------------* 03100922
         SPACE 1                                                        03101020
NOTRAP   DC    F'0'                                                     03101122
         SPACE 1                                                        03101222
*------------------------ TRANSLATE TABLES ---------------------------* 03101322
         SPACE 1                                                        03101422
*                 0 1 2 3 4 5 6 7 8 9 A B C D E F                       03101520
HEXTRAN  EQU   *                                                        03101620
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    0X                03101720
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    1X                03101820
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    2X                03101920
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    3X                03102020
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    4X                03102120
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    5X                03102220
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    6X                03102320
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    7X                03102420
         DC    X'FFA0B0C0D0E0F0FFFFFFFFFFFFFFFFFF'    8X                03102520
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    9X                03102620
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    AX                03102720
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    BX                03102820
         DC    X'FFA0B0C0D0E0F0FFFFFFFFFFFFFFFFFF'    CX                03102920
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    DX                03103020
         DC    X'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'    EX                03103120
         DC    X'00102030405060708090FFFFFFFFFFFF'    FX                03103220
         SPACE 1                                                        03103320
OK3270   EQU   *                                                        03103420
*     0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF  03103520
 DC C'----------------------------------------------------------------' 03103620
 DC C' ---------¢.<(+|.---------!$*);¬-/--------¦,%_>?---------`:#@.="' 03103720
 DC C'-ABCDEFGHI-------JKLMNOPQR-------~STUVWXYZ----------------------' 03103820
 DC C'{ABCDEFGHI------}JKLMNOPQR------\-STUVWXYZ------0123456789|-----' 03103920
         ORG   OK3270+80                                                03104020
         DC    X'50'    AMPERSAND                                       03104120
         ORG   OK3270+125                                               03104220
         DC    X'7D'    SINGLE QUOTE                                    03104320
         ORG                                                            03104420
         EJECT                                                          03104509
*----------------------- HELP MESSAGE TEXTS --------------------------* 03104609
         SPACE 1                                                        03104709
HELPTAB  DS    0F                                                       03104816
         DC    A(XHLPHLP),XL1'04',CL11'HELP'                            03104913
         DC    A(XHLPCMD),XL1'08',CL11'COMMANDS'                        03105013
         DC    A(XHLPALM),XL1'05',CL11'ALARM'                           03105118
         DC    A(XHLPBYE),XL1'03',CL11'BYE'                             03105218
         DC    A(XHLPBYE),XL1'06',CL11'LOGOFF'                          03105318
         DC    A(XHLPBYE),XL1'03',CL11'OFF'                             03105418
         DC    A(XHLPHST),XL1'05',CL11'HOSTS'                           03105513
#HELPS   DC    A((*-HELPTAB)/16)                                        03105617
         SPACE 1                                                        03105713
*  HELP MESSAGES ARE ISOLATED IN MEMBER XTAHELP, AS THEY CONTAIN        03105809
*  LOWER CASE CHARACTERS.                                               03105909
         SPACE 1                                                        03106009
         COPY  XTAHELP                                                  03107009
         END   XTASCMD                                                  03410000