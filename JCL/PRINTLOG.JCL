//PRINTLOG JOB (**accounting info**)
//*
//STEPS    EXEC PGM=XTAPLOG
//STEPLIB   DD  DSN=SYSPROG.TARA.LOAD,DISP=SHR
//SYSPRINT  DD  SYSOUT=A
//XTALOGDS  DD  DSN=SYSPROG.TARA.LOG,DISP=SHR
//