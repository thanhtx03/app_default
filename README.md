# app_default

Dự án Flutter mẫu tích hợp Clean Architecture, Firebase, và ExoAds.

---

## 🚫 Hướng dẫn Bật / Tắt Quảng Cáo (Ads Switch) khi Debug

Dự án hỗ trợ công tắc tắt quảng cáo linh hoạt giúp lập trình viên thuận tiện kiểm thử giao diện và luồng ứng dụng mà không bị quảng cáo làm phiền.

### 1. Dùng lệnh Terminal (Khuyên dùng)

Bạn có thể chạy trực tiếp file script `./ads` tại thư mục gốc của dự án:

| Thao tác | Lệnh rút gọn (Mac/Linux) | Lệnh chuẩn Dart | Mô tả |
| :--- | :--- | :--- | :--- |
| **Tắt Ads** | `./ads off` | `dart run scripts/ads.dart off` | Tắt toàn bộ ads trong dự án khi debug |
| **Bật Ads** | `./ads on` | `dart run scripts/ads.dart on` | Bật lại ads hoạt động bình thường |
| **Kiểm tra trạng thái** | `./ads status` | `dart run scripts/ads.dart status` | Xem ads đang BẬT hay TẮT |
| **Đảo trạng thái** | `./ads toggle` | `dart run scripts/ads.dart toggle` | Bật <-> Tắt nhanh |
| **Chạy app ngay** | `./ads run` | `dart run scripts/ads.dart run` | Chạy `flutter run` với cờ tắt ads |

> **Quy trình thường dùng:**
> 1. Gõ `./ads off` trong Terminal.
> 2. Bấm nút **Run / Debug (F5)** trong Android Studio hoặc VS Code như bình thường.
> 3. Mọi quảng cáo (Splash, Native Language/Onboarding, Interstitial, Banner) sẽ được tự động bỏ qua.
> 4. Khi cần test lại quảng cáo, chỉ cần gõ `./ads on`.

---

### 2. Dùng cờ Flutter CLI (`--dart-define`)

Nếu muốn chạy trực tiếp bằng lệnh Flutter mà không thay đổi file cấu hình:

```bash
flutter run --dart-define=DISABLE_ADS=true
```

---

### 3. Chọn cấu hình sẵn trên IDE

- **Android Studio / IntelliJ**:
  - Tại danh sách Run Configurations trên thanh công cụ, chọn cấu hình **`main (No Ads)`** rồi bấm Run/Debug.
- **Visual Studio Code**:
  - Vào tab **Run & Debug** (`Ctrl+Shift+D` hoặc `Cmd+Shift+D`), chọn **`Flutter: Debug (No Ads)`** và bấm F5.

---

### 4. Cơ chế an toàn (Safety Net)

- Công tắc tắt ads cục bộ (`_debugDisableAds`) chỉ có hiệu lực trong chế độ **Debug** hoặc **Profile** (`kDebugMode || kProfileMode`).
- Khi build bản phát hành **Release** (`flutter build apk/ipa`), quảng cáo sẽ luôn hoạt động theo cấu hình Firebase Remote Config, tránh trường hợp quên bật lại ads trước khi deploy.

---

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

