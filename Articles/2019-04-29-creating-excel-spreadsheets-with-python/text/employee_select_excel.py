# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script : employee_select_excel.py
# Author: Mike Larsen
# Date written: 04/07/19
# Purpose: Select records from the employee table and export into Excel.
#
# ====================================================================*
# Date      Programmer  Description                                   *
#---------------------------------------------------------------------*
# 04/07/19  M.Larsen    Original code.                                *
#                                                                     *
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  * 

import ibm_db_dbi as db2 
from xlsxwriter import Workbook

conn = db2.connect()

cursor = conn.cursor()

salaryStart = 25000.00
salaryEnd   = 75000.00

query = ("Select Empno, FirstNme, LastName, Job, Salary from sample.employee "
         "Where Salary between ? and ? ")
       
cursor.execute(query, (salaryStart, salaryEnd))

#---------------------------------------------------------------------
# create the lists
#---------------------------------------------------------------------
 
employeeNumbers = []
firstNames      = []
lastNames       = []
jobTitles       = []
salaries        = []

#---------------------------------------------------------------------
# loop thru and load the lists
#---------------------------------------------------------------------

for row in cursor:
    employeeNumbers.append(row[0])
    firstNames.append(row[1])
    lastNames.append(row[2])
    jobTitles.append(row[3])
    salaries.append(row[4])
    
#---------------------------------------------------------------------

with Workbook('employee_listing.xlsx') as workbook:

    #-----------------------------------------------------------------
    # Set some properties to the workbook.
    #-----------------------------------------------------------------

    workbook.set_properties({
    'title': 'This is an example spreadsheet',
    'subject': 'With document properties',
    'author': 'Mike Larsen',
    'manager': 'Lexie',
    'company': 'Central Park Data Systems',
    'category': 'Example spreadsheets',
    'keywords': 'Sample, Example, Properties',
    'comments': 'Created with Python and XlsxWriter',
    'status': 'Final',
    })

    #-----------------------------------------------------------------
    # Set up some formatting and text to highlight the panes.
    #-----------------------------------------------------------------

    header_format = workbook.add_format({'bold': True,
                                         'align': 'center',
                                         'valign': 'vcenter',
                                         'fg_color': '#D7E4BC',
                                         'border': 1})

    center_format = workbook.add_format({'align': 'center'})
    
    money_format  = workbook.add_format({'num_format': '$#,##0.00'})
    
    bold_format   = workbook.add_format({'bold': True})

    #-----------------------------------------------------------------
    # I'm adding two worksheets. the second one is just to show how I 
    # can change the tab colors.
    #-----------------------------------------------------------------
    
    ws  = workbook.add_worksheet()
    ws2 = workbook.add_worksheet()
    
    #---------------------------------------------------------------------
    # write the lists to columns
    
    ws.write_column('A2', employeeNumbers)
    ws.write_column('B2', firstNames)
    ws.write_column('C2', lastNames)
    ws.write_column('D2', jobTitles)
    ws.write_column('E2', salaries, money_format)

    ws.freeze_panes(1, 0)
    
    # Other sheet formatting.
    
    ws.set_column('A:E', 16)           # Columns A-E width set to 16.
    ws.set_row(0, 20)                  # Set the height of Row 1 to 20
    ws.set_selection('C3')             # default selected column/row

    # row, column, text, format
    
    ws.write(0, 0, 'Employee number', header_format)
    ws.write(0, 1, 'First name', header_format)
    ws.write(0, 2, 'Last name', header_format)
    ws.write(0, 3, 'Job title', header_format)
    ws.write(0, 4, 'Salary', header_format)

    #-----------------------------------------------------------------
    # Set tab colors
    #-----------------------------------------------------------------
    
    ws.set_tab_color('green')
    ws2.set_tab_color('red')

    #-----------------------------------------------------------------
    # conditional formatting
    #-----------------------------------------------------------------

    # Add a format. Light red fill with dark red text.
    
    format1 = workbook.add_format({'bg_color': '#FFC7CE',
                                   'font_color': '#9C0006'})
    
    # Add a format. Green fill with dark green text.
    
    format2 = workbook.add_format({'bg_color': '#C6EFCE',
                                   'font_color': '#006100'})

    # Write a conditional format over a range. if salary >= $44,000.00
    
    ws.conditional_format('E2:E26', {'type': 'cell',
    'criteria': '>=',
    'value': 44000,
    'format': format1})

    # Write another conditional format over the same range. if salary < $44,000.00
    
    ws.conditional_format('E2:E26', {'type': 'cell',
    'criteria': '<',
    'value': 44000,
    'format': format2})
    
    #-----------------------------------------------------------------

cursor.close()
conn.close()