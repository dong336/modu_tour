import 'package:permission_handler/permission_handler.dart';

class BluetoothPermissionManager {
  /// Bluetooth 권한 요청 및 처리
  static Future<bool> checkAndRequestPermissions() async {
    // 요청할 권한 목록
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ];

    // 권한 요청
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // 모든 권한이 허용되었는지 확인
    if (statuses.values.every((status) => status.isGranted)) {
      print('All Bluetooth permissions granted.');
      return true;
    }

    // 영구 거부된 권한 처리
    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      print('Permanently denied permissions detected. Redirecting to settings.');
      await openAppSettings();
    }

    // 일부 권한이 거부된 경우
    print('Some Bluetooth permissions denied.');
    return false;
  }

  /// Bluetooth 권한 상태 확인
  static Future<void> checkPermissionStatus() async {
    final bluetoothStatus = await Permission.bluetooth.status;
    final bluetoothConnectStatus = await Permission.bluetoothConnect.status;
    final bluetoothScanStatus = await Permission.bluetoothScan.status;

    print('Bluetooth: $bluetoothStatus');
    print('Bluetooth Connect: $bluetoothConnectStatus');
    print('Bluetooth Scan: $bluetoothScanStatus');
  }
}
