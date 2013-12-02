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
    document.addEventListener("page:load", this.getTags());
  },

  getTags: function(){
    var that = this
    
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
          delay:500,
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
    $('.autocomplete').autocomplete({
      source: $('.autocomplete').data('path'),
      minLength: 3,
      delay:500,
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
  },
  hiddenFieldHandler: function(){
    if($('#voucher_payment_type').val() != "Cash")
      $('.select').removeClass("hidden");
    $(document).on('change', '#voucher_payment_type', function() {
      $('.select').removeClass("hidden");
      if($(this).val() == "Cash")
        $('.select').addClass("hidden");
    });
  }
} 