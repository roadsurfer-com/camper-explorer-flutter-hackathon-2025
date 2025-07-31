import { animate } from './src/scene.js';
import { loadModel } from './src/model.js';
import { setupClickHandler, setupHoverHandler } from './src/interactions.js';

// Initialize the application
loadModel();
setupClickHandler();
setupHoverHandler();
animate();
