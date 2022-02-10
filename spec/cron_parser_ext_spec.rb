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
    ["* * L * *",             "2021-08-15 12:00",  "2021-08-31 00:00"],
    ["* * L * *",             "2021-02-15 12:00",  "2021-02-28 00:00"],
    ["* * L * *",             "2021-04-16 12:00",  "2021-04-30 00:00"],
    ["0 9 L * *",             "2021-04-16 12:00",  "2021-04-30 09:00"],
    ["0 9 L 2 *",             "2021-04-16 12:00",  "2022-02-28 09:00"],
    ["* * * * SUN#3",         "2021-01-01 12:00",  "2021-01-17 00:00"],
    ["* * * * SUN#3",         "2021-01-18 12:00",  "2021-02-21 00:00"],
    ["* * * * SUN#3",         "2020-12-31 12:00",  "2021-01-17 00:00"],
    ["* * * * SUN#4",         "2020-12-31 12:00",  "2021-01-24 00:00"],
    ["0 0 * * W",             "2022-02-10 00:00",  "2022-02-11 00:00"],
    ["0 0 * * W",             "2022-02-11 00:00",  "2022-02-14 00:00"],
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
    ["* * L * *",             "2021-08-15 12:00",  "2021-07-31 23:59"],
    ["* * L * *",             "2021-02-15 12:00",  "2021-01-31 23:59"],
    ["* * L * *",             "2021-03-02 12:00",  "2021-02-28 23:59"],
    ["0 9 L * *",             "2021-04-16 12:00",  "2021-03-31 09:00"],
    ["0 9 L 2 *",             "2021-01-02 12:00",  "2020-02-29 09:00"],
    ["* * * * SUN#3",         "2021-01-01 12:00",  "2020-12-20 23:59"],
    ["* * * * SUN#3",         "2021-12-25 12:00",  "2021-12-19 23:59"],
    ["* * * * SUN#3",         "2021-12-06 12:00",  "2021-11-21 23:59"],
    ["0 9 * * SUN#4",         "2021-12-06 12:00",  "2021-11-28 09:00"],
    ["0 0 * * W",             "2022-02-10 00:00",  "2022-02-09 00:00"],
    ["0 0 * * W",             "2022-02-07 00:00",  "2022-02-04 00:00"],
  ].each do |line, now, expected_next|
    it "should return #{expected_next} for '#{line}' when now is #{now}" do
      now = parse_date(now)
      expected_next = parse_date(expected_next)

      parser = CronParser.new(line)

      parser.last(now).should == expected_next
    end
  end
end
