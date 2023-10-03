XTACLNP  TITLE 'TARA SESSION CLEANUP ROUTINE (19.0)'                    00010007
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020007
*                                                                     * 00030007
*     MODULE NAME - XTACLNP                                           * 00040007
*                                                                     * 00050007
*     FUNCTIONAL DESCRIPTION - XTACLNP RECORDS ERROR INFORMATION      * 00060007
*       AND INITIATES SESSION DELETION.                               * 00070007
*                                                                     * 00080007
*     DRIVER - CALLED VIA BALR.                                       * 00090007
*                                                                     * 00100007
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTACLNP.              * 00110007
*                                                                     * 00120007
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130007
*       OF THE EPILOGUE MACRO.                                        * 00140007
*                                                                     * 00150007
*     REGISTERS ON ENTRY -                                            * 00160007
*       BEFORE PROLOGUE:                                              * 00170007
*         R0-R13:  UNPREDICTABLE                                      * 00180007
*         R14: RETURN ADDRESS                                         * 00190007
*         R15: ENTRY ADDRESS                                          * 00200007
*       AFTER PROLOGUE:                                               * 00210007
*         R0:  UNPREDICTABLE                                          * 00220007
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00230007
*         R2-R9: UNPREDICTABLE                                        * 00240007
*         R10: POINTER TO COMMON STORAGE AREA                         * 00250007
*         R11: POINTER TO SESSION STORAGE AREA.                       * 00260007
*         R12: ENTRY ADDRESS                                          * 00270007
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00280007
*         R14: RETURN ADDRESS                                         * 00290007
*         R15: ENTRY ADDRESS                                          * 00300007
*                                                                     * 00310007
*     MACROS USED -                                                   * 00320007
*       IBM MACROS:                                                   * 00330007
*         CLSDST, FREEMAIN, GETMAIN, SNAP, WTO                        * 00340007
*       NON-IBM MACROS:                                               * 00350007
*         CVH, EPILOGUE, PHASE, PROLOGUE                              * 00360007
*                                                                     * 00370007
*     COPY MEMBERS:                                                   * 00380007
*       XTACMAP                                                       * 00390007
*                                                                     * 00400007
*     INPUT:                                                          * 00410007
*       THE FAILING RPL.                                              * 00420007
*                                                                     * 00430007
*     OUTPUT:                                                         * 00440007
*       WTO MESSAGES AS LISTED UNDER "MESSAGES ISSUED". ALSO,         * 00450007
*       SESSION STORAGE IS WRITTEN TO THE XTASNAP DATASET.            * 00460007
*                                                                     * 00470007
*     ABENDS:                                                         * 00480007
*       NONE.                                                         * 00490007
*                                                                     * 00500007
*     MESSAGES ISSUED:                                                * 00510007
*       THE FOLLOWING ARE ISSUED VIA WTO:                             * 00520007
*        XTA1901 FAILURE ON SESSION WITH ........                     * 00530007
*        XTA1901 ......... RPL RTNCD/FDBK2=....                       * 00540007
*                                                                     * 00550007
*     RETURN CODES:                                                   * 00560007
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00570007
*                                                                     * 00580007
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00620007
         SPACE 1                                                        00630007
XTACLNP  PROLOGUE SUBR=CLEANUP                                          00640007
         EJECT                                                          00650007
**                                                                      00660007
*                                                                       00670007
    PHASE  19.1 - PREVENT RECURSIVE ERRORS                              00680007
*                                                                       00690007
**                                                                      00700007
         TM    SS#FLAG1,SS#ALLDN   IF NORMAL CLEANUP IS REQUESTED,      00710007
         BO    PH19#6                BE NICE ABOUT IT.                  00720007
         TM    SS#FLAG1,SS#CLNUP   IF WE WERE HERE BEFORE, FOR THIS     00730007
         BZ    PH19#2                SESSION, WRITE A MESSAGE TO THE    00740007
         MVC   SS#WORK1(LWTO3),WTO3     CONSOLE INDICATING THAT A       00750007
         MVC   SS#WORK1+12(8),SS#PNODE  RECURSIVE ERROR HAS OCCURRED    00760007
         LA    R4,SS#WORK1              ON THIS SESSION, AND...         00770007
         WTO   MF=(E,(R4))                                              00780007
         STIMER WAIT,DINTVL=PAUSE                                       00790011
         B     SUSPEND                                                  00800007
         EJECT                                                          00810007
**                                                                      00820007
*                                                                       00830007
    PHASE  19.2 - INFORM OPERATOR OF SESSION FAILURE                    00840007
*                                                                       00850007
**                                                                      00860007
         OI    SS#FLAG1,SS#CLNUP        SHOW WE HAVE BEEN HERE.         00870007
         MVC   SS#WORK1(LWTO1),WTO1     PREPARE THE MESSAGE TEMPLATE.   00880007
         MVC   SS#WORK1+36(8),SS#PNODE  INDICATE THE FAILING NODE.      00890007
         LA    R4,SS#WORK1              POINT TO THE MESSAGE,           00900007
         WTO   MF=(E,(R4))                AND WRITE IT TO THE CONSOLE.  00910007
         MVC   SS#WORK1(LWTO2),WTO2     PREPARE THE NEXT MESSAGE.       00920007
         MVC   SS#WORK1+12(9),=CL9'PRIMARY'  EACH OF THE POSSIBLE RPL   00930007
         C     R9,SS#APRPL                   NAMES IS PLACED IN THE     00940007
         BE    IDFDRPL                       MESSAGE TEXT IN            00950007
         MVC   SS#WORK1+12(9),=CL9'ECHO'     ANTICIPATION OF A MATCH.   00960007
         C     R9,SS#AERPL                                              00970007
         BE    IDFDRPL                                                  00980007
         MVC   SS#WORK1+12(9),=CL9'SECONDARY'                           00990007
         C     R9,SS#ASRPL                                              01000007
         BE    IDFDRPL                                                  01010007
         MVC   SS#WORK1+12(9),=CL9'CLSDST'                              01020007
         C     R9,SS#ACRPL                                              01030007
         BE    IDFDRPL                                                  01040007
         MVC   SS#WORK1+12(9),=CL9'UNKNOWN'                             01050007
         SPACE 1                                                        01060007
IDFDRPL  EQU   *                        AN APPROPRIATE RPL NAME IS NOW  01070007
         USING IFGRPL,R9                  IN THE MESSAGE TEXT.          01080007
         ICM   R4,15,RPLRTNCD           NOW WE EXTRACT THE RTNCD/FDBK2  01090007
         DROP  R9                         FIELDS TO PLACE IN THE MSG.   01100007
         CVH   R4,SS#WORK2,MF=LONG                                      01110007
         MVC   SS#WORK1+38(4),SS#WORK2                                  01120007
         LA    R4,SS#WORK1              POINT TO THE SECOND MESSAGE,    01130007
         WTO   MF=(E,(R4))                AND SEND TO THE CONSOLE.      01140007
         EJECT                                                          01150007
**                                                                      01160007
*                                                                       01170007
    PHASE  19.3 - LOG ERROR INFORMATION                                 01180007
*                                                                       01190007
**                                                                      01200007
         MVI   SS#WORK1,FERROR          INDICATE THAT IS IS ERROR DATA. 01210010
         MVI   SS#WORK1+1,L'CS#THEN+1   WE ARE WRITING THE TRACE AREA   01220010
         MVI   SS#WORK1+2,1             01=PHASE TRACE                  01230010
         MVC   SS#WORK1+3(L'CS#THEN),CS#THEN  TO THE LOG.               01240010
         LA    R1,SS#WORK1              POINT TO THE LOG RECORD,        01250007
         L     R15,CS#ALOGR               AND CALL THE LOGGER.          01260007
         BALR  R14,R15                                                  01270007
         MVI   SS#WORK1,FERROR          MORE ERROR DATA.                01280010
         MVI   SS#WORK1+1,112+1         THIS TIME WE ARE WRITING THE    01290010
         MVI   SS#WORK1+2,2             02=RPL                          01300010
         MVC   SS#WORK1+3(112),0(R9)      FAILING RPL TO THE LOG.       01310010
         LA    R1,SS#WORK1              AGAIN, POINT TO THE LOG RECORD, 01320007
         L     R15,CS#ALOGR               AND CALL THE LOGGER.          01330007
         BALR  R14,R15                                                  01340007
         EJECT                                                          01350007
**                                                                      01360007
*                                                                       01370007
    PHASE  19.4 - TAKE SNAPSHOT OF TRACE AREA AND SDB                   01380007
*                                                                       01390007
**                                                                      01400007
         GETMAIN R,LV=512,SP=0                                          01410007
         LTR   R15,R15                                                  01420007
         BZ    GOTMAIN                                                  01430007
         WTO   'XTA1904 GETMAIN FOR CLEANUP SNAP FAILED.',             X01440007
               ROUTCDE=(2,11),DESC=(6)                                  01450007
         B     PH19#5                                                   01460007
         SPACE 1                                                        01470007
GOTMAIN  EQU   *                                                        01480007
         LR    R6,R1                                                    01490007
         USING SNAPLIST,R6                                              01500007
         MVC   ALABEL1(LLLENGTH),LABELIST                               01510008
         LA    R5,CS#THEN           POINT TO THE TRACE AREA, ADD IN ITS 01520007
         ST    R5,START1              LENGTH AND SUBTRACT 1 - THIS      01530007
         LA    R4,L'CS#THEN+L'CS#NOW  GIVES THE ADDRESS OF THE LAST     01540007
         AR    R4,R5                  BYTE TO BE DUMPED.                01550007
         BCTR  R4,0                                                     01560007
         ST    R4,END1                                                  01570007
         ST    R11,START2           POINT SNAP AT THE SDB, ADD IN SDB   01580007
         L     R4,SS#LNGTH            LENGTH AND SUBTRACT ONE. SOUND    01590007
         AR    R4,R11                 FAMILIAR?                         01600007
         BCTR  R4,0                                                     01610007
         ST    R4,END2                                                  01620007
         LA    R1,ALABEL2           GET READY TO FLAG THESE ENTRIES AS  01630007
         LA    R2,START2              LAST IN THE SNAP PARAMETER LIST.  01640007
         L     R3,SS#ACCBA                                              01650007
         USING XTACCBA,R3                                               01660007
         LTR   R3,R3                IF THERE IS NO CCBA, THEN WE ARE    01670007
         BZ    DOSNAP                 ALL READY TO DUMP.                01680007
         LR    R4,R3                BUT IF THERE IS A CCBA, THEN WE     01690007
         ST    R4,START3              MUST BUILD PARAMETERS TO DUMP     01700007
         A     R4,CC#LCCBA            IT TOO.                           01710007
         BCTR  R4,0                                                     01720007
         ST    R4,END3                                                  01730007
         LA    R1,ALABEL3           GET READY TO FLAG _THESE_ AS THE    01740007
         LA    R2,START3              LAST PARAMETERS IN SNAP PARMLIST. 01750007
         L     R3,CC#AFBFR          CHECK FOR THE PRESENCE OF ANY I/O   01760007
         LTR   R3,R3                  BLOCKS, AND DUMP THEM IF THEY     01770007
         BZ    DOSNAP                 EXIST.                            01780007
         DROP  R3                                                       01790007
         USING XTAIOBL,R3                                               01800007
         LA    R1,ALABEL4                                               01810007
         LA    R2,START4                                                01820007
         SPACE 1                                                        01830007
IOBLOOP  EQU   *                    BUILD AN ENTRY IN THE SNAP          01840007
         LR    R4,R3                  PARAMETER LIST FOR EACH I/O       01850007
         ST    R4,0(R2)               BLOCK IN THE CHAIN.               01860007
         A     R4,IB#LIOBL                                              01870007
         BCTR  R4,0                                                     01880007
         ST    R4,4(R2)                                                 01890007
         L     R3,IB#NEXT                                               01900007
         LA    R2,8(R2)                                                 01910007
         LTR   R3,R3                                                    01920007
         BNZ   IOBLOOP                                                  01930007
         SPACE 1                                                        01940007
DOSNAP   EQU   *                                                        01950007
         OI    0(R1),X'80'          FLAG THE END OF THE LABEL AND       01960007
         OI    4(R2),X'80'            ADDRESS LISTS.                    01970007
         LA    R3,CS#SNAP                                               01980007
         LA    R4,START1                                                01990008
         LA    R5,ALABEL1                                               02000007
         SNAP  DCB=(R3),LIST=(R4),STRHDR=(R5),SDATA=(TRT),PDATA=(SA)    02010007
         FREEMAIN R,A=(R6),LV=512                                       02020007
         EJECT                                                          02030007
**                                                                      02040007
*                                                                       02050007
    PHASE  19.5 - START CLEANUP PROCESS                                 02060007
*                                                                       02070007
**                                                                      02080007
         L     R4,SS#APRPL          POINT TO OUR FIRST RPL, AND CHECK   02090007
         USING IFGRPL,R4              TO SEE WHETHER IT IS IN USE.      02100007
         SPACE 1                                                        02110007
TRYNEXT  EQU   *                                                        02120007
         CLI   RPLACTIV,X'FF'       IF THE RPL IS NOT BUSY, USE IT FOR  02130007
         BNE   TRYCLOSE               THE CLSDST; OTHERWISE, STEP TO    02140007
         SLR   R3,R3                  THE NEXT RPL AND TRY IT AGAIN.    02150007
         IC    R3,RPLLEN                                                02160007
         AR    R4,R3                                                    02170007
         C     R4,SS#ACRPL          IF WE GET TO THE LAST RPL WITHOUT   02180007
         BNH   TRYNEXT                SUCCESS, SUSPEND THE SESSION.     02190007
         B     SUSPEND                                                  02200007
         DROP  R4                                                       02210007
         SPACE 1                                                        02220007
TRYCLOSE EQU   *                    WE INITIATE THE CLEANUP PROCESS BY  02230007
         L     R5,CS#ACLDX            CLSDST'G THE PRIMARY; CLDX WILL   02240007
         L     R6,SS#PCID             CLSDST THE SEC'Y IF NECESSARY.    02250007
         O     R4,BIT0              SET RECURSION FLAG FOR LERAD/SYNAD. 02260007
         CLSDST RPL=(R4),OPTCD=(ASY,RELEASE),EXIT=(R5),ARG=(R6)         02270007
         LTR   R15,R15              IF THE CLSDST WAS ACCEPTED, WE ARE  02280007
         BZ    PH19#99                ALL DONE HERE.                    02290007
         SPACE 1                                                        02300007
SUSPEND  EQU   *                                                        02310007
         OI    SS#FLAG1,SS#SUSPD   SHOW THIS SESSION SUSPENDED.         02320007
*        L     R3,CS#SSNCT         GET SESSION COUNT.                   02330007
*        SH    R3,=H'1'            DECREMENT IT,                        02340007
*        ST    R3,CS#SSNCT           AND UPDATE THE COUNT.              02350007
*        LTR   R3,R3               DID IT UPDATE TO ZERO?               02360007
*        BP    PH19#99             IF NOT, JUST LEAVE.                  02370007
*        POST  CS#ECBID            ELSE INFORM MAINLINE.                02380007
         B     PH19#99                                                  02390007
         EJECT                                                          02400007
**                                                                      02410007
*                                                                       02420007
    PHASE  19.6 - PERFORM NORMAL CLEANUP PROCESSING                     02430007
*                                                                       02440007
**                                                                      02450007
*        NI    SS#FLAG1,X'FF'-SS#ALLDN                                  02460013
*        USING IFGRPL,R9                                                02470013
*        L     R9,SS#APRPL         BEFORE WE DELETE SESSION STORAGE,    02480013
*        CLI   RPLACTIV,0            WE WANT TO ENSURE THAT NONE OF     02490013
*        BNE   PH19#1                THE RPL'S ARE BEING USED.          02500013
*        L     R9,SS#AERPL           (IF ANY OF THEM ARE STILL IN USE,  02510013
*        CLI   RPLACTIV,0            SOMETHING IS SERIOUSLY WRONG.)     02520013
*        BNE   PH19#1                                                   02530013
*        L     R9,SS#ASRPL                                              02540013
*        CLI   RPLACTIV,0                                               02550013
*        BNE   PH19#1                                                   02560013
*        L     R9,SS#ACRPL                                              02570013
*        CLI   RPLACTIV,0                                               02580013
*        DROP  R9                                                       02590013
*        BNE   PH19#1                                                   02600013
*                                  RECHAIN SESSION STORAGE AREAS        02610007
         L     R2,SS#NEXT          ADDRESS OF NEXT SSA                  02620007
         L     R3,SS#PREV          ADDRESS OF PREVIOUS SSA              02630007
         LTR   R2,R2               IS THIS AN END OF CHAIN?             02640007
         BNZ   PH19#6A             IF NOT AVOID USE OF QAB              02650007
         LA    R2,CS#SSQAB         POINT TO COMMON STORAGE QAB          02660007
         DROP  R11                                                      02670007
         USING XTASMAP,R2                                               02680007
PH19#6A  EQU   *                                                        02690007
         ST    R3,SS#PREV          MAKE THE CHANGE TO THE BACK CHAIN    02700007
         DROP  R2                                                       02710007
         USING XTASMAP,R11                                              02720007
         L     R2,SS#NEXT          RESTORE NEXT POINTER                 02730007
         LTR   R3,R3               IS THIS AN END OF CHAIN?             02740007
         BNZ   PH19#6B             IF NOT AVOID USE OF QAB              02750007
         LA    R3,CS#SSQAB         POINT TO COMMON STORAGE QAB          02760007
         DROP  R11                                                      02770007
         USING XTASMAP,R3                                               02780007
PH19#6B  EQU   *                                                        02790007
         ST    R2,SS#NEXT          MAKE THE CHANGE TO THE FORWARD CHAIN 02800007
         DROP  R3                                                       02810007
         USING XTASMAP,R11                                              02820007
         SPACE                                                          02830007
         LR    R1,R11              LOAD ADDRESS OF SESSION STORAGE      02840007
         L     R0,SS#LNGTH         LOAD LENGTH OF SESSION STORAGE       02850007
         FREEMAIN R,A=(R1),LV=(R0) FREE SESSION STORAGE                 02860007
         L     R2,CS#SSNCT         LOAD COUNT OF MAJOR SESSIONS         02870007
         SH    R2,=H'1'            DECREMENT THE COUNT                  02880007
         BM    POST                                                     02890007
         ST    R2,CS#SSNCT         SAVE THE COUNT                       02900007
         BP    PH19#99             YES, THERE ARE SESSIONS - EXIT       02910007
         SPACE                                                          02920007
POST     EQU   *                                                        02930007
         POST  CS#ECBID            NOTIFY MAINLINE OF IDLE CONDITION    02940007
         EJECT                                                          02950007
**                                                                      02960007
*                                                                       02970007
    PHASE  19.99 - EXIT                                                 02980007
*                                                                       02990007
**                                                                      03000007
         SLR   R15,R15             SET RETURN CODE TO ZERO.             03010007
         EPILOGUE                                                       03020007
*********************************************************************** 03030007
*********************************************************************** 03040007
********                                                       ******** 03050007
********               END OF EXECUTABLE CODE                  ******** 03060007
********                                                       ******** 03070007
*********************************************************************** 03080007
*********************************************************************** 03090007
         EJECT                                                          03100007
         DS    0F                                                       03110007
BIT0     DC    X'80000000'                                              03120007
         SPACE 1                                                        03130007
WTO1     WTO   'XTA1902 FAILURE ON SESSION WITH ........',             +03140007
               ROUTCDE=(2,11),DESC=(6),MF=L                             03150007
LWTO1    EQU   *-WTO1                                                   03160007
         SPACE 2                                                        03170007
WTO2     WTO   'XTA1902 ......... RPL RTNCD/FDBK2=....',               +03180007
               ROUTCDE=(2,11),DESC=(6),MF=L                             03190007
LWTO2    EQU   *-WTO2                                                   03200007
         SPACE 2                                                        03210007
WTO3     WTO   'XTA1901 ........ RECURSIVE ERROR - SESSION SUSPENDED', +03220007
               ROUTCDE=(2,11),DESC=(6),MF=L                             03230007
LWTO3    EQU   *-WTO2                                                   03240007
         SPACE 1                                                        03250007
         DS    0D                                                       03260011
PAUSE    DC    C'00000200'                                              03270012
         SPACE 1                                                        03280011
         DS    0F                                                       03290011
LABELIST EQU   *                                                        03300008
         DC    A(LABEL1)                                                03310008
         DC    A(LABEL2)                                                03320008
         DC    A(LABEL3)                                                03330008
         DC    A(LABEL4)                                                03340008
LLLENGTH EQU   *-LABELIST                                               03350008
         SPACE 1                                                        03360007
LABEL1   DC    YL1(L'LABEL1T)                                           03370007
LABEL1T  DC    C'PHASE TRACE AREA'                                      03380007
LABEL2   DC    YL1(L'LABEL2T)                                           03390007
LABEL2T  DC    C'SESSION STORAGE AREA'                                  03400007
LABEL3   DC    YL1(L'LABEL3T)                                           03410007
LABEL3T  DC    C'CAPTURE CONTROL BLOCK AREA'                            03420007
LABEL4   DC    YL1(L'LABEL4T)                                           03430007
LABEL4T  DC    C'I/O BLOCK(S)'                                          03440007
         SPACE 1                                                        03450007
SNAPLIST DSECT                                                          03460007
ALABEL1  DS    A                                                        03470008
ALABEL2  DS    A                                                        03480008
ALABEL3  DS    A                                                        03490008
ALABEL4  DS    A                                                        03500008
START1   DS    A                                                        03510007
END1     DS    A                                                        03520007
START2   DS    A                                                        03530007
END2     DS    A                                                        03540007
START3   DS    A                                                        03550007
END3     DS    A                                                        03560007
START4   DS    A                                                        03570008
END4     DS    A                                                        03580008
         END   XTACLNP                                                  03590007