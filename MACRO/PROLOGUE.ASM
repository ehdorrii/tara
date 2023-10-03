         MACRO                                                          00010032
&CSECT   PROLOGUE &MAIN,&EXIT=,&SUBR=,&TASK=,&ETXR=                     00020032
.*----------------------------------------------------------------*     00051040
.*   SET-SYMBOLS NEEDED TO COORDINATE WITH EPILOGUE MACRO         *     00052040
.*----------------------------------------------------------------*     00053040
         GBLA  &GMLEN                                                   00054045
         GBLB  &IMAIN,&IEXIT,&ISUBR,&ITASK,&IETXR                       00060032
         GBLC  &TEXIT,&NAME                                             00070032
         LCLC  &DEST                                                    00080032
&NAME    SETC  '&CSECT'                                                 00081044
.*----------------------------------------------------------------*     00090032
.*   ENSURE THAT AT LEAST ONE OPERAND WAS SPECIFIED               *     00100032
.*----------------------------------------------------------------*     00110032
         AIF   ('&MAIN' EQ 'MAIN').MAIN                                 00120032
         AIF   (T'&EXIT NE 'O').EXIT                                    00130032
         AIF   (T'&SUBR NE 'O').SUBR                                    00140032
         AIF   (T'&TASK NE 'O').TASK                                    00150032
         AIF   (T'&ETXR NE 'O').ETXR                                    00160032
         MNOTE 8,'REQUIRED OPERAND OMITTED'                             00170032
         MEXIT                                                          00180032
.*----------------------------------------------------------------*     00190032
.*   ENSURE THAT NO MORE THAN ONE OPERAND WAS SPECIFIED           *     00200032
.*----------------------------------------------------------------*     00210032
.MAIN    AIF   (T'&EXIT NE 'O').NOGOOD                                  00220032
         AIF   (T'&SUBR NE 'O').NOGOOD                                  00230032
         AIF   (T'&TASK NE 'O').NOGOOD                                  00240032
         AIF   (T'&ETXR NE 'O').NOGOOD                                  00250032
         AGO   .DOIT                                                    00260032
.EXIT    AIF   (T'&MAIN NE 'O').NOGOOD                                  00270032
         AIF   (T'&SUBR NE 'O').NOGOOD                                  00280032
         AIF   (T'&TASK NE 'O').NOGOOD                                  00290032
         AIF   (T'&ETXR NE 'O').NOGOOD                                  00300032
         AGO   .DOIT                                                    00310032
.SUBR    AIF   (T'&MAIN NE 'O').NOGOOD                                  00320032
         AIF   (T'&EXIT NE 'O').NOGOOD                                  00330032
         AIF   (T'&TASK NE 'O').NOGOOD                                  00340032
         AIF   (T'&ETXR NE 'O').NOGOOD                                  00350032
         AGO   .DOIT                                                    00360032
.TASK    AIF   (T'&MAIN NE 'O').NOGOOD                                  00370032
         AIF   (T'&EXIT NE 'O').NOGOOD                                  00380032
         AIF   (T'&SUBR NE 'O').NOGOOD                                  00390032
         AIF   (T'&ETXR NE 'O').NOGOOD                                  00400032
         AGO   .DOIT                                                    00410032
.ETXR    AIF   (T'&MAIN NE 'O').NOGOOD                                  00420032
         AIF   (T'&EXIT NE 'O').NOGOOD                                  00430032
         AIF   (T'&SUBR NE 'O').NOGOOD                                  00440032
         AIF   (T'&EXIT NE 'O').NOGOOD                                  00450032
         AGO   .DOIT                                                    00460032
.NOGOOD  MNOTE 8,'TOO MANY OPERANDS SPECIFIED - ONLY ONE ALLOWED'       00470032
         MEXIT                                                          00480032
.*----------------------------------------------------------------*     00490032
.*   GENERATE COMMON CODE                                         *     00500032
.*----------------------------------------------------------------*     00510032
.DOIT    ANOP                                                           00520032
         SPACE 1                                                        00530032
R0       EQU   0                                                        00560039
R1       EQU   1                                                        00570039
R2       EQU   2                                                        00580039
R3       EQU   3                                                        00590039
R4       EQU   4                                                        00600039
R5       EQU   5                                                        00610039
R6       EQU   6                                                        00620039
R7       EQU   7                                                        00630039
R8       EQU   8                                                        00640039
R9       EQU   9                                                        00650039
R10      EQU   10                                                       00660039
R11      EQU   11                                                       00670039
R12      EQU   12                                                       00680039
R13      EQU   13                                                       00690039
R14      EQU   14                                                       00691039
R15      EQU   15                                                       00692039
         SPACE 1                                                        00700032
         COPY  XTAOPTN                                                  00700141
         SPACE 1                                                        00701041
&CSECT   CSECT                                                          00710032
         USING &CSECT,R15          USE ENTRY REGISTER FOR BASE          00720032
         B     &CSECT.$            SKIP PAST MODULE ID                  00730032
         DC    YL1(9+9+6+18)       LENGTH OF ID FIELD                   00740032
         DC    CL9'&CSECT'         CSECT NAME                           00750032
         DC    CL9'&SYSDATE'       DATE OF ASSEMBLY                     00760032
         DC    CL6'&SYSTIME'       TIME OF ASSEMBLY                     00770032
.*----------------------------------------------------------------*     00780032
.*   NOW GO TO DEPENDENT CODE GENERATION                          *     00790032
.*----------------------------------------------------------------*     00800032
         AIF   (T'&MAIN NE 'O').GENMAIN                                 00810032
         AIF   (T'&EXIT NE 'O').GENEXIT                                 00820032
         AIF   (T'&SUBR NE 'O').GENSUBR                                 00830032
         AIF   (T'&TASK NE 'O').GENTASK                                 00840032
         AIF   (T'&ETXR NE 'O').GENETXR                                 00850032
.*----------------------------------------------------------------*     00860032
.*   GENERATE MAINLINE ENTRY CODE                                 *     00870032
.*----------------------------------------------------------------*     00880032
.GENMAIN ANOP                                                           00890032
&IMAIN   SETB  1                                                        00900032
&GMLEN   SETA  72                                                       00901035
         DC    CL18'TARA MAINLINE'                                      00910032
         DS    0F                                                       00920032
         DC    CL20'  COMMON STORAGE AT '                               00930032
@CADDR   DC    V(XTACMAP)                                               00940032
         SPACE 1                                                        00953038
         DS    0H                                                       00960032
&CSECT.$ EQU   *                                                        00970032
         DROP  R15                                                      00980032
         STM   R14,R12,12(R13)     PRESERVE REGISTERS                   00990032
         LR    R12,R15             LOAD OUR BASE REGISTER               01000032
         USING &CSECT,R12          ESTABLISH ADDRESSABILITY FOR GOOD    01010032
         MNOTE '         GETMAIN R,LV=&GMLEN,SP=0'                      01020035
         GETMAIN R,LV=&GMLEN,SP=0                                       01030035
         ST    R13,4(R1)           CREATE SAVEAREA BACKWARD CHAIN       01040032
         ST    R1,8(R13)           AND FORWARD CHAIN, TOO               01050032
         LR    R13,R1              THEN POINT TO OUR VERY OWN SAVEAREA  01060032
         L     R10,@CADDR          LOAD POINTER TO COMMON STORAGE       01070032
         USING XTACMAP,R10         NOW, GET ADDRESSABILITY TO COMMON    01080032
         MEXIT                                                          01090032
.*----------------------------------------------------------------*     01100032
.*   GENERATE SUBROUTINE ENTRY CODE                               *     01110032
.*----------------------------------------------------------------*     01120032
.GENSUBR ANOP                                                           01130032
&ISUBR   SETB  1                                                        01140032
&GMLEN   SETA  72                                                       01141035
         DC    CL18'TARA &SUBR SUBR'                                    01150032
         SPACE 1                                                        01160032
         DS    0H                                                       01170032
&CSECT.$ EQU   *                                                        01180032
         DROP  R15                                                      01190032
         STM   R14,R12,12(R13)     PRESERVE REGISTERS                   01200032
         LR    R12,R15             LOAD OUR BASE REGISTER               01210032
         USING &CSECT,R12          ESTABLISH ADDRESSABILITY FOR GOOD    01220032
         LR    R7,R1               PARAMETER POINTER INTO R7            01230032
         MNOTE '         GETMAIN R,LV=&GMLEN,SP=0'                      01240035
         GETMAIN R,LV=&GMLEN,SP=0                                       01250035
         ST    R13,4(R1)           CREATE SAVEAREA BACKWARD CHAIN       01260032
         ST    R1,8(R13)           AND FORWARD CHAIN, TOO               01270032
         LR    R13,R1              THEN POINT TO OUR VERY OWN SAVEAREA  01280032
         USING XTACMAP,R10         ADDRESSABILITY TO COMMON AREA        01290032
         USING XTASMAP,R11                                              01300032
         MEXIT                                                          01310032
.*----------------------------------------------------------------*     01320032
.*   GENERATE SUBTASK ENTRY CODE                                  *     01330032
.*----------------------------------------------------------------*     01340032
.GENTASK ANOP                                                           01350032
&ITASK   SETB  1                                                        01360032
&GMLEN   SETA  72                                                       01361035
         DC    CL18'TARA &TASK TASK'                                    01370032
         SPACE 1                                                        01383038
         DS    0H                                                       01390032
&CSECT.$ EQU   *                                                        01400032
         DROP  R15                                                      01410032
         STM   R14,R12,12(R13)     PRESERVE REGISTERS                   01420032
         LR    R12,R15             LOAD OUR BASE REGISTER               01430032
         USING &CSECT,R12          ESTABLISH ADDRESSABILITY FOR GOOD    01440032
         LM    R10,R11,0(R1)       LOAD PASSED PARAMETERS               01450032
         MNOTE '         GETMAIN R,LV=&GMLEN,SP=0'                      01460035
         GETMAIN R,LV=&GMLEN,SP=0                                       01470035
         ST    R13,4(R1)           CREATE SAVEAREA BACKWARD CHAIN       01480032
         ST    R1,8(R13)           AND FORWARD CHAIN, TOO               01490032
         LR    R13,R1              THEN POINT TO OUR VERY OWN SAVEAREA  01500032
         USING XTACMAP,R10         ADDRESSABILITY TO COMMON AREA        01510032
         USING XTASMAP,R11         ADDRESSABILITY TO SESSION STORAGE    01520032
         MEXIT                                                          01530032
.*----------------------------------------------------------------*     01540032
.*   GENERATE END-OF-TASK EXIT ROUTINE ENTRY CODE                 *     01550032
.*----------------------------------------------------------------*     01560032
.GENETXR ANOP                                                           01570032
&IETXR   SETB  1                                                        01580032
&GMLEN   SETA  76                                                       01581035
         DC    CL18'TARA &TASK ETXR'                                    01590032
         SPACE 1                                                        01600032
         DS    0H                                                       01610032
&CSECT.$ EQU   *                                                        01620032
         DROP  R15                                                      01630032
         STM   R14,R12,12(R13)     PRESERVE REGISTERS                   01640032
         LR    R12,R15             LOAD OUR BASE REGISTER               01650032
         USING &CSECT,R12          ESTABLISH ADDRESSABILITY FOR GOOD    01670032
         LR    R7,R1               KEEP TCB ADDRESS                     01671032
         MNOTE '         GETMAIN R,LV=&GMLEN,SP=0'                      01680035
         GETMAIN R,LV=&GMLEN,SP=0                                       01690035
         ST    R13,4(R1)           CREATE SAVEAREA BACKWARD CHAIN       01700032
         ST    R1,8(R13)           AND FORWARD CHAIN, TOO               01710032
         LR    R13,R1              THEN POINT TO OUR VERY OWN SAVEAREA  01720032
         ST    R7,72(R1)           CACHE THE TCB POINTER                01721035
         USING TCB,R7              MAP TCB OF TASK WHICH DROVE US       01730032
         L     R8,TCBFSA           POINT TO THAT TASK'S SAVEAREA        01740032
         ICM   R7,B'0111',TCBCMPC                                       01741042
         DROP  R7                                                       01750032
         ICM   R7,B'1000',=XL1'00'                                      01751042
         L     R8,24(R8)           GET R1 WHICH WAS GIVEN TO TASK       01760032
         LM    R10,R11,0(R8)       WHICH POINTS TO NEEDED REGS          01770032
         USING XTACMAP,R10         ADDRESSABILITY TO COMMON AREA        01780032
         USING XTASMAP,R11         ADDRESSABILITY TO SESSION STORAGE    01790032
         LA    R1,72(R13)          POINT TO TCB POINTER                 01790135
         MNOTE '         DETACH (1)'                                    01791035
         DETACH (1)                RELEASE TASK CB'S                    01800035
         MNOTE '         FREEMAIN RC,LV=8,A=(R8)'                       01801034
         FREEMAIN RC,LV=8,A=(R8)   RELEASE PARAMETER STORAGE AREA       01810033
         MEXIT                                                          01820032
.*----------------------------------------------------------------*     01830032
.*   GENERATE ENTRY CODE FOR VTAM EXIT ROUTINES                   *     01840032
.*----------------------------------------------------------------*     01850032
.GENEXIT ANOP                                                           01860032
&IEXIT   SETB  1                                                        01870032
&TEXIT   SETC  '&EXIT'                                                  01880032
&GMLEN   SETA  76                                                       01881035
         DC    CL18'TARA &EXIT EXIT'                                    01890032
         SPACE 1                                                        01900032
         DS    0H                                                       01910032
&CSECT.$ EQU   *                                                        01920032
         DROP  R15                                                      01930032
         LR    R12,R15             LOAD OUR BASE REGISTER               01940032
         USING &CSECT,R12          ESTABLISH ADDRESSABILITY FOR GOOD    01950032
         LR    R8,R0                                                    01960032
         LR    R9,R1                                                    01970032
         MNOTE '         GETMAIN R,LV=&GMLEN,SP=0'                      01980035
         GETMAIN R,LV=&GMLEN,SP=0                                       01990035
         ST    R13,4(R1)           SAVE R13 FOR LERAD/SYNAD             02000032
         ST    R14,72(R1)          SAVE RETURN ADDRESS                  02010032
         LR    R13,R1              THEN POINT TO OUR SAVEAREA           02020032
         L     R10,=V(XTACMAP)     GET ADDRESS OF COMMON AREA           02030032
         USING XTACMAP,R10         ADDRESSABILITY TO COMMON AREA        02040032
.*----------------------------------------------------------------*     02050032
.*   RPL, SYNAD, AND LERAD EXITS ARE ASSOCIATED WITH SESSIONS     *     02060032
.*----------------------------------------------------------------*     02070032
         AIF   ('&EXIT' EQ 'RPL').SESS                                  02080032
         AIF   ('&EXIT' EQ 'LERAD').SESS                                02090032
         AIF   ('&EXIT' NE 'SYNAD').MEXIT                               02100032
.SESS    ANOP                                                           02110032
         USING IFGRPL,R9           GET RPL ADDRESSABILITY               02120032
         L     R11,RPLUSFLD        GET POINTER TO SESSION STORAGE       02130032
         USING XTASMAP,R11         ADDRESS SESSION STORAGE              02140032
.*----------------------------------------------------------------*     02150032
.*   IN RPL EXITS, CHECK THAT TPEND HAS NOT OCCURRED              *     02160032
.*----------------------------------------------------------------*     02170032
         AIF   ('&EXIT' NE 'RPL').MEXIT                                 02180032
         TM    CS#FLAG1,CS#TPNXI   HAS TPEND OCCURRED?                  02190043
         BNZ   &NAME.@             IF NOT, CONTINUE NORMALLY            02210032
.MEXIT   MEXIT                                                          02220032
         MEND                                                           02230032