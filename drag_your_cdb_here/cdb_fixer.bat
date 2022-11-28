if %1== goto end
cd /d %0\..
sqlite3 "%~f1" ".read cdb_fixer.sql"
:end
