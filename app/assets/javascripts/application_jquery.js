  function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).siblings(".bank_amount").find('.total_amount').val('0')
    $(link).closest(".radioBox").hide();
    $(link).closest(".radioBox").closest('.labell').hide();
    $(link).siblings('.banking').find("input[type=hidden]").val("another")
    // $(link).parent('span').siblings('.banking').find("input[type=hidden]").val("another")
    $(link).closest(".radioBox").siblings('.tagname').remove();
  }
  function removeClass(){ 
    $('.create_new').click(function() {
      $(this).addClass('hidden');
      $('li.create_new_user').removeClass('hidden');
    });
  }

  function add_fields(link, association, content) {
    i = i+1;
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    content = content.replace($(content).find('div').find('.autocomplete').val(), '')  
    content = content.replace(/_\d+/g, function(val) {  return ("_" + (parseInt(val.split('_')[1], 10)+i).toString()) })
    if($(content).find('div').find('.autocomplete').data('textbox-id'))
      number  =  $(content).find('div').find('.autocomplete').data('textbox-id').split('_')[1]
    content= content.replace(/\[new_transactions/g, function(val) { return ("[" + number.toString()) })
    $(link).before(content.replace(regexp, $('.ui-autocomplete-input').size() + 1));
    
    
  }
  