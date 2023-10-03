XTAPSMR  TITLE 'TARA PRIMARY SCREEN MANAGER ROUTINE - (10.0)'           00010006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020006
*                                                                     * 00030006
*     MODULE NAME - XTAPSMR                                           * 00040006
*                                                                     * 00050006
*     FUNCTIONAL DESCRIPTION - XTAPSMR IS THE MODULE WHICH            * 00060006
*       PROCESSES ALL OUTPUT TO THE PRIMARY SESSION (3270).           * 00070006
*                                                                     * 00080006
*     DRIVER - THIS ROUTINE IS ENTERED VIA BAL(R).                    * 00090006
*                                                                     * 00100006
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAPSMR.              * 00110006
*                                                                     * 00120006
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130006
*       OF THE EPILOGUE MACRO.                                        * 00140006
*                                                                     * 00150006
*     REGISTERS ON ENTRY -                                            * 00160006
*       BEFORE PROLOGUE:                                              * 00170006
*         R0:  UNPREDICTABLE                                          * 00180006
*         R1:  POINTER TO PARAMETER LIST                              * 00190006
*         R2-R8:  UNPREDICTABLE                                       * 00200006
*         R9:  POINTER TO CURRENT RPL                                 * 00210006
*         R10: POINTER TO COMMON STORAGE AREA                         * 00220006
*         R11: POINTER TO SESSION STORAGE AREA                        * 00230006
*         R12: CALLER'S ENTRY POINT                                   * 00240006
*         R13: SAVE AREA                                              * 00250006
*         R14: RETURN ADDRESS                                         * 00260006
*         R15: ENTRY ADDRESS                                          * 00270006
*       AFTER PROLOGUE:                                               * 00280006
*         R0:  UNPREDICTABLE                                          * 00290006
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00300006
*         R2-R6: UNPREDICTABLE                                        * 00310006
*         R7:  POINTER TO PARAMETER LIST                              * 00320006
*         R8:  UNPREDICTABLE                                          * 00330006
*         R9:  POINTER TO CURRENT RPL                                 * 00340037
*                NOTE: SUBSEQUENT TO PHASE 10.2, R9 IS A              * 00350037
*                POINTER TO THE ACTIVE SEND BUFFER.                   * 00360037
*         R10: POINTER TO COMMON STORAGE AREA                         * 00370006
*         R11: POINTER TO SESSION STORAGE AREA                        * 00380006
*         R12: ENTRY ADDRESS                                          * 00390006
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00400006
*         R14: RETURN ADDRESS                                         * 00410006
*         R15: ENTRY ADDRESS                                          * 00420006
*                                                                     * 00430006
*     MACROS USED -                                                   * 00440006
*       IBM MACROS:                                                   * 00450006
*         SEND, FREEMAIN, GETMAIN, MODCB                              * 00460006
*       NON-IBM MACROS:                                               * 00470006
*         EPILOGUE, PHASE, PROLOGUE, SBA, ICSR, EUA, SF               * 00480006
*                                                                     * 00490006
*     COPY MEMBERS:                                                   * 00500006
*       XTACMAP, XTASMAP                                              * 00510006
*                                                                     * 00520006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00530006
         EJECT                                                          00540006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00550006
*                                                                     * 00560006
*     INPUT:                                                          * 00570006
*       ON ENTRY, REGISTER 1 POINTS TO THE FOLLOWING PARAMETER LIST:  * 00580006
*                                                                     * 00590006
*          +--------+--------+------------//------------+             * 00600006
*          |  TYPE  | LENGTH |         MESSAGE          |             * 00610006
*          +--------+--------+------------//------------+             * 00620006
*                                                                     * 00630006
*                            |<-------- LENGTH -------->|             * 00640006
*                                                                     * 00650006
*                                                                     * 00660006
*       BITS 4-7 OF THE FIRST BYTE INDICATE WHAT KIND OF MESSAGE      * 00670006
*       PROCESSING IS REQUIRED:                                       * 00680006
*                                                                     * 00690006
*   LOW-ORDER BIT-> (BIT 7) = INITIAL SCREEN                          * 00700006
*                   (BIT 6) = SYSTEM MESSAGE                          * 00710006
*                   (BIT 5) = ECHO                                    * 00720006
*                   (BIT 4) = DATA                                    * 00730006
*                                                                     * 00740006
*       BITS 0-3 OF THE FIRST BYTE INDICATE VARIOUS OPTIONAL          * 00750006
*       PROCESSING OPTIONS:                                           * 00760006
*                                                                     * 00770006
*                   (BIT 3) = NOT USED AT PRESENT                     * 00780006
*                   (BIT 2) = SOUND THE AUDIBLE ALARM                 * 00790006
*                   (BIT 1) = BEGIN A NEW LINE                        * 00800006
*    HI-ORDER BIT-> (BIT 0) = CLEAR THE INPUT AREA                    * 00810006
*                                                                     * 00820006
*     OUTPUT:                                                         * 00830006
*       THE MESSAGE IS DISPLAYED ON THE SCREEN OF THE PRIMARY SLU.    * 00840006
*                                                                     * 00850006
*     ABENDS:                                                         * 00860006
*       NO USER ABENDS ISSUED BY THIS MODULE.                         * 00870006
*                                                                     * 00880006
*     MESSAGES ISSUED:                                                * 00890006
*       NO SYSTEM MESSAGES ARE ISSUED BY THIS MODULE.                 * 00900006
*                                                                     * 00910006
*     RETURN CODES:                                                   * 00920006
*       08  -  MESSAGE TOO LONG: MESSAGE TRUNCATED AND SENT.          * 00930006
*       12  -  REQUEST INVALID - MESSAGE NOT SENT.                    * 00940023
*       16  -  NO BUFFERS AVAILABLE - MESSAGE NOT SENT.               * 00950023
*                                                                     * 00960006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01000006
         EJECT                                                          01010006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01020006
*                                                                     * 01030006
*     HERE'S THE SCOOP: THERE ARE FOUR DIFFERENT KINDS OF DATA        * 01040006
*     WE CAN BE ASKED TO SEND TO THE PRIMARY (3270) -                 * 01050006
*                                                                     * 01060006
*      . DATA RECEIVED FROM THE SECONDARY (DATA)                      * 01070006
*      . DATA RECEIVED FROM THE PRIMARY (ECHO)                        * 01080006
*      . MESSAGES FROM TARA (SYSTEM MESSAGE)                          * 01090006
*      . THE INITIAL SCREEN FORMATTING (INITIAL SCREEN)               * 01100006
*                                                                     * 01110006
*     NOW LET'S LOOK AT THE RPL'S WE HAVE AT OUR DISPOSAL: THERE      * 01120006
*     IS AN RPL WHICH IS USED FOR RECEIVES FROM THE PRIMARY AND       * 01130006
*     SENDS TO THE SECONDARY - THIS IS CALLED THE 'PRIMARY' RPL;      * 01140006
*     ANOTHER RPL IS USED FOR SENDS TO THE PRIMARY AND RECEIVES       * 01150006
*     FROM THE SECONDARY - THIS IS THE 'SECONDARY' RPL; THERE IS      * 01160006
*     ONE MORE RPL, A SPECIAL ONE THAT IS ONLY USED FOR SENDS TO      * 01170006
*     THE PRIMARY - IT IS CALLED THE 'ECHO' RPL.                      * 01180006
*                                                                     * 01190006
*                               +----+                                * 01200006
*           +-------------------|SEC |<----------------+              * 01210006
*           V                   |RPL |                 |              * 01220006
*        +-----+                +----+              +-----+           * 01230006
*        | PRI |                                    | SEC |           * 01240006
*        | SLU |                                    | SLU |           * 01250006
*        +-----+                +----+              +-----+           * 01260006
*          A |                  |PRI |                 A              * 01270006
*          | +------------------|RPL |-----------------+              * 01280006
*          |                    +----+                                * 01290006
*          |                                                          * 01300006
*          |                                                          * 01310006
*        +----+                                                       * 01320006
*        |ECHO|                                                       * 01330006
*        |RPL |                                                       * 01340006
*        +----+                                                       * 01350006
*                                                                     * 01360006
*     BY USING THE SAME RPL FOR ALL TRAFFIC IN A SINGLE DIRECTION,    * 01370006
*     WE IMPLEMENT A FORM OF 'PACING'. PSM IS ONLY INVOLVED           * 01380006
*     IN TRAFFIC BOUND FOR THE PRIMARY, AND DATA COMING FROM THE      * 01390006
*     SECONDARY MUST GO VIA THE SECONDARY RPL. BUT IF DATA FROM SOME  * 01400006
*     OTHER SOURCE IS BOUND FOR THE PRIMARY, WE MUST USE ANOTHER      * 01410006
*     RPL - THAT'S WHERE THE ECHO RPL COMES IN.                       * 01420006
*                                                                     * 01430006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01440006
         EJECT                                                          01450006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01460006
*                                                                     * 01470006
*     NOTE THAT ANY 3270 DEVICE WITH A PRESENTATION SPACE OF MINIMUM  * 01480006
*     DIMENSIONS (24 LINES X 80 COLUMNS) IS SUPPORTED.  IN ORDER      * 01490006
*     TO ACCOMPLISH THIS, ALL BUFFER ADDRESSES ARE CALCULATED         * 01500006
*     DYNAMICALLY AND THE APPROPRIATE BUFFER ADDRESSING TECHNIQUE     * 01510006
*     IS USED.  XTAPSMR IS THE ONLY MODULE IN TARA WHICH HAS (OR      * 01520006
*     NEEDS) AN AWARENESS OF THE DEVICE ARCHITECTURE.  BY ROUTING     * 01530006
*     ABSOLUTELY ALL REQUESTS FOR TERMINAL OUTPUT THROUGH XTAPSMR,    * 01540006
*     IT IS POSSIBLE TO MAINTAIN SOME SEMBLANCE OF PRESENTATION       * 01550006
*     SPACE INTEGRITY.                                                * 01560006
*                                                                     * 01570006
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 01580006
         EJECT                                                          01590006
XTAPSMR  PROLOGUE SUBR=PSM                                              01600006
         XC    SS#WORD4,SS#WORD4   SET RETURN CODE TO ZERO              01610017
         EJECT                                                          01620006
**                                                                      01630006
*                                                                       01640006
    PHASE  10.1 - IF NULL REQUEST --> 10.10                             01650006
*                                                                       01660006
**                                                                      01670006
         NI    SS#FLAG2,X'FF'-SS#REENT   RESET RE-ENTRY BIT.            01680006
         LTR   R7,R7               IF THE PARAMETER REGISTER IS EMPTY,  01690006
         BZ    PH10#10               JUST GO PROCESS WAITERS.           01700006
         SPACE 1                                                        01710006
         TM    SS#FLAG1,SS#SUSPD   IGNORE ANY REQUESTS DESTINED FOR     01720006
         BO    PH10#99               FOR SUSPENDED SESSIONS.            01730006
         EJECT                                                          01740006
**                                                                      01750006
*                                                                       01760006
    PHASE  10.2 - FIND AND INITIALIZE A SEND BUFFER                     01770006
*                                                                       01780006
**                                                                      01790006
         LA    R9,SS#SBPL               POINT TO THE SEND BUFFER POOL.  01800037
         LA    R5,SS#SBCNT-1            LOAD NUMBER OF BUFFERS IN POOL. 01810006
         SPACE 1                                                        01820006
FINDSB   EQU   *                                                        01830006
*******                                                                 01840006
*                                                                       01850006
*       +--THIS BIT ON IN SEND-BUFFERS WHICH ARE IN USE.                01860006
*       V                                                               01870006
*     +-0-0-0-0-0-0-0-0-+--//                                           01880006
*     |                 |                                               01890006
*     +-0-1-2-3-4-5-6-7-+--//                                           01900006
*                                                                       01910006
         TM    0(R9),SS#SBIU            IF THE SEND BUFFER IS NOT IN    01920037
         BZ    GOTSB                      USE, GO USE IT.               01930006
         LA    R9,256(R9)               IF IN USE, TRY ANOTHER SB.      01940037
         BCT   R5,FINDSB                IF WE'RE AT THE END OF THE ROAD 01950006
         MVI   SS#WORD4+3,16              SAY MESSAGE WAS DISCARDED.    01960017
         B     PH10#99                  GO RETURN IN DEFEAT.            01970006
         EJECT                                                          01980006
*********************************************************************** 01990006
*                                                                     * 02000006
*  THE ANATOMY OF A SEND BUFFER:                                      * 02010006
*                                                                     * 02020006
*                 LENGTH OF    POINTER TO NEXT      BEGINNING OF      * 02030006
*                   DATA     BUFFER (INITIALLY 0)   BUFFER PROPER     * 02040006
*                    |                 |            |                 * 02050006
*               ----------- ----------------------- V                 * 02060006
*  +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----  * 02070006
*  |     |     |           |                       | CMD | WCC |      * 02080006
*  +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----  * 02090006
*  |       \                                                          * 02100006
*  |         \                                                        * 02110006
*  |           \                                                      * 02120006
*  |             \                                                    * 02130006
*  |               \                                                  * 02140006
*  +-0-0-0-0-0-0-0-0-+                                                * 02150006
*  |                 |                                                * 02160006
*  +-0-1-2-3-4-5-6-7-+                                                * 02170006
*    | |     ---+---                                                  * 02180006
*    | |        |                                                     * 02190006
*    | |        +-- TYPE-OF-MESSAGE INDICATOR                         * 02200006
*    | +-- 1=TURN ON PACING AFTER THIS BUFFER IS SUCCESSFULLY SENT    * 02210006
*    +---- 1=BUFFER IS IN USE  0=BUFFER IS FREE                       * 02220006
*                                                                     * 02230006
*********************************************************************** 02240006
         SPACE 2                                                        02250006
GOTSB    EQU   *                                                        02260006
         XC    0(256,R9),0(R9)          CLEAR THE BUFFER.               02270037
         OI    0(R9),SS#SBIU            MARK THE BUFFER IN-USE.         02280037
         ICM   R5,15,SS#SBLST           WHERE IS THE LAST IN THE Q?     02290006
         ST    R5,SS#WORD3              (SAVE IN CASE WE MUST DELETE.)  02300006
         BZ    NONEUSED                 IF NONE IN Q YET, SKIP THE...   02310006
         ST    R9,4(R5)                 ADD TO END OF Q.                02320037
         B     NOTFIRST                                                 02330006
         SPACE 1                                                        02340006
NONEUSED EQU   *                                                        02350006
         ST    R9,SS#SBFST              SHOW WE'RE FIRST ON Q.          02360037
         SPACE 1                                                        02370006
NOTFIRST EQU   *                                                        02380006
         ST    R9,SS#SBLST              SHOW WE'RE NOW LAST ON Q.       02390037
         LA    R4,8(R9)                 POINT TO BUFFER PROPER.         02400037
         MVI   0(R4),X'F1'              INSERT WRITE COMMAND,           02410006
         MVI   1(R4),X'C2'                AND WRITE CONTROL CHARACTER.  02420006
         LA    R4,2(R4)                 POINT TO DATA PART OF BUFFER.   02430006
         ST    R4,SS#BUFPT              SAVE IT.                        02440006
         EJECT                                                          02450006
**                                                                      02460006
*                                                                       02470006
    PHASE  10.3 - PROCESS OPTIONS                                       02480006
*                                                                       02490006
**                                                                      02500006
         TM    0(R7),CLEARIPT           IS THE INPUT AREA TO BE CLEARED 02510006
         BZ    NOCLRIPT                 NOPE, SKIP THAT ORDER.          02520006
         OI    9(R9),RSTMDT             SET 'RESET MDT' IN WCC.         02530036
         L     R6,SS#BUFPT              GET POINTER TO FREE BUFFER AREA 02540006
         MVC   0(LCLEARIT,R6),CLEARIT   INSERT ORDER TO CLEAR I/P AREA  02550006
         L     R5,SS#COLS                                               02560006
         M     R4,SS#ROWS                                               02570006
         S     R5,SS#COLS                                               02580006
         S     R5,SS#COLS                                               02590006
         AH    R5,=H'8'                                                 02600006
         BAL   R14,ABSCNVRT                                             02610006
         STCM  R5,B'0011',1(R6)                                         02620006
         LA    R6,LCLEARIT(R6)          POINT PAST CLEAR ORDER.         02630006
         ST    R6,SS#BUFPT              SAVE UPDATED BUFFER POINTER.    02640006
         SPACE 1                                                        02650006
NOCLRIPT EQU   *                                                        02660006
         TM    0(R7),AALARM             SHOULD WE SOUND AUDIBLE ALARM?? 02670006
         BZ    NOAALARM                 NOPE, LEAVE BIT CLEARED.        02680007
         OI    9(R9),ALARM              SET AUDIBLE ALARM BIT           02690036
         SPACE 1                                                        02700006
NOAALARM EQU   *                                                        02710007
         TM    0(R7),CLEARDTA      CHECK FOR THE 'CLEAR DATA AREA'      02720007
         BZ    NOCLRDTA              OPTION.                            02730007
         L     R6,SS#BUFPT                                              02740011
         SLR   R5,R5               IF CHOSEN, DO AN SBA TO THE FIRST    02750007
         BAL   R2,PUTSBA             LOCATION OF THE DATA AREA, THEN    02760007
         MVI   0(R6),RA              AN RA TO THE START OF THE NEXT     02770007
         L     R5,SS#COLS            -TO-LAST LINE OF THE SCREEN.       02780007
         M     R4,SS#ROWS                                               02790007
         S     R5,SS#COLS                                               02800007
         S     R5,SS#COLS                                               02810007
         BAL   R14,ABSCNVRT                                             02820007
         STCM  R5,B'0011',1(R6)                                         02830007
         MVI   3(R6),X'00'                                              02840007
         LA    R6,4(R6)            KEEP TRACK OF THE BUFFER POINTER.    02850007
         ST    R6,SS#BUFPT                                              02860007
         B     NONEWLNE                                                 02870015
         SPACE 1                                                        02880007
NOCLRDTA EQU   *                                                        02890007
         TM    0(R7),NEWLINE       IF NEWLINE WAS NOT REQUESTED,        02900006
         BZ    NONEWLNE              DATA IS PUT AT CSP.                02910006
         SPACE 1                                                        02920006
         SLR   R4,R4               IF NEWLINE WAS REQUESTED, WE         02930006
         LH    R5,SS#CSP             WILL UPDATE CSP SO THAT IT         02940006
         D     R4,SS#COLS            POINTS TO THE FIRST POSITION       02950006
         LTR   R4,R4                 OF THE NEXT AVAILABLE LINE IN      02960006
         BZ    NOREMAIN              THE DATA AREA OF THE SCREEN.       02970006
         SPACE 1                                                        02980006
         M     R4,SS#COLS          IF CSP WAS ALREADY AT THE START OF   02990006
         A     R5,SS#COLS            A LINE, IT IS LEFT UNDISTURBED.    03000006
         SLR   R4,R4                                                    03010006
         D     R4,SS#DAREA         ENSURE THAT WE WRAP WHEN ON THE      03020006
         STH   R4,SS#CSP             LAST LINE OF THE DATA AREA.        03030006
         SPACE 1                                                        03040006
NOREMAIN EQU   *                                                        03050006
         L     R6,SS#BUFPT         SINCE THIS IS EQUIVALENT TO A LF     03060006
         MVC   0(7,R6),ORDERS        CHARACTER BEING PROCESSED, WE      03070006
         LH    R5,SS#CSP             MUST ENSURE THAT THE LINE WE JUST  03080006
         BAL   R14,RELCNVRT          CAME TO IS CLEARED.                03090006
         STCM  R5,B'0011',1(R6)                                         03100006
         LH    R5,SS#CSP                                                03110006
         A     R5,SS#COLS                                               03120006
         BAL   R14,RELCNVRT                                             03130006
         STCM  R5,B'0011',4(R6)                                         03140006
         LA    R6,7(R6)            BE SURE TO KEEP THE O/P BUFFER       03150006
         ST    R6,SS#BUFPT           POINTER UP TO DATE!!               03160006
         SPACE 1                                                        03170006
NONEWLNE EQU   *                                                        03180006
         MVN   0(1,R9),0(R7)       GET TYPE-OF-MESSAGE INDICATOR        03190036
         EJECT                                                          03200006
**                                                                      03210006
*                                                                       03220006
    PHASE  10.4 - DISPATCH REQUESTED FORMATTER                          03230006
*                                                                       03240006
**                                                                      03250006
         TM    0(R7),SS#ECHO       IS IT AN ECHO??                      03260006
         BO    PH10#5                                                   03270006
         TM    0(R7),SS#DATA       IS IT DATA?                          03280006
         BO    PH10#6                                                   03290006
         TM    0(R7),SS#ISCR       IS IT INITIAL SCREEN?                03300006
         BO    PH10#7                                                   03310006
         TM    0(R7),SS#SMSG       IS IT A SYSTEM MESSAGE?              03320006
         BO    PH10#8                                                   03330006
         MVI   SS#WORD4+3,12              SAY INVALID REQUEST.          03340018
         NI    0(R8),X'FF'-SS#SBIU      FREE THE SEND BUFFER WE HAD     03350006
         ICM   R5,B'1111',SS#WORD3      ALLOCATED BY TURNING OFF THE    03360006
         ST    R5,SS#SBLST              IN-USE BIT, AND DEQUEUEING IT.  03370006
         BZ    ONLY                DON'T TRY TO ZERO FORWARD POINTER IF 03380006
         XC    4(4,R5),4(R5)         THIS WAS THE FIRST IN Q.           03390006
         B     PH10#99             GO RETURN.                           03400006
         SPACE 1                                                        03410006
ONLY     EQU   *                                                        03420006
         ST    R5,SS#SBFST         IF WE WERE 'ONLY' ON Q, 'FIRST'      03430006
         B     PH10#99               POINTER MUST BE RESTORED TOO.      03440006
         EJECT                                                          03450006
*********************************************************************** 03460006
*                                                                     * 03470006
*  BEFORE WE GO ANY FURTHER, I'D LIKE TO TAKE JUST A MINUTE TO REVIEW * 03480006
*  A COUPLE OF INSTRUCTIONS USED HEAVILY IN THE FOLLOWING CODE:       * 03490006
*  M (MULTIPLY) AND D (DIVIDE). (THIS MAY RELIEVE YOU OF THE NEED TO  * 03500006
*  GO SCURRYING FOR YOUR S/370 PRINCIPLES OF OPERATION.) REMEMBER     * 03510006
*  THAT THE FIRST OPERAND MUST SPECIFY AN EVEN-ODD REGISTER PAIR;     * 03520006
*  THE SECOND OPERAND IS ALWAYS A 32-BIT QUANTITY - IT MAY BE IN A    * 03530006
*  REGISTER, OR IN A FULLWORD OF STORAGE. NOTE ESPECIALLY THAT THE    * 03540006
*  FACT THAT A DIVIDE RESULTS IN AN INTEGER QUOTIENT AND A REMAINDER  * 03550006
*  IS EXPLOITED BY THIS CODE.                                         * 03560006
*                                                                     * 03570006
*  DIVIDE...                                                          * 03580006
*                            R1                  R2 -OR- D2(X2,B2)    * 03590006
*                   EVEN            ODD                               * 03600006
*           +----------------+----------------+  +----------------+   * 03610006
*   BEFORE: |             DIVIDEND            |  |    DIVISOR     |   * 03620006
*           +----------------+----------------+  +----------------+   * 03630006
*                                                                     * 03640006
*           +----------------+----------------+  +----------------+   * 03650006
*    AFTER: |   REMAINDER    |    QUOTIENT    |  |    DIVISOR     |   * 03660006
*           +----------------+----------------+  +----------------+   * 03670006
*                                                                     * 03680006
*                                                                     * 03690006
*  MULTIPLY...                                                        * 03700006
*                            R1                          R2           * 03710006
*                   EVEN            ODD                               * 03720006
*           +----------------+----------------+  +----------------+   * 03730006
*   BEFORE: | ////////////// |  MULTIPLICAND  |  |   MULTIPLIER   |   * 03740006
*           +----------------+----------------+  +----------------+   * 03750006
*                                                                     * 03760006
*           +----------------+----------------+  +----------------+   * 03770006
*    AFTER: |             PRODUCT             |  |   MULTIPLIER   |   * 03780006
*           +----------------+----------------+  +----------------+   * 03790006
*                                                                     * 03800006
*********************************************************************** 03810006
         EJECT                                                          03820006
**                                                                      03830006
*                                                                       03840006
    PHASE  10.5 - ECHO                                                  03850006
*                                                                       03860006
**                                                                      03870006
         SPACE 1                                                        03880006
         NI    SS#FLAG2,X'FF'-SS#HOLDD  LET THE BITS FLOW...            03890006
         SPACE 1                                                        03900006
*********************************************************************** 03910006
*                                                                     * 03920006
*   NOTE THAT ECHO PROCESSING ALSO CAUSES THE INPUT AREA TO BE        * 03930006
*   CLEARED AND, FOR COMMANDS, A NEW LINE TO BE STARTED.  THESE       * 03940006
*   ACTIONS ARE TRIGGERED BY BITS SET BY THE 'ECHO' EQUATE, AND       * 03950006
*   SO ARE HANDLED ELSEWHERE.                                         * 03960006
*                                                                     * 03970006
*********************************************************************** 03980006
         EJECT                                                          03990006
**                                                                      04000006
*                                                                       04010006
    PHASE  10.6 - DATA: PUT MESSAGE IN DATA AREA OF SCREEN              04020006
*                                                                       04030006
**                                                                      04040006
         SPACE 1                                                        04050006
*********************************************************************** 04060006
*                                                                     * 04070006
*  BESIDES GRAPHIC CHARACTERS, 'CONTROL CHARACTERS' MAY BE RECEIVED   * 04080006
*  FROM THE REMOTE HOST. MOST OF THEM ARE MEANINGLESS IN THIS         * 04090006
*  ENVIRONMENT, AND ARE FILTERED OUT BY THE SECONDARY RECEIVE RPL     * 04100006
*  EXIT (XTASRRX). THE FOLLOWING 'CONTROL CHARACTERS', HOWEVER, HAVE  * 04110006
*  MEANINGS WHICH CAN BE INTERPRETED GRAPHICALLY, AND ARE THUS        * 04120006
*  SPECIALLY TREATED BY THIS ROUTINE:                                 * 04130006
*                                                                     * 04140006
*    ..............THE EBCDIC CONTROL CODE AS RECEIVED FROM NPSI      * 04150006
*    |   ..........WHAT THE EBCDIC CODE IS TRANSLATED TO BY XTASRRX   * 04160006
*    |   |   ......WHAT THE CONTROL CHARACTER MEANS                   * 04170006
*    |   |   |   ..HOW THAT CONTROL CODE IS HANDLED BY XTAPSMR        * 04180006
*    |   |   |   |                                                    * 04190006
*    V   V   V   V                                                    * 04200006
*   05  40  HT   ONE POSITION IS SKIPPED (HANDLED BY XTASRRX)         * 04210006
*   0B  10  VT   SAME AS LF                                           * 04220006
*   0C  04  FF   SCREEN IS CLEARED AND ALL PREVIOUS TEXT DISCARDED    * 04230006
*   0D  08  CR   BUFFER POSITION SET TO NEXT LOWER MULTIPLE OF 80     * 04240006
*   16  0C  BS   BACK UP ONE POSITION IN BUFFER (NOT BEYOND START)    * 04250006
*   25  10  LF   BUFFER POSITION INCREASED BY 80                      * 04260006
*   2F  14  BEL  THE AUDIBLE ALARM WILL BE SOUNDED                    * 04270006
*                                                                     * 04280006
*  THE DATA PRESENTATION AREA OF THE SCREEN IS TREATED AS ONE CON-    * 04290006
*  TINUOUS LINEAR BUFFER (OF LENGTH ROWS*COLS-(4*ROWS), WHICH WRAPS   * 04300006
*  FROM THE LAST POSITION TO THE FIRST POSITION. ADDITIONALLY, EACH   * 04310006
*  POSITION WHICH IS A MULTIPLE OF 80 IS TREATED LIKE A 'LEFT MARGIN' * 04320006
*  WHEN A CR IS ENCOUNTERED.                                          * 04330006
*                                                                     * 04340006
*********************************************************************** 04350006
         SPACE 2                                                        04360006
         SLR   R8,R8               LOAD R8 WITH # OF BYTES TO PROCESS.  04370006
         IC    R8,1(R7)                                                 04380006
         LA    R7,2(R7)            POINT TO TEXT PROPER.                04390006
         L     R6,SS#BUFPT         POINT TO THE OUTPUT BUFFER, AND      04400006
         MVC   0(LORDERS,R6),ORDERS  INSERT AN RA ORDER TO CLEAR THE    04410006
         L     R5,SS#ROWS            'MORE...' MESSAGE AREA;            04420006
         M     R4,SS#COLS                                               04430006
         S     R5,LMORE                                                 04440006
         BAL   R14,ABSCNVRT                                             04450006
         STCM  R5,B'0011',1(R6)                                         04460006
         LH    R5,SS#CSP             THEN INSERT AN SBA ORDER TO SET    04470006
         BAL   R14,RELCNVRT          US UP TO WRITE TO THE CSP (CURRENT 04480006
         STCM  R5,B'0011',8(R6)      SCREEN POSITION).                  04490006
         LA    R6,LORDERS(R6)      UPDATE O/P BUFFER POINTER.           04500006
         ST    R6,SS#BUFPT                                              04510016
         LTR   R8,R8               IF THERE WAS NO DATA TO SEND, DON'T  04520006
         BZ    FINISHIT              TRY TO PROCESS ANY!!               04530006
         EJECT                                                          04540006
*********************************************************************** 04550006
*                                                                     * 04560006
*  NOW WE PROCESS THE INPUT BUFFER, BYTE, BY BYTE, BY BYTE....        * 04570006
*                                                                     * 04580006
*********************************************************************** 04590006
         SPACE 2                                                        04600006
LOOP     EQU   *                                                        04610006
         LR    R3,R9               WE MUST CHECK WHERE WE ARE IN THE    04620036
         A     R3,=F'230'            BUFFER TO ENSURE THAT WE DON'T     04630026
         CR    R6,R3                 ACCIDENTLY CORRUPT SUBSEQUENT      04640026
         BL    ROOM                  BUFFERS.  WHAT WE HAVE SO FAR MAY  04650026
         MVI   SS#WORD4+3,8          BE FOLLOWED BY UP TO 3 SBA'S, AN   04660026
         B     FINISHIT              RA, STATUS INDICATORS, "MORE...".  04670026
         SPACE 1                                                        04680020
ROOM     EQU   *                                                        04690020
         SLR   R3,R3               GET A CHARACTER FROM THE I/P BUFFER  04700006
         ICM   R3,B'0001',0(R7)      TO PROCESS. WEIRD AND BIZARRE      04710006
         BZ    NEXTPOS               CONTROL CODES WE CAN'T HANDLE ARE  04720006
         CLI   0(R7),C' '            TRANSLATED BY XTASRRX INTO 'NUL'   04730006
         BNL   GRAPHIC               CHARACTERS - WHICH WE IGNORE.      04740006
         SPACE 1                                                        04750006
         B     *(R3)               REMEMBER HOW XTASRRX TRANSLATED      04760006
         B     FF1                   CONTROL CODES IT RECEIVED?? WELL,  04770006
         B     CR                    HERE YOU CAN SEE THAT THE          04780006
         B     BS                    RESULTING CODES ARE BEING USED AS  04790006
         B     LF1                   OFFSETS INTO THIS NEAT BRANCH      04800006
         B     BEL                   TABLE.                             04810006
         B     FF2                                                      04820006
         B     LF2                                                      04830006
         EJECT                                                          04840006
*********************************************************************** 04850006
*                                                                     * 04860006
*  HERE WE HAVE THE PROCESSORS FOR THE DIFFERENT KINDS OF CONTROL     * 04870006
*  CHARACTERS THAT MAY BE ENCOUNTERED.  THERE ARE TWO PROCESSORS      * 04880006
*  FOR EACH OF THE CONTROL CHARACTERS THAT MIGHT CAUSE SCREEN         * 04890006
*  OVERFLOW: THE FIRST PROCESSOR IS ENTERED THE FIRST TIME THE        * 04900006
*  CHARACTER IS ENCOUNTERED.  IF SCREEN OVERFLOW ACTUALLY OCCURS,     * 04910006
*  THEN THAT CHARACTER CAN'T BE SENT IN THE CURRENT MESSAGE (UNLESS   * 04920006
*  THE AUTOWRAP OPTION IS IN EFFECT), THE CHARACTER IS CHANGED INTO   * 04930006
*  THE SECOND FORM OF THAT CONTROL CHARACTER, AND THE MESSAGE IS      * 04940006
*  RECONSTRUCTED SO THAT WE WILL BEGIN PROCESSING WHERE WE LEFT OFF.  * 04950006
*  ON THE SECOND PASS THROUGH THE MESSAGE, WE ENCOUNTER THE SECONDARY * 04960006
*  FORM OF THE CONTROL CHARACTER, AND THE NORMAL PROCESSING FOR THAT  * 04970006
*  CHARACTER TAKES PLACE.  GRAPHICS ARE MUCH EASIER.                  * 04980006
*                                                                     * 04990006
*********************************************************************** 05000006
         SPACE 1                                                        05010006
FF1      EQU   *                                                        05020006
*                                                                       05030007
*  FF1 DOES NOT GENERATE ANY ORDERS, BUT CONTROL MAY BE PASSED TO FF2   05040007
*                                                                       05050007
         TM    SS#FLAG2,SS#AWRAP   CHECK AUTOWRAP OPTION, AND PROCESS   05060006
         BO    FF2                   FF IMMEDIATELY IF ON.              05070006
         TM    0(R9),SS#ECHO       ALSO, WE DON'T HOLD DATA IF WE ARE   05080036
         BO    FF2                   PROCESSING AN ECHO.                05090036
         TM    SS#FLAG2,SS#ONEFF   IF WE'VE SEEN ONE BEFORE IN THIS     05100006
         BO    NEXTPOS               MESSAGE, THEN DISREGARD IT;        05110006
         OI    SS#FLAG2,SS#ONEFF   ELSE, PROCESS BY BRANCHING           05120006
         MVI   0(R7),X'18'           TO THE 'OVERFLOW' CODE - AFTER     05130006
         BCTR  R7,0                  FIXING UP THE BUFFER SO THAT       05140006
         LA    R8,1(R8)              THE RECONSTRUCTED FF GETS          05150006
         B     OVERFLOW              REPROCESSED LATER.                 05160006
         SPACE 1                                                        05170006
FF2      EQU   *                                                        05180006
*                                                                       05190007
*  SBA ADDR ( DATA_AREA )                                               05200007
*  RA ADDR ( DATA_AREA + LEN ( DATA_AREA ) ) BLANK                      05210007
*  SBA ADDR ( DATA_AREA )                                               05220007
*                                                                       05230007
         XC    SS#CSP,SS#CSP       RESET CSP.                           05240006
         LR    R6,R9               POINT TO THE START OF THE BUFFER WE  05250036
         LA    R6,10(R6)             ARE USING, AND INSERT ORDERS TO    05260006
         MVC   0(LORDERS,R6),ORDERS  CLEAR THE DATA AREA OF THE SCREEN. 05270006
         SLR   R5,R5               POINT TO THE FIRST POSITION IN THE   05280006
         BAL   R14,RELCNVRT          DATA AREA OF THE SCREEN.           05290006
         STCM  R5,B'0011',1(R6)                                         05300006
         STCM  R5,B'0011',8(R6)                                         05310006
         L     R5,SS#COLS          POINT TO THE FIRST POSITION ON THE   05320006
         M     R4,SS#ROWS            NEXT-TO-LAST LINE OF THE SCREEN.   05330006
         S     R5,SS#COLS                                               05340006
         S     R5,SS#COLS                                               05350006
         BAL   R14,ABSCNVRT                                             05360006
         STCM  R5,B'0011',4(R6)                                         05370006
         LA    R6,LORDERS(R6)                                           05380006
         ST    R6,SS#BUFPT                                              05390006
         B     NEXTPOS                                                  05400006
         SPACE 1                                                        05410006
CR       EQU   *                                                        05420006
*                                                                       05430007
*  SBA ADDR ( CURRENT_LINE )                                            05440007
*                                                                       05450007
         LH    R5,SS#CSP           GET THE CSP AND TAKE THE NEXT LOWER  05460006
         SLR   R4,R4                 (OR EQUAL) MULTIPLE OF 80, TO PUT  05470006
         D     R4,SS#COLS            US AT THE BEGINNING OF THE CURRENT 05480006
         M     R4,SS#COLS            LINE.                              05490006
         STH   R5,SS#CSP                                                05500006
         BAL   R2,PUTSBA           INSERT AN SBA TO THE NEW LOCATION.   05510006
         B     NEXTPOS             PROCESS THE NEXT BYTE.               05520006
         SPACE 1                                                        05530006
BS       EQU   *                                                        05540006
*                                                                       05550007
*  IF ( CURRENT_SCREEN_POSITION > CURRENT_LINE )                        05560007
*    SBA ADDR ( CURRENT_SCREEN_POSITION - 1 )                           05570007
*                                                                       05580007
         LH    R5,SS#CSP           GET CURRENT SCREEN POSITION.         05590006
         SLR   R4,R4               CHECK WHETHER WE'RE AT THE           05600006
         D     R4,SS#COLS            BEGINNING OF A LINE - IF WE ARE,   05610006
         LTR   R4,R4                 WE IGNORE THE BS (THIS ALSO WILL   05620006
         BZ    NEXTPOS               HANDLE BEGINNING OF SCREEN).       05630006
         LH    R5,SS#CSP           RELOAD THE CSP, BACK UP ONE          05640006
         BCTR  R5,0                  POSITION, AND STORE IT BACK.       05650006
         STH   R5,SS#CSP                                                05660006
         BAL   R2,PUTSBA           GENERATE SBA TO PUT US THERE.        05670006
         B     NEXTPOS             PROCESS THE NEXT BYTE.               05680006
         SPACE 1                                                        05690006
LF1      EQU   *                                                        05700006
*                                                                       05710007
*  THOUGH LF1 UPDATES CSP, IT LEAVES IT TO LF2 TO GENERATE ORDERS       05720007
*                                                                       05730007
         LH    R5,SS#CSP           HERE, WE INCREMENT THE CSP BY        05740007
         A     R5,SS#COLS            (LINE LENGTH) AND PERFORM          05750007
         SLR   R4,R4                 MODULO (SIZE OF DATA AREA) ON      05760007
         D     R4,SS#DAREA           IT TO ENSURE WE DON'T LINEFEED OUT 05770007
         STH   R4,SS#CSP             OF THE DATA AREA OF THE SCREEN.    05780007
         TM    SS#FLAG2,SS#AWRAP   (TWO QUICK CHECKS TO SEE WHETHER WE  05790036
         BO    LF2                   IGNORE THE OVERFLOW CONDITION.)    05800006
         TM    0(R9),SS#ECHO                                            05810036
         BO    LF2                                                      05820036
         LTR   R5,R5               NOW, IF WE DO, IN FACT, LF OUT OF    05830006
         BZ    LF2                   THE DATA AREA, WE MUST RECONSTRUCT 05840006
         MVI   0(R7),X'1C'           THE LF SO THAT IT WILL BE          05850006
         BCTR  R7,0                  REPROCESSED, AND ENTER THE         05860006
         LA    R8,1(R8)              OVERFLOW CODE.                     05870006
         B     OVERFLOW                                                 05880006
         SPACE 1                                                        05890006
LF2      EQU   *                                                        05900007
*                                                                       05910007
*  SBA ADDR ( CURRENT_LINE)                                             05920007
*  RA ADDR ( CURRENT_LINE + LINE_LENGTH ) BLANK                         05930024
*  SBA ADDR ( CURRENT_SCREEN_POSITION )                                 05940007
*                                                                       05950007
         LH    R5,SS#CSP           CSP WAS ALREADY UPDATED BY LF1.      05960007
         BAL   R2,PUTSBA           PUTSBA WILL CHECK FOR AN IMMEDIATELY 05970007
         SH    R6,=H'3'              PRECEDING SBA.                     05980007
         MVC   0(LORDERS,R6),ORDERS  0  1  2  3  4  5  6   7  8  9      05990009
         STH   R5,8(R6)            SBA,00,00,RA,00,00,40,SBA,00,00      06000007
         LH    R5,SS#CSP           (R5 WAS CHANGED BY PUTSBA)           06010007
         SLR   R4,R4               THIS CALCULATES THE RELATIVE SCREEN  06020006
         D     R4,SS#COLS            POSITION OF THE START OF THE       06030006
         M     R4,SS#COLS            CURRENT LINE...                    06040007
         ST    R5,SS#WORD3           ...WHICH WE SAVE...                06050006
         BAL   R14,RELCNVRT                                             06060006
         STCM  R5,B'0011',1(R6)                                         06070006
         L     R5,SS#WORD3           ...TO SIMPLIFY CALCULATING THE     06080006
         A     R5,SS#COLS            ADDRESS OF THE START OF THE NEXT   06090006
         BAL   R14,RELCNVRT          LINE (THE DESTINATION OF THE RA).  06100006
         STCM  R5,B'0011',4(R6)                                         06110006
         LA    R6,LORDERS(R6)      UPDATE O/P BUFFER POINTER.           06120006
         B     NEXTPOS             PROCESS MORE INPUT.                  06130006
         SPACE 1                                                        06140006
BEL      EQU   *                                                        06150006
*                                                                       06160024
*  NO ORDERS ARE GENERATED, BUT BIT 5 IN THE WCC WILL BE TURNED ON      06170024
*                                                                       06180024
         OI    9(R9),ALARM         FLIP ON THE AUDIBLE ALARM BIT IN     06190036
         B     NEXTPOS               THE WCC.                           06200036
         SPACE 1                                                        06210006
GRAPHIC  EQU   *                                                        06220006
*                                                                       06230024
*  A SINGLE GRAPHIC CHARACTER IS TRANSFERRED FROM THE INPUT BUFFER      06240024
*  TO THE OUTPUT BUFFER, THEN A CHECK IS MADE FOR END-OF-LINE OR        06250024
*  END-OF-DATA-AREA; OTHER PROCESSING MAY THEN BE INITIATED.            06260024
*                                                                       06270024
         STC   R3,0(R6)            PUT THE GRAPHIC CHARACTER IN THE     06280006
         LA    R6,1(R6)              OUTPUT STREAM, AND INCREMENT THE   06290006
         SLR   R4,R4                 OUTPUT BUFFER POINTER.             06300006
         LH    R5,SS#CSP           UPDATE THE CSP, INCREMENTING IT      06310006
         LA    R5,1(R5)              BY ONE - MAKE SURE WE WRAP WHEN    06320006
         D     R4,SS#DAREA           ON THE LAST LINE, THOUGH!!         06330006
         STH   R4,SS#CSP                                                06340006
         LTR   R5,R5               IF WE OVERFLOWED THE DATA AREA OF    06350006
         BZ    CHKNL                 THE SCREEN, (AND WRAP IS ON)       06360006
         TM    SS#FLAG2,SS#AWRAP     WE MUST INSERT AN SBA INTO THE     06370006
         BO    NOBREAK               OUTPUT STREAM TO REPOSITION US     06380036
         TM    0(R9),SS#ECHO         ON THE SCREEN.                     06390036
         BZ    OVERFLOW                                                 06400036
         SPACE 1                                                        06410036
NOBREAK  EQU   *                                                        06420036
         LR    R5,R4                                                    06430036
         BAL   R2,PUTSBA                                                06440006
         B     CHKNL                                                    06450006
         SPACE 1                                                        06460006
OVERFLOW EQU   *                                                        06470007
         NI    0(R9),X'FF'-SS#DATA                                      06480036
         OI    0(R9),SS#ECHO                                            06490036
         BAL   R2,PUTSBA           PUTSBA CHECKS FOR IMMEDIATELY        06500007
         SH    R6,=H'3'              PRECEDING SBA.                     06510007
         L     R5,SS#ROWS          CALCULATE THE ADDRESS FOR THE        06520007
         M     R4,SS#COLS            'MORE...' MESSAGE...               06530007
         S     R5,LMORE                                                 06540006
         BAL   R14,ABSCNVRT                                             06550006
         STCM  R5,B'0011',1(R6)                                         06560006
         MVC   3(L'MORE,R6),MORE     ...AND MOVE IT INTO THE BUFFER.    06570007
         LA    R6,3+L'MORE(R6)                                          06580006
         OI    9(R9),ALARM         SIGNAL OVERFLOW WITH AUDIBLE ALARM.  06590036
         BCTR  R7,0                NOW WE FIX UP THE INPUT BUFFER AND   06600006
         MVI   0(R7),SS#DATA         POINTERS SO THAT WE CAN CONTINUE   06610033
         TM    SS#FLAG2,SS#ERASE     PROCESSING IT WHERE WE LEFT OFF... 06620010
         BZ    NOERASE                                                  06630007
         OI    0(R7),CLEARDTA                                           06640007
         SPACE 1                                                        06650007
NOERASE  EQU   *                                                        06660007
         BCTR  R8,0                                                     06670006
         STC   R8,1(R7)                                                 06680006
         OI    SS#FLAG2,SS#REENT   INDICATE THAT THERE'S MORE TO DO.    06690006
         OI    0(R9),SS#PACNG      FINALLY, INDICATE PACING SHOULD BE   06700036
         B     ENDATA                TURNED ON AFTER SUCCESSFUL SEND.   06710036
         SPACE 1                                                        06720006
CHKNL    EQU   *                   WE MUST CHECK WHETHER WE HAVE JUST   06730006
         SR    R4,R4                 OVERFLOWED TO A NEW LINE, FOR WHEN 06740006
         LH    R5,SS#CSP             WE DO, WE MUST CLEAR IT.           06750006
         D     R4,SS#COLS          WE CHECK FOR THIS CONDITION BY       06760006
         LTR   R4,R4                 TESTING WHETHER THE NEW CSP IS     06770006
         BNZ   NEXTPOS               EVENLY DISIBLE BY 80 - IF IF IS,   06780006
         MVC   0(7,R6),ORDERS+3      WE JUST STARTED A NEW LINE.        06790006
         LH    R5,SS#CSP           SO, PUT AN ORDER STREAM IN THE       06800006
         BAL   R14,RELCNVRT          OUTPUT BUFFER TO DO AN RA BLANK    06810006
         STCM  R5,B'0011',5(R6)      TO THE END OF THE LINE, AND THEN   06820006
         LH    R5,SS#CSP             SBA BACK TO WHERE WE SHOULD BE.    06830006
         A     R5,SS#COLS                                               06840006
         BAL   R14,RELCNVRT                                             06850006
         STCM  R5,B'0011',1(R6)                                         06860006
         LA    R6,7(R6)                                                 06870006
         SPACE 1                                                        06880006
NEXTPOS  EQU   *                                                        06890006
         LA    R7,1(R7)            BUMP PAST THE BYTE WE JUST PROCESSED 06900006
         BCT   R8,LOOP               AND LOOP 'TIL INPUT EXHAUSTED.     06910006
         EJECT                                                          06920006
*********************************************************************** 06930006
*                                                                     * 06940006
*  HERE, WE FINISH UP THE OUTPUT BUFFER BY WRITING THE SEPARATOR      * 06950006
*  LINE (UNLESS WE FINISHED ON THE LAST LINE OF THE DATA AREA OF      * 06960006
*  THE SCREEN).                                                       * 06970006
*                                                                     * 06980006
*********************************************************************** 06990006
         SPACE 2                                                        07000006
FINISHIT EQU   *                                                        07010006
         LH    R5,SS#CSP           WHERE ARE WE NOW??                   07020006
         SLR   R4,R4               WHEREVER WE ARE, WHERE IS THE START  07030006
         D     R4,SS#COLS            OF WHATEVER LINE WE ARE ON??       07040006
         M     R4,SS#COLS                                               07050006
         A     R5,SS#COLS          GO TO THE START OF THE NEXT LINE     07060006
         C     R5,SS#DAREA           AND CHECK WHETHER IT IS BEYOND     07070006
         BNL   ENDATA                THE DATA AREA OF THE SCREEN.       07080006
         ST    R5,SS#WORD3         SAVE THE ADDRESS OF THE NEXT LINE,   07090007
         BAL   R2,PUTSBA             AND THEN DO AN SBA TO IT.          07100007
         MVI   0(R6),RA            BUILD AN RA ORDER TO                 07110007
         L     R5,SS#WORD3           WRITE A SEPARATOR LINE ON THE      07120006
         A     R5,SS#COLS            LINE AFTER THE ONE WE ARE ON.      07130006
         BAL   R14,RELCNVRT                                             07140006
         STCM  R5,B'0011',1(R6)                                         07150007
         MVC   3(1,R6),SS#SEPCH                                         07160007
         LA    R6,4(R6)                                                 07170007
         SPACE 1                                                        07180006
ENDATA   EQU   *                                                        07190006
         ST    R6,SS#BUFPT         STORE LAST VALUE OF BUFFER POINTER,  07200006
         B     PH10#9                AND GO PROCESS THE BUFFER.         07210006
         EJECT                                                          07220006
*********************************************************************** 07230006
*                                                                     * 07240006
*  THIS ROUTINE PLACES AN SBA ORDER AT THE LOCATION POINTED TO BY     * 07250006
*  R6, USING THE RELATIVE (DATA AREA) BUFFER ADDRESS CONTAINED IN     * 07260006
*  R5.  R6 IS INCREMENTED BY THE LENGTH OF AN SBA ORDER (3).  A CHECK * 07270032
*  IS MADE TO DETERMINE THAT THERE IS NOT AN IMMEDIATELY PRECEDING    * 07280006
*  SBA ORDER IN THE BUFFER: IF THERE IS, THEN THE CURRENT BUFFER      * 07290006
*  ADDRESS REPLACES THE EXISTING ADDRESS, AND THE BUFFER POINTER      * 07300006
*  (R6) IS NOT UPDATED.                                               * 07310006
*                                                                     * 07320006
*********************************************************************** 07330006
         SPACE 1                                                        07340006
PUTSBA   EQU   *                                                        07350006
         LR    R1,R9               FIRST, ENSURE THAT WE WON'T BE       07360036
         LA    R1,13(R1)             LOOKING IN FRONT OF THE BUFFER     07370006
         CR    R6,R1                 PROPER, OR AT THE CMD OR WCC.      07380009
         BL    SBAOK                                                    07390006
         SH    R6,=H'3'            NOW WE BACK UP TO DETERMINE WHETHER  07400006
         CLI   0(R6),SBA             AN SBA IMMEDIATELY PRECEDES OURS   07410006
         BE    SBAOK                 IN THE BUFFER - IF SO, WE REPLACE  07420006
         LA    R6,3(R6)              IT.                                07430006
         SPACE 1                                                        07440006
SBAOK    EQU   *                                                        07450006
         MVI   0(R6),SBA           INSERT OUR SBA ORDER, AND A DATA     07460006
         BAL   R14,RELCNVRT          AREA BUFFER ADDRESS.               07470006
         STCM  R5,B'0011',1(R6)                                         07480006
         LA    R6,3(R6)            UPDATE THE BUFFER POINTER,           07490006
         BR    R2                    AND RETURN.                        07500006
         EJECT                                                          07510006
*********************************************************************** 07520006
*                                                                     * 07530006
*  THIS ROUTINE TAKES A RELATIVE BUFFER ADDRESS IN REGISTER 5 AND     * 07540006
*  CONVERTS IT TO ACTUAL 3270 BUFFER ADDRESSING BYTES. REGISTER 4     * 07550006
*  IS USED, BUT ITS CONTENTS ARE PRESERVED. ALL OTHER REGISTERS ARE   * 07560006
*  LEFT UNDISTURBED. ENTRY IS BY BAL(R) WITH R14 AS LINK REGISTER.    * 07570006
*                                                                     * 07580006
*  NOTE THAT WHEN 14-BIT/16-BIT ADDRESSING IS USED, THE RELATIVE      * 07590006
*  BUFFER ADDRESS IS USED WITHOUT CONVERSION.                         * 07600006
*                                                                     * 07610006
*********************************************************************** 07620006
         SPACE 1                                                        07630006
RELCNVRT EQU   *                   THE RELATIVE BUFFER ADDRESS REFERS   07640006
         A     R5,SS#COLS            TO THE DATA AREA OF THE SCREEN -   07650006
         A     R5,SS#COLS            WHICH BEGINS ON LINE 2.            07660006
         SPACE 1                                                        07670006
ABSCNVRT EQU   *                                                        07680006
         TM    SS#FLAG2,SS#1416    IF WE USE 14/16-BIT ADDRESSING       07690006
         BOR   R14                   THEN NO CONVERSION IS NEEDED.      07700006
         ST    R4,SS#WORD2         PRESERVE THE VALUE IN R4.            07710006
         SLR   R4,R4                                                    07720006
         D     R4,=F'64'                                                07730006
         N     R4,=F'63'           HERE WE ENSURE THAT WE DON'T DO WILD 07740006
         N     R5,=F'63'             AND UNRESTRAINED FETCHES.          07750006
         IC    R4,CN3270(R4)       CONVERT TO VALID 3270 CODES.         07760006
         IC    R5,CN3270(R5)                                            07770006
         SLL   R5,8                WE COMBINE THE TWO BYTES OF BUFFER   07780006
         OR    R5,R4                 ADDRESS INTO THE 2 LOW BYTES OF    07790006
         L     R4,SS#WORD2           REGISTER 5.                        07800006
         BR    R14                                                      07810006
         EJECT                                                          07820006
**                                                                      07830006
*                                                                       07840006
    PHASE  10.7 - INITIAL: INSERT SCREEN FORMAT INTO BUFFER             07850006
*                                                                       07860006
**                                                                      07870006
         CLC   =X'0000001800000050',SS#ROWS   IF THE SCREEN SIZE IS NOT 07880006
         BE    STDSIZE             24 X 80, USE ERASE/WRITE ALTERNATE   07890006
         MVI   8(R9),X'7E'         TO SET DEVICE TO ALT SCREEN SIZE.    07900038
         SPACE 1                                                        07910006
STDSIZE  EQU   *                                                        07920006
         NI    SS#FLAG2,X'FF'-SS#HOLDD  RESET ANY PREVIOUS HOLD REQUEST 07930006
         L     R6,SS#BUFPT         GET BUFFER POINTER.                  07940006
         MVC   0(LHERALD,R6),HERALD  INSERT SCREEN FORMATTING.          07950006
         LA    R6,LHERALD(R6)      UPDATE BUFFER POINTER,               07960006
         MVC   0(LFIELDEF,R6),FIELDEF                                   07970006
         L     R5,SS#COLS                                               07980006
         BAL   R14,ABSCNVRT                                             07990006
         STCM  R5,B'0011',1(R6)                                         08000006
         L     R5,SS#COLS                                               08010006
         M     R4,SS#ROWS                                               08020006
         S     R5,SS#COLS                                               08030006
         S     R5,SS#COLS                                               08040006
         BAL   R14,ABSCNVRT                                             08050006
         STCM  R5,B'0011',6(R6)                                         08060006
         L     R5,SS#COLS                                               08070006
         M     R4,SS#ROWS                                               08080006
         S     R5,LMORE                                                 08090006
         BCTR  R5,0                                                     08100006
         BAL   R14,ABSCNVRT                                             08110006
         STCM  R5,B'0011',20(R6)                                        08120006
         LA    R6,LFIELDEF(R6)     UPDATE BUFFER POINTER,               08130006
         ST    R6,SS#BUFPT           AND SAVE IT.                       08140006
         XC    SS#CSP,SS#CSP       RESET CURRENT SCREEN POSITION.       08150006
         SPACE 1                                                        08160006
         MVC   SS#SBFST,SS#SBLST   POINT QAB TO JUST US, EFFECTIVELY    08170006
         LA    R4,SS#SBPL            REMOVING ALL WAITERS BUT US FROM   08180006
         LA    R5,SS#SBCNT           THE QUEUE.                         08190006
         SPACE 1                                                        08200006
CLRSBPL  EQU   *                   THEN, MARK ALL THE BUFFERS, EXCEPT   08210006
         C     R4,SS#SBFST           THE ONE WE ARE USING, NOT IN USE.  08220006
         BE    BCT                                                      08230006
         NI    0(R4),X'FF'-SS#SBIU                                      08240006
         SPACE 1                                                        08250006
BCT      EQU   *                                                        08260006
         LA    R4,256(R4)                                               08270006
         BCT   R5,CLRSBPL                                               08280006
         SPACE 1                                                        08290028
         TM    SS#FLAG1,SS#SACT    SINCE WE ARE DISCARDING ALL THE      08300028
         BZ    PH10#8                IN-USE SEND BUFFERS, WE MUST BE    08310028
         L     R6,SS#ASRPL           SURE TO RE-ISSUE THE RECEIVE ON    08320028
         USING IFGRPL,R6             THE SECONDARY WHICH WOULD NORMALLY 08330028
         CLI   RPLACTIV,X'00'        HAVE BEEN ISSUED BY THE SEND EXIT. 08340028
         BNE   PH10#8              FIRST, OF COURSE, WE MUST MAKE SURE  08350028
         DROP  R6                    THAT THE RECEIVE SHOULD, IN FACT,  08360028
         L     R5,SS#SCID            BE ISSUED.                         08370028
         L     R4,CS#ASNRX                                              08380028
         LA    R3,SS#SIBUF                                              08390028
         RECEIVE RPL=(R6),                                             X08400028
               ARG=(R5),                                               X08410028
               EXIT=(R4),                                              X08420028
               AREA=(R3),                                              X08430028
               AREALEN=160                                              08440028
         EJECT                                                          08450006
**                                                                      08460006
*                                                                       08470006
    PHASE  10.8 - SYSMSG: INSERT DATA + FORMATTING AT BUFFER POINTER    08480006
*                                                                       08490006
**                                                                      08500006
         L     R6,SS#BUFPT         GET BUFFER POINTER.                  08510006
         MVC   0(LORDERS,R6),ORDERS  CLEAR THE SYSMSG LINE.             08520006
         L     R5,SS#COLS          POINT TO THE SECOND POSITION ON THE  08530006
         LA    R5,1(R5)              SECOND LINE.                       08540006
         BAL   R14,ABSCNVRT                                             08550006
         STCM  R5,B'0011',1(R6)                                         08560006
         STCM  R5,B'0011',8(R6)                                         08570006
         L     R5,SS#COLS          POINT TO THE FIRST POSITION ON THE   08580006
         SLL   R5,1                  THIRD LINE.                        08590006
         BAL   R14,ABSCNVRT                                             08600006
         STCM  R5,B'0011',4(R6)                                         08610006
         LA    R6,LORDERS(R6)      UPDATE DATA LENGTH.                  08620006
         ST    R6,SS#BUFPT         SAVE IT IN CASE WE SEND JUST THIS.   08630006
         SLR   R4,R4               ZERO R6 IN PREPARATION FOR IC.       08640006
         ICM   R4,1,1(R7)          GET THE MESSAGE LENGTH.              08650006
         BZ    PH10#9              IF NO MESSAGE...                     08660006
         AH    R4,=H'2'                                                 08670006
         C     R4,SS#COLS          IS MESSAGE LONGER THAN MAX?          08680006
         BNH   LENGTHOK            IF NOT, ALL IS WELL,                 08690006
         MVI   SS#WORD4+3,8          BUT IF IT IS, SET RC=8, AND        08700018
         L     R4,SS#COLS            FORCE LENGTH TO MAX.               08710006
         SPACE 1                                                        08720006
LENGTHOK EQU   *                                                        08730006
         SH    R4,=H'3'            DECREMENT FOR EXECUTED MVC.          08740006
         EX    R4,MOVESYSM         MOVE MESSAGE INTO BUFFER.            08750006
         LA    R6,1(R6,R4)         ADD LENGTH OF DATA TO TOTAL LENGTH.  08760006
         ST    R6,SS#BUFPT         SAVE IT FOR FUTURE USE.              08770006
         SPACE 1                                                        08780016
         TM    SS#FLAG1,SS#SACT    IN ORDER TO MAKE SURE THAT THE       08790016
         BO    PH10#9                'MORE...' MESSAGE GOES AWAY WHEN   08800016
         SLR   R5,R5                 THE SECONDARY IS LOST, I'M         08810016
         BAL   R2,PUTSBA             CHECKING (DURING SYSMSG PROCESS'G  08820016
         SH    R6,=H'3'              ONLY) TO SEE IF THERE'S A SEC'Y;   08830016
         MVC   0(7,R6),ORDERS        IF THERE ISN'T, I'M CLEARING THE   08840016
         L     R5,SS#ROWS            AREA WHERE THE 'MORE...' MESSAGE   08850016
         M     R4,SS#COLS            MIGHT BE.  I DON'T REALLY LIKE     08860016
         S     R5,LMORE              THIS SOLUTION, BUT CAN'T THINK OF  08870016
         BAL   R14,ABSCNVRT          ANY OTHER WAY TO DO IT.            08880016
         STCM  R5,B'0011',1(R6)                                         08890016
         LA    R6,7(R6)                                                 08900016
         ST    R6,SS#BUFPT                                              08910016
         EJECT                                                          08920006
**                                                                      08930006
*                                                                       08940006
    PHASE  10.9 - FINISH PREPARING THE BUFFER                           08950006
*                                                                       08960006
**                                                                      08970006
         L     R4,SS#BUFPT         GET POINTER TO END OF DATA, AND      08980006
         MVI   0(R4),SBA             ADDRESS THE LAST PART OF THE TOP   08990006
         L     R5,SS#COLS            LINE OF THE SCREEN, SO THAT WE CAN 09000006
         SH    R5,=H'7'              ADD THE STATUS INDICATORS.         09010006
         BAL   R14,ABSCNVRT                                             09020006
         STCM  R5,B'0011',1(R4)                                         09030006
         MVI   3(R4),C' '          LEAVE ROOM FOR FOUR INDICATORS (WITH 09040006
         MVC   4(6,R4),3(R4)         A BLANK BETWEEN EACH ONE).         09050006
         SPACE 1                                                        09060006
         TM    SS#FLAG1,SS#SACT                                         09070008
         BZ    NOSEC               THE 'S' INDICATES AN ACTIVE          09080008
         MVI   3(R4),C'S'            SECONDARY SESSION.                 09090008
         SPACE 1                                                        09100006
NOSEC    EQU   *                                                        09110006
         TM    SS#FLAG2,SS#AWRAP   A 'W' INDICATES THAT THE AUTOWRAP    09120006
         BZ    NOWRP                 OPTION IS IN EFFECT.               09130006
         MVI   5(R4),C'W'                                               09140006
         SPACE 1                                                        09150006
NOWRP    EQU   *                                                        09160006
         TM    SS#FLAG4,SS#SAVON                                        09170006
         BZ    NOSAV               THE 'C' INDICATES THAT THE CAPTURE   09180006
         MVI   7(R4),C'C'            FACILITY IS ACTIVE.                09190006
         SPACE 1                                                        09200006
NOSAV    EQU   *                                                        09210006
         TM    SS#FLAG2,SS#ERASE                                        09220013
         BZ    NOERS               THE 'E' INDICATES THAT THE ERASE     09230023
         MVI   9(R4),C'E'            OPTION IS IN EFFECT.               09240023
         SPACE 1                                                        09250012
NOERS    EQU   *                                                        09260012
         LA    R4,10(R4)           END OF DATA MINUS START OF BUFFER    09270036
         SR    R4,R9                 IS LENGTH OF DATA TO SEND.         09280036
         S     R4,=F'8'            ACCOUNT FOR 8-BYTE BUFFER HEADER     09290006
         STH   R4,2(R9)              AND SAVE LENGTH OF DATA IN BUFFER. 09300037
         TM    SS#FLAG2,SS#NOALM   IF USER DOESN'T WANT ALARM, TURN IT  09310006
         BZ    PH10#10               OFF HERE, AFTER EVERYONE HAS HAD   09320006
         NI    9(R9),X'FF'-ALARM     THEIR CHANCE TO TURN IT ON.        09330037
         EJECT                                                          09340006
**                                                                      09350006
*                                                                       09360006
    PHASE  10.10 - PROCESS FIRST WAITER                                 09370006
*                                                                       09380006
**                                                                      09390006
         L     R3,SS#SBFST         PREPARE TO SEND THE FIRST WAITER.    09400006
         LTR   R3,R3               IF THERE ARE NO WAITERS, JUST LEAVE. 09410006
         BZ    PH10#99                                                  09420006
         SPACE 1                                                        09430006
         TM    SS#FLAG2,SS#HOLDD   IF DATA IS NOT BEING HELD, FORGE     09440006
         BZ    PH10#11               AHEAD.                             09450006
         SPACE 1                                                        09460006
         TM    0(R3),SS#DATA+SS#ECHO   IF IT ISN'T GOING TO THE DATA    09470006
         BZ    PH10#11                   AREA ANYWAY, FORGE AHEAD.      09480006
         SPACE 1                                                        09490006
         LR    R4,R3                                                    09500006
         SPACE 1                                                        09510006
NEXTBUF  EQU   *                   *BUT*, IF IT *IS* A DATA (OR ECHO)   09520006
         LR    R5,R4                 MESSAGE, AND DATA *IS* BEING HELD, 09530006
         ICM   R4,15,4(R4)           THEN TRY TO FLOAT A NON-DATA QEL   09540006
         BZ    PH10#99               TO THE TOP OF THE QUEUE.           09550006
         SPACE 1                                                        09560006
         TM    0(R4),SS#DATA+SS#ECHO                                    09570006
         BNZ   NEXTBUF                                                  09580006
         SPACE 1                                                        09590006
         MVC   4(4,R5),4(R4)       OUR OBJECTIVE IS TO FLOAT THE FIRST  09600006
         ST    R3,4(R4)              NON-DATA QEL WE FIND TO THE TOP OF 09610006
         ST    R4,SS#SBFST           THE QUEUE WITHOUT ALTERING THE     09620006
         CLC   SS#SBFST,SS#SBLST     ORDER OF ANY OTHER QEL'S.          09630006
         BNE   PH10#11                                                  09640006
         SPACE 1                                                        09650006
         ST    R5,SS#SBLST                                              09660006
         EJECT                                                          09670006
**                                                                      09680006
*                                                                       09690006
    PHASE  10.11 - SEND ASY TO PRIMARY                                  09700006
*                                                                       09710006
**                                                                      09720006
         L     R3,SS#AERPL         INITIALLY WE WILL ASSUME THAT WE'RE  09730006
         L     R2,CS#AEKOX           NOT SENDING 'FINAL DATA', WHICH    09740006
         L     R6,SS#SBFST           MEANS THAT WE USE THE ECHO RPL.    09750006
         SPACE 1                                                        09760006
         TM    0(R6),SS#DATA       NOW WE CHECK WHETHER IT IS ACTUALLY  09770006
         BZ    RPLOK                 'DATA' WE ARE SENDING.             09780006
         SPACE 1                                                        09790006
         L     R3,SS#ASRPL         NOW WE KNOW FOR SURE THAT WE ARE     09800006
         L     R2,CS#ASNRX           SENDING 'FINAL DATA'.              09810006
         SPACE 1                                                        09820006
RPLOK    EQU   *                                                        09830006
         LH    R5,2(R6)            GET THE LENGTH OF THE DATA;          09840006
         LA    R6,8(R6)              THEN POINT TO DATA TO BE SENT.     09850006
         PUSH  USING               ADDRESS THE RPL WE WILL BE USING FOR 09860006
         USING IFGRPL,R3             THE SEND OPERATION, AND CHECK      09870006
         CLI   RPLACTIV,X'FF'        WHETHER IT'S ALREADY ACTIVE; IF IT 09880006
         BE    PH10#99               IS LET EKOX INITIATE THE SEND.     09890006
         SPACE 1                                                        09900006
         L     R4,SS#PCID          SEND TO PRIMARY.                     09910006
         OI    RPLRH3,RPLEB        ENSURE EBI IS SET.                   09920006
         NI    RPLRH3,X'FF'-RPLBB  RESET THE BEGIN-BRACKET INDICATOR.   09930006
         TM    SS#FLAG2,SS#INBKT   ARE WE IN IN-BRACKET STATE?          09940006
         BO    SENDIT              IF SO, REMAIN IN-BRACKET, BUT IF WE  09950006
         OI    RPLRH3,RPLBB          ARE BETB, WE MUST START A BRACKET. 09960006
         SPACE 1                                                        09970006
SENDIT   EQU   *                                                        09980006
         SEND  RPL=(R3),                                               +09990006
               RESPOND=(NEX,FME,NRRN),                                 +10000006
               EXIT=(R2),                                              +10010006
               ARG=(R4),                                               +10020006
               AREA=(R6),                                              +10030006
               RECLEN=(R5)                                              10040006
         LTR   R15,R15             IF ALL IS WELL, JUST LEAVE.          10050006
         BZ    PH10#99                                                  10060006
         SPACE 1                                                        10070006
         CLC   =X'2003',RPLSSNSI   BUT IF WE HAD AN ERROR WITH OUR      10080006
         BNE   PH10#99               BRACKET STATE, INVERT THE BBI AND  10090006
         XI    RPLRH3,RPLBB          TRY SENDING AGAIN.                 10100006
         POP   USING                                                    10110006
         B     SENDIT                                                   10120006
         EJECT                                                          10130006
**                                                                      10140006
*                                                                       10150006
    PHASE  10.99 - EXIT                                                 10160006
*                                                                       10170006
**                                                                      10180006
         TM    SS#FLAG2,SS#REENT   IF WE HAD SCREEN OVERFLOW, THEN      10190034
         BO    PH10#1                REENTER TO PROCESS REMAINING DATA. 10200034
         NI    SS#FLAG2,X'FF'-SS#ONEFF                                  10210006
         SLR   R15,R15             ZERO HI 3 BYTES OF R15.              10220006
         L     R15,SS#WORD4        GET RETURN CODE.                     10230017
         EPILOGUE                                                       10240006
*********************************************************************** 10250006
*********************************************************************** 10260006
********                                                       ******** 10270006
********               END OF EXECUTABLE CODE                  ******** 10280006
********                                                       ******** 10290006
*********************************************************************** 10300006
*********************************************************************** 10310006
         TITLE 'DATA AREA'                                              10320006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10330006
*                                                                     * 10340006
*  EXECUTE OBJECTS                                                    * 10350006
*                                                                     * 10360006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10370006
         SPACE 2                                                        10380006
MOVESYSM MVC   0(0,R6),2(R7)                                            10390006
         SPACE 2                                                        10400006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10410006
*                                                                     * 10420006
*  MESSAGE TEMPLATE                                                   * 10430006
*                                                                     * 10440006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10450006
         SPACE 2                                                        10460006
HERALD   EQU   *                                                        10470006
         SBA   1,1                                                      10480006
         RA    1,1,CHAR=00                                              10490006
         SF    (SKIP,HIGH)                                              10500006
         DC    C'TARA - ' TIME-SHARING APPLICATIONS REMOTE ACCESS'      10510006
         DC    X'E3899485A288819989958740C1979793898381A3899695A240'    10520006
         DC    X'D9859496A38540C1838385A2A2'                            10530006
LHERALD  EQU   *-HERALD                                                 10540006
         SPACE 2                                                        10550006
FIELDEF  EQU   *                                                        10560006
*                                                                     * 10570006
* NOTE THAT WHILE ACTUAL SCREEN POSITIONS (FOR A 24 X 80 SCREEN) ARE  * 10580006
* CODED HERE, THEY ARE FOR REFERENCE PURPOSES ONLY.  THE ACTUAL       * 10590006
* BUFFER ADDRESSES FOR THE APPROPRIATE SCREEN SIZE ARE CALCULATED BY  * 10600006
* THE CODE AND INSERTED INTO THIS "TEMPLATE."                         * 10610006
*                                                                     * 10620006
         SBA   2,1                                                      10630006
         SF    (SKIP,LOW)                                               10640006
         SBA   23,1                                                     10650006
         SF    (SKIP,HIGH)                                              10660006
         DC    C'INPUT:'                                                10670006
         SF    (UNPROT,LOW)                                             10680006
         ICSR                                                           10690006
         SBA   23,73                                                    10700006
         SF    (SKIP,HIGH)                                              10710006
LFIELDEF EQU   *-FIELDEF                                                10720006
         SPACE 2                                                        10730006
CLEARIT  EQU   *                                                        10740007
         SBA   1,1                                                      10750007
         ICSR                                                           10760007
         EUA   1,1                                                      10770007
LCLEARIT EQU   *-CLEARIT                                                10780006
         SPACE 2                                                        10790006
ORDERS   DC    YL1(SBA),2X'0',YL1(RA),2X'0',X'40',YL1(SBA),2X'0'        10800006
LORDERS  EQU   *-ORDERS                                                 10810006
         SPACE 2                                                        10820006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10830006
*                                                                     * 10840006
*  OVERFLOW MESSAGE                                                   * 10850006
*                                                                     * 10860006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10870006
         SPACE 2                                                        10880006
MORE     DC    C'MORE...'                                               10890006
LMORE    DC    A(L'MORE+1)                                              10900006
         SPACE 2                                                        10910006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10920006
*                                                                     * 10930006
*  3270 ORDER EQUATES                                                 * 10940006
*                                                                     * 10950006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 10960006
         SPACE 2                                                        10970006
ALARM    EQU   X'04'                                                    10980006
RSTMDT   EQU   X'01'                                                    10990006
SBA      EQU   X'11'                                                    11000006
SF       EQU   X'1D'                                                    11010006
IC       EQU   X'13'                                                    11020006
PT       EQU   X'05'                                                    11030006
RA       EQU   X'3C'                                                    11040006
EUA      EQU   X'12'                                                    11050006
         SPACE 2                                                        11060006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 11070006
*                                                                     * 11080006
*  3270 COUNTING NUMBERS                                              * 11090006
*                                                                     * 11100006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 11110006
         SPACE 2                                                        11120006
CN3270   EQU   *                                                        11130006
         DC   X'40C1C2C3C4C5C6C7C8C94A4B4C4D4E4F'                       11140006
         DC   X'50D1D2D3D4D5D6D7D8D95A5B5C5D5E5F'                       11150006
         DC   X'6061E2E3E4E5E6E7E8E96A6B6C6D6E6F'                       11160006
         DC   X'F0F1F2F3F4F5F6F7F8F97A7B7C7D7E7F'                       11170006
         END   XTAPSMR                                                  11180006