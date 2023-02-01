import $ from 'jquery';
import _ from 'underscore';
import Rails from '@rails/ujs';

Rails.start();

$(document).ready(function() {
  $('pre code, .js-code-with-comments').each(function() {
    // TODO: Working copy buttons
    window.activateCopyButton($(this));
  });

  $('[data-contribution-input]').on('input', _.throttle(function() {
    const $replyBox = $(this);
    const $previewArea = $('[data-contribution-preview]');

    $.ajax('/preview', {
      type: 'POST',
      data: { body: $replyBox.val() },
      dataType: 'html',
      success: (data) => $previewArea.html(data),
      headers: {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
    }, 1000);
  }));
});
