         MACRO                                                          00010000
&LABEL   CVH   &ROP1,&SOP2,&MF=                                         00020015
.*                                                                      00030001
.*   VERSION 2.0 - JULY 8, 1980                                         00050016
.*                                                                      00060009
.*   CONVERT TO HEX: CONVERTS A FULLWORD OF BINARY IN REGISTER &ROP1    00070003
.*    TO A DOUBLEWORD OF EBCDIC-FORMATTED HEXADECIMAL IN STORAGE        00080003
.*    LOCATION &SOP2. REGISTER &ROP1 IS UNCHANGED, AND THE 8-BYTE       00090007
.*    STORAGE LOCATION &SOP2 IS THE ONLY STORAGE AFFECTED.              00100007
.*                                                                      00110007
.*   &CVHCSCT IS THE NAME OF THE CSECT IN WHICH CVH WAS LAST CALLED;    00120007
.*    &CVHTRTB REPRESENTS THE TR TABLE ALL CVH'S IN A CSECT WILL USE;   00130015
.*    &CVHOC IS THE LABEL FOR THE CONSTANT X'F0F0' FOR THE OC;          00131015
.*    &CVHB IS THE LABEL FOR THE FIRST INSTR AFTER THE TR TABLE.        00132015
.*                                                                      00140003
         LCLC  &CVHB                                                    00150015
         GBLC  &CVHCSCT,&CVHTRTB,&CVHOC                                 00151015
.*                                                                      00160003
.*   MF=LONG WILL FORCE A FULL 256 BYTE TRANSLATE TABLE TO              00170020
.*    BE BUILT IN-LINE. IF OMITTED, ONLY THE REQUIRED 16 BYTES          00180015
.*    WILL BE GENERATED IF THERE HAS NOT YET BEEN ANOTHER CVH           00190015
.*    TRANSLATE TABLE GENERATED IN THE SAME CSECT.                      00200015
.*                                                                      00210007
         AIF   (T'&MF EQ 'O').MFOK      CHECK FOR OMITTED MF OPERAND    00211015
         AIF   ('&MF' EQ 'LONG').MFOK   CHECK FOR VALID MF OPERAND      00220015
         MNOTE 8,'INVALID OPERAND ''&MF'' SPECIFIED ON MF PARAMETER'    00240015
.MFOK    ANOP                           MF OPERAND WAS VALID            00250015
.*                                                                      00260007
&LABEL   STCM  &ROP1,15,&SOP2               GET THE DATA INTO STORAGE   00270021
         UNPK  &SOP2.(7),&SOP2.(4)          EXPAND THE DIGITS           00280021
         UNPK  &SOP2+7(1),&SOP2+6(1)        SWAP RIGHTMOST NYBBLES      00290021
.*                                                                      00310003
         AIF   ('&MF' EQ 'LONG').GENTABL                                00320003
         AIF   ('&CVHCSCT' NE '&SYSECT').GENTABL                        00330003
         OC    &SOP2+6(2),&CVHOC            MAKE SURE ALL ZONES ARE 'F' 00331021
         TR    &SOP2.(8),&CVHTRTB           CONVERT TO EBCDIC           00340021
         MEXIT                                                          00350003
.*                                                                      00360003
.*   IF WE GET HERE, THEN EITHER MF=LONG HAS BEEN CODED, OR CVH HAS     00370003
.*    NOT YET BEEN CALLED IN THE CURRENT CSECT AND THEREFORE THE        00380003
.*    TRANSLATE TABLE MUST BE BUILT.                                    00390015
.*                                                                      00400003
.GENTABL ANOP                                                           00410003
&CVHCSCT SETC  '&SYSECT'           SET GLOBAL TO CURRENT CSECT NAME     00420015
&CVHOC   SETC  'CVH&SYSNDX.O'      SET GLOBAL OC OPERAND NAME           00430015
&CVHTRTB SETC  'CVH&SYSNDX.T'      SET GLOBAL TR TABLE NAME             00431015
&CVHB    SETC  'CVH&SYSNDX.B'      SET LOCAL TO BRANCH DESTINATION      00432015
         B     &CVHB                        BRANCH AROUND CONSTANT DATA 00440021
&CVHOC   DC    X'F0F0'                      VALID NUMERIC EBCDIC ZONES  00450021
         AIF   ('&MF' NE 'LONG').SKIP00                                 00470003
&CVHTRTB DC    240XL1'00'                                               00480006
         AGO   .SKIPEQU                                                 00490003
.SKIP00  ANOP                                                           00500003
&CVHTRTB EQU   *-240     IF THIS CAUSES AN ADDRESSING ERROR USE MF=LONG 00510010
.SKIPEQU DC    CL16'0123456789ABCDEF'                                   00520003
&CVHB    OC    &SOP2+6(2),&CVHOC             MAKE ALL ZONES X'F'        00530021
         TR    &SOP2.(8),&CVHTRTB                                       00540017
         MEND                                                           00550000