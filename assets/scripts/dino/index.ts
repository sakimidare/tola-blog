/**
 * Ported from the Chromium offline T-Rex runner (BSD-3-Clause).
 * Extracted from the Chromium source code.
 */
import { Runner } from './runner.js';

/** Start the T-Rex runner if the container is present in the page. */
export function initDino(selector = '.interstitial-wrapper'): void {
  if (document.querySelector(selector)) {
    new Runner(selector);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  initDino();
});
