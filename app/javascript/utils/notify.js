export function notify(type, msg, title, duration) {
  let container = document.getElementById("notification-container");
  if (!container) {
    container = document.createElement("div");
    container.id = "notification-container";
    const wrapper = document.querySelector("main.wrapper");
    if (wrapper) {
      wrapper.insertBefore(container, wrapper.firstChild);
    } else {
      document.body.appendChild(container);
    }
  }

  const defaultType = 'info';

  const icons = {
    info: "bi-info-circle",
    success: "bi-check-circle",
    alert: "bi-exclamation-triangle",
    error: "bi-x-circle"
  };

  let notification = document.createElement("div");

  const isKnown = Object.keys(icons).includes(type);
  const finalType = isKnown ? type : defaultType;
  const finalTitle = title || (isKnown ? (type.charAt(0).toUpperCase() + type.slice(1)) : defaultType.charAt(0).toUpperCase() + defaultType.slice(1));
  const finalIcon = isKnown ? icons[type] : "bi-bell";

  notification.className = `notification ${finalType}`;

  const hasHeader = finalTitle || finalIcon;

  notification.innerHTML = `
    ${hasHeader ? `
      <div class="notification-header">
        ${finalIcon ? `<i class="bi ${finalIcon}"></i>` : ''}
        ${finalTitle ? `<span class="notification-title">${finalTitle}</span>` : ''}
      </div>
    ` : ''}
    <div class="notification-body">${msg}</div>
  `;

  container.appendChild(notification);

  requestAnimationFrame(() => {
    notification.classList.add("visible");
  });

  setTimeout(() => {
    notification.classList.remove("visible");
    notification.classList.add("fade-out");

    notification.addEventListener(
      "transitionend",
      () => {
        notification.remove();
        if (container.children.length === 0) {
          container.remove();
        }
      }, {
      once: true
    }
    );
  }, duration);
};
