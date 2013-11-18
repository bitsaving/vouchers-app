// #FIXME_AB: Where is all the learning gone. YOu should use object oriented concept here for JS  
//Fixed
$(document).ready(function(){
  var accountsHandler = new AccountsHandler();
})

var AccountsHandler = function() {
  this.init();
}
AccountsHandler.prototype = {
  init: function() {
    this.getVouchersByState();
    document.addEventListener("page:load", this.getVouchersByState);
  },
  getVouchersByState: function(){
    $(document).on('change', '#account', function() {
      pathname = $(this).siblings('.associated_voucher').find('ul').children('li.active').text();
      // if(pathname == "New")
      //   pathname = pathname + "_vouchers"
      info = {account_type: $(this).val(),account_id: $(this).attr('name')}
      $.ajax({
        url:'/vouchers/' + pathname.toLowerCase(),
        data: info  ,
        type:'get',
        dataType: 'script',
        success: function(responseData) {
        }
      });      
    });
  }
}
