Time = (time_since_epoch_in_miliseconds, timezone) ->
  time = new Number(time_since_epoch_in_miliseconds or (new Date).getTime())
  time.zone = timezone or Time.zone
  time.date = new Date(time - (Time.zone.utc_offset) + time.zone.utc_offset)
  time[method] = procedure for method, procedure of Time.prototype
  return time

Time.prototype =
  utc: -> Time this, utc_offset: 0
  hour: -> @date.getHours()
  minute: -> @date.getMinutes()
  second: -> @date.getSeconds()
  toString: ->
    abs_offset = @zone.utc_offset.abs()
    zone_operator = if @zone.utc_offset > 0 then '+' else '-'
    zone_offset_hour = (abs_offset / 1.hour()).floor().toPaddedString(2)
    zone_offset_minute = (abs_offset % 1.hour() / 1.minute()).floor().toPaddedString(2)
    zone_offset_string = 'UTC' + zone_operator + zone_offset_hour + zone_offset_minute
    @date.toString().replace /GMT-\d\d\d\d \([A-Z]+\)/, zone_offset_string


Time.Numeric = new ->
  @hour       = @hours       = -> @minutes() * 60
  @minute     = @minutes     = -> @seconds() * 60
  @second     = @seconds     = -> @miliseconds() * 1000
  @milisecond = @miliseconds = -> @valueOf()

Number.prototype[method] = procedure for method, procedure of Time.Numeric


Time.zone = utc_offset: -1 * (new Date).getTimezoneOffset() * 1.minute()


Time.duration_in_words = (a, b) ->
  duration = (a - b).abs()
  duration_in_minutes = (duration / 1.minute()).round()
  switch duration_in_minutes
    when 0
      return 'a moment'
    when 1
      return '1 minute'
    else
      return duration_in_minutes + ' minutes'
  return

Time.describe_duration_in_words = (a, b) ->
  duration = (a - b).abs()
  duration_in_minutes = (duration / 1.minute()).round()
  if duration_in_minutes == 0
    return 'right now'
  if a > b
    Time.duration_in_words(a, b) + ' ago'
  else
    'in ' + Time.duration_in_words(a, b)
