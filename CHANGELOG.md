# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-04-06

### Added
- New resources: `Terminal`, `PaymentLink`, `Balance`, `Balance::Report`,
  `Balance::Transaction`, `Partner`, `Payment::Line`, `Order::Payment`
- Payment: `amount_charged_back`, `cancel_url`, `lines` fields
- Order: `amount_captured`, `amount_refunded`, `cancel_url`, `webhook_url`,
  `expired_at`, `paid_at`, `authorized_at`, `canceled_at`, `completed_at`
  fields; `cancelable?`, `payments()`, `shipments()` methods
- Organization: `locale`, `vat_regulation` fields; `self.current()` method
- Profile: `business_category` field
- Settlement: `invoice_id` field; `chargebacks()`, `invoice()` methods
- Method: `issuers`, `status` fields; `Issuer` struct; `all_available()` method;
  `BancomatPay`, `Klarna` enum values
- Payment method enum: Alma, Bancolombia, Billie, Blik, In3, MyBank, Payconiq,
  Riverty, Satispay, Trustly, Twint
- `State.clear` method for cleaning up stored client instances
- Sandbox entries for all new resources

### Changed
- Renamed exception classes: `Exception` → `Error`, `RequestException` →
  `RequestError`, `ResourceNotFoundException` → `ResourceNotFoundError`,
  `MissingApiKeyException` → `MissingApiKeyError`,
  `RequestTimeoutException` → `RequestTimeoutError`,
  `MethodNotSupportedException` → `MethodNotSupportedError`
- Use system CA certificate store instead of bundled `cacert.pem`
- `Amount#to_json` now respects currency-specific decimal places (e.g. JPY uses
  0 decimals)
- `Underscorer` now handles `Bool`, `Int`, and `Float` JSON values in addition
  to strings
- Bumped minimum Crystal version to `>= 1.14.0`
- Updated `wordsmith` dependency to `~> 0.5`
- Pinned `webmock` dependency to `~> 0.14.0` (was `branch: master`)
- Updated GitHub Actions to v4
- Order: `method`, `expires_at`, `consumer_date_of_birth` are now nilable
- Profile: `category_code` is now nilable

### Removed
- Bundled `cacert.pem` file (using system certificates)
- Redundant nil check in `Client#initialize`

## [1.6.1] - 2025-10-03

### Changed
- Removed guardian dependency
- Code style fixes

## [1.6.0] - 2024-04-19

### Fixed
- Use `Time::Span` for timeout settings

## [1.5.0] - 2024-02-11

### Changed
- Converted Mollie namespace from struct to module
- Simplified version management
- Upgraded ameba

### Fixed
- Code formatting issues

## [1.4.2] - 2022-10-15

### Changed
- Locked minimum Crystal version to 1.4

## [1.4.1] - 2022-10-15

### Changed
- Ensured compatibility with all Crystal v1+ versions

## [1.4.0] - 2021-10-31

### Fixed
- Moved config reference to current fiber for thread safety

## [1.3.3] - 2021-08-03

### Changed
- Moved repository to personal account

## [1.3.2] - 2021-07-31

### Fixed
- `Mollie::Amount` compatibility with older Crystal versions

## [1.3.1] - 2021-07-29

### Fixed
- Backwards compatibility for Crystal 1.0.0
- Cleaned up util module

## [1.3.0] - 2021-07-29

### Changed
- Updated to Crystal 1.0.0
- Removed Travis CI in favor of GitHub Actions

### Fixed
- Use ties-away rounding mode for consistency with the Ruby gem

## [1.2.6] - 2020-06-10

### Changed
- Updated to Crystal v0.35.0

## [1.2.5] - 2020-05-11

### Changed
- Prepared for deprecation of `JSON.mapping` in Crystal v0.35.0

## [1.2.4] - 2020-05-11

### Added
- Settlement: captures helper method
- Organization: dashboard URL helper method

### Changed
- Settlement: moved `invoice_id` to period, added dedicated `Period` struct

## [1.2.3] - 2020-05-03

### Changed
- Updated dev dependencies

## [1.2.2] - 2020-04-29

### Fixed
- Client error handling bug

## [1.2.1] - 2020-03-17

### Added
- Configurable decimal numbers per currency

## [1.2.0] - 2020-03-11

### Added
- Client sandbox for calls with a specific API key

## [1.1.0] - 2020-03-11

### Added
- Missing relation methods to payment

## [1.0.2] - 2020-03-11

### Changed
- Moved aliases to Mollie namespace

## [1.0.1] - 2020-03-11

### Changed
- Better error messages for API exceptions

## [1.0.0] - 2020-03-10

### Added
- Initial release with full Mollie API v2 coverage
- Payment, Customer, Order, Subscription, Refund, Chargeback, Capture,
  Invoice, Profile, Settlement, Organization, Onboarding, Permission, Method
- Client with API key management and sandbox mode
- Pagination support with `next`/`previous`
- Fiber-safe configuration
