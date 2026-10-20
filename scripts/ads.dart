// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) async {
  final configFile = _findConfigFile();
  if (configFile == null || !configFile.existsSync()) {
    print('❌ Không tìm thấy file lib/app/config/ads_config.dart!');
    exit(1);
  }

  if (args.isEmpty) {
    _printHelp();
    return;
  }

  final command = args.first.toLowerCase();

  switch (command) {
    case 'off':
    case 'disable':
      _setAdsDisabled(configFile, true);
      break;

    case 'on':
    case 'enable':
      _setAdsDisabled(configFile, false);
      break;

    case 'status':
      _showStatus(configFile);
      break;

    case 'toggle':
      final currentDisabled = _isCurrentlyDisabled(configFile);
      _setAdsDisabled(configFile, !currentDisabled);
      break;

    case 'run':
      await _runWithNoAds(args.sublist(1));
      break;

    case 'help':
    case '--help':
    case '-h':
      _printHelp();
      break;

    default:
      print('❌ Lệnh không hợp lệ: "$command"');
      print('');
      _printHelp();
      exit(1);
  }
}

File? _findConfigFile() {
  final localPath = File('lib/app/config/ads_config.dart');
  if (localPath.existsSync()) return localPath;

  final fromScript = File.fromUri(
    Platform.script.resolve('../lib/app/config/ads_config.dart'),
  );
  if (fromScript.existsSync()) return fromScript;

  return null;
}

bool _isCurrentlyDisabled(File file) {
  final content = file.readAsStringSync();
  final match = RegExp(r'static const bool _debugDisableAds\s*=\s*(true|false);').firstMatch(content);
  if (match != null) {
    return match.group(1) == 'true';
  }
  return false;
}

void _setAdsDisabled(File file, bool disable) {
  final content = file.readAsStringSync();
  final regex = RegExp(r'static const bool _debugDisableAds\s*=\s*(true|false);');

  if (!regex.hasMatch(content)) {
    print('❌ Không tìm thấy biến _debugDisableAds trong file ads_config.dart!');
    exit(1);
  }

  final newContent = content.replaceFirst(
    regex,
    'static const bool _debugDisableAds = $disable;',
  );

  file.writeAsStringSync(newContent);

  print('======================================================');
  if (disable) {
    print('🚫 [ADS SWITCH] ĐÃ TẮT QUẢNG CÁO (ADS: OFF)');
    print('👉 Trạng thái: isAdsDisabled = true');
    print('👉 Tất cả quảng cáo (Splash, Native, Interstitial, Banner) sẽ không xuất hiện khi bạn debug ứng dụng!');
  } else {
    print('✅ [ADS SWITCH] ĐÃ BẬT QUẢNG CÁO (ADS: ON)');
    print('👉 Trạng thái: isAdsDisabled = false');
    print('👉 Quảng cáo sẽ hoạt động bình thường theo cấu hình Remote Config.');
  }
  print('======================================================');
}

void _showStatus(File file) {
  final disabled = _isCurrentlyDisabled(file);
  print('======================================================');
  print('📊 TRẠNG THÁI QUẢNG CÁO TRONG DỰ ÁN:');
  if (disabled) {
    print('   Trạng thái hiện tại: 🚫 ĐANG TẮT (ADS OFF)');
    print('   (Khi bạn chạy hoặc debug ứng dụng, ads sẽ không hiển thị)');
  } else {
    print('   Trạng thái hiện tại: ✅ ĐANG BẬT (ADS ON)');
    print('   (Quảng cáo sẽ load & hiển thị bình thường)');
  }
  print('======================================================');
}

Future<void> _runWithNoAds(List<String> extraArgs) async {
  print('🚀 Đang khởi chạy Flutter với cờ tắt ads (--dart-define=DISABLE_ADS=true)...');
  final runArgs = [
    'run',
    '--dart-define=DISABLE_ADS=true',
    ...extraArgs,
  ];

  final process = await Process.start(
    'flutter',
    runArgs,
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  exit(exitCode);
}

void _printHelp() {
  print('''
🔧 CÔNG CỤ QUẢN LÝ QUẢNG CÁO KHI DEBUG (ADS SWITCH)

Cách dùng:
  ./ads <lệnh>
  hoặc: dart run scripts/ads.dart <lệnh>

Các lệnh hỗ trợ:
  off / disable : Tắt toàn bộ ads trong dự án khi debug
  on / enable   : Bật lại ads hoạt động bình thường
  status        : Xem trạng thái ads hiện tại đang Bật hay Tắt
  toggle        : Đảo trạng thái hiện tại (bật <-> tắt)
  run [args]    : Chạy trực tiếp "flutter run --dart-define=DISABLE_ADS=true"

Ví dụ:
  ./ads off             # Tắt ads rồi bấm Run/Debug trong Android Studio / VS Code
  ./ads on              # Bật lại ads khi cần test quảng cáo
  ./ads status          # Kiểm tra xem ads đang bật hay tắt
  ./ads run             # Chạy app ngay lập tức trong terminal không có ads
  flutter run --dart-define=DISABLE_ADS=true  # Cách dùng chuẩn Flutter CLI
''');
}
