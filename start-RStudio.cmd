@SetLocal ENABLEEXTENSIONS
:: INSTRUCTIONS
:: This is a Windows batch file. Use it to start RStudio.
:: This file addresses the following cases:
:: 1. At startup RStudio 0.98.994 (released July 2014) prints error messages
::    indicating that it can't load two of its libraries.
:: 2. You want to preset RStudio's working directory to the folder where you
::    keep your .RData and .R code files.
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
:: 
:: USAGE
:: Open your "DataScienceSpecialization" folder. Go to folder "setup".
:: If you need to install R and RStudio do so now.
:: Double click file "start-RStudio.cmd" to launch RStudio.
::
:: ^^^ Scroll up this window if you can't read the INSTRUCTIONS ^^^
@echo on
@"%SystemRoot%\system32\findStr.exe" /bl /c:"::" "%~dpnx0"
@echo off
pause

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
