require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new( @attr.merge( :name => "" ) )
    no_name_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 65
    long_name_user = User.new( @attr.merge( :name => long_name ) )
    long_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new( @attr.merge( :email => "" ) )
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org foo-bar@bix.com
        foo@bar-baz.net first.last@foo.jp foo@bar.museum john&kate+8@foo.bar.edu]
    addresses.each do |address|
      valid_email_user = User.new( @attr.merge( :email => address ) )
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo.@bar.com
        foo@.com foo@bar..com foo..bar@biz.com .foo@bar.com foo@bar.mkiuji]
    addresses << ("a" * 247) + "@foo.com"
    #addresses << ("a" * 65) + "@foo.com"
    addresses.each do |address|
      invalid_email_user = User.new( @attr.merge( :email => address ) )
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # put a user with given emaill address into the database
    User.create!( @attr )
    user_with_duplicate_email = User.new( @attr )
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!( @attr.merge( :email => upcased_email ) )
    user_with_duplicate_email = User.new( @attr )
    user_with_duplicate_email.should_not be_valid
  end

end
