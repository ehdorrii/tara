XTASNRX  TITLE 'TARA SEND RPL EXIT (11.0)'                              00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTASNRX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTASNRX IS THE RPL EXIT SPECIFIED      * 00060006
*       WHEN DATA IS SENT USING THE PRIMARY OR THE SECONDARY RPLS.    * 00070006
*       (THE RPL EXIT USED WHEN DATA IS SENT VIA THE ECHO RPL IS      * 00080006
*       XTAEKOX.)  WHEN A SEND IS COMPLETED THIS MODULE IS            * 00090006
*       DISPATCHED AND IT THEN ISSUES A RECEIVE TO THE OPPOSITE       * 00100006
*       SESSION PARTNER USING THE SAME RPL.                           * 00110006
*                                                                     * 00160000
*     DRIVER - THE COMPLETION OF A SEND ON THE PRIMARY OR SECONDARY   * 00170006
*       RPL.                                                          * 00180006
*                                                                     * 00200000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTASNRX.              * 00201006
*                                                                     * 00202006
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00203006
*       OF THE EPILOGUE MACRO.                                        * 00204006
*                                                                     * 00205006
*     REGISTERS ON ENTRY -                                            * 00206006
*       BEFORE PROLOGUE:                                              * 00207006
*         R0:  UNPREDICTABLE.                                         * 00208006
*         R1:  ADDRESS OF THE PRIMARY OR SECONDARY RPL.               * 00209006
*         R2-R13: UNPREDICTABLE.                                      * 00209106
*         R14: RETURN ADDRESS.                                        * 00209206
*         R15: ENTRY ADDRESS.                                         * 00209306
*       AFTER PROLOGUE:                                               * 00209406
*         R0:  UNPREDICTABLE.                                         * 00209506
*         R1:  ADDRESS OF GETMAINED SAVEAREA.                         * 00209606
*         R2-R8: UNPREDICTABLE.                                       * 00209706
*         R9:  ADDRESS OF THE RPL.                                    * 00209806
*         R10: POINTER TO COMMON STORAGE AREA.                        * 00209906
*         R11: POINTER TO SESSION STORAGE AREA.                       * 00210006
*         R12: ENTRY ADDRESS.                                         * 00210106
*         R13: ADDRESS OF GETMAINED SAVEAREA.                         * 00210206
*         R14: RETURN ADDRESS                                         * 00210306
*         R15: RETURN CODE FROM GETMAIN                               * 00210406
*                                                                     * 00210506
*     MACROS USED:                                                    * 00210606
*       IBM MACROS:                                                   * 00210706
*         GETMAIN, FREEMAIN, CHECK, SEND, RECEIVE, IFGRPL.            * 00210806
*       NON-IBM MACROS:                                               * 00210906
*         PROLOGUE, EPILOGUE, PHASE.                                  * 00211006
*                                                                     * 00211106
*     COPY MEMBERS:                                                   * 00211206
*       XTACMAP.                                                      * 00211306
*                                                                     * 00211406
*                                                                     * 00211506
*     INPUT:                                                          * 00211606
*       THE RPL USED FOR THE SEND.                                    * 00211706
*                                                                     * 00211806
*     OUTPUT:                                                         * 00211906
*       NONE.                                                         * 00212006
*                                                                     * 00212106
*     ABENDS:                                                         * 00212206
*       NONE                                                          * 00212306
*                                                                     * 00212406
*     MESSAGES ISSUED:                                                * 00212506
*       NONE.                                                         * 00212606
*                                                                     * 00212706
*     RETURN CODES:                                                   * 00212806
*       ALWAYS ZERO.                                                  * 00212906
*                                                                     * 00213006
*                                                                     * 00213106
*                             +-------+                               * 00214006
*     +------+                |PRIMARY|                +-------+      * 00220006
*     |      |----RECEIVE---->|  RPL  |------SEND----->|       |      * 00230006
*     |      |                +-------+                |       |      * 00240006
*     | 3270 |                                         |TELENET|      * 00250006
*     |      |               +---------+               |       |      * 00260006
*     |      |<-----SEND-----|SECONDARY|<---RECEIVE----|       |      * 00270006
*     +------+               |   RPL   |               +-------+      * 00280006
*                            +---------+                              * 00290006
*                                                                     * 00300000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00330000
         SPACE 1                                                        00340000
XTASNRX  PROLOGUE EXIT=RPL                                              00350000
         EJECT                                                          00360000
**                                                                      00370000
*                                                                       00380000
    PHASE  11.1 - CHECK THE RPL                                         00390000
*                                                                       00400000
**                                                                      00410000
         L     R6,RPLAREA          SAVE RPL AREA ADDRESS.               00420000
         CHECK RPL=(R9)            CHECK THE SEND RPL.                  00430000
         LTR   R15,R15             WAS THERE AN ERROR?                  00440000
         BZ    PH11#2              NO, CONTINUE.                        00450000
         CLC   =X'0C0B',RPLRTNCD   HAS THE LU BEEN LOST?                00460000
         BE    PH11#4              YES, DEQ THE BUFFER.                 00470000
         CLC   =X'0C0C',RPLRTNCD   SESSIONC CLEAR WAS SENT.             00471007
         BE    PH11#99                                                  00472007
         CLC   =X'081B',RPLSSNSI   FOR 'RECEIVER IN TRANSMIT MODE',     00480000
         BE    PH11#99               HOLD IT 'TIL USER SENDS HIS DATA.  00490000
         CLC   =X'0813',RPLSSNSI   IF THE NEGATIVE RESPONSE INDICATES   00500000
         BE    RESEND                A BRACKET ERROR, THEN TRY          00510000
         CLC   =X'2003',RPLSSNSI     RESENDING WITH INVERTED BBI.       00520000
         BE    RESEND                                                   00530000
         LA    R9,0(R9)            CLEAR THE HI BYTE                    00540000
         L     R2,SS#APRPL         GET ADDRESS OF PRIMARY RPL           00550000
         LA    R2,0(R2)            CLEAR THE HI BYTE                    00560000
         CR    R9,R2               IS THIS THE PRIMARY RPL?             00570000
         BNE   NOTPRI              NO, CAN'T RESET                      00580000
         L     R15,CS#ARCVY        GET ADDRESS OF RECOVERY ROUTINE.     00590000
         BALR  R14,R15             GO RESET I/O ON PRIMARY SESSION.     00600000
         B     PH11#2              RESUME PROCESSING.                   00610000
         SPACE 1                                                        00620000
NOTPRI   EQU   *                                                        00630000
         L     R15,CS#ACLNP        GET ADDRESS OF CLEANUP ROUTINE.      00640005
         BALR  R14,R15             INITIATE DELETION OF THIS SESSION.   00650000
         B     PH11#99             EXIT.                                00660000
         SPACE 2                                                        00670000
RESEND   EQU   *                                                        00680000
         XI    RPLRH3,RPLBB        FLIP BBI.                            00690000
         SEND  RPL=(R9),RESPOND=(NEX,FME,NRRN)                          00700000
         B     PH11#99                                                  00710000
         EJECT                                                          00720000
**                                                                      00730000
*                                                                       00740000
    PHASE  11.2 - IF PRIMARY RPL, ISSUE RECEIVE ON PRIMARY              00750000
*                                                                       00760000
**                                                                      00770000
         LA    R9,0(R9)            CLEAR THE HI BYTE                    00780000
         L     R2,SS#APRPL         GET ADDRESS OF PRIMARY RPL           00790000
         LA    R2,0(R2)            CLEAR THE HI BYTE                    00800000
         CR    R9,R2               IS THIS THE PRIMARY RPL?             00810000
         BNE   PH11#3              NO, TRY SECONDARY                    00820000
         SPACE                                                          00830000
         L     R2,SS#PCID          LOAD CID OF PRIMARY SESSION          00840000
         L     R3,CS#APRRX         LOAD ADDR OF PRIMARY RECEIVE EXIT    00850000
         LA    R4,SS#PIBUF         LOAD ADDR OF PRIMARY I/O BUFFER      00860000
         SPACE                                                          00870000
         RECEIVE RPL=(R9),         ISSUE THE RECEIVE                   X00880000
               ARG=(R2),                                               X00890000
               EXIT=(R3),                                              X00900000
               AREA=(R4),                                              X00910000
               AREALEN=160                                              00920000
         SPACE                                                          00930000
         B     PH11#99             GO TO EXIT                           00940000
         EJECT                                                          00950000
**                                                                      00960000
*                                                                       00970000
    PHASE  11.3 - DEQUEUE THE BUFFER FOR THE COMPLETED SEND TO PRIMARY  00980000
*                                                                       00990000
**                                                                      01000000
         CLC   SS#SCID,RPLSAF      BUT FIRST, IF THE SEND WAS TO THE    01001003
         BE    PH11#4                SECONDARY, JUST DO THE RECEIVE.    01002003
         SPACE 1                                                        01003003
         NI    SS#FLAG2,X'FF'-SS#INBKT    WE ARE NOW BETB.              01010002
         S     R6,=F'8'            BACK UP TO START OF SEND BUFFER.     01020000
         NI    0(R6),X'FF'-SS#SBIU   TURN OFF IN-USE INDICATOR.         01030003
         TM    0(R6),SS#PACNG      CHECK FOR PACING BIT...IF IT'S ON,   01040000
         BZ    NOPACE                WE WILL INDICATE THAT DATA MUST    01050000
         OI    SS#FLAG2,SS#HOLDD     BE HELD UNTIL FURTHER NOTICE.      01060002
         SPACE 1                                                        01070000
NOPACE   EQU   *                                                        01080000
         ICM   R5,15,4(R6)         GET PNTR TO NEXT WAITER (OR 0).      01090000
         ST    R5,SS#SBFST         UPDATE SB QUEUE ANCHOR.              01100000
         BNZ   NOTQLAST            AND IF THIS SB WAS LAST ON QUEUE,    01110000
         ST    R5,SS#SBLST           UPDATE LAST POINTER, TOO.          01120000
         B     PH11#4              SKIP THE SEND, NOTHING TO SEND.      01130000
         SPACE                                                          01140000
NOTQLAST EQU   *                                                        01150000
         TM    0(R5),SS#DATA       SEARCH THE QUEUE FOR DATA MESSAGES;  01160000
         BO    SEND                  IF ANY DATA MESSAGES REMAIN IN THE 01170000
         ICM   R5,15,4(R5)           QUEUE, WE WILL DEFER TURNING THIS  01180000
         BZ    PH11#4                RPL AROUND UNTIL THEY ARE ALL      01190000
         B     NOTQLAST              SENT.                              01200000
         SPACE 1                                                        01210000
SEND     EQU   *                                                        01220000
         SLR   R1,R1               CALL PSM TO DISPATCH THE NEXT        01230000
         L     R15,CS#APSMR          WAITER; THEN, SINCE WE KNOW WE'VE  01240000
         BALR  R14,R15               NOT YET SENT ALL THE DATA, SKIP    01250000
         B     PH11#99               THE RECEIVE(SECONDARY).            01260000
         EJECT                                                          01270000
**                                                                      01280000
*                                                                       01290000
    PHASE  11.4 - ISSUE A RECEIVE TO THE SECONDARY                      01300000
*                                                                       01310000
**                                                                      01320000
         L     R2,SS#ASRPL         GET ADDRESS OF SECONDARY RPL         01330000
         LA    R2,0(R2)            CLEAR THE HI BYTE                    01340000
         CR    R9,R2               IS THIS THE SECONDARY RPL?           01350000
         BNE   PH11#5              NO, ERROR - GO CLEAN UP              01360001
         SPACE                                                          01370000
         TM    SS#FLAG1,SS#SACT    IF THERE IS NO SEC'Y SESSION,        01380002
         BZ    PH11#99               THEN DON'T ISSUE A RECEIVE         01390000
         SPACE                                                          01400000
         L     R2,SS#SCID          LOAD CID OF SECONDARY SESSION        01410000
         L     R3,CS#ASRRX         LOAD ADDR OF SECONDARY RECEIVE EXIT  01420000
         LA    R4,SS#SIBUF         LOAD ADDR OF SECONDARY I/O BUFFER    01430000
         RECEIVE RPL=(R9),         ISSUE THE RECEIVE                   X01440000
               ARG=(R2),                                               X01450000
               EXIT=(R3),                                              X01460000
               AREA=(R4),                                              X01470000
               AREALEN=160                                              01480000
         B     PH11#99             EXIT.                                01490000
         EJECT                                                          01500000
**                                                                      01510000
*                                                                       01520000
    PHASE  11.5 - INVOKE CLEANUP FOR THIS SESSION                       01530000
*                                                                       01540000
**                                                                      01550000
         L     R15,CS#ACLNP        LOAD ADDRESS OF CLEANUP ROUTINE.     01560000
         BALR  R14,R15             GO CLEAR THE SESSION.                01570000
         EJECT                                                          01580000
**                                                                      01590000
*                                                                       01600000
    PHASE  11.99 - EXIT                                                 01610000
*                                                                       01620000
**                                                                      01630000
         SR    R15,R15             ZERO RETURN CODE                     01640000
         EPILOGUE                  RETURN                               01650000
*********************************************************************** 01660000
*********************************************************************** 01670000
********                                                       ******** 01680000
********               END OF EXECUTABLE CODE                  ******** 01690000
********                                                       ******** 01700000
*********************************************************************** 01710000
*********************************************************************** 01720000
         END   XTASNRX                                                  01730000