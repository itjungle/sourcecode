       // Copyright (c) 2019 Partner400
       // All rights reserved.
       // Based on latest version of Jon's Open Access Program Template

       Ctl-Opt DftActGrp(*No) Option(*SrcStmt: *NoDebugIO );

       // Include user parm defintiions
      /Copy OASampSrc,IFSUSRPARM

       Dcl-C  CRLF    x'0d25'; // Default record terminator - change if required

       // Standard IBM supplied Open Access definitions
      /Copy QRNOPENACC

       // Standard IBM supplied IFS prototypes
      /copy qsysinc/qrpglesrc,ifs

       // Copy constants for RPG status codes - write your own or use mine
       //   email me at Contact at Partner400 dot com for a copy
      /Copy MonStatCds

       // User parameter definition.
       //   If present, data will be copid into the state informatio area
       //
       //   This avoids possible problems might be caused by the user
       //     changing the values post file open

(A)    Dcl-Ds  userData  Based( info.userArea )  LikeDS(userParms_T);

       // This handler only uses the OA output buffer which contains
       //   the "print" or "disk" data.

       Dcl-S  outputBuffer  Char(64512)  Based( info.outputBuffer );

       // State info
       // This allows the handler to be used by multiple files in a single
       //   program if needed. File name would need to be enlarged if a
       //   full path is to be supplied.

       Dcl-Ds  stateInfo  Based( info.stateInfo )  Qualified;
          fileHandle  int(10);
          Dcl-ds  userParms  LikeDs(userParms_T);
       End-Ds;

       // Procedure interface for handler - only a single parameter

       Dcl-Pi  IFSWRTREC2;
         info  likeds( QrnOpenAccess_T );
       End-Pi;

       // Main logic begins by determining operation requested

       Select;

       When ( info.rpgOperation = QrnOperation_WRITE );
         WriteFile();
       When ( info.rpgOperation = QrnOperation_OPEN );
         OpenFile();
       When ( info.rpgOperation = QrnOperation_CLOSE );
         CloseFile();

         // This section processes op-codes the handler is not designed for.
         // You must report the error to RPG and should log something.
         // A real production handler would also report the actual
         //   operation that was being attempted.
         // Rather than set the rpgStatus value you could send a failure message
         //   back to the caller - the RPG run time will note this and set the
         //   appropriate error status for you. See IBM's shipped examples.

       Other;
         Dsply ( 'Unsupported operation ' + %Char( info.rpgOperation ) +
         ' on file ' + info.externalFile.name );
         info.rpgStatus = errIO;
       EndSl;

       Return;

       // Logic for IFS file Open function

       Dcl-Proc  OpenFile;
       Dcl-Pi  *N  End-Pi;

       // If no state info area exists yet, allocate now and initialize

       If info.stateInfo = *null;
         info.stateInfo = %Alloc( %Size( stateInfo ) );
         Clear stateInfo;
       EndIf;

       // Tell OA we are a buffer handler - it is the default but good to be specific

       info.useNamesValues = *Off;

       // Check if user has supplied file name etc. parms and if present copy
       //   the into the state information.
       // If no user data supplied for a field then set up default value.

(B)    // Use user supplied file name or set up default value
       If info.userArea <> *Null and userData.fileName <> '';
         stateInfo.userParms.fileName = userData.fileName;  // Use supplied name
       Else;    // Otherwise build the default name.
         stateInfo.userParms.fileName = %Trim(info.externalFile.name)
                          + '_' + %Char(%Date()) + '_' + %Char(%Time())
                          + '.txt';
       EndIf;

       // Set up code page to use
       If info.userArea <> *Null and userData.codePage <> 0;  // Code page supplied?
         stateInfo.userParms.codePage = userData.codePage;
       Else;
         stateInfo.userParms.codePage = 819;  // Default value for IFS code page
       EndIf;

       // Set up record terminator
       If info.userArea <> *Null and userData.recordTerminator <> '';  // Terminator supplied?
         stateInfo.userParms.recordTerminator = userData.recordTerminator;
       Else;
         stateInfo.userParms.recordTerminator = CRLF;
       EndIf;

       // Now actually open the file and get the file handle
       //   Options used will create the file if it does not exist and clear
       //   it if it does. It will also do the code page coversion to CCSID 819

       stateInfo.fileHandle = open( stateInfo.userParms.fileName
                                   :  O_CREAT + O_WRONLY + O_CCSID + O_TRUNC
                                      + O_TEXTDATA + O_TEXT_CREAT
                                   : S_IRUSR + S_IWUSR + S_IRGRP + S_IROTH
                                   : stateInfo.userParms.codePage
                                   : 0 );

       // Check for an open error and report if one occured.
       //   Usually this will only happen if the directory does not exist.
       // Error handling could be extended to use __errno and associated
       //   error string.

       If stateInfo.fileHandle < 0;
          Dsply ('Open fail on file ' + info.externalFile.name);
          info.rpgStatus = errIO;
       EndIf;

       Return;

       End-Proc OpenFile;


       // File Close operation

       Dcl-Proc CloseFile;
       Dcl-Pi  *N  End-Pi;

       Dcl-s  reply  int(10);

       // Close the file - reply status is ignored 'cos there's really
       //    nothing sensible we can do with it.

       reply = close( stateInfo.fileHandle );

       // Release the storage holding state information & set pointer to null.
       //   That way we can't ever reference it later by mistake.

       Dealloc(N) info.stateInfo;
       info.rpgStatus = stsOK;

       Return;

       End-Proc CloseFile;


       // Write operation

       Dcl-Proc WriteFile;
       Dcl-Pi  *N  End-Pi;

       Dcl-s  buffer  Varchar(32740)  Inz;
       Dcl-s  reply   int(10);

       // Form and write the record to the file with a CRLF record terminator.
       //   If the records should be trimmed of trailing spaces then change
       //   the code to buffer = %TRimR( %Subst( outputBuffer ...

       buffer = %Subst( outputBuffer: 1: info.outputBufferLen )
                + stateInfo.userParms.recordTerminator;

       reply = write ( stateInfo.fileHandle
                     : %Addr( buffer: *Data )
                     : %Len( buffer ) );
       If reply < 0;
          Dsply ('Write fail on file: ' + info.externalFile.name);
          info.rpgStatus = errImpOpenClose;

       EndIf;
       Return;

       End-Proc WriteFile;
