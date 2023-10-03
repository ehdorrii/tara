         MACRO                                                          00010000
.*====================================================================* 00020001
.*                                                                    * 00020101
.*         THIS MACRO GENERATES A HOST ALIAS TABLE ENTRY.             * 00021001
.*                                                                    * 00023001
.*====================================================================* 00024001
.*                                                                      00025001
&NAME    HOST  &LUPREFIX=,&ALIAS=,&NUMCALLS=                            00030004
.*                                                                      00030102
.*====================================================================* 00030202
.*                      DECLARE SET-SYMBOLS                           * 00030302
.*====================================================================* 00030402
.*                                                                      00030502
         GBLA  &SVC,&HOSTNO,&CALLS(64)                                  00031008
         GBLC  &LUPFX(64)                                               00031105
         LCLA  &NUMNAME,&ENT,&NAMELEN                                   00032002
         LCLB  &ERROR                                                   00032102
.*                                                                      00032511
         AIF   (T'&LUPREFIX NE 'O').LUHERE                              00033004
         MNOTE 8,'REQUIRED OPERAND ''LUPREFIX'' OMITTED.'               00034004
&ERROR   SETB  1                                                        00035002
.LUHERE  ANOP                                                           00036002
.*                                                                      00036102
         AIF   (T'&ALIAS NE 'O').ALSHERE                                00036202
         MNOTE 8,'REQUIRED OPERAND ''ALIAS'' OMITTED.'                  00036302
&ERROR   SETB  1                                                        00036402
.ALSHERE ANOP                                                           00036502
.*                                                                      00037002
         AIF   (&ERROR).MEND                                            00037102
.*                                                                      00037202
&NUMNAME SETA  N'&ALIAS                                                 00037302
&HOSTNO  SETA  &HOSTNO+1                                                00037402
&ENT     SETA  0                                                        00037502
&CALLS(&HOSTNO) SETA &SVC                                               00037608
         AIF   (T'&NUMCALLS EQ 'O').NOCALLS                             00037708
&CALLS(&HOSTNO) SETA &NUMCALLS                                          00037808
.NOCALLS ANOP                                                           00037908
&LUPFX(&HOSTNO) SETC  '&LUPREFIX'                                       00038004
.*                                                                      00038102
.LOOP    ANOP                                                           00038202
&ENT     SETA  &ENT+1                                                   00038302
&NAMELEN SETA  K'&ALIAS(&ENT)                                           00038402
         DC    A(HOST&HOSTNO)                                           00038506
         DC    YL1(&NAMELEN),CL11'&ALIAS(&ENT)'                         00039009
         AIF   (&ENT LT &NUMNAME).LOOP                                  00039102
.*                                                                      00039202
.MEND    ANOP                                                           00039302
         MEND                                                           00040000