import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  Flutter3DController controller = Flutter3DController();
  String srcGlb = 'assets/campervan.glb';

  @override
  void initState() {
    super.initState();
    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Flexible(
          flex: 1,
          child: Flutter3DViewer(
            activeGestureInterceptor: true,
            progressBarColor: Colors.orange,
            enableTouch: true,
            //This callBack will return the loading progress value between 0 and 1.0
            onProgress: (double progressValue) {
              debugPrint('model loading progress : $progressValue');
            },
            //This callBack will call after model loaded successfully and will return model address
            onLoad: (String modelAddress) {
              debugPrint('model loaded : $modelAddress');
              controller.playAnimation();
            },
            //this callBack will call when model failed to load and will return failure error
            onError: (String error) {
              debugPrint('model failed to load : $error');
            },
            //You can have full control of 3d model animations, textures and camera
            controller: controller,
            src: srcGlb,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // controller.setCameraOrbit(90, 180, 90);
          controller.setCameraTarget(90, 90, 90);
        },
        tooltip: 'Play Animation',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
