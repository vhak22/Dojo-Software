package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class FileUtil {

    private FileUtil() {
    }

    public static String saveUpload(Part filePart, String uploadDir, Set<String> allowedExtensions) throws IOException {
        if (filePart == null || filePart.getSize() == 0) return null;

        String original = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (original.isBlank()) return null;

        String ext = getExtension(original).toLowerCase();
        if (allowedExtensions != null && !allowedExtensions.isEmpty() && !allowedExtensions.contains(ext)) {
            throw new IOException("File type not allowed: " + ext);
        }

        Path dir = Paths.get(uploadDir);
        Files.createDirectories(dir);

        String storedName = UUID.randomUUID() + "_" + sanitizeFileName(original);
        Path target = dir.resolve(storedName);

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return storedName;
    }

    public static byte[] readAllBytes(String absolutePath) throws IOException {
        return Files.readAllBytes(Paths.get(absolutePath));
    }

    public static boolean deleteIfExists(String absolutePath) throws IOException {
        return Files.deleteIfExists(Paths.get(absolutePath));
    }

    public static String sanitizeFileName(String fileName) {
        return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    public static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return (dot >= 0 && dot < fileName.length() - 1) ? fileName.substring(dot + 1) : "";
    }

    /**
     * Minimal Google OAuth2 helpers for the servlet-based app.
     * Notes:
     * - This implementation exchanges tokens and reads the userinfo endpoint.
     * - It does not fully validate the ID token signature (only email/sub are trusted from Google responses).
     */
    public static final class GoogleOAuthUtil {
        private GoogleOAuthUtil() {
        }

        public static final String SESSION_OAUTH_STATE = "google_oauth_state";
        public static final String SESSION_CODE_VERIFIER = "google_pkce_code_verifier";

        private static final String PROPERTIES_RESOURCE = "google-oauth.properties";

        private static Properties loadProperties() {
            Properties p = new Properties();
            try (InputStream is = GoogleOAuthUtil.class.getClassLoader().getResourceAsStream(PROPERTIES_RESOURCE)) {
                if (is != null) {
                    p.load(is);
                }
            } catch (IOException ignored) {
                // If properties can't be read, we'll fall back to env/system properties.
            }
            return p;
        }

        private static final Properties PROPS = loadProperties();

        public static String getRequiredEnv(String name) {
            String value = System.getenv(name);
            if (value == null || value.isBlank()) {
                value = System.getProperty(name);
            }
            if (value == null || value.isBlank()) {
                value = PROPS.getProperty(name);
            }

            if (value == null || value.isBlank()) {
                throw new IllegalStateException(
                        "Missing Google OAuth config for key '" + name
                                + "'. Set environment variables, JVM system properties, or provide '" + PROPERTIES_RESOURCE
                                + "' on the classpath."
                );
            }
            return value;
        }

        public static String buildRedirectUri(HttpServletRequest req, String callbackPath) {
            // Allow overriding the redirect URI for deployments behind proxies.
            String override = System.getenv("GOOGLE_REDIRECT_URI");
            if (override != null && !override.isBlank()) {
                return override;
            }

            String scheme = req.getScheme();
            String host = req.getServerName();
            int port = req.getServerPort();
            String portPart = ((scheme.equals("http") && port == 80) || (scheme.equals("https") && port == 443))
                    ? ""
                    : ":" + port;

            return scheme + "://" + host + portPart + req.getContextPath() + callbackPath;
        }

        public static String generateState() {
            return generateUrlSafeRandom(16);
        }

        public static String generateCodeVerifier() {
            // RFC 7636: 43-128 chars URL-safe.
            return generateUrlSafeRandom(32);
        }

        private static String generateUrlSafeRandom(int byteCount) {
            byte[] bytes = new byte[byteCount];
            new SecureRandom().nextBytes(bytes);
            return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        }

        public static String codeChallengeFromVerifier(String verifier) {
            try {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(verifier.getBytes(StandardCharsets.UTF_8));
                return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
            } catch (NoSuchAlgorithmException e) {
                throw new IllegalStateException("SHA-256 not available", e);
            }
        }

        public static String generateRandomPassword() {
            // Password is required by the DB schema (non-null). OAuth users don't use this for login.
            return UUID.randomUUID().toString().replace("-", "");
        }

        public static String generateGoogleUserId(String input) {
            String safeInput = (input == null || input.isBlank()) ? UUID.randomUUID().toString() : input;
            try {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(safeInput.getBytes(StandardCharsets.UTF_8));
                String hex = bytesToHex(hash);
                // UserId is length 20; keep it deterministic and short enough.
                return "G" + hex.substring(0, Math.min(18, hex.length()));
            } catch (NoSuchAlgorithmException e) {
                throw new IllegalStateException("SHA-256 not available", e);
            }
        }

        private static String bytesToHex(byte[] bytes) {
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        }

        public static String extractJsonStringField(String json, String fieldName) {
            if (json == null || json.isBlank()) return null;
            Pattern p = Pattern.compile("\"" + Pattern.quote(fieldName) + "\"\\s*:\\s*\"([^\"]*)\"");
            Matcher m = p.matcher(json);
            if (m.find()) return m.group(1);
            return null;
        }

        public static String httpPostForm(String urlStr, Map<String, String> formParams) throws IOException {
            HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

            String body = buildFormBody(formParams);
            byte[] bodyBytes = body.getBytes(StandardCharsets.UTF_8);
            conn.setFixedLengthStreamingMode(bodyBytes.length);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(bodyBytes);
            }

            int status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
            String response = readAll(is);
            if (status < 200 || status >= 300) {
                throw new IOException("HTTP " + status + " calling " + urlStr + ": " + response);
            }
            return response;
        }

        public static String httpGet(String urlStr, Map<String, String> headers) throws IOException {
            HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setRequestMethod("GET");
            if (headers != null) {
                for (Map.Entry<String, String> e : headers.entrySet()) {
                    conn.setRequestProperty(e.getKey(), e.getValue());
                }
            }

            int status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
            String response = readAll(is);
            if (status < 200 || status >= 300) {
                throw new IOException("HTTP " + status + " calling " + urlStr + ": " + response);
            }
            return response;
        }

        private static String buildFormBody(Map<String, String> formParams) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (Map.Entry<String, String> e : formParams.entrySet()) {
                if (!first) sb.append("&");
                first = false;
                sb.append(URLEncoder.encode(e.getKey(), StandardCharsets.UTF_8));
                sb.append("=");
                sb.append(URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8));
            }
            return sb.toString();
        }

        private static String readAll(InputStream is) throws IOException {
            if (is == null) return "";
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                return sb.toString();
            }
        }
    }
}