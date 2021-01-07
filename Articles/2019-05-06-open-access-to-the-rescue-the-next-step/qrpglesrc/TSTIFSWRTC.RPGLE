       // This program calls the TSTIFSWRT3 test program passing it the
       //     file name and code page to be used for the IFS file

       // Include user parameter template

      /Copy OASampSrc,IFSUSRPARM

       // Prototype for TSTIFSWRT3
       Dcl-Pr  TSTIFSWRT3  ExtPgm;
         fileDetails  LikeDS(userParms_T);
       End-Pr;

       // User parameters for IFS output file
       //   Inz(*LikeDS) used to ensure that parm fields are set to default
       //   values  when not specifically set by user program.

       Dcl-ds fileParms  LikeDS(userParms_T) Inz(*LikeDS);

       // Set up file name and code page but default record terminator

       fileParms.fileName = '/home/PARIS/ITJungle/PrinterOutput.txt';

       fileParms.codepage = 1208;  // Set codepage to UTF-8

       TSTIFSWRT3( fileParms );  // Call test program

       *InLr = *On;

