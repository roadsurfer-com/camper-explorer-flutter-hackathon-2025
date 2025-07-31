import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'feature_details_page.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Discover your camper'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  final String imageAsset;

  const Feature(this.icon, this.title, this.subtitle,this.imageAsset);
}

final List<Feature> features = [
  Feature(Icons.directions_bike, 'Bike rack', 'Secure your bike by placing the front wheel into the designated slot and locking it with your personal lock. Make sure the bike is stable and properly positioned to prevent tipping or theft.','assets/images/bikerack.png'),
  Feature(Icons.water_drop, 'Water', 'To turn on the water supply, locate the main valve and rotate it clockwise to shut off or counterclockwise to open the flow. Ensure all taps are closed before turning the supply back on to avoid sudden pressure surges.','assets/images/water.png'),
  Feature(Icons.roofing, 'Rooftop bed', 'The rooftop bed can easily be opened using your camper control panel. Keep in mind that at least one window must be opened during opening and closing to avoid damage from overpressure or underpressure.','assets/images/rooftop.png'),
];


class _MyHomePageState extends State<MyHomePage> {
  final Flutter3DController controller = Flutter3DController();
  final String srcGlb = 'assets/campervan.glb';
  double _sliderValue = 0;

  Feature? _selectedFeature;
  final Feature _defaultFeature = Feature(Icons.help, 'none', '', '');

  //String? _selectedFeature;
  //final String _defaultFeature = 'none';

  @override
  void initState() {
    super.initState();
    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
      _resetCamera(); // Set default view
    });
  }

  void _resetCamera() {
    controller.setCameraTarget(0, 1.5, 0);
    controller.setCameraOrbit(45, 65, 120);
  }

  void _focusFeature(String feature) {
    switch (feature) {
      case 'Bike rack':
        controller.setCameraTarget(0, 1.5, 0);
        controller.setCameraOrbit(180, 70, 60);
        break;
      case 'Water':
        controller.setCameraTarget(0, 1.5, 1);
        controller.setCameraOrbit(220, 70, 40);
        break;
      case 'Rooftop bed':
        controller.setCameraTarget(0, 1, 0);
        controller.setCameraOrbit(0, 0, 80);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // TOP: Horizontal ListView with icons
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: features.map(_buildFeatureCard).toList(),
                  ),
                ),
              ),

              // MIDDLE: 3D Viewer
              Expanded(
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

              // BOTTOM: Curved slider for manual rotation
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SleekCircularSlider(
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
                    infoProperties: InfoProperties(modifier: (value) => ''),
                  ),
                  onChange: (value) {
                    setState(() {
                      _sliderValue = value;
                      controller.setCameraOrbit(value, 80, 120);
                    });
                  },
                ),
              ),
            ],
          ),

          // Floating label for selected feature
         if (_selectedFeature != null && _selectedFeature!.title != _defaultFeature.title)
            Positioned(
              top: 130,
              right: 16,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: () => _openFeatureDetails(_selectedFeature!),
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.deepPurple,
                ),
                label: Text(
                  _selectedFeature!.title,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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

  void _openFeatureDetails(Feature feature) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FeatureDetailPage(
          feature: feature.title,
          imageAsset: feature.imageAsset,
          subtitle: feature.subtitle,
        ),
      ),
    );
  }

  // Card builder
  Widget _buildFeatureCard(Feature feature) {
  return GestureDetector(
    onTap: () {
      setState(() {
        if (_selectedFeature == feature) {
          _selectedFeature = _defaultFeature;
          _resetCamera();
        } else {
          _selectedFeature = feature;
          _focusFeature(feature.title);
        }
      });
      // _openFeatureDetails(feature); // now passing the whole object
    },
    child: Container(
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
          Icon(feature.icon, size: 24, color: Colors.black87),
          const SizedBox(height: 8),
          Text(feature.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          //Text(feature.subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}

}
