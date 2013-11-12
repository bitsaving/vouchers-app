$(document).ready(AccountsHandler)
document.addEventListener("page:load", AccountsHandler);
function AccountsHandler(){
 $(document).on('change', '#account', function() {
  pathname = $(this).siblings('.associated_voucher').find('ul').children('li.active').text();
  if($(this).val() == 'credit')
    info = {account_type: 'credit',account_id: $(this).attr('name')}
  else
    info = {account_id: $(this).attr('name')}
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