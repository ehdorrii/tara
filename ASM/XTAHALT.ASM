XTAHALT  HOSTTAB NUMSVC=16                                              00010001
*                                                                       00020000
* HOST: COMPUSERVE                                                      00030008
*                                                                       00050008
         HOST    LUPREFIX=TSCPS,ALIAS=(COMPUSERVE,CPS),NUMCALLS=4       00060006
*                                                                       00070008
* HOST: MIND                                                            00080008
*                                                                       00100008
         HOST    LUPREFIX=TSBBN,ALIAS=(MIND,BBN),NUMCALLS=2             00110006
*                                                                       00120008
* HOST: TELEMAIL                                                        00130008
*                                                                       00150008
         HOST    LUPREFIX=TSTLM,ALIAS=(TELEMAIL),NUMCALLS=2             00160006
*                                                                       00170008
* HOST: THE SOURCE                                                      00180008
*                                                                       00200008
         HOST    LUPREFIX=TSSRC,ALIAS=(SOURCE),NUMCALLS=4               00210006
*                                                                       00220008
* HOST: DOW JONES NEWS RETRIEVAL SERVICE                                00230008
*                                                                       00250008
         HOST    LUPREFIX=TSDJN,NUMCALLS=2,                            X00260006
               ALIAS=(DOWJONES,DJNRS,DJN,DJ)                            00270006
*                                                                       00280008
* HOST: TELENET INTERNAL EMAIL SYSTEM                                   00290008
*                                                                       00310008
         HOST    LUPREFIX=TSTNT,ALIAS=(TNET),NUMCALLS=1                 00320006
*                                                                       00330009
* HOST: FDP                                                             00340009
*                                                                       00360009
         HOST    LUPREFIX=TSFDP,ALIAS=(FDP),NUMCALLS=2                  00370006
*                                                                       00380009
* HOST: USA TODAY                                                       00390009
*                                                                       00410009
         HOST    LUPREFIX=TSUST,ALIAS=(USATODAY,USAT),NUMCALLS=2        00420006
*                                                                       00680000
         HOSTEND                                                        00690000
         END                                                            00700000
