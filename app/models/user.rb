# == Schema Information
# Schema version: 20101201030243
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
  include ActiveModel::Validations

  class EmailValidator < ActiveModel::EachValidator
    def help
      Helper.instance
    end

    class Helper
      include Singleton
      include ActionView::Helpers::TextHelper

      def pluralize_no_count( count, singular, plural = nil )
        if count == 1
          return singular
        elseif plural.nil?
          return pluralize( singular )
        else
          return plural
        end        
      end
    end

    def validate_each( record, attribute, value )

      # special characters that may appear in the local_part of an email address
      special_chars = Regexp.escape('!#$%&\'*+-/=?^_`{|}~')

      # all characters that are valid  in the local part of an email address,
      # includes all alphanumeric characters and certain special characters
      # (! # $ % & ' * + - / = ? ^ _ ` { | } ~), except for dot (.)
      all_chars = "[a-z0-9#{special_chars}]"
      
      # the local part matches the part of an email address before the at sign (@).
      # consists of a series of letters, digits and certain special characters,
      # including one or more dots. However, dots may not appear consecutively
      # or at the start or end of the word
      local_part = "(#{all_chars})+(\\.(#{all_chars})+)*"
      
      # a label matches the parts of the domain of an email address that are seperated
      # by dots (.). consist of a string of alphanumeric characters and dashes (-).
      # However, dashes may not appear at the start or end of a label
      label = "[a-z0-9]+(\\-[a-z0-9]+)*"

      # the top level domain matches the charcters after the last dot (.) in an email.
      # for simplicities sake it will match any string of letters of length 2-4 inclusive,
      # or the museum domain as it is currently the only top level domain with more than
      # 4 letters
      top_level_domain = "[a-z]{2,4}|museum"

      # the domain matches the part of an email address after the at sign (@).
      # valid domains are of the form label(.label)*.tld
      domain = "(#{label})(\\.(#{label}))*\\.(#{top_level_domain})"

      # email_regex - matches strings of the form local_part@domain
      #email_regex = /\A(#{local_part})@(#{domain})\z/i
      email_regexp = Regexp.new( "\\A(#{local_part})@(#{domain})\\z", Regexp::IGNORECASE )
      if !( value =~ email_regexp )
        return record.errors[ attribute ] << ( options[ :message ] ||
          ": '#{value}' is not an email address" )  
      end
      # record.errors[ attribute ] << ( options[ :message ] || "is not an email address" ) unless
      #   value =~ email_regexp

      # the local part of an email address is limited to 64 characters or less
      local_part_length = 64
      local_part_length_regexp = /\A[^@]{0,#{local_part_length}}@/i    
      chars = help.pluralize( local_part_length, 'character' )
      record.errors[ attribute ] << ( options[ :message ] ||
        ": '#{value}' is not an email address, the part before the @ may not exceed #{chars}" ) unless
        value =~ local_part_length_regexp

      # the domain part of an email address may not have more than 127
      # labels.  126 not including the top level domain
      number_labels = 126
      number_labels_regexp = /@([^\.]+\.){1,#{number_labels}}[a-z]+\z/i
      dots = help.pluralize( number_labels, 'dot' )
      record.errors[ attribute ] << ( options[ :message ] ||
        ": '#{value}' is not an email address, the part after the @ may not have more than #{dots} (.)" ) unless
        value =~ number_labels_regexp

      # labels may not exceed 63 characters
      label_length = 63
      label_length_regexp = /@([^\.]{1,#{label_length}}\.)+[a-z]+\z/i
      chars = help.pluralize_no_count( label_length, 'character' )
      record.errors[ attribute ] << ( options[ :message ] ||
        ": '#{value}' is not an email address, the part after the @ may not have more than #{label_length} consecutive non-dot (.) characters" ) unless
        value =~ label_length_regexp

      # the full domain name may not exceed 253 characters
      domain_length = 253
      domain_length_regexp = /@.{4,#{domain_length}}\z/i
      chars = help.pluralize( domain_length, 'character' )
      record.errors[ attribute ] << ( options[ :message ] ||
        ": '#{value}' is not an email address, the part after the @ may not have more than #{chars}" ) unless
        value =~ domain_length_regexp

      # the entire email address is limited to 254 characters or less
      email_address_length = 254
      email_address_length_regexp = /\A.{0,#{email_address_length}}\z/i
      chars = help.pluralize( email_address_length, 'character')
      record.errors[ attribute ] << ( options[ :message ] ||
        ": '#{value}' is not an email address, the entire email address may not exceed #{chars}" ) unless
        value =~ email_address_length_regexp
    end
  end

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation


  validates :name,     :presence     => true,
                       :length       => { :maximum => 64 }
  validates :email,    :presence     => true,
                       :email        => true,
                       #:format       => { :with => email_regex },
                       #:length       => { :maximum => 254 },
                       :uniqueness   => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password

  # returns true if the user's password matches the submitted password
  def has_password?( submitted_password )
    encrypted_password == encrypt( submitted_password )
  end

  def self.authenticate( email, submitted_password )
    user = find_by_email( email )
    #return nil if user.nil?
    user if user.has_password?( submitted_password ) unless user.nil?
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt( password )
    end

    def encrypt( string )
      secure_hash( "#{salt}--#{string}" )
    end

    def make_salt
      secure_hash( "#{Time.now.utc}--#{password}" )
    end

    def secure_hash( string )
      Digest::SHA2.hexdigest( string )
    end
  
end
