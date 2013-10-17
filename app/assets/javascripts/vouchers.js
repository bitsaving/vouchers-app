// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(EventsHandler)
document.addEventListener("page:load", EventsHandler);

function EventsHandler() { 
  autoCompleteFieldHandler();
  hiddenFieldHandler(); 
}

function autoCompleteFieldHandler() {
  $('.autocomplete').autocomplete({
    source: $('#'+ $('.autocomplete').data('textbox-id')).data('autocomplete-source'),
    select: function(event, ui) {
      event.preventDefault();
      this.value = ui.item.label;
      $('#'+ $(this).data('hidden-field-id')).val(ui.item.value);
    },
    focus: function(event, ui) {
      event.preventDefault();
      this.value = ui.item.label;
      $('#'+ $(this).data('textbox-id')).val(ui.item.label);
    }
  });
}
function hiddenFieldHandler(){
  $radio_button = $('.radiobutton');
  $radio_button .click(function() { 
    if ($("#voucher_bill_attachment_yes:checked").length > 0)
      $('.radioBox').removeClass('hidden');
    else
     $('.radioBox').addClass('hidden');
  });
}