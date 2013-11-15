// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(VoucherEventsHandler)
document.addEventListener("page:load", VoucherEventsHandler);

function VoucherEventsHandler() { 
  hiddenFieldHandler(); 
  autocomplete();
  getTags();

}

function autocomplete() {
  $('.date-field').css('cursor', 'pointer');
$('.autocomplete').on('keyup',function() {
    if(this.value.length == 1) {
      autoCompleteFieldHandler();
    }
  });
}

function getTags(){
  function split( val ) {
    return val.split( /,\s*/ );
  }
  function extractLast( term ) {
    return split( term ).pop();
  }
  $.ajax({
    type: 'get',
    url: $('.tag').data('path'), 
    dataType: "json", 
    success: function(data){
      $('.tag').autocomplete({ 
      source: function( request, response ) {
        response( $.ui.autocomplete.filter(
          data, extractLast( request.term ) ) );
        },
        focus: function() {
          return false;
        },
        select: function( event, ui ) {
          var terms = split( this.value );
          terms.pop();
          terms.push( ui.item.label );
          terms.push( "" );
          this.value = terms.join( ", " );
          return false;
        }
      });
    }
  });
}
function autoCompleteFieldHandler() {
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
}
function hiddenFieldHandler(){
 $(document).on('change', '#voucher_payment_type', function() {
   $('.select').removeClass("hidden");
  });
}
