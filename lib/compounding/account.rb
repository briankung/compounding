require "compounding/constants"
require "compounding/account_ledger_item"

module Compounding
  class Account
    attr_accessor :ledger_items, :interest

    def initialize(apy:, continuous:, annual_compoundings: nil)
      @apy, @continuous, @annual_compoundings = apy, continuous, annual_compoundings
      @ledger_items = []
      @interest = []
    end

    def add_credit(amount, added_at)
      add_ledger_item(amount: amount, added_at: added_at, type: :credit)
    end

    def add_debit(amount, added_at)
      add_ledger_item(amount: amount, added_at: added_at, type: :debit)
    end

    def balance_at(ending)
      self.interest = []
      events = ledger_events.select { |t| (opened_at...ending).include?(t) }
      events << ending

      events.each_cons(2).reduce(0) do |principal, (beginning, ending)|
        starting_principal = principal + principal_added_at(beginning)

        ending_principal = Compounding::CalculatePeriodic(
          starting_principal,
          @apy,
          @annual_compoundings,
          time_in_years(beginning, ending)
        )

        interest << { interest: ending_principal - starting_principal, date_range: beginning...ending }

        ending_principal
      end
    end

    def opened_at
      ledger_events.first
    end

    def ledger_items_at(time)
      ledger_items.select { |li| li.added_at == time }
    end

    def principal_added_at(time)
      ledger_items_at(time).sum(&:to_i)
    end

    private

      def add_ledger_item(amount:, added_at:, type:)
        ledger_items << LedgerItem.new(
          amount: amount,
          added_at: added_at,
          type: type
        )
      end

      def increment_years(beginning, number_of_years)
        beginning.to_datetime.next_year(number_of_years).to_time
      end

      def time_in_years(beginning, ending)
        years_from_beginning = ending.year - beginning.year
        final_year = increment_years(beginning, years_from_beginning)

        until final_year >= ending
          years_from_beginning += 1
          final_year = increment_years(beginning, years_from_beginning)
        end

        penultimate_year = increment_years(beginning, years_from_beginning - 1)
        proportion_of_final_year = (ending - penultimate_year) / (final_year - penultimate_year)

        (years_from_beginning - 1) + proportion_of_final_year
      end

      def ledger_events
        ledger_items.map(&:added_at).uniq.sort
      end
  end
end
