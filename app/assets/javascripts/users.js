$(document).ready(function(){
  var userEventsHandler = new UserEventsHandler();
})
var UserEventsHandler = function() {
  this.init();
}
UserEventsHandler.prototype = {
  init: function() {
    this.setAdmin();
    document.addEventListener("page:load", this.setAdmin);
  },
// #FIXME_AB: I am not sure why you need to do this from JS? 
//Sir this required becoz i have a user-type column as a hidden field that is set to admin or normal user depending on whther checkbox is checked or not.
  setAdmin: function() {
	if($('.user_type').val() == 'admin')
      $('#user_user_type').prop('checked',true) 
    $('#user_user_type').click(function() {
      if($(this).is( ':checked' ))
        $('.user_type').val('admin');
      else
        $('.user_type').val('normal');
    }); 
  }
}
