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

  $("td.line-pre").hover(function () {
    $(this).css("background","#ffd700");
  }, function () {
    $(this).css("background","");
  });

  $(document).on("click", "i.collapse-table", function() {
    var id = $(this).attr('id');
    console.log("collapse-table"+id);
    $(".collapsable"+id).hide();
    $("form#new_linecomment"+id).hide();
    $("tr.new_comment"+id).hide();
    $("div.collapse-ctrl"+id).html(
      "<i class=\"icon-plus pull-right uncollapse-table uncollapse-table" +
        id + "\" id=\"" + id + "\">" +
      "</i></div>"
    )
  });

  $(document).on("click", "i.uncollapse-table", function() {
    var id = $(this).attr('id');
    console.log("uncollapse-table"+id);
    $(".collapsable"+id).show();
    $("form#new_linecomment"+id).show();
    $("tr.new_comment"+id).show();
    $("div.collapse-ctrl"+id).html(
      "<i class=\"icon-minus pull-right collapse-table collapse-table" +
        id + "\" id=\"" + id + "\">" +
      "</i></div>"
    )
  });

  $(document).on("click", ".new-linecomment", function() {
    var linenumber = $(this).closest('tr').attr('id'),
        calledby = $(this);

    if (typeof linenumber == 'undefined') {
      linenumber = $(this).attr('id');
    }
    console.log("Line: " + linenumber);

    if ($("form#new_linecomment"+linenumber).length > 0) {
      $("tr.new_comment"+linenumber).remove();
      $(".collapse-table"+linenumber).trigger("click");
      return;
    }

    $("img.loading"+linenumber).removeClass('none');

    $.ajax({
      url: window.location.pathname+"/new_line_comment",
      data: { line: linenumber },
      cache: false
    }).complete(function(xhr, settings) {
      var table = $('table.linecomments' + linenumber);
      if (calledby.hasClass('btn')) {
        calledby.hide();
      }
      $("a.addbtn"+linenumber).hide();
      $(".uncollapse-table"+linenumber).trigger("click");

      $("img.loading"+linenumber).addClass('none');
      table.after("<tr id=\"new-comment\" class=\"new_comment"+linenumber+"\">"+
        "<td></td><td>"+xhr.responseText+"</td></tr>"
      );
    });

  $("a#delete_trigger").bind("ajax:success",
    function(evt, data, state, xhr){
      if (data.errors) {
        $("p#alert").html(data.errors);
      } else {
        $('div#preview_area'+data.postid).fadeOut("slow");
        $("p#notice").html(data.notice);
        if (window.location.pathname != "/") {
          setTimeout(function() {
            window.location.href = "/";
          }, 2000);
        }
      }
    });
  });

  $(document).on('click', "a.closeform", function() {
    var id = $(this).attr('id');
    $("tr.new_comment"+id).remove();
    $("a.addbtn"+id).show();
  });

  $(document).on("ajax:success", "form.new_linecomment",
    function(evt, data, status, xhr){

      if (data.error) {
        $("p#alert").html(data.error);
        return;
      }

      $("p#alert").html("");
      $("p#notice").html(data.notice);
      $("table.linecomments"+data.line).html(
       data.html
      );

      if ($(".collapsable"+data.line+":hidden", document.body).length > 0) {
        $(".uncollapse-table"+data.line).trigger("click");
      }

      $("td.comment-size"+data.line).html(
        "<span class=\"comments_count\">" +
          "<i class=\"icon-comment\"></i> " + data.count +
        "</span>"
      );

      $("a.addbtn"+data.line).show();

      $("tr.new_comment"+data.line).remove();
    }
  );
});
