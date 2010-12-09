require 'spec_helper'

describe "Microposts" do

  before( :each ) do
    @user = Factory( :user )
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
      
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template( 'pages/home' )
          response.should have_selector( "div#error_explanation" )
        end.should_not change( Micropost, :count )
      end
    end
    
    describe "success" do
      
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector( "span.content", :content => content )
        end.should change( Micropost, :count ).by( 1 )
      end
    end
  end
  
  describe "micropost display count" do
    
    before( :each ) do
      #@user = Factory( :user, :email => Factory.next( :email ) )
      #visit signup_path
      #fill_in :name,         :with => @user.name
      #fill_in :email,        :with => @user.email
      #fill_in :password,     :with => @user.password
      #fill_in :confirmation, :with => @user.password
      #click_button
      @c1 = "Lorem ipsum"
      @c2 = "dolor sit amet"
    end
    
    it "should be 0 for a new user" do
      @user.microposts.length.should == 0
    end
    
    it "should be pluralized for 0" do
      visit root_path
      response.should have_selector( "span.microposts", :content => "0 microposts " )
    end
    
    it "should not be pluralized for 1" do
      visit root_path
      fill_in :micropost_content, :with => @c1
      click_button
      response.should have_selector( "span.microposts", :content => "1 micropost " )
    end
    
    it "should be pluralized for 2" do
      visit root_path
      fill_in :micropost_content, :with => @c1
      click_button
      fill_in :micropost_content, :with => @c2
      click_button
      response.should have_selector( "span.microposts", :content => "2 microposts " )
    end
  end
end
