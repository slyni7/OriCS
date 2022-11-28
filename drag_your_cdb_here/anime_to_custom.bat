if %1== goto end
cd /d %0\..
sqlite3 "%~f1" ".read anime_to_custom.sql"
:end
