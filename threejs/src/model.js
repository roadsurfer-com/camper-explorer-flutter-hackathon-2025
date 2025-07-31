import * as THREE from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';
import { scene, camera, controls } from './scene.js';

export let van = null;
export const clickableMeshes = [];

// Materials
const hotspotMaterial = new THREE.MeshBasicMaterial({
  visible: false,
});

const highlightMaterial = new THREE.MeshBasicMaterial({
  color: 0xff00ff,
  transparent: true,
  opacity: 0.3,
  visible: true,
});

// Create hotspot and highlight for a part
function createInteractivePart(geometry, position, name) {
  // Create hotspot
  const hotspot = new THREE.Mesh(geometry, hotspotMaterial);
  hotspot.position.copy(position);
  hotspot.userData = { name };
  scene.add(hotspot);
  clickableMeshes.push(hotspot);

  // Create highlight
  const highlight = new THREE.Mesh(geometry, highlightMaterial.clone());
  highlight.position.copy(position);
  hotspot.userData.highlightMesh = highlight;
  scene.add(highlight);
  hotspot.userData.highlightMesh.visible = false;

  return { hotspot, highlight };
}

// Load the van model and set up interactive parts
export function loadModel() {
  const gltfLoader = new GLTFLoader();

  gltfLoader.load(
    './assets/volkswagen_t2_campervan.glb',
    (gltf) => {
      van = gltf.scene;

      // Scale and position the van
      van.scale.set(0.01, 0.01, 0.01);
      van.position.set(0, 0, 0);

      // Store original materials
      van.traverse((child) => {
        if (child.isMesh) {
          child.userData.originalMaterial = child.material;
        }
      });

      scene.add(van);

      // Create interactive parts
      const doorGeo = new THREE.BoxGeometry(0.2, 1.4, 1.1);
      createInteractivePart(
        doorGeo,
        new THREE.Vector3(-0.8, 1.1, 0.15),
        'side_door'
      );

      // Create interactive parts
      const trunkGeo = new THREE.BoxGeometry(1.5, 1.2, 0.6);
      createInteractivePart(trunkGeo, new THREE.Vector3(0, 1.1, -1.9), 'trunk');

      // Create wheel geometry and rotate it to stand upright
      const wheelGeo = new THREE.CylinderGeometry(0.3, 0.3, 0.3, 32);
      wheelGeo.rotateZ(Math.PI / 2); // Rotate the geometry to make wheel stand upright

      // Front Left Wheel
      const frontLeftWheelPosition = new THREE.Vector3(0.7, 0.35, 1.15);
      createInteractivePart(
        wheelGeo,
        frontLeftWheelPosition,
        'front_left_wheel'
      );

      // Front Right Wheel
      const frontRightWheelPosition = new THREE.Vector3(-0.7, 0.35, 1.15);
      createInteractivePart(
        wheelGeo,
        frontRightWheelPosition,
        'front_right_wheel'
      );

      // Front Left Wheel
      const backLeftWheelPosition = new THREE.Vector3(0.7, 0.35, -1.22);
      createInteractivePart(wheelGeo, backLeftWheelPosition, 'back_left_wheel');

      // Front Right Wheel
      const backRightWheelPosition = new THREE.Vector3(-0.7, 0.35, -1.22);
      createInteractivePart(
        wheelGeo,
        backRightWheelPosition,
        'back_right_wheel'
      );

      // Position camera
      camera.position.set(8, 4, 8);
      controls.target.set(0, 1, 0);
      controls.update();
    },
    (progress) => {
      console.log(
        'Loading progress:',
        (progress.loaded / progress.total) * 100 + '%'
      );
    },
    (error) => {
      console.error('Error loading VW van:', error);
    }
  );
}
