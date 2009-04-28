require 'rubygems'
require 'sinatra'
require 'environment'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  def highlight(text)
    SiteConfig.search_keywords.each do |keyword|
      text = text.gsub(/(#{keyword})/i, '<span class="highlight">\1</span>')
    end
    activate_links(text)
  end

  def activate_links(text)
    text.gsub(/((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/, '<a href="\1">\1</a>'). \
      gsub(/@(\w+)/, '<a href="http://twitter.com/\1">@\1</a>')
  end

  def profile_link(user_name)
    "<a href=\"http://twitter.com/#{user_name}\">#{user_name}</a>"
  end
end

# root page
get '/' do 
  @statuses = []
  # this is messy, but unfortunately AR doesn't appear to have a random find method
  # TODO: this needs to be refactored into the random method on Status
  (1..SiteConfig.status_length).each do |i|
    @statuses << Status.find(:first, :offset => rand(Status.count))
  end
  @statuses.sort!{|x,y| y.created_at <=> x.created_at }
  
  haml :main
end
