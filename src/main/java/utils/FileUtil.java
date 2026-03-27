package utils;

import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.Set;
import java.util.UUID;

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
}