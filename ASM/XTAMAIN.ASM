XTAMAIN  TITLE 'TARA MAINLINE ROUTINE (1.0)'                            00010005
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020005
*                                                                     * 00030005
*     MODULE NAME - XTAMAIN                                           * 00040005
*                                                                     * 00050005
*     FUNCTIONAL DESCRIPTION - XTAMAIN IS THE TARA MAIN TASK, WHICH   * 00060005
*       PERFORMS ALL THE REQUIRED STARTUP PROCESSING IN PREPARATION   * 00070005
*       FOR OPERATION.  SUBSEQUENTLY, IT PROCESSES OPERATOR MODIFY    * 00080005
*       AND STOP COMMANDS.  FINALLY, IT PERFORMS THE CLEANUP UNDER    * 00090005
*       NORMAL TERMINATION.                                           * 00100005
*                                                                     * 00110005
*     DRIVER - ENTRY IS FROM OS ATTACH BY AN INITIATOR OR FROM        * 00120005
*       ADDRESS SPACE CREATION BY OPERATOR START.                     * 00130005
*                                                                     * 00140005
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED - XTAMAIN.             * 00150005
*                                                                     * 00160005
*     EXIT - NORMAL EXIT IS THROUGH PHASE 1.99.  EXIT MAY ALSO        * 00170005
*       OCCUR DURING STARTUP VIA ABEND IN THE FOLLOWING PHASES:       * 00180005
*       1.1 (XTAHALT LOAD FAILURE); 1.5 (VTAM ACB OPEN FAILURE);      * 00190005
*       1.6 (SETLOGON START FAILURE).                                 * 00200005
*                                                                     * 00210005
*     REGISTERS ON ENTRY -                                            * 00220005
*       BEFORE PROLOGUE:                                              * 00230005
*         R0: UNPREDICTABLE                                           * 00240005
*         R1: STANDARD OS PARAMETER LIST FROM EXEC STATEMENT          * 00250005
*         R2-R12: UNPREDICTABLE                                       * 00260005
*         R13: POINTER TO OS-PROVIDED SAVEAREA                        * 00270005
*         R14: RETURN ADDRESS                                         * 00280005
*         R15: ENTRY ADDRESS                                          * 00290005
*       AFTER PROLOGUE:                                               * 00300005
*         R0: UNPREDICTABLE                                           * 00310005
*         R1: POINTER TO GETMAIN'D SAVEAREA                           * 00320005
*         R2-R11: UNPREDICTABLE                                       * 00330005
*         R12: ENTRY ADDRESS                                          * 00340005
*         R13: POINTER TO GETMAIN'D SAVEAREA                          * 00350005
*         R14: RETURN ADDRESS                                         * 00360005
*         R15: RETURN CODE FROM GETMAIN                               * 00370005
*                                                                     * 00380005
*     MACROS USED -                                                   * 00390005
*       IBM MACROS:                                                   * 00400005
*         GETMAIN, FREEMAIN, LOAD, WTO, ABEND, OPEN, EXTRACT,         * 00410005
*         QEDIT, MODCB, SHOWCB, SETLOGON, WAIT, CLOSE, IEZCIB         * 00420005
*       NON-IBM MACROS:                                               * 00430005
*         PROLOGUE, EPILOGUE, PHASE, CVH                              * 00440012
*                                                                     * 00450005
*     COPY MEMBERS -                                                  * 00460005
*       XTACMAP, XTASMAP.                                             * 00470005
*                                                                     * 00480005
*     INPUT -                                                         * 00490005
*       PARAMETER FROM EXEC STATEMENT.                                * 00500005
*                                                                     * 00510005
*     OUTPUT -                                                        * 00520005
*       ABNORMAL DUMPS AS DIRECTED BY SYSABEND; SNAP DUMPS ON         * 00530005
*       XTASNAP; LOG RECORDS DIRECTED TO XTALOGDS; AND VARIOUS        * 00540005
*       WTO'S AS NEEDED.                                              * 00550005
*                                                                     * 00560005
*     ABENDS -                                                        * 00570005
*       USER 101: FAILURE DURING LOAD OF HOST ALIAS/ADDRESS TABLE.    * 00580005
*       USER 105: FAILURE DURING OPEN OF VTAM ACB.                    * 00590005
*       USER 105: FAILURE DURING OPEN OF VTAM ACB.                    * 00600022
*       USER 106: FAILURE DURING SETLOGON START.                      * 00610005
*                                                                     * 00620005
*     MESSAGES ISSUED:                                                * 00630005
*      XTA0101  LOAD OF HOST ALIAS TABLE FAILED.                      * 00640005
*      XTA0105  ACB OPEN ERROR CODE X'00'.                            * 00650005
*      XTA0105  REPLY 'RETRY' OR 'TERMINATE'.                         * 00660022
*      XTA0106  SETLOGON (START) FAILED.                              * 00670005
*      XTA0108  TARA INITIALIZATION COMPLETE.                         * 00680005
*      XTA0110  MAINLINE WAIT PREMATURELY ENDED.                      * 00690005
*      XTA0143  INVALID COMMAND.                                      * 00700005
*      XTA0143  TARA      -TERMLU- -HOSTLU- -PKTS-                    * 00710005
*      XTA0143  TARA      PLUNAME  SLUNAME  B12345                    * 00720005
*      XTA0143  TARA NUMBER OF ACTIVE SESSIONS IS 000                 * 00730005
*      XTA0145  STOP REQUEST ACKNOWLEDGED.                            * 00740005
*      XTA0145  STOP IS IN PROGRESS.                                  * 00750005
*      XTA0190  SHUTDOWN IN PROGRESS.                                 * 00760005
*      XTA0145 TARA IS BEING SHUTDOWN BY OPERATOR REQUEST. PLEASE     * 00780005
*        LOGOFF.                                                      * 00790005
*                                                                     * 00800005
*     RETURN CODES:                                                   * 00810005
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00820005
*                                                                     * 00830005
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00870005
XTAMAIN  PROLOGUE MAIN                                                  00880005
         EJECT                                                          00890005
**                                                                      00900005
*                                                                       00910005
    PHASE  1.1 - LOAD THE HOST ALIAS TABLE                              00920005
*                                                                       00930005
**                                                                      00940005
         SPACE 1                                                        00950005
         LOAD  EP=XTAHALT,ERRET=LOADFAIL                                00960005
         ST    R0,CS#AHALT         SAVE THE ADDRESS OF THE HALT,        00970005
         B     PH1#2                 AND CONTINUE ON OUR MERRY WAY.     00980005
         SPACE 1                                                        00990005
LOADFAIL EQU   *                   O/S DRIVES THIS CODE ON BAD LOAD.    01000005
         WTO   'XTA0101  LOAD OF HOST ALIAS TABLE FAILED.',            X01010005
               ROUTCDE=(2,11),DESC=(6)                                  01020005
         ABEND 101,DUMP,,USER                                           01030005
         EJECT                                                          01040005
**                                                                      01050005
*                                                                       01060005
    PHASE  1.2 - OPEN THE LOG AND SNAP DATASETS                         01070005
*                                                                       01080005
**                                                                      01090005
         LA    R2,CS#LOG           GET ADDRESS OF LOG DCB               01100005
         OPEN  ((R2),(OUTPUT))     OPEN THE LOG DCB                     01110005
         LA    R2,CS#SNAP          GET ADDRESS OF SNAP DCB              01120005
         OPEN  ((R2),(OUTPUT))     OPEN THE SNAP DCB                    01130005
         EJECT                                                          01140005
**                                                                      01150005
*                                                                       01160005
    PHASE  1.4 - ESTABLISH LINK TO COMM TASK                            01170005
*                                                                       01180005
**                                                                      01190005
         SPACE                                                          01200005
*********************************************************************** 01210005
*                                                                     * 01220005
*   ANSWER                                                            * 01230005
*   +------+                               +-"BLOCK"                  * 01240005
*   | ADDR |--> +0+------+    +------+     |                          * 01250005
*   +------+      | ADDR |--->| ECB  |     V                          * 01260005
*               +4+------+    +------+     +-----------------/ /--+   * 01270005
*     "ORIGIN"->  | ADDR |---------------->| CIB            / /   |   * 01280005
*                 +------+                 +---------------/ /----+   * 01290005
*                |                                                    * 01300005
*                -THIS WORD (AT +4) IS REFERED TO AS THE "CIB ORIGIN" * 01310005
*                                                                     * 01320005
*   REGS 5 & 6 ARE SET TO POINT AS SHOWN FOR THE QEDIT MACROS         * 01330005
*                                                                     * 01340005
*********************************************************************** 01350005
         SPACE 1                                                        01360022
         EXTRACT ANSWER,FIELDS=COMM                                     01370005
         L     R4,ANSWER           GET POINTER TO ECB & CIB ADDRESSES   01380005
         L     R5,0(R4)            LOAD THE COM ECB ADDRESS             01390005
         ST    R5,CS#ECBL3         PUT COM ECB POINTER IN WAIT LIST     01400005
         OI    CS#ECBL3,X'80'      FLAG END OF LIST.                    01410005
         L     R6,4(R4)            ADDRESS OF FIRST BLOCK ON THE CHAIN  01420005
         LA    R6,0(R6)            CLEAR HI ORDER BYTE                  01430005
         LTR   R6,R6               DO I HAVE A CIB?                     01440005
         BZ    PH1#4A              NO, ZERO ADDR SAYS NOTHING IS THERE  01450005
         QEDIT ORIGIN=4(R4),BLOCK=(R6)     FREE THE CIB                 01460005
         SPACE 1                                                        01470022
PH1#4A   EQU   *                                                        01480021
         QEDIT ORIGIN=4(R4),CIBCTR=1   ALLOW 1 OUTSTANDING REQUEST      01490005
         EJECT                                                          01500005
**                                                                      01510005
*                                                                       01520005
    PHASE  1.5 - OPEN VTAM ACB                                          01530005
*                                                                       01540005
**                                                                      01550005
         LA    R2,CS#EXLST         POINT TO THE EXLST CB, THEN LOAD     01560005
         L     R3,CS#ALRDX           THE ADDRESS OF EACH OF OUR         01570005
         L     R4,CS#ALOGX           EXITS TO DYNAMICALLY ESTABLISH     01580005
         L     R5,CS#ALSTX           THEM ALL BEFORE WE OPEN THE ACB.   01590005
         L     R6,CS#ASYDX                                              01600005
         L     R7,CS#ATPNX                                              01610005
         MODCB AM=VTAM,            BUILD OUR LIST OF EXITS.            X01620005
               EXLST=(R2),                                             X01630005
               LERAD=(R3),                                             X01640005
               LOGON=(R4),                                             X01650005
               LOSTERM=(R5),                                           X01660005
               SYNAD=(R6),                                             X01670005
               TPEND=(R7)                                               01680020
         SPACE 1                                                        01690022
         LA    R2,CS#NIBEX         NOW, POINT TO THE EXIT LIST FOR      01700020
         L     R3,CS#ADFAX           NIBS, AND SET THE DFASY EXIT.      01710020
         MODCB AM=VTAM,                                                X01720020
               EXLST=(R2),                                             X01730020
               DFASY=(R3)                                               01740020
         SPACE 1                                                        01750022
OPENACB  EQU   *                                                        01760022
         LA    R4,CS#ACB           POINT TO OUR VTAM ACB AND...         01770005
         OPEN  ((R4))                ...OPEN IT.                        01780005
         SPACE                                                          01790005
         LTR   R15,R15             ENSURE THAT OUR OPEN WENT OK.        01800005
         BZ    PH1#6                                                    01810005
         SPACE                                                          01820005
         SHOWCB ACB=(R4),FIELDS=ERROR,AREA=FWD,LENGTH=L'FWD,AM=VTAM     01830005
         L     R5,FWD                                                   01840006
         CVH   R5,DBLWD                                                 01850006
         MVC   WTOACB,DBLWD+6                                           01860006
         LA    R1,WTO0105          MESSAGE  'OPEN ACB ERROR'            01870006
         WTO   MF=(E,(R1))         -------------------------            01880005
         SPACE 1                                                        01890022
ACBWTOR  EQU   *                                                        01900022
         XC    WTORECB,WTORECB                                          01910022
         WTOR  'XTA0105  REPLY ''RETRY'' OR ''TERMINATE''.',           +01920022
               WTOREPLY,L'WTOREPLY,WTORECB                              01930022
         WAIT  1,ECB=WTORECB                                            01940022
         TR    WTOREPLY,UPCASE                                          01950022
         CLC   =C'RETRY',WTOREPLY                                       01960022
         BE    OPENACB                                                  01970022
         CLC   =C'TERMINATE',WTOREPLY                                   01980022
         BE    PH1#48                                                   01990022
         B     ACBWTOR                                                  02000022
         EJECT                                                          02010005
**                                                                      02020005
*                                                                       02030005
    PHASE  1.6 - ISSUE SETLOGON                                         02040005
*                                                                       02050005
**                                                                      02060005
         LA    R3,CS#STLGN         POINT TO THE CONTROL BLOCKS THAT     02070005
         LA    R4,CS#ACB             SETLOGON USES.                     02080005
         SETLOGON RPL=(R3),        TELL VTAM WE'RE OPEN FOR BUSINESS.  X02090005
               ACB=(R4)                                                 02100005
         SPACE                                                          02110005
         LTR   R15,R15             ONCE AGAIN, WE ENSURE THAT VTAM      02120005
         BZ    PH1#7                 PROCESSED OUR REQUEST OK, AND QUIT 02130005
         SPACE 1                                                        02140005
         WTO   'XTA0106  SETLOGON (START) FAILED.',                    X02150005
               ROUTCDE=(2,11),DESC=(6)                                  02160005
         ABEND 0106,DUMP,,USER       IF NOT.                            02170005
         EJECT                                                          02180005
**                                                                      02190005
*                                                                       02200005
    PHASE  1.7 - CLEAR THE ECB'S                                        02210005
*                                                                       02220005
**                                                                      02230005
         SPACE 1                                                        02240005
         LA    R5,CS#ECBL          POINT TO ECB ADDRESS LIST            02250005
         SPACE 1                                                        02260005
*   THE LAST ECB IN THE LIST MUST BE THE COMM ECB                       02270005
*   AND I CANNOT CLEAR IT - THE SYSTEM WILL DO SO WHEN NEEDED           02280005
         SPACE 1                                                        02290005
ECBLOOP  L     R6,0(R5)            GET POINTER TO ECB ITSELF            02300005
         TM    0(R5),X'80'         END OF LIST? (AND COMM ECB POINTER)  02310005
         BO    PH1#8               YEP, ALL DONE                        02320005
         XC    0(4,R6),0(R6)       CLEAR THE ECB                        02330005
         LA    R5,4(R5)            NEXT ADDRESS PLEASE                  02340005
         B     ECBLOOP             ONE MORE TIME                        02350005
         EJECT                                                          02360005
**                                                                      02370005
*                                                                       02380005
    PHASE  1.8 - LOG THE SUCCESSFUL STARTUP                             02390005
*                                                                       02400005
**                                                                      02410005
         SPACE                                                          02420005
         WTO   'XTA0108  TARA INITIALIZATION COMPLETE.',               X02430005
               ROUTCDE=(2,11),DESC=(6)                                  02440005
         SPACE                                                          02450005
         LA    R1,XTA0108          POINT TO RECORD                      02460005
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           02470005
         BALR  R14,R15             WRITE THE RECORD                     02480005
         SPACE 3                                                        02490005
*-*-*-*-*-*-*-*-*-*-* END OF INITIALIZATION *-*-*-*-*-*-*-*-*-*-*-*-*-* 02500005
         EJECT                                                          02510005
**                                                                      02520005
*                                                                       02530005
    PHASE   1.9 - WAIT FOR AN EVENT                                     02540005
*                                                                       02550005
**                                                                      02560005
         WAIT  1,ECBLIST=CS#ECBL           WAIT FOR EVENTS              02570005
         EJECT                                                          02580005
**                                                                      02590005
*                                                                       02600005
    PHASE  1.10 - DISPATCH EVENT HANDLER                                02610005
*                                                                       02620005
**                                                                      02630005
         TM    CS#ECBTP,POSTED     WAS IT THE TPEND ECB?                02640005
         BO    PH1#20              GO TAKE CARE OF TPEND SHUTDOWN       02650005
         SPACE                                                          02660005
         L     R4,ANSWER           GET ADDRESS OF COMTASK PARMLIST      02670005
         L     R5,0(R4)            GET ADDRESS OF ECB                   02680005
         TM    0(R5),POSTED        WAS IT THE STOP/MODIFY ECB?          02690005
         BO    PH1#40              GO DO WHAT THE OPERATOR COMMANDS     02700005
         SPACE                                                          02710005
         TM    CS#ECBID,POSTED     WAS IT THE IDLE ECB?                 02720005
         BO    PH1#30              GO CHECK ON SHUTDOWN STATUS          02730005
         SPACE 2                                                        02740005
******                                                                  02750005
*                                                                       02760005
*  UH-OH - SOMETHING STRANGE HAPPENED.  DO WTO TO INFORM WORLD,         02770005
*  THEN WAIT AGAIN.  SINCE WE DON'T KNOW WHY THE WAIT ENDED, IT         02780005
*  COULD VERY WELL HAPPEN AGAIN, SO WE DELAY A SHORT WHILE TO PREVENT   02790005
*  THE OPERATOR FROM BEING DELUGED WITH THESE MESSAGES, AND TO GIVE     02800005
*  HIM AN OPPORTUNITY TO GET INTO THE CONSOLE TO ISSUE CANCEL.          02810005
*                                                                       02820005
         WTO   'XTA0110  MAINLINE WAIT PREMATURELY ENDED.',            X02830005
               ROUTCDE=(2,11),DESC=(6)                                  02840005
         STIMER WAIT,DINTVL=WTODELAY                                    02850005
         B     PH1#48                                                   02860009
         SPACE 3                                                        02870005
*-*-*-*-*-*-*-*-*-*-* END OF WAIT LOGIC *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02880005
         EJECT                                                          02890005
**                                                                      02900005
*                                                                       02910005
    PHASE  1.20 - LOG TPEND ACKNOWLEDGEMENT                             02920005
*                                                                       02930005
**                                                                      02940005
         LH    R2,CS#ECBTP+2       GET SHUTDOWN CODE                    02950005
         CVH   R2,DBLWD                                                 02960015
         MVC   XTA0120T+11(4),DBLWD                                     02970015
         LA    R1,XTA0120          POINT TO RECORD                      02980005
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           02990005
         BALR  R14,R15             WRITE THE RECORD                     03000005
         B     PH1#90              GO DO SHUTDOWN                       03010005
         SPACE 3                                                        03020005
*-*-*-*-*-*-*-*-*-*-* END OF TPEND PROCESSING *-*-*-*-*-*-*-*-*-*-*-*-* 03030005
         EJECT                                                          03040005
**                                                                      03050005
*                                                                       03060005
    PHASE  1.30 - CLEAR ECB - LOG STATUS                                03070005
*                                                                       03080005
**                                                                      03090005
         XC    CS#ECBID,CS#ECBID   CLEAR THE IDLE ECB                   03100005
         SPACE                                                          03110005
         LA    R1,XTA0130          POINT TO RECORD                      03120005
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           03130005
         BALR  R14,R15             WRITE THE RECORD                     03140005
         EJECT                                                          03150005
**                                                                      03160005
*                                                                       03170005
    PHASE  1.31 - IF NOT IN SHUTDOWN MODE --> 1.9                       03180005
*                                                                       03190005
**                                                                      03200005
         TM    CS#FLAG1,CS#STOPI   AM I SUPPOSED TO SHUTDOWN?           03210011
         BZ    PH1#9               NO, GO CONTINUE WAITING              03220005
         EJECT                                                          03230005
**                                                                      03240005
*                                                                       03250005
    PHASE  1.32 - LOG THE SHUTDOWN                                      03260005
*                                                                       03270005
**                                                                      03280005
         LA    R1,XTA0132          POINT TO RECORD                      03290005
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           03300005
         BALR  R14,R15             WRITE THE RECORD                     03310005
         SPACE 2                                                        03320005
         B     PH1#90              GO TERMINATE                         03330005
         SPACE 3                                                        03340005
*-*-*-*-*-*-*-*-*-* END OF IDLE CONDITION CHECKING  *-*-*-*-*-*-*-*-*-* 03350005
         EJECT                                                          03360005
**                                                                      03370005
*                                                                       03380005
    PHASE  1.40 - OPERATOR COMMAND PROCESSING - LOG THE EVENT           03390005
*                                                                       03400005
**                                                                      03410005
         L     R4,ANSWER           GET POINTER TO ECB & CIB ADDRESSES   03420005
         SPACE                                                          03430005
         L     R6,4(R4)            LOAD THE CIB ADDRESS                 03440005
         LA    R6,0(,R6)           CLEAR HI ORDER BYTE                  03450005
         USING IEZCOM,R6           GET ADDRESSABILITY TO CIB            03460005
         SLR   R8,R8                                                    03470015
         LH    R8,CIBDATLN         LENGTH OF CIB DATA                   03480017
         LA    R8,CIBDATA-CIBVERB(,R8)                                  03490017
         STC   R8,XTA0140+1        LENGTH OF LOG RECORD                 03500019
         BCTR  R8,0                DECREMENT FOR MOVE                   03510015
         EX    R8,MVC_CIB          PUT CIB DATA INTO RECORD             03520015
         SPACE                                                          03530005
         LA    R1,XTA0140          POINT TO RECORD                      03540005
         L     R15,CS#ALOGR        LOG WRITER ROUTINE ADDRESS           03550005
         BALR  R14,R15             WRITE THE RECORD                     03560005
         EJECT                                                          03570005
**                                                                      03580005
*                                                                       03590005
    PHASE  1.41 - SEGREGATE THE COMMANDS  START/STOP/MODIFY             03600005
*                                                                       03610005
**                                                                      03620005
         CLI   CIBVERB,CIBMODFY    ARE THE MODIFY BITS SET?             03630005
         BE    PH1#42              GO PROCESS MODIFY REQUEST            03640005
         SPACE                                                          03650005
         CLI   CIBVERB,CIBSTOP     IS THE STOP BIT SET?                 03660005
         BE    PH1#45              GO PROCESS NORMAL STOP REQUEST       03670005
         SPACE                                                          03680005
         B     PH1#43              GO TELL OPERATOR ITS INVALID         03690005
         EJECT                                                          03700005
**                                                                      03710005
*                                                                       03720005
    PHASE  1.42 - DETERMINE TYPE OF "MODIFY" REQUEST                    03730005
*                                                                       03740005
**                                                                      03750005
         LH    R3,CIBDATLN        GET COMMAND LENGTH                    03760005
         DROP  R6                                                       03770015
         LTR   R3,R3              IS THERE A COMMAND?                   03780005
         BZ    PH1#43             IF NOT, TELL HIM THAT'S INVALID       03790005
         SPACE                                                          03800005
         BCTR  R3,0               DECREMENT FOR EX INSTRUCTIONS         03810005
         EX    R3,MOVECIBD        MVC WORK(0),CIBDATA                   03820005
         TR    WORK,UPCASE                                              03830022
         SPACE                                                          03840005
         LA    R5,WORK            FIND THE FIRST SIGNIFICANT CHARACTER  03850005
         EX    R3,FINDSIG         TRT 0(0,R5),ALPHA#                    03860005
         BZ    PH1#43             IF NO GOOD CHAR, THEN INVALID         03870005
         LR    R7,R1              SAVE ADDR OF 1ST GOOD CHARACTER       03880005
         LR    R8,R7              CALCULATE LENGTH OF REMAINDER         03890005
         SR    R8,R5              NOW HAVE DISPLACEMENT TO SIG-CHAR     03900005
         SR    R3,R8              NOW HAVE LENGTH OF REMAINDER -1 IN R3 03910005
         LR    R5,R7              POINT TO START OF SIGNIFICANT STUFF   03920005
         CLC   =C'STOP',0(R7)     DID HE SAY STOP?                      03930005
         BNE   PH1#42A            NO, NOT 'STOP', GO ASK MORE QUESTIONS 03940005
         SPACE                                                          03950005
         LA    R5,4(R5)           POINT PAST "STOP"                     03960005
         LA    R8,3               CALCULATE THE REAL LENGTH...          03970005
         SR    R3,R8              ...OF THE REMAINING OPERAND           03980005
         LTR   R3,R3              ANYTHING LEFT?                        03990005
         BZ    PH1#45             NO, THERE IS NO OPERAND               04000005
         BCTR  R3,0               YES, DECREMENT LENGTH FOR EX          04010005
         EX    R3,FINDSIG         TRT 0(0,R5),ALPHA#                    04020005
         BZ    PH1#45             NO OPERAND FOUND - NORMAL STOP        04030005
         LR    R7,R1              POINTER TO OPERAND                    04040005
         CLC   =C'NOW',0(R7)      IMMEDIATE STOP REQUESTED?             04050005
         BE    PH1#90             GO DO IT                              04060005
         B     PH1#43             OPERAND INVALID = REQUEST INVALID     04070005
         SPACE 2                                                        04080005
PH1#42A  CLC   =C'DISPLAY',0(R7)  DID HE SAY DISPLAY?                   04090005
         BE    PH1#44             GO TAKE CARE OF THAT                  04100005
         SPACE                                                          04110005
*        ELSE, FALL THRU TO TELL HIM THE COMMAND IS INVALID             04120005
         EJECT                                                          04130005
**                                                                      04140005
*                                                                       04150005
    PHASE  1.43 - ISSUE "COMMAND NOT RECOGNIZED" MESSAGE TO OPERATOR    04160005
*                                                                       04170005
**                                                                      04180005
         SPACE                                                          04190005
         WTO   'XTA0143  INVALID COMMAND.',                            X04200005
               ROUTCDE=(2,11),DESC=(6)                                  04210008
         SPACE                                                          04220005
         B     PH1#48              GO FREE AND OBTAIN BUFFER            04230005
         EJECT                                                          04240005
**                                                                      04250005
*                                                                       04260005
    PHASE  1.44 - HANDLE "DISPLAY" REQUEST                              04270005
*                                                                       04280005
**                                                                      04290005
         SPACE 1                                                        04300005
         L     R11,CS#SSFST        GET POINTER TO FIRST SDB FROM THE    04310005
         USING XTASMAP,R11           QAB FOR SESSION STORAGE.  IF THIS  04320005
         LTR   R11,R11               POINTER IS ZERO, THEN THERE ARE NO 04330005
         BZ    SESSCT                SESSIONS, SO WE SKIP THE DETAIL.   04340005
         SPACE                                                          04350005
         WTO   'XTA0144  TARA      -TERMLU- -HOSTLU- -PKTS-     ',     X04360005
               ROUTCDE=(2,11),DESC=(6)                                  04370008
         SPACE                                                          04380005
SDBLOOP  EQU   *                                                        04390005
         MVC   WTOTERM,SS#PNODE      GET THE PRIMARY (TERMINAL) AND     04400006
         MVI   WTOHOST,C' '                                             04410022
         MVC   WTOHOST+1(L'WTOHOST-1),WTOHOST                           04420022
         TM    SS#FLAG1,SS#SACT        SESSION STORAGE, AND FILL IN THE 04430006
         BZ    NOSESS                  WTO TEMPLATE.                    04440006
         MVC   WTOHOST,SS#SNODE                                         04450006
         L     R7,SS#SNDCT           GET THE RECEIVE AND SEND COUNT FOR 04460006
         A     R7,SS#RCVCT             THE CURRENT SESSION, AND ADD     04470006
         CVD   R7,DBLWD                THEM TOGETHER TO GET # PACKETS.  04480006
         MVC   WTOPKTS,=X'402020202120'                                 04490006
         ED    WTOPKTS,DBLWD+5                                          04500006
         SPACE                                                          04510005
NOSESS   EQU   *                                                        04520005
         MVI   WTOSUSP,C' '                                             04530022
         MVC   WTOSUSP+1(L'WTOSUSP-1),WTOSUSP                           04540022
         TM    SS#FLAG1,SS#SUSPD                                        04550005
         BZ    NOTSUSP                                                  04560005
         MVC   WTOSUSP,=C'SUSPENDED'                                    04570006
         SPACE                                                          04580005
NOTSUSP  EQU   *                                                        04590005
         LA    R1,WTO0144B         DISPLAY THE FILLED-IN MESSAGE.       04600005
         WTO   MF=(E,(R1))                                              04610005
         L     R11,SS#NEXT         REPEAT FOR EACH SESSION STORAGE      04620005
         LTR   R11,R11               AREA ON THE QUEUE; THE LAST SDB    04630005
         BNZ   SDBLOOP               HAS ZERO IN THE 'NEXT' POINTER TO  04640005
         DROP  R11                 FLAG IT AS LAST IN QUEUE.            04650005
         SPACE                                                          04660005
SESSCT   EQU   *                                                        04670005
         L     R8,CS#SSNCT         AS A CROSS-CHECK, WE NOW DISPLAY THE 04680005
         CVD   R8,DBLWD              NUMBER OF SESSIONS WE HAVE KEPT    04690005
         MVC   WTOSESS,=X'40202120'    TRACK OF.                        04700006
         ED    WTOSESS,DBLWD+6                                          04710006
         LA    R1,WTO0144C                                              04720005
         WTO   MF=(E,(R1))                                              04730005
         B     PH1#48              GO FREE AND OBTAIN BUFFER            04740005
         EJECT                                                          04750005
**                                                                      04760005
*                                                                       04770005
    PHASE  1.45 - NORMAL "STOP" REQUESTED - NOTIFY USERS                04780005
*                                                                       04790005
**                                                                      04800005
         TM    CS#FLAG1,CS#STOPI   IS STOP IN PROGRESS ALREADY?         04810011
         BZ    PH1#45C             NO, THEN BRANCH                      04820005
         SPACE                                                          04830005
         WTO   'XTA0145  STOP IS IN PROGRESS.',                        X04840005
               ROUTCDE=(2,11),DESC=(6)                                  04850008
         SPACE                                                          04860005
         B     PH1#48              GO FREE AND OBTAIN BUFFER            04870005
         SPACE 2                                                        04880005
PH1#45C  OI    CS#FLAG1,CS#STOPI   TURN ON STOP FLAG                    04890011
         SPACE                                                          04900005
         WTO   'XTA0145  STOP REQUEST ACKNOWLEDGED.',                  X04910005
               ROUTCDE=(2,11),DESC=(6)                                  04920008
         SPACE                                                          04930005
         LA    R3,CS#STLGN         ADDRESS OF SETLOGON RPL              04940005
         LA    R4,CS#ACB           ADDRESS OF ACB                       04950005
         SETLOGON RPL=(R3),        DISABLE LOGON REQUESTS              X04960005
               ACB=(R4),                                               X04970005
               OPTCD=(QUIESCE,SYN)                                      04980005
         SPACE                                                          04990005
         USING XTASMAP,R11         USE R11 FOR SESSION STORAGE          05000005
         SPACE                                                          05010005
*        NOTE: R11 MUST POINT TO SDB FOR PSM'S SAKE WHEN SENDING MSGS   05020005
         L     R11,CS#SSFST        FIRST SESSION STORAGE AREA (POINTER) 05030005
         SPACE                                                          05040005
PH1#45A  LTR   R11,R11             IS THIS THE END-OF-QUE?              05050005
         BZ    PH1#46              GO PERFORM SHUTDOWN                  05060005
         SPACE                                                          05070005
         LA    R1,XTA0145          POINT TO MESSAGE                     05080005
         L     R15,CS#APSMR        PSM ROUTINE ADDRESS                  05090005
         BALR  R14,R15             SEND THE MESSAGE TO PRIMARY          05100005
         SPACE                                                          05110005
         L     R11,SS#NEXT         GET NEXT SSA POINTER                 05120005
         B     PH1#45A             GO LOOK AT NEXT SSA                  05130005
         SPACE                                                          05140005
         DROP  R11                 I DONT NEED SESSION STORAGE ANY MORE 05150005
         EJECT                                                          05160005
**                                                                      05170005
*                                                                       05180005
    PHASE  1.46 - LOG THE "STOP" OPERATION AND NOTIFY OPERATOR          05190005
*                                                                       05200005
**                                                                      05210005
         SPACE 1                                                        05220016
         L     R8,CS#SSNCT         SESSION COUNT                        05230005
         SPACE                                                          05240005
         LTR   R8,R8               DO WE HAVE ANY SESSIONS?             05250005
         BZ    PH1#90              NO, SO STOP NOW                      05260005
         SPACE                                                          05270005
         CVD   R8,DBLWD            MAKE SESSION COUNT READABLE          05280005
         MVC   WTOSESS,=X'40202120' EDIT MASK (999 IS TOO MUCH!)        05290007
         ED    WTOSESS,DBLWD+6 EDIT THE VALUE INTO MESSAGE              05300007
         SPACE                                                          05310005
         LA    R1,WTO0144C                                              05320007
         WTO   MF=(E,(R1))                                              05330005
         EJECT                                                          05340005
**                                                                      05350005
*                                                                       05360005
    PHASE  1.48 - FREE THE COMMAND INPUT BUFFER                         05370005
*                                                                       05380005
**                                                                      05390005
         SPACE 1                                                        05400005
*  WHEN THE LAST (OR, AS IN OUR CASE, ONLY) CIB IS FREED                05410005
*  THE SYSTEM WILL CLEAR THE COMM ECB FOR US.                           05420005
         SPACE 1                                                        05430005
         L     R4,ANSWER           GET POINTER TO ECB & CIB ADDRESSES   05440005
         L     R6,4(R4)            LOAD THE CIB ADDRESS (THE "BLOCK")   05450005
         LA    R6,0(,R6)           CLEAR HI ORDER BYTE                  05460005
         QEDIT ORIGIN=4(R4),BLOCK=(R6)      FREE THE CIB                05470005
         QEDIT ORIGIN=4(R4),CIBCTR=1        ALLOW ONE MORE MODIFY       05480005
         B     PH1#9                       GO WAIT SOME MORE            05490009
         SPACE 3                                                        05500005
*-*-*-*-*-*-*-*-*-*-* END OF COMTASK PROCESSING *-*-*-*-*-*-*-*-*-*-*-* 05510005
         EJECT                                                          05520005
**                                                                      05530005
*                                                                       05540005
    PHASE  1.90 - NOTIFY OPERATOR OF SHUTDOWN                           05550005
*                                                                       05560005
**                                                                      05570005
         SPACE 1                                                        05580005
         WTO   'XTA0190  SHUTDOWN IN PROGRESS.',                       X05590005
               ROUTCDE=(2,11),DESC=(6)                                  05600008
         EJECT                                                          05610005
**                                                                      05620005
*                                                                       05630005
    PHASE  1.91 - CLOSE THE ACB                                         05640005
*                                                                       05650005
**                                                                      05660005
         SPACE 1                                                        05670005
         LA    R3,CS#ACB                                                05680005
         CLOSE ((R3))                                                   05690005
         EJECT                                                          05700005
**                                                                      05710005
*                                                                       05720005
    PHASE  1.92 - CLOSE THE LOG AND SNAP DATASETS                       05730005
*                                                                       05740005
**                                                                      05750005
         SPACE 1                                                        05760005
         LA   R3,CS#LOG            GET THE LOG DCB ADDRESS              05770005
         CLOSE ((R3))              CLOSE THE LOG DATASET                05780005
         LA   R3,CS#SNAP           GET THE SNAP DCB ADDRESS             05790005
         CLOSE ((R3))              CLOSE THE SNAP DATASET               05800005
         EJECT                                                          05810005
**                                                                      05820005
*                                                                       05830005
    PHASE  1.99 - EXIT                                                  05840005
*                                                                       05850005
**                                                                      05860005
         SPACE 1                                                        05870005
         SR    R15,R15             ZERO RETURN CODE                     05880005
         EPILOGUE                  RETURN                               05890005
*********************************************************************** 05900005
*********************************************************************** 05910005
********                                                       ******** 05920005
********               END OF EXECUTABLE CODE                  ******** 05930005
********                                                       ******** 05940005
*********************************************************************** 05950005
*********************************************************************** 05960005
         EJECT                                                          05970005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 05980005
*                                                                     * 05990005
*  MISCELLANEOUS "NUTS AND BOLTS"                                     * 06000005
*                                                                     * 06010005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06020005
         SPACE 2                                                        06030005
WTOREPLY DS    CL10                                                     06040022
WTORECB  DS    F                                                        06050022
ANSWER   DS    F                   USED BY EXTRACT                      06060005
FWD      DS    F                   WORK AREA                            06070005
DBLWD    DS    D                   WORK AREA                            06080005
         SPACE                                                          06090005
STIMEINT DC    D'3000'             INTERVAL OF 30 SECONDS               06100005
WTODELAY DC    D'500'              INTERVAL OF 5.0 SECONDS              06110005
         SPACE                                                          06120005
WORK     DC    256XL1'FF'          WORK AREA                            06130005
         SPACE 2                                                        06140005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06150005
*                                                                     * 06160005
*  EXECUTE OBJECTS                                                    * 06170005
*                                                                     * 06180005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06190005
         SPACE 2                                                        06200005
         USING IEZCOM,R6           GET ADDRESSABILITY TO CIB            06210015
MVC_CIB  MVC   XTA0140T(0),CIBVERB                                      06220015
MOVECIBD MVC   WORK(0),CIBDATA                                          06230005
         DROP  R6                                                       06240015
FINDSIG  TRT   0(0,R5),ALPHA#                                           06250005
         SPACE 2                                                        06260005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06270005
*                                                                     * 06280005
*  LOG RECORDS                                                        * 06290005
*                                                                     * 06300005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06310005
         SPACE 2                                                        06320005
XTA0108  DC    YL1(USTATUS)        RECORD TYPE                          06330005
         DC    YL1(L'XTA0108T)     LENGTH OF TEXT                       06340007
XTA0108T DC    C'TARA STARTED'                                          06350015
         SPACE                                                          06360005
XTA0120  DC    YL1(USTATUS)        RECORD TYPE                          06370005
         DC    YL1(L'XTA0120T)     LENGTH OF TEXT                       06380005
XTA0120T DC    C'TPEND CODE=....'                                       06390015
         SPACE                                                          06400005
XTA0130  DC    YL1(USTATUS)        RECORD TYPE                          06410005
         DC    YL1(L'XTA0130T)     LENGTH OF TEXT                       06420005
XTA0130T DC    C'BEGIN IDLE CONDITION'                                  06430015
         SPACE                                                          06440005
XTA0132  DC    YL1(USTATUS)        RECORD TYPE                          06450005
         DC    YL1(L'XTA0132T)     LENGTH OF TEXT                       06460005
XTA0132T DC    C'NORMAL IDLE SHUTDOWN'                                  06470015
         SPACE                                                          06480005
XTA0140  DC    YL1(FSTATUS)        RECORD TYPE                          06490015
         DC    YL1(L'XTA0140T)     LENGTH OF TEXT                       06500005
XTA0140T DS    XL48                                                     06510016
         SPACE 2                                                        06520005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06530005
*                                                                     * 06540005
*  TERMINAL MESSAGES                                                  * 06550005
*                                                                     * 06560005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06570005
         SPACE 2                                                        06580005
XTA0145  DC    YL1(SYSMSG)         MESSAGE TYPE                         06590005
         DC    YL1(L'XTA0145T)     LENGTH OF MESSAGE                    06600005
XTA0145T DC    C'XTA0145  TARA IS BEING SHUTDOWN BY OPERATOR REQUEST. P-06610005
               LEASE LOGOFF.'                                           06620005
         SPACE 2                                                        06630005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06640005
*                                                                     * 06650005
*  VARIABLE TEXT OPERATOR MESSAGES                                    * 06660005
*                                                                     * 06670005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06680005
         SPACE 2                                                        06690005
WTO0105  WTO   'XTA0105  ACB OPEN ERROR CODE X''XX''.',                X06700005
               ROUTCDE=(2,11),DESC=(6),MF=L                             06710005
WTOACB   EQU   *-8,2                                                    06720006
         SPACE                                                          06730005
WTO0144B WTO   'XTA0144  TARA      TERMNAME HOSTNAME B12345 SUSPENDED',X06740005
               ROUTCDE=(2,11),DESC=(6),MF=L                             06750005
WTOTERM  EQU   *-38,8                                                   06760006
WTOHOST  EQU   *-29,8                                                   06770006
WTOPKTS  EQU   *-20,6                                                   06780006
WTOSUSP  EQU   *-13,9                                                   06790006
         SPACE                                                          06800005
WTO0144C WTO   'XTA0144  TARA NUMBER OF ACTIVE SESSIONS IS.....',      X06810006
               ROUTCDE=(2,11),DESC=(6),MF=L                             06820005
WTOSESS  EQU   *-9,4                                                    06830006
         SPACE 2                                                        06840005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06850005
*                                                                     * 06860005
*  TRANSLATE TABLES                                                   * 06870005
*                                                                     * 06880005
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 06890005
         SPACE 2                                                        06900005
ALPHA#   EQU   *  0 1 2 3 4 5 6 7 8 9 A B C D E F                       06910005
         DC    X'00000000000000000000000000000000' 0                    06920005
         DC    X'00000000000000000000000000000000' 1                    06930005
         DC    X'00000000000000000000000000000000' 2                    06940005
         DC    X'00000000000000000000000000000000' 3                    06950005
         DC    X'00000000000000000000000000000000' 4                    06960005
         DC    X'00000000000000000000000000000000' 5                    06970005
         DC    X'00000000000000000000000000000000' 6                    06980005
         DC    X'00000000000000000000000000000000' 7                    06990005
         DC    X'00000000000000000000000000000000' 8                    07000005
         DC    X'00000000000000000000000000000000' 9                    07010005
         DC    X'00000000000000000000000000000000' A                    07020005
         DC    X'00000000000000000000000000000000' B                    07030005
         DC    X'00C1C2C3C4C5C6C7C8C9000000000000' C  UPPER CASE ALPHA  07040005
         DC    X'00D1D2D3D4D5D6D7D8D9000000000000' D                    07050005
         DC    X'0000E2E3E4E5E6E7E8E9000000000000' E                    07060005
         DC    X'F0F1F2F3F4F5F6F7F8F9000000000000' F  NUMERIC DIGITS    07070005
         SPACE 2                                                        07080023
UPCASE   EQU   *                                                        07090022
*     0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF  07100022
 DC C'----------------------------------------------------------------' 07110022
 DC C' ---------¢.<(+|.---------!$*);¬-/--------¦,%_>?---------`:#@.="' 07120022
 DC C'-ABCDEFGHI-------JKLMNOPQR-------~STUVWXYZ----------------------' 07130022
 DC C'{ABCDEFGHI------}JKLMNOPQR------\-STUVWXYZ------0123456789|-----' 07140022
         ORG   UPCASE+80                                                07150023
         DC    X'50'    AMPERSAND                                       07160022
         ORG   UPCASE+125                                               07170023
         DC    X'7D'    SINGLE QUOTE                                    07180022
         ORG                                                            07190022
         EJECT                                                          07200023
IEZCOM   DSECT                                                          07210005
         IEZCIB                                                         07220005
         END   XTAMAIN                                                  07230005