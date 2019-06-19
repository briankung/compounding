# Compounding

This is a small gem for fun and certainly not profit, unless you're counting interest. Please note that you use this software as is, at your own risk, etc. There are no guarantees that it's correct.

Basically I wanted to see if I could write some code to help calculate what interest on an account would be with intermittent payments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compounding'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compounding

## Usage

There are basically three top level constants to be aware of, and two of them are class methods:

- `Compounding::CalculatePeriodic`
- `Compounding::CalculateContinuous`
- `Compounding::Account`

### Compounding::Calculators

`CalculatePeriodic` and `CalculateContinuous` are pure functions based off of the formulas for calculating compound interest and continuously compounded interest seen below:

---

![compound interest](https://www.meta-financial.com/compound-interest/images/formula-compound-interest.png)

Source: [https://www.meta-financial.com/lessons/compound-interest/formula-calculate.php](https://www.meta-financial.com/lessons/compound-interest/formula-calculate.php)

---

![continuously compounded interest](https://www.meta-financial.com/compound-interest/images/continously/continously-compounded-interest-formula.png)

Source: [https://www.meta-financial.com/lessons/compound-interest/continuously-compounded-interest.php](https://www.meta-financial.com/lessons/compound-interest/formula-calculate.php)

---

Depending on the formula, you provide the principal, rate, number of compoundings per year, time in years, and these functions pump out _an_ answer. Yay! Is it a correct answer? Well, between floating point math and not knowing how to calculate interest rates mentally (which is why I started this project) _I don't really know._ But that's alright.

Moving on, then...

### Compounding::Account

`Compounding::Account` lets you add credits and debits at certain times (via `#add_credit(amount, time)` and `#add_debit(amount, time)`) and calculate the balance at a point in the future.

Ex.

```ruby
account = Compounding::Account.new(apy: 1, continuous: false, annual_compoundings: 1)
account.add_credit(1000, Time.now)
account.balance_at(Time.now + Compounding::ONE_YEAR_IN_SECONDS)
#=> 2000.0000002600652
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To-do:

- [ ] Figure out what to do about `Compounding::ONE_YEAR_IN_SECONDS` because it's kind of janky
- [ ] Actually write the code that

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/briankung/compounding. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Compounding project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/briankung/compounding/blob/master/CODE_OF_CONDUCT.md).
