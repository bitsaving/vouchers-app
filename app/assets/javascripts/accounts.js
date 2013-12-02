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
      if($(this).val() != 'Both')
        window.location.href =  $(this).data('path') + "/" + pathname.split(" (")[0].toLowerCase() + "?account_type=" + $(this).val().toLowerCase()
      else
        window.location.href = $(this).data('path') + "/" + pathname.split(" (")[0].toLowerCase()
    })
  }
}
