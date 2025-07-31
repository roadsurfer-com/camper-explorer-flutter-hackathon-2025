import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';

// Setup raycaster and mouse vector
const raycaster = new THREE.Raycaster();
const mouse = new THREE.Vector2();

// Track last hovered object
let lastHovered = null;

// Part click handlers
function handlePartClick(partName) {
  console.log(`Clicked on: ${partName}`);
}

// Setup click handler
export function setupClickHandler() {
  window.addEventListener('click', (event) => {
    mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
    mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;

    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects(clickableMeshes);

    if (intersects.length > 0) {
      const clickedHotspot = intersects[0].object;
      handlePartClick(clickedHotspot.userData.name);
    }
  });
}

// Setup hover handler
export function setupHoverHandler() {
  window.addEventListener('mousemove', (event) => {
    mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
    mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;

    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects(clickableMeshes);

    if (intersects.length > 0) {
      const currentlyHovered = intersects[0].object;

      if (lastHovered !== currentlyHovered) {
        // Hide previous highlight
        if (lastHovered && lastHovered.userData.highlightMesh) {
          lastHovered.userData.highlightMesh.visible = false;
        }

        // Show new highlight
        if (currentlyHovered.userData.highlightMesh) {
          currentlyHovered.userData.highlightMesh.visible = true;
        }

        lastHovered = currentlyHovered;
      }
    } else {
      // Hide last highlight when not hovering over any object
      if (lastHovered && lastHovered.userData.highlightMesh) {
        lastHovered.userData.highlightMesh.visible = false;
      }
      lastHovered = null;
    }
  });
}

export let van = null;
export const clickableMeshes = [];

// Materials
const hotspotMaterial = new THREE.MeshBasicMaterial({
  visible: false,
});

const highlightMaterial = new THREE.MeshBasicMaterial({
  color: 0x808080,
  transparent: true,
  opacity: 0.7,
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
      //   const doorGeo = new THREE.BoxGeometry(1.5, 2, 0.5);
      //   createInteractivePart(
      //     doorGeo,
      //     new THREE.Vector3(-0.4, 1.2, 1.4),
      //     'side_door'
      //   );

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

// Scene setup
export const scene = new THREE.Scene();
export const camera = new THREE.PerspectiveCamera(
  75,
  window.innerWidth / window.innerHeight,
  0.1,
  1000
);

// Renderer setup
export const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setClearColor(0xffffff);
document.body.appendChild(renderer.domElement);

// Camera and controls setup
export const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.05;
controls.screenSpacePanning = false;
controls.minDistance = 3;
controls.maxDistance = 5;
controls.minPolarAngle = 0;
controls.maxPolarAngle = Math.PI / 2;

// Lighting setup
const ambientLight = new THREE.AmbientLight(0xffffff, 1.2);
scene.add(ambientLight);

const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
directionalLight.position.set(10, 10, 5);
scene.add(directionalLight);

const directionalLight2 = new THREE.DirectionalLight(0xffffff, 0.8);
directionalLight2.position.set(-10, 8, -5);
scene.add(directionalLight2);

const directionalLight3 = new THREE.DirectionalLight(0xffffff, 0.6);
directionalLight3.position.set(0, 15, 0);
scene.add(directionalLight3);

// Handle window resize
window.addEventListener('resize', () => {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
});

// Animation loop
export function animate() {
  requestAnimationFrame(animate);
  controls.update();
  renderer.render(scene, camera);
}

// Initialize the application
loadModel();
setupClickHandler();
setupHoverHandler();
animate();
