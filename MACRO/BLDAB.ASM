         MACRO                                                          00010000
         BLDAB &ATTR                                                    00020000
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00030012
.*                                                                    * 00031012
.*    BUILD ATTRIBUTE BYTE          9/80 - 3270 SERIES                * 00040012
.*                                  REVISED 3/83                      * 00050012
.*                                                                    * 00050112
.*    MACRO 'BLDAB' WILL BUILD A GLOBAL SYMBOL CONTAINING, IN         * 00051012
.*    CHARACTER FORM, THE HEX VALUE OF THE ATTRIBUTE BYTE WHICH       * 00052012
.*    CORRESPONDS TO THE FIELD DESCRIPTION PASSED IN THE              * 00053012
.*    INVOCATION.                                                     * 00054012
.*                                                                    * 00055012
.*    THE FIRST SUBPARAMETER DESCRIBES THE PROTECTION ATTRIBUTE       * 00056012
.*    - 'U' OR 'UNPROT' FOR UNPROTECTED FIELDS; 'P' OR 'PROT' FOR     * 00057012
.*    PROTECTED FIELDS; 'S' OR 'SKIP' FOR PROTECTED+SKIP FIELDS.      * 00058012
.*    THE SECOND SUBPARAMETER DESCRIBES THE APPEARENCE OF THE         * 00058112
.*    FIELD - HIGH-INTENSITY ('H', 'HI', OR 'HIGH'), LOW INTENSITY    * 00059012
.*    ('L', 'LO', OR 'LOW'), OR NON-DISPLAY ('N' OR 'NONDISP').       * 00059112
.*    THE THIRD SUBPARAMETER SPECIFIES WHETHER THE MODIFIED DATA      * 00059212
.*    TAG IS TO BE SET OR RESET: IF 'MDT' IS CODED THE MDT WILL       * 00059312
.*    BE SET; A RESET STATUS IS SPECIFIED BY M OMITTING THIS          * 00059412
.*    SUBPARAMETER.                                                   * 00059512
.*                                                                    * 00059612
.*    FIELD ATTRIBUTE BYTE:             V - VALIDITY BITS             * 00059712
.*           +-0-0-0-0-0-0-0-0-+        P - FIELD PROTECT BIT         * 00059812
.*           | V V P   D D   M |        D - DISPLAY DESCRIPTOR BITS   * 00060012
.*           +-0-1-2-3-4-5-6-7-+        M - MODIFIED DATA TAG BIT     * 00060212
.*                                                                    * 00060312
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00060412
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00060612
.*   DECLARE SET-SYMBOLS                                              * 00060712
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00060812
         GBLC  &ATRBYTE            USED TO RETURN ATTRIBUTE BYTE        00061009
         LCLA  &ATTR#              DECIMAL VALUE OF ATTRIBUTE BYTE      00070009
         LCLA  &OFFSET             INDEX INTO &STRING                   00071009
         LCLC  &STRING             CHAR REP OF 3270 COUNTING NUMBERS    00080009
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00081012
.*   INITIALIZE SET-SYMBOLS                                           * 00082012
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00083012
&STRING  SETC  '40C1C2C3C4C5C6C7C8C94A4B4C4D4E4F50D1D2D3D4D5D6D7D8D95A5X00090000
               B5C5D5E5F6061E2E3E4E5E6E7E8E96A6B6C6D6E6FF0F1F2F3F4F5F6FX00100000
               7F8F97A7B7C7D7E7F'                                       00110000
&ATTR#   SETA  0                                                        00120000
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00121012
.*   PROCESS MODIFIED-DATA-TAG ATTRIBUTE                              * 00122012
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00123012
         AIF   (T'&ATTR(3) EQ 'O').MDTOFF                               00130012
         AIF   ('&ATTR(3)' EQ 'MDT').MDTON                              00140012
         MNOTE 8,' ''&ATTR(3)'' IS INVALID; MDT ON ASSUMED'             00150009
.MDTON   ANOP                                                           00160012
&ATTR#   SETA  &ATTR#+1                                                 00170000
.MDTOFF  ANOP                                                           00170112
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00171012
.*   PROCESS INTENSITY ATTRIBUTE                                      * 00172012
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00173012
         AIF   (T'&ATTR(2) EQ 'O').LOINT                                00180012
         AIF   ('&ATTR(2)' EQ 'L').LOINT                                00190012
         AIF   ('&ATTR(2)' EQ 'LO').LOINT                               00191012
         AIF   ('&ATTR(2)' EQ 'LOW').LOINT                              00192012
         AIF   ('&ATTR(2)' EQ 'H').HINT                                 00200005
         AIF   ('&ATTR(2)' EQ 'HI').HINT                                00201009
         AIF   ('&ATTR(2)' EQ 'HIGH').HINT                              00202009
         AIF   ('&ATTR(2)' EQ 'N').NODISP                               00210005
         AIF   ('&ATTR(2)' EQ 'NONDISP').NODISP                         00211009
         MNOTE 8,' ''&ATTR(2)'' IS INVALID; LOW INTENSITY ASSUMED'      00220000
         AGO   .LOINT                                                   00230012
.HINT    ANOP                                                           00240000
&ATTR#   SETA  &ATTR#+8            BITS 4-5 = B'10'                     00250009
         AGO   .LOINT                                                   00260012
.NODISP  ANOP                                                           00270000
&ATTR#   SETA  &ATTR#+12           BITS 4-5 = B'11'                     00280009
.LOINT   ANOP                                                           00280112
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00281012
.*   PROCESS PROTECTION ATTRIBUTE                                     * 00282012
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00283012
         AIF   (T'&ATTR(1) EQ 'O').UNPROT                               00290012
         AIF   ('&ATTR(1)' EQ 'U').UNPROT                               00300012
         AIF   ('&ATTR(1)' EQ 'UNPROT').UNPROT                          00301012
         AIF   ('&ATTR(1)' EQ 'P').PROT                                 00310005
         AIF   ('&ATTR(1)' EQ 'PROT').PROT                              00311009
         AIF   ('&ATTR(1)' EQ 'S').SKIP                                 00312011
         AIF   ('&ATTR(1)' EQ 'SKIP').SKIP                              00313011
         MNOTE 8,' ''&ATTR(1)'' IS INVALID; UNPROTECTED FIELD ASSUMED'  00320000
         AGO   .UNPROT                                                  00330012
.SKIP    ANOP                                                           00340011
&ATTR#   SETA  &ATTR#+16           BIT 3 = B'1' PLUS...                 00350012
.PROT    ANOP                                                           00351011
&ATTR#   SETA  &ATTR#+32           BIT 2 = B'1'                         00352011
.UNPROT  ANOP                                                           00360012
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00361012
.*   NOW MAKE THE ATTRIBUTE BYTE VALID FOR 3270                       * 00362012
.*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''* 00363012
&OFFSET  SETA  &ATTR#*2+1          CALCULATE OFFSET INTO &STRING        00370009
&ATRBYTE SETC  '&STRING'(&OFFSET,2)    EXTRACT 3270 CODE                00380009
         MEND                                                           00390000