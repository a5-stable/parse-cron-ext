require 'set'
require 'date'
require 'parse-cron'

class CronParser
  SUBELEMENT_REGEX = %r{^(\d+|l|w)((-(\d+)(/(\d+))?)?|#(\d+))$}

  def parse_element(elem, allowed_range, time_specs_key=nil)
    values = elem.split(',').map do |subel|
      if subel =~ /^\*/
        step = subel.length > 1 ? subel[2..-1].to_i : 1
        stepped_range(allowed_range, step)
      else
        if SUBELEMENT_REGEX === subel
          if $6 # with range
            stepped_range($1.to_i..$4.to_i, $6.to_i)
          elsif $4 # range without step
            stepped_range($1.to_i..$4.to_i, 1)
          elsif $1 == "l" && time_specs_key == :dom
            [$1]
          elsif $1 == "w" && time_specs_key == :dow
            @dow_offset = $7.to_i if $7
            [1, 2, 3, 4, 5]
          else # just a numeric
            @dow_offset = $7.to_i if $7
            [$1.to_i]
          end
        else
          raise ArgumentError, "Bad Vixie-style specification #{subel}"
        end
      end
    end.flatten

    values = values.sort if time_specs_key.nil?
    [Set.new(values), values, elem]
  end

  protected

  def nudge_date(t, dir = :next, can_nudge_month = true)
    spec = interpolate_weekdays(t.year, t.month)[1]
    spec = [spec[@dow_offset-1]] if @dow_offset

    next_value = find_best_next(t.day, spec, dir)
    t.day = next_value || (dir == :next ? spec.first : spec.last)

    nudge_month(t, dir) if next_value.nil? && can_nudge_month
  end

  def nudge_month(t, dir = :next)
    spec = time_specs[:month][1]
    next_value = find_best_next(t.month, spec, dir)
    t.month = next_value || (dir == :next ? spec.first : spec.last)

    nudge_year(t, dir) if next_value.nil?

    # we changed the month, so its likely that the date is incorrect now
    valid_days = interpolate_weekdays(t.year, t.month)[1]
    valid_days = [valid_days[@dow_offset-1]] if @dow_offset
    t.day = dir == :next ? valid_days.first : valid_days.last
  end

  def interpolate_weekdays_without_cache(year, month)
    t = Date.new(year, month, 1)
    valid_mday, _, mday_field = time_specs[:dom]
    valid_wday, _, wday_field = time_specs[:dow]
    # Careful, if both DOW and DOM fields are non-wildcard,
    # then we only need to match *one* for cron to run the job:
    if not (mday_field == '*' and wday_field == '*')
      valid_mday = [] if mday_field == '*'
      valid_wday = [] if wday_field == '*'
    end
    # Careful: crontabs may use either 0 or 7 for Sunday:
    valid_wday << 0 if valid_wday.include?(7)

    # Now only handle "L" statement
    valid_mday << (t.next_month - 1).day if valid_mday.include?("l")

    result = []
    while t.month == month
      result << t.mday if valid_mday.include?(t.mday) || valid_wday.include?(t.wday)
      t = t.succ
    end

    [Set.new(result), result]
  end

  def time_specs
    @time_specs ||= begin
      # tokens now contains the 5 fields
      tokens = substitute_parse_symbols(@source).split(/\s+/)
      {
        :minute => parse_element(tokens[0], 0..59), #minute
        :hour   => parse_element(tokens[1], 0..23), #hour
        :dom    => parse_element(tokens[2], 1..31, :dom), #DOM
        :month  => parse_element(tokens[3], 1..12), #mon
        :dow    => parse_element(tokens[4], 0..6, :dow)  #DOW
      }
    end
  end
end
