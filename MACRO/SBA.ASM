         MACRO                                                          00010000
&LABEL   SBA   &ROW,&COL,&SF=,&IC                                       00020002
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00030003
.*       SET BUFFER ADDRESS             5/7/79 - 3270 SERIES          * 00040003
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00050003
         GBLC  &COORD1,&COORD2,&ATRBYTE                                 00060000
         LCLC  &SFB,&ICB                                                00070000
&ATRBYTE SETC  ''                                                       00080000
&SFB     SETC  ''                                                       00090000
&ICB     SETC  ''                                                       00100000
         ROCOL &ROW,&COL                                                00110000
         AIF   (T'&SF EQ 'O').SKIPATR                                   00120000
&SFB     SETC  '1D'                                                     00130000
         BLDAB &SF                                                      00140001
.SKIPATR AIF   (T'&IC EQ 'O').SKIPIC                                    00150000
         AIF   ('&IC' EQ 'IC').SKIPERR                                  00160000
         MNOTE 8,' ''&IC'' IS INVALID; IC ASSUMED'                      00170000
.SKIPERR ANOP                                                           00180000
&ICB     SETC  '13'                                                     00190000
.SKIPIC  ANOP                                                           00200000
&LABEL   DC    X'11&COORD1&COORD2&SFB&ATRBYTE&ICB'                      00210000
         MEND                                                           00220000