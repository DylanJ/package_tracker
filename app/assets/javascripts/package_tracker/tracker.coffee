class PackageTracker
  constructor: (context) ->
    @tracker = $(context).closest('.package-tracker')
    @tracking_url = @tracker.data('tracking-url')
    @results = @tracker.find('.results')
    @errors = @tracker.find('.errors')
    @modal = @tracker.find('.modal')

    @result_template_source = @tracker.find('.result-template').html()
    @error_template_source = @tracker.find('.error-template').html()

  valid_dhl_id: (id) ->
    if id.length != 12
      return false
    true

  valid_fedex_id: (id) ->
    #only going to support fedex's new barcodes which are 34 characters long
    if id.length != 34
      return false
    true

  valid_tracking_id: (id) ->
    @valid_fedex_id(id) || @valid_dhl_id(id)

  lookup: (id) =>
    id = @tracker.find('.tracking-number').val()
    that = this

    if @valid_tracking_id(id)
      $.post @tracking_url, { id: id }, (data) ->
        if data.response == 'success'
          that.results.html( Mustache.render(that.result_template_source, data) )
          that.modal.modal('hide')
        else
          that.errors.html( Mustache.render(that.error_template_source, data) )

$ ->
  if (val = $('.package-tracker').find('.tracking-number').val()) != ""
    new PackageTracker($('.package-tracker')).lookup()

  $('.package-tracker .track').on 'click', ->
    new PackageTracker(this).lookup()

