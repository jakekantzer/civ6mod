@echo off
echo Updating repository...
git fetch --all
git reset --hard origin/master
git clean -fd -e update.bat
echo.
echo Update complete!
pause