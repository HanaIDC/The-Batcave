@echo off
REM ====================================================================
REM E-Farm Application - One-Click Database Setup & Launch
REM ====================================================================
REM This script:
REM 1. Checks if MySQL is running
REM 2. Sets up the database if needed
REM 3. Compiles the application with MySQL connector
REM 4. Launches the Login Form
REM ====================================================================

SETLOCAL EnableDelayedExpansion
cd /d "%~dp0"

echo.
echo ========================================
echo  E-Farm Application Launcher
echo ========================================
echo.

REM ====================================================================
REM Step 1: Check if MySQL is running
REM ====================================================================
echo [1/5] Checking MySQL service...
echo.

REM Try to connect to MySQL to check if it's running
mysql -u root -e "SELECT 1;" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] MySQL is running!
) else (
    echo [WARNING] MySQL is not responding!
    echo.
    echo Please ensure MySQL is running:
    echo - Open XAMPP Control Panel
    echo - Click "Start" on MySQL module
    echo - Wait a few seconds
    echo.
    echo Attempting to start MySQL via XAMPP...

    REM Try common XAMPP installation paths
    if exist "C:\xampp\xampp_start.exe" (
        start "" "C:\xampp\xampp-control.exe"
        echo XAMPP Control Panel launched. Please start MySQL manually.
        timeout /t 5 /nobreak >nul
    ) else if exist "C:\Program Files\XAMPP\xampp-control.exe" (
        start "" "C:\Program Files\XAMPP\xampp-control.exe"
        echo XAMPP Control Panel launched. Please start MySQL manually.
        timeout /t 5 /nobreak >nul
    ) else (
        echo Could not find XAMPP. Please start MySQL manually.
    )

    echo.
    echo Press any key once MySQL is running, or Ctrl+C to cancel...
    pause >nul
)

echo.

REM ====================================================================
REM Step 2: Check and setup database
REM ====================================================================
echo [2/5] Checking database setup...
echo.

REM Check if database exists
mysql -u root -e "USE efarm_db;" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Database 'efarm_db' exists!
) else (
    echo [INFO] Database 'efarm_db' not found. Creating...

    REM Check if schema file exists
    if exist "Efarm\database\schema.sql" (
        echo Creating database from schema...
        mysql -u root < "Efarm\database\schema.sql"
        if !errorlevel! equ 0 (
            echo [OK] Database created successfully!
        ) else (
            echo [ERROR] Failed to create database!
            echo Please run setup-database.bat manually.
            pause
            exit /b 1
        )
    ) else (
        echo [INFO] Schema file not found. Creating basic database...
        mysql -u root -e "CREATE DATABASE IF NOT EXISTS efarm_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        echo [OK] Basic database created!
        echo [WARNING] You may need to run the full schema setup later.
    )
)

echo.

REM ====================================================================
REM Step 3: Verify MySQL Connector JAR
REM ====================================================================
echo [3/5] Verifying MySQL connector library...
echo.

if exist "Efarm\lib\mysql-connector-j-9.5.0.jar" (
    echo [OK] MySQL connector found!
) else (
    echo [ERROR] MySQL connector JAR not found!
    echo Expected location: Efarm\lib\mysql-connector-j-9.5.0.jar
    echo.
    echo Please download MySQL Connector/J from:
    echo https://dev.mysql.com/downloads/connector/j/
    pause
    exit /b 1
)

echo.

REM ====================================================================
REM Step 4: Compile the application
REM ====================================================================
echo [4/5] Compiling application...
echo.

cd Efarm

REM Create build directories if they don't exist
if not exist "build\classes" mkdir "build\classes"

REM Compile all Java files
echo Compiling Java source files...
javac -cp "lib/mysql-connector-j-9.5.0.jar" -d build/classes ^
    src/efarm/models/*.java ^
    src/efarm/util/*.java ^
    src/efarm/auth/*.java ^
    src/efarm/database/*.java ^
    src/efarm/ui/*.java ^
    src/efarm/ui/panels/*.java ^
    src/efarm/*.java 2>compile-errors.txt

if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed! Check compile-errors.txt for details.
    type compile-errors.txt
    cd ..
    pause
    exit /b 1
) else (
    echo [OK] Compilation successful!
    if exist "compile-errors.txt" del "compile-errors.txt"
)

REM Copy image resources
echo Copying resources...
xcopy /E /I /Y src\Images build\classes\Images >nul 2>&1
echo [OK] Resources copied!

cd ..
echo.

REM ====================================================================
REM Step 5: Launch the application
REM ====================================================================
echo [5/5] Launching E-Farm Login Form...
echo.
echo ========================================
echo  Starting Application...
echo ========================================
echo.

cd Efarm
java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" efarm.ui.LoginForm

REM Check exit code
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo  Application exited with errors
    echo ========================================
    echo.
    cd ..
    pause
    exit /b 1
)

cd ..
echo.
echo ========================================
echo  Application closed
echo ========================================
echo.
pause

