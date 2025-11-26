@echo off
REM ====================================================================
REM E-Farm Quick Launcher - Simple One-Click Start
REM ====================================================================
cd /d "%~dp0Efarm"

cls
echo ========================================
echo  E-Farm Application
echo ========================================
echo.
echo Starting application...
echo.

REM Compile with MySQL connector
javac -cp "lib/mysql-connector-j-9.5.0.jar" -d build/classes src/efarm/models/*.java src/efarm/util/*.java src/efarm/auth/*.java src/efarm/database/*.java src/efarm/ui/*.java src/efarm/ui/panels/*.java src/efarm/*.java 2>nul

REM Copy resources
xcopy /E /I /Y src\Images build\classes\Images >nul 2>&1

REM Launch application with MySQL connector in classpath
java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" efarm.ui.LoginForm

echo.
echo Application closed.
pause

