import 'package:flutter/material.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart';
import 'scene.dart';
import 'model.dart';
import 'interactions.dart';

void main() {
  runApp(const CamperExplorerApp());
}

class CamperExplorerApp extends StatelessWidget {
  const CamperExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camper Explorer Dart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CamperExplorerPage(),
    );
  }
}

class CamperExplorerPage extends StatefulWidget {
  const CamperExplorerPage({super.key});

  @override
  State<CamperExplorerPage> createState() => _CamperExplorerPageState();
}

class _CamperExplorerPageState extends State<CamperExplorerPage> {
  late FlutterGlPlugin flutterGl;
  late SceneManager sceneManager;
  late ModelManager modelManager;
  late InteractionManager interactionManager;
  
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeThreeJS();
  }

  Future<void> _initializeThreeJS() async {
    // Initialize Flutter GL
    flutterGl = FlutterGlPlugin();
    
    // Initialize scene manager
    sceneManager = SceneManager();
    
    // Initialize model manager
    modelManager = ModelManager(sceneManager);
    
    // Initialize interaction manager
    interactionManager = InteractionManager(sceneManager, modelManager);
    
    // Setup renderer and controls
    sceneManager.setupRenderer(flutterGl);
    sceneManager.setupControls(flutterGl);
    
    // Load model
    await modelManager.loadModel();
    
    // Start animation loop
    _startAnimationLoop();
    
    setState(() {
      initialized = true;
    });
  }

  void _startAnimationLoop() {
    Future.delayed(const Duration(milliseconds: 16), () {
      if (mounted) {
        sceneManager.render();
        _startAnimationLoop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camper Explorer - Dart Version'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: initialized
          ? _buildThreeJSView()
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildThreeJSView() {
    return GestureDetector(
      onTapDown: (details) {
        final size = MediaQuery.of(context).size;
        interactionManager.handleTap(details, size);
      },
      onHover: (event) {
        final size = MediaQuery.of(context).size;
        interactionManager.handleHover(event, size);
      },
      onExit: (_) {
        interactionManager.handleMouseExit();
      },
      child: FlutterGlWidget(
        flutterGl: flutterGl,
        onWebViewCreated: (controller) {
          // WebView controller setup if needed
        },
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  @override
  void dispose() {
    flutterGl.dispose();
    super.dispose();
  }
} 