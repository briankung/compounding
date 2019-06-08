require "compounding/version"
require "active_support/core_ext/integer/time"
require "active_support/core_ext/numeric/time"

module Compounding
  class Error < StandardError; end

  def self.CalculatePeriodic(principal, apy, annual_compoundings, years)
    (principal * (1 + (apy/annual_compoundings)) ** (annual_compoundings * years)).round(2)
  end

  def self.CalculateContinuous(principal, apy, years)
    (principal * Math::E ** (apy * years)).round(2)
  end

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
      ledger_items.map(&:added_at).sort.first
    end

    def balance_after(time_passed)
      Compounding::CalculatePeriodic(
        principal_added_at(opened_at),
        @apy,
        @annual_compoundings,
        (time_passed / 1.year)
      )
    end

    class LedgerItem
      attr_accessor :amount, :added_at, :type

      def initialize(amount:, added_at:, type:)
        @amount, @added_at, @type = amount, added_at, type
      end

      def ==(other)
        [@amount, @added_at, @type] == [other.amount, other.added_at, other.type]
      end

      def to_i
        type == :credit ? @amount : -@amount
      end
    end
  end
end
