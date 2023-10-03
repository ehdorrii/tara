XTACPTT  TITLE 'TARA CAPTURE TASK (24.0)'                               00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTACPTT                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTACPTT IS THE ROUTINE WHICH           * 00060000
*       ALLOCATES AND OPENS THE CAPTURE DATASET; WHICH THEREAFTER     * 00070000
*       DOES THE PHYSICAL I/O TO THE CAPTURE DATASET; AND WHICH       * 00080000
*       FINALLY CLOSES AND DEALLOCATES THE CAPTURE DATASET AT LOGOFF. * 00081000
*                                                                     * 00082000
*     DRIVER - XTACPTT IS INVOKED VIA AN ATTACH BY XTASAVE.           * 00090000
*                                                                     * 00100000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTACPTT.              * 00110000
*                                                                     * 00120000
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00130000
*       OF THE EPILOGUE MACRO.                                        * 00140000
*                                                                     * 00150000
*     REGISTERS ON ENTRY -                                            * 00160000
*       BEFORE PROLOGUE:                                              * 00170000
*         R0:  UNPREDICTABLE                                          * 00180000
*         R1:  POINTER TO COMMAND                                     * 00190000
*         R2-8: UNPREDICTABLE                                         * 00200000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00210000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00220000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00230000
*         R12: ADDRESS OF XTAPRRX ENTRY POINT                         * 00240000
*         R13: ADDRESS OF XTAPRRX'S SAVEAREA                          * 00250000
*         R14: RETURN ADDRESS                                         * 00260000
*         R15: ENTRY ADDRESS                                          * 00270000
*       AFTER PROLOGUE:                                               * 00280000
*         R0:  UNPREDICTABLE                                          * 00290000
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00300000
*         R2-6: UNPREDICTABLE                                         * 00310000
*         R7:  POINTER TO COMMAND                                     * 00320000
*         R8:  UNPREDICTABLE                                          * 00330000
*         R9:  ADDRESS OF THE PRIMARY RPL                             * 00340000
*         R10: POINTER TO COMMON STORAGE AREA                         * 00350000
*         R11: POINTER TO SESSION STORAGE AREA                        * 00360000
*         R12: ENTRY ADDRESS                                          * 00370000
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00380000
*         R14: RETURN ADDRESS                                         * 00390000
*         R15: ENTRY ADDRESS                                          * 00400000
*                                                                     * 00410000
*     MACROS USED -                                                   * 00420000
*       IBM MACROS:                                                   * 00430000
*         FREEMAIN, GETMAIN, OPEN, CLOSE, DCBD, WRITE, WAIT           * 00440032
*       NON-IBM MACROS:                                               * 00450000
*         EPILOGUE, PHASE, PROLOGUE, GETLOCK, RLSLOCK                 * 00460014
*                                                                     * 00470000
*     COPY MEMBERS -                                                  * 00480000
*       XTACMAP, XTASMAP, XTAS99P                                     * 00490000
*                                                                     * 00500000
*     INPUT -                                                         * 00510000
*       THE COMMAND BUFFER AND THE PRIMARY RPL.                       * 00520000
*                                                                     * 00530000
*     OUTPUT -                                                        * 00540000
*       THE CAPTURE DATASET.                                          * 00550000
*                                                                     * 00560000
*     ABENDS -                                                        * 00570000
*       NO ABENDS ARE ISSUED BY THIS MODULE.                          * 00580000
*                                                                     * 00590000
*     MESSAGES ISSUED -                                               * 00600000
*       XTA2301  .                                                    * 00610000
*                                                                     * 00620000
*     RETURN CODES -                                                  * 00630000
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00640000
*                                                                     * 00650000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00660000
XTACPTT  PROLOGUE TASK=CAPTURE                                          00670031
         EJECT                                                          00680000
**                                                                      00690000
*                                                                       00700000
    PHASE  24.1 - BUILD AN SVC99 REQUEST BLOCK.                         00710000
*                                                                       00720000
**                                                                      00730000
         SPACE 1                                                        00740000
         GBLC  &PHSID                                                   00740111
         LA    R3,CC#LEN           GET THE SUM LENGTH OF THE CCBA       00740203
         LA    R4,BLOCKLEN           PREFIX AND THE CONTROL BLOCKS.     00740303
         AR    R3,R4                                                    00740403
         GETMAIN RC,LV=(R3)                                             00741003
         ST    R3,0(R1)            SAVE THE GETMAIN'D LENGTH.           00742003
         LR    R8,R1                                                    00743003
         USING XTACCBA,R8          ADDRESS THE CCBA.                    00744003
         ST    R8,SS#ACCBA         SAVE ADDRESS OF CCBA IN SDB.         00745013
         LA    R4,CC#S99RB         MOVE THE MODEL SVC99 PARAMETER       00760003
         LA    R5,LENS99PL           LIST INTO THE CCBA...              00770003
         LA    R6,S99RBPTR                                              00780000
         LR    R7,R5                                                    00790000
         MVCL  R4,R6                                                    00800000
         LA    R4,CC#S99RB         RESTORE ADDRESS CHANGED BY MVCL.     00810003
         ST    R4,CC#AS99R                                              00820003
         USING S99RBPTR,R4         ADDRESS THE NEWLY CREATED CB'S.      00850000
         LA    R7,S99RB            NOW, RECONCILE ALL THOSE BLOODY      00860000
         O     R7,HIGHBIT            POINTERS!!                         00870000
         ST    R7,S99RBPTR                                              00880000
         LA    R7,S99TUPL                                               00890000
         ST    R7,S99TXTPP                                              00900000
         LA    R7,DDN                                                   00910000
         ST    R7,ADDN                                                  00920000
         LA    R7,DSN                                                   00930000
         ST    R7,ADSN                                                  00940000
         LA    R7,IDISP                                                 00950000
         ST    R7,AIDISP                                                00960000
         LA    R7,NDISP                                                 00970000
         ST    R7,ANDISP                                                00980000
         LA    R7,CDISP                                                 00990000
         ST    R7,ACDISP                                                01000000
         LA    R7,TRKS                                                  01010000
         ST    R7,ATRKS                                                 01020000
         LA    R7,PRISPC                                                01030000
         ST    R7,APRISPC                                               01040000
         LA    R7,SECSPC                                                01050000
         ST    R7,ASECSPC                                               01060000
         LA    R7,RLSE                                                  01070000
         ST    R7,ARLSE                                                 01080000
         LA    R7,VOLSER                                                01090000
         ST    R7,AVOLSER                                               01100000
         LA    R7,UNITTYPE                                              01110000
         ST    R7,AUNITYPE                                              01120000
         LA    R7,PS                                                    01130000
         ST    R7,APS                                                   01140000
         LA    R7,FB                                                    01150000
         ST    R7,AFB                                                   01160000
         LA    R7,BLKSZ                                                 01170000
         ST    R7,ABLKSZ                                                01180000
         LA    R7,LRECL                                                 01190000
         O     R7,HIGHBIT                                               01200000
         ST    R7,ALRECL                                                01210000
         MVI   DSNAME,C' '                                              01211030
         MVC   DSNAME+1(L'DSNAME-1),DSNAME                              01212030
         MVC   DSNAME,SS#TSOID     WE BUILD A DSNAME BY SANDWICHING     01220030
         LA    R1,DSNAME+8           'TARATEXT' BETWEEN THE USER        01230030
         TRT   DSNAME(8),BLANK       -SPECIFIED ID AND QUALIFIER.       01240030
         MVC   0(L'TARATEXT,R1),TARATEXT                                01260030
         MVC   L'TARATEXT(L'SS#CDSN,R1),SS#CDSN                         01261030
         LA    R1,DSNAME+L'DSNAME                                       01270030
         TRT   DSNAME,BLANK                                             01280030
         LA    R2,DSNAME                                                01290000
         SR    R1,R2                                                    01300000
         STH   R1,DSNLEN                                                01310000
         MVC   DDNAME,SS#PNODE     WE MUST ALSO SUPPLY A DDNAME. FOR    01320000
         LA    R1,DDNAME+8           THIS WE AGAIN USE THE TERMINAL     01330029
         TRT   DDNAME(8),BLANK       NAME.                              01340000
         LA    R2,DDNAME                                                01350000
         SR    R1,R2                                                    01360000
         STH   R1,DDNLEN                                                01370000
         EJECT                                                          01380000
**                                                                      01390000
*                                                                       01400000
    PHASE  24.2 - DYNAMICALLY ALLOCATE THE CAPTURE DATASET.             01410000
*                                                                       01420000
**                                                                      01430000
         SPACE 1                                                        01440000
         LA    R1,S99RBPTR         PARM LIST IS ALL BUILT, ALL WE NEED  01450000
         SVC   99                    DO IS POINT TO IT, AND CALL DAIR.  01460000
         GETLOCK SS#TLOCK                                               01460103
         MVC   SS#CTFDB(2),=XL2'&PHSID'                                 01460211
         MVC   SS#CTRC,S99ERROR                                         01461003
         RLSLOCK SS#TLOCK                                               01462003
         LTR   R15,R15             CHECK BOTH THE RETURN CODE IN R15    01470000
         BNZ   PH24#10               AND THE ERROR CODE IN THE SVC99RB  01480007
         GETLOCK SS#TLOCK                                               01481011
         MVC   SS#CTFDB(2),=XL2'0000'                                   01482011
         XC    SS#CTRC,SS#CTRC                                          01483011
         RLSLOCK SS#TLOCK                                               01484011
         LH    R2,S99ERROR           TO ENSURE THAT ALL WENT WELL; IF   01490000
         LTR   R2,R2                 IT DIDN'T, GET UP AND STORM OUT    01500000
         BNZ   PH24#10               IN DISGUST.                        01510007
         DROP  R4                  FIRST, COPY THE MODEL DCB INTO OUR   01511004
         EJECT                                                          01520000
**                                                                      01530000
*                                                                       01540000
    PHASE  24.3 - BUILD A DCB FOR THE CAPTURE DATASET.                  01550000
*                                                                       01560000
**                                                                      01570000
         SPACE 1                                                        01580000
         LA    R3,MODELDCB         POINT TO DCB AREA...                 01600005
         USING S99RBPTR,R4                                              01610000
         MVC   MODELDCB(DCBLEN),0(R3)                                   01620000
         LA    R5,MODELDCB                                              01630000
         ST    R5,CC#ADCB            ...AND SHOW EVERYONE WHERE IT IS.  01640003
         USING IHADCB,R5           THEN, MOVE THE DDNAME WE'RE USING    01650000
         MVC   DCBDDNAM,SS#PNODE     INTO THE DCB.                      01660000
         EJECT                                                          01670000
**                                                                      01680000
*                                                                       01690000
    PHASE  24.4 - OPEN THE CAPTURE DATASET.                             01700000
*                                                                       01710000
**                                                                      01720000
         SPACE 1                                                        01730000
         OPEN  ((R5),(OUTPUT))     OPEN THE CAPTURE DATASET.            01740000
         GETLOCK SS#TLOCK                                               01741011
         MVC   SS#CTFDB(2),=XL2'&PHSID'                                 01742011
         RLSLOCK SS#TLOCK                                               01744011
         TM    DCBOFLGS,DCBOFOPN   IF THE OPEN WAS SUCCESSFUL, EXIT;    01750000
         BZ    PH24#9                ELSE, FLAG THE BAD OPEN SO THE     01760011
         GETLOCK SS#TLOCK                                               01761011
         MVC   SS#CTFDB(2),=XL2'0000'                                   01762011
         RLSLOCK SS#TLOCK                                               01764011
         DROP  R5                                                       01780000
         EJECT                                                          01790000
**                                                                      01800000
*                                                                       01810000
    PHASE  24.5 - ALLOCATE A DATA BUFFER.                               01820000
*                                                                       01830000
**                                                                      01840000
         SPACE 1                                                        01850000
         GBLA  &CBLKSZ                                                  01850108
         L     R6,=F'&CBLKSZ'      LOAD UP THE LENGTH OF THE BLOCK      01851009
         LA    R5,IB#LEN             WE NEED INCLUDING THE IB PREFIX.   01852004
         AR    R6,R5                                                    01853004
         GETMAIN R,LV=(R6),SP=0    ACQUIRE A BLOCK.                     01860004
         LR    R5,R1               ADDRESS THE BLOCK.                   01861004
         USING XTAIOBL,R5                                               01861104
         GETLOCK SS#TLOCK                                               01861214
         ST    R6,IB#LIOBL         INITIALIZE THE I/O BLOCK.            01862004
         ST    R5,CC#AFBFR                                              01863004
         ST    R5,CC#ALBFR                                              01864004
         XC    IB#NEXT,IB#NEXT                                          01865004
         XC    IB#FLAGS,IB#FLAGS                                        01866014
         OI    IB#FLAGS,IB#ACTIV                                        01866114
         XC    IB#FREEC,IB#FREEC                                        01867021
         LA    R2,IB#DATA                                               01868120
         L     R3,=A(&CBLKSZ)                                           01868220
         XR    R6,R6                                                    01868320
         XR    R7,R7                                                    01868420
         ICM   R7,B'1000',=C' '                                         01868520
         MVCL  R2,R6                                                    01868620
         DROP  R5                                                       01869005
         OI    SS#FLAG4,SS#SAVON+SS#CAPDS                               01869112
         NI    SS#FLAG4,X'FF'-SS#OPENG                                  01869212
         RLSLOCK SS#TLOCK                                               01869314
         EJECT                                                          01870000
**                                                                      01880000
*                                                                       01890000
    PHASE  24.6 - INITIALIZE THE ECBS AND WAIT FOR A REQUEST.           01900002
*                                                                       01910000
**                                                                      01920000
         SPACE 1                                                        01930000
         XC    CC#WECB,CC#WECB     WE NOW PREPARE BOTH OF THE ECB'S TO  01931002
         LA    R5,CC#WECB            BE WAITED UPON, AND BUILD AN       01933002
         ST    R5,CC#AWECB           ECBLIST, FLAGGING THE LAST ENTRY   01934002
         XC    CC#EECB,CC#EECB       IN THE LIST.                       01934102
         LA    R5,CC#EECB                                               01935001
         ST    R5,CC#AEECB                                              01936001
         OI    CC#AEECB,X'80'                                           01937001
         LA    R5,CC#AWECB         POINT TO THE ECBLIST, AND WAIT FOR   01937102
         WAIT  1,ECBLIST=(R5)        SOMETHING TO HAPPEN.               01938001
         EJECT                                                          01940000
**                                                                      01950000
*                                                                       01960000
    PHASE  24.7 - DATA: WRITE A BLOCK.                                  01970002
*                                                                       01980000
**                                                                      01990000
         SPACE 1                                                        02000000
         XC    CC#WECB,CC#WECB     CLEAR THE WRITE ECB; POINT TO DCB    02000407
         L     R4,CC#ADCB            AND TO I/O BLOCK.  FROM THE I/O    02001014
         L     R5,CC#AFBFR           BLOCK WE GET THE ADDRESS OF THE    02002014
         USING XTAIOBL,R5            DATA BLOCK TO BE WRITTEN.          02002114
         LA    R5,IB#DATA                                               02002305
         L     R7,IB#FREEC                                              02002425
         DROP  R5                                                       02002508
         A     R7,=F'131'                                               02002725
         XR    R6,R6                                                    02002825
         D     R6,=F'132'                                               02002925
         M     R6,=F'132'                                               02003025
         WRITE DECB,SF,(R4),(R5),(R7)                                   02003325
         CHECK DECB                                                     02004007
         SPACE 1                                                        02004102
         GETLOCK SS#TLOCK          GET THE CCBA LOCK.                   02004405
         L     R3,CC#AFBFR         POINT TO THE FIRST IO BLOCK (THE ONE 02004614
         LR    R4,R3                 WE JUST WROTE) AND FROM THERE GET  02004705
         USING XTAIOBL,R3            A POINTER TO THE NEXT: THIS IS NOW 02004805
         L     R3,IB#NEXT            THE FIRST BLOCK; SHOW SO IN CCBA.  02004905
         ST    R3,CC#AFBFR                                              02005005
         L     R3,CC#ALBFR         POINT TO LAST BLOCK, AND STRING THE  02005105
         ST    R4,IB#NEXT            OLD Q HEAD ONTO THE Q TAIL.        02005205
         ST    R4,CC#ALBFR                                              02005305
         DROP  R3                                                       02005405
         USING XTAIOBL,R4                                               02005505
         XC    IB#NEXT,IB#NEXT     REINITIALIZE THE I/O BLOCK FOR       02005605
         XC    IB#FREEC,IB#FREEC     RE-USE.                            02005721
         XC    IB#FLAGS,IB#FLAGS                                        02005914
         LA    R2,IB#DATA                                               02006021
         L     R3,=A(&CBLKSZ)                                           02006120
         XR    R4,R4                                                    02006220
         XR    R5,R5                                                    02006320
         ICM   R5,B'1000',=C' '                                         02006420
         MVCL  R2,R4                                                    02006520
         RLSLOCK SS#TLOCK                                               02006614
         L     R4,CC#AFBFR                                              02006714
         TM    IB#FLAGS,IB#PENDW   CHECK FOR REQUESTS WHICH MAY HAVE    02006814
         BO    PH24#7                QUEUED WHILE WE WERE PROCESSING.   02006905
         DROP  R4                                                       02007018
         TM    CC#EECB,X'40'       IF THE END ECB WAS POSTED, CONTINUE  02007105
         BZ    PH24#6                CLEANUP; ELSE, WAIT FOR MORE DATA. 02008014
         EJECT                                                          02080000
**                                                                      02090000
*                                                                       02100000
    PHASE  24.8 - CLOSE CAPTURE DATASET.                                02110002
*                                                                       02120000
**                                                                      02130000
         SPACE 1                                                        02140000
         NI    SS#FLAG4,X'FF'-SS#SAVON                                  02141024
         L     R2,CC#ADCB          GET A POINTER TO OUR CAPTURE DATASET 02150005
         CLOSE ((2))                 DCB, AND WRAP UP I/O.              02171023
         EJECT                                                          02180000
**                                                                      02190000
*                                                                       02200000
    PHASE  24.9 - DEALLOCATE THE CAPTURE DATASET.                       02210002
*                                                                       02220000
**                                                                      02230000
         SPACE 1                                                        02240000
         L     R1,CC#AS99R         POINT TO SVC 99 REQUEST BLOCK, AND   02250005
         USING S99RBPTR,R1           FIX IT UP FOR A FREE REQUEST.      02251026
         MVI   S99VERB,S99VRBUN                                         02260026
         XC    S99FLAG1(L'S99FLAG1+L'S99ERROR+L'S99INFO),S99FLAG1       02270000
         OI    ADDN,X'80'                                               02280000
         DROP  R1                                                       02281026
         SVC   99                  FREE THE CAPTURE DATASET.            02290005
         EJECT                                                          02300000
**                                                                      02310000
*                                                                       02320000
    PHASE  24.10 - FREE STORAGE AREAS.                                  02330002
*                                                                       02340000
**                                                                      02350000
         SPACE 1                                                        02360000
         GETLOCK SS#TLOCK                                               02360105
         L     R4,CC#AFBFR         POINT TO THE FIRST I/O BLOCK.        02361005
         LTR   R4,R4                                                    02361111
         BZ    FREECCBA                                                 02361211
         USING XTAIOBL,R4                                               02362005
         SPACE 1                                                        02362105
IBFREE   EQU   *                                                        02362205
         L     R5,IB#LIOBL         GET THE LENGTH OF THE BLOCK, AND     02363005
         L     R6,IB#NEXT            THE ADDRESS OF THE NEXT ONE.       02363105
         FREEMAIN R,A=(R4),LV=(R5) FREE THE BLOCK.                      02363210
         LTR   R4,R6               POINT TO THE NEXT ONE, AND IF THERE  02363310
         BNZ   IBFREE                IS A NEXT, FREE IT.                02363405
         DROP  R4                                                       02363505
         SPACE 1                                                        02364000
FREECCBA EQU   *                                                        02365000
         L     R1,SS#ACCBA         POINT TO THE CCBA ITSELF, AND GET    02366007
         USING XTACCBA,R1            ITS LENGTH.  THEN FREE IT.         02366105
         L     R0,CC#LCCBA                                              02367005
         FREEMAIN RC,LV=(0),A=(1)                                       02368000
         DROP  R1                                                       02368107
         XC    SS#ACCBA,SS#ACCBA   ZERO THE POINTER TO THE NOW DEFUNCT  02369005
         RLSLOCK SS#TLOCK            CCBA.                              02369205
         EJECT                                                          02370000
**                                                                      02380000
*                                                                       02390000
    PHASE  24.99 - EXIT                                                 02400000
*                                                                       02410000
**                                                                      02420000
         SR    R15,R15             ZERO RETURN CODE                     02430000
         EPILOGUE                  RETURN                               02440000
*********************************************************************** 02450000
*********************************************************************** 02460000
********                                                       ******** 02470000
********               END OF EXECUTABLE CODE                  ******** 02480000
********                                                       ******** 02490000
*********************************************************************** 02500000
*********************************************************************** 02510000
         EJECT                                                          02520000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02530000
*                                                                     * 02540000
*        DATA OBJECTS                                                 * 02550000
*                                                                     * 02560000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02570000
         SPACE 1                                                        02580000
         DS    0F                                                       02590000
HIGHBIT  DC    X'80000000'         USED TO FLAG THE END OF A LIST.      02600000
TARATEXT DC    C'.TARATEXT.'                                            02601030
         SPACE 1                                                        02610000
BLANK    EQU   *                   TRANSLATE TABLE USED TO FIND THE     02620000
         DC    256XL1'FF'            END OF A DATASET NAME.             02630000
         ORG   BLANK+C'.'                                               02640000
         DC    X'00'                                                    02650000
         ORG   BLANK+C'$'                                               02660000
         DC    X'00'                                                    02670000
         ORG   BLANK+C'#'                                               02680000
         DC    2XL1'00'                                                 02690000
         ORG   BLANK+C'A'                                               02700000
         DC    9XL1'00'                                                 02710000
         ORG   BLANK+C'J'                                               02720000
         DC    9XL1'00'                                                 02730000
         ORG   BLANK+C'S'                                               02740000
         DC    8XL1'00'                                                 02750000
         ORG   BLANK+C'0'                                               02760000
         DC    10XL1'00'                                                02770000
         ORG                                                            02780000
         EJECT                                                          02790000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02800000
*                                                                     * 02810000
*        SVC 99 PARAMETER LIST MODEL                                  * 02820000
*                                                                     * 02830000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02840000
         SPACE 1                                                        02850000
         COPY  XTAS99P                                                  02860000
         EJECT                                                          02870000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02880000
*                                                                     * 02890000
*        DCB MODEL                                                    * 02900000
*                                                                     * 02910000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 02920000
         SPACE 1                                                        02930000
MODELDCB DCB   DDNAME=UNKNOWN,                                         -02940000
               LRECL=132,                                              -02950008
               BLKSIZE=&CBLKSZ,                                        -02960008
               RECFM=FB,                                               -02970000
               DSORG=PS,                                               -02980000
               DEVD=DA,                                                -02990000
               MACRF=W,                                                 03000019
         SPACE 2                                                        03020000
DCBLEN   EQU   *-MODELDCB                                               03030000
         SPACE 1                                                        03040000
BLOCKLEN EQU   *-S99RBPTR                                               03050000
         EJECT                                                          03060000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 03070000
*                                                                     * 03080000
*        DCB DSECT                                                    * 03090000
*                                                                     * 03100000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 03110000
         SPACE 1                                                        03120000
         DCBD  DSORG=BS,DEVD=DA                                         03130032
         END                                                            03140000