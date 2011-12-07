cal = $('#calendar')
cal.fullCalendar
  allDaySlot: false
  firstDay: 1
  height: 500
  defaultView: 'agendaWeek'
  events: (start, end, callback) ->
    $.getJSON cal.data('source-url') + "?from_time="+(start.getTime() / 1000)+"&to_time="+(end.getTime() / 1000), (data) ->
      events = []
      $(data).each ->
        events.push
          id: this.id,
          title: this.description,
          start: this.start_time,
          end: this.end_time
      
      callback(events)
