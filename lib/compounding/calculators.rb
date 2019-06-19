module Compounding
  def self.CalculatePeriodic(principal, apy, annual_compoundings, years)
    principal * (1 + (apy/annual_compoundings)) ** (annual_compoundings * years)
  end

  def self.CalculateContinuous(principal, apy, years)
    principal * Math::E ** (apy * years)
  end
end
