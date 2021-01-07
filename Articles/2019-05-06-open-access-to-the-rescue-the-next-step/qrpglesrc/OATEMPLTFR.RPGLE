      // Latest version of Partner400's Open Access Template
      //   This version uses free-form data declarations and can easily be
      //     conveted to **Free if you wish
      //   Last update: Jan 31st, 2019
      // Can be used for either handler programs or procedures
      // Copyright (c) 2011-2019 Partner400
      // All rights reserved.
      //
      // Redistribution and use in source and binary forms, with or without
      // modification, are permitted provided that the following conditions
      // are met:
      // 1. Redistributions of source code must retain the above copyright
      //    notice, this list of conditions and the following disclaimer.
      // 2. Redistributions in binary form must reproduce the above copyright
      //    notice, this list of conditions and the following disclaimer in the
      //    documentation and/or other materials provided with the distribution.
      //
      // THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ''AS IS'' AND
      // ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
      // IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
      // ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
      // FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
      // DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
      // OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
      // HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
      // LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
      // OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
      // SUCH DAMAGE.
      //

      Ctl-Opt DftActGrp(*No) Option(*SrcStmt);

      // Standard IBM supplied Open Access definitions
     /Copy QRNOPENACC

      // Copy constants for RPG status codes - write your own or use mine
      //   email me at Contact at Partner400 dot com for a copy
     /Copy MonStatCds

      // If you are on V7.1 or later, remove these prototypes. They are not
      //    required as long as the code for the subprocs is in this source.

      Dcl-Pr  OpenFile  End-Pr;

      Dcl-Pr  CloseFile  End-Pr;

      // Change to PR to use ExtProc etc. if required

      Dcl-Pr HandlerName ExtPgm('<NameGoesHere>');
        info  likeds( QrnOpenAccess_T );
      End-Pr;

      // This is the definition for the user parameter if required.
      // Consider placing it in a /Copy rather than hard code it here.
      //   That allows the user program to use the same defintion.

      Dcl-Ds  userData  Based( info.userArea );
         // Add any fields etc here as required.
      End-Ds;

      // Use _either_ the input and/or output buffer definitions _or_
      // the Names/Values structure as required

      Dcl-S  inputBuffer   Char(64512)  Based( info.inputBuffer );
      Dcl-S  outputBuffer  Char(64512)  Based( info.outputBuffer );

      Dcl-Ds  nvInput  likeds( QrnNamesValues_T )
         based( info.NamesValues );

      // State info
      // This allows the handler to be used by multiple files in a single
      //   program if needed.

      Dcl-Ds  stateInfo  Based( info.stateInfo )  Qualified;
        // This is where you define any fields you need to preserve
        //   for a specific file
        // Check my published examples such as the IFS handlers for an example
      End-Ds;

      // Procedure interface for handler - only a single parameter

      Dcl-Pi  HandlerName;
        info  likeds( QrnOpenAccess_T );
      End-Pi;

      // Main logic begins by determining operation requested

      Select;

        // This is the spot where you add WHEN clauses for all required
        // operations such as READ, CHAIN, SETLL, etc.
        // Code is already in place below for Open and close operations

      When ( info.rpgOperation = QrnOperation_OPEN );
        OpenFile();
      When ( info.rpgOperation = QrnOperation_CLOSE );
        CloseFile();

        // This section, processes op-codes the handler is not designed for.
        // You must report the error to RPG and should log something.
        // A real production handler would also report the actual
        //   operation that was being attempted.

        // Rather than set the RPG status value you could send a failure message
        //   back to the caller - the RPG run time will note this and set the
        //   appropriate error status for you. See IBM's shipped same code
        //   for examples.

      Other;
        Dsply ( 'Unsupported operation ' + %Char( info.rpgOperation ) +
        ' file ' + info.externalFile.name );
        info.rpgStatus = errIO;
      EndSl;

      Return;

      // Basic outline logic for Open function

      Dcl-Proc  OpenFile;
      Dcl-Pi  *N  End-Pi;

      // If no state info area yet allocate now and initialize
      //   This code can be removed if no state information required.

      If info.stateInfo = *null;
        info.stateInfo = %Alloc( %Size( stateInfo ) );
        Clear stateInfo;
      EndIf;

      // Check if user parm was supplied and any set defaults if needed
      // Store parm values in state info area otherwise if caller
      //   changes the values it could really mess you up

      If info.userArea = *Null;

        // Add logic to set any default values required by handler

      Else;

        // Copy user supplied data into state info area to preserve
        //    and set defaults for any values not supplied
      EndIf;

      Return;

      End-Proc OpenFile;


      // Basic outline for file Close operation

      Dcl-Proc CloseFile;
      Dcl-Pi  *N  End-Pi;

      // Release storage holding state information and set pointer to null.
      //   That way we can't ever reference it later by mistake.

      Dealloc(N) info.stateInfo;
      info.rpgStatus = stsOK;

      Return;

      End-Proc CloseFile;

