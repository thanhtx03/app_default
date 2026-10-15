# Hướng Dẫn Tích Hợp Quảng Cáo ExoAds (Chuẩn Kiến Trúc S018 & S011)

Tài liệu này tổng hợp toàn bộ quy chuẩn và các bước tích hợp quảng cáo **ExoAds** vào ứng dụng Flutter, đối chiếu đồng bộ theo kiến trúc chuẩn giữa dự án mẫu **s018_video_download** và **s011_travel_camera**.

---

## 1. Tổng Quan Về Kiến Trúc Quảng Cáo

Hệ thống quảng cáo phân bổ theo 3 thành phần chính:
1. **Màn Home (Tab chính)**: 
   - `under_home_bottom`: Transformer widget gắn ngay bên dưới Navigation Bar (trong Scaffold con).
   - `home_collap_bottom`: Transformer widget collapsible banner ghim ở mép dưới cùng màn hình (ở Scaffold ngoài).
2. **Tất cả các màn hình còn lại**:
   - `native_all_new`: Transformer widget nằm trong `bottomNavigationBar` hoặc cuối cột layout, bọc trong `SafeArea(top: false)`.
3. **Các điểm chuyển màn (Navigation / Interaction)**:
   - `ExoAds.instance.broadcastEvent('inter_on_tap');`: Bắn event trước khi `Navigator.push`, `Navigator.pushReplacement`, `Navigator.pushNamed`, hoặc khi đổi tab.

---

## 2. Chi Tiết Tích Hợp Ở Từng Vị Trí

### 2.1. Màn Home (Mô hình 2 Scaffold lồng nhau)

Để tránh hiện tượng quảng cáo collapsible đè lên Bottom Navigation Bar hoặc bị tràn viền màn hình, sử dụng cấu trúc **Double Scaffold**:

```dart
import 'package:flutter/material.dart';
import 'package:exo_ads/exo_ads.dart';

class HomeScreen extends StatelessWidget {
  final int currentIndex;
  final Widget bodyContent;
  final Function(int) onTabChange;

  const HomeScreen({
    super.key,
    required this.currentIndex,
    required this.bodyContent,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHomeTab = currentIndex == 0; // Tab chính (Map / Home)

    // TAB HOME: Dùng Double Scaffold với under_home_bottom và home_collap_bottom
    if (isHomeTab) {
      return Scaffold(
        body: Scaffold(
          extendBody: true,
          body: bodyContent,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTabChange,
              ),
              // Ad 1: Nằm dưới Bottom Nav Bar
              ExoAds.instance.transformerWidget('under_home_bottom'),
            ],
          ),
        ),
        // Ad 2: Collapsible Banner cố định sát đáy
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExoAds.instance.transformerWidget('home_collap_bottom'),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
    }

    // CÁC TAB CÒN LẠI (Compass, Download, Settings, v.v.): Dùng native_all_new
    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTabChange,
          ),
          SafeArea(
            top: false,
            child: ExoAds.instance.transformerWidget('native_all_new'),
          ),
        ],
      ),
    );
  }
}
```

---

### 2.2. Sự Kiện Chuyển Màn / Đổi Tab (`inter_on_tap`)

Bất cứ hành động nào dẫn đến chuyển đổi ngữ cảnh hoặc mở màn hình mới đều gọi sự kiện broadcast:
`ExoAds.instance.broadcastEvent('inter_on_tap');`

#### Ví dụ 1: Khi người dùng bấm đổi Tab
```dart
Future<void> _onTabTapped(BuildContext context, int index) async {
  if (currentIndex == index) return;

  // 1. Kích hoạt interstitial ad trước khi chuyển
  ExoAds.instance.broadcastEvent('inter_on_tap');

  // 2. Chuyển route
  Navigator.pushReplacementNamed(context, targetRoute);
}
```

#### Ví dụ 2: Khi bấm nút mở màn hình mới (Gallery, Detail, Viewer, Settings, v.v.)
```dart
void _openGallery(BuildContext context) {
  // Bắn event quảng cáo trước khi push
  ExoAds.instance.broadcastEvent('inter_on_tap');

  Navigator.of(context).pushNamed(AppRoutes.gallery);
}
```

#### Ví dụ 3: Sau khi hoàn thành một tác vụ (Chụp ảnh, Lưu file, Xoá media)
```dart
void _onMediaCaptured(MediaModel media) {
  ExoAds.instance.broadcastEvent('inter_on_tap');

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MediaViewerScreen(mediaList: [media], initialIndex: 0),
    ),
  );
}
```

---

### 2.3. Tất Cả Các Màn Hình Khác (`native_all_new`)

Với tất cả các màn hình phụ không thuộc Home (Viewer, Import, Formats, Picker, Navigation,...), gắn quảng cáo qua thuộc tính `bottomNavigationBar` của `Scaffold` hoặc cuối layout:

#### Kiểu 1: Màn hình dùng `Scaffold` thông thường
```dart
import 'package:flutter/material.dart';
import 'package:exo_ads/exo_ads.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: const Center(child: Text('Content')),
      bottomNavigationBar: SafeArea(
        top: false,
        child: ExoAds.instance.transformerWidget('native_all_new'),
      ),
    );
  }
}
```

#### Kiểu 2: Màn hình dùng `Column` chứa `Expanded(Scaffold)` (như Camera/Viewer tùy biến)
```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: Scaffold(
          // Nội dung màn hình
        ),
      ),
      SafeArea(
        top: false,
        child: ExoAds.instance.transformerWidget('native_all_new'),
      ),
    ],
  );
}
```

---

## 3. Quy Trình Cài Đặt Cho Project Mới (Step-by-Step)

### Bước 1: Khai báo dependency trong `pubspec.yaml`
```yaml
dependencies:
  exo_ads:
    git:
      url: https://github.com/app-defaults/exo_ads.git # hoặc cấu hình git package của team
```

### Bước 2: Thiết lập Service Ads (`lib/app/services/ads_service.dart`)
Tạo service quản lý khởi tạo `ExoAds`:
```dart
import 'package:exo_ads/exo_ads.dart';
import 'package:get/get.dart';

class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  Future<void> init() async {
    // 1. Cấu hình navigator key (Bắt buộc nếu có Native Full Ads / Dialogs)
    ExoAds.navigatorKey = Get.key;

    // 2. Khởi tạo ExoAds SDK
    await ExoAds.instance.init(
      // Các options cấu hình test device, timeout, debug mode...
    );
  }
}
```

### Bước 3: Khởi tạo tại `main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Ads sau khi Flutter engine sẵn sàng
  await AdsService.instance.init();

  runApp(const MyApp());
}
```

### Bước 4: Khai báo App ID trong `AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

### Bước 5: Cấu hình Remote Config / Ad Unit Keys
Đảm bảo Remote Config hoặc cấu hình Ad Unit IDs trên Firebase / Server có đầy đủ các placement sau:
- `under_home_bottom`
- `home_collap_bottom`
- `native_all_new`
- `inter_on_tap`

---

## 4. Checklist Đối Soát Nhanh (Audit Checklist)

- [ ] **Home Screen**: Đã có `under_home_bottom` bên dưới Bottom Navigation Bar.
- [ ] **Home Screen**: Đã có `home_collap_bottom` ở Scaffold ngoài cùng sát đáy.
- [ ] **Home Screen Tabs**: Đổi tab đã bắn `ExoAds.instance.broadcastEvent('inter_on_tap');`.
- [ ] **Màn con/phụ**: Tất cả các màn hình con đều có `SafeArea(top: false, child: ExoAds.instance.transformerWidget('native_all_new'))`.
- [ ] **Mọi nút chuyển route**: Các nút mở màn mới, nút back quan trọng hoặc các điểm chuyển luồng đã gọi `inter_on_tap`.
- [ ] **Safe Area & Overflow**: Đã kiểm tra các thiết bị có viền cong (Gesture pill / bottom padding) không bị che khuất nút hay nội dung.
