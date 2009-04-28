require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  before(:each) do
    @status = mock('Status', :null_object => true)
    @status.stub!(:text).and_return("Here is some text")
  end

  specify "should show the default index page" do
    Status.should_receive(:find).at_least(1).times.and_return(@status)
    get '/'
    last_response.should be_ok
    last_response.should have_tag('title', /#{SiteConfig.title}/)
  end

  specify 'should show the most recent statuses' do
    Status.should_receive(:find).at_least(1).times.and_return(@status)
    get '/'
    last_response.should be_ok
    last_response.body.should have_tag('li', /#{@status.text}/, :count => 20)
  end
end
