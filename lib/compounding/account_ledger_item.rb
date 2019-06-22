module Compounding
  class Account
    class LedgerItem
      attr_accessor :amount, :added_at, :type, :recurs

      def initialize(amount:, added_at:, type:, recurs:)

        @amount, @added_at, @type, @recurs = amount, added_at, type, recurs
      end

      def ==(other)
        [
          @amount,
          @added_at,
          @type,
          @recurs
        ] == [other.amount, other.added_at, other.type, recurs]
      end

      def to_i
        type == :credit ? @amount : -@amount
      end

      def recurs_at?(time)
        return false unless recurs

        until recurrences.peek > time
          return true if recurrences.next == time
        end

        false
      end

      def recurrences_before(time)
        recurrences.take_while {|recurrence| recurrence < time }
      end

      private

        def recurrences
          return [] unless recurs

          @recurrences ||= Enumerator.new do |enum|
            date = added_at.to_datetime
            period, n = recurs.to_a.flatten
            i = 0

            loop do
              enum.yield(next_nth(date, period, n * i))
              i += 1
            end
          end
        end

        def next_nth(date, period, n)
          method_name = case period
                        when :years then :next_year
                        when :months then :next_month
                        when :days then :next_day
                        else
                          raise BadInput, 'Must use :days, :months, or :years'
                        end

          date.send(method_name, n).to_time
        end

        class BadInput < StandardError; end
    end
  end
end
