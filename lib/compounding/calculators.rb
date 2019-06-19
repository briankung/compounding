module Compounding
  def self.CalculatePeriodic(principal, apy, annual_compoundings, time_in_years)
    principal * (1 + (apy/annual_compoundings)) ** (annual_compoundings * time_in_years)
  end

  def self.CalculateContinuous(principal, apy, time_in_years)
    principal * Math::E ** (apy * time_in_years)
  end
end
