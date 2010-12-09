require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task[ 'db:reset' ].invoke
    make_users
    make_microposts
    make_relationships
  end
  
  def make_users
    admin = User.create!( :name => "Example User",
                          :email => "example@railstutorial.org",
                          :password => "foobar",
                          :password_confirmation => "foobar" )
    admin.toggle!( :admin )
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!( :name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password )
    end
  end
  
  def make_microposts
    User.all( :limit => 6 ).each do |user|
      50.times do
        content = Faker::Lorem.sentence( 5 )
        user.microposts.create!( :content => content )
      end
    end
    #User.all[ 6 .. 90 ].each do |user|
    #  Random.new.rand( 1..50 ).times do
    #    content = Faker::Lorem.sentence( 5 )
    #    user.microposts.create!( :content => content )
    #  end
    #end
  end
  
  def make_relationships
    users = User.all
    user = users.first
    following = users[ 1..50 ]
    followers = users[ 25..80 ]
    following.each { |followed| user.follow!( followed ) }
    followers.each { |follower| follower.follow!( user ) }
    #users[ 1..90 ].each do |user|
    #  lower = Random.new.rand( 1..50 )
    #  upper = Random.new.rand( 51..90 )
    #  following = users[ lower..upper ]
    #  lower2 = Random.new.rand( 1..50 )
    #  upper2 = Random.new.rand( 51..90 )
    #  followers = users[ lower2..upper2 ]
    #  following.each do |followed|
    #    user.follow!( followed ) unless followed == user
    #  end
    #  followers.each do |follower|
    #    follower.follow!( user ) unless follower == user
    #  end
    #end
  end
end