$(document).ready(function() {
    $('.item-card').click(function() {
      var itemUrl = $(this).find('.item-url').val();
      window.location.href = itemUrl;
    });
  });