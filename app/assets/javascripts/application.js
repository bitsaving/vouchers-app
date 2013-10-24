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

$(document).ready(ApplicationFieldHandler)
document.addEventListener("page:load", ApplicationFieldHandler);
function ApplicationFieldHandler(){
  dateFieldHandler();
  voucherStatusHandler();
}
function dateFieldHandler(){
  $(".date-field").datepicker({
    dateFormat: "dd/mm/yy"
  });
}
function voucherStatusHandler(){
  $.ajax({
    type: "get",
    url: "../pending",
    dataType:'json',
    success: function(response){
      var i = 0;
      while(i <response.length){
        $targetLi = $('<li/>').attr('id',response[i]["id"]).appendTo($('#pending'));
        var string = "/vouchers/" +response[i]["id"];
        $targetlink = ($('<a>') .attr('href',string).text("Voucher " + response[i]['id'])).appendTo($('#'+response[i]["id"])) 
        $targetlink.appendTo($targetLi).addClass('pending');
        i++;
      }  
    }
  });
  $("#pending_vouchers").hover(function() {
    $('#pending').removeClass('hidden');
  },
  function(){
    $('#pending').addClass('hidden')
  });
}
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".radioBox").hide();
}
function remove_class(){ 
  $('.create_new').click(function() {
  $(this).addClass('hidden');
  $('li.create_new_user').removeClass('hidden');
});
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id));
}