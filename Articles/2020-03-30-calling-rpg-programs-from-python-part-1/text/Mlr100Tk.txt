**FREE
ctl-opt option (*srcstmt : *nodebugio : *nounref);
ctl-opt debug (*input);
ctl-opt dftactgrp (*no);
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Program : Mlr100Tk
//  Author  : Mike Larsen
//  Date Written: 03/21/2020
//  Purpose : This program receives a parm and passes one back to the
//            caller.
//
//====================================================================*
//   Date    Programmer  Description                                  *
//--------------------------------------------------------------------*
// 03/21/20  M.Larsen    Original code.                               *
//                                                                    *
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *

// - - - - - - -
// Prototypes (entry parameters)

dcl-pr Mlr100Tk    ExtPgm;
       inFirstName char(10);
       outLastName char(10);
End-pr;

// - - - - - - -
// Main procedure interface

dcl-pi Mlr100Tk;
       inFirstName char(10);
       outLastName char(10);
end-pi;

//------------------------------

If %trim(inFirstName) = 'Mike';
   outLastName = 'Larsen';
Else;
   outLastName = 'Holt';
Endif;

*Inlr = *On;
Return;

 //- - - - - - - - - - - - - - 