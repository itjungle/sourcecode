     H option(*srcstmt: *nodebugio) dftactgrp(*no) actgrp(*new)

     FWHS0020D  cf   e             workstn sfile(S1: RRN1)
     FWarehouse1uf a e           k disk

     D Reload          s               n   inz(*on)

     D RRN1            s              4s 0
     D Size1           s                   like(RRN1)

     D PSDS           sds
     D  PgmName                      10A   overlay(PSDS: 1)

        *inlr = *on;

        dow '1';
           if reload;
              LoadS1 ();
           endif;

           *in61 = *on;
           *in62 = (Size1 > *zero);
           *in63 = *off;

           Screen = %trimr(PgmName) + '-C1';
           Options = '2=Change, 5=Display';

           write S2;
           exfmt C1;

           select;
              when *in03;
                 leave;
              when *in05;
                 reload = *on;
              other;
                 ProcessS1 ();
           endsl;

        enddo;
        return;

        dcl-proc  LoadS1;

           *in61 = *off;
           *in62 = *off;
           *in63 = *on;
           write C1;
           *in63 =*off;

           RRN1 = *zero;

           setll *loval  warehouse;
           dow '1';
              read warehouse;
              if %eof();
                 leave;
              endif;
              RRN1 += 1;
              write s1;
           enddo;

           Size1  = RRN1;
           Reload = *off;

        end-proc  LoadS1;

        dcl-proc  ProcessS1;

           dow '1';
              readc S1;
              if %eof();
                 leave;
              endif;

              select;
                 when Option = '2';
                    chain   ID warehouse;
                    if %found();
                       exfmt W1;
                    else;
                       // should never happen
                       // do error routine
                    endif;
                    if not *in12;
                       update warehouse;
                    endif;
                 when Option = '5';
                    chain(n) ID warehouse;
                    if %found();
                       exfmt W1;
                    else;
                       // should never happen
                       // do error routine
                    endif;
              endsl;

              clear Option;
              update S1;

           enddo;

        end-proc  ProcessS1; 