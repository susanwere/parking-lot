# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    barcode { SecureRandom.hex(8) }
    ticketedtime { Time.now.in_time_zone('GMT') }
    price_cents { 0 }
    price_currency { "EUR" }
  end
end
