class User < ActiveRecord::Base
  has_many :addresses
  has_secure_password
end
