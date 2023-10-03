XTASRRX  TITLE 'TARA SECONDARY RECEIVE RPL EXIT (8.0)'                  00010011
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020011
*                                                                     * 00030011
*     MODULE NAME - XTASRRX                                           * 00040011
*                                                                     * 00050011
*     FUNCTIONAL DESCRIPTION - XTASRRX PROCESSES INPUT FROM THE       * 00060011
*       SECONDARY HALF-SESSION.  WHEN DATA IS RECEIVED FROM THE       * 00070011
*       SECONDARY (THE EXTERNAL TIME-SHARING SERVICE), THIS           * 00080011
*       ROUTINE GETS CONTROL, DEFORMATS THE DATA, AND SENDS IT TO     * 00090011
*       THE PRIMARY (THE USER) VIA PSM.                               * 00100011
*                                                                     * 00110011
*     DRIVER - XTASRRX THIS RPL EXIT IS DRIVEN BY THE COMPLETION      * 00120011
*       OF A RECEIVE SPECIFIC ISSUED FOR THE SECONDARY.               * 00130011
*                                                                     * 00140011
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTASRRX.              * 00150011
*                                                                     * 00160011
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00170011
*       OF THE EPILOGUE MACRO.                                        * 00180011
*                                                                     * 00190011
*     REGISTERS ON ENTRY -                                            * 00200011
*       BEFORE PROLOGUE:                                              * 00210011
*         R0:  UNPREDICTABLE                                          * 00220011
*         R1:  ADDRESS OF RPL WHOSE OPERATION HAS JUST COMPLETED      * 00230011
*         R2-R13:  UNPREDICTABLE                                      * 00240011
*         R14: RETURN ADDRESS                                         * 00250011
*         R15: ENTRY ADDRESS                                          * 00260011
*       AFTER PROLOGUE:                                               * 00270011
*         R0:  UNPREDICTABLE                                          * 00280011
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00290011
*         R2-R8: UNPREDICTABLE                                        * 00300011
*         R9:  ADDRESS OF RPL WHOSE OPERATION HAS JUST COMPLETED      * 00310011
*         R10: POINTER TO COMMON STORAGE AREA                         * 00320011
*         R11: POINTER TO SESSION STORAGE AREA                        * 00330011
*         R12: ENTRY ADDRESS                                          * 00340011
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00350011
*         R14: RETURN ADDRESS                                         * 00360011
*         R15: ENTRY ADDRESS                                          * 00370011
*                                                                     * 00380011
*     MACROS USED -                                                   * 00390011
*       IBM MACROS:                                                   * 00400011
*         CHECK, FREEMAIN, GETMAIN, IFGRPL, SHOWCB                    * 00410011
*       NON-IBM MACROS:                                               * 00420011
*         EPILOGUE, PHASE, PROLOGUE                                   * 00430011
*                                                                     * 00440011
*     COPY MEMBERS:                                                   * 00450011
*       XTACMAP, XTASMAP                                              * 00460011
*                                                                     * 00470011
*     INPUT:                                                          * 00480011
*       THE RPL WHOSE COMPLETION DROVE THIS EXIT IS POINTED TO        * 00490011
*       BY R1. THE INPUT FROM THE SECONDARY IS IN SS#SIBUF IN THE     * 00500011
*       SESSION STORAGE AREA ASSOCIATED WITH THIS SESSION.            * 00510011
*                                                                     * 00520011
*     OUTPUT:                                                         * 00530011
*       THE INPUT RECEIVED FROM THE SECONDARY IS SENT TO THE          * 00540011
*       PRIMARY.                                                      * 00550011
*                                                                     * 00560011
*     ABENDS:                                                         * 00570011
*       NONE.                                                         * 00580011
*                                                                     * 00590011
*     MESSAGES ISSUED:                                                * 00600011
*       NO SYSTEM MESSAGES ARE ISSUED BY THIS MODULE.                 * 00610011
*                                                                     * 00620011
*     RETURN CODES:                                                   * 00630011
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00640011
*                                                                     * 00650011
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00660011
XTASRRX  PROLOGUE EXIT=RPL                                              00670011
         EJECT                                                          00680011
**                                                                      00690011
*                                                                       00700011
    PHASE 8.1 - CHECK THE RPL                                           00710011
*                                                                       00720011
**                                                                      00730011
         CHECK RPL=(R9)            PROLOGUE SETS UP R9 TO POINT AT RPL  00740011
         LTR   R15,R15             VERIFY SUCCESSFUL CHECK.             00750011
         BZ    PH8#2               IF CHECK WAS OK, CONTINUE.           00760011
         CLC   =X'0C0B',RPLRTNCD                                        00770011
         BE    PH8#99                                                   00780011
         B     PH8#99                                                   00790011
         GBLC  &IPAD                                                    00791015
         AIF   ('&IPAD' EQ 'INTEG').NOTYPE                              00792015
         EJECT                                                          00800011
**                                                                      00810011
*                                                                       00820011
    PHASE 8.2 - DETERMINE PACKET TYPE                                   00830011
*                                                                       00840011
**                                                                      00850011
         SPACE 1                                                        00860011
         CLI   SS#SIBUF,DATAPKT    CHECK THE FIRST BYTE OF THE RECEIVED 00870011
         BE    PH8#4                 DATA TO DETERMINE WHAT TYPE OF     00880011
         CLI   SS#SIBUF,QDATAPKT     PACKET WE HAVE, AND PROCESS THE    00890011
         BE    PH8#3                 RECEIVED DATA ACCORDINGLY.         00900011
         CLI   SS#SIBUF,RESETIND   FOR RESET AND INTERRUPT PACKETS, ALL 00910013
         BE    RESET                 WE DO IS SEND A RESET OR INTERRUPT 00920013
         CLI   SS#SIBUF,INTIND       CONFIRMATION PACKET TO THE         00930013
         BE    INTERUPT              ORIGINATOR.                        00940013
         SPACE 1                                                        00950011
IGNORE   EQU   *                                                        00960011
         L     R2,SS#SCID          THE ONLY OTHER TYPE WE MAY SEE ARE   00970011
         RECEIVE RPL=(R9),           CONFIRMATIONS, WHICH WE IGNORE.   X00980011
               ARG=(R2),                                               X00990011
               AREALEN=160                                              01000011
         B     PH8#99              EXIT.                                01010011
         EJECT                                                          01020013
RESET    EQU   *                                                        01030011
         MVI   SS#SIBUF,RSTCNFRM   THE APPROPRIATE RESPONSE TO RESET IS 01040011
         B     CONFIRM               RESET CONFIRMATION.                01050011
         SPACE 1                                                        01060011
INTERUPT EQU   *                                                        01070011
         MVI   SS#SIBUF,INTCNFRM   INTERRUPT YIELDS INT. CONFIRMATION.  01080011
         SPACE 1                                                        01090011
CONFIRM  EQU   *                                                        01100011
         L     R8,CS#ASNRX                                              01110011
         SEND  RPL=(R9),RECLEN=1,EXIT=(R8)                              01120011
         B     PH8#99                                                   01130011
         EJECT                                                          01140011
**                                                                      01150011
*                                                                       01160011
    PHASE 8.3 - PROCESS PAD COMMANDS                                    01170011
*                                                                       01180011
**                                                                      01190011
         SPACE 1                                                        01200011
         CLI   SS#SIBUF+1,PARMIND  CHECK THE PAD COMMAND BYTE (THE      01210013
         BE    IGNORE                FIRST BYTE OF THE MESSAGE PROPER). 01220013
         CLI   SS#SIBUF+1,SET        WE IGNORE PARAMETER INDICATION, IN 01230013
         BE    SETPAD                FACT WE PROBABLY SHOULDN'T EVER    01240013
         CLI   SS#SIBUF+1,READ       SEE THIS ANYWAY, BUT JUST IN CASE  01250013
         BE    READPAD               WE DO...  ANYWAY, SET, READ, AND   01260013
         CLI   SS#SIBUF+1,SET#READ   SET AND READ ARE PROCESSED AS      01270013
         BNE   IGNORE                APPROPRIATE.                       01280013
         SPACE 1                                                        01290011
         MVI   SS#SIBUF+1,PARMIND  SINCE THIS IS SET AND READ, WE WILL  01300011
         L     R8,CS#ASNRX           FIRST SEND A PARAMETERS INDICATION 01310011
         SEND  RPL=(R9),EXIT=(R8)    PACKET BACK TO THE SENDER.         01320011
         OI    SS#FLAG3,SS#PINDS   INDICATE THE SECD'Y RPL IS NOW BUSY. 01321013
         SPACE 1                                                        01330011
SETPAD   EQU   *                                                        01340013
         L     R3,RPLRLEN          THE PAD PARAMETERS, IF PRESENT, ARE  01350011
         SH    R3,=H'2'              ARE SPECIFIED BY BYTE-PAIRS        01360011
         LTR   R3,R3                 BEGINNING AT +2 IN THE INPUT       01370011
         BNP   IGNORE                STREAM. THE FIRST BYTE OF EACH     01371011
         SRL   R3,1                  PAIR IS THE PARAMETER ID, AND THE  01380011
         LA    R4,SS#PAD             SECOND BYTE IS THE VALUE THAT      01390011
         LA    R5,SS#SIBUF+2         PARAMETER IS TO BE SET TO.         01400011
         SLR   R6,R6                                                    01410011
         SPACE 1                                                        01420011
SETLOOP  EQU   *                   HERE WE LOOP THROUGH THE PARAMETERS, 01430011
         IC    R6,0(R5)              SETTING EACH VALUE AS WE GO. SINCE 01440013
         IC    R7,1(R5)              EACH PARAMETER VALUE MUST BE IN    01450013
         STC   R7,0(R6,R4)           THE RANGE 0-255, EACH CAN BE       01460013
         LA    R5,2(R5)              STORED IN A SINGLE BYTE - SO WE    01470013
         BCT   R3,SETLOOP            USE THE PARAMETER ID AS AN OFFSET  01480013
         TM    SS#FLAG3,SS#PINDS     INTO THE PAD PARAMETER LIST. NOTE  01481013
         BO    PH8#99                THAT THE X.29 IS EXTENSION         01482013
         B     IGNORE                PROVISION IS NOT SUPPORTED (YET).  01490013
         EJECT                                                          01500013
READPAD  EQU   *                   IN THE CASE OF READ PAD WITH         01510013
         L     R3,RPLRLEN            PARAMETERS REQUESTED, THE SETUP    01511013
         CH    R3,=H'2'              IS THE SAME AS FOR SET PAD, BUT    01512013
         BNH   IGNORE                FETCHING AND STORING OF PARAMETERS 01513013
         SH    R3,=H'2'              IS REVERSED - FROM THE PAD         01514013
         SRL   R3,1                  PARAMETER LIST INTO THE PARAMETERS 01515013
         LA    R4,SS#PAD             INDICATION PACKET.                 01516013
         LA    R5,SS#SIBUF+2                                            01517012
         SLR   R6,R6                                                    01518012
         SPACE 1                                                        01519012
READLOOP EQU   *                   IN THE CASE OF READ PAD WITH NO      01519113
         IC    R6,0(R5)              PARAMETERS SPECIFIED, I DON'T YET  01519213
         IC    R7,0(R6,R4)           KNOW WHICH PARAMETERS TO SEND,     01519313
         STC   R7,1(R5)              SO I'M COMPLETELY IGNORING SUCH    01519413
         LA    R5,2(R5)              REQUESTS FOR THE TIME BEING.       01519513
         BCT   R3,READLOOP                                              01519612
         SPACE 1                                                        01519712
         MVI   SS#SIBUF+1,PARMIND  INDICATE THAT THIS IS A PARAMETERS   01519812
         L     R8,CS#ASNRX           INDICATION PACKET, AND SEND TO THE 01519912
         SEND  RPL=(R9),EXIT=(R8)    REQUESTOR.                         01520012
         B     PH8#99                                                   01521012
.NOTYPE  ANOP                                                           01522015
         EJECT                                                          01530011
**                                                                      01540011
*                                                                       01550011
    PHASE 8.4 - CALL DATA CAPTURE TASK                                  01560011
*                                                                       01570011
**                                                                      01580011
         SPACE 1                                                        01590011
         L     R1,RPLRLEN          THE LENGTH OF THE DATA PASSED TO US. 01600011
         ST    R1,SS#SRSPL                                              01620011
         L     R6,SS#RCVCT         GET THE LATEST COUNT OF MESSAGES     01630011
         LA    R6,1(R6)              RECEIVED FROM THE SECONDARY,       01640011
         ST    R6,SS#RCVCT           UP IT BY 1, AND STORE IT BACK.     01650011
         TM    SS#FLAG4,SS#SAVON   CHECK WHETHER SAVE IS ACTIVE BEFORE  01660011
         BZ    PH8#5                 INVOKING CAPTURE ROUTINE.          01670011
         LA    R1,SS#SIBUF         BUILD THE PARAMETER LIST FOR THE     01680015
         ST    R1,SS#WORD1           CAPTURE ROUTINE AND POINT TO IT.   01690011
         L     R1,SS#SRSPL                +-----------+                 01700011
         ST    R1,SS#WORD2         R1 --> |  A(DATA)  |                 01710011
         LA    R1,SS#WORD1                +-----------+                 01720011
         L     R15,CS#ACPTR               |  L'DATA   |                 01730011
         BALR  R14,R15                    +-----------+                 01740011
         EJECT                                                          01750011
**                                                                      01760011
*                                                                       01770011
    PHASE 8.5 - CALL PSM(DATA)                                          01780011
*                                                                       01790011
**                                                                      01800011
         SPACE 1                                                        01810011
         MVI   SS#WORK1,DATA       INDICATE TO PSM WE ARE SENDING DATA. 01811016
         L     R6,SS#SRSPL         GET THE LENGTH OF THE INPUT DATA.    01820011
         BCTR  R6,0                DECR TO ACCOUNT FOR PACKET TYPE.     01830016
         STC   R6,SS#WORK1+1       TELL PSM HOW LONG IT IS.             01830116
         BCTR  R6,0                DECREMENT LENGTH FOR EX'D TR.        01830216
         EX    R6,TR               MAKE ANY CONTROL CHARS TO NULLS.     01840011
         EX    R6,MVC              GIVE THE DATA TO PSM.                01890011
         LA    R1,SS#WORK1         SHOW PSM WHERE ALL THIS INFO IS.     01900011
         L     R15,CS#APSMR        GET PSM ADDRESS FROM COMMON STORAGE. 01910011
         BALR  R14,R15             GO TO PSM.                           01920011
         EJECT                                                          01930011
**                                                                      01940011
*                                                                       01950011
    PHASE 8.99 - EXIT                                                   01960011
*                                                                       01970011
**                                                                      01980011
         NI    SS#FLAG3,X'FF'-SS#PINDS                                  01981012
         SLR   R15,R15             SET RETURN CODE TO ZERO.             01990011
         EPILOGUE                  EXIT.                                02000011
*********************************************************************** 02010011
*********************************************************************** 02020011
********                                                       ******** 02030011
********               END OF EXECUTABLE CODE                  ******** 02040011
********                                                       ******** 02050011
*********************************************************************** 02060011
*********************************************************************** 02070011
         TITLE 'DATA AREA'                                              02080011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02090011
*                                                                     * 02100011
*  SYMBOLICS FOR PACKET TYPES                                         * 02110011
*                                                                     * 02120011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02130011
         SPACE 2                                                        02140011
DATAPKT  EQU   X'00'               DATA PACKET                          02150011
QDATAPKT EQU   X'02'               DATA PACKET WITH Q-BIT SET           02160011
RESETIND EQU   X'1B'               RESET INDICATION                     02170011
RSTCNFRM EQU   X'1F'               RESET CONFIRMATION                   02180011
INTIND   EQU   X'23'               INTERRUPT INDICATION                 02190011
INTCNFRM EQU   X'27'               INTERRUPT CONFIRMATION               02200011
         SPACE 1                                                        02210011
PARMIND  EQU   X'00'               PARAMETER INDICATION                 02220011
SET      EQU   X'02'               SET PAD                              02230011
READ     EQU   X'04'               READ PAD                             02240011
SET#READ EQU   X'06'               SET AND READ PAD                     02250011
         SPACE 2                                                        02260011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02270011
*                                                                     * 02280011
*  EXECUTE OBJECTS                                                    * 02290011
*                                                                     * 02300011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02310011
         SPACE 2                                                        02320011
TR       TR    SS#SIBUF+1(0),DETWX                                      02330011
MVC      MVC   SS#WORK1+2(0),SS#SIBUF+1                                 02340011
         EJECT                                                          02350011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02360011
*                                                                     * 02370011
*  TRANSLATE TABLE FOR NULLIFYING TWX CONTROL CHARACTERS              * 02380011
*                                                                     * 02390011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02400011
         SPACE 2                                                        02410011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02420011
*                                                                     * 02430011
*  AS PER GG24-1569-0 (X.25 NPSI PAD IMPLEMENTATION GUIDE), THIS IS   * 02440011
*  THE TRANSLATE TABLE WHICH IS USED BY NPSI TO TRANSLATE FROM ASCII  * 02450011
*  (IA5) TO EBCDIC:                                                   * 02460011
*                                                                     * 02470011
*     BALXLTI  DS    0F                                               * 02480011
*              DC    X'00010203372D2E2F1605250B0C0D0E0F'              * 02490011
*              DC    X'101112133C3D322618193F271C1D1E1F'              * 02500011
*              DC    X'404F7F7B5B6C507D4D5D5C4E6B604B61'              * 02510011
*              DC    X'F0F1F2F3F4F5F6F7F8F97A5E4C7E6E6F'              * 02520011
*              DC    X'7CC1C2C3C4C5C6C7C8C9D1D2D3D4D5D6'              * 02530011
*              DC    X'D7D8D9E2E3E4E5E6E7E8E94AE05A5F6D'              * 02540011
*              DC    X'79818283848586878889919293949596'              * 02550011
*              DC    X'979899A2A3A4A5A6A7A8A9C06AD0A107'              * 02560011
*                                                                     * 02570011
*  WE DO ADDITIONAL TRANSLATION TO ELIDE ALL BUT THE FOLLOWING        * 02580011
*  CONTROL CHARACTERS:                                                * 02590011
*                                                                     * 02600011
*                 BEL  BS  HT  LF  VT  FF  CR                         * 02610011
*                                                                     * 02620011
*  THESE CODES (EXCEPT HT) ARE HANDLED BY XTAPSMR. HT IS TRANSLATED   * 02630011
*  TO A BLANK (X'40').                                                * 02640011
*                                                                     * 02650011
*  NOTE ALSO THAT THE ASCII CODE X'21', WHICH IS GENERALLY ACCEPTED   * 02660011
*  AS THE CODE FOR EXCLAMATION POINT, IS TRANSLATED BY NPSI TO X'4F'  * 02670011
*  (EBCDIC VERTICAL BAR!).  THIS TRANSLATE TABLE CHANGES X'4F' TO     * 02680011
*  X'5A' SO THAT CHANGES TO NPSI ARE UNNECESSARY.                     * 02690011
*                                                                     * 02700011
*  NOTE ALSO THAT THERE ARE ARE NUMBER OF ASCII GRAPHICS WHICH NPSI   * 02710011
*  DOES SOME QUESTIONABLE INTERPRETATIONS OF WHEN TRANSLATING TO      * 02720011
*  EBCDIC... THIS TRANSLATE TABLE RE-INTERPRETS SEVERAL CODE POINTS   * 02730011
*  AS DOCUMENTED HERE:                                                * 02740011
*                                                                     * 02750011
*  AS RECEIVED BY NPSI         NPSI TRANSLATES   PRRX TRANSLATES      * 02760011
*                                    TO                TO             * 02770011
*  ----ASCII---                ---EBCDIC---      ---EBCDIC---         * 02780011
*  CODE GRAPHIC                CODE GRAPHIC      CODE GRAPHIC         * 02790011
*                                                                     * 02800011
*   21  !                       4F  |            5A   !               * 02810011
*   5B  LEFT SQUARE BRACKET     4A  ¢            C0   LEFT BRACE      * 02820011
*   5D  RIGHT SQUARE BRACKET    5A  !            D0   RIGHT BRACE     * 02830011
*   5E  CARET                   5F  ¬            5F   ¬               * 02840011
*                                                                     * 02850011
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 02860011
         SPACE 2                                                        02870011
DETWX    EQU   *  0 1 2 3 4 5 6 7 8 9 A B C D E F                       02880011
         DC    X'00000000004000000000001004080000' 0X                   02890011
         DC    X'0000000000000C000000000000000000' 1X                   02900011
         DC    X'00000000001000000000000000000014' 2X                   02910011
         DC    X'00000000000000000000000000000000' 3X                   02920011
         DC    X'40404040404040404040C04B4C4D4E5A'                      02930011
         DC    X'50404040404040404040D05B5C5D5E5F'                      02940011
         DC    X'606140404040404040406A6B6C6D6E6F'                      02950011
         DC    X'404040404040404040797A7B7C7D7E7F'                      02960011
         DC    X'40818283848586878889404040404040'                      02970011
         DC    X'40919293949596979899404040404040'                      02980011
         DC    X'40A1A2A3A4A5A6A7A8A9404040404040'                      02990011
         DC    X'40404040404040404040404040404040'                      03000011
         DC    X'C0C1C2C3C4C5C6C7C8C9404040404040'                      03010011
         DC    X'D0D1D2D3D4D5D6D7D8D9404040404040'                      03020011
         DC    X'E040E2E3E4E5E6E7E8E9404040404040'                      03030011
         DC    X'F0F1F2F3F4F5F6F7F8F9FA4040404040'                      03040011
         END   XTASRRX                                                  03050011
* - - - - - - - -   THE SVC 99 REQUEST BLOCK POINTER  - - - - - - - - * 01900000
         SPACE 1                                                        01910000
         DS    0F                                                       01911000
S99RBPTR DC    A(S99RB)                                                 01920000
         SPACE 1                                                        01930000
* - - - - - - - - - -   THE SVC 99 REQUEST BLOCK  - - - - - - - - - - * 01940000
         SPACE 1                                                        01950000
         DS    0F                                                       01951000
S99RB    EQU   *                                                        01960000
S99RBLN  DC    X'14'          LENGTH OF THIS STRUCTURE                  01970000
S99VERB  DC    YL1(S99VRBAL)  VERB CODE = DSNAME ALLOCATE               01980001
S99FLAG1 DC    H'0'           FLAGS                                     01990000
S99ERROR DC    H'0'           ERROR CODE                                02000000
S99INFO  DC    H'0'           INFO CODE                                 02010000
S99TXTPP DC    A(S99TUPL)     POINTER TO TEXT UNIT POINTER LIST         02020000
         DC    F'0'           RESERVED                                  02030000
S99FLAG2 DC    F'0'           FLAGS                                     02040000
         SPACE 1                                                        02041001
* - - - - - - - - - - -   SVC 99 VERB EQUATES   - - - - - - - - - - - * 02042001
         SPACE 1                                                        02043001
S99VRBAL EQU   X'01'          DSNAME ALLOCATION                         02044001
S99VRBUN EQU   X'02'          DSNAME UNALLOCATION                       02044101
S99VRBCC EQU   X'03'          CONCATENATION                             02044201
S99VRBDC EQU   X'04'          DECONCATENATION                           02044301
S99VRBRI EQU   X'05'          REMOVE THE IN-USE ATTRIBUTE               02044401
S99VRBDN EQU   X'06'          DDNAME ALLOCATION                         02044501
S99VRBIN EQU   X'07'          INFORMATION RETRIEVAL                     02045001
         SPACE 1                                                        02050000
* - - - - - - - -  THE SVC 99 TEXT UNIT POINTER LIST  - - - - - - - - * 02060000
         SPACE 1                                                        02070000
         DS    0F                                                       02071000
S99TUPL  EQU   *                                                        02080000
ADDN     DC    A(DDN)                                                   02090000
ADSN     DC    A(DSN)                                                   02100000
AIDISP   DC    A(IDISP)                                                 02110000
ANDISP   DC    A(NDISP)                                                 02120000
ACDISP   DC    A(CDISP)                                                 02130000
ATRKS    DC    A(TRKS)                                                  02140000
APRISPC  DC    A(PRISPC)                                                02150000
ASECSPC  DC    A(SECSPC)                                                02160000
ARLSE    DC    A(RLSE)                                                  02170000
AVOLSER  DC    A(VOLSER)                                                02180000
AUNITYPE DC    A(UNITTYPE)                                              02190000
APS      DC    A(PS)                                                    02200000
AFB      DC    A(FB)                                                    02210000
ABLKSZ   DC    A(BLKSZ)                                                 02220000
ALRECL   DC    A(LRECL)                                                 02230000
         SPACE 1                                                        02240000
* - - - - - - - - - - -  THE SVC 99 TEXT UNITS  - - - - - - - - - - - * 02250000
         SPACE 1                                                        02260000
         DS    0H                                                       02261000
DDN      DC    X'0001',X'0001'                                          02270000
DDNLEN   DC    YL2(L'DDNAME)                                            02280000
DDNAME   DC    CL8' '                                                   02290000
         SPACE 1                                                        02300000
         DS    0H                                                       02301000
DSN      DC    X'0002',X'0001'                                          02310000
DSNLEN   DC    YL2(L'DSNAME)                                            02320000
DSNAME   DC    CL44'DATASET.NAME NOT.INITIALIZED'                       02330006
         SPACE 1                                                        02350000
         DS    0H                                                       02351000
IDISP    DC    X'0004',X'0001',X'0001'                                  02360000
INITDISP DC    YL1(NEW)                                                 02370000
         SPACE 1                                                        02380000
OLD      EQU   X'01'                                                    02390000
MOD      EQU   X'02'                                                    02400000
NEW      EQU   X'04'                                                    02410000
SHR      EQU   X'08'                                                    02420000
         SPACE 1                                                        02430000
         DS    0H                                                       02431000
NDISP    DC    X'0005',X'0001',X'0001'                                  02440000
NORMDISP DC    YL1(CATLG)                                               02450000
         SPACE 1                                                        02460000
         DS    0H                                                       02461000
CDISP    DC    X'0006',X'0001',X'0001'                                  02470000
CONDDISP DC    YL1(CATLG)                                               02480000
         SPACE 1                                                        02490000
UNCATLG  EQU   X'01'                                                    02500000
CATLG    EQU   X'02'                                                    02510000
DELETE   EQU   X'04'                                                    02520000
KEEP     EQU   X'08'                                                    02530000
         SPACE 1                                                        02540000
         DS    0H                                                       02541000
TRKS     DC    X'0007',X'0000'                                          02550000
         SPACE 1                                                        02560000
         DS    0H                                                       02561000
RLSE     DC    X'000D',X'0000'                                          02570000
         SPACE 1                                                        02580000
         DS    0H                                                       02581000
PRISPC   DC    X'000A',X'0001',X'0003'                                  02590000
PSPACE   DC    AL3(16)                                                  02600000
         SPACE 1                                                        02610000
         DS    0H                                                       02611000
SECSPC   DC    X'000B',X'0001',X'0003'                                  02620000
SSPACE   DC    AL3(8)                                                   02630000
         SPACE 1                                                        02640000
         DS    0H                                                       02641000
VOLSER   DC    X'0010',X'0001'                                          02650000
VOLLEN   DC    YL2(L'VOLUME)                                            02660000
VOLUME   DC    C'STG001'                                                02670003
         SPACE 1                                                        02680000
         DS    0H                                                       02681000
UNITTYPE DC    X'0015',X'0001'                                          02690000
UNITLEN  DC    YL2(L'UNIT)                                              02700000
UNIT     DC    C'DISK'                                                  02710000
         SPACE 1                                                        02720000
         DS    0H                                                       02721000
PS       DC    X'003C',X'0001',X'0002',X'4000'                          02730000
         DS    0H                                                       02731000
FB       DC    X'0049',X'0001',X'0001',X'90'                            02740000
         DS    0H                                                       02741000
BLKSZ    DC    X'0030',X'0001',X'0002',AL2(&CBLKSZ)                     02750004
         DS    0H                                                       02751000
LRECL    DC    X'0042',X'0001',X'0002',X'0084'                          02760004
         SPACE 1                                                        02770000
LENS99PL EQU   *-S99RBPTR                                               02780000