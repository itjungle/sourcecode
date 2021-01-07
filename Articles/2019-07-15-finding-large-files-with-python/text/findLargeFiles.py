# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script : findLargeFiles.py
# Author: Mike Larsen
# Date written: 06/30/19
# Purpose: - Find large files in the IFS
#          - Show attributes of the file including a formatted date
#          - Delete the file
#
# ====================================================================*
# Date      Programmer  Description                                   *
#---------------------------------------------------------------------*
# 06/30/19  M.Larsen    Original code.                                *
#                                                                     *
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  * 

from datetime import datetime
import os
import fnmatch

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# date conversion function
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # %d - Day of the month as a zero-padded decimal number
  # %b - Month as locale’s abbreviated name
  # %Y - Year with century as a decimal number.

def convert_date(timestamp):
    d = datetime.utcfromtimestamp(timestamp)
    formatted_date = d.strftime('%d %b %Y')
    
    return formatted_date 
    
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

dir_entries = os.scandir('/home/MLARSEN/test_folder/')

for entry in dir_entries:
   if entry.is_file():
   	
      if fnmatch.fnmatch(entry.name, '*.txt'):   
      		
         info = entry.stat()
         
         # I just picked an arbitrary file size for which to look
         
         if info.st_size > 207:
            print(f'{entry.path}\t {entry.name}\t Last Modified: {convert_date(info.st_mtime)}\t Size in bytes: {info.st_size}')
            
            os.remove(entry.path)
            