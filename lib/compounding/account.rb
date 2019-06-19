require "compounding/constants"
require "compounding/account_ledger_item"

module Compounding
  class Account
    attr_accessor :ledger_items

    def initialize(apy:, continuous:, annual_compoundings: nil)
      @apy, @continuous, @annual_compoundings = apy, continuous, annual_compoundings
      @ledger_items = []
    end

    def add_credit(amount, added_at)
      ledger_items << LedgerItem.new(
        amount: amount,
        added_at: added_at,
        type: :credit
      )
    end

    def add_debit(amount, added_at)
      ledger_items << LedgerItem.new(
        amount: amount,
        added_at: added_at,
        type: :debit
      )
    end

    def ledger_items_at(time)
      ledger_items.select { |li| li.added_at == time }
    end

    def principal_added_at(time)
      ledger_items_at(time).sum(&:to_i)
    end

    def opened_at
      ledger_events.first
    end

    def balance_at(ending)
      events = ledger_events.select { |t| (opened_at...ending).include?(t) }
      events << ending

      events.each_cons(2).reduce(0) do |principal, (beginning, ending)|
        Compounding::CalculatePeriodic(
          principal + principal_added_at(beginning),
          @apy,
          @annual_compoundings,
          ((ending - beginning) / Compounding::ONE_YEAR_IN_SECONDS)
        )
      end
    end

    def ledger_events
      ledger_items.map(&:added_at).sort.uniq
    end
  end
end
