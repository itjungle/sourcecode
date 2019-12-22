      * ========================================================================
      * FMTDATE -- RPG subprocedure to implement SQL function FMTDATE
      *
      * Author: Ted Holt
      *
      * Published in Four Hundred Guru.  No warranties.  Use at your own risk.
      *
      * Parameters:
      * 1. A character or numeric value containing a five- to eight-digit date.
      * 2. A string describing how parameter 1 is formatted.
      * 3. A string describing how the return value is to be formatted.
      *
      * Supported date formats:
      *      5 digits
      *          JUL
      *      6 digits
      *          DMY, MDY, YMD
      *      7 digits
      *          CDMY, CMDY, CYMD, LONGJUL
      *      8 digits
      *          DMYY or EUR
      *          MDYY or USA
      *          YMDD or ISO or JIS
      *
      * To create:
      *          CRTRPGMOD MODULE(xxx/FMTDATE)
      *                    SRCFILE(xxx/QRPGLESRC)
      *                    SRCMBR(FMTDATE)
      *
      *          CRTSRVPGM SRVPGM(xxx/FMTDATE)
      *                    MODULE(xxx/FMTDATE)
      *                    EXPORT(*ALL)
      *
      *          create function xxx/fmtdate
      *          (inDate dec(8,0), inFromFmt varchar(8), inToFmt varchar(8))
      *          returns varchar(10)
      *          language rpgle
      *          parameter style general with nulls
      *          deterministic
      *          no sql
      *          returns null on null input
      *          no external action
      *          not fenced
      *          no final call
      *          allow parallel
      *          no scratchpad
      *          external name 'XXX/FMTDATE(FMTDATEN)'
      *
      *          create function xxx/fmtdate
      *          (inDate varchar(10), inFromFmt varchar(8), inToFmt varchar(8))
      *          returns varchar(10)
      *          language rpgle
      *          parameter style general with nulls
      *          deterministic
      *          no sql
      *          returns null on null input
      *          no external action
      *          not fenced
      *          no final call
      *          allow parallel
      *          no scratchpad
      *          external name 'XXX/FMTDATE(FMTDATEA)'
      *
      * To call:
      *          SELECT ... , fmtdate(<date>,'CYMD','MDYY/'), ...
      *
     H nomain
     H option(*srcstmt)

     D gNullValue      c                   const(-1)

     D WorkDate        ds             8
     D  Date5                  4      8s 0
     D  Date6                  3      8s 0
     D  Date7                  2      8s 0
     D  Date8                  1      8s 0

     D*** *entry plist
     D FmtDateN        pr            10a   varying
     D   inDate                       8p 0 const
     D   inFromFmt                    8a   varying const
     D   inToFmt                      8a   varying const
     D   inNullArray                  6a   const
     D   ouNull                       5i 0

     D FmtDateA        pr            10a   varying
     D   inDate                      10a   varying const
     D   inFromFmt                    8a   varying const
     D   inToFmt                      8a   varying const
     D   inNullArray                  6a   const
     D   ouNull                       5i 0

     D ValidateDate...
     D                 pr
     D  Date                               likeds(WorkDate)
     D  Format                        8a   varying const
     D  ouDate                         d
     D  IsValid                        n

     D ResolveDateFormat...
     D                 pr
     D inFormat                       8    varying const
     D ouFormat                       8    varying
     D ouSeparator                    1a

     D ConvertDate     pr
     D  inDate                         d   const
     D  inToFmt                       8a   const
     D  inSep                         1a   const
     D  ouDate                       10a
      * ====================================================================
     P FmtDateA        b                   export
     D                 pi            10a   varying
     D   inDate                      10a   varying const
     D   inFromFmt                    8a   varying const
     D   inToFmt                      8a   varying const
     D   inNullArray                  6a   const
     D   ouNull                       5i 0

      *** locals
     D WorkDate        s             10a   varying
     D FromFmt         s              8a   varying
     D FromSep         s              1a
     D Sep             s              1a

     D EmptyString     c                   const('')
     D OneBlank        c                   const(' ')
     D Ampersand       c                   const('&')

      /free
          monitor;
             WorkDate = inDate;

             // De-edit the date if the from-format has a separator character.
             ResolveDateFormat (inFromFmt: FromFmt: FromSep);
             if FromSep <> *blank;
                if FromSep <> Ampersand;
                   Sep = FromSep;
                else;
                   Sep = OneBlank;
                endif;
                WorkDate = %scanrpl (Sep: EmptyString: WorkDate);
             endif;

             return FmtDateN (%dec(WorkDate:8:0): inFromFmt:
                              inToFmt: inNullArray: ouNull);
          on-error;
             ouNull = gNullValue;
             return *blank;
          endmon;

      /end-free
     P                 e
      * ====================================================================
     P FmtDateN        b                   export
     D                 pi            10a   varying
     D   inDate                       8p 0 const
     D   inFromFmt                    8a   varying const
     D   inToFmt                      8a   varying const
     D   inNullArray                  6a   const
     D   ouNull                       5i 0
     D**** locals
     D NonNullValue    c                   const(0)
     D EmptyString     c                   const('')

     D FromFmt         s              8a   varying
     D FromSep         s              1a
     D ToFmt           s              8a   varying
     D ToSep           s              1a
    2D ouDate          s             10a
     D
     D DateIsValid     s              1n

     D DateToConvert   s               d

      /free
          ouNull = NonNullValue;
          monitor;
             WorkDate.Date8 = inDate;
             ResolveDateFormat (inFromFmt: FromFmt: FromSep);
             ResolveDateFormat (inToFmt:   ToFmt:   ToSep  );
             ValidateDate (WorkDate: FromFmt: DateToConvert: DateIsValid);
             if not DateIsValid;
                ouNull = gNullValue;
                return *blanks;
             endif;
             ConvertDate (DateToConvert: ToFmt: ToSep: ouDate);
          on-error;
             ouNull = gNullValue;
          endmon;

          return ouDate;
      /end-free
     P                 e
      * ========================================================================
     P ResolveDateFormat...
     P                 b
     D                 pi
     D inFormat                       8    varying const
     D ouFormat                       8    varying
     D ouSeparator                    1a
      *** locals
     D lo              c                   const('abcdefghijklmnopqrstuvwxyz')
     D up              c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D LastChar        s              1a
     D FormatLength    s              5i 0

      /free
          clear ouSeparator;
          ouFormat = %trim(inFormat);

          // ignore leading asterisk
          if %subst(ouFormat: 1: 1) = '*';
             ouFormat = %subst(ouFormat: 2);
          endif;

          // Capitalize the format
          ouFormat = %xlate(lo: up: ouFormat);

          // Is there a separator on the end?
          FormatLength = %len(ouFormat);
          LastChar = %subst(ouFormat: FormatLength: 1);
          if %scan(LastChar: up) <= *zero;
             if LastChar <> '0';
                ouSeparator = LastChar;
             endif;
             ouFormat = %subst(ouFormat: 1: FormatLength - 1);
          endif;

      /end-free
     P                 e
      * ========================================================================
     P ValidateDate...
     P                 b
     D                 pi
     D  inDate                             likeds(WorkDate)
     D  inFormat                      8a   varying const
     D  ouDate                         d
     D  IsValid                        n

      /free
          IsValid = *on;
          monitor;
             select;
                when inFormat = 'ISO'
                  or inFormat = 'YYMD'
                  or inFormat = 'JIS';
                   ouDate = %date(inDate.Date8: *iso);
                when inFormat = 'USA'
                  or inFormat = 'MDYY';
                   ouDate = %date(inDate.Date8: *usa);
                when inFormat = 'EUR'
                  or inFormat = 'DMYY';
                   ouDate = %date(inDate.Date8: *eur);
                when inFormat = 'MDY';
                   ouDate = %date(inDate.Date6: *mdy);
                when inFormat = 'DMY';
                   ouDate = %date(inDate.Date6: *dmy);
                when inFormat = 'YMD';
                   ouDate = %date(inDate.Date6: *ymd);
                when inFormat = 'CMDY';
                   ouDate = %date(inDate.Date7: *cmdy);
                when inFormat = 'CDMY';
                   ouDate = %date(inDate.Date7: *cdmy);
                when inFormat = 'CYMD';
                   ouDate = %date(inDate.Date7: *cymd);
                when inFormat = 'JUL';
                   ouDate = %date(inDate.Date5: *jul);
                when inFormat = 'LONGJUL';
                   ouDate = %date(inDate.Date7: *longjul);
                other;
                   IsValid = *off;
             endsl;
          on-error;
             IsValid = *off;
          endmon;
      /end-free
     P                 e
      * ========================================================================
     P ConvertDate     b
     D                 pi
     D  inDate                         d   const
     D  inToFmt                       8a   const
     D  inSep                         1a   const
     D  ouDate                       10a

      *** locals
     D WDate           s             10a   varying
     D Sep             s                   like(inSep)

      /free
         monitor;
            select;
               when inToFmt = 'ISO'
                 or inToFmt = 'YYMD'
                 or inToFmt = 'JIS';
                  WDate= %char(inDate: *iso0);
               when inToFmt = 'EUR'
                 or inToFmt = 'DMYY';
                  WDate= %char(inDate: *eur0);
               when inToFmt = 'USA'
                 or inToFmt = 'MDYY';
                  WDate= %char(inDate: *usa0);
               when inToFmt = 'MDY';
                  WDate = %char(inDate: *mdy0);
               when inToFmt = 'DMY';
                  WDate = %char(inDate: *dmy0);
               when inToFmt = 'YMD';
                  WDate = %char(inDate: *ymd0);
               when inToFmt = 'CYMD';
                  WDate = %char(inDate: *cymd0);
               when inToFmt = 'CMDY';
                  WDate = %char(inDate: *cmdy0);
               when inToFmt = 'CDMY';
                  WDate = %char(inDate: *cdmy0);
               when inToFmt = 'JUL';
                  WDate = %char(inDate: *jul0);
               when inToFmt = 'LONGJUL';
                  WDate = %char(inDate: *longjul0);
               other;
            endsl;
         on-error;
         endmon;

         if inSep <> *blank;
            if inSep <> '&';
               Sep = inSep;
            else;
               Sep = *blank;
            endif;
            select;
               when inToFmt = 'ISO'
                 or inToFmt = 'YYMD'
                 or inToFmt = 'JIS';
                  WDate= %subst(WDate: 1: 4) + Sep + %subst(WDate: 5: 2) +
                         Sep + %subst(WDate: 7: 2);
               when inToFmt = 'USA'
                 or inToFmt = 'MDYY'
                 or inToFmt = 'EUR'
                 or inToFmt = 'DMYY';
                  WDate= %subst(WDate: 1: 2) + Sep + %subst(WDate: 3: 2) +
                         Sep + %subst(WDate: 5: 4);
               when inToFmt = 'MDY' or inToFmt = 'YMD' or inToFmt = 'DMY';
                  WDate= %subst(WDate: 1: 2) + Sep + %subst(WDate: 3: 2) +
                         Sep + %subst(WDate: 5: 2);
               when inToFmt = 'CMDY' or inToFmt = 'CYMD' or inToFmt = 'CDMY';
                  WDate= %subst(WDate: 1: 3) + Sep + %subst(WDate: 4: 2) +
                         Sep +  %subst(WDate: 6: 2);
               when inToFmt = 'JUL';
                  WDate= %subst(WDate: 1: 2) + Sep + %subst(WDate: 3);
               when inToFmt = 'LONGJUL';
                  WDate= %subst(WDate: 1: 4) + Sep + %subst(WDate: 5);
            endsl;
         endif;

         ouDate = WDate;

      /end-free
     P                 e