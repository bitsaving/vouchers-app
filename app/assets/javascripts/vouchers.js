// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(VoucherEventsHandler)
document.addEventListener("page:load", VoucherEventsHandler);

function VoucherEventsHandler() { 
  hiddenFieldHandler(); 
  autocomplete();

}


function autocomplete() {
$('.autocomplete').on('keyup',function() {
   if(this.value.length == 1) {
    autoCompleteFieldHandler();
  }
  
});
}
function autoCompleteFieldHandler() {
  $.ajax({

    type: 'get',
    url: '/accounts', 
    dataType: "json", 
    success: function(data){
      $('.autocomplete').autocomplete({
        source:  function( request, response ) {
        var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
        response( $.grep( data, function( item ,index){
            return matcher.test( item["label"] );
        }) );
    },
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
 $(document).on('change', '#voucher_pay_type', function() {
   $('.select').removeClass("hidden");
  });
}
// function disabledInput(){
// $('.disable_input :input').prop('disabled', true);
// $('.disable_input :input[type="submit"]').hide();

// }