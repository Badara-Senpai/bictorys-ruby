# Changelog


## [Unreleased]
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-09-07

- Initial release
### Added
- Initial release of **bictorys-ruby** gem.
- Supports creating a checkout/charge via `POST /pay/v1/charges`.
- Configuration with:
    - `api_key`
    - `environment` (`:sandbox` or `:live`)
    - optional `base_url` override
    - `timeout` (default 15s) and `open_timeout` (default 5s)
    - optional `logger`
- Normalized response including:
    - `checkout_url`
    - `charge_id`
    - `raw_response`
- Error handling for common cases:
    - Network/timeout errors
    - 400, 401, 404, 409, 422, and 5xx responses
- Validation of supported payment methods (`orange_money`, `wave_money`, `maxit`, `card`).

---