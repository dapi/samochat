// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//import "@hotwired/turbo-rails"
import "./controllers"
import "./channels"
import "./libs"
import * as bootstrap from 'bootstrap'

const onReady = function() {
  console.log("turbo:load emited");
  var option = { delay: 3000 }
  var toastElList = [].slice.call(document.querySelectorAll('.toast'))
  var toastList = toastElList.map(function (toastEl) {
    var toast = new bootstrap.Toast(toastEl, option)
    toast.show()
  })

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  hljs.highlightAll();
}

document.addEventListener("turbo:load", onReady);

// Чтобы флешки показывались на 422 после POST-запроса
document.addEventListener("turbo:render", onReady);

// Вынужден добавить из-за глюка в popper
window.process = { env: { NODE_ENV: 'production' } };
