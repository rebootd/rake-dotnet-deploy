@echo off
call check-deps.bat
ECHO Are you sure you want to deploy to production portal? (Y/N)
set /p Input=
if /i "%Input%"=="y" (goto Proceed)
exit /b

:Proceed
rake proddeploy
pause