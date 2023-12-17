# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.uuid :reference, default: 'gen_random_uuid()'

      t.index :reference, unique: true

      t.timestamps
    end
  end
end
