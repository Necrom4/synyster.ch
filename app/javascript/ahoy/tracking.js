/* global ahoy */

document.addEventListener("turbo:load", () => {
  ahoy.trackView();
});

if (!window.ahoyHeartbeatInterval) {
  window.ahoyHeartbeatInterval = setInterval(() => {
    ahoy.track(
      "$heartbeat",
      { path: window.location.pathname },
      { language: "JavaScript" },
    );
  }, 2000);
}
