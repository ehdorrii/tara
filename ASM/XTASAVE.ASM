XTASAVE  TITLE 'TARA SAVE COMMAND PROCESSOR (22.0)'                     00010018
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTASAVE                                           * 00040001
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTASAVE IS THE COMMAND PROCESSOR FOR   * 00060000
*       THE SAVE ON/OFF COMMAND.  FOR 'SAVE AS' IT ATTACHES THE       * 00070017
*       DATA CAPTURE TASK (XTACPTT), WHICH WILL DYNAMICALLY           * 00080017
*       ALLOCATE AND THEN OPEN THE CAPTURE DATA, AND THEN WAIT FOR    * 00090017
*       REQUESTS TO APPEAR IN IT'S QUEUE.  FOR 'SAVE OFF', THE FLAG   * 00091017
*       WHICH INDICATES THAT DATA IS BEING CAPTURED IS TURNED OFF.    * 00092017
*       'SAVE ON' WILL TURN THE FLAG BACK ON.  THE CAPTURE DATASET    * 00093017
*       IS CLOSED AND DEALLOCATED WHEN THE USER LOGS OFF.             * 00094017
*                                                                     * 00097017
*     DRIVER - XTASAVE IS CALLED BT XTAPRRX AND XTASRRX VIA BAL(R).   * 00100017
*                                                                     * 00110000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTASAVE.              * 00120000
*                                                                     * 00130000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00140000
*       OF THE EPILOGUE MACRO.                                        * 00150000
*                                                                     * 00160000
*     REGISTERS ON ENTRY -                                            * 00170000
*       BEFORE PROLOGUE:                                              * 00180000
*         R0:  LENGTH OF DATA                                         * 00190017
*         R1:  POINTER TO COMMAND                                     * 00200000
*         R2-8: UNPREDICTABLE                                         * 00210000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00220000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00230000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00240000
*         R12: ADDRESS OF XTAPRRX ENTRY POINT                         * 00250000
*         R13: ADDRESS OF XTAPRRX'S SAVEAREA                          * 00260000
*         R14: RETURN ADDRESS                                         * 00270000
*         R15: ENTRY ADDRESS                                          * 00280000
*       AFTER PROLOGUE:                                               * 00290000
*         R0:  UNPREDICTABLE                                          * 00300000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00310000
*         R2-6: UNPREDICTABLE                                         * 00320000
*         R7:  POINTER TO COMMAND                                     * 00330000
*         R8:  UNPREDICTABLE                                          * 00340000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00350000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00360000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00370000
*         R12: ENTRY ADDRESS                                          * 00380000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00390000
*         R14: RETURN ADDRESS                                         * 00400000
*         R15: ENTRY ADDRESS                                          * 00410000
*                                                                     * 00420000
*     MACROS USED -                                                   * 00430000
*       IBM MACROS:                                                   * 00440000
*         FREEMAIN, GETMAIN, OPEN, CLOSE                              * 00450000
*       NON-IBM MACROS:                                               * 00460000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00470000
*                                                                     * 00480000
*     COPY MEMBERS -                                                  * 00490000
*       XTACMAP, XTASMAP                                              * 00500000
*                                                                     * 00510000
*     INPUT -                                                         * 00520000
*       THE COMMAND BUFFER AND THE PRIMARY RPL.                       * 00530000
*                                                                     * 00540000
*     OUTPUT -                                                        * 00550000
*       THE CAPTURE DATASET.                                          * 00560000
*                                                                     * 00570000
*     ABENDS -                                                        * 00580000
*       NO ABENDS ARE ISSUED BY THIS MODULE.                          * 00590000
*                                                                     * 00600000
*     MESSAGES ISSUED -                                               * 00610000
*       XTA2201  .                                                    * 00620000
*                                                                     * 00710000
*     RETURN CODES -                                                  * 00720000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00730000
*                                                                     * 00740000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00750000
XTASAVE  PROLOGUE SUBR=SAVE                                             00760000
         EJECT                                                          00770000
**                                                                      00780000
*                                                                       00790000
    PHASE  22.1 - IF A STOP REQUEST --> 22.4                            00800000
*                                                                       00810000
**                                                                      00820000
         SPACE 1                                                        00821000
         LA    R1,NOPND            THIS COMMAND REQUIRES AN OPERAND,    00821100
         CLI   SS#WORK2,X'03'        SO WE FIRST ENSURE THAT THE USER   00822000
         BL    PH22#6                SUPPLIED ONE.                      00823015
         SPACE 1                                                        00824000
         LA    R3,SS#WORK2+3       NEXT, POINT PAST THE COMMAND TO THE  00830000
         SLR   R4,R4                 OPERAND.                           00840000
         IC    R4,0(R3)                                                 00850000
         LA    R3,1(R3,R4)                                              00860000
         CLC   0(4,R3),OFF         FOR 'OFF', GO TURN OFF THE CAPTURE   00870021
         BE    PH22#4                INDICATOR.                         00880017
         SPACE 1                                                        00881000
         CLC   0(3,R3),AS          FOR 'AS', ALLOCATE AND OPEN THE 'AS' 00890021
         BE    PH22#2                CAPTURE DATASET.                   00891000
         SPACE 1                                                        00891100
         CLC   0(3,R3),ON          FOR 'ON', GO TURN THE CAPTURE FLAG   00891221
         BE    PH22#5                BACK ON.                           00891317
         SPACE 1                                                        00891415
         LA    R1,INVSYN           ANYTHING ELSE IS INVALID.            00892000
         B     PH22#6                                                   00893015
         EJECT                                                          00900000
**                                                                      00910000
*                                                                       00920000
    PHASE  22.2 - VALIDATE THE CAPTURE DATASET QUALIFIER                00930000
*                                                                       00940000
**                                                                      00950000
         SPACE 1                                                        00951020
         LA    R1,PROGRESS         BEFORE PROCESSING THE 'SAVE AS'      00952025
         TM    SS#FLAG4,SS#OPENG     COMMAND, ENSURE THAT A 'SAVE AS'   00953025
         BO    PH22#6                ISN'T ALREADY IN PROGRESS...       00954025
         SPACE 1                                                        00960000
         LA    R1,OPEN             ...AND THAT A CAPTURE DATASET HASN'T 00960120
         TM    SS#FLAG4,SS#CAPDS     ALREADY BEEN ALLOCATED.            00960220
         BO    PH22#6                                                   00960315
         SPACE 1                                                        00960804
         LA    R1,NEEDDSN          THEN WE ENSURE THAT A NAME WAS       00960920
         CLI   SS#WORK2,X'05'        SUPPLIED WITH THE REQUEST.         00961023
         BL    PH22#6                                                   00962015
         SPACE 1                                                        00963000
         LA    R1,BADNAME                                               00964023
         BAL   R6,VALIDATE                                              00992023
         MVC   SS#TSOID,BLANKS                                          00992124
         EX    R4,MVC@ID           -- MVC@ID MVC SS#TSOID(0),1(R3) --   00992423
         BAL   R6,VALIDATE                                              00992623
         MVC   SS#CDSN,BLANKS                                           00992724
         EX    R4,MVC@QUAL         -- MVC@QUAL MVC SS#CDSN(0),1(R3) --  00992823
         B     PH22#3                                                   00992926
         SPACE 1                                                        00993026
VALIDATE EQU   *                                                        00993123
         SLR   R4,R4               POINT TO THE NEXT WORD.              00994023
         IC    R4,0(R3)                                                 00995023
         LA    R3,1(R3,R4)                                              00996023
         CLI   0(R3),X'08'         VALIDATE THE QUALIFIER (BY MAKING    01000000
         BH    PH22#6                SURE THAT IT ISN'T LONGER THAN     01000115
         CLI   1(R3),C'0'            EIGHT CHARACTERS; THAT IT BEGINS   01000308
         BNL   PH22#6                WITH AN ALPHABETIC OR NATIONAL     01000515
         SLR   R4,R4                 CHARACTER; AND THAT THE REMAINING  01000611
         IC    R4,0(R3)              CHARACTERS ARE ALPHABETIC,         01000711
         BCTR  R4,0                  NATIONAL, OR NUMERIC).             01000911
         EX    R4,TRT@A@1          -- TR@A@1 TRT 1(0,R3),NONA@1 --      01001017
         LA    R1,BADNAME                                               01001126
         BNZ   PH22#6                                                   01002015
         BR    R6                                                       01003023
         EJECT                                                          01680000
**                                                                      01690000
*                                                                       01700000
    PHASE  22.3 - ATTACH THE DATA CAPTURE TASK.                         01710020
*                                                                       01720000
**                                                                      01730000
         SPACE 1                                                        01750000
         OI    SS#FLAG4,SS#OPENG   SHOW A 'SAVE AS' IS IN PROGRESS.     01750125
         GETMAIN RC,LV=8           GET STORAGE FOR PARAMETER LIST,      01750317
         STM   R10,R11,0(R1)         AND PUT THE PARAMETERS THERE.      01750417
         L     R8,CS#ACPTX                                              01750519
         ATTACH EP=XTACPTT,ETXR=(R8)    ATTACH THE CAPTURE TASK.        01750619
         LA    R1,OPENED           REFLECT THE STATUS OF THE ATTACH     01750717
         LTR   R15,R15               BACK TO THE USER.                  01750817
         BZ    PH22#6                                                   01750915
         LA    R1,OPENERR                                               01751003
         B     PH22#6                                                   01751115
         EJECT                                                          01751200
**                                                                      01752000
*                                                                       01753000
    PHASE  22.4 - TURN OFF THE DATA CAPTURE FLAG                        01754015
*                                                                       01755000
**                                                                      01756000
         SPACE 1                                                        01757000
         LA    R1,NOSAVE           FIRST VERIFY THAT DATA CAPTURE       01757117
         TM    SS#FLAG4,SS#SAVON     IS CURRENTLY IN EFFECT; THEN, IF   01757217
         BZ    PH22#6                THAT IS TRUE, RESET THE CAPTURE    01757317
         NI    SS#FLAG4,X'FF'-SS#SAVON  FLAG AND INDICATE TO THE USER   01757417
         LA    R1,SAVEOFF            THAT DATA IS NO LONGER BEING       01758017
         B     PH22#6                CAPTURED.                          01759017
         EJECT                                                          01760000
**                                                                      01770000
*                                                                       01771000
    PHASE  22.5 - TURN THE DATA CAPTURE FLAG BACK ON                    01772017
*                                                                       01773000
**                                                                      01774000
         SPACE 1                                                        01775000
         LA    R1,NOAS             VERIFY THAT A CAPTURE DATASET HAS    01775117
         TM    SS#FLAG4,SS#CAPDS     PREVIOUSLY BEEN ALLOCATED AND      01775217
         BZ    PH22#6                OPENED; THEN TURN ON THE CAPTURE   01775317
         OI    SS#FLAG4,SS#SAVON     FLAG AND TELL THE USER WE ARE ONCE 01775417
         LA    R1,CAPON              AGAIN CAPTURING DATA.              01775517
         EJECT                                                          01776015
**                                                                      01777015
*                                                                       01778015
    PHASE  22.6 - WRITE MESSAGE TO USER                                 01779015
*                                                                       01779115
**                                                                      01779215
         SPACE 1                                                        01779315
         L     R15,CS#APSMR        PSM ROUTINE ADDRESS                  01780000
         BALR  R14,R15             SEND THE MESSAGE TO PRIMARY          01790000
         EJECT                                                          01800000
**                                                                      01810000
*                                                                       01820000
    PHASE  22.99 - EXIT                                                 01830000
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
*        EXECUTE OBJECTS                                              * 02300000
*                                                                     * 02310000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02320000
         SPACE 1                                                        02330000
TRT@A@1  TRT   1(0,R3),NONA@1                                           02340012
MVC@ID   MVC   SS#TSOID(0),1(R3)                                        02350023
MVC@QUAL MVC   SS#CDSN(0),1(R3)                                         02360023
         EJECT                                                          02370000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02480000
*                                                                     * 02490000
*        DATA OBJECTS                                                 * 02500001
*                                                                     * 02510000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02520000
         SPACE 1                                                        02530000
BLANKS   DC    CL10' '                                                  02530124
ON       DC    X'02',C'ON'                                              02530215
OFF      DC    X'03',C'OFF'                                             02530315
AS       DC    X'02',C'AS'                                              02530406
         EJECT                                                          02531001
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02532001
*                                                                     * 02533001
*        MESSAGES USED IN THIS ROUTINE                                * 02534001
*                                                                     * 02535001
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02536001
         SPACE 1                                                        02537001
NOPND    DC    YL1(SYSMSG)           MESSAGE FLAGS                      02540000
         DC    YL1(L'XTA2201T)     LENGTH OF MESSAGE                    02550000
XTA2201T DC    C'XTA2201  THIS COMMAND REQUIRES AN OPERAND.'            02560000
         SPACE                                                          02561016
INVSYN   DC    YL1(SYSMSG)           MESSAGE FLAGS                      02562016
         DC    YL1(L'XTA2201U)     LENGTH OF MESSAGE                    02563016
XTA2201U DC    C'XTA2201  THIS OPERAND IS INVALID.'                     02564016
         SPACE                                                          02570000
OPEN     DC    YL1(SYSMSG)           MESSAGE FLAGS                      02580004
         DC    YL1(L'XTA2202T)     LENGTH OF MESSAGE                    02590000
XTA2202T DC    C'XTA2202  DATA IS ALREADY BEING SAVED.'                 02600004
         SPACE                                                          02601004
PROGRESS DC    YL1(SYSMSG)           MESSAGE FLAGS                      02602004
         DC    YL1(L'XTA2202U)     LENGTH OF MESSAGE                    02603004
XTA2202U DC    C'XTA2202  A SAVE COMMAND IS ALREADY IN PROGRESS.'       02604004
         SPACE                                                          02610000
NEEDDSN  DC    YL1(SYSMSG)           MESSAGE FLAGS                      02620000
         DC    YL1(L'XTA2202V)     LENGTH OF MESSAGE                    02630016
XTA2202V DC    C'XTA2202  A TSOID AND QUALIFIER IS REQUIRED.'           02640023
         SPACE                                                          02660000
BADNAME  DC    YL1(SYSMSG)                  MESSAGE FLAGS               02670000
         DC    YL1(L'XTA2202W)     LENGTH OF MESSAGE                    02680016
XTA2202W DC    C'XTA2202  ONE OR BOTH OF THESE NAMES IS INVALID.'       02690023
         SPACE                                                          02700000
OPENED   DC    YL1(SYSMSG+CLEARIPT-AALARM)                              02710017
         DC    YL1(L'XTA2203T)     LENGTH OF MESSAGE                    02720016
XTA2203T DC    C'XTA2203  DATA CAPTURE HAS BEGUN.'                      02730017
         SPACE                                                          02731003
OPENERR  DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      02732005
         DC    YL1(L'XTA2203U)     LENGTH OF MESSAGE                    02733016
XTA2203U DC    C'XTA2203  CAPTURE DATASET COULD NOT BE ALLOCATED.'      02734016
         SPACE                                                          02735011
NOSAVE   DC    YL1(SYSMSG+CLEARIPT)  MESSAGE FLAGS                      02736011
         DC    YL1(L'XTA2204T)     LENGTH OF MESSAGE                    02737016
XTA2204T DC    C'XTA2204  DATA IS NOT BEING SAVED.'                     02738016
         SPACE                                                          02740000
SAVEOFF  DC    YL1(SYSMSG+CLEARIPT)                                     02750015
         DC    YL1(L'XTA2205T)     LENGTH OF MESSAGE                    02760016
XTA2205T DC    C'XTA2205  DATA CAPTURE IS NOW INACTIVE.'                02770016
         SPACE                                                          02780015
NOAS     DC    YL1(SYSMSG+CLEARIPT)                                     02790015
         DC    YL1(L'XTA2206T)     LENGTH OF MESSAGE                    02800016
XTA2206T DC    C'XTA2206  A ''SAVE AS'' COMMAND MUST BE ISSUED FIRST.'  02810016
         SPACE                                                          02811015
CAPON    DC    YL1(SYSMSG+CLEARIPT)                                     02812015
         DC    YL1(L'XTA2206U)     LENGTH OF MESSAGE                    02813016
XTA2206U DC    C'XTA2206  DATA CAPTURE IS REACTIVATED.'                 02814016
         EJECT                                                          02820000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02821000
*                                                                     * 02822000
*        TRANSLATE TABLES                                             * 02823000
*                                                                     * 02824000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02825000
         SPACE 1                                                        02826000
NONA@1   EQU   *                                                        02847000
         DC    256XL1'FF'                                               02848000
         ORG   NONA@1+C'$'                                              02849000
         DC    X'00'                                                    02849100
         ORG   NONA@1+C'#'                                              02849200
         DC    X'00'                                                    02849300
         ORG   NONA@1+C'@'                                              02849400
         DC    X'00'                                                    02849500
         ORG   NONA@1+C'A'                                              02849600
         DC    9X'00'                                                   02849700
         ORG   NONA@1+C'J'                                              02849800
         DC    9X'00'                                                   02849900
         ORG   NONA@1+C'S'                                              02850000
         DC    8X'00'                                                   02851000
         ORG   NONA@1+C'0'                                              02852000
         DC    10X'00'                                                  02853000
         END                                                            02860000
         SPACE 1                                                        00001020
*********************************************************************** 00010017
*                                                                     * 00011017
* NOTES:                                                              * 00012017
*     1. TEXT IS LIMITED TO CONSIDERABLY LESS THAN 256 BYTES, DUE     * 00013020
*        TO THE OVERHEAD OF SCREEN CONTROL.                           * 00014020
*     2. NOTE THAT EACH OF THE HELP PANELS ENDS WITH A PERIOD. THIS   * 00015020
*        IS NOT REQUIRED, BUT IS SIMPLY A VISUAL AID TO HELP          * 00015120
*        VERIFY THAT ALL OF THE HELP TEXT IS BEING DISPLAYED.         * 00016020
*                                                                     * 00017017
*********************************************************************** 00020017
         SPACE 1                                                        00030020
XHLPHLP  DC    YL1(ECHO),YL1(LXHLPHLP)                                  00750714
  DC  X'081010'                                                         00750823
  DC  C'> TARA HELP:'                                                   00750923
  DC  X'0810'                                                           00751023
  DC  C'>'                                                              00751123
  DC  X'0810'                                                           00751223
  DC  C'> Enter ''HELP COMMANDS'','                                     00751323
  DC  X'0810'                                                           00751423
  DC  C'>    or ''HELP commandname'','                                  00751523
  DC  X'0810'                                                           00751623
  DC  C'>    or ''HELP HOSTS''.'                                        00751723
  DC  X'081010'                                                         00751823
LXHLPHLP EQU   *-XHLPHLP-2                                              00752101
         SPACE 2                                                        00752202
XHLPCMD  DC    YL1(ECHO),YL1(LXHLPCMD)                                  00753014
  DC  X'081010'                                                         00753123
  DC  C'> TARA HELP:'                                                   00755023
  DC  X'0810'                                                           00755123
  DC  C'>'                                                              00755223
  DC  X'0810'                                                           00755323
  DC  C'> Commands: ALARM BYE CALL CAPTURE DELIMIT DIAL DROP'           00790023
  DC  X'0810'                                                           00791023
  DC  C'>  ERASE HANGUP LOGOFF NAME OFF SAVE SEPCHAR WRAP.'             00792023
  DC  X'081010'                                                         00811023
LXHLPCMD EQU   *-XHLPCMD-2                                              00820002
         SPACE 2                                                        00821022
XHLPALM  DC    YL1(ECHO),YL1(LXHLPALM)                                  00822022
  DC  X'081010'                                                         00823023
  DC  C'> TARA HELP:'                                                   00824023
  DC  X'0810'                                                           00825023
  DC  C'>'                                                              00826023
  DC  X'0810'                                                           00827023
  DC  C'> ALARM OFF  stops your terminal''s audible alarm'              00828023
  DC  X'0810'                                                           00829023
  DC  C'>  from being sounded.  ALARM ON restores it.'                  00829123
  DC  X'081010'                                                         00829223
LXHLPALM EQU   *-XHLPALM-2                                              00829322
         SPACE 2                                                        00829422
XHLPBYE  DC    YL1(ECHO),YL1(LXHLPBYE)                                  00829522
  DC  X'081010'                                                         00829623
  DC  C'> TARA HELP:'                                                   00829723
  DC  X'0810'                                                           00829823
  DC  C'>'                                                              00829923
  DC  X'0810'                                                           00830023
  DC  C'> BYE, LOGOFF or OFF disconnects you from TARA and'             00830123
  DC  X'0810'                                                           00830223
  DC  C'>  ends any remote session you may have had.'                   00830323
  DC  X'081010'                                                         00830423
LXHLPBYE EQU   *-XHLPBYE-2                                              00830522
         SPACE 2                                                        00831012
XHLPHST  DC    YL1(ECHO),YL1(LXHLPHST)                                  00840014
  DC  X'081010'                                                         00841023
  DC  C'> TARA HELP:'                                                   00860023
  DC  X'0810'                                                           00861023
  DC  C'>'                                                              00862023
  DC  X'0810'                                                           00863023
  DC  C'> Hosts: COMPUSERVE DOWJONES SOURCE TELEMAIL USATODAY.'         00880023
  DC  X'081010'                                                         00930023
LXHLPHST EQU   *-XHLPHST-2                                              00950012