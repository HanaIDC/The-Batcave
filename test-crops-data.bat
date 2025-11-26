@echo off
REM Test if farm_crops table has data

echo Testing farm_crops database table...
echo.

cd /d "%~dp0Efarm"

REM Create test class
echo import efarm.util.DatabaseConnection; > build\classes\TestCropsData.java
echo import java.sql.Connection; >> build\classes\TestCropsData.java
echo import java.sql.PreparedStatement; >> build\classes\TestCropsData.java
echo import java.sql.ResultSet; >> build\classes\TestCropsData.java
echo public class TestCropsData { >> build\classes\TestCropsData.java
echo     public static void main(String[] args) { >> build\classes\TestCropsData.java
echo         try { >> build\classes\TestCropsData.java
echo             Connection conn = DatabaseConnection.getConnection(); >> build\classes\TestCropsData.java
echo             String sql = "SELECT name, growth_stage FROM farm_crops"; >> build\classes\TestCropsData.java
echo             PreparedStatement pstmt = conn.prepareStatement(sql); >> build\classes\TestCropsData.java
echo             ResultSet rs = pstmt.executeQuery(); >> build\classes\TestCropsData.java
echo             System.out.println("Crops in database:"); >> build\classes\TestCropsData.java
echo             System.out.println("=================="); >> build\classes\TestCropsData.java
echo             int count = 0; >> build\classes\TestCropsData.java
echo             while (rs.next()) { >> build\classes\TestCropsData.java
echo                 System.out.println("Crop: " + rs.getString("name") + " - Stage: " + rs.getString("growth_stage")); >> build\classes\TestCropsData.java
echo                 count++; >> build\classes\TestCropsData.java
echo             } >> build\classes\TestCropsData.java
echo             System.out.println(""); >> build\classes\TestCropsData.java
echo             System.out.println("Total crops found: " + count); >> build\classes\TestCropsData.java
echo             rs.close(); >> build\classes\TestCropsData.java
echo             pstmt.close(); >> build\classes\TestCropsData.java
echo             conn.close(); >> build\classes\TestCropsData.java
echo         } catch (Exception e) { >> build\classes\TestCropsData.java
echo             System.out.println("Error: " + e.getMessage()); >> build\classes\TestCropsData.java
echo             e.printStackTrace(); >> build\classes\TestCropsData.java
echo         } >> build\classes\TestCropsData.java
echo     } >> build\classes\TestCropsData.java
echo } >> build\classes\TestCropsData.java

REM Compile and run
javac -cp "lib/mysql-connector-j-9.5.0.jar;build/classes" build\classes\TestCropsData.java 2>nul
java -cp "build/classes;lib/mysql-connector-j-9.5.0.jar" TestCropsData

echo.
echo ========================================
echo.
echo Try these crop names in QA_T panel:
echo - Wheat
echo - Corn
echo - Tomato
echo.
pause

