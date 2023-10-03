         MACRO                                                          00010000
         GETLOCK &LOCKADR                                               00010100
.*-----------------------------------------------------------------*    00010500
.*                                                                 *    00010600
.*  THIS MACRO WILL ACQUIRE A SPIN-LOOP LOCK AT THE LOCATION       *    00010707
.*  SPECIFIED ON THE MACRO INVOCATION. WHEN THE LOCK IS ACQUIRED,  *    00010807
.*  THE ID OF THE ISSUING PHASE (AND THE CID OF THE PRIMARY LU,    *    00010907
.*  IF AVAILABLE) IS STORED IN THE LOCKWORD.                       *    00011007
.*                                                                 *    00011104
.*-----------------------------------------------------------------*    00012000
.*                                                                      00012600
.*===================== DECLARE SET-SYMBOLS =======================*    00012707
.*                                                                      00012800
         GBLB  &IMAIN,&IEXIT,&ISUBR,&ITASK,&IETXR                       00012906
         GBLC  &PHSID,&TEXIT                                            00013006
         LCLC  &NOLOCK                                                  00013100
.*                                                                      00013200
.*================== BUILD A LABEL FOR THE LOOP ===================*    00013300
.*                                                                      00013400
&NOLOCK  SETC  'GLK&SYSNDX'                                             00014002
.*                                                                      00017400
.*====================== GENERATE THE CODE ========================*    00017500
.*                                                                      00017600
         SLR   R0,R0                                                    00017705
         LR    R1,R0                                                    00017805
         ICM   R1,B'0011',=XL2'&PHSID'                                  00017905
         AIF   (&ISUBR EQ 1).GETCID                                     00018006
         AIF   (&IEXIT NE 1).NOCID                                      00018206
         AIF   ('&TEXIT' EQ 'RPL').GETCID                               00018306
         AIF   ('&TEXIT' EQ 'SYNAD').GETCID                             00019006
         AIF   ('&TEXIT' NE 'LERAD').NOCID                              00019106
.GETCID  ANOP                                                           00019206
         ICM   R1,B'1100',SS#PCIDS                                      00019306
.NOCID   ANOP                                                           00019406
&NOLOCK  EQU   *                                                        00020000
         SLR   R0,R0                                                    00020105
         CS    R0,R1,&LOCKADR                                           00020205
         BNZ   &NOLOCK                                                  00020400
         MEND                                                           00040000