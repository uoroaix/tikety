class AddUserReferenceToTicket < ActiveRecord::Migration
  def change
    add_reference :tickets, :user, index: true
  end
end
