// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require jquery.remotipart
//= require twitter/bootstrap

//= require_tree .
//= require jquery.tagcanvas.js

// #FIXME_AB: Object oriented architecture please 
//fixed
$(document).ready(function(){
  var applicationHandler = new ApplicationHandler();
})
var ApplicationHandler = function() {
  this.init();
}
ApplicationHandler.prototype = {
  init: function() {
    this.dateFieldHandler();
    this.VoucherStateHandler();
    this.oneclick();
    this.resetautocomplete();
    this.showDetails();
    $('div.error_messages').addClass('hidden')
    this.redirectToVouchers();
    document.addEventListener("page:load", this.dateFieldHandler);
    document.addEventListener("page:load", this.resetautocomplete);
    document.addEventListener("page:load", this.VoucherStateHandler);
  },
  dateFieldHandler : function(){
    $(".date-field").datepicker({
      dateFormat: "dd/mm/yy"
    });
  },
  redirectToVouchers: function(){
    $(document).on('click','.assigned_vouchers',function(e){
      var voucherId = $(this).find('.voucher_id .voucher_contents').text();
      window.location.href = '/vouchers/'+ voucherId;
    })
  },
  resetautocomplete: function(){
     $('.voucher_autocomplete').submit(function() {
        if($('.autocomplete').val() == ""){
          $("#"+ $('.autocomplete').data('hidden-field-id')).val("")
        }
        return true;
    });
     // $(document).on('click' , '.submit' , function(){
     //     if($('.autocomplete').val() == "")
     //      $("#"+ $('.autocomplete').data('hidden-field-id')).val("")
     // })
  },
  VoucherStateHandler: function(){
    var pathname = window.location.pathname.split('vouchers/')[1];
    $('.associated_voucher li.' + pathname).addClass('active').siblings().removeClass('active');
  },
  oneclick: function(){
    $(document).on('submit', 'form.one_click', function (e) {
      $(this).submit(function() {
        return false;
      });
      return true;
    });
  },
  showDetails: function() {
    
    $('.shows').click(function(){
      $('tr.show_details[data-id = "' + $(this).attr('data-name') + '"]').toggle('blind', 1000);
      $('tr.show_details[data-id = "' + $(this).attr('data-name') + '"]').toggleClass('hidden').animate(2000);

    });
  }

}