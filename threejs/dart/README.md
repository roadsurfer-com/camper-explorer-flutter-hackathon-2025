# Camper Explorer - Dart Version

This is a Dart/Flutter version of the Camper Explorer project using the [three_dart](https://github.com/wasabia/three_dart) library, which is a Dart rewrite of Three.js.

## Features

- 3D van model with interactive parts
- Hover highlighting of clickable areas
- Mouse/touch interaction handling
- Orbit controls for camera manipulation
- Cross-platform support (Web, iOS, Android, macOS, Windows)

## Project Structure

```
dart/
├── lib/
│   ├── main.dart          # Main Flutter app entry point
│   ├── scene.dart         # Three.js scene setup and management
│   ├── model.dart         # 3D model loading and interactive parts
│   └── interactions.dart  # Mouse/touch interaction handling
├── pubspec.yaml          # Dart dependencies
└── README.md            # This file
```

## Dependencies

- **three_dart**: Dart 3D library (Three.js rewrite)
- **flutter_gl**: Flutter OpenGL integration
- **flutter**: Flutter framework

## Setup Instructions

1. **Install Flutter**: Make sure you have Flutter installed and configured
2. **Install Dependencies**: Run `flutter pub get` in the dart directory
3. **Run the App**: Use `flutter run` to start the application

## Key Differences from JavaScript Version

### Architecture

- **Object-Oriented Design**: Uses Dart classes instead of JavaScript modules
- **Flutter Integration**: Wrapped in a Flutter app for cross-platform deployment
- **Gesture Handling**: Uses Flutter's gesture detection instead of DOM events

### Scene Management

- `SceneManager` class handles all Three.js scene setup
- Materials are created and managed centrally
- Camera and controls are configured through the scene manager

### Model Loading

- Currently uses a placeholder van model (since GLTFLoader may not be available)
- Interactive parts are created with the same geometry and positioning
- Highlight materials work the same way as the JavaScript version

### Interactions

- Mouse events are handled through Flutter's gesture system
- Raycasting works the same way as Three.js
- Hover and click detection is adapted for Flutter widgets

## Usage

The Dart version provides the same functionality as the JavaScript version:

1. **View the 3D Van**: The app displays a 3D van model
2. **Hover Over Parts**: Interactive parts highlight when you hover over them
3. **Click on Parts**: Click on highlighted areas to trigger actions
4. **Camera Controls**: Use mouse/touch to orbit around the van

## Development Notes

- The current implementation uses a placeholder van model since GLTFLoader support may vary
- Some Three.js features might have different APIs in three_dart
- Flutter's gesture system replaces DOM event handling
- The animation loop uses Flutter's timing instead of requestAnimationFrame

## Future Improvements

- Add proper GLTF model loading
- Implement eye icons for better visual feedback
- Add more interactive features
- Optimize performance for mobile devices
- Add sound effects and animations

## Troubleshooting

If you encounter issues:

1. **Dependencies**: Make sure all dependencies are properly installed
2. **Flutter Version**: Ensure you're using a compatible Flutter version
3. **Platform Support**: Check that your target platform is supported
4. **Three_dart Version**: Verify you're using a compatible version of three_dart

## References

- [three_dart GitHub Repository](https://github.com/wasabia/three_dart)
- [Flutter Documentation](https://flutter.dev/docs)
- [Three.js Documentation](https://threejs.org/docs/)
