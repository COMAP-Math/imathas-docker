@echo off
setlocal

:: Get the command line parameters
set PARAMETERS=%*

:: Invoke Git Bash and pass the parameters to make
"C:\Program Files\Git\bin\bash.exe" -c "make %PARAMETERS%"

endlocal
