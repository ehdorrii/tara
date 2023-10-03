XTAPRRX  TITLE 'TARA PRIMARY RECEIVE RPL EXIT (5.0)'                    00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTAPRRX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTAPRRX PROCESSES INPUT FROM THE       * 00060000
*       PRIMARY SESSION (I.E. THE 3270).                              * 00070004
*                                                                     * 00080000
*     DRIVER - XTAPRRX THIS RPL EXIT IS DRIVEN BY THE COMPLETION      * 00090000
*       OF A RECEIVE OPTCD=SPEC ISSUED FOR THE PRIMARY SLU.           * 00100006
*                                                                     * 00110000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAPRRX.              * 00120000
*                                                                     * 00130000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00140000
*       OF THE EPILOGUE MACRO.                                        * 00150000
*                                                                     * 00160000
*     REGISTERS ON ENTRY -                                            * 00170000
*       BEFORE PROLOGUE:                                              * 00180000
*         R0:  UNPREDICTABLE                                          * 00190000
*         R1:  ADDRESS OF THE PRIMARY RPL                             * 00200000
*         R2-R13:  UNPREDICTABLE                                      * 00210000
*         R14: RETURN ADDRESS                                         * 00220000
*         R15: ENTRY ADDRESS                                          * 00230000
*       AFTER PROLOGUE:                                               * 00240000
*         R0:  UNPREDICTABLE                                          * 00250000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00260000
*         R2-R8: UNPREDICTABLE                                        * 00270000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00280000
*         R10: ADDRESS OF COMMON STORAGE AREA                         * 00290004
*         R11: ADDRESS OF SESSION STORAGE AREA                        * 00300004
*         R12: ENTRY ADDRESS                                          * 00310000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00320000
*         R14: RETURN ADDRESS                                         * 00330000
*         R15: RETURN CODE FROM GETMAIN                               * 00340004
*                                                                     * 00350000
*     MACROS USED -                                                   * 00360000
*       IBM MACROS:                                                   * 00370000
*         CHECK, FREEMAIN, GETMAIN, SEND, RECEIVE                     * 00380004
*       NON-IBM MACROS:                                               * 00390000
*         EPILOGUE, PHASE, PROLOGUE                                   * 00400000
*                                                                     * 00410000
*     COPY MEMBERS:                                                   * 00420000
*       XTACMAP, XTASMAP                                              * 00430000
*                                                                     * 00440000
*     INPUT:                                                          * 00450000
*       A BUFFER OF DATA FROM THE PRIMARY SESSION (THE 3270).         * 00460004
*                                                                     * 00470000
*     OUTPUT:                                                         * 00480000
*       IF THE INPUT IS DETERMINED TO BE A COMMAND, NONE.             * 00490004
*       IF THE INPUT IS DETERMINED TO BE DATA, THE DATA IS SENT       * 00491004
*         ON THE SECONDARY SESSION, AND IS ECHOED ON THE PRIMARY      * 00492004
*         SESSION.                                                    * 00493004
*                                                                     * 00494004
*     ABENDS:                                                         * 00500000
*       NO USER ABENDS.                                               * 00510004
*                                                                     * 00520000
*     MESSAGES ISSUED:                                                * 00530000
*       NONE.  IF AN INVALID COMMAND IS ENTERED, IT IS NOT DETECTED   * 00531006
*       HERE, BUT IN XTASCMD, WHICH ISSUES AN ERROR MESSAGE.          * 00550006
*                                                                     * 00553006
*     RETURN CODES:                                                   * 00560000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00570000
*                                                                     * 00580000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00590000
         SPACE 1                                                        00591006
XTAPRRX  PROLOGUE EXIT=RPL                                              00600000
         EJECT                                                          00610000
**                                                                      00620000
*                                                                       00630000
    PHASE  5.1 - CHECK THE RPL                                          00640000
*                                                                       00650000
**                                                                      00660000
         SPACE 1                                                        00661005
         CHECK RPL=(R9)                                                 00670000
         LTR   R15,R15             ENSURE CHECK WAS SUCCESSFUL.         00680004
         BZ    PH5#2               IF CHECK WAS OK, CONTINUE.           00690000
         CLC   =X'1009',RPLRTNCD   IF LU IS GONE, BECAUSE OF SSCP       00700000
         BE    PH5#99                LOGOFF,                            00710004
         CLC   =X'0C0B',RPLRTNCD     OR SESSION TERMINATION,            00720004
         BE    PH5#99                THEN SIMPLY EXIT.                  00730004
         CLC   =X'0C0C',RPLRTNCD   IF REQUEST CANCELLED BY CLEAR REQ,   00731036
         BE    PH5#99                XTASCRX WILL RE-ISSUE RECEIVE.     00732036
         L     R15,CS#ACLNP        FOR OTHER FAILURES, INITIATE A       00740004
         BALR  R14,R15               CLEANUP,                           00750004
         B     PH5#99                THEN EXIT.                         00760004
         EJECT                                                          00770000
**                                                                      00860000
*                                                                       00870000
    PHASE  5.2 - STRIP 3270 FORMATTING                                  00880004
*                                                                       00890000
**                                                                      00900000
         SPACE 1                                                        00910000
*********************************************************************** 00920000
*                                                                     * 00930000
*  THE INBOUND DATA STREAM FOR 3270 SHORT READ OPERATIONS (PA KEY     * 00940000
*  OR CLEAR KEY) CONSISTS OF AN AID BYTE ONLY.                        * 00950000
*                                                                     * 00960000
*  THE INBOUND DATA STREAM FOR 3270 READ MODIFIED OPERATIONS HAS      * 00970000
*  THE FOLLOWING FORMAT:                                              * 00980000
*                                                                     * 00981004
*                             |-----------OPTIONAL------------->      * 00990004
*  +--------+--------+--------+--------+--------+--------+------//    * 01000004
*  |  AID   | CURSOR ADDRESS  |  SBA   |  FIELD ADDRESS  |   DATA     * 01010004
*  +--------+--------+--------+--------+--------+--------+----//      * 01020004
*                                                                     * 01030000
*  FOR 'READ BUFFER FIELD MODE' ONLY SBA AND GE APPEAR IN THE         * 01040005
*  INBOUND DATA STREAM.                                               * 01060004
*                                                                     * 01070000
*  SBA (X'11') IS FOLLOWED BY A TWO BYTE BUFFER ADDRESS; GE (X'08')   * 01080005
*  IS FOLLOWED BY ONE BYTE OF DATA.                                   * 01090005
*                                                                     * 01110000
*  THE FOLLOWING CODE ONLY CHECKS FOR SBA AT OFFSET +0 INTO THE       * 01120004
*  DATA FIELD - SINCE WE FORMAT THE SCREEN, WE KNOW THAT THERE'S      * 01130004
*  ONLY A SINGLE INPUT FIELD.  AT THE PRESENT TIME, GE IS NOT         * 01140006
*  HANDLED IN ANY WAY, AND WILL CAUSE UNPREDICTABLE RESULTS AT        * 01141006
*  BEST, AND ABENDS AT WORST.                                         * 01142006
*                                                                     * 01143006
*********************************************************************** 01150000
         SPACE 1                                                        01150104
         OI    SS#FLAG2,SS#INBKT   THE 3270 HAS STARTED A BRACKET.      01151004
         MVC   SS#PRSPL,RPLRLEN    GET INPUT RECORD LENGTH.             01152004
         MVC   SS#WORK2(6),SS#PIBUF     SAVE AID,CA,CA(,SBA,FA,FA).     01153004
         SPACE 1                                                        01160000
*  AT LABEL 'NOSBA', R5 IS EXPECTED TO CONTAIN THE LENGTH OF THE        01190004
*  RECEIVED DATA MINUS THE LENGTH OF THE AID, CURSOR ADDRESS, AND,      01191004
*  IF PRESENT, THE SBA AND FIELD ADDRESS.  SO . . .                     01192004
         SPACE 1                                                        01193004
         SLR   R5,R5               DATA LENGTH MAY BE 0; LET'S CHECK:   01200004
         L     R4,SS#PRSPL         GET THE LENGTH OF THE RCVD DATA.     01201004
         LTR   R4,R4               IF LENGTH IS ZERO, SOMETHING WENT    01202030
         BZ    PSBAD                 WRONG, REFORMAT THE SCREEN.        01203030
         CH    R4,=H'3'            FOR 'SHORT READS' OR NO DATA, LENGTH 01210000
         BNH   NOSBA                 WILL BE 3 OR LESS.                 01220000
         LR    R5,R4               GET LENGTH INTO R5 (SEE NOTE ABOVE). 01230007
         MVC   SS#PIBUF(L'SS#PIBUF-3),SS#PIBUF+3  ELIDE AID, CURSOR ADR 01240000
         SH    R5,=H'3'            DECREMENT LENGTH APPROPRIATELY.      01250000
         SPACE 1                                                        01260030
PSBAD    EQU   *                                                        01270030
         LA    R1,CLEARPIU         IF THERE IS NO SBA PRESENT, OR THE   01270129
         LA    R14,PH5#12            BA IS THE BEGINNING OF THE SCREEN, 01270221
         L     R15,CS#APSMR          THEN WE KNOW THAT PRESENTATION     01270321
         CLI   SS#PIBUF,SBA          SPACE INTEGRITY HAS BEEN LOST, AND 01270429
         BNER  R15                   THAT WE MUST REFORMAT THE SCREEN.  01270529
         CLC   =X'4040',SS#PIBUF+1                                      01271029
         BER   R15                                                      01272029
         CLC   =X'0000',SS#PIBUF+1                                      01273022
         BER   R15                                                      01274021
         MVC   SS#PIBUF(L'SS#PIBUF-3),SS#PIBUF+3  ELIDE SBA, FIELD ADDR 01280000
         SH    R5,=H'3'            ADJUST LENGTH AGAIN.                 01290004
         SPACE 1                                                        01300000
NOSBA    EQU   *                                                        01310000
         ST    R5,SS#PRSPL         STORE THE UPDATED LENGTH.            01320000
         LA    R4,SS#PIBUF         GET ADDRESS OF RECEIVED DATA.        01330000
         AR    R4,R5               POINT PAST DATA.                     01340000
         MVI   0(R4),X'00'         FLAG END OF INPUT.                   01350000
         SPACE 1                                                        01351004
*  WE CAN SAFELY DO THIS, BECAUSE WE WILL ALWAYS END UP WITH LESS       01352004
*  THAN A FULL BUFFER OF DATA:  IF ANY DATA IS RECIEVED AT ALL,         01353004
*  SIX BYTES WILL HAVE BEEN REMOVED FROM THE FRONT OF THE BUFFER.       01354004
         EJECT                                                          01360000
**                                                                      01370000
*                                                                       01380000
    PHASE  5.3 - IF AID=PF1 --> 5.10                                    01390032
*                                                                       01400000
**                                                                      01410000
         SPACE 1                                                        01411005
         OI    SS#FLAG3,SS#NOCR    PF10/PF22 ARE TREATED AS ENTER       01412032
         CLI   SS#WORK2,PF10         EXCEPT THAT NO CR IS APPENDED TO   01440032
         BE    PH5#4                 THE DATA BEFORE SENDING IT.        01450032
         CLI   SS#WORK2,PF22         ENTER MEANS SEND DATA TO REMOTE    01470032
         BE    PH5#4                 HOST.  OTHER AIDS ARE HANDLED IN   01480032
         NI    SS#FLAG3,X'FF'-SS#NOCR  THE COMMAND PROCESSING PHASE.    01481032
         CLI   SS#WORK2,ENTER                                           01490032
         BNE   PH5#10                                                   01500031
         EJECT                                                          01530000
**                                                                      01540000
*                                                                       01550000
    PHASE  5.4 - IF HOLD=YES, SET HOLD=NO AND REISSUE PRIMARY RECIEVE   01560004
*                                                                       01570000
**                                                                      01580000
         SPACE 1                                                        01581004
         GBLC  &IENTER                                                  01581135
         AIF   ('&IENTER' EQ 'COMMAND').COMMAND                         01581237
         LA    R1,NOSECDY              VERSION 1: COMMANDS MUST ALWAYS  01582035
         TM    SS#FLAG1,SS#SACT          BE ENTERED USING PF1.  IF THE  01583035
         BO    SECDYOK                   ENTER KEY IS USED WHEN THERE   01584035
         NI    SS#FLAG3,X'FF'-SS#NOCR    IS NO SECONDARY, AN ERROR      01585035
         L     R15,CS#APSMR              MESSAGE IS DISPLAYED.          01586035
         BALR  R14,R15                                                  01587035
         B     PH5#12                                                   01588035
         AGO   .POSTENT                                                 01588135
.COMMAND ANOP                                                           01589135
         TM    SS#FLAG1,SS#SACT        VERSION 2: IF THE ENTER KEY IS   01589235
         BO    SECDYOK                   PRESSED, BUT THERE IS NO       01589335
         NI    SS#FLAG3,X'FF'-SS#NOCR    SECONDARY, THE INPUT IS        01589435
         MVI   SS#WORK2,PF1              ASSUMED TO BE A COMMAND.       01589538
         B     PH5#10                                                   01589738
.POSTENT ANOP                                                           01589835
         SPACE 1                                                        01589935
SECDYOK  EQU   *                                                        01590031
         TM    SS#FLAG2,SS#HOLDD       IF WE ARE IN 'HOLD' STATE,       01591001
         BZ    PH5#5                     THEN WE EXIT THAT STATE AND    01600004
         NI    SS#FLAG2,X'FF'-SS#HOLDD   IGNORE THE INPUT - WHICH       01610001
         LA    R1,NULLECHO               REMAINS IN THE INPUT AREA, SO  01620006
         L     R15,CS#APSMR              THE USER CAN PRESS ENTER TO    01630000
         BALR  R14,R15                   SEND IT AGAIN.                 01640000
         L     R2,SS#APRPL             WE'VE GOT TO KEEP THIS RECEIVE   01650000
         L     R3,SS#PCID                OUTSTANDING SO THAT THE USER   01660000
         L     R4,CS#APRRX               DOESN'T END UP STARING AT A    01670000
         LA    R5,SS#PIBUF               LOCKED KEYBOARD.               01680000
         RECEIVE RPL=(R2),                                             X01690000
               ARG=(R3),                                               X01700000
               EXIT=(R4),                                              X01710000
               AREA=(R5),                                              X01720000
               AREALEN=160                                              01730000
         B     PH5#99                                                   01740002
         EJECT                                                          01741004
**                                                                      01742004
*                                                                       01743004
    PHASE  5.5 - CALL PSM(ECHO)                                         01744004
*                                                                       01745004
**                                                                      01746004
         SPACE 1                                                        01750004
         MVC   SS#WORK1(LECHOHDR),ECHOHDR    REQUEST ECHO PROCESSING.   01770004
         L     R4,SS#PRSPL         GET THE LENGTH OF THE DATA.          01800000
         LTR   R4,R4               IF THE DATA LENGTH IS ZERO,          01810000
         BZ    NOMOVE                DON'T TRY TO MOVE IT.              01820004
         BCTR  R4,0                DECREMENT THE LENGTH FOR EX'D MVC.   01830000
         EX    R4,MVC@ECHO         MOVE THE DATA TO THE PSM BUFFER.     01840000
         EX    R4,TR@FMDUP         NEUTRALIZE FIELD-MARKS AND DUP'S.    01841005
         SPACE 1                                                        01850000
NOMOVE   EQU   *                                                        01860000
         L     R4,SS#PRSPL         GET THE LENGTH OF THE DATA.          01870000
         TM    SS#FLAG3,SS#NOCR                                         01880001
         BO    NOCRLF                                                   01890000
         LA    R5,SS#WORK1+2       POINT TO WHERE THE DATA WENT,        01900000
         AR    R5,R4                 THEN TO FIRST BYTE AFTER IT,       01910000
         MVC   0(2,R5),=X'0810'      AND INSERT A CR/LF.                01920000
         LA    R4,2(R4)            ADD LENGTH(CR/LF) TO TOTAL LENGTH.   01930004
         SPACE 1                                                        01940000
NOCRLF   EQU   *                                                        01950000
         STC   R4,SS#WORK1+1       STORE LENGTH OF REQUEST.             01960004
         LA    R1,SS#WORK1         POINT TO THE BUFFER.                 01970004
         L     R15,CS#APSMR        GET ADDRESS OF PSM,                  01980000
         BALR  R14,R15               AND CALL HIM.                      01990000
         EJECT                                                          02000000
**                                                                      02010000
*                                                                       02020000
    PHASE  5.6 - TWX-IZE THE DATA                                       02030000
*                                                                       02040000
**                                                                      02050000
         SPACE 1                                                        02051005
         LA    R6,SS#PIBUF         SET UP TO PROCESS THE INPUT DATA.    02060000
         L     R5,SS#PRSPL                                              02070000
         SPACE 1                                                        02071004
TWXCC    EQU   *                                                        02080000
         BCTR  R5,0                DECREMENT LENGTH REGISTER FOR EX'D   02090000
         EX    R5,TRT@FM             INSTRUCTIONS; THEN CHECK TO SEE    02100005
         BZ    NOFM                  IF THERE ARE ANY FIELD MARKS IN    02110000
         BC    4,CCHAR               THE DATA STREAM.                   02120000
         L     R7,SS#PRSPL         IF A FM IS FOUND IN THE LAST         02130000
         BCTR  R7,0                  POSITION, IT IS SIMPLY DELETED,    02140000
         ST    R7,SS#PRSPL           AND THE LENGTH IS UPDATED.         02150000
         B     NOFM                                                     02160000
         SPACE 1                                                        02170000
CCHAR    EQU   *                                                        02180000
         LR    R4,R1               CALCULATE THE LENGTH OF THE          02190000
         SR    R4,R6                 REMAINING TEXT, AND MOVE IT IN,    02200000
         SR    R5,R4                 ELIDING THE FM.                    02210000
         EX    R4,MVC@CC                                                02220005
         TR    0(1,R1),GRFX2CC     THEN, TRANSLATE THE CHARACTER WHICH  02230000
         LA    R6,1(R1)              FOLLOWED THE FIELD MARK TO THE     02240000
         L     R7,SS#PRSPL           CORRESPONDING CONTROL CHARACTER,   02250000
         BCTR  R7,0                  AND UPDATE THE LENGTH.             02260000
         ST    R7,SS#PRSPL                                              02270000
         BCTR  R5,0                START AT THE NEXT LOCATION AND DO    02280000
         B     TWXCC                 IT ALL AGAIN.                      02290000
         SPACE 1                                                        02300000
NOFM     EQU   *                                                        02310000
         TM    SS#FLAG3,SS#NOCR    IF NO CR WAS WANTED, THEN SKIP       02320001
         BO    NOCR                  THIS STEP.                         02330000
         LA    R6,SS#PIBUF         POINT TO THE INPUT, THEN POINT       02340005
         A     R6,SS#PRSPL           JUST PAST THE INPUT BY ADDING ITS  02350005
         MVI   0(R6),X'0D'           LENGTH TO OUR POINTER, AND INSERT  02360119
         L     R5,SS#PRSPL           A CR AT THE END.                   02361005
         LA    R5,1(R5)            THEN, UPDATE THE LENGTH TO ACCOUNT   02362018
         ST    R5,SS#PRSPL           FOR THE CR WE JUST ADDED.          02363005
         SPACE 1                                                        02370000
NOCR     EQU   *                                                        02380000
         NI    SS#FLAG3,X'FF'-SS#NOCR   RESET THE NOCR FLAG.            02380113
         GBLC  &IPAD                                                    02381011
         AIF   ('&IPAD' EQ 'INTEG').NOTYPE                              02390010
         MVC   SS#WORK1(L'SS#PIBUF),SS#PIBUF  CACHE THE DATA;           02400005
         MVI   SS#PIBUF,X'00'                 INSERT PKT TYPE BYTE;     02410005
         MVC   SS#PIBUF+1(L'SS#PIBUF-1),SS#WORK1  AND RESTORE THE DATA. 02420005
         L     R5,SS#PRSPL         INCREMENT THE LENGTH OF THE DATA     02430005
         LA    R5,1(R5)              BY 1 TO ACCOUNT FOR THE PACKET     02440005
         ST    R5,SS#PRSPL           TYPE BYTE.                         02441005
.NOTYPE  ANOP                                                           02442008
         EJECT                                                          02450000
**                                                                      02460000
*                                                                       02470000
    PHASE  5.7 - CALL DATA CAPTURE ROUTINE                              02480002
*                                                                       02490000
**                                                                      02500000
         SPACE 1                                                        02500105
         TM    SS#FLAG4,SS#SAVON   CHECK WHETHER SAVE IS ACTIVE BEFORE  02500225
         BZ    PH5#8                 INVOKING CAPTURE ROUTINE.          02500326
         LA    R1,SS#PIBUF         BUILD THE PARAMETER LIST FOR THE     02500425
         L     R2,SS#PRSPL           CAPTURE ROUTINE AND POINT TO IT.   02500533
         AIF   ('&IPAD' EQ 'INTEG').NOADJ                               02500633
         LA    R1,1(R1)            HERE WE OMIT THE PAD TYPE BYTE FROM  02500733
         BCTR  R2,0                  THE INPUT LIST.                    02500833
.NOADJ   ANOP                                                           02500933
         ST    R1,SS#WORD1                +-----------+                 02501033
         ST    R2,SS#WORD2         R1 --> |  A(DATA)  |                 02501233
         LA    R1,SS#WORD1                +-----------+                 02501325
         L     R15,CS#ACPTR               |  L'DATA   |                 02501425
         BALR  R14,R15                    +-----------+                 02501525
         EJECT                                                          02501602
**                                                                      02502002
*                                                                       02503002
    PHASE  5.8 - SEND ASY TO SECONDARY                                  02504002
*                                                                       02505002
**                                                                      02506002
         SPACE 1                                                        02507005
         L     R5,SS#PRSPL         RESTORE LENGTH OF DATA.              02510005
         L     R6,SS#APRPL         POINT TO PRIMARY RPL.                02511005
         L     R7,SS#SCID          GET CID FOR SECONDARY SESSION.       02520000
         L     R8,CS#ASNRX         GET ADDRESS OF NEW EXIT.             02530000
         NI    RPLRH3,X'FF'-(RPLBB+RPLEB)                               02540017
         SEND  RPL=(R6),RECLEN=(R5),ARG=(R7),EXIT=(R8)                  02590000
         EJECT                                                          02600000
**                                                                      02610000
*                                                                       02620000
    PHASE  5.9 - INCREMENT SEND COUNT                                   02630002
*                                                                       02640000
**                                                                      02650000
         SPACE 1                                                        02651005
         L     R6,SS#SNDCT         MAINTAIN STATISTICS IN SESSION       02660000
         LA    R6,1(R6)              STORAGE.                           02670000
         ST    R6,SS#SNDCT                                              02680000
         B     PH5#99                                                   02690002
         EJECT                                                          02700000
**                                                                      02710000
*                                                                       02720000
    PHASE  5.10 - PARSE THE COMMAND                                     02730002
*                                                                       02740000
**                                                                      02750000
         SPACE 1                                                        02760000
*********************************************************************** 02770000
*                                                                     * 02780000
*  THE INPUT TO THIS ROUTINE IS THE AID,CA,CA(,SF,FA,FA) IN           * 02790000
*  SS#WORK2, THE NAKED INPUT DATA IN SS#PIBUF, AND THE LENGTH OF THE  * 02800000
*  NAKED INPUT DATA IN SS#PRSPL.  THE OUTPUT IS A STRUCTURE CALLED    * 02810000
*  A COMMAND DESCRIPTOR BLOCK (CDB), PLACED IN SS#WORK2, WHICH        * 02820000
*  DESCRIBES THE PARSED INPUT WORD BY WORD.  THIS IS HOW THE CDB      * 02830000
*  WOULD LOOK GIVEN THE INPUT 'CALL CPS'.                             * 02840000
*                                                                     * 02850000
*                  +------+                                           * 02860000
*                  |  03  |                                           * 02870000
*                  +------+------+                                    * 02880000
*                  |  01  |  7D  |                                    * 02890000
*                  +------+------+------+------+------+               * 02900000
*                  |  04  |  C   |  A   |  L   |  L   |               * 02910000
*                  +------+------+------+------+------+               * 02920000
*                  |  03  |  C   |  P   |  S   |                      * 02930000
*                  +------+------+------+------+                      * 02940000
*                                                                     * 02950000
*  THE FIRST BYTE IS THE NUMBER OF ELEMENTS (WORDS) REPRESENTED IN    * 02960000
*  THE CDB.  THE FIRST WORD IS ALWAYS THE AID BYTE, AND ITS LENGTH,   * 02970000
*  OF COURSE, IS ALWAYS 1.  THE NEXT BYTE IS THE LENGTH OF THE FIRST  * 02980000
*  WORD ENCOUNTERED, FOLLOWED BY THE WORD ITSELF.  THIS CONTINUES     * 02990000
*  UNTIL EACH OF THE WORDS ENCOUNTERED IN THE INPUT IS DESCRIBED.     * 03000000
*                                                                     * 03010000
*********************************************************************** 03020000
         SPACE 1                                                        03030000
         MVC   SS#WORK2+2(1),SS#WORK2   FIX UP THE FIRST PART OF THE    03040000
         MVI   SS#WORK2,X'01'           INPUT DESCRIPTOR BLOCK:         03050000
         MVI   SS#WORK2+1,X'01'         (# OF WORDS, L'AID, AID).       03060000
         LA    R5,SS#WORK2+3       GET OUR POINTERS SET UP TO BEGIN THE 03070000
         L     R3,SS#PRSPL           PARSING OPERATION.                 03080000
         LA    R4,SS#PIBUF                                              03090000
         LTR   R3,R3               IF THERE WASN'T ANYTHING BUT AN AID, 03100000
         BZ    PH5#11                THEN WE'RE ALL DONE...             03110002
         SPACE 1                                                        03120000
         LR    R2,R3               TRANSLATE ALPHABETICS IN THE INPUT   03130000
         BCTR  R2,0                  TO ALL UPPER CASE.                 03140000
         EX    R2,TR@UPCSE                                              03150000
         SPACE 1                                                        03160000
PARSMORE EQU   *                                                        03170000
         BCTR  R3,0                FIND THE FIRST NONBLANK IN THE       03180000
         EX    R3,TRT@NBLK           INPUT BUFFER; IF THERE AREN'T      03190000
         BZ    PH5#11                ANY (MORE) THEN WE'RE DONE.        03200002
         SPACE 1                                                        03210000
         LR    R2,R1               ADJUST THE LENGTH (IN R3) AND THE    03220000
         SR    R2,R4                 STARTING ADDRESS (IN R4) TO LOOK   03230000
         SR    R3,R2                 FOR THE BLANK FOLLOWING THIS WORD. 03240000
         LR    R4,R1               PRESET R1 TO THE END OF THE INPUT IN 03250000
         LA    R1,1(R3,R4)           CASE THERE ISN'T ANY BLANK.        03260000
         EX    R3,TRT@BLK          NOW, SCAN FOR THE BLANK.             03270000
         LR    R2,R1               GET THE LENGTH OF THE WORD AND PUT   03280000
         SR    R2,R4                 IT IN THE CDB...                   03290000
         STC   R2,0(R5)                                                 03300000
         BCTR  R2,0                                                     03310000
         EX    R2,MVC@INP          ...AND FOLLOW IT BY THE WORD ITSELF. 03320000
         SLR   R1,R1               UPDATE THE # OF WORDS APPEARING      03330000
         IC    R1,SS#WORK2           IN THE CDB.                        03340000
         LA    R1,1(R1)                                                 03350000
         STC   R1,SS#WORK2                                              03360000
         LA    R5,2(R5,R2)         UPDATE POINTERS AND LENGTHS TO       03370000
         LA    R4,1(R2,R4)           PREPARE TO SEARCH FOR THE NEXT     03380000
         SR    R3,R2                 WORD - IF THERE'S ANYTHING LEFT    03390000
         BNZ   PARSMORE              TO SEARCH.                         03400000
         EJECT                                                          03410000
**                                                                      03420000
*                                                                       03430000
    PHASE 5.11  -  CALL COMMAND PROCESSOR                               03440002
*                                                                       03450000
**                                                                      03460000
         SPACE 1                                                        03470000
*********************************************************************** 03480000
*                                                                     * 03490000
*  WE'RE LOOKING AT AID BYTES IN THIS PHASE, SO HERE'S WHAT THEY ARE: * 03500000
*                                                                     * 03510000
*   NO AID GENERATED (DISPLAY)   60     0110 0000     READ MOD        * 03520000
*   NO AID GENERATED (PRINTER)   E8     1110 1000     READ MOD        * 03530000
*   STRUCTURED FIELD             88     1000 1000                     * 03540000
*   READ PARTITION               61     0110 0001                     * 03550000
*   TRIGGER ACTION               7F     0111 1111                     * 03560000
*   PFK1 - PFK9                F1-F9    1111 XXXX     READ MOD        * 03570000
*   PFK10 - PFK12              7A-7C    0111 1XXX     READ MOD        * 03580000
*   PFK13 - PFK21              C1-C9    1100 XXXX     READ MOD        * 03590000
*   PFK22 - PFK24              4A-4C    0100 1XXX     READ MOD        * 03600000
*   PA1                          6C     0110 1100     SHORT RD        * 03610000
*   PA2 (CNCL)                   6E     0110 1110     SHORT RD        * 03620000
*   PA3                          6B     0110 1011     SHORT RD        * 03630000
*   CLEAR                        6D     0110 1101     SHORT RD        * 03640000
*   CLEAR PARTITION              6A     0110 1010                     * 03650000
*   ENTER KEY                    7D     0111 1101     READ MOD        * 03660000
*   SELECTOR-PEN ATTENTION       7E     0111 1110                     * 03670000
*                                                                     * 03680000
*********************************************************************** 03690000
         SPACE 1                                                        03700000
*------> NOTE HOW R1, R14 AND R15 ARE PRE-LOADED IN THIS PHASE <------* 03710000
         SPACE 1                                                        03720000
         LA    R14,PH5#12           PREPARE TO RETURN AT NEXT PHASE.    03730005
         L     R15,CS#APSMR         PREPARE TO CALL PSM.                03740005
         SPACE 1                                                        03750000
         LA    R1,CLEARPIU          POINT TO INITSCRN REQUEST, AND SEND 03760000
         CLI   SS#WORK2+2,X'6D'       AN INITSCRN IF THE CLEAR KEY WAS  03770000
         BER   R15                    PRESSED.                          03780000
         SPACE 1                                                        03790000
         LA    R1,SYSMSGL0          HERE WE CHECK FOR 'SHORT READ'      03800000
         MVC   SS#WORD1(1),SS#WORK2   AIDS - WE CURRENTLY SEND A NULL   03801005
         NI    SS#WORD1,X'F8'         SYSMSG IN RESPONSE TO THESE.      03810005
         CLI   SS#WORD1,X'68'                                           03820005
         BER   R15                                                      03830000
         SPACE 1                                                        03840000
         CLI   SS#WORK2,X'01'       WE ALSO SEND NULL SYSMSG IF THERE   03850000
         BNHR  R15                    WAS NO INPUT.                     03860000
         SPACE 1                                                        03861031
         LA    R1,BADAID            TARA CMDS ENTERED VIA PF1; AT SOME  03862031
         CLI   SS#WORK2+2,PF1         POINT I'LL IMPLEMENT A TABLE OF   03863031
         BNER  R15                    AIDS TO CHECK.                    03864031
         SPACE 1                                                        03870000
         LA    R3,CMDTABLE          PREPARE TO SEARCH FOR A VALID       03880000
         LA    R4,#CMDS               COMMAND.                          03890000
         SPACE 1                                                        03900000
CMDLOOP  EQU   *                                                        03910000
         L     R15,0(R3)            GET ADDRESS OF COMMAND PROCESSOR,   03920000
         LH    R5,4(R3)               THEN, IF THE INPUT MATCHES, GO    03930000
         EX    R5,CLC@CMD             TO THAT MODULE.                   03940000
         BER   R15                                                      03950000
         LA    R3,16(R3)            BUMP TO NEXT ENTRY, AND LOOP UNTIL  03960000
         BCT   R4,CMDLOOP             TABLE EXHAUSTED.                  03970000
         SPACE 1                                                        03980000
         L     R15,CS#ASCMD         SINCE THE COMMAND WASN'T FOUND, LET 03990000
         BALR  R14,R15                SCMD HAVE A TRY AT IT.            04000000
         EJECT                                                          04010000
**                                                                      04020000
*                                                                       04030000
    PHASE  5.12 - REISSUE RECEIVE PRIMARY                               04040002
*                                                                       04050000
**                                                                      04060000
         SPACE 1                                                        04061005
         TM    SS#FLAG1,SS#LOGFF   SKIP THE RECEIVE IF WE JUST          04070001
         BO    PH5#99                PROCESSED A LOGOFF COMMAND.        04080002
         XC    SS#PIBUF,SS#PIBUF   ENSURE INPUT BUFFER IS CLEARED.      04090000
         L     R3,SS#PCID          GET CID FOR PRIMARY SESSION.         04100000
         L     R6,SS#APRPL         POINT TO PRIMARY RPL.                04110000
         RECEIVE RPL=(R6),ARG=(R3) ASK FOR MORE INPUT.                  04120000
         EJECT                                                          04130000
**                                                                      04140000
*                                                                       04150000
    PHASE  5.99 - EXIT                                                  04160000
*                                                                       04170000
**                                                                      04180000
         SPACE 1                                                        04181005
         SLR   R15,R15             SET RETURN CODE TO ZERO.             04190000
         EPILOGUE                  EXIT.                                04200000
*********************************************************************** 04210000
*********************************************************************** 04220000
********                                                       ******** 04230000
********               END OF EXECUTABLE CODE                  ******** 04240000
********                                                       ******** 04250000
*********************************************************************** 04260000
*********************************************************************** 04270000
         TITLE 'DATA AREA'                                              04280000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04290000
*                                                                     * 04300000
*  COMMAND TABLE                                                      * 04310000
*                                                                     * 04320000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04330000
         SPACE 2                                                        04340000
         DS    0D                                                       04350000
CMDTABLE EQU   *                                                        04360000
         DC    V(XTALOGF),H'3',CL10'OFF'                                04361005
         DC    V(XTALOGF),H'3',CL10'BYE'                                04362005
         DC    V(XTAACQR),H'4',CL10'CALL'                               04370000
         DC    V(XTAACQR),H'4',CL10'DIAL'                               04380000
         DC    V(XTADROP),H'4',CL10'DROP'                               04390000
         DC    V(XTADROP),H'6',CL10'HANGUP'                             04400000
         DC    V(XTASAVE),H'4',CL10'SAVE'                               04410000
         DC    V(XTASAVE),H'7',CL10'CAPTURE'                            04420000
         DC    V(XTALOGF),H'6',CL10'LOGOFF'                             04430000
#CMDS    EQU   (*-CMDTABLE)/16                                          04440000
         SPACE 2                                                        04450000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04460000
*                                                                     * 04470000
*  EXECUTE OBJECTS                                                    * 04480000
*                                                                     * 04490000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04500000
         SPACE 2                                                        04510000
TR@UPCSE TR    SS#PIBUF(0),UPCASE                                       04520000
TRT@NBLK TRT   0(0,R4),NONBLANK                                         04530000
TRT@BLK  TRT   0(0,R4),BLANK                                            04540000
MVC@INP  MVC   1(0,R5),0(R4)                                            04550000
MVC@ECHO MVC   SS#WORK1+LECHOHDR(0),SS#PIBUF                            04560000
TR@FMDUP TR    SS#WORK1+LECHOHDR(0),FOR3270                             04561012
CLC@CMD  CLC   SS#WORK2+3(0),5(R3)                                      04570000
TRT@FM   TRT   0(0,R6),FLDMARK                                          04580005
MVC@CC   MVC   0(0,R1),1(R1)                                            04590005
         SPACE 2                                                        04600000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04610000
*                                                                     * 04620000
*  MISCELLANEOUS EQUATES                                              * 04630005
*                                                                     * 04640000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04650000
         SPACE 2                                                        04660000
SBA      EQU   X'11'                                                    04670000
         SPACE 1                                                        04671020
*     AID EQUATES                                                       04672020
         SPACE 1                                                        04673020
ENTER    EQU   X'7D'        DATA BOUND FOR SECONDARY                    04680020
PF1      EQU   X'F1'        TARA COMMAND                                04690020
PF10     EQU   X'7A'        DATA FOR SECONDARY - DON'T ADD CR           04690120
PF13     EQU   X'C1'        TARA COMMAND                                04690220
PF22     EQU   X'4A'        DATA FOR SECONDARY - DON'T ADD CR           04691020
         SPACE 2                                                        04700000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04710000
*                                                                     * 04720000
*  MESSAGE TEMPLATES                                                  * 04730000
*                                                                     * 04740000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04750000
         SPACE 2                                                        04760000
NULLECHO EQU   *                                                        04770006
         DC    YL1(ECHO-CLEARIPT)                                       04780014
         DC    YL1(0)                                                   04790006
         SPACE 1                                                        04810000
ECHOHDR  DC    YL1(ECHO),YL1(0)                                         04811005
LECHOHDR EQU   *-ECHOHDR                                                04812005
         SPACE 1                                                        04813005
CLEARPIU EQU   *                                                        04820000
         DC    YL1(INITSCRN)                                            04830004
         DC    YL1(0)                                                   04840000
         SPACE 1                                                        04850000
SYSMSGL0 EQU   *                                                        04860000
         DC    YL1(SYSMSG-AALARM)                                       04870000
         DC    YL1(0)                                                   04880000
         SPACE 1                                                        04881020
NOSECDY  DC    YL1(SYSMSG),YL1(L'TNOSECDY)                              04882020
TNOSECDY DC    C'XTA0503  USE PF1 OR PF13 TO ENTER TARA COMMANDS.'      04883020
         SPACE 1                                                        04883120
BADAID   DC    YL1(SYSMSG),YL1(L'TBADAID)                               04883220
TBADAID  DC    C'XTA0503  FUNCTION KEY NOT DEFINED.'                    04883322
         SPACE 2                                                        04890000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04900000
*                                                                     * 04910000
*  TRANSLATE TABLES                                                   * 04920000
*                                                                     * 04930000
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 04940000
         SPACE 2                                                        04950000
UPCASE   EQU   *                                                        04960000
*     0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF  04970000
 DC C'                                                                ' 04980000
 DC C'          ¢.<(+|.         !$*);¬-/        ¦,%_>?         `:#@.="' 04990000
 DC C' ABCDEFGHI       JKLMNOPQR       ~STUVWXYZ                      ' 05000000
 DC C'{ABCDEFGHI      }JKLMNOPQR      \ STUVWXYZ      0123456789      ' 05010000
         ORG   UPCASE+X'50'                                             05051005
         DC    X'50'    AMPERSAND                                       05052005
         ORG   UPCASE+X'7D'                                             05053005
         DC    X'7D'    SINGLE QUOTE                                    05054005
         ORG                                                            05060000
         SPACE 2                                                        05070000
FLDMARK  EQU   *                                                        05080000
         DC    256X'00'                                                 05090000
         ORG   FLDMARK+X'1E'                                            05100000
         DC    X'1E'                                                    05110000
         ORG                                                            05120000
         SPACE 2                                                        05121005
BLANK    EQU   *                                                        05122005
         DC    256XL1'00'                                               05123005
         ORG   BLANK+C' '                                               05124005
         DC    C' '                                                     05125005
         ORG                                                            05126005
         SPACE 2                                                        05130000
GRFX2CC  EQU   *                                                        05140000
         DC    X'00000000000000000000000000000000'                      05150000
         DC    X'00000000000000000000000000000000'                      05160000
         DC    X'00000000000000000000000000000000'                      05170000
         DC    X'00000000000000000000000000000000'                      05180000
         DC    X'00000000000000000000000E22160B01'                      05190000
         DC    X'2E00000000000000000001372505271E'                      05200000
         DC    X'0D0F0000000000000000220C2D1F1E1F'                      05210000
         DC    X'000000000000000000003F03002F1D02'                      05220000
         DC    X'00010203372D2E2F1605000000000000'                      05230000
         DC    X'00250B0C0D0E0F101112000000000000'                      05240000
         DC    X'001E00003D322618193F000000000000'                      05250000
         DC    X'00000000000000000000000000000000'                      05260000
         DC    X'27010203372D2E2F1605000000000000'                      05270000
         DC    X'1D250B0C0D0E0F101112000000000000'                      05280000
         DC    X'220000003D322618193F000000000000'                      05290000
         DC    X'10111200003D32261819010000000000'                      05300000
         SPACE 2                                                        05310000
FOR3270  EQU   *                                                        05320012
         DC    X'00000000000000000000000000000000'                      05330000
         DC    X'0000000000000000000000009F00AF00'                      05340012
         DC    X'00000000000000000000000000000000'                      05350000
         DC    X'00000000000000000000000000000000'                      05360000
         DC    X'400000000000000000004A4B4C4D4E4F'                      05370012
         DC    X'500000000000000000005A5B5C5D5E5F'                      05380000
         DC    X'606100000000000000006A6B6C6D6E6F'                      05390000
         DC    X'000000000000000000797A7B7C7D7E7F'                      05400000
         DC    X'00818283848586878889000000000000'                      05410000
         DC    X'00919293949596979899000000000000'                      05420000
         DC    X'00A1A2A3A4A5A6A7A8A9000000000000'                      05430000
         DC    X'00000000000000000000000000000000'                      05440000
         DC    X'C0C1C2C3C4C5C6C7C8C9000000000000'                      05450000
         DC    X'D0D1D2D3D4D5D6D7D8D9000000000000'                      05460000
         DC    X'E000E2E3E4E5E6E7E8E9000000000000'                      05470000
         DC    X'F0F1F2F3F4F5F6F7F8F9FA0000000000'                      05480012
         SPACE 2                                                        05490005
NONBLANK EQU   *                                                        05500012
         DC    X'00000000000000000000000000000000'                      05510012
         DC    X'00000000000000000000000000000000'                      05520012
         DC    X'00000000000000000000000000000000'                      05530012
         DC    X'00000000000000000000000000000000'                      05540012
         DC    X'000000000000000000004A4B4C4D4E4F'                      05541012
         DC    X'500000000000000000005A5B5C5D5E5F'                      05542012
         DC    X'606100000000000000006A6B6C6D6E6F'                      05543012
         DC    X'000000000000000000797A7B7C7D7E7F'                      05544012
         DC    X'00818283848586878889000000000000'                      05545012
         DC    X'00919293949596979899000000000000'                      05546012
         DC    X'00A1A2A3A4A5A6A7A8A9000000000000'                      05547012
         DC    X'00000000000000000000000000000000'                      05548012
         DC    X'C0C1C2C3C4C5C6C7C8C9000000000000'                      05549012
         DC    X'D0D1D2D3D4D5D6D7D8D9000000000000'                      05549112
         DC    X'E000E2E3E4E5E6E7E8E9000000000000'                      05549212
         DC    X'F0F1F2F3F4F5F6F7F8F9000000000000'                      05549312
         SPACE 2                                                        05549412
         END   XTAPRRX                                                  05550000