@echo off
echo ========================================
echo  Testing farmer_details Table
echo ========================================
echo.

cd Efarm
javac -cp "lib/mysql-connector-j-9.5.0.jar;." -d build/classes src/TestFarmerDetails.java
if errorlevel 1 (
    echo [ERROR] Compilation failed!
    pause
    exit /b 1
)

java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" TestFarmerDetails
pause

