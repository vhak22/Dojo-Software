package utils;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;

public class XDriver {
	 private static WebDriver driver;

	    /** Lấy WebDriver (Singleton) */
	    public static WebDriver getDriver(boolean headless) {

	        if (driver == null) {
	            // 💥 DÒNG BẮT BUỘC PHẢI CÓ
	            WebDriverManager.chromedriver().setup();

	            ChromeOptions options = new ChromeOptions();
	            options.addArguments("--remote-allow-origins=*");
	            options.addArguments("--start-maximized");

	            if (headless) {
	                options.addArguments("--headless=new");
	                options.addArguments("--window-size=1920,1080");
	            }

	            driver = new ChromeDriver(options);
	        }
	        return driver;
	    }

	    /** Chụp hình screenshot */
	    public static String takeScreenshot(String testName) {
	        try {
	            String time = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
	            String folder = "screenshots";
	            File dir = new File(folder);
	            if (!dir.exists()) dir.mkdirs();

	            String path = folder + "/" + testName + "_" + time + ".png";

	            File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
	            Files.copy(src.toPath(), new File(path).toPath(), StandardCopyOption.REPLACE_EXISTING);
	            return path;

	        } catch (IOException e) {
	            System.out.println("Screenshot error: " + e.getMessage());
	            return null;
	        }
	    }

	    /** Đóng driver */
	    public static void quitDriver() {
	        if (driver != null) {
	            driver.quit();
	            driver = null;
	        }
	    }
}
