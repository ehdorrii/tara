XTASMAP  DSECT                                                          00010027
         SPACE 2                                                        00020027
*********************************************************************** 00030027
*                                                                     * 00040027
*  MODULE NAME - XTASMAP                                              * 00050027
*                                                                     * 00060027
*  THIS MODULE IS STRICTLY A DSECT (AS OPPOSED TO XTACMAP, WHICH IS   * 00070027
*  ALSO A COMPILABLE CSECT). IT MAPS THE STORAGE WHICH IS USED BY     * 00080027
*  SESSION-RELATED CODE.                                              * 00090027
*                                                                     * 00100027
*********************************************************************** 00110027
         SPACE 2                                                        00120027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00130027
         SPACE 1                                                        00140027
SS#NEXT  DS    A                   POINTER TO NEXT SSA OR 0 IF LAST     00150027
SS#PREV  DS    A                   POINTER TO PREV SSA OR 0 IF FIRST    00160027
         SPACE 1                                                        00170027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00180027
         SPACE 1                                                        00190027
SS#LNGTH DS    F                   LENGTH OF SESSION STORAGE AREA       00200027
         SPACE 1                                                        00210027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00220027
         SPACE 1                                                        00230027
SS#PNODE DS    CL8                 NODE NAME OF PRIMARY SLU             00240027
         SPACE 1                                                        00250027
SS#PCID  DS    0XL4                CID FOR SESSION WITH PRIMARY SLU     00260027
SS#PCIDP DS    XL2                    OUR CID                           00270027
SS#PCIDS DS    XL2                    TERMINAL CID                      00280027
SS#APRPL DS    A                   ADDRESS OF 'PRIMARY' RPL             00290027
SS#AERPL DS    A                   ADDRESS OF 'ECHO' RPL                00300027
SS#PRSPL DS    F                   LENGTH OF DATA RECEIVED FROM PRI SLU 00310027
SS#PIBUF DS    CL256               INPUT BUFFER FOR PRIMARY SLU         00320027
         SPACE 1                                                        00330027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00340027
         SPACE 1                                                        00350027
SS#SNODE DS    CL8                 NODE NAME OF SECONDARY SLU           00360027
         SPACE 1                                                        00370027
SS#SCID  DS    0XL4                CID FOR SESSION WITH SECONDARY SLU   00380027
SS#SCIDP DS    XL2                    OUR CID                           00390027
SS#SCIDS DS    XL2                    TELENET CID                       00400027
SS#ASRPL DS    A                   ADDRESS OF 'SECONDARY' RPL           00410027
SS#ACRPL DS    A                   ADDRESS OF 'CLSDST' RPL              00420027
SS#SRSPL DS    F                   LENGTH OF DATA RECEIVED FROM SEC SLU 00430027
SS#SIBUF DS    CL256               INPUT BUFFER FOR SECONDARY SLU       00440027
         SPACE 1                                                        00450027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00460027
         SPACE 1                                                        00470027
SS#ANIB  DS    A                   POINTER TO NIB                       00480027
SS#BIND  DS    XL36                SESSION PARAMETERS (BIND IMAGE)      00490027
SS#DVCHR DS    XL8                 DEVICE CHARACTERISTICS               00500027
         SPACE 1                                                        00510027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00520027
         SPACE 1                                                        00530027
SS#STATS DS    0XL12                                                    00540027
SS#SSNCT DS    F                   COUNT OF SESSIONS STARTED            00550027
SS#SNDCT DS    F                   COUNT OF MESSAGES 'SENT'             00560027
SS#RCVCT DS    F                   COUNT OF MESSAGES 'RECEIVED'         00570027
         SPACE 1                                                        00580027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 00590027
         SPACE 1                                                        00600027
SS#FLAGS DS    0XL4                SESSION-RELATED FLAGS                00610027
         SPACE 1                                                        00620027
SS#FLAG1 DS    XL1                                                      00630027
SS#PACT  EQU   B'10000000'         PRIMARY HALF-SESSION IS ACTIVE       00640027
SS#SACT  EQU   B'01000000'         SECONDARY HALF-SESSION IS ACTIVE     00650027
SS#LOGFF EQU   B'00100000'         SUPPRESS RECEIVE AFTER LOGOFF CMD    00660027
SS#PCONN EQU   B'00010000'         THERE IS A CONNECTION PENDING        00670027
SS#F1_5  EQU   B'00001000'                                              00680034
SS#CLNUP EQU   B'00000100'         CLEANUP WAS INVOKED FOR SESSION      00690027
SS#SUSPD EQU   B'00000010'         SESSION WAS SUSPENDED                00700027
SS#ALLDN EQU   B'00000001'         ALL DONE, READY FOR NORMAL CLEANUP   00710027
         SPACE 1                                                        00720027
SS#FLAG2 DS    XL1                                                      00730027
SS#HOLDD EQU   B'10000000'         PSM: HOLD DATA MODE IN EFFECT        00740027
SS#INBKT EQU   B'01000000'         PSM: IN-BRACKET STATE                00750027
SS#REENT EQU   B'00100000'         PSM: RE-ENTER PSM                    00760027
SS#AWRAP EQU   B'00010000'         PSM: AUTOWRAP OPTION                 00770027
SS#ONEFF EQU   B'00001000'         PSM: FF ALREADY PROCESSED            00780027
SS#NOALM EQU   B'00000100'         PSM: AUDIBLE ALARM IS NOT USED       00790027
SS#1416  EQU   B'00000010'         PSM: USE 14/16-BIT ADDRESSING        00800027
SS#ERASE EQU   B'00000001'         PSM: ERASE DATA AREA ON WRAP         00810027
         SPACE 1                                                        00820027
SS#FLAG3 DS    XL1                                                      00830027
SS#F3_1  EQU   B'10000000'         SEC'Y SESSION: IN-BRACKET STATE      00840034
SS#NOCR  EQU   B'01000000'         SEND DATA TO SEC'Y WITHOUT CR.       00850027
SS#PINDS EQU   B'00100000'         PARM IND PACKET SENT: SEC RPL BUSY   00860029
SS#F3_4  EQU   B'00010000'                                              00870027
SS#F3_5  EQU   B'00001000'                                              00880027
SS#F3_6  EQU   B'00000100'                                              00890027
SS#F3_7  EQU   B'00000010'                                              00900027
SS#F3_8  EQU   B'00000001'                                              00910027
         SPACE 1                                                        00920027
SS#FLAG4 DS    XL1                                                      00930027
SS#SAVON EQU   B'10000000'         DATA CAPTURE IS ACTIVE               00940027
SS#OPENG EQU   B'01000000'         SAVE AS IN PROGRESS                  00950027
SS#CAPDS EQU   B'00100000'         WE HAVE A CAPTURE DATASET            00960027
SS#CPTCR EQU   B'00010000'         LAST PROCESSED CHAR WAS A CR         00970027
SS#F4_5  EQU   B'00001000'                                              00980027
SS#F4_6  EQU   B'00000100'                                              00990027
SS#F4_7  EQU   B'00000010'                                              01000027
SS#F4_8  EQU   B'00000001'                                              01010027
         SPACE 1                                                        01020027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01030027
         SPACE 1                                                        01040027
         DS    0D                                                       01050027
SS#WORK1 DS    CL256               SCRATCHPAD AREAS                     01060027
SS#WORK2 DS    CL256                                                    01070027
         SPACE 1                                                        01080027
SS#WORD1 DS    F                   WORK1, WORK2, WORD1, WORD3 ARE ON    01090027
SS#WORD2 DS    F                     DOUBLEWORD BOUNDARIES              01100027
SS#WORD3 DS    F                                                        01110027
SS#WORD4 DS    F                                                        01120027
         SPACE 1                                                        01130027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01140027
         SPACE 1                                                        01150027
SS#BASE  DS    F                   BASE ADDRESS FOR SHOW COMMANDS       01160027
SS#AHNAE DS    F                   ADDRESS OF HOST NAME ENTRY           01170027
         SPACE 1                                                        01180027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01190027
         SPACE 1                                                        01200027
SS#LMSG  DS    CL268               LOGGER MESSAGE BUFFER                01210027
         SPACE 1                                                        01220027
USTATUS  EQU   X'00'               UNFORMATTED STATUS INFORMATION       01230027
FSTATUS  EQU   X'01'               FORMATTED STATUS INFORMATION         01240027
UERROR   EQU   X'02'               UNFORMATTED ERROR INFORMATION        01250027
FERROR   EQU   X'03'               FORMATTED ERROR INFORMATION          01260027
USTATS   EQU   X'04'               UNFORMATTED STATISTICS RECORD        01270027
FSTATS   EQU   X'05'               FORMATTED STATISTICS RECORD          01280027
         SPACE 1                                                        01290027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01300027
         SPACE 1                                                        01310027
SS#ROWS  DS    F                   PRESENTATION SPACE HEIGHT            01320027
SS#COLS  DS    F                   PRESENTATION SPACE WIDTH             01330027
SS#DAREA DS    F                   CHARACTER POSITIONS IN DATA AREA     01340027
SS#CSP   DS    H                   CURRENT SCREEN POSITION              01350027
SS#SEPCH DS    C                   THE SEPARATOR LINE CHARACTER         01360027
         DS    X                   RESERVED FOR FUTURE USE              01370027
SS#BUFPT DS    F                   BUFFER_POINTER                       01380027
SS#SBQAB DS    2F                  SEND BUFFER QUEUE-ANCHOR-BLOCK       01390027
         ORG   SS#SBQAB                                                 01400027
SS#SBFST DS    F                   FIRST-ON-QUEUE                       01410027
SS#SBLST DS    F                   LAST-ON-QUEUE                        01420027
SS#SBCNT EQU   8                   NUMBER OF SEND BUFFERS (SEE BELOW)   01430027
SS#SBPL  DS    CL(256*SS#SBCNT)    SEND BUFFERS                         01440027
SS#SBIU  EQU   B'10000000'         SEND-BUFFER-IN-USE INDICATOR         01450027
SS#PACNG EQU   B'01000000'         ENTER 'HOLD DATA' MODE AFTER SEND    01460027
         SPACE 1                                                        01470027
*   PSM DATA TYPES                                                      01480027
         SPACE 1                                                        01490027
SS#DATA  EQU   B'00001000'         DATA FROM SECONDARY                  01500027
SS#ECHO  EQU   B'00000100'         DATA FROM PRIMARY                    01510027
SS#SMSG  EQU   B'00000010'         TARA MESSAGE FOR USER                01520027
SS#ISCR  EQU   B'00000001'         SCREEN FORMAT                        01530027
         SPACE 1                                                        01540027
*   PSM OPTIONS                                                         01550027
         SPACE 1                                                        01560027
CLEARIPT EQU   B'10000000'         CLEAR INPUT AREA                     01570027
NEWLINE  EQU   B'01000000'         PUT THIS DATA ON A NEW LINE          01580027
AALARM   EQU   B'00100000'         SOUND AUDIBLE ALARM                  01590027
CLEARDTA EQU   B'00010000'         CLEAR DATA AREA OF SCREEN            01600027
         SPACE 1                                                        01610027
*   PSM REQUEST TYPES                                                   01620027
         SPACE 1                                                        01630027
INITSCRN EQU   SS#ISCR             REQUEST FOR INITIAL SCREEN           01640027
SYSMSG   EQU   SS#SMSG+AALARM      SYSTEM MESSAGE                       01650027
ECHO     EQU   SS#ECHO+CLEARIPT    ECHO                                 01660027
DATA     EQU   SS#DATA             DATA FROM SECONDARY HALF-SESSION     01670027
         SPACE 1                                                        01680027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01690027
         SPACE 1                                                        01700027
SS#TLOCK DS    F                   LOCK ON FOLLOWING 20 BYTES           01710027
SS#ACCBA DS    A                   ADDRESS OF CAPTURE C/B AREA          01720027
SS#CTFDB DS    F                   FEEDBACK INFO FROM CAPTURE TASK      01730027
SS#CTRC  DS    F                   RETURN CODE FROM SPECIFIC TASK       01740027
SS#TSOID DS    CL8                 CAPTURE D/S HIGH-LEVEL QUALIFIER     01750032
SS#CDSN  DS    CL8                 CAPTURE D/S LOW-LEVEL QUALIFIER      01751032
         SPACE 1                                                        01760027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01770027
         SPACE 1                                                        01780027
SS#PAD   DS    256XL1              PAD PARAMETERS ARE STORED HERE       01780128
         SPACE 1                                                        01781028
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01782028
         SPACE 1                                                        01783028
         DS    0F                                                       01790027
SS#CBS   DS    XL512               NIB (64 BYTES) + 4 RPLS (112 BYTES)  01800027
         SPACE 1                                                        01810027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01820027
         SPACE 1                                                        01830027
LXTASMAP EQU   *-XTASMAP           LENGTH OF SESSION STORAGE AREA       01840027
         EJECT                                                          01850027
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * 01860027
         SPACE 1                                                        01870027
*  CCBA AND IOBL(S) EXIST ONLY FOR USERS WHO HAVE ACTIVATED CAPTURE     01871027
         SPACE 1                                                        01871127
*                  CAPTURE CONTROL BLOCK AREA                           01871227
         SPACE 1                                                        01872027
XTACCBA  DSECT                     MAP OF THE OPTIONAL CAPTURE CB AREA  01880027
         SPACE 1                                                        01890027
CC#LCCBA DS    F                   LENGTH OF STORAGE GETMAIN'D FOR CCBA 01900031
CC#AS99R DS    A                   POINTER TO SVC 99 REQUEST BLOCK      01910027
CC#ADCB  DS    A                   POINTER TO CAPTURE D/S DCB           01920027
CC#AWECB DS    A(CC#WECB)          ADDRESS OF THE REQUEST ECB           01930027
CC#AEECB DS    A(CC#EECB)          ADDRESS OF THE END ECB               01940027
CC#WECB  DS    F                   THE REQUEST ECB                      01950027
CC#EECB  DS    F                   THE END ECB                          01960027
CC#AFBFR DS    A                   POINTER TO THE FIRST I/O BLOCK       01970027
CC#ALBFR DS    A                   POINTER TO THE LAST I/O BLOCK        01980027
CC#LEN   EQU   *-XTACCBA                                                01990027
CC#S99RB EQU   *                                                        02000027
         SPACE 2                                                        02010027
*                          I/O BLOCK                                    02020027
         SPACE 1                                                        02021027
XTAIOBL  DSECT                     MAP OF THE OPTIONAL I/O BLOCKS       02030027
         SPACE 1                                                        02040027
IB#LIOBL DS    F                   LENGTH OF STORAGE GETMAIN'D FOR IB   02050027
IB#NEXT  DS    A                   POINTER TO NEXT IB IN CHAIN          02060027
IB#FREEC DS    F                   POINTER TO FIRST FREE BYTE IN BLOCK  02070027
IB#FLAGS DS    BL1                 FLAGS                                02080027
         SPACE 1                                                        02090027
IB#ACTIV EQU   B'10000000'         BLOCK TO WHICH DATA SHOULD BE ADDED. 02100027
IB#PENDW EQU   B'01000000'         FILLED BLOCK READY TO BE WRITTEN.    02110027
IB#F1_3  EQU   B'00100000'                                              02120027
IB#F1_4  EQU   B'00010000'                                              02130027
IB#F1_5  EQU   B'00001000'                                              02140027
IB#F1_6  EQU   B'00000100'                                              02150027
IB#F1_7  EQU   B'00000010'                                              02160027
IB#F1_8  EQU   B'00000001'                                              02170027
         SPACE 1                                                        02171027
         DS    XL3                 RESERVED                             02180027
         SPACE 1                                                        02190027
IB#LEN   EQU   *-XTAIOBL                                                02200027
IB#DATA  EQU   *                   DATA TO BE WRITTEN TO CAPTURE D/S    02210027
         SPACE 2                                                        02220027
&SYSECT  CSECT                                                          02230027