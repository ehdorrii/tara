         MACRO                                                          00010000
&LABEL   EPILOGUE                                                       00020011
.*----------------------------------------------------------------*     00020506
.*   SET-SYMBOL TO REQUEST LISTING OF MAPS                        *     00020611
.*----------------------------------------------------------------*     00020706
         GBLB  &MAPLIST            SET IN OPEN CODE                     00020811
.*----------------------------------------------------------------*     00020914
.*   SET-SYMBOL TO REQUEST COMMON STORAGE DSECT                   *     00021014
.*----------------------------------------------------------------*     00021114
         GBLB  &MAP                CHECKED IN XTACMAP                   00021220
&MAP     SETB  1                                                        00021314
.*----------------------------------------------------------------*     00021406
.*   SET-SYMBOLS FOR GETTING INFO FROM PROLOGUE                   *     00021506
.*----------------------------------------------------------------*     00021606
         GBLA  &GMLEN                                                   00021729
         GBLB  &IMAIN,&IEXIT,&ISUBR,&ITASK,&IETXR                       00021828
         GBLC  &TEXIT,&NAME                                             00021918
.*----------------------------------------------------------------*     00022006
.*   GENERATE APPROPRIATE CODE FOR TYPE OF ROUTINE                *     00023006
.*----------------------------------------------------------------*     00030006
         AIF   (&IMAIN EQ 1).GENMAIN                                    00040006
         AIF   (&IEXIT EQ 1).GENEXIT                                    00041006
         AIF   (&ISUBR EQ 1).GENSUBR                                    00042006
         AIF   (&ITASK EQ 1).GENTASK                                    00042127
         AIF   (&IETXR EQ 1).GENETXR                                    00042228
         MNOTE 12,'NO CORRESPONDING PROLOGUE MACRO'                     00043006
         MEXIT                                                          00044006
.*----------------------------------------------------------------*     00050006
.*   EXIT CODE FOR MAINLINE, SUBROUTINES, LERAD AND SYNAD         *     00100006
.*----------------------------------------------------------------*     00100106
.GENETXR ANOP                                                           00100328
.GENTASK ANOP                                                           00100428
.GENSUBR ANOP                                                           00100527
.GENMAIN ANOP                                                           00100606
&LABEL   DS    0H                                                       00101004
         LR    R1,R13              PREPARE TO FREE OUR SAVEAREA         00101206
         L     R13,4(R13)          REVERT TO CALLER'S SAVEAREA          00102006
         ST    R15,16(R13)         AND PUT RETURN CODE IN SAVED R15     00102106
         MNOTE '         FREEMAIN R,LV=&GMLEN,A=(R1)'                   00103029
         FREEMAIN R,LV=&GMLEN,A=(R1)                                    00110029
         LM    R14,R12,12(R13)     RESTORE CALLER'S REGISTERS           00400006
         BR    R14                 RETURN TO CALLER                     00410006
         EJECT                                                          00410115
         LTORG                                                          00410215
         AGO   .MAPS                                                    00411011
.*----------------------------------------------------------------*     00450006
.*   EGRESS CODE FOR EXITS                                        *     00460006
.*----------------------------------------------------------------*     00470006
.GENEXIT ANOP                                                           00470106
&NAME.@  EQU   *                                                        00490118
         LR    R10,R15             SAVE RETURN CODE (FREEMAIN WILL      00490226
         LR    R11,R13               CHANGE R15).                       00490326
         L     R14,72(R13)         GET RETURN ADDRESS.                  00491026
         L     R13,4(R13)                                               00491125
         MNOTE '         FREEMAIN R,LV=&GMLEN,A=(R11)'                  00491229
         FREEMAIN R,LV=&GMLEN,A=(R11)                                   00492029
         LR    R15,R10             RESTORE SAVED RETURN CODE.           00492126
         BR    R14                 RETURN TO CALLER                     00493006
         EJECT                                                          00493115
         LTORG                                                          00493215
.*----------------------------------------------------------------*     00493313
.*   MAP COMMON AND SESSION STORAGE, AND RPL                      *     00493422
.*----------------------------------------------------------------*     00493513
.MAPS    ANOP                                                           00495020
         EJECT                                                          00495106
         AIF   (&MAPLIST EQ 1).LISTIT                                   00495220
         PUSH  PRINT               PRESERVE CURRENT PRINT STATUS        00495309
         PRINT OFF                 INHIBIT SESSION AREA LISTING         00495409
.LISTIT  ANOP                                                           00495520
         COPY  XTACMAP                                                  00495820
         EJECT                                                          00495920
         COPY  XTASMAP                                                  00496020
         EJECT                                                          00496120
         IFGRPL DSECT=YES,AM=VTAM                                       00496210
         AIF   (&IETXR EQ 0).NOTCB                                      00496329
         EJECT                                                          00496429
         IKJTCB DSECT=YES,LIST=YES                                      00496529
.NOTCB   ANOP                                                           00496629
         AIF   (&MAPLIST EQ 1).MEXIT                                    00499511
         POP   PRINT                                                    00499610
.MEXIT   ANOP                                                           00499810
&SYSECT  CSECT                                                          00499929
         MEND                                                           00500000