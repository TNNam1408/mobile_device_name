import 'package:flutter/material.dart';
import 'package:mobile_device_name/mobile_device_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileDeviceName.instance.initialize();
  runApp(const MaterialApp(home: ExampleApp()));
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  String _displayName = 'Chưa tra cứu';

  void _lookup(String model) {
    final name = MobileDeviceName.instance.getMarketingName(model);
    setState(() {
      _displayName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Device Name Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Kết quả: $_displayName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _lookup('SM-S918B'),
              child: const Text('Tra cứu Samsung S23 Ultra'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _lookup('iPhone15,2'),
              child: const Text('Tra cứu iPhone 14 Pro'),
            ),
          ],
        ),
      ),
    );
  }
}
