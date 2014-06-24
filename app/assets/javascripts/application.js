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

$(document).ready(function(){
  var applicationHandler = new ApplicationHandler();
})
var ApplicationHandler = function() {
  this.init();

}
ApplicationHandler.prototype = {

  init: function() {
   i = 100;   
    this.setTotalAmount();   
    this.dateFieldHandler();
    this.VoucherStateHandler();
    this.oneclick();
    this.resetautocomplete();
    this.showDetails();
    this.printVouchers();
    this.submitDateForm();
    this.showHistory();
    $('div.error_messages').addClass('hidden')
    this.redirectToVouchers();
    document.addEventListener("page:load", this.dateFieldHandler);
    document.addEventListener("page:load", this.showDetails);
    document.addEventListener("page:load", this.resetautocomplete);
    document.addEventListener("page:load", this.VoucherStateHandler);
    document.addEventListener("page:load", this.redirectToVouchers);
  },
  dateFieldHandler : function(){
    $(".date-field").datepicker({
      dateFormat: "dd/mm/yy"
    });
  },

  showHistory: function(){
    $(document).on('click', '#voucher_history', function(){
      $('.history').toggle('blind', 1000);
      $('.history').toggleClass('hidden').animate(2000);
    })
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
  },

  VoucherStateHandler: function(){
    var pathname = window.location.pathname.split('vouchers/')[1];
    if(pathname && pathname.indexOf("edit") < 0) 
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
  submitDateForm: function(){
    $(document).on('change', '#year', function (e) {
      $(this).closest('form').submit();
    });

  },
  showDetails: function() {
     $('.shows').click(function(){
      $('tr.show_details[data-id = "' + $(this).attr('data-name') + '"]').toggle('blind', 1000);
      $('tr.show_details[data-id = "' + $(this).attr('data-name') + '"]').toggleClass('hidden').animate(2000);
   });
  },

  setTotalAmount: function() {
    var that = this
    $(document).on("focusout", 'input.total_amount', function(){
      that.displayAmount();
    });

    $(document).on('click', '.remove_amountt', function(){
      $(this).siblings(".bank_amount").find('.total_amount').val('0')
      $(this).parent('span').siblings(".bank_amount").find('.total_amount').val('0')
      that.displayAmount();
    })
  },

  displayAmount: function(){
    value = 0;
    $('.debitedd').each(function(){
      if($(this).val())
        value += parseFloat($(this).val());
    });
    $('.update_amount_debited').text("Total amount debited : ₹ " + value.toFixed(2));
    value = 0;
    $('.creditedd').each(function(){
      if($(this).val())
        value += parseFloat($(this).val());
    });
    $('.update_amount_credited').text("Total amount credited : ₹ " + value.toFixed(2));
  }, 

  printVouchers: function(){

   $(document).on('click', '.print_vouchers', function(){
    newWin = window.open();
    $.ajax({
      type: "GET",
       url: $('.print_vouchers').data('url') + '?vouchers=' + $('.print_vouchers').data('name') , 
       success: function(data){
        newWin.document.write(data);
        newWin.document.close();
        // newWin.focus();
        newWin.print();
 
      }
      ,error: function() {
      }
    });
  });
  },




}