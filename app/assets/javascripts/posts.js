$(document).ready(function(){
  $(document).endlessScroll({
    fireOnce: true,
    fireDelay: 500,
    ceaseFire: function() {
      return $('#infinite-scroll').length ? false : true;
    },
    callback: function(){
      var last = $("div.list").attr('last');
      $.ajax({
        url: '/',
          data: {
            last: last
          },
        dataType: 'script'
      });
    }
  });

  $("img.loading").ajaxStart(function(){
    $(this).removeClass('none');
  }).ajaxComplete(function(){
    $(this).addClass('none');
  });
});

$(document).ready(
  function(){
  $("a#like_trigger").bind("ajax:success",
    function(evt, data, status, xhr){
      if (data.errors) {
        $("p#alert").html(data.errors);
      } else {
        $("div#likesize"+data.postid).html(
          "<i class=\"icon-thumbs-up\"></i> " + data.likes);
        $("div#dislikesize"+data.postid).html(
          "<i class=\"icon-thumbs-down\"></i> " + data.dislikes);
        $("div#liker").html(data.liker);
        $("div#disliker").html(data.disliker);
      }
    });
});
