         MACRO                                                          00010000
         RLSLOCK &LOCKADR                                               00010100
.*-----------------------------------------------------------------*    00010500
.*                                                                 *    00010600
.*  THIS MACRO WILL RELEASE A SPIN-LOOP LOCK AT THE LOCATION       *    00010705
.*  SPECIFIED ON THE MACRO INVOCATION.                             *    00010805
.*                                                                 *    00010900
.*-----------------------------------------------------------------*    00011000
         XC    &LOCKADR.(4),&LOCKADR                                    00020404
         MEND                                                           00040000