/**
 * Javascript behaviors for terriffilter.
 * http://terriffilter.clearcove.ca
 *
 * Requires jQuery 1.7.0 or later.
 *
 * Released under the MIT license
 *
 */



// Create global terriffilter namespace
if (typeof terriffilter === 'undefined') {
  var terriffilter = {};
}



// Define function to submit terriffilter filter form
terriffilter.submitFilterForm = function(){
  var form = $(this).parents("form"),
      url = form.attr("action");
  // turn on spinner
  $('.terriffilter_spinner').show();
  // Trigger a custom event so that others may then bind to it, if they want to.
  // Example: I want to do something whenever the filtered results changes.
  $('#filterrific_filter').trigger('filterrific_filter:submit');
  // Submit ajax request
  $.ajax({
    url: url,
    data: form.serialize(),
    type: 'GET',
    dataType: 'script'
  }).done(function( msg ) {
    $('.terriffilter_spinner').hide();
  });
};



//
// Embed jquery.observe_field.js to observe terriffilter filter inputs
//
// Copied from https://github.com/splendeo/jquery.observe_field
// Wrap in immediately invoked function for compatibility with other js libraries
//
(function($) {

  $.fn.terriffilter_observe_field = function(frequency, callback) {
    frequency = frequency * 1000; // translate to milliseconds
    return this.each(function(){
      var $this = $(this);
      var prev = $this.val();
      var check = function() {
        if(removed()){ // if removed clear the interval and don't fire the callback
          if(ti) clearInterval(ti);
          return;
        }
        var val = $this.val();
        if(prev != val){
          prev = val;
          $this.map(callback); // invokes the callback on $this
        }
      };
      var removed = function() {
        return $this.closest('html').length == 0
      };
      var reset = function() {
        if(ti){
          clearInterval(ti);
          ti = setInterval(check, frequency);
        }
      };
      check();
      var ti = setInterval(check, frequency); // invoke check periodically
      // reset counter after user interaction
      $this.bind('keyup click mousemove', reset); //mousemove is for selects
    });
  };
})(jQuery);


terriffilter.init = function() {
  // Add change event handler to all terriffilter filter inputs.
  $('#terriffilter_filter').on(
    "change",
    ":input",
    terriffilter.submitFilterForm
  );

  // Add periodic observer to selected inputs.
  // Use this for text fields you want to observe for change, e.g., a search input.
  $(".terriffilter-periodically-observed").terriffilter_observe_field(
    0.5,
    terriffilter.submitFilterForm
  );
};


// Initialize event observers on document ready and turbolinks page:load
jQuery(document).on('turbolinks:load', function() {
  // Prevent double initilisation. With turbolinks 5 this function
  // will be called twice: on 'ready' and 'turbolinks:load'
  jQuery(document).off('ready page:load')
  terriffilter.init();
});

jQuery(document).on('ready page:load', function() {
  terriffilter.init();
});
