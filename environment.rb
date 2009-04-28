require 'rubygems'

require 'haml'
require 'ostruct'
require 'twitter'

require 'activerecord'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title           => 'Your Twitter App',       # title of application
                 :author          => 'zapnap',                 # your twitter user name for attribution
                 :url_base        => 'http://localhost:4567/', # base URL for your site
                 :search_keywords => ['fubar phrase', 'fubar'], # search API keyword
                 :status_length   => 20                        # number of tweets to display
               )
  # setting up AR
  ActiveRecord::Base.establish_connection(
    :adapter => 'mysql',
    :username => 'root',
    :password => '',
    :database => 'retweet_development',
    :host => 'localhost',
    :encoding => 'utf8'
  )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end

# prevent Object#id warnings
Object.send(:undef_method, :id)
