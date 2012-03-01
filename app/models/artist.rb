class Artist < ActiveRecord::Base
  require 'open-uri'
  
  belongs_to :user
  
  validates_uniqueness_of(:user_id, :scope => [:name, :source])
  
  def self.get_and_save_sxsw_artists
    doc = Nokogiri::HTML(open('http://sxsw.com/music/shows/bands'))
    artists = doc.css('strong').each do |link|
      Artist.create(:name => link.content, :source => 'sxsw')
    end
  end
  
  def self.sxsw_artists
    Artist.where(:source => 'sxsw')
  end
end
