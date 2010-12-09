require 'spec_helper'

describe "Pages" do
    
  describe "GET 'home'" do
  
    describe "for signed-in users" do
      
      before( :each ) do
        @user = Factory( :user )
        integration_sign_in( @user )
        29.times do
          Factory( :micropost, :user => @user, :content => Faker::Lorem.sentence( 5 ) )  
        end
        @mp1 = Factory( :micropost, :user => @user, :content => "Foo bar" )
        @mp2 = Factory( :micropost, :user => @user, :content => "Baz quux" )
      end
      
      it "should show the user's micropost feed" do
        visit root_path
        response.should have_selector( "span.content", :content => @mp1.content )
        response.should have_selector( "span.content", :content => @mp2.content )
      end
      
      it "should paginate the user's micropost feed" do
        visit root_path
        response.should have_selector( "div.pagination" )
        response.should have_selector( "span.disabled", :content => "Previous" )
        response.should have_selector( "a", :href => "/?page=2",
                                            :content => "2" )
        response.should have_selector( "a", :href => "/?page=2",
                                            :content => "Next" )
      end
      
      it "should show delete links for user's microposts" do
        #visit root_path
        #response.should have_selector( ".delete" )
      end

      it "should not show delete links for other user's microposts" do
        #@attr = { :email => "example-9@railstutorial.org",
        #          :password => "password-9",
        #          :password_confirmation => "password-9" }
        #wrong_user = Factory( :user, @attr )
        #integration_sign_in( wrong_user )
        #get :show, :id => @user
        #response.should_not have_selector( ".delete" )
      end
    end
  end
end
