class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :uid, :provider, :first_name, :last_name, :image, :token, :secret, :access_token
  
  has_many :artists
  
  def get_and_save_rdio_artists(access_token)
    json = access_token.post('http://api.rdio.com/1/', :method => 'getArtistsInCollection').body
    artists = MultiJson.decode(json)['result']
    artists.each do |artist|
      Artist.create(:name => artist['name'], :key => artist['artistKey'], :user => self)
    end
  end
  
  def self.find_for_rdio_oauth(data, signed_in_resource=nil)
    uid = data.uid
    if user = User.where(:uid => uid).first
      user
    else # Create a user with a stub password. 
      provider = data.provider
      info = data.info
      creds = data.credentials
      User.create!(:uid => uid, 
       :provider => provider, 
       :first_name => info.first_name, 
       :last_name => info.last_name, 
       :image => info.image, 
       :token => creds.token,
       :secret => creds.secret,
       :password => Devise.friendly_token[0,20]) 
    end
  end
end
