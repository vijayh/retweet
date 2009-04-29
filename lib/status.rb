class Status < ActiveRecord::Base
  set_table_name 'status'
  ATTR_MAP = {
               :id                => :twitter_id,
               :text              => :text,
               :from_user         => :from_user_name,
               :from_user_id      => :from_user_id,
               :to_user           => :to_user_name,
               :to_user_id        => :to_user_id,
               :profile_image_url => :profile_image_url,
               :created_at        => :created_at
             }



  validates_presence_of :twitter_id, :message => "Twitter must not be blank"
  validates_presence_of :text, :message => "Text must not be blank"
  validates_presence_of :from_user_id, :message => "From user must not be blank"
  validates_presence_of :from_user_name, :message => "From user name must not be blank"
  validates_presence_of :created_at, :message => "Created at must not be blank"
  validates_uniqueness_of :twitter_id, :message => "Twitter is already taken"

  # return an array of random records (support same options as +all+)
  # ex: Status.random(10, :created_at.gte => Time.now - 86400, :limit => 100)
  def self.random(length = 10, options = {})
    arr = []
    (1..length).each do |i|
      arr << self.find(:first, :offset => rand(self.count), :order => options[:order])
    end
    return arr.first(options[:limit] || SiteConfig.status_length)
  end

  # create a new record from Twitter status data
  def self.create_from_twitter(status_data)
    s = self.new
    ATTR_MAP.each { |k,v| s.send("#{v.to_s}=", status_data.send(k)) }
    s.save
    s
  end

  # updates the local status cache from Twitter, returns number of new messages
  def self.update
    count = 0
    begin
      SiteConfig.search_keywords.each do |keyword|
        Twitter::Search.new(keyword).each do |s|
          unless self.find_by_twitter_id(s.id)
            self.create_from_twitter(s)
            count += 1
          end
        end
      end

    rescue SocketError => e
      puts e
    end

    count
  end
end
