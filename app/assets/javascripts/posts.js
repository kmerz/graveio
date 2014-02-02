$(document).ready(function() {

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

  $(".check4contenttype").keyup(function(){
    var cur_val = $(this).val(),
        regex = /.+\.(.+)/,
        filenames = $('#filenames').data('filenames'),
        element = $('#post_content_type');
    if (regex.test(cur_val)) {
      if (typeof filenames[RegExp.$1] == 'undefined') {
        element.val(filenames['']);
      } else {
        element.val(filenames[RegExp.$1]);
      }
    } else {
      element.val(filenames['']);
    }
  });

  $("a#like_trigger").bind("ajax:success",
    function(evt, data, state, xhr){
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
    }
  );

  $("a#delete_trigger").bind("ajax:success",
      function(evt, data, state, xhr){
        if (data.errors) {
          $("p#alert").html(data.errors);
        } else {
          $(this).closest('div.preview_area').fadeOut();
          $("p#notice").html(data.notice);
          if (window.location.pathname != "/") {
            setTimeout(function() {
              window.location.href = "/";
            }, 2000);
          }
        }
      });

  $('#post_url').focus(function(event) {
    var target = $(event.target);
    setTimeout(function() {
      target.select();
    }, 100);
  });

});
