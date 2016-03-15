Time = (timeSinceEpochInMiliseconds, timezone) ->
  time = new Number(timeSinceEpochInMiliseconds or (new Date).getTime())
  time.zone = timezone or Time.zone
  time.date = new Date(time - (Time.zone.utcOffset) + time.zone.utcOffset)
  time[method] = procedure for method, procedure of Time.prototype
  return time

Time.prototype =
  utc: -> Time this, utcOffset: 0
  hour: -> @date.getHours()
  minute: -> @date.getMinutes()
  second: -> @date.getSeconds()
  toString: ->
    absOffset = @zone.utcOffset.abs()
    zoneOperator = if @zone.utcOffset > 0 then '+' else '-'
    zoneOffsetHour = (absOffset / 1.hour()).floor().toPaddedString(2)
    zoneOffsetMinute = (absOffset % 1.hour() / 1.minute()).floor().toPaddedString(2)
    zone_offset_string = 'UTC' + zoneOperator + zoneOffsetHour + zoneOffsetMinute
    @date.toString().replace /GMT-\d\d\d\d \([A-Z]+\)/, zone_offset_string


Number::milisecond = Number::miliseconds = -> @valueOf()
Number::second     = Number::seconds     = -> @miliseconds() * 1000
Number::minute     = Number::minutes     = -> @seconds() * 60
Number::hour       = Number::hours       = -> @minutes() * 60


Time.zone = utcOffset: -1 * (new Date).getTimezoneOffset() * 1.minute()


Time.durationInWords = (a, b) ->
  duration = (a - b).abs()
  durationInMinutes = (duration / 1.minute()).round()
  switch durationInMinutes
    when 0
      return 'a moment'
    when 1
      return '1 minute'
    else
      return durationInMinutes + ' minutes'
  return

Time.describeDurationInWords = (a, b) ->
  duration = (a - b).abs()
  durationInMinutes = (duration / 1.minute()).round()
  if durationInMinutes == 0
    return 'right now'
  if a > b
    Time.durationInWords(a, b) + ' ago'
  else
    'in ' + Time.durationInWords(a, b)
