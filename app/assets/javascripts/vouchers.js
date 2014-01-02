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
    this.tabHiglight();
    document.addEventListener("page:load", this.hiddenFieldHandler());
    document.addEventListener("page:load", this.autoCompleteFieldHandler());
    document.addEventListener("page:load", this.getTags());
    document.addEventListener("page:load", this.show)
  },

  getTags: function(){
    var that = this
    $(document).on("focus", ".tag", function() {
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
            minLength: 3,
            delay: 500,
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
    });
  },

  split: function( val ) {
    return val.split( /,\s*/ );
  },

  extractLast:function( term ) {
    return this.split( term ).pop();
  },

  autoCompleteFieldHandler: function() {
    if($('.autocomplete').val() == ""){
      $("#"+ $('.autocomplete').data('hidden-field-id')).val("")
    }
    $.ui.autocomplete.prototype._renderItem = function( ul, item){
    var term = this.term.split(' ').join('|');
    var re = new RegExp("(" + term + ")", "gi") ;
    var t = item.label.replace(re,"<b>$1</b>");
    return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append( "<a>" + t + "</a>" )
      .appendTo( ul );
    };
    $('.date-field').css('cursor', 'pointer');
    $(document).on("focus",".autocomplete", function() {
      $('.autocomplete').autocomplete({
        source: $('.autocomplete').data('path'),
        minLength: 3,
        delay: 500,
        select: function(event, ui) { 
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
    });
  },
  tabHiglight: function(current_highlighted_tab) {
    $('.associated_voucher li.'+ current_highlighted_tab || "").addClass('active').siblings().removeClass('active')
  },
  hiddenFieldHandler: function(){
    $(document).on('change', '.voucher_payment_type select', function() {
      $(this).parents('.bank_amount').siblings('.select').removeClass("hidden");
      if($(this).val() == "Cash")
       $(this).parents('.bank_amount').siblings('.select').addClass("hidden");
    });
    $(document).on('click', '.voucher_submit', function(){
      $(document).on('ajax:error' , '.voucher_autocomplete', function(evt, xhr, status, error){
        $('div.error_messages').removeClass('hidden')
        $('div.error_messages').find("#error_explanation").remove()
        $('div.error_messages').append(xhr.responseText)
      })
    })
  }
} 