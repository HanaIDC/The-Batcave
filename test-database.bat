@echo off
REM ====================================================================
REM Database Connection Tester
REM Tests if MySQL is accessible and database is ready
REM ====================================================================
cd /d "%~dp0Efarm"

echo ========================================
echo  Testing Database Connection
echo ========================================
echo.

REM Compile the database connection tester
echo Compiling test...
javac -cp "lib/mysql-connector-j-9.5.0.jar" -d build/classes src/efarm/util/DatabaseConnection.java src/efarm/models/User.java 2>nul

REM Create a simple test class
echo import efarm.util.DatabaseConnection; > build\classes\TestConnection.java
echo import java.sql.Connection; >> build\classes\TestConnection.java
echo public class TestConnection { >> build\classes\TestConnection.java
echo     public static void main(String[] args) { >> build\classes\TestConnection.java
echo         try { >> build\classes\TestConnection.java
echo             System.out.println("Testing MySQL JDBC Driver..."); >> build\classes\TestConnection.java
echo             Class.forName("com.mysql.cj.jdbc.Driver"); >> build\classes\TestConnection.java
echo             System.out.println("[OK] MySQL JDBC Driver loaded!"); >> build\classes\TestConnection.java
echo             System.out.println(""); >> build\classes\TestConnection.java
echo             System.out.println("Testing database connection..."); >> build\classes\TestConnection.java
echo             Connection conn = DatabaseConnection.getConnection(); >> build\classes\TestConnection.java
echo             System.out.println("[OK] Database connection successful!"); >> build\classes\TestConnection.java
echo             System.out.println(""); >> build\classes\TestConnection.java
echo             System.out.println("Database: efarm_db"); >> build\classes\TestConnection.java
echo             System.out.println("Host: localhost:3306"); >> build\classes\TestConnection.java
echo             System.out.println("Status: CONNECTED"); >> build\classes\TestConnection.java
echo             conn.close(); >> build\classes\TestConnection.java
echo         } catch (Exception e) { >> build\classes\TestConnection.java
echo             System.out.println("[ERROR] Connection failed!"); >> build\classes\TestConnection.java
echo             System.out.println("Error: " + e.getMessage()); >> build\classes\TestConnection.java
echo             System.out.println(""); >> build\classes\TestConnection.java
echo             System.out.println("Troubleshooting:"); >> build\classes\TestConnection.java
echo             System.out.println("1. Make sure MySQL is running (XAMPP)"); >> build\classes\TestConnection.java
echo             System.out.println("2. Check database 'efarm_db' exists"); >> build\classes\TestConnection.java
echo             System.out.println("3. Verify MySQL is on port 3306"); >> build\classes\TestConnection.java
echo             e.printStackTrace(); >> build\classes\TestConnection.java
echo         } >> build\classes\TestConnection.java
echo     } >> build\classes\TestConnection.java
echo } >> build\classes\TestConnection.java

REM Compile and run the test
javac -cp "lib/mysql-connector-j-9.5.0.jar;build/classes" build\classes\TestConnection.java 2>nul
java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" TestConnection

echo.
echo ========================================
pause

