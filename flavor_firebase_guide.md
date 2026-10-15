# Hướng Dẫn Cấu Hình Flavor & Quy Trình Build (Dev & Prod)

Tài liệu này tổng hợp toàn bộ kiến trúc Flavor và Firebase đã được thiết lập cho dự án `app_default`, đồng bộ theo tiêu chuẩn của dự án mẫu `reskin-movie_tv_show`.

---

## 1. Bảng So Sánh Cấu Hình Hai Môi Trường

| Thông số | Môi trường Dev (`dev`) | Môi trường Prod (`prod`) |
| :--- | :--- | :--- |
| **Tên ứng dụng** (Android) | `(Dev) App Default` | `App Default` |
| **Package Name / ApplicationId** | `com.example.app_default.dev` | `com.example.app_default` |
| **Cài đặt song song** | Cài song song cùng lúc với bản Prod trên 1 máy | Cài song song cùng lúc với bản Dev trên 1 máy |
| **File Google Services Android** | [android/app/src/dev/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/dev/google-services.json) | [android/app/src/prod/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/google-services.json) |
| **Firebase Options (Dart)** | [lib/firebase/firebase_options_development.dart](file:///Users/devflutter2/Dev/github/app_default/lib/firebase/firebase_options_development.dart) | [lib/firebase/firebase_options_production.dart](file:///Users/devflutter2/Dev/github/app_default/lib/firebase/firebase_options_production.dart) |
| **Firebase Crashlytics** | Tắt ghi lỗi tự động để tránh nhiễu log khi test | Bật tự động ghi log lỗi & crash (`runZonedGuarded`) |

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
│   │       │   └── google-services.json   # Config Firebase Dev (package: com.example.app_default.dev)
│   │       ├── prod/
│   │       │   └── google-services.json   # Config Firebase Prod (package: com.example.app_default)
│   │       └── main/
│   │           └── AndroidManifest.xml    # android:label="@string/app_name"
├── firebase.json                      # Cấu hình mapping giữa flavors và google-services/dart options
├── lib/
│   ├── firebase/
│   │   ├── firebase_options_development.dart # Khởi tạo FirebaseOptions cho môi trường Dev
│   │   └── firebase_options_production.dart  # Khởi tạo FirebaseOptions cho môi trường Prod
│   ├── app/
│   │   └── bindings/
│   │       └── initial_binding.dart   # Tự động chọn FirebaseOptions dựa theo appFlavor
│   └── main.dart                      # Entrypoint duy nhất, ghi Crashlytics khi appFlavor == 'prod'
└── .vscode/
    └── launch.json                    # Cấu hình chạy/debug trực tiếp trên VS Code
```

---

## 3. Quy Trình Cập Nhật Firebase Riêng Biệt Cho Từng Flavor

Khi bạn tạo 2 Project Firebase riêng biệt trên [Firebase Console](https://console.firebase.google.com/):

### Bước 1: Firebase Console - Môi Trường Dev
1. Tạo hoặc chọn Project Firebase dành cho **Dev** (ví dụ: `my-app-dev`).
2. Thêm Android App với Package name là:
   ```
   com.example.app_default.dev
   ```
3. Tải file `google-services.json` về và ghi đè vào:
   [android/app/src/dev/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/dev/google-services.json)
4. Mở file [lib/firebase/firebase_options_development.dart](file:///Users/devflutter2/Dev/github/app_default/lib/firebase/firebase_options_development.dart) và cập nhật các thông số `apiKey`, `appId`, `messagingSenderId`, `projectId`, `storageBucket` tương ứng.

### Bước 2: Firebase Console - Môi Trường Prod
1. Tạo hoặc chọn Project Firebase dành cho **Production** (ví dụ: `my-app-prod`).
2. Thêm Android App với Package name là:
   ```
   com.example.app_default
   ```
3. Tải file `google-services.json` về và ghi đè vào:
   [android/app/src/prod/google-services.json](file:///Users/devflutter2/Dev/github/app_default/android/app/src/prod/google-services.json)
4. Mở file [lib/firebase/firebase_options_production.dart](file:///Users/devflutter2/Dev/github/app_default/lib/firebase/firebase_options_production.dart) và cập nhật các thông số tương ứng của project Prod.

---

## 4. Quy Trình Chạy (Run & Debug)

### Cách 1: Chạy từ thanh công cụ VS Code / Antigravity IDE
Trong tab **Run & Debug** (Ctrl+Shift+D hoặc Cmd+Shift+D), bạn chỉ cần chọn một trong các cấu hình có sẵn:
- **`dev Debug`**: Chạy bản Dev, kết nối Firebase Dev.
- **`dev Debug (No Ads)`**: Chạy bản Dev và tắt toàn bộ quảng cáo.
- **`dev Release`**: Chạy thử bản Dev ở chế độ Release trên máy.
- **`prod Debug`**: Chạy bản Prod ở chế độ Debug, kết nối Firebase Prod.
- **`prod Debug (No Ads)`**: Chạy bản Prod tắt quảng cáo.
- **`prod Release`**: Chạy bản Prod ở chế độ Release.

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
> Tester có thể cài đặt song song với app chính mà không lo đè dữ liệu.

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
2. [ ] Đã cập nhật đúng thông tin trong [lib/firebase/firebase_options_production.dart](file:///Users/devflutter2/Dev/github/app_default/lib/firebase/firebase_options_production.dart).
3. [ ] Đã kiểm tra file `key.properties` và keystore release để ký app.
4. [ ] Chạy lệnh `flutter analyze` để xác nhận không có lỗi mã nguồn.
5. [ ] Chạy `flutter build appbundle --flavor prod` để đóng gói bản phát hành.
