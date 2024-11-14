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

document.addEventListener("turbo:load", updateSpacerHeight);
document.addEventListener("DOMContentLoaded", updateSpacerHeight);
window.addEventListener("resize", updateSpacerHeight);
function updateSpacerHeight() {
	const image = document.getElementById("bg_image");
	const spacer = document.getElementById("spacer");
	if (image.offsetHeight === 0)
		spacer.style.height = `65vw`;
	else
		spacer.style.height = `${image.offsetHeight * 0.75}px`;
}

document.addEventListener("turbo:load", () => {
	document.querySelectorAll(".pictures_gallery img").forEach((img) => {
		img.addEventListener("mouseover", () => {
			const color = getAverageColor(img);
			img.style.setProperty('--hover-shadow-color', `rgba(${color.r}, ${color.g}, ${color.b}, 0.7)`);
		});
	});
});

// document.addEventListener("DOMContentLoaded", () => {
// 	const images = document.querySelectorAll('.pictures_gallery img');

// 	images.forEach((img) => {
// 		const color = getAverageColor(img);
// 		img.style.setProperty('--hover-shadow-color', `rgba(${color.r}, ${color.g}, ${color.b}, 0.7)`);
// 	});
// });


// document.addEventListener("turbo:load", () => {
//   const images = document.querySelectorAll('.pictures_gallery img');

//   Promise.all(Array.from(images).map(img => new Promise(resolve => {
//     img.addEventListener('load', resolve);
//   }))).then(() => {
//     images.forEach(img => {
//       const color = getAverageColor(img);
//       img.style.setProperty('--hover-shadow-color', `rgba(${color.r}, ${color.g}, ${color.b}, 0.7)`);
//     });
//   });
// });

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
