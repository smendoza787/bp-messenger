class RenameNameColumnToIdentifier < ActiveRecord::Migration[5.0]
  def change
    rename_column :chats, :name, :identifier
  end
end
