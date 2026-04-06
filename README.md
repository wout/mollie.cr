<p align="center"> <img src="https://github.com/wout/mollie.cr/blob/main/assets/mollie_crystal_logo.png" width="128" height="128"/>
</p>
<h1 align="center">Mollie API client for Crystal</h1>

![Example payment](https://github.com/wout/mollie.cr/blob/main/assets/example.png)

Accepting [iDEAL](https://www.mollie.com/en/payments/ideal), [Bancontact](https://www.mollie.com/en/payments/bancontact), [Creditcard](https://www.mollie.com/en/payments/credit-card), [SEPA Bank transfer](https://www.mollie.com/en/payments/bank-transfer), [SEPA Direct debit](https://www.mollie.com/en/payments/direct-debit), [PayPal](https://www.mollie.com/en/payments/paypal), [KBC/CBC](https://www.mollie.com/en/payments/kbc-cbc), [Belfius](https://www.mollie.com/en/payments/belfius), [paysafecard](https://www.mollie.com/en/payments/paysafecard), [Gift cards](https://www.mollie.com/en/payments/gift-cards), [EPS](https://www.mollie.com/en/payments/eps), [Apple Pay](https://www.mollie.com/en/payments/apple-pay), [Klarna](https://www.mollie.com/en/payments/klarna), [in3](https://www.mollie.com/en/payments/in3), [Trustly](https://www.mollie.com/en/payments/trustly), [Riverty](https://www.mollie.com/en/payments/riverty), [Przelewy24](https://www.mollie.com/en/payments/przelewy24), [TWINT](https://www.mollie.com/en/payments/twint), [Blik](https://www.mollie.com/en/payments/blik) and [more](https://www.mollie.com/en/payments) online payments without fixed monthly costs or any punishing registration procedures. Just use the Mollie API to receive payments directly on your website or easily refund transactions to your customers.

![GitHub](https://img.shields.io/github/license/wout/mollie.cr)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/wout/mollie.cr)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/wout/mollie.cr/ci.yml?branch=main)

## Disclaimer
This is the unofficial [Crystal](https://crystal-lang.org/) shard for Mollie.
It's directly ported from the Ruby version
([mollie-ruby-api](https://github.com/mollie/mollie-api-ruby)) but not an exact
copy. Usage may vary from the Ruby version due to language differences and to
make the most of Crystal's type system.

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
    github: wout/mollie.cr
```

Then run `shards install`.

## Usage

Create an initializer and add the following line:

```crystal
Mollie.configure do |config|
  config.api_key = ENV["MOLLIE_API_KEY"]
end
```

You can also include a client instance in each request you make:

```crystal
Mollie::Payment.get("pay-id", client: Mollie::Client.new("<your-api-key>"))
```

If you need to do multiple calls with the same API Key, use the following helper:

```crystal
Mollie::Client.with_api_key("<your-api-key>") do |mollie|
  mandates = mollie.customer_mandate.all({ customer_id: "customer-id" })

  return if mandates.empty? 
  
  payment = mollie.payment.create({
    amount: {
      value:    "10.00",
      currency: "EUR",
    },
    method:       "creditcard",
    description:  "My first API payment",
    redirect_url: "https://webshop.example.org/order/12345/",
    webhook_url:  "https://webshop.example.org/mollie-webhook/",
  })
end
```

### Creating a new payment

```crystal
payment = Mollie::Payment.create({
  amount: {
    value:    "10.00",
    currency: "EUR",
  },
  method:       "creditcard",
  description:  "My first API payment",
  redirect_url: "https://shop.org/order/12345",
  webhook_url:  "https://shop.org/mollie-webhook",    
})
```
*Note: Make sure to send the right amount of decimals and omit the thousands
separator. Non-string values are not accepted.*

To ensure amount values always carry the correct amount of decimals, an instance
of `Mollie::Amount` can be passed, which accepts integers, floats and strings:

```crystal
payment = Mollie::Payment.create({
  amount:       Mollie::Amount.new(10, "EUR"),
  method:       "creditcard",
  description:  "My first API payment",
})
```

### Retrieving a payment

```crystal
payment = Mollie::Payment.get("pay-id")

puts "Payment received." if payment.paid?
```

### Refunding payments

The API also supports refunding payments. Note that there is no confirmation and
that all refunds are immediate and definitive. Refunds are only supported for
[certain payment methods](https://help.mollie.com/hc/en-us/articles/115000014489-How-do-I-refund-a-payment-to-one-of-my-consumers-).

```crystal
payment = Mollie::Payment.get("pay-id")
refund = payment.refund!({
  amount: {
    value: "10.00",
    currency: "EUR"
  }
})
```

### Pagination

Fetching all objects of a resource can be convenient. At the same time,
returning too many objects at once can be unpractical from a performance
perspective. Doing so might be too much work for the Mollie API to generate, or
for your website to process. The maximum number of objects returned is 250.

For this reason the Mollie API only returns a subset of the requested set of
objects. In other words, the Mollie API chops the result of a certain API method
call into pages you’re able to programmatically scroll through.

```crystal
payments = Mollie::Payment.all
payments.next
payments.previous
```

## Documentation

- [Shard API Docs](https://wout.github.io/mollie.cr/)
- [Official Mollie API Reference](https://docs.mollie.com/reference/v2/payments-api/create-payment)

## Contributing

1. Fork it (<https://github.com/wout/mollie.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [wout](https://github.com/wout) - creator and maintainer

## License
[BSD (Berkeley Software Distribution) License](https://opensource.org/licenses/bsd-license.php).

## Support
Mollie Contact: [www.mollie.com](https://www.mollie.com) — info@mollie.com

+ [All payment methods](https://www.mollie.com/en/payments)
+ [Mollie API documentation](https://docs.mollie.com/)
