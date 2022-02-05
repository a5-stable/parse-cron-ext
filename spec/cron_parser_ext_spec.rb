require "time"
require "./spec/spec_helper"
require "cron_parse"
require "date"

def parse_date(str)
  dt = DateTime.strptime(str, "%Y-%m-%d %H:%M")
  Time.local(dt.year, dt.month, dt.day, dt.hour, dt.min, 0)
end

describe "CronParser#next" do
  [
    ["* * L * *",             "2011-08-15 12:00",  "2011-08-31 00:00"],
    ["* * L * *",             "2011-02-15 12:00",  "2011-02-28 00:00"],
    ["* * L * *",             "2011-04-16 12:00",  "2011-04-30 00:00"],
    ["0 9 L * *",             "2011-04-16 12:00",  "2011-04-30 09:00"],
    ["0 9 L 2 *",             "2011-04-16 12:00",  "2012-02-29 09:00"],
  ].each do |line, now, expected_next|
    it "should return #{expected_next} for '#{line}' when now is #{now}" do
      now = parse_date(now)
      expected_next = parse_date(expected_next)

      parser = CronParser.new(line)

      parser.next(now).xmlschema.should == expected_next.xmlschema
    end
  end
end

describe "CronParser#last" do
  [
    ["* * L * *",             "2011-08-15 12:00",  "2011-07-31 23:59"],
    ["* * L * *",             "2011-02-15 12:00",  "2011-01-31 23:59"],
    ["* * L * *",             "2011-03-02 12:00",  "2011-02-28 23:59"],
    ["0 9 L * *",             "2011-04-16 12:00",  "2011-03-31 09:00"],
    ["0 9 L 2 *",             "2011-01-02 12:00",  "2010-02-28 09:00"],
  ].each do |line, now, expected_next|
    it "should return #{expected_next} for '#{line}' when now is #{now}" do
      now = parse_date(now)
      expected_next = parse_date(expected_next)

      parser = CronParser.new(line)

      parser.last(now).should == expected_next
    end
  end
end
