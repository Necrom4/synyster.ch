// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "ahoy";
import "ahoy/tracking";
import { notify } from "utils/notify";
import * as bootstrap from "bootstrap";

// Transform logo and background on scroll
let ticking = false;
window.addEventListener("scroll", () => {
  if (ticking) return;

  ticking = true;
  requestAnimationFrame(() => {
    const num = (window.scrollY / window.innerHeight) * 16;

    if (num < 10) {
      const logo = document.getElementById("floating-logo");
      const bg = document.getElementById("bg_image");

      if (logo && bg) {
        logo.style.transform = `scale(${1 - num / 100})`;
        bg.style.transform = `translateX(-50%) scale(${1 - num / 100})`;
        bg.style.filter = `blur(${num}px) brightness(${1 - num / 15})`;
      }
    }

    ticking = false;
  });
});

// Collapse gallery
document.addEventListener("turbo:load", () => {
  const galleries = document.querySelectorAll(".masonry");
  initMasonry(galleries);

  const collapseGalleries = document.querySelectorAll(".masonry.collapse");
  collapseGalleries.forEach((gallery) => {
    gallery.addEventListener("shown.bs.collapse", () => {
      initMasonry([gallery]);
    });
  });
});

function initMasonry(galleries) {
  if (typeof imagesLoaded === "undefined" || typeof Masonry === "undefined") {
    console.warn("Masonry or imagesLoaded not loaded");
    return;
  }

  galleries.forEach((gallery) => {
    imagesLoaded(gallery, () => {
      new Masonry(gallery, {
        itemSelector: ".col",
        percentPosition: true,
      });
    });
  });
}

window.notify = notify;
