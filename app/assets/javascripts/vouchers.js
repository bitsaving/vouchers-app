// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

// #FIXME_AB: Add some spacing between functions 
$(document).ready(function(){
  var voucherEventsHandler = new VoucherEventsHandler();
})
var VoucherEventsHandler = function() {
  this.init();
}
VoucherEventsHandler.prototype = {
  init: function() {
    this.hiddenFieldHandler(); 
    this.autoCompleteFieldHandler();
    this.getTags();
    document.addEventListener("page:load", this.hiddenFieldHandler());
    document.addEventListener("page:load", this.autoCompleteFieldHandler());
    // window.addEventListener("page:fetch", this.autoCompleteFieldHandler());
    //  window.addEventListener("page:fetch", this.getTags());
    document.addEventListener("page:load", this.getTags());
  },
  getTags: function(){
    var that = this
    console.log(":fddfg")
    console.log($('.tag'))
  // #FIXME_AB: Follow OOPs 
    $.ajax({
      type: 'get',
      // #FIXME_AB: User a better selector not just .tag. Why don't you add a data-attribute to the textarea itself. Ask me if you are not sure what I am saying 
      url: $('.tag').data('path'), 
      dataType: "json", 
      success: function(data){
        $('.tag').autocomplete({ 
        source: function( request, response ) {
          response( $.ui.autocomplete.filter(
            data, that.extractLast( request.term ) ) );
          },
          focus: function() {
            return false;
          },
          select: function( event, ui ) {
            var terms = that.split( this.value );
            terms.pop();
            terms.push( ui.item.label );
            terms.push( "" );
            this.value = terms.join( ", " );
            return false;
          }
        });
      }
    });
  },
  split: function( val ) {
    return val.split( /,\s*/ );
  },
  extractLast:function( term ) {
    return this.split( term ).pop();
  },
  autoCompleteFieldHandler: function() {
    console.log($('.autocomplete').data('path'))
    $('.date-field').css('cursor', 'pointer');
    $.ajax({
      type: 'get',
      url: $('.autocomplete').data('path'), 
      dataType: "json", 
      success: function(data){
        $('.autocomplete').autocomplete({
          source: data,
          select: function(event, ui) { 
            console.log(ui.item.value);
            event.preventDefault();
            this.value = ui.item.label;
            $('#'+ $(this).data('hidden-field-id')).val(ui.item.id);
            console.log($('#'+ $(this).data('hidden-field-id')).val(ui.item.value));
          },
          focus: function(event, ui) {
            event.preventDefault();
            this.value = ui.item.label;
            $('#'+ $(this).data('textbox-id')).val(ui.item.label);
          }
        });
      }
    });
  },
  hiddenFieldHandler: function(){
    $(document).on('change', '#voucher_payment_type', function() {
      $('.select').removeClass("hidden");
    });
  }
}