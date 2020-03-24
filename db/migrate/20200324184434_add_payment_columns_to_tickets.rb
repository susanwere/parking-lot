class AddPaymentColumnsToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :paid, :boolean, :default => false
    add_column :tickets, :payment_time, :datetime
    add_column :tickets, :payment_option, :integer
  end
end
