ITJ Tip Source Bundle README for Open Access To The Rescue - The Next Step.

This package contains the following source members.

IFSWRTREC2

This is the updated version of the IFS handler program. It accepts a User Parameter which can be used to specify the file name to be used as well as the code page of the file and the line terminator.

Like the previous version, it can handle program described printer and disk files and to some extent externally described files of these types.


IFSUSRPARM

This is the /COPY file that defines the data structure template used to define the User Parameter.
 

TSTIFSWRT2

Sample test program for the IFSWRTREC2 handler. It outputs two different IFS files.


TSTIFSWRTC and TSTIFSWRT3

This combination demonstrates how parameter passing can be used to avoid having to use USROPN for files using the handler. TSTIFSWRTC is a simple program that sets up the parameter and then calls TSTIFSWRT3 to produce the IFS file.


CUSTMAST

SQL script to create and populate the CUSTMAST table used by the test program TSTIFSWRTH. If you created this file using the original tip's code package then you can ignore this file.


STATUSCDSF

This is the standard copy file I use for RPG stays codes. It is included by IFSWRTREC2.


OATEMLTFR

This is the latest version of my OA template program on which the handler IFSWRTREC2 is based.

 