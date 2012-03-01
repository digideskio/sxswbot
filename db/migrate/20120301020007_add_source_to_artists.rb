class AddSourceToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :source, :string
  end
end
