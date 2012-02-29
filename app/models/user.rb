class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :uid, :provider, :first_name, :last_name, :image, :token, :secret, :access_token
  
  
  def self.find_for_rdio_oauth(access_token, signed_in_resource=nil)
    uid = access_token.uid
    if user = User.where(:uid => uid).first
      #response = extra.access_token.class #post('/getArtistsInCollection')
      r = access_token.extra.access_token.post('/getArtistsInCollection')
      puts '++++++++++++++ ' + r.inspect
      user
    else # Create a user with a stub password. 
      provider = access_token.provider
      info = access_token.info
      creds = access_token.credentials
      extra = access_token.extra
      User.create!(:uid => uid, 
       :provider => provider, 
       :first_name => info.first_name, 
       :last_name => info.last_name, 
       :image => info.image, 
       :token => creds.token,
       :secret => creds.secret,
       :access_token => extra.access_token,
       :password => Devise.friendly_token[0,20]) 
    end
  end
end
