import * as THREE from 'three';
import { camera } from './scene.js';
import { clickableMeshes } from './model.js';

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
