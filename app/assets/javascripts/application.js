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
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

// #FIXME_AB: Object oriented architecture please 

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
    //this.addClassToLi();
    this.redirectToVouchers();
    this.getVouchersByStatus();
    document.addEventListener("page:load", this.dateFieldHandler);
    document.addEventListener("page:load", this.VoucherStateHandler);
    // document.addEventListener("page:load", this.addClassToLi);
    document.addEventListener("page:load", this.getVouchersByStatus);
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

  getVouchersByStatus:function(){
    $(document).on('click','.vouchers' ,function(e) {
      console.log("df")
      var voucherStatus = $(this).find('.voucher_label').text();
      console.log(voucherStatus.toLowerCase())
      $.ajax({
        type: 'get',
        url: '/vouchers/' + voucherStatus.toLowerCase(),
        //data: {state : voucherStatus.toLowerCase()},
        dataType: "html", 
        success: function(data){
          $('.assigned_vouchers').html('').html(data);
          $('.associated_voucher ul li.' + voucherStatus.toLowerCase()).addClass('active').siblings().removeClass('active');
        }
      })
    });
  },
   // addClassToLi: function(){
   // $('ul.navigation li').each(function(){
   //  if(this)
  //   // {
  //   // $(this).addClass('active').siblings().removeClass('active');
  //   // }
  //   // });
  //   $(document).on('click' ,'data[method="post"]' ,function(e){
  //       window.location.href.replace(/\?.*/,'');
  //   })
  // },
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
  }
}