import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart';
import 'package:flutter_gl/flutter_gl.dart';

class SceneManager {
  late Scene scene;
  late PerspectiveCamera camera;
  late WebGLRenderer renderer;
  late OrbitControls controls;
  
  // Materials
  late MeshBasicMaterial hotspotMaterial;
  late MeshBasicMaterial highlightMaterial;

  SceneManager() {
    _initializeScene();
    _setupMaterials();
  }

  void _initializeScene() {
    // Scene setup
    scene = Scene();
    
    // Camera setup
    camera = PerspectiveCamera(75, 1, 0.1, 1000);
    camera.position.setValues(8, 4, 8);
    
    // Renderer setup
    renderer = WebGLRenderer({
      "antialias": true,
      "alpha": true,
    });
    
    // Lighting setup
    final ambientLight = AmbientLight(0xffffff, 1.2);
    scene.add(ambientLight);

    final directionalLight = DirectionalLight(0xffffff, 1.0);
    directionalLight.position.setValues(10, 10, 5);
    scene.add(directionalLight);

    final directionalLight2 = DirectionalLight(0xffffff, 0.8);
    directionalLight2.position.setValues(-10, 8, -5);
    scene.add(directionalLight2);

    final directionalLight3 = DirectionalLight(0xffffff, 0.6);
    directionalLight3.position.setValues(0, 15, 0);
    scene.add(directionalLight3);
  }

  void _setupMaterials() {
    // Materials
    hotspotMaterial = MeshBasicMaterial({
      "visible": false,
    });

    highlightMaterial = MeshBasicMaterial({
      "color": 0xff00ff,
      "transparent": true,
      "opacity": 0.3,
      "visible": true,
    });
  }

  void setupRenderer(FlutterGlPlugin flutterGl) {
    renderer = WebGLRenderer({
      "canvas": flutterGl.canvasId,
      "antialias": true,
      "alpha": true,
    });
    renderer.setSize(800, 600);
    renderer.setClearColor(0xffffff, 1.0);
  }

  void setupControls(FlutterGlPlugin flutterGl) {
    controls = OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.05;
    controls.screenSpacePanning = false;
    controls.minDistance = 3;
    controls.maxDistance = 5;
    controls.minPolarAngle = 0;
    controls.maxPolarAngle = 3.14159 / 2;
    controls.target.setValues(0, 1, 0);
    controls.update();
  }

  void resize(int width, int height) {
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize(width, height);
  }

  void render() {
    controls.update();
    renderer.render(scene, camera);
  }

  Scene getScene() => scene;
  PerspectiveCamera getCamera() => camera;
  WebGLRenderer getRenderer() => renderer;
  OrbitControls getControls() => controls;
  MeshBasicMaterial getHotspotMaterial() => hotspotMaterial;
  MeshBasicMaterial getHighlightMaterial() => highlightMaterial;
} 