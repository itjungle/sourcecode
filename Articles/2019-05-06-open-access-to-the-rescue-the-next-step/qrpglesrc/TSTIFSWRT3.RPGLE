       // This program demonstrates the use of the IFSWRTRECH handler.
       //   In this example the IFS parameters are passed in to the program
       //     as a result the files do not need to be defined as User Open

       Dcl-f  IFSPrinter  Printer(50) Handler('IFSWRTREC2' : fileParms );

       Dcl-F  CustMast Keyed;

       // Include user parameter template

      /Copy OASampSrc,IFSUSRPARM

       // User parameters for IFS output files are passed to the program

       Dcl-PI  TSTIFSWRT3  ExtPgm;
         fileParms  LikeDS(userParms_T);
       End-Pi;


       // Really nothing much to say about the rest of this code.
       //   It simply reads all records in the CustMast file and
       //   writes out to both the Disk and Printer files.

       Read CustMast;

       DoU %Eof(CustMast);

          Except IFSLine1;

          Read CustMast;

       EndDo;

       *InLr = *On;

     OIFSPrinterE            IFSLine1
     O                       Cust#                5
     O                       Name                40
     O                       Credit              50

