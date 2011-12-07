jQuery ->
  $("body").bind "ajaxSend", (elm, xhr, s) ->
    if s.type == "POST"
      xhr.setRequestHeader 'X-CSRF-Token', csrf_token
