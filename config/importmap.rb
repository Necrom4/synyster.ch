# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@fancyapps/ui", to: "@fancyapps--ui.js" # @6.1.7
pin "ahoy.js" # @0.4.4
pin "ahoy/tracking", to: "ahoy/tracking.js"
pin "utils/notify", to: "utils/notify.js"
pin "bootstrap" # @5.3.8
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
