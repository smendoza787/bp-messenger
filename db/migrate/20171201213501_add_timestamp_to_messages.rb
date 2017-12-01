class AddTimestampToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :created_at, :timestamps
  end
end
