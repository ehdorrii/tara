         MACRO                                                          00010000
         ROCOL &ROW,&COL,&MODEL=4                                       00020007
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00021013
.*                                                                    * 00030007
.*   3270 SERIES - 5/7/79 - REVISED 8/6/82                            * 00040007
.*                                                                    * 00040107
.*   TRANSLATE ROW AND COLUMN COORDINATES TO 3270 SCREEN ADDRESSING   * 00041007
.*   SCHEME. REVISED TO SUPPORT 3270 MODELS 1-5.                      * 00050007
.*                                                                    * 00050207
.*   ADDRESS BYTES ARE RETURNED IN THE GLOBAL SETC SYMBOLS &COORD1    * 00050307
.*   AND &COORD2.                                                     * 00050407
.*                                                                    * 00050507
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00051013
         GBLC  &COORD1,&COORD2                                          00061007
         LCLA  &MOD,&PROD,&SUM,&SUB1,&SUB2,&SUB3,&SUB4,&#ROWS,&#COLS    00070011
         LCLB  &STOP                                                    00071006
         LCLC  &STRING                                                  00080000
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00080113
.*   THE VALUES PASSED FOR ROW AND COLUMN SPECIFICATIONS MUST BE      * 00080213
.*   SELF-DEFINING TERMS IN ORDER FOR THE VALUES TO BE AVAILABLE      * 00080313
.*   DURING MACRO "EXPANSION" - SINCE CALCULATIONS ARE DONE WITH      * 00080413
.*   THESE VALUES.                                                    * 00080513
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00080613
         AIF   (T'&ROW EQ 'N').TROWOK                                   00081006
         MNOTE 8,'ROW SPECIFICATION IS NOT A SELF-DEFINING TERM'        00082006
&STOP    SETB  1                                                        00083006
.TROWOK  AIF   (T'&COL EQ 'N').TCOLOK                                   00084006
         MNOTE 8,'COLUMN SPECIFICATION IS NOT A SELF-DEFINING TERM'     00085006
&STOP    SETB  1                                                        00086006
.TCOLOK  AIF   (&STOP EQ 1).STOP                                        00087006
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00087113
.*   MODEL SPECIFICATION MUST BE IN THE RANGE OF 1-5.                 * 00087213
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00087313
&MOD     SETA  &MODEL                                                   00087410
.MODOK   AIF   (&MOD EQ 1).MOD1                                         00087908
         AIF   (&MOD EQ 2).MOD2                                         00088008
         AIF   (&MOD EQ 3).MOD3                                         00088108
         AIF   (&MOD EQ 4).MOD4                                         00088208
         AIF   (&MOD EQ 5).MOD5                                         00088308
         MNOTE 8,'MODEL SPECIFICATION OF ''&MODEL'' IS INVALID'         00088408
&STOP    SETB  1                                                        00088508
         AGO   .STOP                                                    00088608
.MOD1    ANOP                                                           00088708
&#ROWS   SETA  12                                                       00088808
&#COLS   SETA  40                                                       00088908
         AGO   .MODSET                                                  00089008
.MOD2    ANOP                                                           00089108
&#ROWS   SETA  24                                                       00089208
&#COLS   SETA  80                                                       00089308
         AGO   .MODSET                                                  00089408
.MOD3    ANOP                                                           00089508
&#ROWS   SETA  32                                                       00089608
&#COLS   SETA  80                                                       00089708
         AGO   .MODSET                                                  00089808
.MOD4    ANOP                                                           00089908
&#ROWS   SETA  43                                                       00090008
&#COLS   SETA  80                                                       00090108
         AGO   .MODSET                                                  00090208
.MOD5    ANOP                                                           00090308
&#ROWS   SETA  27                                                       00090408
&#COLS   SETA  132                                                      00090508
.MODSET  ANOP                                                           00090612
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00090713
.*   THE VALUES OF ROW AND COLUMN MUST BE WITHIN THE VALID RANGE      * 00090813
.*   OF VALUES FOR THE MODEL SPECIFIED.                               * 00090913
.*                                                                    * 00091013
.*                 MODEL      ROWS       COLS                         * 00091113
.*                   1         12         40                          * 00091213
.*                   2         24         80                          * 00091313
.*                   3         32         80                          * 00091413
.*                   4         43         80                          * 00091513
.*                   5         27        132                          * 00091613
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00091713
         AIF   (&ROW LE &#ROWS).VROWOK                                  00091808
         MNOTE 8,'''&ROW'' IS NOT A VALID ROW SPECIFICATION'            00091906
&STOP    SETB  1                                                        00092006
.VROWOK  AIF   (&COL LE &#COLS).VCOLOK                                  00092108
         MNOTE 8,'''&COL'' IS NOT A VALID COLUMN SPECIFICATION'         00092206
&STOP    SETB  1                                                        00092306
.VCOLOK  AIF   (&STOP EQ 0).GO                                          00092406
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00092513
.*   IF ERRORS HAVE BEEN FOUND, SET COORDS TO 00 AND QUIT             * 00092613
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00092713
.STOP    ANOP                                                           00092806
&COORD1  SETC  '00'                                                     00092906
&COORD2  SETC  '00'                                                     00093006
         MEXIT                                                          00093106
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00093213
.*   SETC SYMBOL &STRING IS SET TO A CHARACTER VECTOR MADE UP OF      * 00093313
.*   THE 'COUNTING NUMBERS' OF A 3270                                 * 00093413
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00093513
.GO      ANOP                                                           00093606
&STRING  SETC  '40C1C2C3C4C5C6C7C8C94A4B4C4D4E4F50D1D2D3D4D5D6D7D8D95A5X00094000
               B5C5D5E5F6061E2E3E4E5E6E7E8E96A6B6C6D6E6FF0F1F2F3F4F5F6FX00100000
               7F8F97A7B7C7D7E7F'                                       00110000
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00111013
.*   ADDRESS BYTES ARE ARRIVED AT BY CALCULATING THE RELATIVE BYTE    * 00112013
.*   NUMBER ON THE SCREEN                                             * 00113013
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00114013
&PROD    SETA  (&ROW-1)*&#COLS                                          00120008
&SUM     SETA  &PROD+&COL-1                                             00130003
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00131013
.*   THE RELATIVE BYTE ADDRESS MUST NOW BE CONVERTED TO RADIX 64      * 00132013
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00133013
&SUB1    SETA  &SUM/64                                                  00140000
&SUB2    SETA  &SUM-&SUB1*64                                            00150003
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00151013
.*   THE ACTUAL HEX CODES ARE CONVERTED TO 3270 COUNTING NUMBERS BY   * 00152013
.*   USING THE VALUES AS OFFSETS INTO THE SETC SYMBOL '&STRING'       * 00153013
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00154013
&SUB3    SETA  &SUB1*2+1                                                00160000
&SUB4    SETA  &SUB2*2+1                                                00170000
&COORD1  SETC  '&STRING'(&SUB3,2)                                       00180001
&COORD2  SETC  '&STRING'(&SUB4,2)                                       00190001
         MEND                                                           00200000