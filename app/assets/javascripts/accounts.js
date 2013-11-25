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
      info = { account_type: $(this).val(), account_id: $(this).data('name') };
      $.ajax({
        // #FIXME_AB: URL should be handle in the same way we are handling tags
        //fixed
        url: $(this).data('path') + "/" + pathname.toLowerCase(),
        data: info  ,
        type:'get',
        dataType: 'script',
      });      
    });
  }
}
