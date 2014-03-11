$ ->
  $('.package-tracker .track').on 'click', ->
    modal = $(this).closest('.package-tracker')
    tracking_url = modal.data('tracking-url')
    id = modal.find('.tracking-number').val()
    results = modal.find('.results')

    # todo validate id

    $.post tracking_url, { id: id }, (data) ->
      results.html(JSON.stringify(data))
