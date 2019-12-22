       // Extract the time from a string in various formats.
       // Author: Ted Holt
       // No warranties. As with all code, test everything and
       // use at your own risk.

       // Compile with CRTBNDRPG during development and debugging.
       // This creates a program with driving test code.

       //    CRTBNDRPG PGM(xxx/GETTIME)
       //              SRCFILE(xxx/QRPGLESRC)
       //              SRCMBR(GETTIME)
       //              DBGVIEW(*SOURCE)
       //              REPLACE(*YES)

       // Compile with CRTRPGMOD for installation into production.
       // Create a module and then a service program from the module.

       //    CRTRPGMOD MODULE(xxx/GETTIME)
       //              SRCFILE(xxx/QRPGLESRC)
       //              SRCMBR(GETTIME)
       //              DBGVIEW(*SOURCE)
       //              REPLACE(*YES)

       //    CRTSRVPGM SRVPGM(xxx/GETTIME)
       //              MODULE(xxx/GETTIME)
       //              EXPORT(*ALL)

       // If you want an SQL interface, create the service program
       // and run the following command within SQL.

       //    create function xxx/gettime
       //      ( inTime varchar(80))
       //      returns time
       //      language rpgle
       //      parameter style sql
       //      deterministic
       //      no sql
       //      returns null on null input
       //      no external action
       //      not fenced
       //      no final call
       //      no scratchpad
       //      external name 'xxx/GETTIME(GETTIME_SQL)'

     H option(*srcstmt: *nodebugio)
      /if defined(*crtbndrpg)
     H dftactgrp(*no) actgrp(*new)
      /else
     H nomain
      /endif

      /if defined(*crtbndrpg)
     Fqsysprt   o    f  132        printer
     Fqprint    o    f  132        printer

     D Pl              ds           132    qualified
     D  Ndx                           6
     D                                2
     D  State                         6
     D                                2
     D  Char                          4
     D                                2
     D  Column                        6
     D                                2
     D  Action                        6
     D                                2
     D  Token                        24
     D                                2
     D  hour                          4
     D                                1
     D  minute                        4
     D                                1
     D  second                        4
     D                                1
     D  amorpm                        5a

     D PLine           ds           132    qualified

      /endif

      /copy prototypes,GetTime

      * ============================================
      * State table
      * ============================================
     D NbrOfRows       c                   const(15)
     D NbrOfColumns    c                   const( 9)

     D StateTable      ds
     D   Row                         45a   dim(NbrOfRows) ctdata perrcd(1)

     D ptr             s               *   inz(%addr(StateTable))

     D State           ds                  dim(NbrOfRows) qualified based(ptr)
     D   Entry                             likeds(Action_t) dim(NbrOfColumns)

     D Action_t        ds                  qualified
     D   Action                       2a
     D   NextState                    2s 0
     D                                1a

      /if defined(*crtbndrpg)
          *inlr = *on;

          // valid time values
          TestTime ('   12:00:00   am');
          TestTime ('   12:00:00   pm');
          TestTime ('   12:25:50   am');
          TestTime ('   12:25:50   pm');

          TestTime ('   05:13:45   AM');
          TestTime ('   05:13:45   PM');
          TestTime ('   05:13:45   am');
          TestTime ('   05:13:45   pm');
          TestTime ('   05.13.45   A');
          TestTime ('   05.13.45    ');
          TestTime ('   05.13    AM ');
          TestTime ('   05:13    AM ');
          TestTime ('   5:13:45   AM');
          TestTime ('   5:13    AM ');
          TestTime ('   5.13.45   AM');
          TestTime ('   5.13    AM ');
          TestTime ('   05:13:45   A');
          TestTime ('   05:13:45   P');
          TestTime ('   05:13:45A');
          TestTime ('   05:13:45P');
          TestTime ('   05:13:45AM');
          TestTime ('   05:13:45PM');

          TestTime ('   0513   AM  ');
          TestTime ('    513   PM  ');
          TestTime ('   0513       ');
          TestTime ('    513       ');
          TestTime ('   051345     ');
          TestTime ('    51345     ');
          TestTime ('   051345    AM  ');
          TestTime ('    51345    PM  ');
          TestTime ('   051345   A');
          TestTime ('   051345   P');
          TestTime ('   051345A');
          TestTime ('   051345P');

          TestTime ('   1426       ');
          TestTime ('   142637     ');
          TestTime ('   18:45:15   ');
          TestTime ('   18.45.15   ');
          TestTime ('1426');

       // invalid time values
          TestTime ('   05.13:45   AM');
          TestTime ('   05:13.00   AM');
          TestTime ('   BR-549  ');
          TestTime ('   05513545   AM');
          TestTime ('   05:13:00   GG');
          TestTime ('   05:13:00   PX');
          TestTime ('   05:13:00   mp');
          TestTime ('   05:13:00   ma');

          return;

     P TestTime        b
     D TestTime        pi
     D   inString                    80a   varying const

     D ttime           s               t

          monitor;
             ttime = getTime (inString);
             PLine = %char(ttime:*ISO) + ' ' +
                     %char(ttime:*USA) + ' ' + inString;
             write QPrint PLine;
          on-error;
             // nothing
          endmon;

     P TestTime        e

      /endif

       // ================================================================
       // getTime:
       //
       // Extract the time from a string.

     P getTime         b
      /if not defined(*crtbndrpg)
     P                                     export
      /endif

     D getTime         pi              t   timfmt(*iso)
     D   inString                    80a   varying const

     D Token           s             80a   varying
     D hour            s              2s 0
     D minute          s              2s 0
     D second          s              2s 0
     D amorpm          s              2a

     D ErrorCode       s              5u 0
     D Separator       s              1a
     D TempTime        s             10u 0
     D CurrState       s              3u 0
     D CurrChar        s              1a
     D CharNdx         s              3u 0
     D StringLength    s              3u 0
     D Column          s              3u 0
     D CurrAction      s              2a
     D EOI             c                   const(x'00')

     D QMHSNDPM        pr                  extpgm('QMHSNDPM')
     D   MsgID                        7    const
     D   MsgFile                     20    const
     D   MsgDta                   32767    const options(*varsize)
     D   MsgDtaLen                   10i 0 const
     D   MsgType                     10    const
     D   MsgQ                        10    const
     D   MsgQNbr                     10i 0 const
     D   MsgKey                       4
     D   ErrorDS                     10i 0 const

     D MsgKey          s              4a
     D MsgDta          s             96a   varying

      /if defined(*crtbndrpg)
     D DashLine        s            110a   inz(*all'-')
      /endif

        clear hour;
        clear minute;
        clear second;
        clear amorpm;

      /if defined(*crtbndrpg)
        writeln ('>> ' + inString);
        evalr Pl.Ndx      = 'Ndx';
        evalr pl.State    = 'State';
        eval  pl.Char     = 'Char';
        evalr pl.column   = 'Column';
              pl.Action   = 'Action';
              pl.Token    = 'Token';
              pl.Hour     = 'Hour';
              pl.Minute   = 'Min';
              pl.Second   = 'Sec';
              pl.AMorPM   = 'AM/PM';
        writeln (pl);
      /endif

        // Initialize the state machine

        ErrorCode = *zero;
        CharNdx = *zero;
        StringLength = %len(%trimr(inString));
        CurrState = 1;

        // Begin loop to process the input, one character at a time.

        dow CurrState <> *zero
        and ErrorCode = *zero;

           // Move to next character.
           CharNdx += 1;

           if CharNdx <= StringLength;
              CurrChar = %subst(inString: CharNdx: 1);
           else;
              CurrChar = EOI;
           endif;

           // Decide which column of the state table to use.
           select;
              when CurrChar = EOI;
                 Column = 1;
              when CurrChar = *blank;
                 Column = 2;
              when (    CurrChar >= '0'
                    and CurrChar <= '9');
                 Column = 4;
              when CurrChar = 'A'
                or CurrChar = 'a';
                 Column = 5;
              when CurrChar = 'P'
                or CurrChar = 'p';
                 Column = 6;
              when CurrChar = 'M'
                or CurrChar = 'm';
                 Column = 7;
              when Separator <> *blank
               and CurrChar = Separator;
                 Column = 3;
              when CurrChar = '.'
                or CurrChar = ':';
                 Column = 8;
              other;
                 Column = 9;
           endsl;

           // Retrieve the action from the state table.
           CurrAction = State(CurrState).Entry(Column).Action;

           // Carry out the action.
           select;
             when CurrAction = 'NO';
                // no action
             when CurrAction = 'ER';
                ErrorCode = CharNdx;
             when CurrAction = 'CT';          // copy char to token
                exsr do_CT;
             when CurrAction = 'HS';          // hours
                Separator = CurrChar;
                Hour = %dec(token:2:0);
                clear Token;
             when CurrAction = 'MI';          // minutes
                Minute = %dec(token:2:0);
                clear Token;
             when CurrAction = 'SC';          // seconds
                exsr do_SC;
             when CurrAction = 'AP';          // store AM or PM
                AMorPM = Token;
                clear Token;
             when CurrAction = 'DT';          // divide time
                exsr do_DT;
             when CurrAction = 'S2';          // SC followed by A/P
                exsr do_SC;
                exsr do_CT;
             when CurrAction = 'D2';          // DT followed by A/P
                exsr do_DT;
                exsr do_CT;
             other;
      /if defined(*crtbndrpg)
                writeln('Invalid action ' + CurrAction);
      /endif
           endsl;

      /if defined(*crtbndrpg)
           evalr Pl.Ndx = %editc(CharNdx:'4');
           evalr pl.State = %editc(CurrState:'4');
           eval  pl.Char  = currChar;
           evalr pl.column = %editc(Column:'4');
           evalr pl.Action = CurrAction;
                 pl.Token  = Token;
           eval  pl.Hour   = %char(Hour);
           eval  pl.Minute = %char(Minute);
           eval  pl.Second = %char(Second);
           eval  pl.AMorPM = AMorPM;
           writeln (pl);
      /endif

           // Retrieve the next state from the state table.
           CurrState = State(CurrState).Entry(Column).NextState;
        enddo;

        if errorCode > *zero;
           MsgDta = 'Error found at position ' + %char(errorCode) +
                    '. Last character processed was "' + CurrChar + '"';
      /if defined(*crtbndrpg)
           writeln (MsgDta + '.');
           writeln (DashLine);
      /endif
           qmhSndPm ('CPF9898': 'QCPFMSG   *LIBL':
                      MsgDta: %len(MsgDta): '*ESCAPE':
                     '*' : 1: MsgKey: *zero);
        endif;

      /if defined(*crtbndrpg)
        writeln (DashLine);
      /endif

        if hour = 12 and (AMorPM = 'A' or AMorPM = 'a');
           hour = *zero;
        elseif hour < 12 and (AMorPM = 'P' or AMorPM = 'p');
           hour += 12;
        endif;

        return %time(hour * 10000 + minute * 100 + second);

        begsr do_CT;
           Token = (Token + CurrChar);
        endsr;

        begsr do_SC;
                Second = %dec(Token:2:0);
                clear Token;
        endsr;

        begsr do_DT;
                TempTime = %uns(Token);
                if TempTime >= 240000;
                   ErrorCode = CharNdx;
                endif;
                if ErrorCode = *zero;
                   if TempTime > 009999;
                      Second   = %rem(TempTime: 100);
                      TempTime = %div(TempTime: 100);
                   endif;
                   Minute = %rem(TempTime: 100);
                   Hour   = %div(TempTime: 100);
                endif;
                clear Token;
        endsr;

     P getTime         e

     P getTime_SQL     b
      /if not defined(*crtbndrpg)
     P                                     export
      /endif

     D getTime_SQL     pi
     D   inTime                      80a   varying const
     D   ouTime                        t   timfmt(*iso)
     D   inNull                       5i 0         const
     D   ouNull                       5i 0
     D   ouSQLState                   5a
     D   inFuncName                 517a           const
     D   inSpecifName               128a           const
     D   ouMsgText                 1000a   varying

        ouSqlState = *zeros;
        ouNull     = *zero;
        clear ouMsgText;
        monitor;
           ouTime = GetTime (inTime);
        on-error;
           ouSqlState = '88201';
           ouMsgText = 'Invalid time string';
        endmon;

     P getTime_SQL     e

      /if defined(*crtbndrpg)
       // ================================================================
       // Writeln: Write free-form output to the printer.
       // ================================================================
     P Writeln         b
     D Writeln         pi
     D  inString                    132a   varying const

     D Output          ds           132
         Output = inString;
         write qsysprt Output;
     P Writeln         e
      /endif

       // ================================================================
       // The state table follows below.
       // Each row represents a state.
       // Each column represents an input category.

       // columns:
       //  1 : EOI (end of input)
       //  2 : blank
       //  3 : separator character (period or colon)
       //  4 : digit
       //  5 : A or a
       //  6 : P or p
       //  7 : M or m
       //  8 : period or colon
       //  9 : other

1----2*---3----4----5----6----7----8----9----
eol   *   sep  dig  Aa   Pp   Mm   .:   other
**
ER00 NO01 ER00 CT02 ER00 ER00 ER00 ER00 ER00        1
ER00 ER00 ER00 CT03 ER00 ER00 ER00 HS04 ER00        2
ER00 ER00 ER00 CT13 ER00 ER00 ER00 HS04 ER00        3
ER00 ER00 ER00 CT05 ER00 ER00 ER00 ER00 ER00        4
ER00 ER00 ER00 CT06 ER00 ER00 ER00 ER00 ER00        5
ER00 MI10 MI07 ER00 ER00 ER00 ER00 ER00 ER00        6
ER00 ER00 ER00 CT08 ER00 ER00 ER00 ER00 ER00        7
ER00 ER00 ER00 CT09 ER00 ER00 ER00 ER00 ER00        8
SC00 SC10 ER00 ER00 S211 S211 ER00 ER00 ER00        9
ER00 NO10 ER00 ER00 CT11 CT11 ER00 ER00 ER00       10
AP00 ER00 ER00 ER00 ER00 ER00 AP12 ER00 ER00       11
NO00 NO12 ER00 ER00 ER00 ER00 ER00 ER00 ER00       12
DT00 DT10 ER00 CT13 D211 D211 ER00 ER00 ER00       13
ER00 ER00 ER00 ER00 ER00 ER00 ER00 ER00 ER00
ER00 ER00 ER00 ER00 ER00 ER00 ER00 ER00 ER00
