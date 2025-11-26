@echo off
REM E-Farm Database Setup Script
REM Run this first to create the database and tables

cd /d "%~dp0Efarm"

echo Compiling DatabaseSetup...
javac -cp "lib/mysql-connector-j-9.5.0.jar" -d build/classes src/efarm/util/DatabaseSetup.java src/efarm/util/DatabaseConnection.java

echo Running Database Setup...
java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" efarm.util.DatabaseSetup

pause

