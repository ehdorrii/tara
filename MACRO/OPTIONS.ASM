         MACRO                                                          00010000
&NAME    OPTIONS &MAP=,&PAD=,&BLKSIZE=,&ENTER=,&AUTH=                   00020012
.*----------------------------------------------------------------*     00020104
.*   THIS MACRO IS USED TO SET GLOBAL SET-SYMBOLS WHICH CONTROL   *     00020212
.*   CODE GENERATION IN OPEN CODE.                                *     00020304
.*----------------------------------------------------------------*     00020804
.*   SET-SYMBOLS REFERENCED IN OPEN CODE                          *     00020904
.*----------------------------------------------------------------*     00021004
         GBLA  &CBLKSZ                                                  00021106
         GBLB  &MAPLIST                                                 00021206
         GBLC  &IPAD,&IENTER,&IAUTH                                     00021312
.*----------------------------------------------------------------*     00021404
.*   PROCESS MAP= OPTION                                          *     00021505
.*----------------------------------------------------------------*     00021604
&MAPLIST SETB  1                                                        00021705
         AIF   (T'&MAP EQ 'O').SETMAP                                   00021805
         AIF   ('&MAP' EQ 'YES').MAPOK                                  00030005
         AIF   ('&MAP' EQ 'NO').SETMAP                                  00040005
         MNOTE 4,'MAP=&MAP INVALID - MUST BE ''YES'' OR ''NO''.'        00050005
         MNOTE *,'DSECT MAPS WILL NOT BE GENERATED.'                    00050105
.SETMAP  ANOP                                                           00050205
&MAPLIST SETB  0                                                        00051005
.MAPOK   ANOP                                                           00060005
.*----------------------------------------------------------------*     00060105
.*   PROCESS PAD= OPTION                                          *     00060205
.*----------------------------------------------------------------*     00060305
         AIF   (T'&PAD EQ 'O').SETPAD                                   00060405
&IPAD    SETC  '&PAD'                                                   00060505
         AIF   ('&PAD' EQ 'TRANSP').PADOK                               00060605
         AIF   ('&PAD' EQ 'INTEG').PADOK                                00060705
         MNOTE 4,'PAD=&PAD INVALID - MUST BE ''INTEG'' OR ''TRANSP''.'  00060805
         MNOTE *,'VALUE OF PAD IS SET TO ''TRANSP''.'                   00060905
.SETPAD  ANOP                                                           00061005
&IPAD    SETC  'TRANSP'                                                 00061105
.PADOK   ANOP                                                           00061205
.*----------------------------------------------------------------*     00061306
.*   PROCESS BLKSIZE= OPTION                                      *     00061406
.*----------------------------------------------------------------*     00061506
         AIF   (T'&BLKSIZE EQ 'O').SETBLK                               00061606
&CBLKSZ  SETA  &BLKSIZE                                                 00061706
&QUOTNT  SETA  &BLKSIZE/132                                             00061808
&PRODCT  SETA  &QUOTNT*132                                              00061908
         AIF   (&BLKSIZE EQ &PRODCT).BLKOK                              00062008
         MNOTE 4,'BLKSIZE=&BLKSIZE INVALID - MUST BE MULTIPLE OF 132.'  00062108
.SETBLK  ANOP                                                           00062207
&CBLKSZ  SETA  4092                                                     00062309
.BLKOK   ANOP                                                           00062406
.*----------------------------------------------------------------*     00062510
.*   PROCESS ENTER= OPTION                                        *     00062610
.*----------------------------------------------------------------*     00062710
         AIF   (T'&ENTER EQ 'O').SETENT                                 00062810
&IENTER  SETC  '&ENTER'                                                 00062910
         AIF   ('&ENTER' EQ 'ERROR').ENTOK                              00063011
         AIF   ('&ENTER' EQ 'COMMAND').ENTOK                            00063111
         MNOTE 4,'ENTER=&ENTER INVALID - MUST BE ''ERROR'' OR ''COMMAND+00063210
               ''.'                                                     00063310
         MNOTE *,'VALUE OF ENTER IS SET TO ''ERROR''.'                  00063410
.SETENT  ANOP                                                           00063510
&IENTER  SETC  'ERROR'                                                  00063610
.ENTOK   ANOP                                                           00063710
.*----------------------------------------------------------------*     00063812
.*   PROCESS AUTH= OPTION                                         *     00063912
.*----------------------------------------------------------------*     00064012
         AIF   (T'&AUTH EQ 'O').SETAUTH                                 00064112
&IAUTH   SETC  '&AUTH'                                                  00064212
         AIF   ('&AUTH' EQ 'NOPO').AUTHOK                               00064312
         AIF   ('&AUTH' EQ 'SPO').AUTHOK                                00064412
         MNOTE 4,'AUTH=&AUTH INVALID - MUST BE ''NOPO'' OR ''SPO''.'    00064512
         MNOTE *,'VALUE OF AUTH IS SET TO ''NOPO''.'                    00064712
.SETAUTH ANOP                                                           00064812
&IAUTH   SETC  'NOPO'                                                   00064912
.AUTHOK  ANOP                                                           00065012
.*----------------------------------------------------------------*     00065104
.*   END OF OPTIONS                                               *     00065204
.*----------------------------------------------------------------*     00066004
         MEND                                                           00070000