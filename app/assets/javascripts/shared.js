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
    tagsHTML += "<span onclick='delTag(this)' class='icon-remove css_class_for_tag'><span class='DelTag'>"+currEle.innerHTML+"</span></span>";
  });
  $.each(tagsArray, function(key, value) { 
    if(value.trim() != "") {
      tagsHTML += "<span onclick='delTag(this)' class='icon-remove css_class_for_tag'><span class='DelTag'>"+value+"</span></span>";
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
  fillCategoryId();
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
    // valu = $(this).val().slice(-11);
    // if (valu == "@vinsol.com"){
    // }else{
    //   $(this).val(valu + '@vinsol.com');
    // }
  });

  $("#userEmailTextField").on("focusin", function(){
    valu = $(this).val().slice(-11);
    if (valu == "@vinsol.com"){
      $(this).val($(this).val().replace('@vinsol.com',''));
    }else{
      
    }
  });

  $("#userForm").on("submit", function(event){
    var valu = $("#userEmailTextField").val();
    $("#userEmailTextField").val(valu + "@vinsol.com")
  });

  $("#userEmailTextField").focus();
  
});

$(function() {
  $("#download_now").on("click", function(event){
    var v = $("input#num_of_sets").val();
    if (!v){
      $("input#num_of_sets").val("1");
    }  
  })

  $('#question_tags_field').on('railsAutocomplete.select', function(event, data){
    addTags();
  });

  $('#question_tags_field').on('change', function(event){
    addTags();
    $('#question_tags_field').focus();
  });
  $("#question_category_field").on('railsAutocomplete.select', function(event, data){
    addCategories(data);
  });

});

function addCategories(data) {
  var categoryArray = $("#question_category_field").val().split(",");
  $("#question_category_field").val("");
  var catHTML = ""
  $.each(categoryArray, function(key, value) { 
    if(value.trim() != "") {
      catHTML += "<span onclick='delCategory(this)' class='icon-remove css_class_for_tag'><span class='DelCategory' id=" + data.item.id + ">" +value+"</span></span>";
    }
  });
  $("#categories").append(catHTML);
}

function delCategory(currentCat) {
  $(currentCat).remove();
}

function fillCategoryId() {
  var previousCatg = $(".DelCategory").get()
  var catg = ""
  $.each(previousCatg, function(key, currEle) {
    if(key != previousCatg.length-1) { 
      catg += $(this).attr("id") + ",";      
    }
    else {
      catg += $(this).attr("id")
    }
  });
  $("#question_category_field").val(catg);
}

