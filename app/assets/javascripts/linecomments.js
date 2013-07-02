$(document).ready(function() {

  $(document).on("click", "i.collapse-table", function() {
    var id = $(this).data('line');
    $(".collapsable"+id).hide();
    $("form#new_linecomment"+id).hide();
    $("tr.new_comment"+id).hide();
    $("div.collapse-ctrl"+id).html(
      "<i class=\"icon-plus pull-right uncollapse-table uncollapse-table" +
        id + "\" data-line=\"" + id + "\">" +
      "</i></div>"
    )
  });

  $(document).on("click", "i.uncollapse-table", function() {
    var id = $(this).data('line');
    $(".collapsable"+id).show();
    $("form#new_linecomment"+id).show();
    $("tr.new_comment"+id).show();
    $("div.collapse-ctrl"+id).html(
      "<i class=\"icon-minus pull-right collapse-table collapse-table" +
        id + "\" data-line=\"" + id + "\">" +
      "</i></div>"
    )
  });

  $(document).on("click", "a.show-comments", function() {
    $(".linecomment-line").toggle();
  });

  $(document).on("click", ".new-linecomment", function() {
    var linenumber = $(this).closest('tr').data('line'),
        calledby = $(this);

    if (typeof linenumber == 'undefined') {
      linenumber = $(this).data('line');
    }

    if ($("form#new_linecomment"+linenumber).length > 0) {
      $("tr.new_comment"+linenumber).remove();
      $(".collapse-table"+linenumber).trigger("click");
      return;
    }

    $("img.loading"+linenumber).removeClass('none');

    $.ajax({
      url: window.location.pathname+"/linecomments/new",
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
  });

  $(document).on('click', "a.closeform", function() {
    var id = $(this).data('line');
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
