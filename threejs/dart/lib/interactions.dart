import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart';
import 'scene.dart';
import 'model.dart';

class InteractionManager {
  final SceneManager sceneManager;
  final ModelManager modelManager;
  
  late Raycaster raycaster;
  late Vector2 mouse;
  Object3D? lastHovered;

  InteractionManager(this.sceneManager, this.modelManager) {
    _initialize();
  }

  void _initialize() {
    raycaster = Raycaster();
    mouse = Vector2();
  }

  // Part click handlers
  void handlePartClick(String partName) {
    print('Clicked on: $partName');
  }

  // Setup click handler
  void setupClickHandler(FlutterGlPlugin flutterGl) {
    // In Flutter, we'll handle this through gesture detection
    // This is a placeholder for the click handling logic
  }

  // Handle tap events from Flutter
  void handleTap(TapDownDetails details, Size size) {
    mouse.x = (details.globalPosition.dx / size.width) * 2 - 1;
    mouse.y = -(details.globalPosition.dy / size.height) * 2 + 1;

    raycaster.setFromCamera(mouse, sceneManager.getCamera());
    final intersects = raycaster.intersectObjects(modelManager.getClickableMeshes());

    if (intersects.isNotEmpty) {
      final clickedHotspot = intersects[0]["object"] as Object3D;
      handlePartClick(clickedHotspot.userData["name"]);
    }
  }

  // Setup hover handler
  void setupHoverHandler(FlutterGlPlugin flutterGl) {
    // In Flutter, we'll handle this through mouse tracking
    // This is a placeholder for the hover handling logic
  }

  // Handle hover events from Flutter
  void handleHover(PointerHoverEvent event, Size size) {
    mouse.x = (event.position.dx / size.width) * 2 - 1;
    mouse.y = -(event.position.dy / size.height) * 2 + 1;

    raycaster.setFromCamera(mouse, sceneManager.getCamera());
    final intersects = raycaster.intersectObjects(modelManager.getClickableMeshes());

    if (intersects.isNotEmpty) {
      final currentlyHovered = intersects[0]["object"] as Object3D;

      if (lastHovered != currentlyHovered) {
        // Hide previous highlight
        if (lastHovered != null && lastHovered!.userData["highlightMesh"] != null) {
          final highlightMesh = lastHovered!.userData["highlightMesh"] as Object3D;
          highlightMesh.visible = false;
        }

        // Show new highlight
        if (currentlyHovered.userData["highlightMesh"] != null) {
          final highlightMesh = currentlyHovered.userData["highlightMesh"] as Object3D;
          highlightMesh.visible = true;
        }

        lastHovered = currentlyHovered;
      }
    } else {
      // Hide last highlight when not hovering over any object
      if (lastHovered != null && lastHovered!.userData["highlightMesh"] != null) {
        final highlightMesh = lastHovered!.userData["highlightMesh"] as Object3D;
        highlightMesh.visible = false;
      }
      lastHovered = null;
    }
  }

  // Handle mouse exit
  void handleMouseExit() {
    // Hide last highlight when mouse exits the area
    if (lastHovered != null && lastHovered!.userData["highlightMesh"] != null) {
      final highlightMesh = lastHovered!.userData["highlightMesh"] as Object3D;
      highlightMesh.visible = false;
    }
    lastHovered = null;
  }
} 