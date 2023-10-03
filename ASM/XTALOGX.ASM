XTALOGX  TITLE 'TARA LOGON EXIT (2.0)'                                  00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTALOGX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTALOGX ACQUIRES AND INITIALIZES       * 00060002
*       SESSION STORAGE, CHECKS WHETHER THE REQUESTING DEVICE IS      * 00070002
*       SUPPORTED, AND THEN EITHER ISSUES AN OPNDST (IF IT IS), OR    * 00080002
*       A CLSDST (IF IT ISN'T).  IN THE LATTER CASE, AS ALWAYS,       * 00090002
*       SESSION STORAGE IS FREED BY THE CLSDST EXIT.                  * 00091002
*                                                                     * 00092002
*     DRIVER - XTALOGX IS DRIVEN BY THE VTAM LOGON EXIT               * 00100000
*                                                                     * 00110000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTALOGX.              * 00120000
*                                                                     * 00130000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00140000
*       OF THE EPILOGUE MACRO.                                        * 00150000
*                                                                     * 00160000
*     REGISTERS ON ENTRY -                                            * 00170000
*       BEFORE PROLOGUE:                                              * 00180000
*         R0:  UNPREDICTABLE                                          * 00190000
*         R1:  POINTER TO PARAMETER LIST (DESCRIBED BELOW)            * 00200000
*         R2-R13:  UNPREDICTABLE                                      * 00210000
*         R14: RETURN ADDRESS                                         * 00220000
*         R15: ENTRY ADDRESS                                          * 00230000
*       AFTER PROLOGUE:                                               * 00240000
*         R0:  UNPREDICTABLE                                          * 00250000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00260000
*         R2-R8: UNPREDICTABLE                                        * 00270000
*         R9:  POINTER TO PARAMETER LIST (DESCRIBED BELOW)            * 00280000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00290000
*         R11: UNPREDICTABLE                                          * 00300000
*         R12: ENTRY ADDRESS                                          * 00310000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00320000
*         R14: RETURN ADDRESS                                         * 00330000
*         R15: RETURN CODE FROM GETMAIN                               * 00340002
*                                                                     * 00350000
*     MACROS USED -                                                   * 00360000
*       IBM MACROS:                                                   * 00370000
*         FREEMAIN, GETMAIN, GENCB, INQUIRE, OPNDST,                  * 00380001
*         CLSDST, ISTDBIND, ISTDVCHR                                  * 00390000
*       NON-IBM MACROS:                                               * 00400000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00410000
*                                                                     * 00420000
*     COPY MEMBERS:                                                   * 00430000
*       XTACMAP                                                       * 00440000
*                                                                     * 00450000
*     INPUT:                                                          * 00460000
*       R1 POINTS TO THE FOLLOWING PARAMETER LIST:                    * 00470000
*         +0   ACB ADDRESS                                            * 00480000
*         +4   ADDRESS OF SLU NAME                                    * 00490000
*         +8   ZERO (USERFLD IF SIMLOGON WAS USED)                    * 00500000
*         +12  LENGTH OF LOGON MESSAGE                                * 00510000
*         +16  ADDRESS OF READ-ONLY RPL                               * 00520000
*         +20  CID                                                    * 00530000
*                                                                     * 00540000
*     OUTPUT:                                                         * 00550000
*       A SESSION STORAGE AREA IS BUILT.                              * 00560002
*                                                                     * 00570000
*     ABENDS:                                                         * 00580000
*       NO USER ABENDS ARE ISSUED.                                    * 00590002
*                                                                     * 00600000
*     MESSAGES ISSUED:                                                * 00610000
*       XTA0201 LOGON FAILED - UNABLE TO GETMAIN SESSION STORAGE.     * 00620000
*       XTA0207 OPNDST ACCEPT FOR PRIMARY LOGON FAILED.               * 00630000
*                                                                     * 00640000
*     RETURN CODES:                                                   * 00650000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00660000
*                                                                     * 00661007
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00680000
XTALOGX  PROLOGUE EXIT=LOGON                                            00690000
         EJECT                                                          00700000
**                                                                      00710000
*                                                                       00720000
    PHASE  2.1 - GETMAIN SESSION STORAGE                                00730000
*                                                                       00740000
**                                                                      00750000
         SPACE 1                                                        00751002
         L     R5,=A(LXTASMAP)     SPECIFY SESSION STORAGE AREA SIZE.   00760006
         GETMAIN RU,LV=(R5)                                             00770000
         LR    R11,R1              NOW THAT WE HAVE SOME SESSION        00780000
         USING XTASMAP,R11           STORAGE, GET ADDRESSABILITY TO IT. 00790000
         LTR   R15,R15             TEST FOR SUCCESSFUL GETMAIN.         00800000
         BZ    PH2#2               IF GETMAIN WENT OK, CONTINUE.        00810000
         WTO   'XTA0201 LOGON FAILED - UNABLE TO GETMAIN SESSION STORAG-00820000
               E.',ROUTCDE=(2,11),DESC=(6)                              00830002
         B     PH2#9                                                    00840000
         EJECT                                                          00850000
**                                                                      00860000
*                                                                       00870000
    PHASE  2.2 - INITIALIZE SESSION STORAGE                             00880000
*                                                                       00890000
**                                                                      00900000
         SPACE 1                                                        00910000
*  FIRST WE INITIALIZE THE SDB . . .                                    00911002
         SPACE 1                                                        00920002
         L     R4,4(R9)            POINT TO NODE NAME.                  00940000
         MVC   SS#PNODE,0(R4)      MOVE SLU NAME INTO SESSION STORAGE.  00950000
         L     R4,20(R9)           GET THE CID.                         00960000
         ST    R4,SS#PCID          SAVE THAT IN SS, TOO.                00970000
         ST    R5,SS#LNGTH         INDICATE LENGTH OF AREA.             00980000
         LA    R3,0                INITIALIZE BUFFER POINTER TO ZERO.   00990000
         ST    R3,SS#BUFPT                                              01000000
         XC    SS#CSP,SS#CSP       ENSURE CSP IS ZEROED.                01010000
         XC    SS#STATS,SS#STATS   ZERO THE SESSION STATISTICS.         01020000
         XC    SS#FLAGS,SS#FLAGS   RESET ALL FLAGS.                     01030000
         MVI   SS#SEPCH,C'-'       SET SEP LINE TO DASHES.              01040000
         ST    R11,SS#BASE         !!BASE. DEFAULTS TO SESSION.         01050000
         EJECT                                                          01060000
*********************************************************************** 01070000
*                                                                     * 01080000
*   LET'S TAKE A MINUTE TO LOOK AT THE ORGANIZATION OF THE SDB QUEUE: * 01090000
*   (SDB = SESSION DATA BLOCK = SESSION STORAGE AREA)                 * 01100002
*                                                                     * 01110000
*   THE QUEUE ANCHOR BLOCK (QAB) LIVES IN COMMON STORAGE, AND GETS    * 01120000
*   US STARTED ON THE QUEUE:                                          * 01130000
*                                                                     * 01140000
*                 +---------------------------+                       * 01150000
*                 |   -> FIRST SDB ON QUEUE   |                       * 01160000
*                 +---------------------------+                       * 01170000
*                 |   -> LAST SDB ON QUEUE    |                       * 01180000
*                 +---------------------------+                       * 01190000
*                                                                     * 01200000
*   EACH SDB BEGINS WITH NEXT/PREVIOUS POINTERS FOR OTHER SDBS        * 01210000
*   IN THE QUEUE:                                                     * 01220000
*                                                                     * 01230000
*                 +---------------------------+                       * 01240000
*                 | -> NEXT SDB OR 0 IF LAST  |                       * 01250000
*                 +---------------------------+                       * 01260000
*                 | -> PREV SDB OR 0 IF FIRST |                       * 01270000
*                 +---------------------------+                       * 01280000
*                 |           ETC.            |                       * 01290000
*                 /                           /                       * 01300000
*                                                                     * 01310000
*   SDB'S ARE CHAINED TOGETHER IN A QUEUE LIKE THIS:                  * 01320000
*                                                                     * 01330000
* +----------+      +---------+      +---------+      +---------+     * 01340002
* | -> FIRST | ---> | -> NEXT | ---> | -> NEXT | ---> |    0    |<-+  * 01350002
* +----------+      +---------+      +---------+      +---------+  |  * 01360002
* | -> LAST  | -+   |    0    | <--- | -> PREV | <--- | -> PREV |  |  * 01370002
* +----------+  |   +---------+      +---------+      +---------+  |  * 01380002
*               |   |         |      |         |      |         |  |  * 01390002
*               |   /         /      /         /      /         /  |  * 01400002
*               |                                                  |  * 01410002
*               +--------------------------------------------------+  * 01420002
*                                                                     * 01430002
*   NOTE THAT THE 'NEXT' POINTER OF THE LAST SDB IS ZERO, AND THAT    * 01440000
*   THE 'PREVIOUS' POINTER OF THE FIRST SDB IS ZERO. IF THERE IS ONLY * 01450000
*   ONE SDB ON THE QUEUE, *BOTH* OF THESE POINTERS WILL BE ZERO.      * 01460000
*   FURTHER, IF THERE ARE *NO* SDB'S AT ALL, THE 'FIRST' AND 'LAST'   * 01470000
*   POINTERS IN THE QAB WILL BOTH BE ZERO.                            * 01480000
*                                                                     * 01490000
*********************************************************************** 01500000
         SPACE 1                                                        01510000
*   . . . AND THEN WE ADD IT TO THE SDB QUEUE.                          01520002
         SPACE 1                                                        01530000
         L     R5,CS#SSLST         POINT TO LAST SDB CREATED.           01540000
         ST    R5,SS#PREV          POINT OUR SDB TO PREVIOUS SDB.       01550000
         LTR   R5,R5               ARE WE FIRST IN THE Q?               01560000
         BNZ   ADDROK              IF NOT, KEEP PREVIOUS SDB ADDRESS.   01570000
         LA    R5,CS#SSQAB         ELSE, POINT TO QAB.                  01580000
         PUSH  USING               SAVE PRESENT ADDRESSABILITIES.       01590000
         DROP  R11                                                      01600000
         USING XTASMAP,R5          POINT TO PREVIOUS SDB OR QAB.        01610000
ADDROK   ST    R11,SS#NEXT         POINT IT TO OUR SDB.                 01620000
         POP   USING               RESTORE ADDRESSABILITY TO OUR SDB.   01630000
         ST    R11,CS#SSLST        POINT COMMON TO OURS AS LAST.        01640000
         SLR   R5,R5               ZERO R5, WE ARE LAST IN Q.           01650000
         ST    R5,SS#NEXT          ENSURE 'NEXT' POINTER IS ZERO.       01660000
         EJECT                                                          01670000
**                                                                      01680000
*                                                                       01690000
    PHASE  2.3 - GENCB 1 NIB AND 4 RPL'S                                01700000
*                                                                       01710000
**                                                                      01720000
         LA    R5,SS#CBS           POINT TO WHERE WE WANT CB'S GEN'D,   01730000
         LA    R7,L'SS#CBS           AND INDICATE HOW BIG THAT AREA IS. 01740018
         LA    R3,CS#NIBEX                                              01741018
         GENCB AM=VTAM,            FIRST THING SESSION-STORAGE         +01750000
               BLK=NIB,              CONTROL BLOCK AREA IS A NIB.      +01760000
               WAREA=(R5),                                             +01770000
               LENGTH=(R7),                                            +01780018
               NAME=(*,SS#PNODE),                                      +01790000
               MODE=RECORD,                                            +01800000
               EXLST=(R3),                                             +01801018
               PROC=(NDFASYX,SYSRESP),                                 +01810016
               RESPLIM=2,                                              +01811005
               SDT=SYSTEM,                                             +01820000
               USERFLD=(R11)                                            01830000
         SPACE 1                                                        01840000
         ST    R1,SS#ANIB          SAVE THE ADDRESS OF THE NIB.         01850000
         AR    R5,R0               POINT TO NEXT FREE AREA, AND UPDATE  01860000
         SR    R7,R0                 THE AVAILABLE AREA LENGTH.         01870000
         LR    R6,R1               POINT TO JUST-CREATED NIB.           01880000
         LA    R4,CS#ACB           POINT TO OUR ACB.                    01890000
         GENCB AM=VTAM,            AND MAKE OURSELVES SOME RPLS.       +01900000
               BLK=RPL,                                                +01910000
               WAREA=(R5),                                             +01920000
               LENGTH=(R7),                                            +01930000
               COPIES=4,                                               +01940000
               ACB=(R4),                                               +01950000
               OPTCD=(TRUNC,ACCEPT,RELEASE,SPEC,CS),                   +01960000
               RESPOND=(NEX,FME,NRRN),                                 +01970000
               POST=RESP,                                              +01980000
               STYPE=(REQ),                                            +01990000
               RTYPE=(DFSYN,NDFASY,NRESP),                             +02000000
               CONTROL=DATA,                                           +02010000
               CHAIN=ONLY,                                             +02020000
               NIB=(R6),                                               +02030000
               BRACKET=(NBB,EB)                                         02040000
         SPACE 1                                                        02050000
         ST    R1,SS#APRPL         SAVE THE ADDRESS OF THE FIRST RPL.   02060000
         LR    R1,R0               GET TOTAL LENGTH OF RPLS CREATED.    02070000
         SLR   R0,R0               CLEAR HI WORD OF DIVIDEND.           02080000
         D     R0,=F'4'            DIVIDE BY # OF RPLS CREATED.         02090000
         LR    R2,R0               CAN'T 'USE' R0!!!                    02100000
         USING IFGRPL,R2                                                02110000
         L     R2,SS#APRPL         GET ADDRESS OF FIRST RPL.            02120000
         ST    R11,RPLUSFLD        INITIALIZE USERFLD IN RPL.           02130000
         AR    R2,R1               ADD LENGTH FOR ADDRESS OF RPL #2.    02140000
         ST    R2,SS#AERPL         SAVE THAT ADDRESS.                   02150000
         ST    R11,RPLUSFLD        INITIALIZE USERFLD IN RPL.           02160000
         AR    R2,R1               ADD LENGTH AGAIN FOR THIRD RPL ADDR  02170000
         ST    R2,SS#ASRPL         NOW SAVE THAT ONE...                 02180000
         ST    R11,RPLUSFLD        INITIALIZE USERFLD IN RPL.           02190000
         AR    R2,R1               ADD LENGTH AGAIN FOR LAST RPL ADDR   02200000
         ST    R2,SS#ACRPL         AND SAVE THAT...WE'RE DONE!          02210000
         ST    R11,RPLUSFLD        INITIALIZE USERFLD IN RPL.           02220000
         DROP  R2                                                       02230000
         EJECT                                                          02240000
**                                                                      02250000
*                                                                       02260000
    PHASE  2.4 - ISSUE INQUIRE SESSPARM FOR BIND IMAGE                  02270000
*                                                                       02280000
**                                                                      02290000
         SPACE 1                                                        02291002
         L     R7,SS#AERPL         USE ECHO RPL FOR INQUIRE.            02300000
         INQUIRE RPL=(R7),         THIS INQUIRE WILL GIVE US A COPY    +02310000
               OPTCD=(SYN,SESSPARM),                                   +02320000
               AREA=SS#BIND,                                           +02330000
               AREALEN=L'SS#BIND                                        02340000
         EJECT                                                          02350000
**                                                                      02360000
*                                                                       02370000
    PHASE  2.5 - ISSUE INQUIRE DEVCHAR FOR DEVICE CHARACTERISTICS       02380000
*                                                                       02390000
**                                                                      02400000
         SPACE 1                                                        02401002
         INQUIRE RPL=(R7),         REGS 5-7 SHOULD STILL BE ALL SET    +02410000
               OPTCD=(SYN,DEVCHAR),  DEVICE CHARACTERISTICS OF THE     +02420000
               AREA=SS#DVCHR,        USERS TERMINAL.                   +02430000
               AREALEN=L'SS#DVCHR                                       02440000
         SPACE 1                                                        02450000
         L     R6,CS#AEKOX         POINT TO ECHO SEND RPL EXIT          02460000
         MODCB AM=VTAM,            MAKE OUR ECHO RPL ASY AGAIN, AND    +02470000
               RPL=(R7),             SET THE EXIT ROUTINE.             +02480000
               EXIT=(R6),                                              +02490000
               OPTCD=(ASY)                                              02500000
         EJECT                                                          02510000
**                                                                      02520000
*                                                                       02530000
    PHASE  2.6 - IF BIND NOT ACCEPTABLE --> 2.9                         02540002
*                                                                       02550000
**                                                                      02560000
         SPACE 1                                                        02561002
         LA    R7,SS#BIND          POINT TO THE BIND IMAGE, AND MAP     02570000
         USING ISTDBIND,R7           IT WITH A DSECT.                   02580000
         LA    R8,SS#DVCHR         POINT AT DEVICE CHARACTERISTICS AND  02590000
         USING ISTDVCHR,R8           ADDRESS THAT, TOO.                 02600000
         SPACE 1                                                        02610000
*  FIRST, VERIFY THAT THE DEVICE TYPE IS ACCEPTABLE                     02620000
         SPACE 1                                                        02630000
         CLI   DEVTCODE,DEV3277    ODS DEVICES ARE OK, AS LONG AS THEY  02640000
         BE    CHKMODEL              ARE MODEL 2'S.                     02650000
         CLI   DEVTCODE,DEV3275                                         02660000
         BE    CHKMODEL                                                 02670000
         CLI   DEVTCODE,DEVLU      IF USER HAS NEITHER ODS NOR NDS      02680000
         BNE   PH2#9                 3270, SEND HIM TO SIBERIA.         02690000
         SPACE 1                                                        02700000
*  CHECK THE BIND PARAMETERS THAT WE REQUIRE                            02710000
         SPACE 1                                                        02720000
         CLC   =X'0202',BINFM      ALLOW SESSIONS ONLY TO LU'S WITH     02730000
         BE    CHKBIND               FM/TS PROFILES OF 02 OR 03.        02740000
         CLC   =X'0303',BINFM                                           02750000
         BNE   PH2#9                                                    02760000
         SPACE 1                                                        02770000
CHKBIND  EQU   *                                                        02780000
         OI    BINCMNP,BINBRAK     BRACKETS WILL BE USED, BUT NO        02781010
         NI    BINCMNP,X'FF'-BINALT  ALTERNATES CODES.                  02782010
         OI    BINPRIP,BINPSEB     WE CAN SEND EB, BUT NPSI CAN'T.      02790010
         NI    BINSECP,X'FF'-(BINSCMP+BINSSEB)                          02820010
         CLI   BINLUP,BINLUP0C     ENSURE THAT A TYPE-0 OR TYPE-2       02890000
         BE    PSERVIC               LU-LU SESSION IS BEING USED.       02900000
         CLI   BINLUP,BINLUP2C                                          02910000
         BNE   PH2#9                                                    02920000
         SPACE 1                                                        02930000
*  CHECK THE RU SIZES SPECIFIED                                         02940000
         SPACE 1                                                        02950000
         SLR   R4,R4               ZERO OUT REGISTER IN PREPARATION     02960000
         SLR   R5,R5                 FOR CALCULATION.                   02970000
         IC    R4,BINSRUSZ         GET 2'Y MAX RU SIZE FROM BIND.       02980000
         SRDL  R4,4                SHIFT EXPONENT INTO R5.              02990000
         SRL   R5,28               GET EXPONENT RIGHT-JUSTIFIED.        03000000
         SLL   R4,0(R5)            RAISE TO POWER.                      03010000
         C     R4,MAXRCVSZ         CHECK THE VALUE.                     03020000
         BNH   CHKPRUSZ                                                 03030010
         MVI   BINSRUSZ,X'C4'                                           03031010
         SPACE 1                                                        03032010
CHKPRUSZ EQU   *                                                        03033010
         SLR   R4,R4               LET'S SEE THAT AGAIN...              03040000
         SLR   R5,R5               R4:00000000  R5:00000000             03050000
         IC    R4,BINPRUSZ         R4:000000XY  R5:00000000             03060000
         SRDL  R4,4                R4:0000000X  R5:Y0000000             03070000
         SRL   R5,28               R4:0000000X  R5:0000000Y             03080000
         SLL   R4,0(R5)            R4 <- X*2**Y                         03090000
         C     R4,MINSNDSZ                                              03100000
         BNL   PSERVIC                                                  03110010
         MVI   BINPRUSZ,X'85'                                           03111010
         SPACE 1                                                        03120000
*  CHECK THE PRESENTATION SPACE SIZE                                    03130000
         SPACE 1                                                        03140000
PSERVIC  EQU   *                                                        03150000
         CLI   BINPRESZ,BINPSZ2    BYTE 24 OF THE BIND IS 0 OR 2, THEN  03160000
         BE    TERM2480              THE SCREEN SIZE IS 24 X 80 - WHICH 03170000
         CLI   BINPRESZ,BINPSZ0      IS ACCEPTABLE TO US. (0 IS USED    03180000
         BE    TERM2480              FOR LOCAL ODS DEVICES).            03190000
         TM    BINPRESZ,BINPSFX    IF SIZE NOT SPECIFIED IN ROW/COLUMN  03200000
         BNO   PH2#9                 AREA - FORGET IT.                  03210000
         SLR   R5,R5               EXTRACT THE PRESENTATION SPACE       03220000
         IC    R5,BINSALTR           DIMENSIONS FROM THE BIND AND PLACE 03230000
         ST    R5,SS#ROWS            INTO SESSION STORAGE FOR PSM.      03240000
         IC    R5,BINSALTC                                              03250000
         ST    R5,SS#COLS                                               03260000
         B     TERMOK              CONTINUE.                            03270000
         SPACE 1                                                        03280000
CHKMODEL EQU   *                                                        03290000
         CLI   DEVMCODE,DEVMOD2    FOR ODS DEVICES, VERIFY MODEL IS     03300000
         BNE   PH2#9                 2. NOTHING ELSE IS ACCEPTABLE.     03310000
         DROP  R7                  WE'RE DONE WITH BIND AND DEVCHAR.    03320000
         DROP  R8                                                       03330000
         SPACE 1                                                        03340000
TERM2480 EQU   *                   WE COME HERE WHEN THE PRESENTATION   03350000
         LA    R7,24                 SPACE DIMENSIONS ARE NOT IN THE    03360000
         ST    R7,SS#ROWS            BIND. WE SET THE DIMENSIONS FOR    03370000
         LA    R7,80                 PSM HERE.                          03380000
         ST    R7,SS#COLS                                               03390000
         SPACE 1                                                        03400000
TERMOK   EQU   *                   TAKE THE DIMENSIONS OF THE           03410003
         L     R7,SS#ROWS            PRESENTATION SPACE, AND CALCULATE  03420003
         M     R6,SS#COLS            ITS SIZE.                          03430003
         C     R7,=F'4096'         IF THE PSSIZE > 4096, THEN WE MUST   03431003
         BNH   @12BIT                USE 14/16-BIT ADDRESSING.          03432004
         OI    SS#FLAG2,SS#1416                                         03433003
         SPACE 1                                                        03434003
@12BIT   EQU   *                   SUBTRACT 4 LINES FROM PSSIZE         03435003
         L     R6,SS#COLS            TO ARRIVE AT THE SIZE OF THE DATA  03440000
         SLL   R6,2                  AREA OF THE SCREEN. THIS FIGURE IS 03450000
         SR    R7,R6                 FOR PSM'S USE.                     03460000
         ST    R7,SS#DAREA         ( ROWS X COLUMNS - (4 X COLUMNS) )   03470000
         EJECT                                                          03480000
**                                                                      03490000
*                                                                       03500000
    PHASE  2.7 - OPNDST ACCEPT,ASY,SPEC                                 03510000
*                                                                       03520000
**                                                                      03530000
         SPACE 1                                                        03531002
         L     R7,CS#AOPRX         POINT TO THE OPNDST EXIT FOR THE PRI 03540000
         L     R8,SS#APRPL         POINT TO THE RPL FOR THE PRIMARY.    03550000
         OPNDST RPL=(R8),          ACCEPT THE LOGON.                   +03560000
               EXIT=(R7),                                              +03570000
               OPTCD=(ACCEPT,ASY,SPEC)                                  03580000
         LTR   R15,R15                                                  03590000
         BZ    PH2#8                                                    03600000
         WTO   'XTA0207 OPNDST ACCEPT FOR PRIMARY LOGON FAILED.',      +03610000
               ROUTCDE=(2,11),DESC=(6)                                  03620000
         B     PH2#9                                                    03630000
         EJECT                                                          03640000
**                                                                      03650000
*                                                                       03660000
    PHASE  2.8 - LOG LOGON EVENT                                        03670000
*                                                                       03680000
**                                                                      03690000
         SPACE 1                                                        03691002
         MVC   SS#WORK1(L'XTA0208T+2),XTA0208    MOVE MSG INTO SCRATCH. 03700000
         MVC   SS#WORK1+2(L'SS#PNODE),SS#PNODE   TELL WHO IT WAS.       03710013
         LA    R1,SS#WORK1         SHOW THE LOGGER WHERE THE MSG IS.    03720000
         L     R15,CS#ALOGR        FIND OUT WHERE THE LOGGER LIVES,     03730000
         BALR  R14,R15               AND GIVE HIM A CALL.               03740000
         B     PH2#99              GIVE UP.                             03750000
         EJECT                                                          03760000
**                                                                      03770000
*                                                                       03780000
    PHASE  2.9 - CLSDST SPEC,RELEASE                                    03790000
*                                                                       03800000
**                                                                      03810000
         SPACE 1                                                        03811002
         L     R6,20(R9)           THE USER'S DEVICE IS UNACCEPTABLE.   03830000
         L     R7,CS#ACLDX         GET THE ADDRESS OF THE CLSDST EXIT.  03840000
         L     R8,SS#APRPL         POINT TO THE RPL FOR THE PRIMARY.    03850000
         CLSDST RPL=(R8),          MAKE THE USER GO AWAY.              +03860000
               ARG=(R6),                                               +03870000
               EXIT=(R7)                                                03880000
         EJECT                                                          03890000
**                                                                      03900000
*                                                                       03910000
    PHASE  2.99 - EXIT                                                  03920000
*                                                                       03930000
**                                                                      03940000
         SPACE 1                                                        03941002
         SLR   R15,R15             SET RETURN CODE TO ZERO.             03950000
         EPILOGUE                  EXIT.                                03960000
*********************************************************************** 03970000
*********************************************************************** 03980000
********                                                       ******** 03990000
********               END OF EXECUTABLE CODE                  ******** 04000000
********                                                       ******** 04010000
*********************************************************************** 04020000
*********************************************************************** 04030000
         TITLE 'DATA AREA'                                              04040000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04050000
*                                                                     * 04060000
*  MESSAGE TEMPLATE FOR LOG MESSAGE                                   * 04070000
*                                                                     * 04080000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04090000
         SPACE 2                                                        04100000
XTA0208  DC    YL1(USTATUS)                                             04110000
         DC    YL1(L'XTA0208T)                                          04120000
XTA0208T DC    C'--PLU--- LOGON'                                        04130013
         SPACE 2                                                        04140000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04150000
*                                                                     * 04160000
*  CONSTANTS TO CHECK BIND AGAINST                                    * 04170000
*                                                                     * 04180000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04190000
         SPACE 2                                                        04200000
         DS    0F                                                       04210000
MAXRCVSZ DC    F'192'                                                   04220010
MINSNDSZ DC    F'256'                                                   04230000
         TITLE 'DSECTS'                                                 04240000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04250000
*                                                                     * 04260000
*  MAP THE BIND AREA                                                  * 04270000
*                                                                     * 04280000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04290000
         SPACE 2                                                        04300000
         ISTDBIND                                                       04310000
         EJECT                                                          04320000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04330000
*                                                                     * 04340000
*  MAP THE DEVICE CHARACTERISTICS AREA                                * 04350000
*                                                                     * 04360000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04370000
         SPACE 2                                                        04380000
         ISTDVCHR                                                       04390000
         END   XTALOGX                                                  04400000