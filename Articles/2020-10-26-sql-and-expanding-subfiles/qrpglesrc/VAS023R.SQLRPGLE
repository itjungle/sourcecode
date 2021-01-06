**free
ctl-opt  option(*srcstmt: *nodebugio)
         main(VAS023R_Main)
         actgrp(*new);

dcl-f  Display    workstn(*ext)  qualified
                                 extdesc('VAS0230D')
                                 extfile(*extdesc)
                                 sfile(SFL01: RRN01)
                                 indds(WsInd)
                                 usropn;

dcl-ds  CTL01_rec_t     likerec(Display.CTL01:    *all)   template;
dcl-ds  SFL01_rec_t     likerec(Display.SFL01:    *all)   template;
dcl-ds  SCREEN01_rec_t  likerec(Display.SCREEN01: *all)   template;

dcl-c  SFL01_PageSize      5;
dcl-s  RRN01               zoned(3);

dcl-ds  WsInd    len(99)  qualified;
   ExitKey       ind      pos( 3);
   RollUp        ind      pos(10);
   SflClr        ind      pos(40);
   SflDspCtl     ind      pos(41);
   SflDsp        ind      pos(42);
   SflEnd        ind      pos(43);
end-ds  WsInd;

dcl-c  SortByName        '1';
dcl-c  SortByDepartment  '2';
dcl-c  SortByClock       '3';

dcl-c  c_SQL_EOD      '02000';

dcl-proc  VAS023R_Main;

     monitor;
        open  Display;
        Driver();
        close *all;
     on-error;
        // fixme -- error handling goes here
     endmon;
     return;

end-proc  VAS023R_Main;

dcl-proc  Driver;

   dcl-ds  CTL01_rec         likeds(CTL01_rec_t)     inz;
   dcl-ds  SCREEN01_rec      likeds(SCREEN01_rec_t)  inz;

   dcl-s  Size01    like(RRN01);
   dcl-s  EndOfData ind;

   dcl-s  SaveSortOption     like(CTL01_rec.SortOption);
   dcl-s  SaveDepartment     like(CTL01_rec.Department);

   CTL01_rec.SortOption = SortByName;
   CTL01_rec.Department = *blanks;

   dow '1';
      if CTL01_rec.SortOption <> SaveSortOption
      or CTL01_rec.Department <> SaveDepartment;
         LoadFirstPage (CTL01_rec: Size01: EndOfData: SCREEN01_rec);
         CTL01_rec.SFLRCDNBR = Size01;
         SaveSortOption = CTL01_rec.SortOption;
         SaveDepartment = CTL01_rec.Department;
      endif;

      WsInd.SflDspCtl  =  *on;
      WsInd.SflDsp     =  (Size01 > *zero);
      WsInd.sflClr     =  *off;
      WsInd.sflEnd     =  EndOfData;
      write   Display.Screen01  Screen01_rec;
      exfmt   Display.CTL01     CTL01_rec;
      if WsInd.ExitKey;
         leave;
      endif;
      clear Screen01_rec.Message;
      if WsInd.RollUp;
         LoadOnePage (Size01: EndOfData: SCREEN01_rec);
         CTL01_rec.SFLRCDNBR = Size01;
      endif;
   enddo;

end-proc  Driver;

dcl-proc  LoadFirstPage;

   dcl-pi  *n;
      ioCTL01_rec     likeds(CTL01_rec_t);
      ouSize          like(RRN01);
      ouEndOfData     ind;
      ouScreen01_rec  likeds(SCREEN01_rec_t);
   end-pi;

   dcl-s   Statement         varchar(512);
   dcl-s   Department        char(2);

   WsInd.SflDspCtl   = *off;
   WsInd.SflDsp      = *off;
   WsInd.SflClr      = *on;
   WsInd.SflEnd      = *off;
   write  Display.CTL01  ioCTL01_rec;
   WsInd.SflClr    =*off;

   ouSize = *zero;
   ouEndOfData = *off;

   Statement = 'select clock, name, department, type from emps';

   if ioCTL01_rec.Department <> *blanks;
      Statement += ' where department = ?';
   endif;

   select;
      when ioCTL01_rec.SortOption = SortByDepartment;
         Statement += ' order by department, name';
      when ioCTL01_rec.SortOption = SortByClock;
         Statement += ' order by clock';
      other;
         Statement += ' order by name';
   endsl;

   Statement += ' optimize for ' + %char(SFL01_PageSize) + ' rows';

   exec sql  close Inp;

   exec sql  prepare x from :Statement;
   if SqlState >= c_SQL_EOD;
      ouScreen01_rec.Message = '10: SQL failed with state ' + SQLState + '.';
      return;
   endif;

   exec sql  declare Inp cursor for x;
   if SqlState >= c_SQL_EOD;
      ouScreen01_rec.Message = '20: SQL failed with state ' + SQLState + '.';
      return;
   endif;

   if ioCTL01_rec.Department = *blanks;
   exec sql open Inp;
      if SqlState >= c_SQL_EOD;
         ouScreen01_rec.Message = '30: SQL failed with state ' + SQLState + '.';
         return;
   endif;
   else;
      Department = ioCTL01_rec.Department;
      exec sql  open Inp using :Department;
      if SqlState >= c_SQL_EOD;
         ouScreen01_rec.Message = '35: SQL failed with state ' + SQLState + '.';
         return;
      endif;
   endif;

   LoadOnePage (ouSize: ouEndOfData: ouScreen01_rec);
   ioCTL01_rec.SFLRCDNBR = ouSize;

end-proc  LoadFirstPage;

dcl-proc LoadOnePage;

   dcl-pi *n;
      ioSize          like(RRN01);
      ioEndOfData     ind;
      ouScreen01_rec  likeds(SCREEN01_rec_t);
   end-pi;

   dcl-ds  SFL01_rec    likeds(SFL01_rec_t)  inz;

   dcl-ds  DataArray  qualified    dim(SFL01_PageSize);
      clock       packed( 5);
      name        char  (16);
      department  char  ( 2);
      type        char  ( 1);
   end-ds;

   dcl-s   Ndx          uns(5);

   if ioEndOfData;
      return;
   endif;

   RRN01 = ioSize;

   exec sql  fetch Inp for :SFL01_PageSize rows into :DataArray;
   if SqlState > c_SQL_EOD;
      ouScreen01_rec.Message = '40: SQL failed with state ' + SQLState + '.';
      return;
   endif;

   ioEndOfData = (SqlState >= c_SQL_EOD);

   for Ndx = 1 to sqler3;
      eval-corr  SFL01_rec = DataArray (Ndx);
      RRN01 += 1;
      write  Display.SFL01   SFL01_rec;
   endfor;

   ioSize = RRN01;

end-proc LoadOnePage;