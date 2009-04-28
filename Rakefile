require 'spec/rake/spectask'

task :default => :test
task :test => :spec

if !defined?(Spec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.spec_opts = ['-cfs']
  end
end

namespace :db do
  desc "Migrate the database"
  task :migrate => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end


namespace :twitter do
  desc 'Update the local status cache'
  task :update => :environment do
    count = Status.update
    puts "#{count} new status updates retrieved"
  end
end

namespace :gems do
  desc 'Install required gems'
  task :install do
    required_gems = %w{ sinatra rspec rack-test dm-core dm-validations
                        dm-aggregates haml twitter rspec_hpricot_matchers }
    required_gems.each { |required_gem| system "sudo gem install #{required_gem}" }
  end
end

task :environment do
  require 'environment'
end



