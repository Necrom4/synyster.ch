// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "ahoy";
import "ahoy/tracking";
import { notify } from "utils/notify";

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

window.addEventListener("scroll", () => {
  const num = (window.scrollY / window.innerHeight) * 16;

  if (num < 10) {
    const logo = document.getElementById("floating-logo");
    const bg = document.getElementById("bg_image");

    if (!logo || !bg) return;

    logo.style.transform = `scale(${1 - num / 100})`;
    bg.style.transform = `translateX(-50%) scale(${1 - num / 100})`;
    bg.style.filter = `blur(${num}px) brightness(${1 - num / 15})`;
  }
});

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
