package auth; // Đổi lại tên package theo cấu trúc dự án Dojo của bạn

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.*;
import utils.XDriver;

import java.io.File;
import java.io.FileOutputStream;
import java.time.Duration;

public class LoginTest {

    // ==========================================
    // 1. CONFIG & SETUP
    // ==========================================
    private WebDriver driver;
    private Workbook workbook;
    private Sheet sheet;
    private int currentRow = 1;
    private String excelPath = "results/Dojo_Auth_TestCases.xlsx";
    private String baseUrl = "http://localhost:8080/Dojo_Software"; // Đổi đường dẫn gốc về dự án Dojo

    @BeforeClass
    public void setupClass() {
        try {
            File dir = new File("results");
            if (!dir.exists()) dir.mkdirs();
            workbook = new XSSFWorkbook();
            sheet = workbook.createSheet("Auth_TestCases");
            createExcelHeader();
        } catch (Exception e) {
            System.err.println("Lỗi tạo Excel: " + e.getMessage());
        }
    }

    @BeforeMethod
    public void setupMethod() {
        driver = XDriver.getDriver(false);
        driver.manage().deleteAllCookies(); // Xóa cookie trước mỗi TC để đảm bảo trạng thái logout
        try {
            WebDriverWait quickWait = new WebDriverWait(driver, Duration.ofMillis(500));
            quickWait.until(ExpectedConditions.alertIsPresent());
            driver.switchTo().alert().accept();
        } catch (Exception e) {
            // Bỏ qua nếu không có alert
        }
    }

    @AfterClass
    public void tearDownClass() {
        try (FileOutputStream out = new FileOutputStream(excelPath)) {
            workbook.write(out);
            workbook.close();
            System.out.println("✔ Excel SAVED: " + excelPath);
        } catch (Exception e) {
            e.printStackTrace();
        }
        XDriver.quitDriver();
    }

    // ==========================================
    // 2. HELPER METHODS
    // ==========================================
    private void logResult(String id, String module, String testCase, String actual, String status) {
        Row row = sheet.createRow(currentRow++);
        row.createCell(0).setCellValue(id);
        row.createCell(1).setCellValue(module);
        row.createCell(2).setCellValue(testCase);
        row.createCell(8).setCellValue(actual);
        row.createCell(9).setCellValue(status);
        System.out.println(String.format("[%s] %s: %s", status, id, testCase));
    }

    private void createExcelHeader() {
        Row header = sheet.createRow(0);
        String[] cols = {"ID", "Module", "TestCase", "Pre-Cond", "Steps", "Data", "Expected", "Post-Cond", "Actual", "Status"};
        for (int i = 0; i < cols.length; i++) header.createCell(i).setCellValue(cols[i]);
    }

    private void performLogin(String username, String password) {
        driver.get(baseUrl + "/login");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        // Bạn có thể đổi name="id" thành "username" nếu form login của Dojo dùng tên đó
        WebElement userField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("id")));
        userField.clear();
        if (!username.isEmpty()) {
            userField.sendKeys(username);
        }

        WebElement passField = driver.findElement(By.name("password"));
        passField.clear();
        if (!password.isEmpty()) {
            passField.sendKeys(password);
        }

        driver.findElement(By.cssSelector("button[type='submit']")).click();
    }

    // ==========================================
    // 3. TEST CASES - DOJO AUTHENTICATION
    // ==========================================

    @Test(priority = 1)
    public void TC01_Auth_Login_Success_Admin() {
        performLogin("AD001", "456"); // Sửa lại tài khoản admin thật của bạn

        boolean isSuccess = driver.getCurrentUrl().contains("admin") || driver.getCurrentUrl().contains("dashboard");
        logResult("TC01", "Auth", "Login Admin Thành Công", isSuccess ? "Vào trang quản trị" : "Vẫn ở trang Login", isSuccess ? "PASS" : "FAIL");
    }

    @Test(priority = 2)
    public void TC02_Auth_Login_Success_Instructor() {
        performLogin("ST001", "123"); // Sửa lại tài khoản Huấn luyện viên/Học viên

        boolean isSuccess = driver.getCurrentUrl().contains("instructor") || driver.getCurrentUrl().contains("home");
        logResult("TC02", "Auth", "Login Instructor Thành Công", isSuccess ? "Vào trang hệ thống" : "Vẫn ở trang Login", isSuccess ? "PASS" : "FAIL");
    }

    @Test(priority = 3)
    public void TC03_Auth_Login_EmptyUsername() {
        performLogin("", "123");

        boolean stayOnLogin = driver.getCurrentUrl().contains("login");
        logResult("TC03", "Auth", "Login Bỏ trống ID", stayOnLogin ? "Bị chặn tại form" : "Bị lỗi server", stayOnLogin ? "PASS" : "FAIL");
    }

    @Test(priority = 4)
    public void TC04_Auth_Login_EmptyPassword() {
        performLogin("admin_dojo", "");

        boolean stayOnLogin = driver.getCurrentUrl().contains("login");
        logResult("TC04", "Auth", "Login Bỏ trống Password", stayOnLogin ? "Bị chặn tại form" : "Bị lỗi server", stayOnLogin ? "PASS" : "FAIL");
    }

    @Test(priority = 5)
    public void TC05_Auth_Login_InvalidCredentials() {
        performLogin("hacker", "wrongpass");

        boolean hasErrorMessage = driver.getPageSource().contains("Sai") || driver.getPageSource().contains("không đúng") || driver.getCurrentUrl().contains("login");
        logResult("TC05", "Auth", "Login Sai Thông Tin", hasErrorMessage ? "Hiện thông báo lỗi" : "Không có thông báo/Vào được", hasErrorMessage ? "PASS" : "FAIL");
    }

    @Test(priority = 6)
    public void TC06_Auth_Login_SQLInjection() {
        performLogin("' OR '1'='1", "' OR '1'='1");

        boolean isHacked = driver.getCurrentUrl().contains("admin") || driver.getCurrentUrl().contains("dashboard");
        boolean crash = driver.getPageSource().contains("SQLException") || driver.getPageSource().contains("500");

        String status = (!isHacked && !crash) ? "PASS" : "FAIL";
        String actual = crash ? "Server Crash" : (isHacked ? "Đăng nhập trái phép thành công" : "Đã chặn SQL Injection");
        logResult("TC06", "Auth", "Login SQL Injection", actual, status);
    }

    @Test(priority = 7)
    public void TC07_Auth_Logout_Success() {
        performLogin("admin_dojo", "123");

        try {
            // Cập nhật lại selector nút Đăng Xuất theo code giao diện của Dojo
            driver.findElement(By.cssSelector("a[href*='logout']")).click();
            boolean isLoggedOut = driver.getCurrentUrl().contains("login");
            logResult("TC07", "Auth", "Đăng xuất thành công", isLoggedOut ? "Trở về Login" : "Chưa đăng xuất được", isLoggedOut ? "PASS" : "FAIL");
        } catch (Exception e) {
            logResult("TC07", "Auth", "Đăng xuất", "Lỗi: Không tìm thấy nút Logout", "FAIL");
        }
    }

    @Test(priority = 8)
    public void TC08_Auth_AccessAdminWithoutLogin() {
        driver.manage().deleteAllCookies();
        // Cố tình truy cập một route dành riêng cho Admin của võ đường
        driver.get(baseUrl + "/admin/classes");

        boolean isRedirected = driver.getCurrentUrl().contains("login");
        logResult("TC08", "Auth", "Vào trang Admin khi chưa Login", isRedirected ? "Đẩy về Login" : "Truy cập lậu thành công", isRedirected ? "PASS" : "FAIL");
    }
}