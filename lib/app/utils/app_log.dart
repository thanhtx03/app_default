import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Tiện ích ghi log an toàn cho ứng dụng:
/// - Chỉ in log khi chạy ở chế độ Debug (`kDebugMode = true`).
/// - Tự động tắt hoàn toàn khi build Release (app thật) để chống lộ dữ liệu nhạy cảm.
class AppLog {
  AppLog._();

  /// Log Debug (thông tin kiểm thử, trace luồng)
  static void d(Object? message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      debugPrint('[$tag] 🐛 $message');
    }
  }

  /// Log Info (thông tin tiến trình chung)
  static void i(Object? message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      debugPrint('[$tag] ℹ️ $message');
    }
  }

  /// Log Warning (cảnh báo)
  static void w(Object? message, {String tag = 'WARN'}) {
    if (kDebugMode) {
      debugPrint('[$tag] ⚠️ $message');
    }
  }

  /// Log Error (lỗi kèm exception & stacktrace)
  static void e(
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'ERROR',
  }) {
    if (kDebugMode) {
      debugPrint('[$tag] ❌ $message${error != null ? ': $error' : ''}');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  /// Log trực tiếp vào DevTools/Logcat kèm developer.log (hỗ trợ name/tag)
  static void log(
    String message, {
    String name = 'AppLog',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
