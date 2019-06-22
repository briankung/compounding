require 'date'

RSpec.describe Compounding do
  it "has a version number" do
    expect(Compounding::VERSION).not_to be nil
  end

  describe "Compounding calculations" do
    context 'periodically compounded interest' do
      # Examples from:
      # https://www.meta-financial.com/lessons/compound-interest/formula-calculate.php

      def periodic(principal, apy, annual_compoundings, years)
        Compounding::CalculatePeriodic(principal, apy, annual_compoundings, years)
      end

      it 'calculates periodic interest' do
        expect(periodic(1, 1, 1, 1)).to be_within(0.01).of(2)

        expect(periodic(1000, 0.05, 2, 1)).to be_within(0.01).of(1050.63)

        expect(periodic(10_000, 0.08, 4, 1)).to be_within(0.01).of(10_824.32)

        expect(periodic(1200, 0.1249, 12, 0.5)).to be_within(0.01).of(1_276.92)
      end
    end

    context 'continuously compounded interest' do
      # Examples from:
      # https://www.meta-financial.com/lessons/compound-interest/continuously-compounded-interest.php

      def continuous(principal, apy, years)
        Compounding::CalculateContinuous(principal, apy, years)
      end

      it 'calculates continuous interest' do
        expect(continuous(1000, 0.05, 5)).to be_within(0.01).of(1284.03)

        expect(continuous(500, 0.1, 5)).to be_within(0.01).of(824.36)

        expect(continuous(2000, 0.13, 20)).to be_within(0.01).of(26_927.47)

        expect(continuous(20_000, 0.01, 20)).to be_within(0.01).of(24_428.05)
      end
    end
  end

  describe Compounding::Account do
    let(:defaults) do
      {
        apy: 1,
        continuous: false,
        annual_compoundings: 1
      }
    end

    let(:account) { described_class.new(**defaults) }
    let(:time) { Time.now }

    describe 'ledger' do
      let(:credit) do
        Compounding::Account::LedgerItem.new(
          amount: 1000,
          added_at: time,
          type: :credit
        )
      end

      let(:debit) do
        Compounding::Account::LedgerItem.new(
          amount: 1000,
          added_at: time,
          type: :debit
        )
      end

      it 'can add a credit' do
        account.add_credit 1000, time

        expect(account.ledger_items).to include(credit)
      end

      it 'can add a debit' do
        account.add_debit 1000, time

        expect(account.ledger_items).to include(debit)
      end

      it 'fetches ledger items at a given time' do
        account.add_credit 1000, time
        account.add_debit 1000, time

        expect(account.ledger_items_at(time)).to match_array([credit, debit])
      end

      it 'calculates principal added at a given time' do
        account.add_credit 1000, time
        account.add_debit 1000, time

        expect(account.principal_added_at(time)).to eq 0
      end
    end

    describe '#balance_at' do
      def next_year(years)
        time.to_datetime.next_year(years).to_time
      end

      def balance_after(years:)
        account.balance_at(next_year(years))
      end

      context 'with periodically compounded interest' do
        before do
          account.add_credit(1000, time)
        end

        it 'calculates interest after 1 year' do
          expect(balance_after(years: 1)).to be_within(0.01).of(2000)
        end

        it 'calculates interest after 2 years' do
          expect(balance_after(years: 2)).to be_within(0.01).of(4000)
        end

        it 'calculates interest after 2 years with one credit' do
          account.add_credit(1000, next_year(1))

          expect(balance_after(years: 2)).to be_within(0.01).of(6000)
        end

        it 'calculates interest after 2 years with one debit' do
          account.add_debit(1000, next_year(1))

          expect(balance_after(years: 1)).to be_within(0.01).of(2000)
        end
      end
    end
  end
end
