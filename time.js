var Time = function(time_since_epoch_in_miliseconds, timezone)
{
  var time = new Number(time_since_epoch_in_miliseconds || (new Date).getTime())
  time.zone  = timezone || Time.zone
  time.date  = new Date(time - Time.zone.utc_offset + time.zone.utc_offset)
  return Object.extend(time, Time.prototype)
}

Time.prototype = new(function()
{
  this.utc = function()
  {
    return Time(this, {utc_offset: 0})
  }

  this.hour = function()
  {
    return this.date.getHours()
  }

  this.minute = function()
  {
    return this.date.getMinutes()
  }

  this.second = function()
  {
    return this.date.getSeconds()
  }

  this.toString = function()
  {
    var abs_offset = this.zone.utc_offset.abs()
    var zone_operator = (this.zone.utc_offset > 0) ? '+' : '-'
    var zone_offset_hour   = (abs_offset / (1).hour()).floor().toPaddedString(2)
    var zone_offset_minute = ((abs_offset % (1).hour()) / (1).minute()).floor().toPaddedString(2)
    var zone_offset_string = "UTC" + zone_operator + zone_offset_hour + zone_offset_minute
    return this.date.toString().replace(/GMT-\d\d\d\d \([A-Z]+\)/, zone_offset_string)
  }
})

Time.Numeric = new(function()
{
  this.hour = this.hours = function()
  {
    return this.minutes() * 60
  }

  this.minute = this.minutes = function()
  {
    return this.seconds() * 60
  }

  this.second = this.seconds = function()
  {
    return this.miliseconds() * 1000
  }

  this.milisecond = this.miliseconds = function()
  {
    return this.valueOf()
  }
})

Object.extend(Number.prototype, Time.Numeric)

Time.zone = { utc_offset: -1 * (new Date).getTimezoneOffset() * (1).minute() }

Time.duration_in_words = function(a, b)
{
  var duration = (a - b).abs()
  var duration_in_minutes = (duration / (1).minute()).round()
  switch(duration_in_minutes) {
  case 0:
    return "a moment"
  case 1:
    return "1 minute"
  default:
    return duration_in_minutes + " minutes"
  }
}

Time.describe_duration_in_words = function(a, b)
{
  var duration = (a - b).abs()
  var duration_in_minutes = (duration / (1).minute()).round()
  if (duration_in_minutes === 0) return "right now"
  if (a > b) {
    return Time.duration_in_words(a, b) + ' ago'
    }
  else return 'in ' + Time.duration_in_words(a, b)
}
