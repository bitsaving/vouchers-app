$(document).ready(CommentsEventsHandler)
document.addEventListener("page:load", CommentsEventsHandler);

function CommentsEventsHandler(){
  $('.submit_accepted').click(function(){
	$('form.assign_form').submit();
  })
}