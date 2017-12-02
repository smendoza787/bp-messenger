class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.timestamps null: false
      t.string :body
      t.belongs_to :user, foreign_key: true
      t.belongs_to :chat, foreign_key: true
    end
  end
end
