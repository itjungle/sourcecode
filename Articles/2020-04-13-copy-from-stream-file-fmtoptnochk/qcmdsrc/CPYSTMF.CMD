CPYSTMF:    CMD        PROMPT('Copy IFS to Db2')
             PARM       KWD(FROMSTMF) TYPE(*PNAME) LEN(650) MIN(1) +
                          EXPR(*YES) CASE(*MIXED) PROMPT('IFS file +
                          to copy')
             PARM       KWD(FILE) TYPE(QUAL) SNGVAL((*STMF)) MIN(1) +
                          PROMPT('File to receive data')
 QUAL:       QUAL       TYPE(*NAME) LEN(10) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB)) EXPR(*YES) +
                          PROMPT('Library')
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          EXPR(*YES) PROMPT('Member name')
             PARM       KWD(RCDLEN) TYPE(*INT2) DFT(*FILE) REL(*GT +
                          0) SPCVAL((*FILE 0)) PROMPT('Maximum +
                          record length to write')
             PARM       KWD(DB2FILE) TYPE(*PNAME) LEN(650) +
                          DFT(*FILE) SPCVAL((*FILE)) EXPR(*YES) +
                          CASE(*MIXED) PROMPT('Db2 file to receive +
                          data')
             DEP        CTL(&FILE *EQ *STMF) PARM((&DB2FILE *NE *FILE))    
