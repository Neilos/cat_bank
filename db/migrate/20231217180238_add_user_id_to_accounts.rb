# frozen_string_literal: true

class AddUserIdToAccounts < ActiveRecord::Migration[7.1]
  def change
    change_table :accounts do |t|
      t.references :user, null: true, index: true, foreign_key: true
    end
  end
end
