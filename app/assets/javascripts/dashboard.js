var lastKeyTime;

$(document).ready(function() {
  $(".favorite > a > img")
    .hover(function() { 
        var src = $(this).attr("src");
        var array = src.split("/");
        array[array.length-1] = $(this).data('next');
        $(this).attr("src", array.join("/"));
    },
    function() {
        var src = $(this).attr("src");
        var array = src.split("/");
        array[array.length-1] = $(this).data('initial');
        $(this).attr("src", array.join("/"));
    });

  $("#search_text_field").keyup(function() {
    lastKeyTime = new Date().getTime();
    var keyTime = lastKeyTime;
    window.setTimeout(function() {
      if(keyTime == lastKeyTime) {
        $("#dashboard_fe_ad_container").addClass("loading"); // show the spinner
        var form = $("#fe_ad_search"); // grab the form wrapping the search bar.
        var formData = form.serialize(); // grab the data in the form  
        $.get(ajaxSearchUrl, formData, function(html) {
          $("#dashboard_fe_ad_container").removeClass("loading"); // hide the spinner
        });
      }
    }, 500);
  });
  
  $(".dashboard_section_tab").click(function(e) {
     var action = $(this).data("action");
     $.get(action);
     return false;
  });
  
  var section_id = $("#section_id").val();
  
  $("#section_tab_"+section_id).addClass("selected");
  
  var bg_colors_array = ["#C0E9F7", "#F0E1E1", "#E2F0DE", "#FDFBD1"];

  $(".dashboard_fe_ad_container").css('background-color', bg_colors_array[section_id-1]);  
    
});


