import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camper 3D Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Discover your camper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Flutter3DController controller = Flutter3DController();
  final String srcGlb = 'assets/campervan.glb';
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
      controller.setCameraOrbit(45, 80, 90);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // TOP: Horizontal ListView with icon, bold title, and subtitle
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFeatureCard(Icons.directions_bike, 'Bike rack', 'Everyone’s asking about it.'),
                _buildFeatureCard(Icons.water_drop, 'Water', 'Everyone’s asking about it.'),
                _buildFeatureCard(Icons.roofing, 'Roof tent', 'Everyone’s asking about it.'),
              ],
            ),
          ),

          // MIDDLE: 3D Model Viewer
          Flexible(
            child: Flutter3DViewer(
              activeGestureInterceptor: true,
              progressBarColor: Colors.orange,
              enableTouch: true,
              onProgress: (double progressValue) {
                debugPrint('model loading progress : $progressValue');
              },
              onLoad: (String modelAddress) {
                debugPrint('model loaded : $modelAddress');
                controller.playAnimation();
              },
              onError: (String error) {
                debugPrint('model failed to load : $error');
              },
              controller: controller,
              src: srcGlb,
            ),
          ),

          SleekCircularSlider(
            initialValue: _sliderValue,
            min: 0,
            max: 360,
            appearance: CircularSliderAppearance(
              angleRange: 180,
              startAngle: 180,
              size: 200,
              customWidths: CustomSliderWidths(
                trackWidth: 2,
                progressBarWidth: 4,
                handlerSize: 12,
              ),
              customColors: CustomSliderColors(
                progressBarColor: Colors.black,
                trackColor: Colors.grey.shade300,
                dotColor: Colors.black,
              ),
              infoProperties: InfoProperties(
                modifier: (value) => '',
              ),
            ),
            onChange: (value) {
              setState(() {
                _sliderValue = value;
                controller.setCameraOrbit(value, 80, 120); // Smooth horizontal rotation
              });
            },
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.playAnimation();
        },
        tooltip: 'Play Animation',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

}
