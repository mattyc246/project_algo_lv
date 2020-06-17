// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss";
import "bootstrap";
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";
import Chartkick from "chartkick";
import Chart from "chart.js";
import Hooks from "./hooks"
import "./stripe"

Chartkick.use(Chart);

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks,
  params: { _csrf_token: csrfToken },
});


// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", (info) => NProgress.start());
window.addEventListener("phx:page-loading-stop", (info) => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

let menuButton = document.querySelector(".burger");
// let dashMenu = document.querySelector(".dash-nav");
// let dashContent = document.querySelector(".dash-content")

// menuButton.addEventListener("click", () => {
//   if (dashMenu.classList.contains("expanded")) {
//     dashMenu.classList.remove("expanded");
//     dashContent.classList.remove("expanded")
//   } else {
//     dashMenu.classList.add("expanded");
//     dashContent.classList.add("expanded");
//   }
// });

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;
