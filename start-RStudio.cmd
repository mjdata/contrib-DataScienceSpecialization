@SetLocal ENABLEEXTENSIONS
:: INSTRUCTIONS
:: This is a Windows batch file. Use it to start RStudio.
:: This file addresses the following cases:
:: 1. At startup RStudio 0.98.994 (released July 2014) prints error messages
::    indicating that it can't load two of its libraries.
:: 2. You want to preset the RStudio working directory to the folder where
::    you keep your .RData and .R code files.
:: 3. You want to run file.download() with method="curl" as typically used
::    in the lecture notes.
:: 4. You want to set the RStudio font family and size.
:: 
:: INSTALLATION
:: In your DataScienceSpecialization folder create folders "setup" and
:: "code". Put the setup files of R and RStudio in folder "setup". Put
:: this file there too. Folder "code" holds your R programs and saved
:: R/RStudio session data files ".RData" and ".RHistory".
:: See the picture below. If you are doing this for the first time you
:: might not have files .RData, .RHistory, and .some_program.R in there.
:: That's OK.
:: 
:: +DataScienceSpecialization\
:: |__+code\
:: |  |__.RData
:: |  |__.RHistory
:: |  |__.some_program.R
:: |__+setup\
::    |__R-3.1.1-win.exe
::    |__RStudio-0.98.994.exe
::    |__start-RStudio.cmd
::    |__desktop.ini   (see NOTES)
:: 
:: USAGE
:: Open your "DataScienceSpecialization" folder. Go to folder "setup".
:: If you need to install R and RStudio do so now.
:: Double click file "start-RStudio.cmd" to launch RStudio.
::
:: NOTES
:: File desktop.ini is optional. If found it is copied to the
:: RStudio folder in Windows user's profile folder to set the
:: base font family and size.
:: To customize this script look for tag CUSTOMIZE in the source file.
::
:: ^^^ Scroll up this window if you can't read the INSTRUCTIONS ^^^
@echo on
@"%SystemRoot%\system32\findStr.exe" /bl /c:"::" "%~dpnx0"
@echo off
echo Press any key to continue or Ctrl+C to terminate...
pause >nul

REM >>> CUSTOMIZE <<<
REM Enable support for method="curl" in file.download().
REM Download curl from http://curl.haxx.se/download.html.
REM Get a win32-Generic or win64-Generic package, uncompress it in a folder
REM of your choice, and append the folderpath to variable PATH as shown below.
set PATH=%PATH%;P:\tipi\bin\curl

REM Copy RStudio desktop.ini, if any, to Windows user's profile.
REM You may remove "/-y " after "copy " to disable copy prompts.
REM
REM Note: The script attempts a two-way copy: first copy desktop.ini, if any,
REM from the Windows profile folder to this folder for backup purposes;
REM then copy desktop.ini from this folder to the Windows profile folder to
REM initialize RStudio. If you have just installed RStudio the Windows profile
REM folder is empty, so the first copy is silently skipped.
set p="%USERPROFILE%\Application Data\RStudio\desktop.ini"
set h="%~dp0desktop.ini"
set t="%TEMP%\%~n0-%RANDOM%.tmp"
if not exist %p% goto :files_are_different
if not exist %h% goto :files_are_different
"%SystemRoot%\system32\fc.exe" /u %p% %h% > %t%
if %errorlevel% == 0 goto :done_desktop_ini
type %t%
:files_are_different
mkdir "%USERPROFILE%\Application Data\RStudio"
REM save profile to here on restarting
if exist %p% ( echo [GET PROFILE] & copy /-y %p% %h% )
REM save here to profile on starting
if exist %h% ( echo [PUT PROFILE] & copy /-y %h% %p% )
goto :done_desktop_ini
:done_desktop_ini
if exist %t% del %t%
set p=
set h=
set t=

REM Fix RStudio 0.98.994 unable to load its two libraries when
REM the system command shell isn't cmd.exe.
set ComSpec=%SystemRoot%\system32\cmd.exe

REM Like setwd("..\code") relative to the location of this this batch file.
set RS_INITIAL_WD=%~dp0..\code
%~d0
cd "%RS_INITIAL_WD%"
set RS_INITIAL_WD=%CD%

REM Equivalent to the way RStudio desktop icon starts RStudio .
start "starting..." /D"%ProgramFiles%\RStudio" "%ProgramFiles%\RStudio\bin\rstudio.exe"
