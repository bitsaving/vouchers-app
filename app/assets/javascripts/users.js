
$(document).ready(UserEventsHandler)
document.addEventListener("page:load", UserEventsHandler);

function UserEventsHandler(){
 setAdmin();
}
function setAdmin() {
  $('#user_type').click(function() {

  	if($(this).is( ':checked' )) {
  		$('#user_user_type').val('admin');
  	}

  });
}
