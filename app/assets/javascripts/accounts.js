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
     console.log( $(this).data('path') + "/" + pathname.toLowerCase() + "?account_type= " + $(this).val().toLowerCase())
      if($(this).val() != 'Both')
      //   params  =  {account_id: $(this).data('name')};
      // else
   //     params =  account_type: $(this).val().toLowerCase() , account_id: $(this).data('name')};
      window.location.href =  $(this).data('path') + "/" + pathname.toLowerCase() + "?account_type=" + $(this).val().toLowerCase()
     
      else
        window.location.href = $(this).data('path') + "/" + pathname.toLowerCase()

  })
    //   $.ajax({
    //     // #FIXME_AB: URL should be handle in the same way we are handling tags
    //     //fixed
    //     url: $(this).data('path') + "/" + pathname.toLowerCase(),
    //     data: info  ,
    //     type:'get',
    //     dataType: 'html',
    //     error: function(a,b,c) {
    //       console.log(a + b+c)
    //     },
    //     success: function(data) {
    //       // $('html').html(data)
    //     }
    //   });      
    // });
  }
}
