XTACPTR  TITLE 'TARA DATA CAPTURE ROUTINE - (23.0)'                     00010015
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020015
*                                                                     * 00030015
*     MODULE NAME - XTACPTR                                           * 00040015
*                                                                     * 00050015
*     FUNCTIONAL DESCRIPTION - XTACPTR PROCESSES DATA TO BE           * 00060015
*       WRITTEN TO THE CAPTURE DATASET.                               * 00070015
*                                                                     * 00080015
*     DRIVER - VIA BALR FROM XTAPRRX AND XTASRRX.                     * 00090015
*                                                                     * 00100015
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTACPTR.              * 00110015
*                                                                     * 00120015
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130015
*       OF THE EPILOGUE MACRO.                                        * 00140015
*                                                                     * 00150015
*     REGISTERS ON ENTRY -                                            * 00160015
*       BEFORE PROLOGUE:                                              * 00170015
*         R0:  UNPREDICTABLE                                          * 00180015
*         R1:  POINTER TO PARAMETER LIST                              * 00190015
*         R2-R8:  UNPREDICTABLE                                       * 00200015
*         R9:  POINTER TO CURRENT RPL                                 * 00210015
*         R10: POINTER TO COMMON STORAGE AREA                         * 00220015
*         R11: POINTER TO SESSION STORAGE AREA                        * 00230015
*         R12: CALLER'S ENTRY POINT                                   * 00240015
*         R13: SAVE AREA                                              * 00250015
*         R14: RETURN ADDRESS                                         * 00260015
*         R15: ENTRY ADDRESS                                          * 00270015
*       AFTER PROLOGUE:                                               * 00280015
*         R0:  UNPREDICTABLE                                          * 00290015
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00300015
*         R2-R6: UNPREDICTABLE                                        * 00310015
*         R7:  POINTER TO PARAMETER LIST                              * 00320015
*         R8:  UNPREDICTABLE                                          * 00330015
*         R9:  POINTER TO CURRENT RPL                                 * 00340015
*         R10: POINTER TO COMMON STORAGE AREA                         * 00350015
*         R11: POINTER TO SESSION STORAGE AREA                        * 00360015
*         R12: ENTRY ADDRESS                                          * 00370015
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00380015
*         R14: RETURN ADDRESS                                         * 00390015
*         R15: ENTRY ADDRESS                                          * 00400015
*                                                                     * 00410015
*     INPUT -                                                         * 00411026
*       THE INPUT PARAMETER LIST:                                     * 00412026
*         +0  ADDRESS OF DATA TO BE WRITTEN.                          * 00413026
*         +4  LENGTH OF DATA TO BE WRITTEN (FULLWORD).                * 00414026
*                                                                     * 00415026
*     MACROS USED -                                                   * 00420015
*       IBM MACROS:                                                   * 00430015
*         GETMAIN, FREEMAIN, POST                                     * 00440026
*       NON-IBM MACROS:                                               * 00450015
*         EPILOGUE, PHASE, PROLOGUE, GETLOCK, RLSLOCK                 * 00460026
*                                                                     * 00470015
*     COPY MEMBERS:                                                   * 00480015
*       XTACMAP, XTASMAP                                              * 00490015
*                                                                     * 00500015
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00510015
         EJECT                                                          00520015
XTACPTR  PROLOGUE SUBR=CAPTURE                                          00530015
         EJECT                                                          00540015
**                                                                      00550015
*                                                                       00560015
    PHASE  23.1 - ADD THE NEW REQUEST TO THE I/O BLOCK.                 00570015
*                                                                       00580015
**                                                                      00590015
         SPACE 1                                                        00600015
         TM    SS#FLAG4,SS#SAVON   ENSURE THAT DATA CAPTURE IS ACTIVE   00610015
         BZ    PH23#99               BEFORE PROCESSING REQUEST.         00620015
         SPACE 1                                                        00630015
         L     R2,0(R7)            GET THE DATA ADDRESS INTO R2, AND    00640016
         L     R3,4(R7)              ITS LENGTH INTO R3.                00650016
         L     R7,SS#ACCBA                                              00660015
         GETLOCK SS#TLOCK                                               00670015
         USING XTACCBA,R7          START OUT WITH A POINTER TO THE      00680015
         L     R7,CC#AFBFR           FIRST IOBL ON THE IOBL QUEUE...    00690015
         DROP  R7                                                       00700015
         USING XTAIOBL,R7                                               00710015
         SPACE 1                                                        00720015
ACTLOOP  EQU   *                   ...AND TRAVERSE THE QUEUE UNTIL      00730015
         TM    IB#FLAGS,IB#ACTIV     THE ACTIVE IOBL IS FOUND.          00740015
         BO    ACTVIOBL                                                 00750015
         L     R7,IB#NEXT                                               00760015
         LTR   R7,R7                                                    00770015
         BZ    PH23#99             FOR NOW, IF THERE IS NO ACTIVE       00780015
         B     ACTLOOP               IOBL (AN ERROR), QUIT.             00790015
         SPACE 1                                                        00800015
ACTVIOBL EQU   *                   NOW THAT WE ARE POINTED TO THE       00810015
         L     R5,IB#FREEC           ACTIVE IOBL, GET THE OFFSET OF     00820016
         GBLA  &CBLKSZ               THE FIRST FREE LOCATION INTO R5.   00840016
         SPACE 1                                                        00860015
LOOP     EQU   *                   SCREEN OUT CONTROL CHARACTERS.       00870015
         CLI   0(R2),C' '                                               00880016
         BL    CONTROL                                                  00890015
         SLR   R4,R4                                                    00890127
         IC    R4,0(R2)            MOVE GRAPHIC CHARACTERS FROM INPUT   00891016
         IC    R4,GRAFIX(R4)         AREA TO BUFFER, "TRANSLATING" AS   00892026
         STC   R4,IB#DATA(R5)        WE FETCH EACH BYTE.                00900026
         LA    R5,1(R5)            BUMP BUFFER PTR AND ENSURE WE DON'T  00920019
         B     CKRANGE               EXCEED THE BLOCK'S UPPER BOUND.    00930019
         SPACE 1                                                        00940015
CONTROL  EQU   *                   PROCESS CONTROL CHARACTERS.          00950015
         CLI   0(R2),X'0D'  CR     THE FOLLOWING CONTROL CHARACTERS     00960017
         BE    CR                    ARE PROCESSED:                     00970017
         CLI   0(R2),X'25'  LF                                          00980016
         BE    LF                    CR  -  RESET TO START OF LINE      00990017
         CLI   0(R2),X'0B'  VT       LF  -  INCREMENT ONE LINE          00991017
         BE    LF                    BS  -  BACK UP ONE POSITION        00992017
         CLI   0(R2),X'16'  BS       HT  -  SKIP ONE POSITION           00993017
         BE    BS                    VT  -  INCREMENT ONE LINE          00994017
         CLI   0(R2),X'05'  HT                                          00995017
         BE    HT                    ALL OTHERS ARE IGNORED.            00996017
         B     CKRANGE                                                  01010015
         SPACE 1                                                        01020015
CR       EQU   *                   SUBTRACT MODULO 132 FROM THE         01030017
         XR    R4,R4                 CURRENT OFFSET INTO THE BLOCK.     01031017
         D     R4,=F'132'            THIS RESULTS IN A REPOSITIONING    01032017
         M     R4,=F'132'            TO A 'START OF LINE'.              01033017
         A     R5,=F'132'                                               01033124
         OI    SS#FLAG4,SS#CPTCR   SHOW WE JUST DID A CR.               01033223
         B     CRRANGE             <--NOTE THIS IS NOT CKRANGE          01034023
         SPACE 1                                                        01035016
LF       EQU   *                   ADD 132 TO THE CURRENT OFFSET.  THIS 01040017
         TM    SS#FLAG4,SS#CPTCR     RESULTS IN A POINTER TO THE SAME   01041023
         BO    CKRANGE               COLUMN IN THE NEXT LINE.           01042023
         A     R5,=F'132'          THIS IS SKIPPED IF THE LAST CHAR     01042123
         B     CKRANGE               PROCESSED WAS A CR.                01042223
         SPACE 1                                                        01043016
BS       EQU   *                   BS MUST CHECK FOR THE SPECIAL CASE   01050018
         LR    R6,R5                 OF THE CURRENT POINTER DWELLING AT 01050117
         XR    R4,R4                 THE START OF A LINE.  IN THIS CASE 01050217
         D     R4,=F'132'            THE BACKSPACE IS IGNORED.  OTHER-  01050317
         M     R4,=F'132'            WISE, WE SUBTRACT ONE FROM THE     01050417
         CR    R5,R6                 BUFFER POINTER, EFFECTIVELY        01050517
         BE    CKRANGE               BACKING UP ONE POSITION.           01050617
         LR    R5,R6                                                    01050717
         BCTR  R5,0                                                     01050817
         B     CKRANGE                                                  01050917
         SPACE 1                                                        01051017
HT       EQU   *                   HERE WE SIMPLY INCREMENT OUR CURRENT 01051117
         LA    R5,1(R5)              OFFSET BY ONE.                     01052017
         SPACE 1                                                        01060015
CKRANGE  EQU   *                                                        01070023
         NI    SS#FLAG4,X'FF'-SS#CPTCR                                  01070123
         SPACE 1                                                        01070223
CRRANGE  EQU   *                   BUMP INPUT POINTER; THEN CHECK TO    01070323
         LA    R2,1(R2)              ENSURE WE DON'T EXCEED THE         01071019
         C     R5,=F'&CBLKSZ'        UPPER BOUND OF OUR I/O BLOCK.      01080016
         BNL   PH23#2              IF WE HAVE, GO ALLOCATE ANOTHER      01090015
         BCT   R3,LOOP               BEFORE CONTINUING.                 01100016
         B     PH23#99                                                  01110015
         EJECT                                                          01120015
**                                                                      01130015
*                                                                       01140015
    PHASE  23.2 - NOTIFY THE CAPTURE TASK VIA POST.                     01150015
*                                                                       01160015
**                                                                      01170015
         SPACE 1                                                        01180015
         ST    R5,IB#FREEC                                              01181021
         L     R1,IB#NEXT          BEFORE WE DO A GETMAIN FOR ANOTHER   01190015
         LTR   R1,R1                 IOBL, LET'S CHECK TO SEE IF WE     01200015
         BNZ   NEWIOBL               ALREADY HAVE A FREE ONE.           01210015
         SPACE 1                                                        01220015
         L     R8,IB#LIOBL                                              01230015
         GETMAIN RC,LV=(R8),SP=0   IF NOT, DO A GETMAIN FOR ONE.        01240015
         PUSH  USING                                                    01241016
         DROP  R7                                                       01242016
         USING XTAIOBL,R1                                               01243016
         STM   R4,R7,0(R1)         WE NOW CLEAR THE BUFFER AREA OF OUR  01250015
         LA    R4,IB#DATA            NEWLY GETMAIN'D I/O BLOCK TO       01251016
         L     R5,=F'&CBLKSZ'        EBCDIC BLANKS.  SINCE MVCL USES    01252016
         XR    R6,R6                 FOUR (COUNT 'EM - FOUR) REGISTERS, 01253015
         XR    R7,R7                 WE TEMPORARILY STASH THEM IN THE   01254015
         ICM   R7,B'1000',=C' '      FRONT OF THE IOBL.                 01255015
         MVCL  R4,R6                                                    01256015
         LM    R4,R7,0(R1)                                              01257016
         POP   USING                                                    01258016
         ST    R8,0(R1)            SHOW LENGTH OF GETMAIN.              01260015
         ST    R1,IB#NEXT          NEW IOBL'S MUST BE ADDED TO THE IOBL 01270015
         L     R8,SS#ACCBA           QUEUE; THIS IS BYPASSED IF A FREE  01280015
         PUSH  USING                 IOBL WAS FOUND IN THE QUEUE.       01290015
         USING XTACCBA,R8                                               01300015
         ST    R1,CC#ALBFR                                              01310015
         DROP  R7                                                       01320015
         USING XTAIOBL,R1                                               01330015
         XC    IB#NEXT,IB#NEXT     FINALLY, WE INITIALIZE THE REMAINING 01340015
         XC    IB#FREEC,IB#FREEC     FIELDS IN THE IOBL.                01350016
         POP   USING                                                    01370015
         SPACE 1                                                        01380015
NEWIOBL  EQU   *                   INITIALIZE THE IOBL.                 01390015
         NI    IB#FLAGS,X'FF'-IB#ACTIV  INDICATE THAT THE NOW CURRENT   01400015
         OI    IB#FLAGS,IB#PENDW     (ABOUT TO BE OLD) IOBL IS NO       01410015
*                                    LONGER ACTIVE, AND IS WAITING TO   01420015
*                                    BE WRITTEN.                        01430015
         LR    R7,R1               MAKE THE NEW IOBL THE CURRENT IOBL,  01440015
         XC    IB#FLAGS,IB#FLAGS     AND SHOW IT TO BE ACTIVE.          01450015
         OI    IB#FLAGS,IB#ACTIV                                        01460015
         L     R8,SS#ACCBA                                              01470015
         USING XTACCBA,R8                                               01480015
         TM    CC#WECB,X'80'       IF THE WRITE ECB HAS BEEN WAITED     01490015
         BZ    NOPOST                ON, THEN POST IT; ELSE XTACPTT     01500015
         LA    R1,CC#WECB            WILL FIND THE NEW BUFFER BEFORE    01510015
         POST  (R1)                  IT WAITS AGAIN.                    01520015
         DROP  R8                                                       01530015
         SPACE 1                                                        01540015
NOPOST   EQU   *                   LOOP UNTIL ALL THE DATA IS           01550015
         S     R5,=F'&CBLKSZ'                                           01551016
         BCT   R3,LOOP               PROCESSED.                         01560016
         EJECT                                                          01570015
**                                                                      01580015
*                                                                       01590015
    PHASE  23.99 - EXIT                                                 01600015
*                                                                       01610015
**                                                                      01620015
         SPACE 1                                                        01630015
         ST    R5,IB#FREEC         UPDATE POINTER TO FREE LOCATION IN   01640016
         RLSLOCK SS#TLOCK            BUFFER, AND RELEASE CCBA LOCK.     01650015
         SLR   R15,R15                                                  01660015
         EPILOGUE                                                       01670015
*********************************************************************** 01680015
*********************************************************************** 01690015
********                                                       ******** 01700015
********               END OF EXECUTABLE CODE                  ******** 01710015
********                                                       ******** 01720015
*********************************************************************** 01730015
*********************************************************************** 01740015
         EJECT                                                          01879726
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01879826
*                                                                     * 01879926
*  TRANSLATE TABLE FOR RECTIFYING TWX GRAPHICS                        * 01880026
*                                                                     * 01881026
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01882026
         SPACE 2                                                        01883026
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01884026
*                                                                     * 01885026
*  AS PER GG24-1569-0 (X.25 NPSI PAD IMPLEMENTATION GUIDE), THIS IS   * 01886026
*  THE TRANSLATE TABLE WHICH IS USED BY NPSI TO TRANSLATE FROM ASCII  * 01887026
*  (IA5) TO EBCDIC:                                                   * 01888026
*                                                                     * 01889026
*     BALXLTI  DS    0F                                               * 01889126
*              DC    X'00010203372D2E2F1605250B0C0D0E0F'              * 01889226
*              DC    X'101112133C3D322618193F271C1D1E1F'              * 01889326
*              DC    X'404F7F7B5B6C507D4D5D5C4E6B604B61'              * 01889426
*              DC    X'F0F1F2F3F4F5F6F7F8F97A5E4C7E6E6F'              * 01889526
*              DC    X'7CC1C2C3C4C5C6C7C8C9D1D2D3D4D5D6'              * 01889626
*              DC    X'D7D8D9E2E3E4E5E6E7E8E94AE05A5F6D'              * 01889726
*              DC    X'79818283848586878889919293949596'              * 01889826
*              DC    X'979899A2A3A4A5A6A7A8A9C06AD0A107'              * 01889926
*                                                                     * 01890026
*  THE PROCESSING IN PHASE 23.1 ACCEPTS AND PROCESSES THE FOLLOWING   * 01891026
*  CONTROL CHARACTERS:                                                * 01892026
*                                                                     * 01893026
*                     CR  LF  VT  BS  HT                              * 01894026
*                                                                     * 01895026
*  THE EFFECT OF THESE CHARACTERS, RATHER THAN THE CHARACTERS         * 01896026
*  THEMSELVES, APPEAR IN THE OUTPUT DATASET.  ALL OTHER CONTROL       * 01897026
*  CHARACTERS ARE IGNORED COMPLETELY BY THIS ROUTINE.  ONLY GRAPHIC   * 01898026
*  CHARACTERS ARE WRITTEN TO THE CAPTURE DATASET.  FURTHER, ALL       * 01899026
*  RECORDS ARE PADDED WITH EBCDIC BLANKS TO A LENGTH OF 132.          * 01899126
*                                                                     * 01899426
*  AS FOR THE GRAPHIC CHARACTERS, THE FOLLOWING CHANGES ARE MADE TO   * 01899526
*  CONFORM WITH THE CHANGES MADE IN XTASRRX BEFORE SENDING THE        * 01899626
*  DATA TO XTAPSMR:                                                   * 01899726
*                                                                     * 01900126
*  AS RECEIVED BY NPSI         NPSI TRANSLATES   PRRX TRANSLATES      * 01900226
*                                    TO                TO             * 01901026
*  ----ASCII---                ---EBCDIC---      ---EBCDIC---         * 01902026
*  CODE GRAPHIC                CODE GRAPHIC      CODE GRAPHIC         * 01903026
*                                                                     * 01904026
*   21  !                       4F  |            5A   !               * 01905026
*   5B  LEFT SQUARE BRACKET     4A  ¢            C0   LEFT BRACE      * 01906026
*   5D  RIGHT SQUARE BRACKET    5A  !            D0   RIGHT BRACE     * 01907026
*   5E  CARET                   5F  ¬            5F   ¬               * 01908026
*                                                                     * 01909026
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 01909126
         SPACE 2                                                        01909226
GRAFIX   EQU   *  0 1 2 3 4 5 6 7 8 9 A B C D E F                       01909326
         DC    X'00000000000000000000000000000000' 0X                   01909426
         DC    X'00000000000000000000000000000000' 1X                   01909526
         DC    X'00000000000000000000000000000000' 2X                   01909626
         DC    X'00000000000000000000000000000000' 3X                   01909726
         DC    X'40404040404040404040C04B4C4D4E5A'                      01909826
         DC    X'50404040404040404040D05B5C5D5E5F'                      01909926
         DC    X'606140404040404040406A6B6C6D6E6F'                      01910026
         DC    X'404040404040404040797A7B7C7D7E7F'                      01911026
         DC    X'40818283848586878889404040404040'                      01912026
         DC    X'40919293949596979899404040404040'                      01913026
         DC    X'40A1A2A3A4A5A6A7A8A9404040404040'                      01914026
         DC    X'40404040404040404040404040404040'                      01915026
         DC    X'C0C1C2C3C4C5C6C7C8C9404040404040'                      01916026
         DC    X'D0D1D2D3D4D5D6D7D8D9404040404040'                      01917026
         DC    X'E040E2E3E4E5E6E7E8E9404040404040'                      01918026
         DC    X'F0F1F2F3F4F5F6F7F8F9FA4040404040'                      01919026
         END   XTACPTR                                                  01920015