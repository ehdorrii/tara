         MACRO                                                          00010000
         PHASE &PHASE                                                   00010105
.*-----------------------------------------------------------------*    00010504
.*                                                                 *    00010604
.*  THIS MACRO MAINTAINS TWO FIELDS WHICH IDENTIFIES THE CURRENT   *    00010704
.*  AND THE PREVIOUS PROCESSING PHASES.                            *    00010804
.*                                                                 *    00010904
.*-----------------------------------------------------------------*    00011004
.*-----------------------------------------------------------------*    00011104
.*   DECLARE AND INITIALIZE LOCAL SET-SYMBOLS                      *    00011204
.*-----------------------------------------------------------------*    00011304
         LCLA  &SUBSCR             USED TO SUBSCRIPT INTO &PHASE        00011404
         GBLC  &PHSTAG,&PHSID      GEN'D LABEL AND HALFWORD LITERAL     00011516
&SUBSCR  SETA  1                                                        00012404
&PHSTAG  SETC  'PH'                                                     00012516
.*                                                                      00012610
.*==================== BUILD LABEL FOR PHASE ======================*    00012710
.*                                                                      00012810
.*-----------------------------------------------------------------*    00012904
.*   GET ROUTINE NUMBER                                            *    00013004
.*-----------------------------------------------------------------*    00013104
.LOOPL1  ANOP                                                           00013210
&PHSTAG  SETC  '&PHSTAG'.'&PHASE'(&SUBSCR,1)                            00013316
&SUBSCR  SETA  &SUBSCR+1                                                00013404
         AIF   ('&PHASE'(&SUBSCR,1) EQ '.').PARTTWO                     00013504
         AGO   .LOOPL1                                                  00013610
.*-----------------------------------------------------------------*    00013704
.*   APPEND '#'                                                    *    00013804
.*-----------------------------------------------------------------*    00013904
.PARTTWO ANOP                                                           00014004
&PHSTAG  SETC  '&PHSTAG'.'#'                                            00014116
&SUBSCR  SETA  &SUBSCR+1                                                00014204
.*-----------------------------------------------------------------*    00014304
.*   GET LINE NUMBER                                               *    00014404
.*-----------------------------------------------------------------*    00014504
.LOOPL2  ANOP                                                           00014610
&PHSTAG  SETC  '&PHSTAG'.'&PHASE'(&SUBSCR,1)                            00014716
&SUBSCR  SETA  &SUBSCR+1                                                00014804
         AIF   (&SUBSCR GT K'&PHASE).LDONE                              00014910
         AGO   .LOOPL2                                                  00015010
.LDONE   ANOP                                                           00015110
.*                                                                      00015210
.*================ BUILD PHASE NUMBER AS HALFWORD =================*    00015310
.*                                                                      00015410
.*-----------------------------------------------------------------*    00015510
.*   START AT BACK END, DO STATEMENT NUMBER FIRST                  *    00015610
.*-----------------------------------------------------------------*    00015710
&SUBSCR  SETA  &SUBSCR-1                                                00015810
&PHSID   SETC  '&PHASE'(&SUBSCR,1)                                      00015916
&SUBSCR  SETA  &SUBSCR-1                                                00016010
         AIF   ('&PHASE'(&SUBSCR,1) EQ '.').APP0L                       00016110
&PHSID   SETC  '&PHASE'(&SUBSCR,1).'&PHSID'                             00016316
&SUBSCR  SETA  &SUBSCR-1                                                00016413
         AGO   .HIGH                                                    00016510
.APP0L   ANOP                                                           00016610
&PHSID   SETC  '0'.'&PHSID'                                             00016716
.*-----------------------------------------------------------------*    00016810
.*   NOW DO ROUTINE NUMBER                                         *    00016910
.*-----------------------------------------------------------------*    00017010
.HIGH    ANOP                                                           00017110
&SUBSCR  SETA  &SUBSCR-1                                                00017210
&PHSID   SETC  '&PHASE'(1,&SUBSCR).'&PHSID'                             00017316
.*                                                                      00017410
.*====================== GENERATE THE CODE ========================*    00017510
.*                                                                      00017610
         SPACE 1                                                        00018002
&PHSTAG  EQU   *                                                        00020016
         MVC   CS#THEN,CS#THEN+2                                        00021014
         MVC   CS#NOW,=XL2'&PHSID'                                      00030016
         MEND                                                           00040000