// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
// import { Fancybox } from "@fancyapps/ui";
// import "@fancyapps/ui/dist/fancybox/fancybox.css";

function sleep(ms) {
	return new Promise(resolve => setTimeout(resolve, ms));
}

window.addEventListener('scroll', function() {
	let num = (window.scrollY/window.innerHeight)*16;

	if (num < 10) {
		document.getElementById('floating-logo').style.transform = 'scale(' + (1 - num / 100) + ')'
		document.getElementById('bg_image').style.transform = 'translateX(-50%) scale(' + (1 - num / 100) + ')'
		document.getElementById('bg_image').style.webkitFilter = 'blur(' + num + 'px) brightness(' + (1 - (num / 15)) + ')'
	}
	// if (num > 8 && num < 10) {
	// 	document.getElementById('neon-logo').style.background = `rgba(0, 0, 0, ${1 / num * 10})`
	// }
})

document.addEventListener("DOMContentLoaded", () => {
    const images = document.querySelectorAll('.gallery_image');

    images.forEach((img) => {
        img.addEventListener("load", () => {
            const color = getAverageColor(img);
            img.style.setProperty('--hover-shadow-color', `rgba(${color.r}, ${color.g}, ${color.b}, 0.7)`);
        });
    });
});

function getAverageColor(img) {
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');

    canvas.width = img.width;
    canvas.height = img.height;
    context.drawImage(img, 0, 0, img.width, img.height);

    const imageData = context.getImageData(0, 0, img.width, img.height);
    const data = imageData.data;
    let r = 0, g = 0, b = 0;

    for (let i = 0; i < data.length; i += 4) {
        r += data[i];
        g += data[i + 1];
        b += data[i + 2];
    }

    const pixelCount = data.length / 4;
    r = Math.floor(r / pixelCount);
    g = Math.floor(g / pixelCount);
    b = Math.floor(b / pixelCount);

    return { r, g, b };
}
