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
 // $.ajaxSetup({ cache: false });

  // $('#myCanvas').tagcanvas({
  //     textColour : '#ffffff',
  //    outlineColour : '#ff9999',
 
  //    outlineThickness : 15,
  //    maxSpeed : 0.02,
  //    weight : true,
  //    textHeight :10,
  //    weightSize : 10,
  //    depth : 1.75
  //  })
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
    alert("hah")
     $('.voucher_autocomplete').submit(function() {
        if($('.autocomplete').val() == ""){
          $("#"+ $('.autocomplete').data('hidden-field-id')).val("")
        }
        return true; // return false to cancel form action
    });

     $(document).on('click' , '.submit' , function(){
      alert("lol")
         if($('.autocomplete').val() == "")
          $("#"+ $('.autocomplete').data('hidden-field-id')).val("")
     })
  },
  // tagcanvas: function() {
  //   var options = {
  //     textColour : 'red',
  //     outlineColour : '#ff9999',
  //     outlineThickness : 1,
  //     minSpped : 0.07,
  //     maxSpeed : 0.07,
  //     weight : true,
  //     weightMode: 'both',
  //     shape : 'cylinder',
  //     minBrightness: 2.9,
  //     weightGradient: {0:'#660033', 0.33:'#ff0',0.66:'#944d70', 1:'#c299ad'},
  //     depth : 0.75
  //   };
  //   window.onload = function() {
  //     try {
  //       TagCanvas.Start('myCanvas',"",options);
  //     } catch(e) {
  //     // something went wrong, hide the canvas container
  //    // document.getElementById('myCanvasContainer').style.display = 'none';
  //     }
  //   };  
  // },
  // getVouchersByStatus:function(){
  //   $(document).on('click','.vouchers' ,function(e) {
  //     var voucherStatus = $(this).find('.voucher_label').text();
  //     console.log(voucherStatus.toLowerCase())
  //     $.ajax({
  //       type: 'get',
  //       url: '/vouchers/' + voucherStatus.toLowerCase(),
  //       dataType: "html", 
  //       success: function(data){
  //         $('.assigned_vouchers').html('').html(data);
  //         $('.associated_voucher ul li.' + voucherStatus.toLowerCase()).addClass('active').siblings().removeClass('active');
  //       }
  //     })
  //   });
  // },
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