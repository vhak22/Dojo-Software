package utils;

import jakarta.servlet.http.HttpServletRequest;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public final class ParamUtil {

    private ParamUtil() {
    }

    public static String getString(HttpServletRequest req, String name, String defaultValue) {
        String val = req.getParameter(name);
        if (val == null) return defaultValue;
        val = val.trim();
        return val.isEmpty() ? defaultValue : val;
    }

    public static Integer getInt(HttpServletRequest req, String name, Integer defaultValue) {
        String val = getString(req, name, null);
        if (val == null) return defaultValue;
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static Long getLong(HttpServletRequest req, String name, Long defaultValue) {
        String val = getString(req, name, null);
        if (val == null) return defaultValue;
        try {
            return Long.parseLong(val);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static Boolean getBoolean(HttpServletRequest req, String name, Boolean defaultValue) {
        String val = getString(req, name, null);
        if (val == null) return defaultValue;
        if ("true".equalsIgnoreCase(val) || "1".equals(val) || "yes".equalsIgnoreCase(val) || "on".equalsIgnoreCase(val)) {
            return true;
        }
        if ("false".equalsIgnoreCase(val) || "0".equals(val) || "no".equalsIgnoreCase(val) || "off".equalsIgnoreCase(val)) {
            return false;
        }
        return defaultValue;
    }

    public static LocalDate getLocalDate(HttpServletRequest req, String name, String pattern, LocalDate defaultValue) {
        String val = getString(req, name, null);
        if (val == null) return defaultValue;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
            return LocalDate.parse(val, formatter);
        } catch (DateTimeParseException e) {
            return defaultValue;
        }
    }

    public static LocalDateTime getLocalDateTime(HttpServletRequest req, String name, String pattern, LocalDateTime defaultValue) {
        String val = getString(req, name, null);
        if (val == null) return defaultValue;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
            return LocalDateTime.parse(val, formatter);
        } catch (DateTimeParseException e) {
            return defaultValue;
        }
    }

    public static <E extends Enum<E>> E getEnum(HttpServletRequest req, String name, Class<E> enumType, E defaultValue) {
        String val = getString(req, name, null);
        if (val == null) return defaultValue;
        try {
            return Enum.valueOf(enumType, val.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return defaultValue;
        }
    }
}