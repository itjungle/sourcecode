       Ctl-Opt DftActGrp(*No);

       // Use a subprocedure to extract the year from 
	   // a CYMD packed date.

       Dcl-S  reply      char(1);
       Dcl-S  forever    Ind Inz;
       Dcl-S  inputCYMD  packed(7);
       Dcl-S  year       packed(2);

       DoU forever;

         Dsply ('Input 7 digit CYMD value') ' ' inputCYMD;

         If inputCYMD = 0;
           Leave;
         Else;
           year = GetYYfromCYMD ( inputCYMD );
         EndIf;

         Dsply ('The year was ' + %Char(year) + 
                ' - Press <Enter> to continue') ' ' reply;
       EndDo;


       *InLR = *On;

       Dcl-Proc GetYYfromCYMD;
       Dcl-PI   *N  zoned(2);
         // Note CYMD parameter is specified as zoned with
         //   Const keyword. This allows the routine to be
         // called with any kind of numeric value.
         cymd       zoned(7) Const;
       End-Pi;

       Dcl-Ds  cymdDate;
         date  zoned(7);
         year  zoned(2) overlay(date:2);
       End-Ds;

       // You could add validation here to be sure the date
       //   was a valid CYMD. Perhaps return zero to 
       //   indicate an error?
       date = cymd;

       Return year;

       End-Proc;

 