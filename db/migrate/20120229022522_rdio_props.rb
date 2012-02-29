class RdioProps < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :image, :string
    add_column :users, :token, :string
    add_column :users, :secret, :string
    add_column :users, :uid, :string
  end
end