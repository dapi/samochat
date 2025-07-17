
(function(window) {
if (!window.) { window.Widget = {}; }

  var projectKeyAttribute = 'data--pk';
  var widgetElId = "-button-widget";
  var widgetCssClass = "-button-widget";

  function getAllWidgets() {
    var widgets = [];
    if (document.querySelectorAll) {
      widgets = document.querySelectorAll(`script[]`);
    } else {
      widgets = Array.prototype.slice.apply(document.getElementsByTagName('SCRIPT'));
    }
    return widgets;
  }

  function insertStyles() {
  var stylesId = "-button-widget-styles";
    if (document.getElementById(stylesId)) { return };
    const style = document.createElement("style");
    style.id = stylesId;
    style.textContent = `. { 
    position:fixed;
    bottom:0;left:0;
    margin:1em;
    background:none;
    z-index:9999;
    transition:all 0.3s ease;
    animation: -widget-popup ease 0.3s;
    // opacity:0;
    transform: scale(1);
    &:hover { 
      opacity: 1; 
      transform: scale(1.05);
     }
    }
    . > img {
      border-radius: 50%;
      box-shadow: 5px 6px 35px -7px rgba(34, 60, 80, 0.41);;
     }
    .:hover > img {
      box-shadow: 5px 6px 45px -7px rgba(34, 60, 80, 0.41);
     }
     @keyframes -widget-popup {
      0%{ transform: scale(1); opacity: 0.3; }
      50%{ transform: scale(0.9); opacity: 1; }
      100%{ transform: scale(1); opacity: 0.9 }
    }
    `;
    document.head.appendChild(style);
  }

  function initWidget(widgetEl) {
    var widgetProjectKey;
    var size = widgetEl.getAttribute('data-size') || 50;
    if (!widgetEl.tagName || !(widgetEl.tagName.toUpperCase() == 'SCRIPT')) {
      return null;
    }
    if (window.Widget.widgetEl && document.getElementById(widgetElId)) {
      return true;
    }

    insertStyles();
    if (widgetProjectKey = (widgetEl.getAttribute(projectKeyAttribute) || widgetEl.getAttribute('data-pk'))) {
      var a = document.createElement('A');

      console.log('Create  button widget');
      a.id = widgetElId;
      a.setAttribute('title', widgetEl.getAttribute('data-title') || "Нажмите чтобы связаться с оператором");
      a.setAttribute('target', '_blank');
      a.setAttribute('rel', 'noopener');
      a.setAttribute('class', widgetCssClass);

      // TODO: Update data attributes on click
      var params = '?pk=' + widgetProjectKey + '&t=' + Date.now();

      if (widgetEl.getAttribute('data-user')) { params += '&user=' + widgetEl.getAttribute('data-user'); }
      if (widgetEl.getAttribute('data-page')) { params += '&page=' + widgetEl.getAttribute('data-page'); }
      if (widgetEl.getAttribute('data-visit')) { params += '&visit=' + widgetEl.getAttribute('data-visit'); }

      a.href='<%= Rails.application.routes.url_helpers.v_url %>' + params;
      var img = document.createElement('IMG');
      img.width = img.height = size;
      // img.src="<%= image_url 'telegram_logo.svg?pk=' %>";
      img.src='<%= Rails.application.routes.url_helpers.i_url(format: :svg) %>' + params;
      a.appendChild(img);
      document.body.appendChild(a);
    } else {
      console.log(`Nuichat widget script has no "" attribute. Initialization canceled..`);
    }
    window.Widget.widgetEl = widgetEl;
    return true;
  }

  if (!document.currentScript ||
    !initWidget(document.currentScript)) {
    var widgets = getAllWidgets();
    for (var i = 0; i < widgets.length; i++) {
      initWidget(widgets[i]);
    }
  }
})(window);
