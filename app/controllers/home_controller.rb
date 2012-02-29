class HomeController < ApplicationController
  
  def index
  end
  
  def get_rdio_artists
    #rdio = Rdio.new([Sxswbot::Application::RDIO_CONSUMER_KEY, Sxswbot::Application::RDIO_CONSUMER_SECRET], [current_user.token, current_user.secret])
    consumer = OAuth::Consumer.new(Sxswbot::Application::RDIO_CONSUMER_KEY, Sxswbot::Application::RDIO_CONSUMER_SECRET, {:site=>'http://api.rdio.com/1/'})
    access_token = current_user.access_token
    
    response = access_token.post('/getArtistsInCollection')
    puts response.inspect
  end
end