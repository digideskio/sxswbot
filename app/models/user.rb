class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :uid, :provider, :first_name, :last_name, :image, :token, :secret, :access_token
  
  
  def self.find_for_rdio_oauth(data, signed_in_resource=nil)
    uid = data.uid
    if user = User.where(:uid => uid).first
      #response = extra.access_token.class #post('/getArtistsInCollection')
      json = data.extra.access_token.post('http://api.rdio.com/1/', :method => 'getArtistsInCollection').body
      puts '++++++++++++++ ' + MultiJson.decode(json)['result'].to_s
      user
    else # Create a user with a stub password. 
      provider = data.provider
      info = data.info
      creds = data.credentials
      extra = data.extra
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
