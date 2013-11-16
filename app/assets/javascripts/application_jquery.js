// #FIXME_AB: If not needed then remove it 
// function remove_fields(link) {

//   $(link).prev("input[type=hidden]").val("1");
//   $(link).closest(".radioBox").hide();
// }

// function add_fields(link, association, content) {
// 	console.log(link)
//   var new_id = new Date().getTime();
//   var regexp = new RegExp("new_" + association, "g")
//   console.log($(link).parent());
//   $(link).before(content.replace(regexp, new_id));
//   // $(link).addClass('fields').append_to('div .fields');
// // $(link).closest("div .fields").append_to(
// }


  function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".radioBox").hide();
    $(link).closest(".radioBox").siblings('.tagname').hide();
  }
  function removeClass(){ 
    $('.create_new').click(function() {
      $(this).addClass('hidden');
      $('li.create_new_user').removeClass('hidden');
    });
  }

  function add_fields(link, association, content) {
    console.log("fvf")
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).before(content.replace(regexp, new_id));
  }