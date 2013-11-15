// #FIXME_AB: Where is all the learning gone. YOu should use object oriented concept here for JS  
$(document).ready(AccountsHandler)
document.addEventListener("page:load", AccountsHandler);
function AccountsHandler(){
 $(document).on('change', '#account', function() {
  pathname = $(this).siblings('.associated_voucher').find('ul').children('li.active').text();
    info = {account_type: $(this).val(),account_id: $(this).attr('name')}
  $.ajax({
      url:'/vouchers/' + pathname.toLowerCase() + '_vouchers',
       data: info  ,
      type:'get',
      dataType: 'script',
      success: function(responseData) {

      }
    });      
  });
}