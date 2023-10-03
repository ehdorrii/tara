XTAXREF  TITLE 'TARA CONSOLIDATED CROSS REFERENCE GENERATOR'            00010019
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020019
*                                                                     * 00030019
*   MODULE NAME - XTAXREF                                             * 00040019
*                                                                     * 00050019
*   FUNCTIONAL DESCRIPTION - THIS PROGRAM IS A TARA 'SERVICE AID.'    * 00060019
*     IT READS ASSEMBLY LISTINGS OF TARA MODULES AND PRODUCES A       * 00070019
*     CONSOLIDATED CROSS REFERENCE LISTING, SO THAT REFERENCES TO     * 00080019
*     COMMON DATA AREAS FROM ALL MODULES ARE GROUPED TOGETHER.  IN    * 00090019
*     THIS WAY, INTERACTIONS BETWEEN MODULES WHICH TAKE PLACE IN      * 00100019
*     THE COMMON DATA AREAS CAN BE SEEN.                              * 00110019
*                                                                     * 00120019
*   INPUT - THE ASSEMBLY LISTING CREATED BY THE ASSEMBLY OF TARA      * 00130019
*     MODULES.                                                        * 00140019
*                                                                     * 00150019
*   OUTPUT - THE INPUT DATASET IS PRINTED, FOLLOWED BY A CONSOL-      * 00160019
*     IDATED CROSS REFERENCE LISTING.                                 * 00170019
*                                                                     * 00190019
*   REQUIRED DD'S -                                                   * 00200019
*     ASMLIST: THE OUTPUT LISTING FROM THE ASSEMBLER                  * 00210019
*     REFLIST: THE OUTPUT FROM XTAXREF (RECFM=FBM,LRECL=121)          * 00220019
*     ALSO, STANDARD SORT DD'S REQUIRED BY THE INSTALLATION'S         * 00230019
*       SORT PROGRAM ARE ALSO NEEDED (E.G. SORTLIB, SORTWORK)         * 00240019
*                                                                     * 00250019
*   PRINCIPLE OF OPERATION - WHEN THE CHARACTERS 'XTA' ARE FOUND IN   * 00260019
*     POSITIONS 2-4 OF THE INPUT LISTING, THIS IS ASSUMED TO BE THE   * 00270019
*     CURRENT MODULE NAME.  WHEN THE CHARACTER '#' IS FOUND IN        * 00280019
*     POSITION 4 OF THE INPUT LISTING, THIS IS ASSUMED TO BE AN       * 00290019
*     ENTRY IN THE ASSEMBLER CROSS REFERENCE DICTIONARY TO A TARA     * 00300019
*     COMMON AREA OBJECT.  NOTE THAT 1.) ALL OBJECTS IN COMMON AREAS  * 00310019
*     MUST FOLLOW THE NAMING CONVENTION OF HAVING A '#' IN THE        * 00320019
*     THIRD POSITION OF THE NAME IN ORDER TO BE DETECTED BY XTAXREF;  * 00330019
*     AND 2.) OBJECTS IN UNIQUE AREAS WILL BE LISTED AS COMMON        * 00340019
*     IF THEY HAVE A '#' IN THE THIRD POSITION OF THE NAME FIELD.     * 00350019
*                                                                     * 00360019
*     THIS SIMPLE SCHEME WORKS SURPRISINGLY WELL.  IN FACT, THE       * 00370019
*     LINKAGE EDITOR LISTING MAY BE INCLUDED IN THE INPUT DATA        * 00380019
*     STREAM WITH NO ILL EFFECTS.                                     * 00390019
*                                                                     * 00440019
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00450019
         EJECT                                                          00451019
XTAXREF  CSECT                                                          00452019
         USING XTAXREF,R15         ESTABLISH TEMPORARY ADDRESSABILITY.  00470019
         B     AFTERID                                                  00480019
         SPACE 1                                                        00490019
ID       DC    YL1(IDLEN)          IDENTIFY PROGRAM AND VERSION.        00500019
         DC    CL8'XTAXREF'                                             00510019
         DC    CL8'&SYSDATE'                                            00520019
         DC    CL8'&SYSTIME'                                            00530019
IDLEN    EQU   *-ID                                                     00540019
         SPACE 1                                                        00550019
AFTERID  DS    0H                  NOW WE DO ALL THE STANDARD LINKAGE   00560019
         DROP  R15                   STUFF.                             00570019
         STM   R14,R12,12(R13)                                          00580019
         LR    R12,R15                                                  00590019
         USING XTAXREF,R12         ESTABLISH PERMANENT ADDRESSABILITY.  00600019
         ST    R13,MAINSAVE+4                                           00610019
         LA    R11,MAINSAVE                                             00620019
         ST    R11,8(R11)                                               00630019
         LR    R13,R11             FINISH UP SAVEAREA LINKAGE.          00640019
         SPACE 1                                                        00641019
         OPEN  (ASMLIST,(INPUT),REFLIST,(OUTPUT))                       00650019
         LA    R1,SORTPARM         POINT TO SORT ROUTINE PARAMETER      00660019
         LINK  EP=SORT               LIST, THEN CALL HIM.               00670019
         PUT   REFLIST,NEWPAGE                                          00671026
         CLOSE (ASMLIST,,REFLIST)  BUTTON UP I/O AND LEAVE.             00680019
         L     R13,MAINSAVE+4                                           00690019
         RETURN (14,12),RC=0       BYE!                                 00700019
         EJECT                                                          00710019
* - - - - - - - - - - - - - - SORT EXIT 15  - - - - - - - - - - - - - * 00720019
         SPACE 1                                                        00730019
EXIT15   EQU   *                                                        00740019
         STM   R14,R12,12(R13)        SAVE SORT'S REGISTERS, AND GET    00750019
         USING EXIT15,R15               ADDRESSABILITY LONG ENOUGH TO.. 00760019
         CNOP  0,4                                                      00770019
         BAL   R15,SKIP15             ..BRANCH PAST, AND POINT TO..     00780019
         DC    A(XTAXREF)             ..OUR ORIGINAL BASE ADDRESS..     00790019
SKIP15   L     R12,0(R15)             ..WHICH WE THEN RELOAD..          00800019
         DROP  15                     ..AND RE-ESTABLISH.               00810019
         LA    R15,EXITSAVE           NOW WE DO THE REGULAR STANDARD    00820019
         ST    R15,8(R13)               LINKAGE STUFF.                  00830019
         ST    R13,4(R15)                                               00840019
         LR    R13,R15                                                  00850019
         SPACE 1                                                        00860019
LOOP     EQU   *                                                        00870019
         GET   ASMLIST,RECORD         WE PRINT THE INPUT AS WE READ IT. 00880019
         PUT   REFLIST,RECORD                                           00890025
         CLI   RECORD+3,C'#'          IF THIS A COMMON-AREA SYMBOL,     00900019
         BE    REF                      PASS THE INPUT TO SORT.         00910019
         CLC   =C'XTA',RECORD+1       IF IT IS A PAGE-TITLE, SAVE THE   00920019
         BE    NAME                     MODULE NAME.                    00930019
         CLC   =CL10' ',RECORD+25     IF IT IS A BLANK LINE, OR A       00940019
         BE    LOOP                     COLUMN-HEADER LINE, THEN WE     00950019
         CLC   =C'DEFN  REFE',RECORD+25 IGNORE THOSE WITHOUT RESETTING  00960019
         BE    LOOP                     'COMMON SYMBOL DETECTED.'       00970019
         TM    FLAGS,CMNREF           WE IGNORE OTHER TYPES, TOO, BUT   00980019
         BZ    NOREF                    RESET CMNREF FIRST.             00990019
         CLC   =CL8' ',RECORD+1       HERE WE PICK UP CONTINUATION      01000019
         BE    REF                      LINES ON SYMBOL REFERENCES.     01010019
         SPACE 1                                                        01020019
NOREF    EQU   *                      'CMNREF' MEANS: THE LAST TIME WE  01030019
         NI    FLAGS,X'FF'-CMNREF       SAW A SYMBOL, IT WAS A COMMON   01040019
         B     LOOP                     AREA SYMBOL.                    01050019
         SPACE 1                                                        01060019
NAME     EQU   *                      WE NEED TO KEEP THE NAME OF THE   01070019
         MVC   MODNAME,RECORD+1         CURRENT MODULE TO PUT INTO      01080019
         B     LOOP                     REFERENCE ENTRIES.              01090019
         SPACE 1                                                        01100019
REF      EQU   *                      AHA!  WE HAVE FOUND A REFERENCE   01110019
         OI    FLAGS,CMNREF             TO A COMMON AREA SYMBOL.  IF    01120019
         CLC   =CL8' ',RECORD+1         THE NAME FIELD IS BLANK, THEN   01130019
         BNE   FIRSTREF                 THIS IS A CONTINUATION OF AN    01140019
         MVC   RECORD+1(8),SYMBOL       ENTRY; WE MUST TEMPORARILY      01150019
         B     CONTINUE                 RESTORE THE NAME FOR THE SORT.  01160019
         SPACE 1                                                        01170019
FIRSTREF EQU   *                      IF THERE IS A NAME, REMEMBER IT   01180019
         MVC   SYMBOL,RECORD+1          FOR POSSIBLE CONTINUATIONS.     01190019
         SPACE 1                                                        01200019
CONTINUE EQU   *                      NOW, WE PUT THE MODULE NAME INTO  01210019
         MVI   RECORD+10,C' '           THE RECORD, AND ELIDE ALL       01220019
         MVC   RECORD+11(8),MODNAME     FIELDS EXCEPT NAME AND          01230019
         MVI   RECORD+19,C' '           REFERENCES.                     01240019
         MVC   RECORD+20(90),RECORD+30                                  01250019
         LA    R1,RECORD              SHOW SORT WHERE THE RECORD IS,    01260019
         L     R13,EXITSAVE+4           AND GIVE IT TO HIM (RC=12       01270019
         ST    R1,24(R13)               MEANS 'INSERT RECORD').         01280019
         RETURN (14,12),RC=12                                           01290019
         SPACE 1                                                        01300019
ENDASM   EQU   *                      WE CAME HERE VIA THE EODAD ENTRY  01310019
         L     R13,EXITSAVE+4           IN THE DCB. RC=8 MEANS 'DO NOT  01320019
         RETURN (14,12),RC=8            RETURN' (I.E. END OF INPUT).    01330019
         EJECT                                                          01340019
* - - - - - - - - - - - - - - SORT EXIT 35  - - - - - - - - - - - - - * 01350019
         SPACE 1                                                        01360019
EXIT35   EQU   *                                                        01370019
         STM   R14,R12,12(R13)        ONCE AGAIN, WE PERFORM ALL THESE  01380019
         USING EXIT35,R15               FOOLISH CONTORTIONS, JUST TO    01390019
         CNOP  0,4                      GET BACK OUR ORIGINAL BASE      01400019
         BAL   R15,SKIP35               REGISTER (WHICH SORT STOLE      01410019
         DC    A(XTAXREF)               FROM US - THE SON OF A GUN!).   01420019
SKIP35   L     R12,0(15)                                                01430019
         DROP  15                                                       01440019
         LA    R15,EXITSAVE           SAVEAREA LINKAGE BLAH BLAH BLAH   01450019
         ST    R15,8(R13)                                               01460019
         ST    R13,4(R15)                                               01470019
         LR    R13,R15                                                  01480019
         SPACE 1                                                        01481019
         L     R7,0(R1)               GET POINTER TO RECORD SORT IS     01490019
         LTR   R7,R7                    GIVING US - IF HE ISN'T, THEN   01500019
         BZ    THATSIT                  WE ARE DONE.                    01510019
         SPACE 1                                                        01520019
         L     R6,LINECNT             FETCH LINE COUNTER, AND CHECK     01530019
         C     R6,=F'55'                FOR A FULL PAGE.  IF WE HAVE    01540024
         BL    NOHEAD                   A FULL PAGE, THEN WE EJECT AND  01550019
         L     R2,PAGECNT               WRITE OUT PAGE AND COLUMN       01560019
         LA    R2,1(R2)                 HEADINGS.  EXCITING STUFF, HUH? 01570021
         ST    R2,PAGECNT             HO-HUM...FORMAT A PAGE NUMBER     01580019
         CVD   R2,DWORD                 INTO THE PAGE TITLE...          01590023
         MVC   PAGENO,EDPATTRN                                          01610019
         ED    PAGENO,DWORD+6                                           01611023
         PUT   REFLIST,NEWPAGE        GO TO THE START OF A NEW PAGE,    01620019
         PUT   REFLIST,TITLE            AND PUT PAGE + COLUMN HEADERS.  01630019
         PUT   REFLIST,HEADER                                           01640019
         XC    LINECNT,LINECNT                                          01670019
         SPACE 1                                                        01680019
NOHEAD   EQU   *                      NOW, THE MEAT AND POTATOES...     01690019
         MVC   RECORD,0(R7)           GET THE RECORD FROM SORT, AND IF  01700019
         CLC   SYMBOL,RECORD+1          THE SYMBOL NAME IS THE SAME AS  01710019
         BNE   GETSYMB                  THE ONE WE JUST PRINTED,        01720019
         MVI   RECORD+1,C' '            REMOVE IT.                      01730019
         MVC   RECORD+2(7),RECORD+1                                     01740019
         B     PUT                                                      01750019
         SPACE 1                                                        01760019
GETSYMB  EQU   *                      BUT! IF IT'S A NEW SYMBOL, SAVE   01770019
         MVC   SYMBOL,RECORD+1          IT TO COMPARE THE NEXT ONE TO.  01780019
         SPACE 1                                                        01790019
PUT      EQU   *                      ENSURE THAT WE ARE ONLY GOING TO  01800019
         MVI   RECORD,X'09'             SPACE ONE LINE WHEN WE WRITE    01810019
         PUT   REFLIST,RECORD           THIS RECORD, AND WRITE IT.      01820019
         L     R6,LINECNT             INCREMENT THE LINE COUNTER.       01830019
         LA    R6,1(R6)                                                 01840019
         ST    R6,LINECNT                                               01850019
         L     R13,EXITSAVE+4         RETURN TO SORT...AWAITING MORE!   01860019
         RETURN (14,12),RC=4                                            01870019
         SPACE 1                                                        01880019
THATSIT  EQU   *                      WE CAME HERE BECAUSE SORT GAVE US 01890019
         L     R13,EXITSAVE+4           NOTHING; SO, WE RETURN FOREVER. 01900019
         RETURN (14,12),RC=8          SO LONG!                          01910019
         EJECT                                                          01920019
* - - - -  THE MISCELLANEOUS NUTS AND BOLTS OF THIS PROGRAM - - - - - * 01930019
         SPACE 1                                                        01940019
TITLE    DC    X'19',CL120'                                        TARA+01950019
                CONSOLIDATED CROSS REFERENCE LISTING'                   01960019
         ORG   *-9                                                      01970024
         DC    CL9'PAGE'                                                01980024
PAGENO   EQU   *-4,3                                                    01990024
         ORG                                                            01991024
HEADER   DC    X'11',CL120' SYMBOL    MODULE   REFERENCES'              02000019
NEWPAGE  DC    X'8B',CL120' '                                           02010021
RECORD   DS    CL121                                                    02020019
SYMBOL   DS    CL8                                                      02030019
MODNAME  DS    CL8                                                      02040019
DWORD    DS    D                                                        02050023
EDPATTRN DC    X'202120'                                                02051023
         SPACE 1                                                        02060019
FLAGS    DC    XL1'00'                                                  02070019
FIRSTIME EQU   B'10000000'                                              02080019
CMNREF   EQU   B'01000000'                                              02090019
*        EQU   B'00100000'                                              02100019
*        EQU   B'00010000'                                              02110019
*        EQU   B'00001000'                                              02120019
*        EQU   B'00000100'                                              02130019
*        EQU   B'00000010'                                              02140019
*        EQU   B'00000001'                                              02150019
         SPACE 1                                                        02160019
PAGECNT  DC    F'0'                                                     02170019
LINECNT  DC    F'100'                                                   02180019
         SPACE 1                                                        02190019
MAINSAVE DS    18F                                                      02200019
EXITSAVE DS    18F                                                      02210019
         EJECT                                                          02220019
* - - - - - - - - - - -  ASSEMBLY LISTING DCB - - - - - - - - - - - - * 02230019
         SPACE 1                                                        02240019
ASMLIST  DCB   MACRF=(GM),DDNAME=ASMLIST,EODAD=ENDASM,DSORG=PS          02250019
         EJECT                                                          02260019
* - - - - - - - - - - - OUR OUTPUT LISTING DCB  - - - - - - - - - - - * 02270019
         SPACE 1                                                        02280019
REFLIST  DCB   MACRF=(PM),DDNAME=REFLIST,DSORG=PS,                     +02290019
               LRECL=121,RECFM=FBM,BLKSIZE=1210                         02300019
         EJECT                                                          02310019
* - - - - - - - - - - -  SORT PARAMETER LIST  - - - - - - - - - - - - * 02320019
         SPACE 1                                                        02330019
         DS    0F                                                       02340019
SORTPARM DC    X'80',AL3(PARMLIST)                                      02350019
         SPACE 1                                                        02360019
         DS    H                                                        02370019
PARMLIST DC    H'24'                                                    02380019
         DC    A(SREC1)                                                 02390019
         DC    A(SREC1+L'SREC1-1)                                       02400019
         DC    A(SREC2)                                                 02410019
         DC    A(SREC2+L'SREC2-1)                                       02420019
         DC    A(EXIT15)                                                02430019
         DC    A(EXIT35)                                                02440019
         SPACE 1                                                        02450019
SREC1    DC    C' SORT FIELDS=(2,8,BI,A)    '                           02460019
SREC2    DC    C' RECORD LENGTH=121,TYPE=F  '                           02470019
         SPACE 1                                                        02480019
* - - - - - - - - - - - - REGISTER EQUATES  - - - - - - - - - - - - - * 02490019
         SPACE 1                                                        02500019
R0       EQU   0                                                        02510019
R1       EQU   1                                                        02520019
R2       EQU   2                                                        02530019
R3       EQU   3                                                        02540019
R4       EQU   4                                                        02550019
R5       EQU   5                                                        02560019
R6       EQU   6                                                        02570019
R7       EQU   7                                                        02580019
R8       EQU   8                                                        02590019
R9       EQU   9                                                        02600019
R10      EQU   10                                                       02610019
R11      EQU   11                                                       02620019
R12      EQU   12                                                       02630019
R13      EQU   13                                                       02640019
R14      EQU   14                                                       02650019
R15      EQU   15                                                       02660019
         SPACE 2                                                        02670019
         END                                                            02680019