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
      info = { account_type: $(this).val(), account_id: $(this).attr('name') }
      $.ajax({
        // #FIXME_AB: URL should be handle in the same way we are handling tags
        url:'/vouchers/' + pathname.toLowerCase(),
        data: info  ,
        type:'get',
        dataType: 'html',
        success: function(responseData) {
          $('.voucher_status').html(unescape(responseData));
          console.log($(this).attr('data'))
        }
      });      
    });
  }
}
