           /****************************************************/
           /*  (c) Copyright Cozzi Productions, Inc. 2020      */
           /*  All rights reserved.                            */
           /****************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdarg.h>
#include <qusec.h>
#include <cpybytes.mih>
#include <triml.mih>

#include <except.h>
#include <qp0ztrc.h>
#include <qp0z1170.h>

#include <qusrmbrd.h>
#include <qdbrtvfd.h>

#include <iostream>
#include <sstream>
#include <fstream>
#include <algorithm>

#include <string>

using namespace std;

typedef _Packed struct qtf
{
    char  file[10];
    char  library[10];
} qualFile_T;

int main(int argc, char* argv[])
{

        std::ifstream  ifsFile;
        std::ofstream  db2File;
        std::string    inFile;
        std::string    outFile;
        std::string    mbrName;
        Qdb_Mbrd0100_t mbrDesc;
        char           overrides = '1';
        char           findMbr   = '1';
        char           stmf[640];
        Qus_EC_t  ec;
        Qdb_Qddfmt_t   fmtInfo;

        memset((char*)&fmtInfo,0x00,sizeof(fmtInfo));

        char line[4096];
        long  rcdLen   = 0;
        int  bStmf     = 0;
        int  bytesRead = 0;
        qualFile_T     rtnFileLib;
        qualFile_T     dbf;
        char           mbr[10];

        if (argc < 3)
        {
          Qp0zLprintf("syntax: copyifs \
           (\'/ifsfolder/file.txt\' \'/QSYS.LIB/mylib.lib/myfile.file/mymbr.mbr\')");
          return 1;
        }
        //  Parameter Sequence:
        // 1 = Source IFS Stream file
        // 2 = Qualified Db2 File name and library
        // 3 = Member Name (blank if none specified)
        // 4 = /QSYS.LIB Db2 File name if FILE(*STMF) is specified.

        memset((char*)&mbr, ' ', sizeof(mbr));
        memset((char*)&ec,0x00,sizeof(ec));
        ec.Bytes_Provided = sizeof(ec);

        if (argc >= 2) // Stmf Name
        {
          inFile.reserve(640);
          inFile.assign(argv[1],640);
          size_t len = inFile.find_first_of(' ');
          if (len != std::string::npos)
          {
            inFile.erase(len);
          }
        }
        if (argc >= 3)   // Qualified File Library
        {
          outFile.assign(argv[2],20);
        }
        // argc==4 is Member name
        if (argc >= 5)  // max record length to write to target file
        {
            rcdLen = *((short*) argv[4]);
        }
        if (stricmp(outFile.c_str(),"*STMF")==0 && argc >= 5)
        {
          outFile = argv[6];
          bStmf = true;
        }
        else
        {
          memset((char*)&dbf, ' ', sizeof(dbf));
          _CPYBYTES((char*)&dbf, outFile.c_str(), std::min<int>(sizeof(dbf),outFile.length()));
          if (argc >= 4)
          {
            mbrName.assign(argv[3],10);
            _CPYBYTES(mbr,argv[3],std::min<int>(sizeof(mbr),strlen(argv[3])));
          }
        }


       if (!bStmf)
       {
          if (mbr[0] =='*' || mbr[0]==' ' ||
              dbf.library[0]=='*' || dbf.library[0]==' ')
          {
              memset((char*)&ec, 0x00, sizeof(Qus_EC_t));
              ec.Bytes_Provided = sizeof(Qus_EC_t);
              memset((char*)&mbrDesc,0x00,sizeof(mbrDesc));
              if (memicmp(mbr,"*FILE",5)==0)
              {
                _CPYBYTES(mbr,dbf.file,sizeof(mbr));
              }
              else if (memicmp(mbr,"*ONLY",5)==0 ||
                       memicmp(mbr,"*FIRSTMBR",9)==0 ||
                       mbr[0] == ' ')
              {
                _CPYBYTES(mbr,"*FIRST",strlen("*FIRST"));
              }
              if (dbf.library[0]==' ')
              {
                _CPYBYTES(dbf.library,"*LIBL",strlen("*LIBL"));
              }
          }
          QUSRMBRD(&mbrDesc, sizeof(mbrDesc),"MBRD0100",&dbf,mbr,
                     &overrides,&ec,&findMbr);


          if (ec.Bytes_Available == 0)
          {
             if (rcdLen == 0)
             {
               QDBRTVFD((char *) &fmtInfo, sizeof(fmtInfo),
                        &rtnFileLib, "FILD0200",
                        &dbf, "*FIRST    ", &overrides,
                      "*LCL      ", "*EXT      ", &ec);
                if (ec.Bytes_Available == 0)
                {   // GET THE RECORD LENGTH
                   rcdLen = fmtInfo.Qddfrlen;
                }
              }
              char f[11];
              char l[11];
              char m[11];
              memset(f,0x00,sizeof(f));
              memset(l,0x00,sizeof(l));
              memset(m,0x00,sizeof(m));
              _CPYBYTES(f,mbrDesc.Db_File_Name,sizeof(mbrDesc.Db_File_Name));
              _CPYBYTES(l,mbrDesc.Db_File_Lib,sizeof(mbrDesc.Db_File_Lib));
              _CPYBYTES(m,mbrDesc.Member_Name,sizeof(mbrDesc.Member_Name));
              f[::triml(f, ' ')] = 0x00;
              l[::triml(l, ' ')] = 0x00;
              m[::triml(m, ' ')] = 0x00;
              sprintf(stmf,"/QSYS.LIB/%s.lib/%s.file/%s.mbr",l,f,m);
              outFile = stmf;
           }
       }

       ifsFile.open(inFile.c_str(),ios_base::_occsid | std::ifstream::in);

       std::transform(outFile.begin(), outFile.end(), outFile.begin(), ::toupper);
       db2File.open(outFile.c_str(), ios::out|ios::binary);

       if (ifsFile.is_open()) // if is open...
       {
         while (!ifsFile.eof())
         {
            ifsFile.getline(line,sizeof(line)-1);
            bytesRead = ifsFile.gcount();
            if (bytesRead > 0)
            {
              if (rcdLen > 0 && rcdLen < bytesRead)
              {
                 bytesRead = rcdLen;
              }
              else
              {
                 bytesRead--;
                 if (rcdLen > 0)
                 {  // pad the line to the full requested record length
                   if ( bytesRead < rcdLen)
                   {
                     memset(line+bytesRead,0x00, rcdLen - bytesRead);
                   }
                   bytesRead = rcdLen;
                 }
              }
              db2File.write( line, bytesRead );
            }
         }
       }
       ifsFile.close();
       db2File.close();
       return 0;
} 