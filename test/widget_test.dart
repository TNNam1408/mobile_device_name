import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_device_name/main.dart';
import 'package:mobile_device_name/mobile_device_name.dart';

void main() {
  setUp(() {
    MobileDeviceName.instance.loadRawMap({
      'SM-S918B': 'Samsung Galaxy S23 Ultra',
      'Pixel 8 Pro': 'Google Pixel 8 Pro',
    });
  });

  testWidgets('Tra cứu thành công trên giao diện DeviceNameDemoApp', (WidgetTester tester) async {
    await tester.pumpWidget(const DeviceNameDemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Tra cứu Tên Thiết bị'), findsOneWidget);
    expect(find.text('Samsung Galaxy S23 Ultra'), findsOneWidget);

    final input = find.widgetWithText(TextField, 'Mã Model (Build.MODEL)');
    await tester.enterText(input, 'Pixel 8 Pro');

    await tester.tap(find.text('Tra cứu tên thương mại'));
    await tester.pumpAndSettle();

    expect(find.text('Google Pixel 8 Pro'), findsOneWidget);
  });
}
