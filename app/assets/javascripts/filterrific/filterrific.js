/**
 * Javascript behaviors for Filterrific.
 * http://filterrific.clearcove.ca
 *
 * Released under the MIT license
 *
 */

// Create global Filterrific namespace
if (typeof Filterrific === 'undefined') {
  var Filterrific = {};
}

// Define function to submit Filterrific filter form
Filterrific.submitFilterForm = function() {
  var form = Filterrific.findParents(this, '#filterrific_filter')[0];

  // send before event
  form.dispatchEvent(new Event('loadingFilterrificResults'));

  // turn on spinner
  document.querySelector('.filterrific_spinner').style.display = 'block';

  // Abort previous XMLHttpRequest request
  if (Filterrific.lastRequest && Filterrific.lastRequest.readyState != 4) {
    Filterrific.lastRequest.abort();
  }

  // Submit XMLHttpRequest request
  Filterrific.lastRequest = Filterrific.prepareRequest(form);
  Filterrific.lastRequest.send();
};

Filterrific.prepareRequest = function(form) {
  var url = form.getAttribute('action'),
      formData = new FormData(form),
      params = new URLSearchParams(formData),
      xhr = new XMLHttpRequest();

  if (url.indexOf('?') < 0) {
    url += '?' + params;
  } else {
    url += '&' + params;
  }

  xhr.open("GET", url, true);
  xhr.setRequestHeader('Accept', 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01');
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
        return Filterrific.processResponse(form, xhr);
      }
  }

  return xhr;
}

Filterrific.processResponse = function(form, xhr) {
  var rawResponse = (_ref = xhr.response) != null ? _ref : xhr.responseText,
      type = xhr.getResponseHeader('Content-Type'),
      response;

  if (typeof rawResponse === 'string' && typeof type === 'string') {
      if (type.match(/\bjson\b/)) {
        try {
          response = JSON.parse(rawResponse);
        } catch (_error) {}
      } else if (type.match(/\b(?:java|ecma)script\b/)) {
        script = document.createElement('script');
        script.setAttribute('nonce', Filterrific.cspNonce());
        script.text = rawResponse;
        document.head.appendChild(script).parentNode.removeChild(script);
      } else if (type.match(/\b(xml|html|svg)\b/)) {
        parser = new DOMParser();
        type = type.replace(/;.+/, '');
        try {
          response = parser.parseFromString(rawResponse, type);
        } catch (_error) {}
      }
  }

  // send after event
  form.dispatchEvent(new Event('loadedFilterrificResults'));
  document.querySelector('.filterrific_spinner').style.display = 'none';

  return response;
}

Filterrific.cspNonce = function() {
  return document.querySelector("meta[name=csp-nonce]")?.content
}

Filterrific.findParents = function(elem, selector) {
  var elements = [];
  var ishaveselector = selector !== undefined;

  while ((elem = elem.parentElement) !== null) {
    if (elem.nodeType !== Node.ELEMENT_NODE) {
      continue;
    }

    if (!ishaveselector || elem.matches(selector)) {
      elements.push(elem);
    }
  }

  return elements;
};

Filterrific.observe_field = function(inputs_selector, frequency, callback) {
  frequency = frequency * 1000;

  document.querySelectorAll(inputs_selector).forEach(input => {
    var prev = input.value;
    var check = function() {
      // if removed clear the interval and don't fire the callback
      if (removed()) {
        if(ti) clearInterval(ti);
        return;
      }
      var val = input.value;
      if (prev != val) {
        prev = val;

        // invokes the callback on $this
        if (callback && typeof callback === 'function') {
          callback.call(input);
        }
      }
    };

    var removed = function() {
      return input.closest('html').length == 0
    };

    var reset = function() {
      if (ti) {
        clearInterval(ti);
        ti = setInterval(check, frequency);
      }
    };
    check();
    var ti = setInterval(check, frequency); // invoke check periodically
    // reset counter after user interaction
    // mousemove is for selects
    input.addEventListener('keyup', reset);
    input.addEventListener('click', reset);
    input.addEventListener('mousemove', reset);
  })
};


Filterrific.init = function() {
  // Add change event handler to all Filterrific filter inputs.
  var filterrificForm = document.querySelector('#filterrific_filter');
  filterrificForm.querySelectorAll('input, textarea, select, textarea').forEach(input => {
    input.addEventListener('change', Filterrific.submitFilterForm)
  })

  // Add periodic observer to selected inputs.
  // Use this for text fields you want to observe for change, e.g., a search input.
  Filterrific.observe_field(
    ".filterrific-periodically-observed",
    0.5,
    Filterrific.submitFilterForm
  );
};


// Initialize event observers on document ready and turbolinks page:load
document.addEventListener('turbolinks:load', Filterrific.init);
document.addEventListener('DOMContentLoaded', Filterrific.init)
