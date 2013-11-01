
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

