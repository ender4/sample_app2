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

class User < ActiveRecord::Base
  attr_accessible :name, :email

  # special - special characters that may appear in the local_part of an
  # email address
  special = Regexp.escape('!#$%&\'*+-/=?^`{|}~')

  # word - matches a series of letters, digits and certain special characters
  # (! # $ % & ' * + - / = ? ^ _ ` { | } ~)
  word = "[\\w#{special}]+"
  
  # local_part - matches the part of an email address before the at sign (@).
  # consists of a series of letters, digits and certain special characters,
  # including one or more dots. However, dots may not appear consecutively
  # or at the start or end of the word
  local_part = "(#{word})(\\.(#{word}))*"
  
  # label - matches a string of alphanumeric characters and dashes (-). However,
  # dashes may not appear at the start or end of a label
  label = "[a-z0-9]+(\\-[a-z0-9]+)*"

  # tld - top level domain - matches top level domains, for simplicities sake
  # it will match any string of letters of length 2-4 inclusive, or the museum
  # domain as it is currently the only top level domain with more than 4 letters
  tld = "[a-z]{2,4}|museum"

  # domain - matches the part of an email address after the at sign (@).
  # valid domains are of the form label(.label)*.tld
  domain = "(#{label})(\\.(#{label}))*\\.(#{tld})"

  # email_regex - matches strings of the form local_part@domain
  #email_regex = /\A(#{local_part})@(#{domain})\z/i
  email_regex = Regexp.new( "\\A(#{local_part})@(#{domain})\\z", Regexp::IGNORECASE )

  validates :name,  :presence   => true,
                    :length     => { :maximum => 64 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :length     => { :maximum => 254 },
                    :uniqueness => { :case_sensitive => false }
  #validates validate_local_part
  
  #def validate_local_part
  #  errors.add_to_base "The local part of an email address (the part before @) may not be longer than 64 characters" if :email.to_s.split('@')[0].length > 64 unless :email.nil?
  #end
  
end
