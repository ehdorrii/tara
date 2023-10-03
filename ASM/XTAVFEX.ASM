XTAVFEX  TITLE 'TARA RPL EXIT FRONT-END (28.0)'                         00010000
*********************************************************************** 00020000
*                                                                     * 00030000
*     MODULE NAME - XTAVFEX                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTAVFEX FRONT-ENDS RPL EXITS DRIVEN    * 00060000
*       BY REQUESTS USING THE PRIMARY RPL, WHENEVER EMISSION IS       * 00070000
*       ACTIVE.  ITS PURPOSE IS TO PUT THE ADDRESS OF THE             * 00071000
*       PSEUDO-ACB INTO THE RPL SO THAT FUTURE REQUESTS BASED ON      * 00072000
*       THIS RPL WILL BE TRAPPED BY XTAPAMR.                          * 00073000
*                                                                     * 00074000
*     DRIVER - THIS ROUTINE GETS CONTROL FROM VTAM WHEN ANY           * 00080000
*       RPL-BASED REQUEST USING A CONVERTED RPL COMPLETES.            * 00100000
*                                                                     * 00104000
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTAVFEX.              * 00110000
*                                                                     * 00120000
*     EXIT - ON EXIT, ALL REGISTERS ARE UNAFFECTED EXCEPT R15,        * 00130000
*       WHICH WILL CONTAIN THE ENTRY POINT ADDRESS OF THE EXIT        * 00140000
*       ROUTINE ORIGINALLY SPECIFIED IN THE REQUEST.                  * 00150000
*                                                                     * 00151000
*     REGISTERS ON ENTRY -                                            * 00160000
*       R0:  UNPREDICTABLE.                                           * 00180000
*       R1:  ADDRESS OF RPL.                                          * 00181000
*       R2-13: UNPREDICTABLE.                                         * 00182000
*       R14:  RETURN ADDRESS.                                         * 00183000
*       R15:  ENTRY POINT.                                            * 00184000
*                                                                     * 00340000
*     MACROS USED -                                                   * 00350000
*       IBM MACROS:                                                   * 00360000
*         NONE.                                                       * 00370000
*       NON-IBM MACROS:                                               * 00380000
*         NONE.                                                       * 00390000
*                                                                     * 00400000
*     COPY MEMBERS:                                                   * 00410000
*       XTACMAP                                                       * 00420000
*                                                                     * 00430000
*     INPUT:                                                          * 00440000
*       THE RPL.                                                      * 00470000
*                                                                     * 00471000
*     OUTPUT:                                                         * 00480000
*       THE RPL, CONVERTED.                                           * 00490000
*                                                                     * 00500000
*     ABENDS:                                                         * 00510000
*       NONE.                                                         * 00520000
*                                                                     * 00530000
*     MESSAGES ISSUED:                                                * 00540000
*       NO SYSTEM MESSAGES ARE ISSUED BY THIS MODULE.                 * 00550000
*                                                                     * 00560000
*     RETURN CODES:                                                   * 00570000
*       SINCE THIS IS A FRONT-END, THERE IS NO VALUE WHICH WOULD      * 00580000
*       BE CONSIDERED A RETURN CODE.                                  * 00590000
*                                                                     * 00590100
*********************************************************************** 00594000
         SPACE 1                                                        00595000
XTAVFEX  CSECT                                                          00596000
         USING XTAVFEX,R15         GET ADDRESSABILITY FOR THE LITERAL   00597000
         USING IFGRPL,R1             POOL AND THE RPL.                  00597100
         L     R15,=V(CS#IOACB)    LOAD THE ADDRESS OF THE PAMR ACB     00598000
         DROP  R15                   AND STORE IT INTO THE RPL.         00599000
         ST    R15,24(R1)                                               00599100
         L     R15,RPLUSFLD        GET ADDRESSABILITY TO SESSION        00600000
         USING XTASMAP,R15           STORAGE (WHICH IS WHERE THE        00601000
         L     R15,SS#AMLEX          ADDRESS OF THE 'REAL' EXIT ROUTINE 00602001
         DROP  R15                   IS STORED) AND BRANCH TO THE       00603000
         BR    R15                   ORIGINALLY-SPECIFIED EXIT.         00610000
         SPACE 1                                                        00620000
*********************************************************************** 02790000
*********************************************************************** 02800000
********                                                       ******** 02810000
********               END OF EXECUTABLE CODE                  ******** 02820000
********                                                       ******** 02830000
*********************************************************************** 02840000
*********************************************************************** 02850000
         EJECT                                                          02850100
         LTORG                                                          02850200
         EJECT                                                          02850300
         COPY  XTASMAP                                                  02850400
         EJECT                                                          02850500
         IFGRPL AM=VTAM                                                 02850600
         END   XTAVFEX                                                  02851000