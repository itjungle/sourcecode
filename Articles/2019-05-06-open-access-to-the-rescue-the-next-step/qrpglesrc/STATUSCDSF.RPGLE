       // Copyright (c) 2011-2016 Partner400
       // All rights reserved.
       //
       // Redistribution and use in source and binary forms, with or without
       // modification, are permitted provided that the following conditions
       // are met:
       // 1. Redistributions of source code must retain the above copyright
       //    notice, this list of conditions and the following disclaimer.
       // 2. Redistributions in binary form must reproduce the above copyright
       //    notice, this list of conditions and the following disclaimer in the
       //    documentation and/or other materials provided with the distribution.
       //
       // THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ''AS IS'' AND
       // ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
       // IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
       // ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
       // FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
       // DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
       // OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
       // HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
       // LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
       // OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
       // SUCH DAMAGE.
       //


       Dcl-C stsOK              00000;  // No error.

       Dcl-C stsPgmRetLR        00001;  // Called program returned with *INLR on.

       Dcl-C stsFkeyPressed     00002;  // Function key pressed.

       Dcl-C stsEOF             00011;  // End of file (%EOF = *ON).

       Dcl-C stsNotFnd          00012;  // Record not found (%FOUND = *OFF).

       Dcl-C stsWrtSflFull      00013;  // Write to full subfile.

       Dcl-C stsCvtSubst        00050;  // Conversion resulted in substitution.

       Dcl-C errInvalString     00100;  // String operation, value out of range.

       Dcl-C errNegSqrt         00101;  // Negative square root.

       Dcl-C errDivZero         00102;  // Divide by zero.

       Dcl-C errResultTooSmall  00103;  // Intermediate result too small to contain result.

       Dcl-C errFltUndflow      00104;  // Float underflow. Intermediate value too small.

       Dcl-C errInNumConv       00105;  // Invalid characters in character to numeric conversion

       Dcl-C errInvalDate       00112;  // Invalid date, time, or timestamp value.

       Dcl-C errDateOvflow      00113;  // Date overflow or underflow.

       Dcl-C errDateMap         00114;  // Date mapping error.

       Dcl-C errInvalVarLen     00115;  // Invalid length for variable-length field.

       Dcl-C errArrSeq          00120;  // Table or array out of sequence.

       Dcl-C errArrIdx          00121;  // Invalid array index.

       Dcl-C errInvalOccur      00122;  // OCCUR value out of range.

       Dcl-C errInzReset        00123;  // RESET attempted during initialization.

       Dcl-C errCallFail        00202;  // Call to program or procedure ended in error.

       Dcl-C errCall            00211;  // Error occurred while calling program or procedure.

       Dcl-C errParmNoPass      00221;  // Called program tried to use unpassed parameter.

       Dcl-C errPtrParm         00222;  // Pointer or parameter error.

       Dcl-C errCallHalt        00231;  // Called program returned with halt indicator on.

       Dcl-C errHalt            00232;  // 00232 Halt indicator on in this program.

       Dcl-C errHaltRtn         00233;  // 00233 Halt indicator on when RETURN operation run.

       Dcl-C errDumpFail        00299;  // 00299 RPG dump failed.

       Dcl-C errMthCall         00301;  // 00301 Error in method call.

       Dcl-C errCvtJavArrEnt    00302;  // 00302 Error converting Java array to RPG parm on entry

       Dcl-C errCvtRpgPrmOut    00303;  // 00303 Error converting RPG parm to Java array on exit

       Dcl-C errCvtRPGtoJavaArr 00304;  // 00304 Error converting RPG parm to Java array during prep

       Dcl-C errCvtJavArrToRPG  00305;  // 00305 Error cvting Java array to RPG parm/return value

       Dcl-C errcvtRpgRtnVal    00306;  // 00306 Error converting RPG return value to Java array.

       Dcl-C errDsply           00333;  // 00333 Error on DSPLY operation.

       Dcl-C errDataAreaNotFnd  00401;  // 00401 Data area not found.

       Dcl-C errInvalPsjPDA     00402;  // 00402 *PDA not valid for non-prestart job.

       Dcl-C errInvalDataArea   00411;  // 00411 Data area types/lengths do not match.

       Dcl-C errDataAreaNoOutp  00412;  // 00412 Data area not allocated for output.

       Dcl-C errDataAreaIO      00413;  // 00413 I/O error while processing data area.

       Dcl-C errDataAreaUseAut  00414;  // 00414 Not authorized to use data area.

       Dcl-C errDataAreaChgAut  00415;  // 00415 Not authorized to change data area.

       Dcl-C errDataAreaUnlFail 00421;  // 00421 Error while unlocking data area.

       Dcl-C errInvalAlloc      00425;  // 00425 Requested storage allocation length out of range.

       Dcl-C errStorFail        00426;  // 00426 Error during storage management operation.

       Dcl-C errDataAreaAlloc   00431;  // 00431 Data area previously allocated to another process.

       Dcl-C errDataAreaLock    00432;  // 00432 *LOCK for data area not granted.

       Dcl-C errInvalSosi       00450;  // 00450 Character field not enclosed by SO and SI.

       Dcl-C errCvtCcsid        00451;  // 00451 Cannot convert between two CCSIDs.

       Dcl-C errSortRtv         00501;  // 00501 Sort sequence not retrieved.

       Dcl-C errSortCvt         00502;  // 00502 Sort sequence not converted.

       Dcl-C errCmtNact         00802;  // 00802 Commitment control not active.

       Dcl-C errRolbkFail       00803;  // 00803 Rollback failed.

       Dcl-C errCmt             00804;  // 00804 COMMIT error.

       Dcl-C errRolbk           00805;  // 00805 ROLBK error.

       Dcl-C errDecimal         00907;  // 00907 Decimal data error.

       Dcl-C errCompLevChk      00970;  // 00970 Compiler/runtime level check.

       Dcl-C errUndefRecTyp     01011;  // 01011 Undefined record type.

       Dcl-C errRecExists       01021;  // 01021 Record already exists.

       Dcl-C errRefCst          01022;  // 01022 Referential constraint error.

       Dcl-C errTrgBefore       01023;  // 01023 Trigger program error before operation.

       Dcl-C errTrgAfter        01024;  // 01024 Trigger program error after operation.

       Dcl-C errMatchSeq        01031;  // 01031 Match field sequence error.

       Dcl-C errLoadArr         01041;  // 01041 Array/table load sequence error.

       Dcl-C errArrAltSeq       01042;  // 01042 Array/table load sequence error.

       Dcl-C errArrOvflow       01051;  // 01051 Excess entries in array/table file.

       Dcl-C errInvalRecSeq     01071;  // 01071 Record out of sequence.

       Dcl-C errDDSPrtKey       01121;  // 01121 No Print Key DDS keyword indicator.

       Dcl-C errDDSPgDn         01122;  // 01122 No Page Down Key DDS keyword indicator.

       Dcl-C errDDSPgUp         01123;  // 01123 No Page Up Key DDS keyword indicator.

       Dcl-C errDDSClrKey       01124;  // 01124 No Clear Key keyword indicator.

       Dcl-C errDDSHlpKey       01125;  // 01125 No Help Key DDS keyword indicator.

       Dcl-C errDDSHomeKey      01126;  // 01126 No Home Key DDS keyword indicator.

       Dcl-C errInpMisMatch     01201;  // 01201 Record mismatch detected on input.

       Dcl-C errIOClosed        01211;  // 01211 I/O operation to a closed file.

       Dcl-C errAlreadyOpen     01215;  // 01215 OPEN issued to already open file.

       Dcl-C errImpOpenClose    01216;  // 01216 Error on implicit OPEN/CLOSE.

       Dcl-C errExpOpenClose    01217;  // 01217 Error on explicit OPEN/CLOSE.

       Dcl-C errRcdLocked       01218;  // 01218 Unable to allocate record.

       Dcl-C errUpdNoRead       01221;  // 01221 Update/delete operation without a prior read.

       Dcl-C errRefCstAlloc     01222;  // 01222 Referential constraint allocation error.

       Dcl-C errSpecial         01231;  // 01231 Error on SPECIAL file.

       Dcl-C errPrtCtl          01235;  // 01235 Error in PRTCTL space or skip entries.

       Dcl-C errRecNbrNotFnd    01241;  // 01241 Record number not found.

       Dcl-C errPermIO          01251;  // 01251 Permanent I/O error.

       Dcl-C errSessDev         01255;  // 01255 Session or device error.

       Dcl-C errMaxDev          01261;  // 01261 Attempt to exceed maximum number of devices.

       Dcl-C errDevUnavail      01271;  // 01271 Attempt to acquire unavailable device.

       Dcl-C errDevUnacq        01281;  // 01281 Operation to unacquired device.

       Dcl-C errJobEndCtl       01282;  // 01282 Job ending with controlled option.

       Dcl-C errAcqAddDev       01284;  // 01284 Unable to acquire second device.

       Dcl-C errDevAlloc        01285;  // 01285 Attempt to acquire an allocated device.

       Dcl-C errShrOpn          01286;  // 01286 Attempt to open shared file with SAVDS or SAVIND.

       Dcl-C errRespInd         01287;  // 01287 Response indicators overlap SAVIND indicators.

       Dcl-C errIO              01299;  // 01299 I/O error detected.

       Dcl-C errWait            01331;  // 01331 Wait time exceeded for WORKSTN file.

       Dcl-C errIntRPGFail      09998;  // 09998 Internal failure in RPG compiler runtime

       Dcl-C errPgmExc          09999;  // 09999 Program exception in system routine.
