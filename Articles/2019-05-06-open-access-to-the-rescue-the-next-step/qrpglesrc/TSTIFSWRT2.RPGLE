       // This program demonstrates the use of the IFSWRTREC2 handler.
       //   Two IFS files will be created both defined by O-specs.

(C)    Dcl-f  IFSOut1   Printer(50)  UsrOpn
                          Handler('IFSWRTREC2' : fileParms1 );

       Dcl-f  IFSOut2   Disk(60)  UsrOpn
                          Usage(*Output) Handler('IFSWRTREC2' : fileParms2);

       Dcl-F  CustMast Keyed;

       // Include user parameter template

(D)   /Copy OASampSrc,IFSUSRPARM

       // User parameters for IFS output files
       //   Inz(*LikeDS) used to ensure that parm fields are set to default
       //   values  when not specifically set by user program.

(F)    Dcl-ds fileParms1  LikeDS(userParms_T) Inz(*LikeDS);
       Dcl-ds fileParms2  LikeDS(userParms_T) Inz(*LikeDS);

       // Set up parameters for file name etc.
       //   For IFSOut1 supply file name but default code page and record terminator
       fileParms1.fileName = '/home/PARIS/ITJungle/DiskOut.txt';

       //   For IFSOut2 default just the file name
       fileParms2.codepage = 1208;  // Set codepage to UTF-8
       fileParms2.recordTerminator = '!';  // Set line end to !

       // Now that file name etc. is set we can open the files

       Open IFSOut1;

       Open IFSOut2;

       // Really nothing much to say about the rest of this code.
       //   It simply reads all records in the CustMast file and
       //   writes out to both the Disk and Printer files.

       Read CustMast;

       DoU %Eof(CustMast);

          Except IFSRec1;

          Except IFSRec2;

          Read CustMast;

       EndDo;

       *InLr = *On;

     OIFSOut1   E            IFSRec1
     O                       Cust#                5
     O                       Name                40
     O                       Credit              50

       // Same basic layout but showing use of edit code
     OIFSOut2   E            IFSRec2
     O                       Cust#                5
     O                       City                35
     O                       State               50
     O                       CurYr$        Q     60
