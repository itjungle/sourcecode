       // Code for Guru Classics Tip 
       //   "A Bevy of BIFs: %SCAN and %CHECK"

       Dcl-s  fixedLengthTarget    Char(10);
       Dcl-s  varyingLengthTarget  VarChar(10);

       Dcl-s  source    Char(30);
       Dcl-s  position  Int(5);

       Dcl-s  goodNumber1  Char(16)  Inz('(253) 555-1212');
       Dcl-s  goodNumber2  Char(16)  Inz('253-555-1212');
       Dcl-s  goodNumber3  Char(16)  Inz('# (253) 555-1212');

       // Test use of %CHECK to validate a variety of phone number formats
       
       If ValidPhoneNumber(goodNumber1);
          Dsply ( goodnumber1 + ' is a valid phone number' );
       Else;
          Dsply ( goodnumber1 + ' is NOT a valid phone number' );
       endif;
       If ValidPhoneNumber(goodNumber2);
          Dsply ( goodnumber2 + ' is a valid phone number' );
       Else;
          Dsply ( goodnumber2 + ' is NOT a valid phone number' );
       endif;
       If ValidPhoneNumber(goodNumber3);
          Dsply ( goodnumber3 + ' is a valid phone number' );
       Else;
          Dsply ( goodnumber3 + ' is NOT a valid phone number' );
       endif;

       //  Demonstrate effects of using variable vs fixed length field
       //    strings as search argument of %Scan

       source = 'this is the test input string';
       Dsply ('Input string: ' + source );
       fixedLengthTarget = 'is';
       position = %Scan( fixedLengthTarget: source);
         // position value is zero due to trailing spaces
       Dsply ('Fixed target ' + fixedLengthTarget
              + ' at posiiton ' + %Char(position));

       position = %Scan( %TrimR(fixedLengthTarget): source);
         // position value is zero due to trailing spaces
       Dsply ('Trimmed target ' + fixedLengthTarget
              + ' at posiiton ' + %Char(position));

       varyingLengthTarget = 'is';
       position = %Scan( varyingLengthTarget: source);
         // position value is 3
       Dsply ('Varying target '
              + varyingLengthTarget +  ' at position ' + %Char(position));

       *InLr = *On;

       // Subprocedure to validate phone number
       //   Doesn't check the format - only the characters used

       Dcl-Proc  ValidPhoneNumber;
          Dcl-Pi  *N  Ind;
             phoneNumber  Char(16);
          end-pi;

       Dcl-c  validPhoneNumChars  '( )-0123456789';


       If %Check ( validPhoneNumChars: phoneNumber ) = 0;
          Return *On;
       Else;
          Return *Off;
       endif;

       end-proc ValidPhoneNumber;

 