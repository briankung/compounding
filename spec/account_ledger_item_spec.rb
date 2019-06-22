RSpec.describe Compounding::Account::LedgerItem do
  let(:li) do
    described_class.new(**defaults)
  end

  let(:defaults) do
    Hash[
      amount: 1000,
      added_at: time,
      type: :credit,
      recurs: recurs
    ]
  end

  let(:time) { Time.now }
  let(:recurs) { Hash[years: 1] }

  def next_year(years)
    time.to_datetime.next_year(years).to_time
  end

  context 'with bad input' do
    it 'raises error' do
      defaults[:recurs] = { blah: 2 }
      expect { li.recurs_at?(time) }.to raise_error described_class::BadInput
    end
  end

  describe '#recurs_at?' do

    it 'returns true after 1 year' do
      expect(li.recurs_at?(next_year(1))).to be true
    end
  end

  describe '#recurrences_before' do
    it 'returns all recurrences occurring before time' do
      recurrences = li.recurrences_before(next_year(10))
      expect(recurrences.length).to eq 10
    end
  end
end
