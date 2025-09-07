# Bictorys Ruby SDK (`bictorys-ruby`)

A lightweight Ruby client for the [Bictorys](https://bictorys.com) payments API.  
Currently supports **checkout/charge creation**.

---

## Installation

Add this line to your application's Gemfile:

    gem "bictorys-ruby", git: "https://github.com/Badara-Senpai/bictorys-ruby.git"

And then execute:

    bundle install

---

## Configuration

    Bictorys.configure do |config|
      config.api_key       = ENV.fetch("BICTORYS_API_KEY")
      config.environment   = :sandbox # or :live
      config.base_url      = "..."    # optional override
      config.timeout       = 15       # seconds (default)
      config.open_timeout  = 5        # seconds (default)
      config.logger        = Logger.new($stdout) # optional
    end

---

## Usage

### Create a charge

    client = Bictorys::Client.new
    result = client.charges.create(
      amount_cents: 1000,
      currency: "XOF",
      reference: "INV-12345",
      payment_method: "wave_money",
      success_url: "https://example.com/payment/success",
      error_url: "https://example.com/payment/failure"
    )

    puts result[:checkout_url]  # redirect customer here
    puts result[:charge_id]     # store for reconciliation

---

## Supported Payment Methods

- `orange_money`
- `wave_money`
- `maxit`
- `card` (adds `payment_category=card` to the checkout URL)

---

## Errors

All SDK errors inherit from `Bictorys::Error::Base`.

- `NetworkError` – timeouts, connection failures
- `BadRequest` – 400
- `Unauthorized` – 401
- `NotFound` – 404
- `Conflict` – 409
- `Unprocessable` – 422
- `APIError` – 5xx or unknown error

Example:

    begin
      client.charges.create(...)
    rescue Bictorys::Error::Unauthorized => e
      puts "Invalid API key: #{e.message}"
    end

---

## Roadmap

- Webhook signature verification
- Refunds and payouts
- Idempotency support
- Rate-limit (429) backoff

---

## License

MIT