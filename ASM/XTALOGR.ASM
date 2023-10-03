XTALOGR  TITLE 'TARA LOGGER SUBROUTINE (14.0)'                          00010000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00020000
*                                                                     * 00030000
*     MODULE NAME - XTALOGR                                           * 00040000
*                                                                     * 00050000
*     FUNCTIONAL DESCRIPTION - XTALOGR IS THE TARA LOG WRITER         * 00060000
*       ROUTINE, USED TO RECORD SIGNIFICANT APPLICATION EVENTS.       * 00070000
*                                                                     * 00071008
*     DRIVER - THIS ROUTINE IS ENTERED VIA BAL(R) USING R14 AS THE    * 00072008
*       LINK REGISTER.                                                * 00073008
*                                                                     * 00074008
*     ENTRY - ONLY ONE ENTRY POINT IS PROVIDED, XTALOGR.              * 00075008
*                                                                     * 00076008
*     EXIT - ALL PATHS EXIT THROUGH THE LAST PHASE, WHICH CONSISTS    * 00077008
*       OF THE EPILOGUE MACRO.                                        * 00078008
*                                                                     * 00079008
*     REGISTERS ON ENTRY -                                            * 00079108
*       BEFORE PROLOGUE:                                              * 00079208
*         R0:  UNPREDICTABLE.                                         * 00079308
*         R1:  ADDRESS OF THE RECORD TO BE WRITTEN TO THE LOG.        * 00079408
*         R2-R13:  UNPREDICTABLE                                      * 00079508
*         R14: RETURN ADDRESS                                         * 00079608
*         R15: ENTRY ADDRESS                                          * 00079708
*       AFTER PROLOGUE:                                               * 00079808
*         R0:  UNPREDICTABLE                                          * 00079908
*         R1:  ADDRESS OF GETMAINED SAVEAREA                          * 00080008
*         R2-R6: UNPREDICTABLE                                        * 00080108
*         R7:  ADDRESS OF THE RECORD TO BE WRITTEN TO THE LOG.        * 00080208
*         R8-R9: UNPREDICTABLE.                                       * 00080308
*         R10: POINTER TO COMMON STORAGE AREA                         * 00080508
*         R11: POINTER TO SESSION STORAGE AREA.                       * 00080608
*         R12: ENTRY ADDRESS                                          * 00080708
*         R13: ADDRESS OF GETMAINED SAVEAREA                          * 00080808
*         R14: RETURN ADDRESS                                         * 00080908
*         R15: RETURN CODE FROM GETMAIN.                              * 00081008
*                                                                     * 00081108
*     MACROS USED -                                                   * 00081208
*       IBM MACROS:                                                   * 00081308
*         GETMAIN, FREEMAIN, TIME, PUT.                               * 00081408
*       NON-IBM MACROS:                                               * 00081508
*         EPILOGUE, PHASE, PROLOGUE                                   * 00081608
*                                                                     * 00081708
*     COPY MEMBERS -                                                  * 00081808
*       XTACMAP                                                       * 00081908
*                                                                     * 00082000
*     INPUT -                                                         * 00090008
*       THE RECORD TO BE WRITTEN TO THE LOG, IN THIS FORMAT:          * 00100008
*                                                                     * 00110000
*       +--------+--------+---------//-----------+                    * 00120008
*       |  TYPE  | LENGTH |        DATA          |                    * 00120108
*       +--------+--------+---------//-----------+                    * 00121008
*                                                                     * 00122008
*       THE TYPE BYTE IS DOCUMENTED IN XTASMAP.                       * 00123008
*       THE LENGTH BYTE INDICATES THE LENGTH OF THE DATA FIELD.       * 00130008
*                                                                     * 00260000
*     OUTPUT:                                                         * 00273008
*       THE LOG RECORD IS WRITTEN TO THE LOG DATASET.                 * 00273108
*                                                                     * 00273308
*     ABENDS:                                                         * 00273408
*       NONE.                                                         * 00273508
*                                                                     * 00273608
*     MESSAGES ISSUED:                                                * 00273708
*       NO SYSTEM MESSAGES ARE ISSUED BY THIS MODULE.                 * 00273808
*                                                                     * 00273908
*     RETURN CODES:                                                   * 00274008
*       THE RETURN CODE IS ALWAYS ZERO.                               * 00274108
*                                                                     * 00274208
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00275000
XTALOGR  PROLOGUE SUBR=LOGGER                                           00280000
         EJECT                                                          00290000
**                                                                      00300000
*                                                                       00310000
    PHASE  14.1 - IDENTIFY SOURCE AND TIME-STAMP LOG RECORD             00320006
*                                                                       00330000
**                                                                      00340000
         LA    R2,LOGRECD          ZERO OUT THE LOGGER WORKAREA BEFORE  00351001
         LA    R3,L'LOGRECD          USING ANY OF IT.                   00352001
         SLR   R4,R4                                                    00353001
         SLR   R5,R5                                                    00354001
         MVCL  R2,R4                                                    00355001
         SPACE 1                                                        00355106
         MVC   RID_TYPE,0(R7)      SHOW RECORD TYPE.                    00355206
         MVC   RID_PHAS,CS#NOW-2   GET PREVIOUS (CALLER'S) PHASE.       00356007
         TIME  DEC,ZONE=LT         GET DATE AND TIME (IN PACKED FORMAT) 00357006
         ST    R0,TS_CLOCK           IN R1 AND R0, RESPECTIVELY, AND    00358006
         ST    R1,TS_DATE            TIME-STAMP THE LOG RECORD.         00359006
         IC    R4,1(R7)            GET THE MESSAGE LENGTH AND MOVE THE  00390001
         BCTR  R4,0                  MESSAGE INTO THE LOGGER WORKAREA.  00400001
         EX    R4,MVC@LOGR         -- MVC LOGDATA(0),2(R7) --           00410001
         EJECT                                                          00510206
* %%                                                                    00510309
* %% NOTES ON FUTURE FUNCTION--                                         00510409
* %%    FOR THE !!MONITOR. FUNCTION, AT THIS POINT (NOW THAT WE HAVE    00510509
* %%    A TIMESTAMP)  WE WOULD FORMAT "UNFORMATTED" MESSAGES INTO       00510609
* %%    INTO A PSMR REQUEST WITH AN EBCDIC TIMESTAMP IN FRONT, AND      00510709
* %%    GET THE MONITOR SESSION'S SDB ADDRESS FROM COMMON STORAGE,      00510809
* %%    THEN CALL PSMR TO SEND THIS MONITOR RECORD...AND CONTINUE:      00510909
* %%                                                                    00511009
**                                                                      00511106
*                                                                       00511206
    PHASE  14.2 - WRITE RECORD TO LOG DATASET                           00511306
*                                                                       00511406
**                                                                      00511506
         IC    R4,1(R7)            GET THE MESSAGE LENGTH, THEN UPDATE  00511606
         LA    R4,L'PREFIX(R4)       LENGTH TO INCLUDE ADDITIONAL       00511706
         STH   R4,RDW_LL             FIELDS AND STORE AS RDW.           00512006
         PUT   CS#LOG,LOGRECD      WRITE RECORD TO LOG DATASET          00520000
         EJECT                                                          00530000
**                                                                      00540000
*                                                                       00550000
    PHASE  14.99 - EXIT                                                 00560000
*                                                                       00570000
**                                                                      00580000
         SR    R15,R15             ZERO RETURN CODE                     00590000
         EPILOGUE                  RETURN                               00600000
*********************************************************************** 00610000
*********************************************************************** 00620000
********                                                       ******** 00630000
********               END OF EXECUTABLE CODE                  ******** 00640000
********                                                       ******** 00650000
*********************************************************************** 00660000
*********************************************************************** 00670000
         EJECT                                                          00680000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00690000
*                                                                     * 00700000
*        LOGGER WORK AREAS                                            * 00710000
*                                                                     * 00720000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* 00730000
         SPACE 1                                                        00731004
MVC@LOGR MVC   LOGDATA(0),2(R7)    EXECUTED MOVE FROM CALLER TO LOGRECD 00732004
         SPACE 1                                                        00740001
         DS    0D                                                       00750006
LOGRECD  DS    0CL512              RDW + TIMESTAMP + DATA               00760004
PREFIX   DS    0XL16                 LOG RECORD PREFIX                  00761006
RDW      DS    0XL4                    RECORD DESCRIPTOR WORD           00770006
RDW_LL   DS    H                         RECORD LENGTH                  00771006
RDW_RSVD DS    H                         RESERVED                       00772006
RID      DS    0XL4                    RECORD IDENTIFICATION            00773006
RID_TYPE DS    XL1                       RECORD TYPE                    00774006
RID_RSVD DS    XL1                       RESERVED                       00774106
RID_PHAS DS    H                         CALLER'S PHASE ID              00775006
TS       DS    0XL8                    TIMESTAMP                        00776006
TS_CLOCK DS    F                         LOCAL TIME-OF-DAY (HHMMSSTH)   00781006
TS_DATE  DS    F                         JULIAN DATE       (00YYDDDF)   00782006
LOGDATA  DS    CL(512-(*-LOGRECD))   DATA AS PASSED FROM CALLER         00800006
         SPACE 1                                                        00830001
         END   XTALOGR                                                  00840000