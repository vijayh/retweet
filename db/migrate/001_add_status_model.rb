class AddStatusModel < ActiveRecord::Migration
  def self.up
    create_table :status do |t|
      
      t.integer :id
      
      t.integer :twitter_id
      t.integer :from_user_id
      t.integer :to_user_id
      
      t.string :text
      t.string :from_user_name
      t.string :to_user_name
      t.string :profile_image_url
      
      t.datetime :created_at
      
    end

  end

  def self.down
    drop_table :status
  end
end

