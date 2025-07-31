import 'package:three_dart/three_dart.dart';
import 'scene.dart';

class ModelManager {
  Object3D? van;
  final List<Mesh> clickableMeshes = [];
  final SceneManager sceneManager;

  ModelManager(this.sceneManager);

  // Create hotspot and highlight for a part
  Map<String, Object3D> createInteractivePart(
      BufferGeometry geometry, Vector3 position, String name) {
    // Create hotspot
    final hotspot = Mesh(geometry, sceneManager.getHotspotMaterial());
    hotspot.position.copy(position);
    hotspot.userData = {"name": name};
    sceneManager.getScene().add(hotspot);
    clickableMeshes.add(hotspot);

    // Create highlight
    final highlight = Mesh(geometry, sceneManager.getHighlightMaterial().clone());
    highlight.position.copy(position);
    hotspot.userData["highlightMesh"] = highlight;
    sceneManager.getScene().add(highlight);
    highlight.visible = false;

    return {"hotspot": hotspot, "highlight": highlight};
  }

  // Load the van model and set up interactive parts
  Future<void> loadModel() async {
    try {
      // For now, we'll create a simple placeholder since GLTFLoader might not be available
      // In a real implementation, you'd use the GLTFLoader from three_dart
      
      // Create a simple van placeholder
      van = _createVanPlaceholder();
      
      // Scale and position the van
      van!.scale.setValues(0.01, 0.01, 0.01);
      van!.position.setValues(0, 0, 0);

      // Store original materials
      van!.traverse((child) {
        if (child is Mesh) {
          child.userData["originalMaterial"] = child.material;
        }
      });

      sceneManager.getScene().add(van!);

      // Create interactive parts
      _createInteractiveParts();

      // Position camera
      sceneManager.getCamera().position.setValues(8, 4, 8);
      sceneManager.getControls().target.setValues(0, 1, 0);
      sceneManager.getControls().update();
      
    } catch (error) {
      print('Error loading VW van: $error');
    }
  }

  Object3D _createVanPlaceholder() {
    // Create a simple van shape as placeholder
    final group = Group();
    
    // Van body
    final bodyGeometry = BoxGeometry(2.0, 1.5, 4.0);
    final bodyMaterial = MeshPhongMaterial({"color": 0x2196F3});
    final body = Mesh(bodyGeometry, bodyMaterial);
    body.position.setValues(0, 0.75, 0);
    group.add(body);
    
    // Van roof
    final roofGeometry = BoxGeometry(1.8, 0.5, 2.0);
    final roofMaterial = MeshPhongMaterial({"color": 0x1976D2});
    final roof = Mesh(roofGeometry, roofMaterial);
    roof.position.setValues(0, 1.5, -0.5);
    group.add(roof);
    
    // Windows
    final windowGeometry = BoxGeometry(1.9, 0.8, 0.1);
    final windowMaterial = MeshPhongMaterial({
      "color": 0x87CEEB,
      "transparent": true,
      "opacity": 0.7
    });
    
    // Front window
    final frontWindow = Mesh(windowGeometry, windowMaterial);
    frontWindow.position.setValues(0, 1.0, 2.0);
    group.add(frontWindow);
    
    // Side windows
    final sideWindowGeometry = BoxGeometry(0.1, 0.8, 1.5);
    final leftWindow = Mesh(sideWindowGeometry, windowMaterial);
    leftWindow.position.setValues(1.0, 1.0, 0);
    group.add(leftWindow);
    
    final rightWindow = Mesh(sideWindowGeometry, windowMaterial);
    rightWindow.position.setValues(-1.0, 1.0, 0);
    group.add(rightWindow);
    
    return group;
  }

  void _createInteractiveParts() {
    // Create interactive parts
    final doorGeo = BoxGeometry(0.2, 1.4, 1.1);
    createInteractivePart(
        doorGeo, Vector3(-0.8, 1.1, 0.15), 'side_door');

    // Create trunk
    final trunkGeo = BoxGeometry(1.5, 1.2, 0.6);
    createInteractivePart(trunkGeo, Vector3(0, 1.1, -1.9), 'trunk');

    // Create wheel geometry and rotate it to stand upright
    final wheelGeo = CylinderGeometry(0.3, 0.3, 0.3, 32);
    wheelGeo.rotateZ(3.14159 / 2); // Rotate the geometry to make wheel stand upright

    // Front Left Wheel
    final frontLeftWheelPosition = Vector3(0.7, 0.35, 1.15);
    createInteractivePart(wheelGeo, frontLeftWheelPosition, 'front_left_wheel');

    // Front Right Wheel
    final frontRightWheelPosition = Vector3(-0.7, 0.35, 1.15);
    createInteractivePart(wheelGeo, frontRightWheelPosition, 'front_right_wheel');

    // Back Left Wheel
    final backLeftWheelPosition = Vector3(0.7, 0.35, -1.22);
    createInteractivePart(wheelGeo, backLeftWheelPosition, 'back_left_wheel');

    // Back Right Wheel
    final backRightWheelPosition = Vector3(-0.7, 0.35, -1.22);
    createInteractivePart(wheelGeo, backRightWheelPosition, 'back_right_wheel');
  }

  Object3D? getVan() => van;
  List<Mesh> getClickableMeshes() => clickableMeshes;
} 