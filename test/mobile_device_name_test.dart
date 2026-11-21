import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_device_name/mobile_device_name.dart';

void main() {
  group('MobileDeviceName Tests', () {
    setUp(() {
      MobileDeviceName.instance.loadRawMap({
        'SM-S918B': 'Samsung Galaxy S23 Ultra',
        'dm3q': 'Samsung Galaxy S23 Ultra',
        '23021RAA2Y': 'Xiaomi Redmi Note 12',
        'topaz': 'Xiaomi Redmi Note 12',
        'Pixel 8 Pro': 'Google Pixel 8 Pro',
        'husky': 'Google Pixel 8 Pro',
        'iPhone15,2': 'iPhone 14 Pro',
        'iPhone16,1': 'iPhone 15 Pro',
        'iPhone17,1': 'iPhone 16 Pro',
        'iPhone17,5': 'iPhone 16e',
        'iPhone18,1': 'iPhone 17 Pro',
        'iPhone18,4': 'iPhone Air',
        'iPhone19,2': 'iPhone 18 Pro',
        'iPhone19,4': 'iPhone Duo',
        'iPad16,3': 'iPad Pro 11-inch (M4, Wi-Fi)',
        'iPad16,8': 'iPad Air 11-inch (M4, Wi-Fi)',
        'RealityDevice14,1': 'Apple Vision Pro (M2)',
        'Watch7,12': 'Apple Watch Ultra 3',
        'Watch8,1': 'Apple Watch Ultra 4',
      });
    });

    test('Tra cứu chính xác theo mã Model O(1)', () {
      final res = MobileDeviceName.instance.getMarketingName('SM-S918B');
      expect(res, equals('Samsung Galaxy S23 Ultra'));
    });

    test('Tra cứu chữ thường không phân biệt hoa thường O(1)', () {
      final res = MobileDeviceName.instance.getMarketingName('sm-s918b');
      expect(res, equals('Samsung Galaxy S23 Ultra'));
    });

    test('Tra cứu loại bỏ khoảng trắng hai đầu', () {
      final res = MobileDeviceName.instance.getMarketingName('  23021RAA2Y  ');
      expect(res, equals('Xiaomi Redmi Note 12'));
    });

    test('Tra cứu qua Device codename khi mã Model không có trong dữ liệu', () {
      final res = MobileDeviceName.instance.getMarketingName('UNKNOWN_MODEL', device: 'topaz');
      expect(res, equals('Xiaomi Redmi Note 12'));
    });

    test('Tra cứu Device codename không phân biệt hoa thường', () {
      final res = MobileDeviceName.instance.getMarketingName('UNKNOWN_MODEL', device: 'TOPAZ');
      expect(res, equals('Xiaomi Redmi Note 12'));
    });

    test('Fallback về mã Model khi không tìm thấy', () {
      final res = MobileDeviceName.instance.getMarketingName('UNKNOWN_99');
      expect(res, equals('UNKNOWN_99'));
    });

    test('Trả về fallback tùy chỉnh khi được cung cấp', () {
      final res = MobileDeviceName.instance.getMarketingName('UNKNOWN_99', fallback: 'Không rõ');
      expect(res, equals('Không rõ'));
    });

    test('Tra cứu danh mục Apple thống nhất trong bảng tra cứu (iPhone, iPad, Vision Pro, Watch)', () {
      expect(MobileDeviceName.instance.getMarketingName('iPhone15,2'), equals('iPhone 14 Pro'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone16,1'), equals('iPhone 15 Pro'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone17,1'), equals('iPhone 16 Pro'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone17,5'), equals('iPhone 16e'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone18,1'), equals('iPhone 17 Pro'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone18,4'), equals('iPhone Air'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone19,2'), equals('iPhone 18 Pro'));
      expect(MobileDeviceName.instance.getMarketingName('iPhone19,4'), equals('iPhone Duo'));
      expect(MobileDeviceName.instance.getMarketingName('iPad16,3'), equals('iPad Pro 11-inch (M4, Wi-Fi)'));
      expect(MobileDeviceName.instance.getMarketingName('iPad16,8'), equals('iPad Air 11-inch (M4, Wi-Fi)'));
      expect(MobileDeviceName.instance.getMarketingName('RealityDevice14,1'), equals('Apple Vision Pro (M2)'));
      expect(MobileDeviceName.instance.getMarketingName('Watch7,12'), equals('Apple Watch Ultra 3'));
      expect(MobileDeviceName.instance.getMarketingName('Watch8,1'), equals('Apple Watch Ultra 4'));
    });

    test('Tra cứu Apple không phân biệt chữ hoa thường O(1)', () {
      expect(MobileDeviceName.instance.getMarketingName('iphone17,1'), equals('iPhone 16 Pro'));
      expect(MobileDeviceName.instance.getMarketingName('ipad16,3'), equals('iPad Pro 11-inch (M4, Wi-Fi)'));
    });
  });
}
