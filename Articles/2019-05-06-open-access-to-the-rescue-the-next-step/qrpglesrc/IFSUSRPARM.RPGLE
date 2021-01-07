       // IFSUSRPARM
       //   Basic DS template for IFS parameters for IFSWRTREC2 OA Handler
       //
       //   This is copied into the handler and also and programs that use
       //     the handler.

       Dcl-ds  userParms_T  Template;
         filename          varchar(128)  Inz;  // Full path name of file
         codepage          int(10)       Inz;  // Code page for file
         recordTerminator  varchar(2)    Inz;  // Record terminator
       End-Ds;

