#!/usr/bin/env ruby

# http://www.openldap.org/faq/data/cache/347.html

# Ruby script to generate SSHA (Good for LDAP)
begin
  require 'sha1'
  require 'base64'
  require 'io/console'
rescue LoadError
end

if STDIN.respond_to?(:noecho)
  def get_password(prompt="Password: ")
    print prompt
    STDIN.noecho(&:gets).chomp
  end
else
  def get_password(prompt="Password: ")
    `read -s -p "#{prompt}" password; echo $password`.chomp
  end
end

password1 = get_password("Enter your password here   : ")
puts ''
password2 = get_password("Re-enter your password here: ")
puts ''

require 'securerandom'
salt = SecureRandom.hex

if password1 != password2
  puts "Passwords don't match!"
else
  hash = "{SSHA}"+Base64.encode64(Digest::SHA1.digest(password2+salt)+salt).chomp!
  puts hash+"\n"
end
