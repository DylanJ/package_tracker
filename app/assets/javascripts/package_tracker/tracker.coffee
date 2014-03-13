class PackageTracker
  constructor: (context) ->
    @modal = $(context).closest('.package-tracker')
    @tracking_url = @modal.data('tracking-url')
    @results = @modal.find('.results')

    @result_template_source = @modal.find('.result-template').html()
    @error_template_source = @modal.find('.error-template').html()

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
    id = @modal.find('.tracking-number').val()
    that = this

    if @valid_tracking_id(id)
      $.post @tracking_url, { id: id }, (data) ->
        if data.response == 'success'
          that.results.html( Mustache.render(that.result_template_source, data) )
        else
          that.results.html( Mustache.render(that.error_template_source, data) )

    else
      alert('incorrect tracking id')

$ ->
  $('.package-tracker .track').on 'click', ->
    package_tracker = new PackageTracker(this)
    package_tracker.lookup()

