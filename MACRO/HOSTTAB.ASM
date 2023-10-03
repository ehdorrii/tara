         MACRO                                                          00030000
.*====================================================================* 00030402
.*                                                                    * 00030502
.*  THIS IS A MACRO WHICH GENERATES A CSECT CARD; THE NUMBER OF SVC'S * 00031002
.*     (SWITCHED VIRTUAL CIRCUITS) IS SPECIFIED HERE, ALSO.           * 00032002
.*                                                                    * 00033002
.*====================================================================* 00034002
.*                                                                      00035002
&NAME    HOSTTAB &NUMSVC=                                               00040002
.*                                                                      00040102
.*====================================================================* 00041002
.*                      DECLARE SET-SYMBOLS                           * 00041102
.*====================================================================* 00041202
.*                                                                      00041302
         LCLB  &ERROR                                                   00041403
         GBLA  &SVC,&HOSTNO                                             00041503
.*                                                                      00042001
         AIF   (T'&NAME NE 'O').NAMEOK                                  00050002
         MNOTE 8,'NAME REQUIRED ON HOSTTAB MACRO.'                      00060002
&ERROR   SETB  1                                                        00070003
.NAMEOK  ANOP                                                           00071002
.*                                                                      00080000
         AIF   (T'&NUMSVC NE 'O').SVCHERE                               00100000
         MNOTE 8,'REQUIRED OPERAND ''NUMSVC'' OMITTED.'                 00110003
&ERROR   SETB  1                                                        00111003
         AGO   .SVCTERM                                                 00111103
.SVCHERE ANOP                                                           00112002
.*                                                                      00120000
         AIF   (T'&NUMSVC EQ 'N').SVCTERM                               00121002
         MNOTE 8,'NUMSVC MUST BE A SELF-DEFINING TERM.'                 00122002
&ERROR   SETB  1                                                        00123003
.SVCTERM ANOP                                                           00123103
.*                                                                      00124002
         AIF   (&ERROR).MEND                                            00131003
.*                                                                      00132000
&NAME    CSECT                                                          00140000
         SPACE 1                                                        00141004
*********************************************************************** 00142004
*                         HOST ALIAS TABLE                            * 00143004
*********************************************************************** 00144004
         SPACE 1                                                        00145004
&SVC     SETA  &NUMSVC(1)                                               00150002
&HOSTNO  SETA  0                                                        00150103
.*                                                                      00151000
.MEND    ANOP                                                           00160000
         MEND                                                           00170000
