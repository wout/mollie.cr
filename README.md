<p align="center">
  <img src="https://raw.githubusercontent.com/tilishop/mollie.cr/master/img/crystal_icon.png" width="128" height="128"/>
</p>
<h1 align="center">Mollie API client for Crystal</h1>

![Example payment](https://raw.githubusercontent.com/tilishop/mollie.cr/master/img/editor.png)

Accepting [iDEAL](https://www.mollie.com/en/payments/ideal), [Bancontact](https://www.mollie.com/en/payments/bancontact), [SOFORT Banking](https://www.mollie.com/en/payments/sofort), [Creditcard](https://www.mollie.com/en/payments/credit-card), [SEPA Bank transfer](https://www.mollie.com/en/payments/bank-transfer), [SEPA Direct debit](https://www.mollie.com/en/payments/direct-debit), [PayPal](https://www.mollie.com/en/payments/paypal), [KBC/CBC Payment Button](https://www.mollie.com/en/payments/kbc-cbc), [Belfius Direct Net](https://www.mollie.com/en/payments/belfius), [paysafecard](https://www.mollie.com/en/payments/paysafecard), [ING Home’Pay](https://www.mollie.com/en/payments/ing-homepay), [Gift cards](https://www.mollie.com/en/payments/gift-cards), [EPS](https://www.mollie.com/en/payments/eps), [Giropay](https://www.mollie.com/en/payments/giropay) and [Apple Pay](https://www.mollie.com/en/payments/apple-pay) online payments without fixed monthly costs or any punishing registration procedures. Just use the Mollie API to receive payments directly on your website or easily refund transactions to your customers.

[![Build Status](https://travis-ci.org/tilishop/mollie.cr.svg?branch=master)](https://travis-ci.org/tilishop/mollie.cr)

[![GitHub version](https://badge.fury.io/gh/tilishop%2Fmollie.cr.svg)](https://badge.fury.io/gh/tilishop%2Fmollie.cr)

## Disclaimer
This is the unofficial Crystal shard for Mollie. It is directly ported from the
Ruby version ([mollie-ruby-api](https://github.com/mollie/mollie-api-ruby)) but
not an exact copy. Usage might vary from the Ruby version due to language
differences and to make the most of Crystal's type system.

## Requirements
To use the Mollie API client, the following things are required:

+ Get yourself a free [Mollie account](https://www.mollie.com/dashboard/signup). No sign up costs.
+ Create a new [Website profile](https://www.mollie.com/dashboard/settings/profiles) to generate API keys (live and test mode) and setup your webhook.
+ Now you're ready to use the Mollie API client in test mode.
+ In order to accept payments in live mode, payment methods must be activated in your account. Follow [a few of steps](https://www.mollie.nl/beheer/diensten), and let us handle the rest.

## Installation

Add mollie as a depencency to your application's `shard.yml`:

```yaml
dependencies:
  mollie:
    github: tilishop/mollie
```

Then run `shards install`.

## Usage

Configure your API key:

```crystal
Mollie.configure do |config|
  config.api_key = "test_O5GwT48772F3f3Cr0211c83341Q83F"
end
```

Create a payment:

```crystal
payment = Mollie::Payment.create({
  amount: {
    value: "10.00",
    currency: "EUR",
  },
  method:       "creditcard",
  description:  "My first API payment",
  redirect_url: "https://shop.org/order/12345",
  webhook_url:  "https://shop.org/mollie-webhook",    
})
```

## Documentation

- [Shard API Docs](https://tilishop.github.io/mollie.cr/)
- [Official Mollie API Reference](https://docs.mollie.com/reference/v2/payments-api/create-payment)

## Contributing

1. Fork it (<https://github.com/your-github-user/mollie/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [wout](https://github.com/wout) - creator and maintainer
- [tilishop](https://github.com/tilishop) - owner and maintainer

## API documentation ##

If you wish to learn more about the Mollie API, please visit the [Mollie API Documentation](https://docs.mollie.com).

## License
[BSD (Berkeley Software Distribution) License](https://opensource.org/licenses/bsd-license.php).

## Support
Mollie Contact: [www.mollie.com](https://www.mollie.com) — info@mollie.com — +31 20-612 88 55

+ [More information about iDEAL via Mollie](https://www.mollie.com/en/payments/ideal/)
+ [More information about Credit card via Mollie](https://www.mollie.com/en/payments/credit-card/)
+ [More information about Apple Pay via Mollie](https://www.mollie.com/en/payments/apple-pay/)
+ [More information about Bancontact via Mollie](https://www.mollie.com/en/payments/bancontact/)
+ [More information about SOFORT Banking via Mollie](https://www.mollie.com/en/payments/sofort/)
+ [More information about SEPA Bank transfer via Mollie](https://www.mollie.com/en/payments/bank-transfer/)
+ [More information about SEPA Direct debit via Mollie](https://www.mollie.com/en/payments/direct-debit/)
+ [More information about PayPal via Mollie](https://www.mollie.com/en/payments/paypal/)
+ [More information about KBC/CBC Payment Button via Mollie](https://www.mollie.com/en/payments/kbc-cbc/)
+ [More information about Belfius Direct Net via Mollie](https://www.mollie.com/en/payments/belfius)
+ [More information about paysafecard via Mollie](https://www.mollie.com/en/payments/paysafecard/)
+ [More information about ING Home’Pay via Mollie](https://www.mollie.com/en/payments/ing-homepay/)
+ [More information about Gift cards via Mollie](https://www.mollie.com/en/payments/gift-cards)
+ [More information about EPS via Mollie](https://www.mollie.com/en/payments/eps)
+ [More information about Giropay via Mollie](https://www.mollie.com/en/payments/giropay)