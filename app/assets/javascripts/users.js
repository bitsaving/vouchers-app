
$(document).ready(UserEventsHandler)
document.addEventListener("page:load", UserEventsHandler);

function UserEventsHandler(){
 setAdmin();
}
// #FIXME_AB: I am not sure why you need to do this from JS? 
function setAdmin() {
  if($('.user_type').val() == 'admin')
    $('#user_user_type').prop('checked',true) 
  	$('#user_user_type').click(function() {
  	if($(this).is( ':checked' )) {
  		$('.user_type').val('admin');
  	}
  	else
  		$('.user_type').val('normal');
  });
}
