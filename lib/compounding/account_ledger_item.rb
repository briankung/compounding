module Compounding
  class Account
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
