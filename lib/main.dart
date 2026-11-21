
import 'package:flutter/material.dart';
import 'mobile_device_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo trước cơ sở dữ liệu tên thiết bị từ asset
  await MobileDeviceName.instance.initialize();
  runApp(const DeviceNameDemoApp());
}

class DeviceNameDemoApp extends StatelessWidget {
  const DeviceNameDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Device Name Resolver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DeviceNameScreen(),
    );
  }
}

class DeviceNameScreen extends StatefulWidget {
  const DeviceNameScreen({super.key});

  @override
  State<DeviceNameScreen> createState() => _DeviceNameScreenState();
}

class _DeviceNameScreenState extends State<DeviceNameScreen> {
  final TextEditingController _modelController = TextEditingController(text: 'SM-S918B');
  final TextEditingController _deviceController = TextEditingController(text: 'dm3q');
  String _resultName = '';

  final List<Map<String, String>> _sampleDevices = [
    {'model': 'SM-S918B', 'device': 'dm3q', 'desc': 'Samsung Flagship'},
    {'model': 'Pixel 8 Pro', 'device': 'husky', 'desc': 'Google Flagship'},
    {'model': '23021RAA2Y', 'device': 'topaz', 'desc': 'Xiaomi Redmi Note 12'},
    {'model': 'T705J', 'device': 'Sunrise_CAN', 'desc': '10.or / TCL'},
    {'model': 'DIW362P 1U1', 'device': 'diw362_1u1', 'desc': '1&1 TV Box'},
    {'model': 'iPhone17,1', 'device': '', 'desc': 'Apple iPhone 16 Pro'},
    {'model': 'RealityDevice14,1', 'device': '', 'desc': 'Apple Vision Pro'},
  ];

  @override
  void initState() {
    super.initState();
    _performLookup();
  }

  void _performLookup() {
    final model = _modelController.text;
    final device = _deviceController.text.isEmpty ? null : _deviceController.text;

    final resolved = MobileDeviceName.instance.getMarketingName(
      model,
      device: device,
      fallback: 'Không tìm thấy (giữ nguyên: $model)',
    );

    setState(() {
      _resultName = resolved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu Tên Thiết bị'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nhập thông tin phần cứng:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Mã Model (Build.MODEL)',
                        hintText: 'Ví dụ: SM-S918B, Pixel 8 Pro',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _deviceController,
                      decoration: const InputDecoration(
                        labelText: 'Mã Device Codename (Tùy chọn)',
                        hintText: 'Ví dụ: dm3q, husky',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.memory),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _performLookup,
                      icon: const Icon(Icons.search),
                      label: const Text('Tra cứu tên thương mại'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.indigo.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.indigo.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TÊN THƯƠNG MẠI (MARKETING NAME):',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _resultName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chọn mẫu thiết bị thử nghiệm nhanh:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sampleDevices.map((d) {
                return ActionChip(
                  avatar: const Icon(Icons.touch_app, size: 16),
                  label: Text('${d['model']} (${d['desc']})'),
                  onPressed: () {
                    _modelController.text = d['model']!;
                    _deviceController.text = d['device']!;
                    _performLookup();
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
