# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  field = $('#registration_project_title')
  field.autocomplete
    source: field.data('source')
    # source: (request, response) ->
    #   url = field.data('source') + "?q="+request.term
    #   $.getJSON url, (data) ->
    #     response $.map data, (el) ->
    #       {
    #         label: el.title,
    #         value: el.id,
    #         url: el.url
    #       }
    focus: (event, ui) ->
      field.val(ui.item.label)
      event.preventDefault()
    select: (event, ui) ->
      field.val(ui.item.label)
      event.preventDefault()
