module Compounding
  def self.CalculatePeriodic(principal, apy, annual_compoundings, years)
    (principal * (1 + (apy/annual_compoundings)) ** (annual_compoundings * years)).round(2)
  end

  def self.CalculateContinuous(principal, apy, years)
    (principal * Math::E ** (apy * years)).round(2)
  end
end
