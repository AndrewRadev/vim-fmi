import $ from 'jquery';

$(document).ready(function() {
  $('pre code, .js-code-with-comments').each(function() {
    // TODO: Working copy buttons
    window.activateCopyButton($(this));
  });
});
