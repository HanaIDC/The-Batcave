@echo off
REM ====================================================================
REM Verify FarmerManage Database Connection
REM ====================================================================

echo ========================================
echo  FarmerManage Database Verification
echo ========================================
echo.

cd /d "%~dp0Efarm"

echo [1/2] Checking if new classes are compiled...
echo.

if exist "build\classes\efarm\models\FarmerDetails.class" (
    echo [OK] FarmerDetails.class found
) else (
    echo [ERROR] FarmerDetails.class not found - need to compile
    goto :compile
)

if exist "build\classes\efarm\database\FarmerDatabase.class" (
    echo [OK] FarmerDatabase.class found
) else (
    echo [ERROR] FarmerDatabase.class not found - need to compile
    goto :compile
)

if exist "build\classes\efarm\auth\SessionManager.class" (
    echo [OK] SessionManager.class found
) else (
    echo [ERROR] SessionManager.class not found - need to compile
    goto :compile
)

echo.
echo [2/2] All classes compiled successfully!
echo.
goto :test

:compile
echo.
echo Compiling classes...
javac -cp "lib/mysql-connector-j-9.5.0.jar" -d build/classes src/efarm/models/*.java src/efarm/util/*.java src/efarm/auth/*.java src/efarm/database/*.java src/efarm/ui/*.java src/efarm/ui/panels/*.java
echo.
echo Compilation complete!
echo.

:test
echo ========================================
echo  Testing Database Query
echo ========================================
echo.

REM Create test class
echo import efarm.database.FarmerDatabase; > build\classes\TestFarmerDB.java
echo import efarm.models.FarmerDetails; >> build\classes\TestFarmerDB.java
echo public class TestFarmerDB { >> build\classes\TestFarmerDB.java
echo     public static void main(String[] args) { >> build\classes\TestFarmerDB.java
echo         try { >> build\classes\TestFarmerDB.java
echo             System.out.println("Testing FarmerDatabase connection..."); >> build\classes\TestFarmerDB.java
echo             System.out.println(""); >> build\classes\TestFarmerDB.java
echo             FarmerDetails details = FarmerDatabase.getFarmerDetailsByUsername("admin"); >> build\classes\TestFarmerDB.java
echo             if (details != null) { >> build\classes\TestFarmerDB.java
echo                 System.out.println("[SUCCESS] Farmer details found!"); >> build\classes\TestFarmerDB.java
echo                 System.out.println(""); >> build\classes\TestFarmerDB.java
echo                 System.out.println("Username: " + details.getUsername()); >> build\classes\TestFarmerDB.java
echo                 System.out.println("Location: " + details.getLocation()); >> build\classes\TestFarmerDB.java
echo                 System.out.println("Farm Size: " + details.getFarmSize() + " acres"); >> build\classes\TestFarmerDB.java
echo                 System.out.println("Contact: " + details.getContactNumber()); >> build\classes\TestFarmerDB.java
echo                 System.out.println("Email: " + details.getEmail()); >> build\classes\TestFarmerDB.java
echo                 System.out.println(""); >> build\classes\TestFarmerDB.java
echo                 System.out.println("This data will appear in FarmerManage panel!"); >> build\classes\TestFarmerDB.java
echo             } else { >> build\classes\TestFarmerDB.java
echo                 System.out.println("[WARNING] No farmer details found for 'admin'"); >> build\classes\TestFarmerDB.java
echo                 System.out.println("Run setup-database.bat to insert sample data"); >> build\classes\TestFarmerDB.java
echo             } >> build\classes\TestFarmerDB.java
echo         } catch (Exception e) { >> build\classes\TestFarmerDB.java
echo             System.out.println("[ERROR] Database connection failed!"); >> build\classes\TestFarmerDB.java
echo             System.out.println("Error: " + e.getMessage()); >> build\classes\TestFarmerDB.java
echo             System.out.println(""); >> build\classes\TestFarmerDB.java
echo             System.out.println("Make sure:"); >> build\classes\TestFarmerDB.java
echo             System.out.println("1. MySQL is running (XAMPP)"); >> build\classes\TestFarmerDB.java
echo             System.out.println("2. Database 'efarm_db' exists"); >> build\classes\TestFarmerDB.java
echo             System.out.println("3. Run setup-database.bat"); >> build\classes\TestFarmerDB.java
echo             e.printStackTrace(); >> build\classes\TestFarmerDB.java
echo         } >> build\classes\TestFarmerDB.java
echo     } >> build\classes\TestFarmerDB.java
echo } >> build\classes\TestFarmerDB.java

REM Compile and run test
javac -cp "lib/mysql-connector-j-9.5.0.jar;build/classes" build\classes\TestFarmerDB.java 2>nul
java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" TestFarmerDB

echo.
echo ========================================
echo  Verification Complete
echo ========================================
echo.
echo If you see farmer details above, your
echo FarmerManage panel will display them!
echo.

cd ..
pause

