/**
 * Javascript behaviors for Filterrific.
 *
 * Rewrite of filterrific-jquery.js without jQuery.
 * Requires rails-ujs
 * Suitable to use with webpack
 *
 * Released under the MIT license
 *
 */

 const Filterrific = {};

 Filterrific.submitFilterForm = function(element) {
   const form = element.closest("form");
   const url = form.getAttribute("action");
   // Send before event
   element.dispatchEvent(new Event('loadingFilterrificResults'));
   // Turn on spinner
   document.querySelectorAll('.filterrific_spinner').forEach((elem) => {
     elem.style.display = 'block';
   })
 
   Rails.ajax({
     url: url,
     data: Rails.serializeElement(form),
     type: 'GET',
     dataType: 'script',
     success: (msg) => {
       // Turn off spinner
       document.querySelectorAll('.filterrific_spinner').forEach((elem) => {
         elem.style.display = 'none';
       })
       // Send after event
       element.dispatchEvent(new Event('loadedFilterrificResults'));
     }
   })
 }
 
 Filterrific.observeField = function(element, frequency, callback) {
   const f = frequency * 1000;
   let prev = element.value
   const check = () => {
     // If removed clear the interval and don't fire the callback
     if(removed()){
       if(i) clearInterval(i)
       return
     }
     const val = element.value;
     if(prev !== val){
       prev = val;
       callback();
     }
   }
   const removed = () => {
     return element.closest('html') == null;
   }
   const reset = () => {
     if(i){
       clearInterval(i);
       i = setInterval(check, f);
     }
   }
   check();
   let i = setInterval(check, frequency);
 
   ['keyup', 'click', 'mousemove'].forEach((e) => {
     element.addEventListener(e, reset);
   })
 }
 
 Filterrific.init = function() {
   const form = document.getElementById('filterrific_filter');
   form.addEventListener('change', (event) => {
     const input = event.target.closest('input, textarea, select');
     if ( !input || input.classList.contains('filterrific-periodically-observed') ) return;
 
     this.submitFilterForm(input);
   })
 
   document.querySelectorAll('.filterrific-periodically-observed').forEach( (element) => {
     this.observeField(element, 0.5, () => {
       this.submitFilterForm(element);
     })
   })
 }
 
 export default Filterrific; 