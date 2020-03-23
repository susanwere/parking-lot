class Monetizeticket < ActiveRecord::Migration[5.2]
  def change
    add_monetize :tickets, :price
  end
end
