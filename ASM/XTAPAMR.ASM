XTAPAMR  TITLE 'TARA PSEUDO-ACCESS-METHOD ROUTINES (33.0)'              00010000
*********************************************************************** 00020000
*                                                                     * 00020100
*     MODULE NAME - XTAPAMR                                           * 00020200
*                                                                     * 00020300
*     FUNCTIONAL DESCRIPTION - XTAPAMR IS THE PSEUDO ACCESS METHOD    * 00020400
*       ROUTINE WHICH STARTS UP THE EMIT I/O TASK WHENEVER A          * 00020500
*       RECEIVE IS ISSUED TO THE PRIMARY (AND EMISSION IS ACTIVE).    * 00020600
*                                                                     * 00020900
*     DRIVER - INVOKED BY RPL-BASED REQUESTS USING THE PRIMARY RPL    * 00021000
*       WHEN IT HAS BEEN CONVERTED.                                   * 00021100
*                                                                     * 00021200
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAPAMR.              * 00021300
*                                                                     * 00021400
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00021500
*       OF THE EPILOGUE MACRO.                                        * 00021600
*                                                                     * 00021700
*     REGISTERS ON ENTRY -                                            * 00021800
*       BEFORE PROLOGUE:                                              * 00021900
*         R0:  UNPREDICTABLE.                                         * 00022000
*         R1:  POINTER TO RPL.                                        * 00022100
*         R2-12: UNPREDICTABLE.                                       * 00022200
*         R13: POINTER TO CALLER'S REGISTER SAVEAREA.                 * 00023300
*         R14: RETURN ADDRESS.                                        * 00023400
*         R15: ENTRY POINT ADDRESS.                                   * 00023500
*       AFTER PROLOGUE:                                               * 00023600
*                                                                     * 00025300
*     MACROS USED -                                                   * 00025400
*       IBM MACROS:                                                   * 00025500
*         FREEMAIN, GETMAIN, EXECRPL                                  * 00025600
*       NON-IBM MACROS:                                               * 00025700
*         EPILOGUE, PHASE, PROLOGUE                                   * 00025800
*                                                                     * 00025900
*     COPY MEMBERS:                                                   * 00026000
*       XTACMAP                                                       * 00026100
*                                                                     * 00026200
*     INPUT:                                                          * 00026300
*       THE RPL USED FOR THE REQUEST.                                 * 00026400
*                                                                     * 00026500
*     OUTPUT:                                                         * 00026600
*       NONE.                                                         * 00026700
*                                                                     * 00026800
*     ABENDS:                                                         * 00026900
*       NONE.                                                         * 00027000
*                                                                     * 00027100
*     MESSAGES ISSUED:                                                * 00027200
*       NO SYSTEM MESSAGES ARE ISSUED BY THIS MODULE.                 * 00027300
*                                                                     * 00027400
*     RETURN CODES:                                                   * 00027500
*       THE RETURN CODE IS DETERMINED BY THE EXECUTION OF EXECRPL     * 00027600
*       IF ISSUED; OTHERWISE IT IS ZERO.                              * 00027700
*                                                                     * 00027900
*********************************************************************** 00029000
XTAPAMR  PROLOGUE SUBR=PSEUDOAM                                         00030000
**                                                                      00040000
*                                                                       00050000
    PHASE  33.1 - DECIDE HOW TO PROCESS                                 00060000
*                                                                       00070000
**                                                                      00080000
         SPACE 1                                                        00090000
         CLC   SS#PCID,RPLARG      EXECRPL WILL BE USED IN ALL CASES    00100000
         BNE   PH33#2                EXCEPT:                            00110000
         CLI   RPLREQ,RPLRCV         1.) RECEIVE TO PRIMARY;            00120000
         BE    PH33#3                2.) CHECK OF RECEIVE TO PRIMARY.   00130000
         CLI   RPLREQ,RPLCHECK                                          00140000
         BNE   PRIREQ                                                   00150000
         CLI   SS#LSTRQ,RPLRCV                                          00160000
         BE    PH33#3                                                   00170000
         SPACE 1                                                        00180000
PRIREQ   EQU   *                   WE KEEP TRACK OF THE LAST REQUEST    00190000
         MVC   SS#LSTRQ,RPLREQ       ON PRIMARY SO WE CAN TRAP CHECK.   00200000
         EJECT                                                          00210000
**                                                                      00220000
*                                                                       00230000
    PHASE  33.2 - ISSUE EXECRPL                                         00240000
*                                                                       00250000
**                                                                      00260000
         SPACE 1                                                        00270000
         L     R1,RPLECB           WE REPLACE THE SPECIFIED EXIT WITH   00280000
         ST    R1,SS#AMLEX           A FRONT-END WHICH RESTORES THE     00290000
         L     R1,CS#AVFEX           ADDRESS OF THE PSEUDO-ACB TO THE   00300000
         ST    R1,RPLECB             RPL WHEN THE REQUEST COMPLETES,    00310000
         LA    R1,CS#ACB             THEN BRANCHES TO SPECIFIED EXIT.   00320000
         EXECRPL RPL=(R9),ACB=(R1)                                      00330000
         B     PH33#99                                                  00340000
         EJECT                                                          00350000
**                                                                      00360000
*                                                                       00370000
    PHASE  33.3 - ATTACH EMIT I/O TASK                                  00380000
*                                                                       00390000
**                                                                      00400000
         SPACE 1                                                        00410000
         MVC   SS#LSTRQ,RPLREQ     REMEMBER LAST REQ TO TRAP CHECK.     00420000
         GETMAIN RC,LV=8           GET STORAGE FOR PARM LIST.           00430000
         STM   R10,R11,0(R1)       GIVE NEW TASK ADDRESSES OF COMMON    00440000
         L     R8,CS#AEIOX           AND SESSION STORAGE.               00450000
         ATTACH AP=XTAEIOT,ETXR=(R8)                                    00460000
         SLR   R15,R15             SIMULATE VTAM RC=0.                  00461000
         EJECT                                                          00470000
**                                                                      00480000
*                                                                       00490000
    PHASE  33.99 - EXIT                                                 00500000
*                                                                       00510000
**                                                                      00520000
         SPACE 1                                                        00530000
         EPILOGUE                                                       00550000
         END   XTAPAMR                                                  00560000