# Hướng Dẫn Cấu Hình Flavor & Quy Trình Build (Dev & Prod)

Tài liệu này tổng hợp toàn bộ kiến trúc Flavor, Firebase và Quảng cáo (Ads / Adjust) đã được tối ưu hóa cho dự án `app_default`.

---

## 1. Bảng So Sánh Cấu Hình Hai Môi Trường

| Thông số | Môi trường Dev (`dev`) | Môi trường Prod (`prod`) |
| :--- | :--- | :--- |
| **Tên ứng dụng** (Android) | `(Dev) App Default` | `App Default` |
| **Package Name / ApplicationId** | `com.example.app_default.dev` | `com.example.app_default` |
| **Cài đặt song song** | Cài song song cùng lúc với bản Prod trên 1 máy | Cài song song cùng lúc với bản Dev trên 1 máy |
| **File Google Services Android** | [android/app/src/dev/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/dev/google-services.json) | [android/app/src/prod/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/google-services.json) |
| **Cơ chế nạp Firebase** | Tự động nạp trực tiếp từ Native qua `Firebase.initializeApp()` | Tự động nạp trực tiếp từ Native qua `Firebase.initializeApp()` |
| **Firebase Crashlytics** | Tắt ghi lỗi tự động để tránh nhiễu log khi test | Bật tự động ghi log lỗi & crash (`runZonedGuarded`) |
| **AdMob App ID (Native)** | [android/app/src/dev/res/values/string.xml](file:///Users/devflutter2/Dev/github/app_default/android/app/src/dev/res/values/string.xml) *(ID Test)* | [android/app/src/prod/res/values/string.xml](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/res/values/string.xml) *(ID Thật)* |
| **Adjust SDK Token** | Tắt tracking (`''` / rỗng) | Kích hoạt với Token thật (`4x514zi69lhc`) |

---

## 2. Kiến Trúc Cấu Hình Đã Thiết Lập

```
app_default/
├── android/
│   ├── app/
│   │   ├── build.gradle.kts           # Áp dụng flavorizr.gradle.kts & resValues = true
│   │   ├── flavorizr.gradle.kts       # Định nghĩa flavor dev và prod (appId, resValue app_name)
│   │   └── src/
│   │       ├── dev/
│   │       │   ├── google-services.json   # Config Firebase Dev (package: com.example.app_default.dev)
│   │       │   └── res/values/string.xml  # ads_app_id test cho Dev
│   │       ├── prod/
│   │       │   ├── google-services.json   # Config Firebase Prod (package: com.example.app_default)
│   │       │   └── res/values/string.xml  # ads_app_id thật cho Prod
│   │       └── main/
│   │           └── AndroidManifest.xml    # android:label="@string/app_name", ads: @string/ads_app_id
├── lib/
│   ├── app/
│   │   ├── bindings/
│   │   │   └── initial_binding.dart   # Khởi tạo Firebase trực tiếp từ Native & bật Crashlytics cho prod
│   │   └── services/
│   │       └── ads_service.dart       # Phân tách Adjust token/event key theo appFlavor
│   └── main.dart                      # Entrypoint duy nhất của ứng dụng
└── .vscode/
    └── launch.json                    # Cấu hình chạy/debug trực tiếp trên VS Code & Antigravity IDE
```

---

## 3. Quy Trình Cập Nhật Cấu Hình Từng Môi Trường

### A. Cập nhật Firebase
Nhờ sử dụng cơ chế kế thừa Native trực tiếp, bạn **không cần chỉnh sửa code Dart** hay `firebase.json` mỗi khi đổi Firebase:
1. **Firebase Dev**: Tải file `google-services.json` từ Firebase Console (ứng dụng `com.example.app_default.dev`) và dán đè vào:
   [android/app/src/dev/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/dev/google-services.json)
2. **Firebase Prod**: Tải file `google-services.json` từ Firebase Console (ứng dụng `com.example.app_default`) và dán đè vào:
   [android/app/src/prod/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/google-services.json)

### B. Cập nhật Ads App ID (AdMob & Facebook)
1. **Flavor Dev**: File [android/app/src/dev/res/values/string.xml](file:///Users/devflutter2/Dev/github/app_default/android/app/src/dev/res/values/string.xml) đang chứa sẵn ID Test tiêu chuẩn của Google AdMob (`ca-app-pub-3940256099942544~3347511713`), giữ nguyên để test an toàn không bị ban tài khoản.
2. **Flavor Prod**: Khi phát hành chính thức, mở file [android/app/src/prod/res/values/string.xml](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/res/values/string.xml) và thay thế:
   - `ads_app_id`: Điền App ID AdMob thật của ứng dụng Prod.
   - `facebook_app_id` / `facebook_client_token`: Điền ID Facebook thật (nếu có dùng).

### C. Cập nhật Adjust Token
Mở [lib/app/services/ads_service.dart](file:///Users/devflutter2/Dev/github/app_default/lib/app/services/ads_service.dart):
- Bản `dev` sẽ tự động truyền chuỗi rỗng để không đẩy doanh thu test lên Adjust.
- Bản `prod` sẽ sử dụng `adjustToken` và `adjustEventKey` thật.

---

## 4. Quy Trình Chạy (Run & Debug)

### Cách 1: Chạy từ thanh công cụ Run & Debug
Trong tab **Run & Debug** (Ctrl+Shift+D hoặc Cmd+Shift+D), chọn cấu hình mong muốn:
- **`dev Debug`**: Chạy bản Dev (debug), kết nối Firebase Dev, dùng Ads test, tắt Adjust.
- **`dev Release`**: Chạy thử bản Dev ở chế độ Release trên thiết bị thật.
- **`prod Debug`**: Chạy bản Prod ở chế độ Debug (dùng khi cần kiểm tra môi trường Prod).
- **`prod Release`**: Chạy bản Prod ở chế độ Release (kết nối Firebase Prod, Ads Prod, bật Crashlytics).

### Cách 2: Chạy từ Terminal
```bash
# Chạy bản Dev
flutter run --flavor dev

# Chạy bản Prod
flutter run --flavor prod
```

---

## 5. Quy Trình Build Phát Hành (Release)

### 1. Build APK cho Tester (Môi trường Dev)
```bash
flutter build apk --flavor dev
```
> File APK xuất ra tại: `build/app/outputs/flutter-apk/app-dev-release.apk`  
> Tester có thể cài đặt song song với app Prod mà không lo đè dữ liệu.

### 2. Build APK Test nội bộ (Môi trường Prod)
```bash
flutter build apk --flavor prod
```
> File APK xuất ra tại: `build/app/outputs/flutter-apk/app-prod-release.apk`

### 3. Build AAB (App Bundle) Đẩy Lên Google Play Console (Production)
```bash
flutter build appbundle --flavor prod
```
> File AAB xuất ra tại: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`  
> Đây là file chính thức để tải lên Google Play Store.

---

## 6. Checklist Kiểm Tra Trước Khi Build Production

1. [ ] Đã đặt đúng file `google-services.json` của Firebase Production vào [android/app/src/prod/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/google-services.json).
2. [ ] Đã điền ID Ads thật trong [android/app/src/prod/res/values/string.xml](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/res/values/string.xml).
3. [ ] Đã kiểm tra Adjust Token trong [lib/app/services/ads_service.dart](file:///Users/devflutter2/Dev/github/app_default/lib/app/services/ads_service.dart).
4. [ ] Đã có file `key.properties` và file keystore `.jks` để ký app bản Release.
5. [ ] Chạy lệnh `flutter analyze` xác nhận không có lỗi code:
   ```bash
   flutter analyze
   ```
6. [ ] Chạy lệnh build AAB:
   ```bash
   flutter build appbundle --flavor prod
   ```
