**free
ctl-Opt dftActGrp(*no) option(*srcStmt : *nodebugIO);

dcl-s forNumber zoned(13:2);

dcl-ds *n;
  words      varchar(200);
  showWords1 char(50) overLay(words : 3);
  showWords2 char(50) overLay(words : *next);
  showWords3 char(50) overLay(words : *next);
  showWords4 char(50) overLay(words : *next);
end-ds;

dsply 'Enter number: ' ' ' forNumber;
words = currencyToWords(forNumber);
dsply showWords1;
dsply showWords2;
dsply showWords3;
dsply showWords4;
*inLr = *on;

dcl-proc currencyToWords;
   dcl-pi *n varchar(200);
     number   zoned(13:2) const;
     currency varchar(20) const options(*noPass: *trim);
     decimals varchar(20) const options(*noPass: *trim);
   end-pi;

   dcl-s forCurrency varchar(20) inz('Dollars');
   dcl-s forDecimals varchar(20) inz('cents');

   dcl-s cents zoned(2);

   if (%parms() > 1);
      forCurrency = currency;
   endIf;
   if (%parms() > 2);
      forDecimals = decimals;
   endIf;

   cents = %int((number - %int(number)) * 100);
   return numberToWords(%int(number)) + ' ' + forCurrency + ' and ' +
          %editC(cents: 'X') + ' '  + forDecimals;

end-proc;


dcl-proc numberToWords;

   dcl-pi *n varchar(200);
     numberIn zoned(11) const;
   end-pi;

   dcl-s number   int(20);
   dcl-s mega     int(20);
   dcl-s kilo     int(20);
   dcl-s hundreds int(20);
   dcl-s tens     int(20);
   dcl-s singles  int(20);

   dcl-s result varchar(200);

   dcl-ds forOneWords;
     *n varchar(9) inz('One');
     *n varchar(9) inz('Two');
     *n varchar(9) inz('Three');
     *n varchar(9) inz('Four');
     *n varchar(9) inz('Five');
     *n varchar(9) inz('Six');
     *n varchar(9) inz('Seven');
     *n varchar(9) inz('Eight');
     *n varchar(9) inz('Nine');
     *n varchar(9) inz('Ten');
     *n varchar(9) inz('Eleven');
     *n varchar(9) inz('Twelve');
     *n varchar(9) inz('Thirteen');
     *n varchar(9) inz('Fourteen');
     *n varchar(9) inz('Fifteen');
     *n varchar(9) inz('Sixteen');
     *n varchar(9) inz('Seventeen');
     *n varchar(9) inz('Eighteen');
     *n varchar(9) inz('Nineteen');
     oneWords varchar(9) dim(19) pos(1);
   end-ds;

   dcl-ds forTenWords;
     *n varchar(7) inz('');
     *n varchar(7) inz('Twenty');
     *n varchar(7) inz('Thirty');
     *n varchar(7) inz('Forty');
     *n varchar(7) inz('Fifty');
     *n varchar(7) inz('Sixty');
     *n varchar(7) inz('Seventy');
     *n varchar(7) inz('Eighty');
     *n varchar(7) inz('Ninety');
     tenWords varchar(7) dim(9) POS(1);
   end-ds;

   dcl-c MILLION  ' Million ';
   dcl-c THOUSAND ' Thousand ';
   dcl-c HUNDRED  ' Hundred ';

   number = numberIn;
   mega = %int(number / 1000000);
   number -= mega * 1000000;
   kilo = %int(number / 1000);
   number -= kilo * 1000;
   hundreds = %int(number / 100);
   number -= hundreds * 100;
   tens = %int(number / 10);
   singles = number - (tens * 10);

   result = '';

   if (mega > 0) ;
      result += numberToWords(mega) + MILLION;
   endIf;
   if (kilo > 0) ;
      result += numberToWords(kilo) + THOUSAND;
   endIf;
   if (hundreds > 0) ;
      result += numberToWords(hundreds) + HUNDRED;
   endIf;


   if (tens > 0 or singles > 0);

      if (result <> '');
         result += 'and ';
      endIf;

      if (tens < 2);
         result += oneWords(tens * 10 + singles);
      else;
         result += tenWords(tens);
         if (singles <> 0);
           result += ' ' + oneWords(singles);
         endIf;
      endIf;

   endIf;

   if (result = '');
      result = 'zero';
   endIf;
   return result;
end-proc;