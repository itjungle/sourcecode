     H option(*srcstmt: *nodebugio) dftactgrp(*no) actgrp(*new)
     H main(WHS02R_Main)

     FDisplay   cf   e             workstn qualified
     F                                     extdesc('WHS0010D')
     F                                     extfile(*extdesc)
     F                                     sfile(S1: RRN1)
     F                                     indds(WsInd)
     F                                     usropn

     FW         uf a e           k disk    qualified
     F                                     extdesc('WAREHOUSE1')
     F                                     extfile(*extdesc)
     F                                     usropn

       dcl-ds S1_t   likerec(Display.S1: *all)    template;
       dcl-ds C1_t   likerec(Display.C1: *all)    template;
       dcl-ds S2_t   likerec(Display.S2: *all)    template;
       dcl-ds W1_t   likerec(Display.w1: *all)    template;

       dcl-ds Warehouse_t  likerec(W.Warehouse: *all)    template;

     D WsInd           ds            99    qualified
     D  ExitKey                       1n   overlay(WsInd:  3)
     D  RefreshKey                    1n   overlay(WsInd:  5)
     D  CancelKey                     1n   overlay(WsInd: 12)
     D  SflDspCtl                     1n   overlay(WsInd: 61)
     D  SflDsp                        1n   overlay(WsInd: 62)
     D  SflClr                        1n   overlay(WsInd: 63)

       //dcl-ds  WsInd    len(99)  qualified;
       //   ExitKey       ind      pos( 3);
       //   RefreshKey    ind      pos( 5);
       //   CancelKey     ind      pos(12);
       //   SflDspCtl     ind      pos(61);
       //   SflDsp        ind      pos(62);
       //   SflClr        ind      pos(63);
       //end-ds  WsInd;

     D Reload          s               n   inz(*on)

     D RRN1            s              4s 0
     D Size1           s                   like(RRN1)

     D PSDS           sds
     D  PgmName                      10A   overlay(PSDS: 1)

        dcl-proc  WHS02R_Main;

        dcl-ds C1_rec   likeds(C1_t);
        dcl-ds S2_rec   likeds(S2_t);

        open Display;
        open W;

        dow '1';
           if reload;
              LoadS1 ();
           endif;

           WsInd.SflDspCtl = *on;
           WsInd.SflDsp    = (Size1 > *zero);
           WsInd.sflClr    = *off;

           C1_rec.Screen = %trimr(PgmName) + '-C1';
           C1_rec.Options = '2=Change, 5=Display';

           write  Display.S2  S2_rec;
           exfmt  Display.C1  C1_rec;

           select;
              when WsInd.ExitKey;
                 leave;
              when WsInd.RefreshKey;
                 reload = *on;
              other;
                 ProcessS1 ();
           endsl;

        enddo;

        close *all;

        return;

        end-proc  WHS02R_Main;

        dcl-proc  LoadS1;

           dcl-ds C1_rec    likeds(C1_t);
           dcl-ds S1_rec    likeds(S1_t);
           dcl-ds Whs_rec   likeds(Warehouse_t);

           WsInd.SflDspCtl   = *off;
           WsInd.SflDsp      = *off;
           WsInd.SflClr      = *on;
           write  Display.C1  C1_rec;
           WsInd.SflClr    =*off;

           RRN1 = *zero;

           setll *loval  W.warehouse;
           dow '1';
              read  W.Warehouse  Whs_rec;
              if %eof();
                 leave;
              endif;
              RRN1 += 1;
              eval-corr S1_rec = Whs_rec;
              write  Display.s1  S1_rec;
           enddo;

           Size1  = RRN1;
           Reload = *off;

        end-proc  LoadS1;

        dcl-proc  ProcessS1;

           dcl-ds S1_rec    likeds(S1_t);
           dcl-ds W1_rec    likeds(W1_t);
           dcl-ds Whs_rec   likeds(Warehouse_t);

           dow '1';
              readc Display.S1 S1_rec;
              if %eof();
                 leave;
              endif;

              select;
                 when S1_rec.Option = '2';
                    chain   S1_rec.ID W.Warehouse Whs_rec;
                    if %found();
                       eval-corr  W1_rec = Whs_rec;
                       exfmt Display.W1 W1_rec;
                    else;
                       // should never happen
                       // do error routine
                    endif;
                    if not WsInd.CancelKey;
                       eval-corr  Whs_rec = W1_rec;
                       update W.Warehouse Whs_rec;
                       eval-corr  S1_rec = W1_rec;
                    endif;
                 when S1_rec.Option = '5';
                    chain(n) S1_rec.ID W.Warehouse Whs_rec;
                    if %found();
                       eval-corr  W1_rec = Whs_rec;
                       exfmt Display.W1 W1_rec;
                    else;
                       // should never happen
                       // do error routine
                    endif;
              endsl;

              clear S1_rec.Option;
              update Display.S1 S1_rec;

           enddo;

        end-proc  ProcessS1; 