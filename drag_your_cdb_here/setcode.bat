@echo off
if %1== goto end
cd /d %1\..
if exist "%~n1_setcode.db3" del "%~n1_setcode.db3"
copy "%~nx1" "%~n1_setcode.db3"
cd /d %0\..
sqlite3 "%~dpn1_setcode.db3" ".read setcode.sql"
:end
