FactoryBot.define do
  factory :ticket do
    barcode { SecureRandom.hex(8) }
    ticketedtime { Time.now() }
  end
end