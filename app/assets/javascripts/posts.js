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
        url: '/posts',
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
