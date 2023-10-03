XTAPLOG  TITLE 'TARA LOG FORMATTER PROGRAM'                             00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*   MODULE NAME - XTAPLOG                                             * 00040000
*                                                                     * 00050000
*   FUNCTIONAL DESCRIPTION - THIS PROGRAM IS A TARA 'SERVICE AID.'    * 00060000
*     IT READS THE LOG RECORDS PRODUCED BY TARA DURING NORMAL         * 00070000
*     EXECUTION, FORMATS AND PRINTS THEM.                             * 00080000
*                                                                     * 00120000
*   INPUT - THE LOG RECORDS PRODUCED BY TARA DURING NORMAL            * 00130000
*     EXECUTION.                                                      * 00140000
*                                                                     * 00150000
*   OUTPUT - THE LOG RECORDS ARE PRINTED, ALONG WITH STATISTICS.      * 00160000
*                                                                     * 00190000
*   REQUIRED DD'S -                                                   * 00200000
*     XTALOGDS: THE LOG DATASET.                                      * 00210000
*     SYSPRINT: THE OUTPUT LISTING.                                   * 00220000
*                                                                     * 00250000
*   PRINCIPLE OF OPERATION - ALL LOG RECORDS BEGIN WITH A STANDARD    * 00370000
*     PREFIX, INDICATING THE TYPE OF RECORD (STATUS, ERROR, OR        * 00380000
*     STATISTICS), THE LENGTH OF THE DATA, THE PHASE WHICH CAUSED     * 00390000
*     THE LOG RECORD TO BE WRITTEN, AND THE DATE & TIME THE RECORD    * 00400000
*     WAS WRITTEN.                                                    * 00440000
*                                                                     * 00440100
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00450000
         EJECT                                                          00451000
XTAPLOG  CSECT                                                          00452000
         USING XTAPLOG,R15         ESTABLISH TEMPORARY ADDRESSABILITY.  00470000
         B     AFTERID                                                  00480000
         SPACE 1                                                        00490000
ID       DC    YL1(IDLEN)          IDENTIFY PROGRAM AND VERSION.        00500000
         DC    CL8'XTAPLOG'                                             00510000
         DC    CL8'&SYSDATE'                                            00520000
         DC    CL8'&SYSTIME'                                            00530000
IDLEN    EQU   *-ID                                                     00540000
         SPACE 1                                                        00550000
AFTERID  DS    0H                  NOW WE DO ALL THE STANDARD LINKAGE   00560000
         DROP  R15                   STUFF.                             00570000
         STM   R14,R12,12(R13)                                          00580000
         LR    R12,R15                                                  00590000
         USING XTAPLOG,R12         ESTABLISH PERMANENT ADDRESSABILITY.  00600000
         ST    R13,MAINSAVE+4                                           00610000
         LA    R11,MAINSAVE                                             00620000
         ST    R11,8(R11)                                               00630000
         LR    R13,R11             FINISH UP SAVEAREA LINKAGE.          00640000
         SPACE 1                                                        00641000
         OPEN  (XTALOGDS,(INPUT),SYSPRINT,(OUTPUT))                     00650000
         EJECT                                                          00660000
PRTLOOP  EQU   *                                                        00670000
         GET   XTALOGDS,BUFFER_1                                        00671000
         MVC   BUFFER_2,BUFFER_1                                        00672000
         MVC   BUFFER_3,BUFFER_1                                        00673000
         TR    BUFFER_1,PRINTABLE                                       00674000
         TR    BUFFER_2,ZONES                                           00675000
         TR    BUFFER_3,NUMERICS                                        00676000
         PUT   SYSPRINT,BUFFER_1                                        00677000
         PUT   SYSPRINT,BUFFER_2                                        00678000
         PUT   SYSPRINT,BUFFER_3                                        00679000
         PUT   SYSPRINT,SEP_LINE                                        00679100
         BAL   R2,CLEAR_BUFFERS                                         00679200
         B     PRTLOOP                                                  00679300
         EJECT                                                          00679400
ENDLOG   EQU   *                                                        00679500
         CLOSE (XTALOGDS,,SYSPRINT) BUTTON UP I/O AND LEAVE.            00680000
         L     R13,MAINSAVE+4                                           00690000
         RETURN (14,12),RC=0       BYE!                                 00700000
         EJECT                                                          00710000
* =========================== SUBROUTINES =========================== * 00720000
               SPACE 1                                                  00730000
CLEAR_BUFFERS  EQU   *                                                  00740000
               MVI   BUFFER_1,X'00'                                     00750002
               MVC   BUFFER_1+1(L'BUFFER_1-1),BUFFER_1                  00760002
               MVC   BUFFER_2,BUFFER_1                                  00770000
               MVC   BUFFER_3,BUFFER_1                                  00780000
               BR    R2                                                 00790000
               EJECT                                                    01920000
* ======== THE MISCELLANEOUS NUTS AND BOLTS OF THIS PROGRAM ========= * 01930000
         SPACE 1                                                        01940000
TITLE    DC    X'19',CL120'                                        TARA+01950000
                CONSOLIDATED CROSS REFERENCE LISTING'                   01960000
         ORG   *-9                                                      01970000
         DC    CL9'PAGE'                                                01980000
PAGENO   EQU   *-4,3                                                    01990000
         ORG                                                            01991000
HEADER   DC    X'11',CL120' SYMBOL    MODULE   REFERENCES'              02000000
NEWPAGE  DC    X'8B',CL120' '                                           02010000
RECORD   DS    CL121                                                    02020000
SYMBOL   DS    CL8                                                      02030000
MODNAME  DS    CL8                                                      02040000
DWORD    DS    D                                                        02050000
EDPATTRN DC    X'202120'                                                02051000
         SPACE 1                                                        02060000
FLAGS    DC    XL1'00'                                                  02070000
FLAG_1   EQU   B'10000000'                                              02080000
FLAG_2   EQU   B'01000000'                                              02090000
FLAG_3   EQU   B'00100000'                                              02100000
FLAG_4   EQU   B'00010000'                                              02110000
FLAG_5   EQU   B'00001000'                                              02120000
FLAG_6   EQU   B'00000100'                                              02130000
FLAG_7   EQU   B'00000010'                                              02140000
FLAG_8   EQU   B'00000001'                                              02150000
         SPACE 1                                                        02160000
PAGECNT  DC    F'0'                                                     02170000
LINECNT  DC    F'100'                                                   02180000
         SPACE 1                                                        02190000
MAINSAVE DS    18F                                                      02200000
EXITSAVE DS    18F                                                      02210000
               EJECT                                                    02220000
* ======================== LOG DATASET DCB ========================== * 02230000
               SPACE 1                                                  02240000
XTALOGDS DCB   MACRF=(GM),DDNAME=XTALOGDS,EODAD=ENDLOG,DSORG=PS,       +02250000
               LRECL=512,RECFM=VB                                       02251000
               EJECT                                                    02260000
* ===================== OUR OUTPUT LISTING DCB ====================== * 02270000
               SPACE 1                                                  02280000
SYSPRINT DCB   MACRF=(PM),DDNAME=SYSPRINT,DSORG=PS,                    +02290000
               LRECL=121,RECFM=FB,BLKSIZE=1210                          02300003
               EJECT                                                    02310000
* ========================== I/O BUFFERS ============================ * 02490000
               SPACE 1                                                  02500000
BUFFER_1       DS    CL121                                              02500100
               ORG   BUFFER_1+512                                       02500202
BUFFER_2       DS    CL121                                              02500300
BUFFER_3       DS    CL121                                              02500400
SEP_LINE       DC    61C'- '                                            02500500
               EJECT                                                    02500600
* ======================= TRANSLATE TABLES ========================== * 02500700
         SPACE 1                                                        02500800
PRINTABLE      EQU   *                                                  02500900
               SPACE 1                                                  02501000
*     0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF  02501100
 DC C'................................................................' 02501200
 DC C' .........¢.<(+|..........!$*);¬-/.........,%_>?..........:#@.="' 02501300
 DC C'.ABCDEFGHI.......JKLMNOPQR........STUVWXYZ......................' 02501400
 DC C'.ABCDEFGHI.......JKLMNOPQR........STUVWXYZ......0123456789......' 02501500
               SPACE 2                                                  02501600
ZONES          EQU   *                                                  02501700
*     0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF  02501800
 DC C'0000000000000000111111111111111122222222222222223333333333333333' 02501900
 DC C'4444444444444444555555555555555566666666666666667777777777777777' 02502000
 DC C'88888888888888889999999999999999AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB' 02502100
 DC C'CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFF' 02503000
               SPACE 2                                                  02503100
NUMERICS       EQU   *                                                  02503200
*     0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF  02503300
 DC C'0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF' 02503400
 DC C'0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF' 02503500
 DC C'0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF' 02503600
 DC C'0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF' 02503700
               EJECT                                                    02503900
* ======================= REGISTER EQUATES ========================== * 02504000
               SPACE 1                                                  02505000
R0       EQU   0                                                        02510000
R1       EQU   1                                                        02520000
R2       EQU   2                                                        02530000
R3       EQU   3                                                        02540000
R4       EQU   4                                                        02550000
R5       EQU   5                                                        02560000
R6       EQU   6                                                        02570000
R7       EQU   7                                                        02580000
R8       EQU   8                                                        02590000
R9       EQU   9                                                        02600000
R10      EQU   10                                                       02610000
R11      EQU   11                                                       02620000
R12      EQU   12                                                       02630000
R13      EQU   13                                                       02640000
R14      EQU   14                                                       02650000
R15      EQU   15                                                       02660000
         SPACE 2                                                        02670000
         END                                                            02680000