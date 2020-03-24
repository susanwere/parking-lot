# frozen_string_literal: true

class Ticket < ApplicationRecord
  monetize :price_cents, with_currency: :eur
  enum payment_options: [:credit_card, :debit_card, :cash]
end
