000001190223       Ctl-Opt  DftActGrp(*No);
000002190222
000003190223       // The main line processing of this program does nothing but invoke
000004190223       //   individual subprocedures. One for the %XLATE example and one for
000005190223       //   the %REPLACE and %SCANRPL BIF examples in the tip.
000006190223       //   I did it this way rather than have to have multiple sources
000007190223
000008190222       // These are the global variables used:
000009190222
000010190222       Dcl-S  source  Char(36);
000011190222       Dcl-S  result  Char(36);
000012190222
000013190222       XlateExample();
000014190222
000015190222       ReplaceExample();
000016190222
000017190222       *InLr = *On;
000018190222
000019190223       // %XLATE Examples
000020190223
000021190222       Dcl-Proc  XlateExample;
000022190222         Dcl-Pi  *N  End-Pi;
000023190222
000024190222       Dcl-S  from  varchar(5)  Inz('/*');
000025190222       Dcl-S  to    varchar(5)  Inz('&&');
000026190222
000027190222       source = '123ABC789';
000100190222       result = %XLATE( 'ABC': 'XYZ': source);
000101190222
000102190222       dsply ('Source: ' + source);
000103190222       dsply ('Result: ' + result);
000106190222
000107190222
000108190222       dsply ('Convert /* to && the wrong way with %Xlate');
000109190222
000110190222       source = '/* Leave /these/ and *these* /*';
000111190222       result = %Xlate(from: to: source);
000112190222       // - Result contains '&& Leave &these& and &these& &&'
000113190222
000114190222       dsply ('Source: ' + source);
000115190222       dsply ('%XLate from ' + from + ' to ' + to );
000116190222       dsply ('Result is: ' + result);
000117190222
000118190222
000119190222       End-Proc;
000120190222
000121190223       // Examples for %REPLACE and related functions
000122190223
000123190222       Dcl-Proc  ReplaceExample;
000124190222         Dcl-Pi  *N  End-Pi;
000125190222
000135190222       Dcl-S  from    Varchar(5)  Inz('/*');
000136190222       Dcl-S  to      Varchar(5)  Inz('&&');
000137190222
000138190222       Dcl-S  position  Int(5);
000139190222       Dcl-S  start     Int(5);
000141190222
000142190222       Dcl-S  custName  varchar(12);
000143190222
000144190222       Dcl-S  marker    varchar(10);
000145190222
000146190222       // This is a valid approach to handling character strings
000147190222       //  - It will result in '&& Leave /these/ and *these* &&'
000148190222
000149190222       dsply ('Convert /* to && the "right" way with %Scan/%Replace');
000150190222
000151190222       result = '/* Leave /these/ and *these* /*';
000152190222
000153190222(A)    position = %Scan( from: result);
000154190222
000155190222       DoW position > 0;
000156190222         // If replacing all occurrences %SCANRPL works better
000157190222         // But logic could be added here to check for which
000158190222         //  occurrence(s) should be replaced
000159190222
000160190222(B)       result = %Replace( to: result: position);
000161190222          start = position + 1;
000162190222(C)       position = %Scan( from: result: start);
000163190222
000164190222       EndDo;
000165190222
000166190222       dsply ('Source: ' + source);
000167190222       dsply ('%Replace ' + from + ' With ' + to );
000168190222       dsply ('Result is: ' + result);
000169190222
000170190222       dsply ('"Mailmerge" - replace marker by variable string');
000171190222       dsply ('Old-style by using %Scan/%Replace');
000172190222
000173190222       marker = '&Name';
000174190222       source = 'Hello &Name - how are you today?';
000175190222       custName = 'Jon';
000176190222
000177190222       position = %Scan(marker: source);
000178190222
000179190222       result = %Replace( custName: source: position: %Len(marker));
000180190222
000181190222       dsply ('Source: ' + source);
000182190222       dsply ('%Replace ' + marker + ' With ' + custName );
000183190222       dsply ('Result is: ' + result);
000184190222
000185190222       dsply ('A simpler way using %ScanRpl');
000186190222
000187190222       result = %ScanRpl(marker: custName: source);
000188190222
000189190222       dsply ('Source: ' + source);
000190190222       dsply ('%Replace ' + marker + ' With ' + custName );
000191190222       dsply ('Result is: ' + result);
000192190222
000193190222       End-Proc;
000194190222
