module Compounding
  # It seems like financially a an average year is expected to be
  # 31556926 seconds. This is different than 1.year or (60 * 60 * 24 * 365)
  # Source: https://www.epochconverter.com/timestamp-list#seconds

  # It also makes the interest rate formulas work out 🙄 probably because 1.year
  # by itself assumes the average number of seconds in 1 year whereas adding
  # 1.year to a Time instance increments the year, where each year can have a
  # variable number of seconds.
  ONE_YEAR_IN_SECONDS = 31556926
end
