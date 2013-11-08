function getAndShowTreeData(){
  $.getJSON(
    '/categories',
    function(data) {
      var items = [];
      //jqtree needs a specific format so removing key
      $.each( data, function( k,v ) {
        items.push(v);
      });
      //open tree view 
      $('#my_tree').tree({
        data: items,
        dragAndDrop: true,
        autoOpen: 0,
      });
    }
  );
}

$(function() {
  $('#my_tree').on('tree.move', function(e) {
    var moved_node_id = e.move_info.moved_node.id
    var target_node_id = e.move_info.target_node.id
    $.ajax({
      url: "/categories/" + moved_node_id, 
      dataType: 'script',
      type: 'PUT', 
      data: 'target_node=' + target_node_id
    });

  });

});

function showProgress() {
  $("#progressContainer").html("<div class='progress'></div><div class='loadingText'>Loading...</div>")
}

function endProgress() {
  $("#progressContainer").html("")
}

function addTags() {
  var tagsArray = $("#question_tags_field").val().split(",");
  $("#question_tags_field").val("");
  var tagsHTML = ""
  var previousTags = $(".DelTag").get();
  $.each(previousTags, function(key, currEle) { 
    tagsHTML += "<span onclick='delTag(this)' class='DelTag'>"+currEle.innerHTML+"</span>";
  });
  $.each(tagsArray, function(key, value) { 
    if(value.trim() != "") {
      tagsHTML += "<span onclick='delTag(this)' class='DelTag'>"+value+"</span>";
    }
  });
  $("#tags").html(tagsHTML)
}
    
function fillTagContent() {
  addTags()
  var previousTags = $(".DelTag").get()
  var tags = ""
  $.each(previousTags, function(key, currEle) {
    if(key != previousTags.length-1) { 
      tags += currEle.innerHTML+",";
    }
    else {
      tags += currEle.innerHTML
    }
  });
  $("#question_tags_field").val(tags);
}

function delTag(currentTag) {
  $(currentTag).remove();
}

$(function() {
  $("a.highlighted").parent('li').siblings().removeClass('active');
  $("a.tagNameLink").on("click", function(event){
    event.preventDefault();
    var name = $(this).data('tagname');
    console.log(name);
    $.ajax({
      url: $('#url_for_show_tag').val(), 
      dataType: 'script',
      type: 'get', 
      beforeSend: function() { showProgress() },
      complete: function() { endProgress() },
      data: 'tag=' + name
    });
  });
  
  //user email validation and adding domain name at end of email if not present
  $("span#userEmailHintSpan").hover(function(){
    $("a#userEmailHintLink").tooltip("show");
  },function(){
    $("a#userEmailHintLink").tooltip("hide"); 
  });

  $("#userEmailTextField").keyup(function() {
    var ch = $(this).val();
    $(this).val( ch.replace(/[^a-zA-Z0-9\.\_]/g, function(str) {
      $("span#emailError").html('Please use only letters, numbers and underscore or dot');
      return '';
    }) );
  });

  $("#userEmailTextField").on("focusout", function(){
    $("span#emailError").html('');
    valu = $(this).val().slice(-11);
    if (valu == "@vinsol.com"){
    }else{
      $(this).val(valu + '@vinsol.com');
    }
  });

  $("#userEmailTextField").on("focusin", function(){
    valu = $(this).val().slice(-11);
    if (valu == "@vinsol.com"){
      $(this).val($(this).val().replace('@vinsol.com',''));
    }else{
      
    }
  });
  
});
